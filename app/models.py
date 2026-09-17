import uuid
from datetime import datetime, timezone
from pydantic import BaseModel, Field, field_validator


class IdeaCreate(BaseModel):
    idea: str = Field(..., min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=2000)

    @field_validator("idea")
    @classmethod
    def not_blank(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("idea must not be blank")
        return v


class Idea(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    idea: str
    description: str | None = None
    created_at: str = Field(
        default_factory=lambda: datetime.now(timezone.utc).isoformat()
    )

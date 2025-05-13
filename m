Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8D623957D;
	Tue, 13 May 2025 09:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747129367; cv=none; b=JUaAyp3dGE70np+YsjpSgBG/WnbCggzNVtgw4vbdwuLdbJMs0XY6FQInwXuGDLhk7fxNA58pzxRjcmXrBtrsHtaVZJ0qEA3Emp08oTQBSwVXz6MDgd/SIG39/X6fpZqwoyIVVr9SfpA4FY0N+4VOQtmJFz6lkRW14TLQxtdtzQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747129367; c=relaxed/simple;
	bh=voImH08ceWASipDZx0JT6UoRg/umXIqv96hJuk2ZoIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DM2da/c71OJ1Rvr6zTtG8c+eKKeZXOmXdUh0mzIPQ6+y+NLO1KjJFfSqE1Ex+o1HDjprxM2i1FjNVz/NQx7UqSNdVuEh2KNe9pWqnhOLjMsYvDPkmjT2fyo5RfbsJkBbbX63JUFdN+yCTVTs7QstoBM6wKcayULyApnhHBH8mso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPly17IZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPly17IZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789D1C4CEE4;
	Tue, 13 May 2025 09:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747129366;
	bh=voImH08ceWASipDZx0JT6UoRg/umXIqv96hJuk2ZoIg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PPly17IZebiIES6CfyLl9R0DoBModaujtVLWuZVNkUHb//0u/cIyiS3wPvx/LyCKe
	 1/Vu9Uv4PgQD0M4obzONLlgEHHWjcT4ZliE6utv49K8YGMHT4X6KvTtEybg0qNAf+F
	 dw7fQyR0/oBsKL3nTgm7TYwyWdpmbzsWQlGu6JxYOjRx6dNktfjuZG+IULOKc+DuIa
	 nz6KWV8RMCpJQYGOa4+8F89UXjsFRMVv/GdvZWO5+ucnDcePCip/03qKCnQWWGc0bD
	 RaLz5DUV15towaXsFMHIz1MbHVBcK7ZQ+gCKEekRu3Z39A/x41c/d71nCIjKQxPk09
	 kNo3FoAReJqzA==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-326c1f3655eso41565891fa.1;
        Tue, 13 May 2025 02:42:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWelOAc5gYKH8tyBpWiSse+c11IFsWJjKcG1Jn+YFLvAZ1pYxtM4Okzndlahc/zXRtoet2+kOgRF3mPZlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS1W88phL5gJcMEfgcTYczAaHF+czQBfNXfvZViktLSFkbTON+
	zrVHyBoBVXoklKrqG6jw2dNOvQsOup/yknMRQbHRY5LZHbkANMApx4zkfnH6Pmuca3gCo8jJSb6
	fWJQW5FDG27qsZ1VN8zs7ZOnUrdU=
X-Google-Smtp-Source: AGHT+IFD6j1C5tKbtO724hL+I6M1AcwsOqMV6s7nR4IP2n5/vXsDfOQgumoLSWXTbao69qSBzjHB2PYT2z1fNEspzTU=
X-Received: by 2002:a05:651c:b14:b0:30c:b2c:edb6 with SMTP id
 38308e7fff4ca-326c45902fbmr53014191fa.18.1747129364888; Tue, 13 May 2025
 02:42:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513022115.39109-1-ebiggers@kernel.org>
In-Reply-To: <20250513022115.39109-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 13 May 2025 10:42:32 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG3p98HX6HtPmm48D2fc=46WuVBTYfZiykszWRDQ85Abg@mail.gmail.com>
X-Gm-Features: AX0GCFukPEDav3-AdX_4_4b3b9R3F_XW9w91H_FYC0QO7qXP6vIvhj1fwlc1JOs
Message-ID: <CAMj1kXG3p98HX6HtPmm48D2fc=46WuVBTYfZiykszWRDQ85Abg@mail.gmail.com>
Subject: Re: [PATCH 0/2] lib/crc16: unexport crc16_table and crc16_byte()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Krzysztof Kozlowski <krzk@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 May 2025 at 03:22, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series removes the only caller of crc16_byte() outside lib/crc16.c,
> then folds crc16_table and crc16_byte() into lib/crc16.c.  I'm planning
> to apply this to the crc tree.
>
> Eric Biggers (2):
>   w1: ds2406: use crc16() instead of crc16_byte() loop
>   lib/crc16: unexport crc16_table and crc16_byte()
>
>  drivers/w1/slaves/w1_ds2406.c | 12 ++----------
>  include/linux/crc16.h         |  9 +--------
>  lib/crc16.c                   |  9 ++++-----
>  3 files changed, 7 insertions(+), 23 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

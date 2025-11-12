Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DBC29ACD7
	for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 20:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762978338; cv=none; b=YvOOzMRhoSKcxoW+gVJl3qQSDW2UkNmNXX+iECqEqMAtqdkqZStf55A6KcRMx8rLmft4CiCxejB+yJ1tpAm50SPRfi3Q4mscpZQ/bKsavIRk8UJeXoaz80UrquU2k7UEoiOU/nT0vWyw+Ccz8JbRRx16Pj+mCda5PFckVzzZ5/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762978338; c=relaxed/simple;
	bh=gsP4RuV0SX74Q4sn2qalh8C+3yPvQoVzq/xVfun11BQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ITd4DZbUX02M2IH6jnEQeojh/5tOFOhFwnErItKEr8Y48xjv5VhHhjw4Ttc3K6qT9qwRLRc8FreLuyswvhFIvVHwxhzjW4mj7yWoVU5y6IU5yYJpGvOFFtn87I9P0lGsAAQSUwBJhW8jsriQFD35NCLGhu4prRKF5Z2GDjOnhTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org; spf=pass smtp.mailfrom=networkplumber.org; dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b=ujCFF9vV; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b="ujCFF9vV"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b80fed1505so15106b3a.3
        for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 12:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20230601.gappssmtp.com; s=20230601; t=1762978336; x=1763583136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gsP4RuV0SX74Q4sn2qalh8C+3yPvQoVzq/xVfun11BQ=;
        b=ujCFF9vVRnLXzvMS2k3iAG8SDEEJO5uSSvMq6Esy8L5kuhwMHCaOZFqZZ4qtAIUy1d
         XQ44qIYBcNuxiyQaIUFIZ6GjH5pWkxSjWTOg96GlX+cz7yS9iQ5szPdiD74Xccj1mZQr
         50W6mg62KC7dH2JGkSwXBA1vpVi4pEw6t9QrQzbJEs5WvNZ0UDBx2OUgb7Mt7XPJuIya
         y3farylFxhsdp9NHRhQyljRBhHH09c/B44PWG/kXG6MaEJRZOJImesuFbni2tXeQVeLU
         X1SR6hyYhRZKP76LN5coM6vSBCScVuoSZzCiqP1wjRufdbyQkLToFe7X7ACvKFDWdMnj
         UWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762978336; x=1763583136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gsP4RuV0SX74Q4sn2qalh8C+3yPvQoVzq/xVfun11BQ=;
        b=NPUsoJnkT4yNaiBKyI9SPTuS04UpuBmak+utLgK5RMU7fPEwE5HxkaYKwoCRg3sLwm
         6/3C3hwOOHXPUVK4RAalS6KNOWTVpqTrMtcWcf7EbDNxE2ZxCouV/2a/UHFqxMUqSdEt
         nU55fCsaz42A2zRQvciQ9GPFyZY1UYSCurQ4rCdkPs0A/jwOnYdi88Fb0t1PdhVrYwd2
         4ImpAy3IG5cIQGyP9K0KO4wVFfNRvt8tW1419g241isO1/fcLY8kI3LeQDvBtxw7JtXu
         BRxKbGObHj4qBm2yABOt21Vl8u4qFCERG1fqFtnXW4aN8whS73k62y1JlQbZD/dGeU3C
         /6Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXbvznBOyVWIYjvu+n0z8YOB18daaCiD/bP77e7VLQksQqyvXMgswjADcgF+SC9PbjRJbrCE9pg0BraBaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyEs9k3qC0Iq8BtsMDYGx52uJBJ50Hrdz3dIvYZKlitgszuSbD
	tq95H/7fY9FVkgZH65dato+gqUl6Ew8Wc4FTfVN/E1qlF9wxCD62js3OIusiDFUv9gU=
X-Gm-Gg: ASbGncvXT67hy88nRPj/L5Dl5RFErv0MjRCjvXO0kgUi4+r2+/qIbxKELlxlLJd5hvI
	uBkMsR4EZP39504NTYexxvX2NBFZYlFaeyLuAspi7FoGn7ughb5LzyIdnKloM50rz5cI+66g+sa
	jHVVo8jaEiM6mPrtp9Esaw1ICht5uOtU+g06GvrJrXZqxvCOM45yUYnmGaSh6SJ5dBEEGQEvJ6l
	mS/tFFxdAN35Lutd3ZabXwwwmkQmEurY4hUeUkbiLUJ04pBbxicpoNOjQDo1P010CqIecWxlgrG
	DI+Yv8gOo6J10pDkoSWBcyqE4RoqMdSIfq7q/A143xi4VEdAZx94VQ3+VGAwaX4rOlEKM8ELuiq
	SFIDOxioxF4fv8IN4T8YogL65LA4yV2NaMvH+PRzBVw2TilJ1PZb775bOl6HlYZL4xBP6diOCMW
	4MhaVFtKTupzK/s43IMhc7THGX1S1RAsi93A==
X-Google-Smtp-Source: AGHT+IG0T8LAB89N+NLBKJi4tziCPLU6tUuh6eDgoooLFm7itDIrTgHFde48cWwu0NOkAzvIltUARQ==
X-Received: by 2002:a05:6a00:4616:b0:7a9:f465:f25 with SMTP id d2e1a72fcca58-7b7a52c74b9mr4620225b3a.27.1762978335682;
        Wed, 12 Nov 2025 12:12:15 -0800 (PST)
Received: from phoenix (204-195-96-226.wavecable.com. [204.195.96.226])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c9ff8538sm19700242b3a.28.2025.11.12.12.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 12:12:15 -0800 (PST)
Date: Wed, 12 Nov 2025 12:12:12 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, bpf@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH iproute2-next v2] lib/bpf_legacy: Use userspace SHA-1
 code instead of AF_ALG
Message-ID: <20251112121212.66e15a2d@phoenix>
In-Reply-To: <20250929194648.145585-1-ebiggers@kernel.org>
References: <20250929194648.145585-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Sep 2025 12:46:48 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> diff --git a/lib/sha1.c b/lib/sha1.c
> new file mode 100644
> index 00000000..1aa8fd83
> --- /dev/null
> +++ b/lib/sha1.c
> @@ -0,0 +1,108 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * SHA-1 message digest algorithm
> + *
> + * Copyright 2025 Google LLC
> + */

Not a big fan of having actual crypto in iproute2.
It creates even more technical debt.
Is there another crypto library that could be used?


Better yet, is there a reason legacy BPF code needs to still exist
in current iproute2? When was the cut over.

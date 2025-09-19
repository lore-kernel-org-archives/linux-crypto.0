Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB135257855
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758294353; cv=none; b=LJuZxYugvZ+k1rGiHoz8SOngfQO1PhIXSQgDZ/kL19uk97bvv9ssc51BSaUdF4ATSQfsPIiSKwJrJlXh/LsSw+UNJZag1mANGVaxraWBczBK1D01JNOELgnUiFlWVExfzxHVpMYhmlesijLmRkMmWbJoANQGlJrPmGLN4BrW6U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758294353; c=relaxed/simple;
	bh=WMftwkU9XX4Xic2+f1rWthYmYDHMbq9eC2vVc+iw4Gs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D1FWhDZckJ1ueGCvVOsJPnyhhi6JNGiKSbCBp1xrZtIR95kwcrJ6/o2nzZRFdCiuNGQx+G7/Rl/M08rstKJERWTmtn7aypZmQS5lEFa3x2xCCSFkR+Ko1UueqpxN+gmg9CGwr3LhUoAFP8I0iWGQFwB1wIjUwWXwY80nvW5wWzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zGiRtqVv; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zGiRtqVv"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-77dd76f6964so32026836d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294350; x=1758899150; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALVFhndHULwyH6PXNjxWdCUnJjL9si5BK+FmNKNwS8Y=;
        b=zGiRtqVviWJDqq5onqQFaUT4flGvNKLkzw8B4KqAcLoi/OyuAwoO3afNvEKf5qQcsk
         lpp+MZFH8MQZiZchtm+y6nRD2lueMAhJ6/t4mTv27veproY97aYIBAzDURje3f7qG6Ob
         K70JI9cZZMDzCovaktCcq5JDrarvFDwsHrgjL3KrGTE6cJKvfo+dHN4otClocii4YYMU
         r1YDXi0PrTPs26AKRIT/lUd/XXNkZaQgDEAdA3tq4K0c10swQECdwCC9OXk2SYcTAkl6
         IQU9FSqcVJpsSnHhwFPe/qcKodpx1B0nF+aFsw9gn84IPrbuHh1NnboqgfjfyQudUrEM
         XjaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294350; x=1758899150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ALVFhndHULwyH6PXNjxWdCUnJjL9si5BK+FmNKNwS8Y=;
        b=qSmUX+iCrfqfzVgcyBmFEvpAo+ok4o4eGnLdJc/5YBAbT5EbuMb+DYTyZWKPSaN/yn
         qpWf0J75L1BpFXW4Ty+MnfBMYH54Bxb/W+zJVhf3xAAyz7b/BXSw+gTP3AFwHgbWv5rH
         EN2mmGxCj+hx0MSf4w27yuXqHfsuBrPzl+BXKyPlychr+87GGJBBzc0Y7XA5bhfEVA4A
         AzdvJypfTylFZPje2fEqPl7u0hPGC5P6CnThqcD8n8YBnRnt6ccDdSHMuAfbhVzbXjmM
         89doWbiVpumTwdhHxU/3+7zS/sekO9YTGpt5cBZ8DcL15O35im4ZoKPnunE1gZDI+mDy
         e6MA==
X-Forwarded-Encrypted: i=1; AJvYcCWbHYYDRtk0ElQnn3+63YwxLLiw3QjCs7rxijFZFznJT6Z56HvMAyxc9pYkziF9H6FFOud2dXTQUOhFrHs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX7E2RKcMHAzZVqj+3qyoyGW9Z3U5BR05oxDu6IutA1zBxM3Fa
	Lt/koxX6/CzaH/S5ciBEFj+Mc1bCDimzoUsnLtDNlGlYDZtz6obF45Zxo4ZG1kC1Sc8uAa+wLNK
	apIiLLBW/7jqcNm0I+V5iyaxN2lW1IDrsrVtEw2Jb
X-Gm-Gg: ASbGncv8MEyPfwaTRikp8HMsMjvkTyqoQrbXhIilxyPfRUXosWuLJxjKWu/itepcVhT
	xszJrUjFUPhMTJ+umFx9Zi6A9/7hPsJlULhkVIRmu1CG32iSHECMGeEyWifD1qGOkBOb7hzQPdS
	TF1AzjKkzWw4fwKl23m03KeIyahE6WbTXiend71gbwwhqyQweCXDpSEAUdwo1kKt6WwfnjatY1I
	yUcaBXc2V4wyW1W9HgKzza/X61EiipJ+9/xTg==
X-Google-Smtp-Source: AGHT+IEVqq7kGd48eq4ZHSpETd+85Yxiw1HuwZsyw3lMLRQhSxxE8PumVmG7OCruoad9bvUz5MihV7lV49oxp9BNi0o=
X-Received: by 2002:ad4:4f4d:0:b0:799:59d0:4e54 with SMTP id
 6a1803df08f44-79959d04f7dmr32751596d6.31.1758294349954; Fri, 19 Sep 2025
 08:05:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:05:13 +0200
X-Gm-Features: AS18NWD-UemVXeXjYD7iHT8a4re1Qj02r-S9mCoMAicLgtJfaZDLOjotbdftD6k
Message-ID: <CAG_fn=ULHR_n+w=apc_g8Pe+MxXwNnQiRjOTRukzEiSAFK7hOQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add the foundational user-facing components for the KFuzzTest framework.
> This includes the main API header <linux/kfuzztest.h>, the Kconfig
> option to enable the feature, and the required linker script changes
> which introduce three new ELF sections in vmlinux.
>
> Note that KFuzzTest is intended strictly for debug builds only, and
> should never be enabled in a production build. The fact that it exposes
> internal kernel functions and state directly to userspace may constitute
> a serious security vulnerability if used for any reason other than
> testing.
>
> The header defines:
> - The FUZZ_TEST() macro for creating test targets.
> - The data structures required for the binary serialization format,
>   which allows passing complex inputs from userspace.
> - The metadata structures for test targets, constraints and annotations,
>   which are placed in dedicated ELF sections (.kfuzztest_*) for
>   discovery.
>
> This patch only adds the public interface and build integration; no
> runtime logic is included.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

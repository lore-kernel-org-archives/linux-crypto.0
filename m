Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6F834F255
	for <linux-crypto@vger.kernel.org>; Sun, 30 Aug 2026 23:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788131182; cv=none; b=UYtFs8dYebtmrfbqgRA1+5+JF4eMXKYuey/P2EQvzZ3wQ1DAGzByt3YygE7xHWeDYpiBUYlJ//0Xq8tzABe4erlIiiVaYp4Smdz7c4zUy7qke0fHalIKdE0HtD7WH64QE4cZR5Co2aypqpjH6ZvfhMrhIXELqPHTHyXC18Rl6Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788131182; c=relaxed/simple;
	bh=rL4yxxYKKG4TIDB9CU1E4ZNOHQlWPM2opU9VJ6JG+zk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pl8Tr+BrEguwjftDvenolMN5NDRA7wWRr8YTFeVGwDsppn5NmvW7cFvb+a78/S2Z6PYYeovvqVcLVbsVSqUoacpD34BQ8JBS5geUkF4yLnlJC1djx9pNW7XemqYef82Zde3O/HVrqmEs4ctyFfyZe2qVCZsD3hWZwxpTasHonS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WV5SvS8M; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WV5SvS8M"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2055573c8cso357441066b.3
        for <linux-crypto@vger.kernel.org>; Sun, 30 Aug 2026 16:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1788131179; x=1788735979; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kchg3SI0pR13iwu/DkltwTxRLDpJHhH3QJUlMk6iCEU=;
        b=WV5SvS8Mz8hO5rcVjwC2X5G8fT+pYcs9JuEvCrdLs+uEUEEpfgq70InuKeBkiUD827
         ANuxNMpwSyfume606XpusziFiKig8bwFCFetTHncuxf/KweDZjlEEMOiajEG29mo2Vrl
         9hjEKg7GTGF59XhF31bDaSD2Yqx4332SFLfRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788131179; x=1788735979;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kchg3SI0pR13iwu/DkltwTxRLDpJHhH3QJUlMk6iCEU=;
        b=F95+9FfuW5i15LQyPvDjKthuMpAnob+iv04qnycwaXYM2Z4laucgFzQSJd/oMJZaw0
         FoIsSgUZLWbkmSJVWD51TOTW92B/w9rPEdIg301y5eEq7rU5Fp+fPPXQ/SNxZ7hDbyi+
         gwDY8kvRDyYYcRQVT+hbkmYqibfP0ztcNdS1PSZqMYTt3h1d3NqIRusrVTE8UC0tzbDs
         71txLkmUqiBWndrDIsdQU0UL0Ww1zO12U1hlY4oU8Us6YgkMEacFlOCBMdLyClCwms0O
         b1ctdq6XS0y/u6El8YSbW2sjsoPQ/U17dRID206pxTdfWvjlun8nMdaGYwRLO1VpF5e2
         1YrA==
X-Forwarded-Encrypted: i=1; AHgh+RoDQOx2cxwjCxMH1K4I1EKEuNYIYtA1dlaZMROeBFpiLamwpZPSZo/1qKgLC2PJOGi2QtvIlzPh7aDjWxo=@vger.kernel.org
X-Gm-Message-State: AFuF++k6hJuVMAP3ph9UkgAX0gJYzUO0qAcWlTh2ZBZ9CvNGxP/Ybti7
	ejfIV4/rtYo1LNzPwYYivTs2opUXCJdPJSx699AnvqNZ9Q8fozXvOuUMqt3+TeRYMxYF4CoBloh
	ZFSKnqfQ=
X-Gm-Gg: AR+sD12ZU3RDftBSczypXFjq7wxrqrrJOO4YouHWyydKfgM7a2SVhv4w5vqUUdIX0FE
	E+MtJTiyI9ZI+nBuXNXkxJcuOTLGFGx5/ZR/6O0tfLl+AMmyElsP56f88iLyEJzHBx+ELOkcP0G
	n4wcj0K9lBlAiW3uPWAsJyDoqLpS/94r4qmeNCzpsrdUQKCHpwmPhWszoEaGxI3yA8frBB6X5hA
	kC7CjcErcu4met2Zj5cuDQZjEU+AJRTklUaDUNbrRXA4ZXD2KRuYupQImkRRMo9jk4tq/xyT0vF
	4k/IKGDgpvO3S3PCuYD4MWPQm1xbptwIVoNqR0m3+DZisA37Ngw+fwsjUUyIqiwGbGH62gu6b6W
	ErPYmVwVZOjauH0zX5DQmaMj12Vs3i4s/SXIyYBmxYxx1CG6pUyxgLy4tz7K79GPAi0EaKF611G
	E/pUhKdzvnOjwDcxFnxq5pjreNuK6QRK0lgTpWxcIgWWOeUQdfxwEHV3NAnNXCHntkFPsuMQrbQ
	td8Wp58V7CfVAOgQBBOPvhSX0TED2i0UTuLXQ==
X-Received: by 2002:a17:907:9b8c:b0:c20:fda7:1856 with SMTP id a640c23a62f3a-c2556c42933mr1472391066b.8.1788131178896;
        Sun, 30 Aug 2026 16:06:18 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255f1fb4c3sm358988266b.48.2026.08.30.16.06.17
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2026 16:06:18 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a1542cdb53so2697206a12.2
        for <linux-crypto@vger.kernel.org>; Sun, 30 Aug 2026 16:06:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxesSBgWzzeUW5EIB8Qpa5cO6+ahO1UXcxdWPn9WEhttz9tqCnJn5EuxE5sDYpPy0k9KT8zEgxT+mYVAk8=@vger.kernel.org
X-Received: by 2002:a05:6402:304c:b0:6a1:8d1a:816b with SMTP id
 4fb4d7f45d1cf-6a60d3c68e1mr10567029a12.11.1788131177037; Sun, 30 Aug 2026
 16:06:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260830222100.2706175-1-usama.arif@linux.dev> <20260830222100.2706175-3-usama.arif@linux.dev>
In-Reply-To: <20260830222100.2706175-3-usama.arif@linux.dev>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 30 Aug 2026 16:06:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg3d5HUkgdWq4Ac74xoUDU_BiHTC_ONacwYFoXnMQZ7Pw@mail.gmail.com>
X-Gm-Features: AcwNN1V9mL9a1wNLsNDWQwZtJk0bPbWUHAKzqqG4Vlgljpt5d7Cp4YfC54xzDks
Message-ID: <CAHk-=wg3d5HUkgdWq4Ac74xoUDU_BiHTC_ONacwYFoXnMQZ7Pw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] zstd: use cpu_feature_enabled() for in-kernel BMI2 dispatch
To: Usama Arif <usama.arif@linux.dev>
Cc: dsterba@suse.com, linux-kernel@vger.kernel.org, terrelln@fb.com, 
	terrelln@meta.com, linux-crypto@vger.kernel.org, yosry@kernel.org, 
	ebiggers@kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, shakeel.butt@linux.dev, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 30 Aug 2026 at 15:21, Usama Arif <usama.arif@linux.dev> wrote:
>
> Add ZSTD_USE_BMI2() and use it at every runtime BMI2/default selector.

Thanks, this looks sane to me.

I do still react to a couple of places. Notably, this part (repeated a
couple of times):

> +#if !defined(ZSTD_USE_KERNEL_CPU_FEATURES)
>      cctx->bmi2 = ZSTD_cpuSupportsBmi2();
> +#endif

should probably be an "set state" macro the same way ZSTD_USE_BMI2()
is now a "get state" macro.

And:

> +ccflags-$(CONFIG_X86) += -DZSTD_USE_KERNEL_CPU_FEATURES

We don't have anything like this for any other ZSTD defines, so my gut
feel is that either this is in the wrong place, and it should be in
something like

   lib/zstd/common/zstd_deps.h

which already has kernel-specific stuff in it, or it should just use
#ifdef __KERNEL__ like we use elsewhere for things that are also used
by user space.

The whole situation with ZSTD configuration is a bit strange. I note
that there are things like ZSTD_ARCH_ARM_NEON that the kernel never
uses.

Why is "DYNAMIC_BMI2" a settimg but things like that
ZSTD_ARCH_X86_SSE2 and ZSTD_ARCH_ARM_NEON are never set? This all
looks messy.

Or is there some hidden config I didn't find?

Strange.

             Linus

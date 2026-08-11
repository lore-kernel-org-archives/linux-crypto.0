Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B13F3F23CC
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 06:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786428991; cv=pass; b=s3ruq8Vy7IAUgR2Il40+Vlbdz4Z39mlFPHsGRIVv+Be1K9PvqPiDf0nFmKaWOnaJpJbiBumoHRyo01heJCnQxITCwXzIkKvkq0EERCoczGAbg4tn+tuGbjr9RXIx526qMj5OjgrWWuNqFwnHeLFl1ZhzydXsROa/gLKWZB7k3eU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786428991; c=relaxed/simple;
	bh=cfgBeWsuQ4lR9xWJ1ew13FUpmpSq+gQ4RYVq3UXp+Eg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VrtZZLRVuiauC+WpwERSYoYoRGl+1k9gJSo29VJpAZfquX+Q79CTiBd9I6TPnph0IUkBkXOAxnNtm+x9kbPiK/sE2XXG6PmBvhy43kzJnLLBrdnStqJK5fK4/+uqWbpKdPps1fTsL7H5VfvOIG65ZmaW3JPF/LwPtrwYU4SfsPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rpvVn8/d; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rpvVn8/d"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81eaf3709b4so35322827b3.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 23:16:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786428988; cv=none;
        d=google.com; s=arc-20260327;
        b=GCz+6DfqvfttDHNknK8ky88ql4lin8hoDhHl0/Vr8E3NbgxipVIpTPbj5C1zcz0LZo
         KknZWyy6dfWX7OtuvXqvS+QuVbJncdQHT/eKKIRHj/6mbfMlZhxh8yFnVrmOeTTpGeq7
         sVwe/IdlqAUz6PnO+ujWl6d/XmRa6Ldns2qzq2N6Z47NV/J33Gz+tGehFtWAxLEHj5FG
         /am3xHtzzdkwkVkO7m8yMztAoFwkkiW3xiRASilSvd2qW1MBRBJaiR1MOQjTZ1djrSxW
         UZ0soXW5E2BliktEh5zPHKdTaSJaQR1Ph5/T4k4OTdV2auHpENB+rZWz7itpVMzIi6k0
         AXeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cfgBeWsuQ4lR9xWJ1ew13FUpmpSq+gQ4RYVq3UXp+Eg=;
        fh=w/xkGYuVM++L66wAH225iaGqIaI1seZr4UovYxFh9YY=;
        b=Vt44kAIpSuApiPMZjlT5N5kQfTv0TO+KV9E/V/LgZLYsCthDcnQOVazm5p+l3VwMvv
         LqNoWxafFqlMh2BPJg6i2lK1nakqeaCBM3s7EX4uPvbTrmBHaAtoJAMEjf2X9aFMfVtT
         caqwD7nvsxQYDnnfZvyFNmIeULxG/PspBKucPhE1BvfJpNIdVifxlRrSNH/VLnI6DqL0
         ETaUZv5OK46wfRYYzzLnjCO4VIzmfR65XCUYIj6Iy0Cowl8FdRkMTiy0ATUdXRXP4SP+
         dM6wAh6NozBHFnNSpbzlr9MocQzWi0aXS78FYaqTc/O1DfqCLmet91sE2r7H3Ck5b9dt
         8+Hw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786428988; x=1787033788; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cfgBeWsuQ4lR9xWJ1ew13FUpmpSq+gQ4RYVq3UXp+Eg=;
        b=rpvVn8/d1WD2uOAJqbXPhHC872/KZzca2C4EyhM/6e4Sez26fmCivKRkroIZo7gH9D
         gLEE1jTuUKakqX/Y+GL0nGufvN1rdCeszCxCfcdD2SM1dm0az9jIvTRQHpPA8AFj2ym/
         dvR3rndXWzV5xNw7cbuiBnV2HU0HF4z8EuEND0xBiLef5Z2Tlvwyy0Q+tct5C0FE+q+u
         SU4ml0tYRpAzx9ULUlOQeukAZSqBdAKI1P7wFBegKjfZsEdGMc22yRm5YIIIDsHgxXVr
         VEQ3EzGiJ07Et8qQyTLbKYb2MjVgbq68yDo6P9BNqLSMLb6T5mJbKE5SY6Gv1PdC7Ilf
         Ajbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786428988; x=1787033788;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cfgBeWsuQ4lR9xWJ1ew13FUpmpSq+gQ4RYVq3UXp+Eg=;
        b=a+klEq/EMt/y0i/n9ZH6F8PUaEHd1zjaBuX/z5rwy8MPy0i9JsJAiE+lMd1STFu9Qs
         WFMq7XTvqeklGMrE4fWeIbKynHALzVH4VsDbbOpFf0DLnyHOLIilMsg9pKkGa1sb0gCb
         u+/TaXUwI3XdvqrUVFUcoaWH4e4dWuESmUqRnKBeoMkz7PLffg6+MEYb/xKaVsTqkXqV
         NswSmYrF51elvI4LHzWVEcMWe32EN2PeNiGcGE4enXOG8bvJNH2mF1d3GaBsEL7blbHq
         dUOYeZk1PzsvpqrM31YRQSLUdRU/UeiNC1sg1UmOhl2dmsrEDgL7RBkz1dm9f6rmSnCP
         CFHg==
X-Forwarded-Encrypted: i=1; AHgh+RpQwdL+og/haPnRkwLepsXmDzXCfIzZM6st4thH3KMCQHWhFH1OTa38ZLXfr1GmawDsSdAMVUw+ZCEIs9o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5U8Nhg9LS7wNqGymBQzLaQeUNGGaZH5T3bB9gwFIvVRbTO4M1
	wPJrvwgUQ8E7Ti1wkYz8CA+3YD2CKHGX95S6f5IpR9xCKqcWacdqHe54XU3ZHJJ3mfgQinYQQ7a
	0ko0s/1suYfHTxNlLopFuIGJ2ssDjcy8=
X-Gm-Gg: AR+sD13toQmbkvIic/0GrTGYJkfYkko61Zgbwfj6hA6Vk86R3lMeC0rHtrsSy2KFzPE
	XJhRPiT0uOye/t2CwqVO5YZJoDa0QvnD84YFMul8nyt7JYHZifI/chy92IVsNXTVHrywysTvO8O
	o7bwy2YTZM7IOI6t61Hsb09OVgm7gm/3eGbJ2ffZ3XSIqLQRrFCYGiDn0DukYAM3Jx1y+inxov+
	MerlMnc2SgWlbORb9yX1nvl7hLCq8syCLojbhmjLT3U6JdlWbGfniXjQQ9F7FhXvczOZXNygstW
	ITDELQDdujBehOCsNzxVucYeJ6aX8SGeochSf9HuXEGeFWo=
X-Received: by 2002:a05:690c:c9e:b0:80c:d342:955c with SMTP id
 00721157ae682-82f289e94b7mr5606407b3.3.1786428988556; Mon, 10 Aug 2026
 23:16:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808074510.2655473-1-lgs201920130244@gmail.com> <anmm6X4MLpyIH8K1@aspen.lan>
In-Reply-To: <anmm6X4MLpyIH8K1@aspen.lan>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Tue, 11 Aug 2026 14:16:16 +0800
X-Gm-Features: AUfX_mxUBmem10ffZDic2Ejp1QbKpijUB1N8Df5NJafaJYvbJY0owxLwLT1ooBs
Message-ID: <CANUHTR9QBUtKJ8f5JAhRGPWw4ca2QpuzMB=F9ZC3Q38RoGMqkQ@mail.gmail.com>
Subject: Re: [PATCH] hwrng: stm32: fix usage_count leak when autosuspend_delay
 is negative
To: Daniel Thompson <danielt@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Linus Walleij <linusw@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Daniel,

Thanks for the suggestion.

On Mon, 10 Aug 2026 at 18:24, Daniel Thompson <danielt@kernel.org> wrote:
>
> On Sat, Aug 08, 2026 at 03:45:10PM +0800, Guangshuo Li wrote:
> > stm32_rng_probe() calls pm_runtime_use_autosuspend(), but neither the
> > probe failure path nor stm32_rng_remove() calls the matching
> > pm_runtime_dont_use_autosuspend() before disabling runtime PM.
> >
> > If the autosuspend delay is set to a negative value while autosuspend
> > is enabled, the runtime PM core increments usage_count to prevent
> > runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> > during teardown, this reference is not dropped and usage_count remains
> > unbalanced.
>
> If calls to pm_runtime_use_autosuspend() must be paired with
> pm_runtime_dont_use_autosuspend() then I wonder if having a
> devm_pm_runtime_use_autosuspend() would be worthwhile?
>
> That way stm32_rng_remove() could be entirely replaced with devres
> cleanup.
>
>
> Daniel.

There is already devm_pm_runtime_enable(), whose devres cleanup calls
pm_runtime_dont_use_autosuspend() followed by pm_runtime_disable().

So I think this driver can simply switch from pm_runtime_enable() to
devm_pm_runtime_enable(), and stm32_rng_remove() can then be removed
entirely.

I'll rework the patch accordingly.

Thanks,
Guangshuo

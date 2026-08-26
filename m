Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8370B3B71C9
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 08:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731480; cv=pass; b=Al4knggAz8swZK1D5JBSzZDmA83wMH4XE43/Ced3LT/ya088NAxu1dwmUltbg3YB1xpijYvL+0s+5CVkOG2FNqh6d6ZP8sd/V+9WNPhMIdaWLLYSL+9wDM5ftd+oi1FUxD28U0pT7oa8zKPAlzmeEbPbelmVLZ94dfzhtdAmwxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731480; c=relaxed/simple;
	bh=gljENqI22pecVC7PFj3mqQuHtHE6FZCK6uxJWQ0B0nc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gO36CORN3RFkwSvsASXROTbN90kImz8F0D7+NvRKx+kNXPaGd0j2G9EdE1WJg6IS6YOjKd9pm/5o4iApku6avAi/+CyLEDb0z4SJz1xlik/O/XoK8t+3BJZkNA119yzho5WVW8fa8g13FTWoXGDZ1dlapU8fYmfOpaKA2twPhX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JZzpKw+A; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZzpKw+A"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66d1442b24eso593452d50.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 01:04:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787731477; cv=none;
        d=google.com; s=arc-20260327;
        b=Kdf2DOR2fK2hnUZglKaevosNXhTJirb3jRs5UlAkxUl+3hZckpHoy32GZiL5UzRVKi
         uQaF763TzVMk69Zfp/KEVVmAZQSyHTF2fbprpUAPqyY07tdqVKR3REGoGgyG9cfHZFT4
         +VGUljBG0VhT/GffdIHCOOD0KyVLo9dhnMMY8/fMJ0XiZgsk1KtceBig4WEG4OdcFcQL
         mmGvlsGJs25xoTObnFuE+gSM5qkr7w9hlXTA6HL0PqbFCDus40I/suAWi8m401c6cHVK
         0CoiBFoLQB1H+KtHshtgACSH+NkjfNtHWMzvUlye3Zou+tE9euFX0gZ06aX2zbFRwqVZ
         Oa4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gljENqI22pecVC7PFj3mqQuHtHE6FZCK6uxJWQ0B0nc=;
        fh=jjNam1EaHnzOMZkjfp5tvVON+8H/A/Dji+agWGHhdkE=;
        b=g3RIBlJFdd2pDH9NHIsC4OwmFoUw5JXhZx1rOmnOJBSqnjD228qKyBsy6MJROPjLHi
         iYZUgxXtTG31QMWavVoIm+caNkOtN31Aprtv3mnYPTlGXkPjydPPteefbMb1RmVJXeTF
         66KV3bIZDI85yc4ChR9G4116voXBqUuWncjhh6WPwwrXzSohm647RCTH49p37y47ZeDT
         xJNa2P9Wds+wKVV8M4tBX15yfSwPuYE0QenBw9htxLXDYlUVgbeaZcqp4JwQNHtKd0FN
         MbS30bXl6LQmxpD+0aE9LBka2GQvAo7KZwmml4gq0kgsC/sKc/e/lGBnhOPag5qwZEV6
         1WoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787731477; x=1788336277; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gljENqI22pecVC7PFj3mqQuHtHE6FZCK6uxJWQ0B0nc=;
        b=JZzpKw+AAPBmuxuCaGpy4CXoHmxkNgbKRfGxEHGIQgnR2E+xFmaLtyEaGqKB2i2YYt
         AF8XIOQlvTZ584+HN+d52SEVrzy/479qIC0/T8ms+eWWuXsdlof3Qe4NcT4mIBb6dVJ+
         Qo1mh96rwtVLvmOuk/MArJ2NvEscDFhV8jZOhXSmzw7uwUkM7znw94N+tiOU4npRJGXp
         s3mZpPn/L2cNRtVEbDZIbJxQIOoZTPfi6RPES7Pik4NsBvxJAp0DcdEPUokKYUgMg7zT
         is8TrdNKOK7OcEpSm9tWvQg8WYdF4WFsvuyfGNHBiELmj+2+/pEpCpfh0bLtfti8b8gn
         pNHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787731477; x=1788336277;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gljENqI22pecVC7PFj3mqQuHtHE6FZCK6uxJWQ0B0nc=;
        b=m0okXKd1a7iVqfLMUoL88XrPgph8EzHAc9oLGrDg0+s67bULvNFrBDyACsKcJijUEi
         I/fi1vsRGwX9vs29FoRuxz3/7uSPU/KA5QRryuPWeZvMmKpeOw9T3M0vZXAD6JpV6MD5
         HD6tGFvy6LTNYZfvzejzCkxzXauegqmHxmcObeQ9kaLzYI+DxxoUAB3oN32mlK3mG6uw
         r/oL5/9w3WsOu/rbhjSzE0/30IcQq6PqVn/N+YlG1uw9wFG/B0uid/NZwAKIMgClc+Zg
         H/iAf45tl5AadAl3jQVUHPT1XRD476ZPPWKjy5wYBIzdgIbMwazC1/yPBRAOggTYFeBy
         YayA==
X-Forwarded-Encrypted: i=1; AHgh+RrTLwAxayltaX+l+ltuDw0AQB1VE88+/k3NWprRLNfltp8UdiqaHORZG+NUPvdp7YDFrNnzVlqaRXWpm90=@vger.kernel.org
X-Gm-Message-State: AFuF++k4rcO7lXBzd0J7QRNR18saNY1ryIkp4nM0CzXRRiSy1oF/zQKm
	P2ewX6PfXZrRbphRe/iEuYAujRzLBeJbMP5RExkukzo/SO38S+v8Y0cJxcQ5CV0R99oF8uJPyJ1
	WZqW+pjyAyv8wWu1Ivl8p154pmnoBM98=
X-Gm-Gg: AR+sD11ILJ0Or2Q7R/OheiPKts2wYv9Xlvsdx06A2qIkdlKMfk75sH5LzGlAYt6lj+V
	aE1t1RCpxP8giimiKgM5ozeEj9cIzfUGiC49RF0I2K+LVyzWuKhPMXqS6oQZ0mWUxxY+N7U9OQD
	GrmTTItQDc9uJPRlNFO6HRhP4IwpHZHOhP/6OI/zQIsQ4IvPZ9Liw6PYIE2phGZNPu+zF8If6eL
	fUJOf1YQch3ATGBF9YgbTOgT9GS/C/jKsU7rlUeMkR0DHH/ucxj+OEMV4KyMMSgRnRegwE73TRR
	qhi5szVezscmEyXw4jMWs4el6K+OZa+3wthqvZjB4o15HxM=
X-Received: by 2002:a53:ac9c:0:b0:668:9fa5:b9cc with SMTP id
 956f58d0204a3-66d2551013fmr1633452d50.0.1787731477460; Wed, 26 Aug 2026
 01:04:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808073748.2649808-1-lgs201920130244@gmail.com> <9e6142fb-bb69-459b-b7e7-4aaf2bbc3bc4@kernel.org>
In-Reply-To: <9e6142fb-bb69-459b-b7e7-4aaf2bbc3bc4@kernel.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 26 Aug 2026 16:04:24 +0800
X-Gm-Features: AcwNN1WTArxH-Wd9ybxPgMiQ8kdpjWn5ZJku5MGMoyUD_P2LJqYmH3XojzLPzC0
Message-ID: <CANUHTR-Kqb+fw1EfPoD5W4SMYR6euBcy47jfGVYF0P0y7gfVtQ@mail.gmail.com>
Subject: Re: [PATCH] hwrng: npcm: fix usage_count leak when autosuspend_delay
 is negative
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Andrew Jeffery <andrew@codeconstruct.com.au>, Avi Fishman <avifishman70@gmail.com>, 
	Tomer Maimon <tmaimon77@gmail.com>, Tali Perry <tali.perry1@gmail.com>, 
	Patrick Venture <venture@google.com>, Nancy Yuen <yuenn@google.com>, 
	Benjamin Fair <benjaminfair@google.com>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Daniel Thompson <danielt@kernel.org>, 
	openbmc@lists.ozlabs.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

On Thu, 20 Aug 2026 at 22:49, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 08/08/2026 09:37, Guangshuo Li wrote:
> > npcm_rng_probe() calls pm_runtime_use_autosuspend(), but neither the
> > probe failure path nor npcm_rng_remove() calls the matching
> > pm_runtime_dont_use_autosuspend() before disabling runtime PM.
> >
> > If the autosuspend delay is set to a negative value while autosuspend
> > is enabled, the runtime PM core increments usage_count to prevent
> > runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> > during teardown, this reference is not dropped and usage_count remains
> > unbalanced.
> >
> > Add the missing pm_runtime_dont_use_autosuspend() calls to both the
> > probe failure and remove paths before disabling runtime PM.
> >
> > This issue was found by manual code inspection.
> >
> > Fixes: c98429297d8b ("hwrng: npcm - add NPCM RNG driver")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
>
> You sent vast amount of patches, all separate, making it very difficult
> to track and respond in efficient way. Do not do that.
>
> Group your work per subsystem.
>
> You were asked to clarify and respond to incorrect fixes statement. I do
> not see how you clarified and responded at all.
>
> Best regards,
> Krzysztof

Sorry about that. I should have replied to the earlier review comments
explicitly, and I also should not have sent so many separate patches.

I will group future patches by subsystem and make sure to respond
clearly to review feedback before resending.

Thanks for pointing this out.

Best regards,
Guangshuo

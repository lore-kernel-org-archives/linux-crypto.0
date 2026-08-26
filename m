Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2389D2E7372
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 08:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731394; cv=pass; b=d2z0Yv/D1/YLKuV2R6CUVjNO8M9SfBo+vHo2DMgpumucmmiq56rpxMg0z5e/wlkiIPQMzYLuV/FH1sTpacCNA1Q/aT6RypoA7USfQDnqHHsv6Y4z2SOGNPXv5LZmVugLWim4jg+5MsfCKcJoAEI2+fvTXSHfDjGpzIpkht0bZUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731394; c=relaxed/simple;
	bh=Uf2R5y6Fxk2ATvMgWSnfDriG/hCrxIHMSdfuHilVYAc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XG9qHlv5kJHBPhGwtavpaL4fCUP7u7936EQJOob+1Zk5MIgZ3yy2GsI0NaSARU0djQelimxeYc/aplI8+Ycic5YzQRCsGxbpMqKbN1eZiFVXYlfVrp+dT3PlH1HC9wSGTWhplrWZgo86/1FbWBN5r9WXZOsKA5naXDO4VPQ3Y5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P6JEdEOi; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P6JEdEOi"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-66d1442b24eso591662d50.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 01:03:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787731392; cv=none;
        d=google.com; s=arc-20260327;
        b=FQ2c6o7+nY1TakdXUysrxyAq+WH5EM2dc8N2j2tGoXeCVyVbHL7VDbO3F69Ga3m2pG
         ZvIRhhLf0gDS0N7170y+9j0adJWBrf+BGw0U4EfjNORZoUtz/y9fl8lmODXUKb7Se8J7
         EcEQU0VhySJaumKHMvADeR/g0gQb1F7+0PJmNC1MWicN0XHZjw7HXsGBqmA5hy39Cu8Y
         kyPyBW2GLOIoiQrbXigF//Ezjo/4Aliqx1tU9ViT5djslqSnQ50O4P1GDoz3z7OEFZcT
         E4bKRjmdj3OKiZt0a3CU8c4zgMUlP1v5Oju37d0YIitMBFLB1OABBnWDsJ7ndbfgISod
         O1Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Uf2R5y6Fxk2ATvMgWSnfDriG/hCrxIHMSdfuHilVYAc=;
        fh=JiuRPWuiR9uNrxc4uzu3KMhrmHRxFacfaFRax7h372s=;
        b=q9hMFsiTwQZMQt+hNukkQOg6En217SJZ6fp/kH98I7L4xEvWemL0DyqzTByboXDuyI
         kqOhoduRKVLtRJ78ZRorQ97+LyhNceW6zPEOrhD2u18nw9mRglxSG3lCZKGG8F+V0Hm6
         qCo3Mfu4CyejJLBFaACkCPHAZLCoy9z36FoKz4RlM25vmBMEy890DF1u8NDZsf2YW/Cc
         /9MKNa3UN37jTN0PFBqvtNWUzMuHrTHrAusPtryEgH2nyclfZhA3MbxkqSBvOwRTVaUr
         KZe8feum/qKB/eAakKjDHLhGhTfsAxNfFVjploFo5vyayECM7NzBuynNW3fo1SidwPFd
         aN2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787731392; x=1788336192; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uf2R5y6Fxk2ATvMgWSnfDriG/hCrxIHMSdfuHilVYAc=;
        b=P6JEdEOiaSnd7C0NRsMzWgFGjiVSzSa7/jwTr7shYLeCNF6Gai0i0AdriR8aAk6lJ/
         sheGb5K9/UMK322hD1VaBnhTBwTcJYD25CazJLil/5yE+zV3/SyF9RF2GUI4rrUGnTcc
         EwmJjIZb+fTly5Obnt9DVY+MvARMmSO38vcjGWGPJ4t3/bJ9V4aUuKf25iQ1bRtIcmOl
         qxSmQtJ8QW3DkVbSFsYH530EXdyWt+OZ52RGimveNInPZf7kRH2/hJJg1mudOYrf0ruP
         nDYFiCFOnhxEIH1HqNhL9++ck44XRzCJMdTOnZJTvONf5jQfTeKy9+NBW55zxq3LGYZz
         ICeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787731392; x=1788336192;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Uf2R5y6Fxk2ATvMgWSnfDriG/hCrxIHMSdfuHilVYAc=;
        b=EK6yXf9hC3hCmbilJfGy5nOD39o1wYP0xVOUL0CE7zYkE7qGcWcXKUbvIRd7pphuw+
         89TNjNXZTZghzno/a0EOUB/heBJWWgO+USbYg6sP2PheDnxh290I7tNML9fdPG3xwPUJ
         2FBppZ2fJ0z5aqqySfZngBFFnSzVnO7lWqAdbirVVoS+ihq6qL66bVtmEm5KfO961OhL
         21taOpjBLyAj/yvhNIQCD1Dkw7XAWBmpqNgAoZvIw+nB3PyHWiABa/tZx3x6W9qVtWM7
         2l+LoRf/Ii0CM2ZaPzMNLYA7nZZ+az5lqSAVLb5JFpD/A1qK2ahZYtFeC/IVL1SYogNt
         o58Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqb0O3X2TUVeAOyVfvt82xl7TNjyPMw0t8FpTQCcxRhG/HgDwGyxCYwLIct1+ulCCN7dyngFGHa5Fc8aQE=@vger.kernel.org
X-Gm-Message-State: AFuF++nnk6ZrALTN+vIfgDMbqb+GLXs5mP+Mfq2+MMins/5tw4lGZNKr
	L12e60zH9RHca71apZGztNWRwQBvio0mH81GYP96x0SmZMgAYRSqcv6be3tCJD2xiNih0UwUuKc
	3P6HE8BmaUbukQyEHs78XO9Jq+9TR7gM=
X-Gm-Gg: AR+sD108O2QgpLVYEgoeWxI0s9MXOwgd7xi0w9HxpXixFtR2PyNIuxsHUDLRnl2mwAK
	eUMVGAoAP70eqeDMEGehwhTArO2BZoZCSuqL3dx+iy7c/kxta35vuFoObLbTXfDusYZ6BoTN/YS
	5B+lVRA/t5Johar0quB9A/r0MjPWOKfIZ8iq2BGGYMJ24U7n66ZhvI9sHuOp8EbwJfOGlZTxFdK
	VxI6du8PhIyWrXMOv7WEB5I5bXIV6f+xmKUFEopJZdFYCzMXSAuWd1iWPLZquTu8TQTr5dnGhUf
	3R9hXP6AGxEb6oMthwt9zvpJnYwi6T78CmxRkbpVJSG2l4s=
X-Received: by 2002:a05:690e:708:b0:66d:fa2:63d0 with SMTP id
 956f58d0204a3-66d2580ca29mr1093286d50.50.1787731392131; Wed, 26 Aug 2026
 01:03:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808094114.2750088-1-lgs201920130244@gmail.com> <822e98eb-8e08-499d-a48e-bf39f985c524@kernel.org>
In-Reply-To: <822e98eb-8e08-499d-a48e-bf39f985c524@kernel.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 26 Aug 2026 16:02:59 +0800
X-Gm-Features: AcwNN1UyKWn6NmN_t45sTti2vw38ypw6BLs-mDluZkOKLJ35A28L82oBP9VRI-M
Message-ID: <CANUHTR-UfWT4gw2EZZrYOrOjdwzpcJVnUM1WbkZa=MyR2yDfaw@mail.gmail.com>
Subject: Re: [PATCH] crypto: stm32/hash: fix autosuspend cleanup during teardown
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Thorsten Blum <thorsten.blum@linux.dev>, "lionel.debieve@st.com" <lionel.debieve@st.com>, 
	linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

On Thu, 20 Aug 2026 at 22:03, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 08/08/2026 11:41, Guangshuo Li wrote:
> > stm32_hash_probe() calls pm_runtime_use_autosuspend(), but neither the
> > probe failure path nor stm32_hash_remove() calls the matching
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
> > Fixes: 8b4d566de6a5 ("crypto: stm32/hash - Add power management support")
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

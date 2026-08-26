Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050CA3B6BF5
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 08:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731361; cv=pass; b=V05XJt1UQAC79O/y2pcPOl0P3mIRxOp2owJkekabMmR6XDRk9uDHNnk5LbZRGAGQBwUCZVDuyNWbuibYvrKtGdqKV/sEDFylrBqmipvt8rRbuzaKFr/6ENW6HEQ1WKLgngrKyzhureX48l5oj7mIpu1vLtiJl2sEFGkEpTyuQvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731361; c=relaxed/simple;
	bh=HNb54WhmzGWfVXwTVFcpIHzscspSYwASA3WPZN7wCaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IsGz0bl0pkWLowpUz7+bkcOl3EEx+8NtUDV22/01C5LYSvXP0RizJYBL8is6ovo3oFXd4DuhBEZIjyN42rlg2jswpxVJk+9fbKPstSs4CfSh+q+5zevLOH4cYDOwQIcnHP9Pxxf5RnN0iGBOfRHWxUfVi4d6lbTSGJS78cyuiGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BeAsBtAy; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BeAsBtAy"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66bd7857841so667274d50.3
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 01:02:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787731359; cv=none;
        d=google.com; s=arc-20260327;
        b=Lge21Z6yBOuaT8cVR7eu+UWcYD04HYWmu3FWRfGwZS89BkXjbEskLCp/XwLYDc5xDv
         Vr7WdUkshfr9udwGjQD6UCfXOWEkZOiLsaTZZyDlnqPUCXKgCJ9Znu095frjHjkEcxEy
         hrKmdWPesV9s54W86RwT3jbdmohuOI8H1Kljgf66ekmpu1SCg6cjwr9FXQOUd8kQ70mM
         atYtDzJvG2O0J0fTAIvjXyDhkH009a/1Ywc7O442VRpKYexgDsQzrLuk8i/8lg79rpqd
         fPnVrEbz354zuvKDMrFLIhQ0qVE6kC8RSboNCoPWqyphZaJ+fiLayxwaFf6dcpVBVkrI
         gI6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HNb54WhmzGWfVXwTVFcpIHzscspSYwASA3WPZN7wCaE=;
        fh=/+qJvWV5TvVd5RGDCW0RpnzgDx1c9IhNvyf/9zVQ10A=;
        b=QavxOiDLGZUUR7yujTKQK1WQl+G4u6YM+IdgQdRJON0AGd1KMl/QBB98xhU3cfVzGm
         uFEcwCbGPyUIIp6bbog6q6iJG0JpH69cVAbvj3NOHa+9wf3xlh7vxmGeT8OS/igmJ1O9
         AWGuLtR7YdDCJ/tmQq+rsRt/1XlhCXuBAxWyevkD6zsder5D6eplXzGOEhgkwcRra3hD
         9iGA2YLcQZpVcfPPxOYZbVyECNP2O/GRxOoESaNXNInh0B+ozLdf6T4/ivV9YPPbouvj
         kVo1WUhb645C0F3Uq2qzhup+8hSgrqLluQchj6kcFwoND0vD2qFshN7EjuE++0RgfoEW
         c8qQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787731359; x=1788336159; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HNb54WhmzGWfVXwTVFcpIHzscspSYwASA3WPZN7wCaE=;
        b=BeAsBtAyyyOYMKhxdAaPX78/e+c9eat2Wt2963pTLWIYhAeAtk9Z34RKZacIYvMP7S
         k0cFbzvMchtY7WlvDrRxl8PiOaNIsxnIX2w940kO9G1A2zCNj3EmXZI5sHlZ8nOeunsr
         uyyLlTJM9Ur/+f8mrI/eyjIHgYhvdWX4MU+Dmeb1q0yUIrueO5RUmiMyoZbZtEQ9FOZY
         9t9RNZPFhtZacur2pL/ZBrhge019Romind+3033oM5Fk3Ed+mB6mniSM743IKSLkxtWO
         1iuSjAp2TNtmi0tGxgHVh+weIMC+SoX5KuOjF9aZCyTUYraFkLIf0XZOdTCvAgMMipmu
         Kk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787731359; x=1788336159;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HNb54WhmzGWfVXwTVFcpIHzscspSYwASA3WPZN7wCaE=;
        b=TGQ50gMrxvjBka13bODciM0GxUsAGolxL9cA8oDVfFQczO2wkgfiilSCYvmaIMacdS
         wCj5P1qypATNXiOXg6kjYZmEwopCWiuIq4yo0+J787sAfRRkMrM0wEuJYZqVU7m5HgGZ
         /zGTnWOD//KA0jTgVimORl/EjEG5IyX8GMsO3yulDD3pNtEQosXY+Hm1DZ5oV9lDiPc9
         EM0b3BDxuWnyWlopQvwPql+FseeZKZmz7cqE/TrXQhLcjQ183f486xZ5oA1ufhQg1JsP
         vab0omNOXBwyxCLu8nH2f0m57aWNlftjQm5Lq6vSSQKw5XRjm1d+WTtLcJU4iuamM1hP
         Uigw==
X-Forwarded-Encrypted: i=1; AHgh+RrRHBa5WxUHnmzseWxmzTQamWRnsreymRQ9yoXvtvtuxBZ4W4j1S7xf2ygx0Qn9f8empVBzsACVF5nDZ9g=@vger.kernel.org
X-Gm-Message-State: AFuF++mnsuSwIhqKhtmJmzeFzSypGl2jfZIdfA4NXWblWWCmgFdD5PjF
	ECmfHR2JRALIv0kUujhD8RmRALsnYO9Q66sXeIj6C5lJfD6YX3Jfgj2giVWP9WqkL/C6WHpf2LY
	O6nPIeyc2SyIkv2DfuxiBQbVuzEBJuZU=
X-Gm-Gg: AR+sD10ysrFlbuo7DheMnOIVzMOyVChz0+nBg2bwA63JE0olPN/MFFgJ7eJjBtfkpEi
	d8bDP0rD8Jx896qRA/+xznRorKn6jZGO9peBnPzymW/WWZR+QKMVZ45MYQgrB2qp8xCCZn+mwLf
	7fnTk57sRJbH+aKkSPGtEUGver5btsQAnp+Cbl4bSjTtcyi1Q0kfE+7yWBed0kkpz4Jcr3VOH2P
	zlhtZ8hjA/9AJV/WZHcuVbRcaaiKZhU+KHgGN/vGalS8zhbrsNqIggW8bUqIdgWAqmJ8mD1R4vh
	FRXkQzYLdjeFn7mbcTiWMghkf0dFoXjlQHEACfl7fS5NV9Qi
X-Received: by 2002:a53:ec85:0:b0:66c:484c:867f with SMTP id
 956f58d0204a3-66d257d6fb4mr912561d50.45.1787731358946; Wed, 26 Aug 2026
 01:02:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808091734.2727295-1-lgs201920130244@gmail.com> <2d997800-b7b5-4700-919c-c4b6e5e926aa@kernel.org>
In-Reply-To: <2d997800-b7b5-4700-919c-c4b6e5e926aa@kernel.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 26 Aug 2026 16:02:25 +0800
X-Gm-Features: AcwNN1WB7uMO3ABJ0oP8Rynn4S9aYtnBveYSbDNyJacRweQS6TxxzJZhtRXy8y4
Message-ID: <CANUHTR89nZ=GQGte0iE2Fa=VeiiEAXZhLu5S+osfXg0OORcNZw@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree: fix autosuspend cleanup during teardown
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

On Thu, 20 Aug 2026 at 22:03, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 08/08/2026 11:17, Guangshuo Li wrote:
> > init_cc_resources() calls pm_runtime_use_autosuspend(), but neither
> > the probe failure path nor cleanup_cc_resources() calls the matching
> > pm_runtime_dont_use_autosuspend() before disabling runtime PM.
> >
> > If the autosuspend delay is set to a negative value while autosuspend
> > is enabled, the runtime PM core increments usage_count to prevent
> > runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> > during teardown, this reference is not dropped and usage_count remains
> > unbalanced.
> >
> > Add the missing pm_runtime_dont_use_autosuspend() calls to both the
> > probe failure and device cleanup paths before disabling runtime PM.
> >
> > This issue was found by manual code inspection.
> >
> > Fixes: 4c3f97276e15 ("crypto: ccree - introduce CryptoCell driver")
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

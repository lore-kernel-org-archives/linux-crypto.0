Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C842832F76D
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 08:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731960; cv=pass; b=DSCkh0/NVLjz32nYeUVUFGUFvNNtG7U8MWZVduseEBYyMH4BLsqgFcpN8TV+/06gRVdS8aQNMXZmglITdoXg+5bD8D1s7iXh25sDnNYUFQFqiaU2KjfPhBTq97P/j90GP+xEJ5s0EsaixL3wdT8/ZdTUG76wPiQXcuSi25isww4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731960; c=relaxed/simple;
	bh=uWjL7Zpc1RbXxYUhrkjehswpmSWh1RaKUZDsqI6aoKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PrrBs+RJtErqcvvt1sAMQav0wzm4EmMn9SYkQ4/luK7QqemK2moYvl0U9E16s2aV1rCNNNT1L1rSrNkQphN1x+i7awXm0ux0OBDCtaGg9k/HkYXwRPdirSAYbg/0PsYsLy4Hl/o0zi4b/ZstANQuoSrM22LOAxzvyDFzWMl2DLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L8pKroQU; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L8pKroQU"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66d2529310aso610927d50.3
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 01:12:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787731958; cv=none;
        d=google.com; s=arc-20260327;
        b=mS2dv+DSGNjs5c0DJxpxB+k1r3VvzizrCPLh2/SBK1flu4Io0OycG/OG57f4Yo9DST
         YXsK52B5RJcmgSQ8iiEpivRbhU3qnUbCUIopFBnzSKxHMO/TjvVNLsM8XWnniuoueANH
         HMk93lQrxaB1M5TPjHtA8z/ufoOhACO49X65Lwhr1WE89MZJVqgKvZkmQ7neUyp90Vsi
         dhH3vOLz3gQNGxKCDwirhgnLr0YLwbaK1WLuWqS82fKXIqfDmi72eWJD/Hef5doazyLT
         lkLIPCoAw6fp2wEwLXT7PVhnXrtBe7/jN0WGJ5ABOrgyWy8VbaD0Ulpccde2ovxFWUGz
         N3/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uWjL7Zpc1RbXxYUhrkjehswpmSWh1RaKUZDsqI6aoKw=;
        fh=jjM7ntroPw6Q+YIz/Q2YhGczb5mSR9jtvCRusYqzhgo=;
        b=rmSaNPfcmcU5286p7AN9Z2/F9ET3vKRZn2k3za3R6wKQyhawVjaZedRMzijJUPbMIA
         nW4wcK9vo3Mcj5A016mWihvMisFLFrdBsiWyECKeDKOLHKtJUpCrHFeBrfRo+UWxmst6
         oEsyCPiB0+wVimmfsmmqZ1xgnNg86UwHbOIW4vhwi6Iez/b3Ow1U7FuedAQn5ephTuz0
         cHA8oSIfI7TeMAR72WkbY45QnGa5m5EJijbTAqDKpeu5ySx2s5nRT4IC2bJ3zIJqf2Tz
         32mZIK7xICry3UgNhlpT9AV1MHJPWH2mZUVM5BoQfZsiSGe8a8R3OydE0x8cEgShbPIF
         +tww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787731958; x=1788336758; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uWjL7Zpc1RbXxYUhrkjehswpmSWh1RaKUZDsqI6aoKw=;
        b=L8pKroQUGzkP3ixtZBUITw4qaZ9M84HFyS7egP4Lj1Cb1tXrJH6uu+7mTaJG8NKi+E
         hmNQgmxmS5rTqeEuOhuHRkGHUm71OWNSRgQipBXYtmX1i0Nkry6NfUuoumoXj6UDYQHb
         FELyw6UI59q3Uu56QLtGeTG5CSxbuSznf8SakNncMKdby86Y5guHRxXUqN4IVq140cZN
         hxlLbzcSBK/+YNBPGzjZDQSiiChxOfRXc9qiKvZQu0z1eJucPgK9+7ou46/aommJz3UV
         75aOMzpr04iQz5hJxwxC9Y6Xylj3dGBfpIvDDlMPJHcXfZD6mhPpGbeYCqjdPti7HEKU
         y1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787731958; x=1788336758;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uWjL7Zpc1RbXxYUhrkjehswpmSWh1RaKUZDsqI6aoKw=;
        b=Gj6finypfNxhXagWi8ZKbm2+kC9bXAbruRyvD0B/zLXGe0Ie4Z444vTvRToAQVXslH
         F7q0FZZ72S7jIFBbHhzo2hM91wX4gXYzX2Sl/+9/x1bXTPTJ+xilYmYd1wOvCQK+5yCS
         7QJxNdx+11AMDEW+lakPPokF7x5BVQbqc1vNR/49/9jl8DTpPqgzotNlmqDQ5GOF2mt7
         +7t1LlT1kQYdUvqZV90MIn9agrvX3v1zpUcJhAp/fzgUYtZv+JJPx/eZP+jciv4NYesL
         4WiAsxljkiaOiDQDH9z6wz2lhj18AnP36Lew/aIGVmgUxfl/Cv97chy8jVKLRORuLzke
         eomQ==
X-Forwarded-Encrypted: i=1; AHgh+RpOhFPWgt2PmUihLpOotSCX1tS4cUc/DtWe/bxsoOf+NHBvWTqh+ksC+olMU0klSYjdaChDS14uhMYwDsQ=@vger.kernel.org
X-Gm-Message-State: AFuF++l7pRCS9iH7hROF08xQYoOT7gxA88uaYH7TQwi6npzwWwZeTn/D
	4Kl+/lzk9tS0MjHT2aTg4UC9tgPS+rtIUTEs/Bfl8jyOiiU9GfkambPFhdiL9YH03fOLZ6ZHCmE
	ChoLz1NcAODMb3CfKFU36KNY4KWFeriA=
X-Gm-Gg: AR+sD11vfrtjYxjIhpjtrjiwmPgOeFTnoGVyCDnE0+ikuFxhv2TUDbekTP+bMRS2QHK
	gwLjMLiQKidlarLXQ3iLm0UVNUONeHrok0C2v9/Yf/gYZtvlX4nRMXEVk/s5q+EomQCzledtnjK
	AtlP+0pdGi1zjJlrIVh5NgParc9bwh5PpfFS9DSsuZQJ3PG3WY37bpMFXSxl2hFPfjuktAvKO5y
	9EQr8Fc0HghcYFywFjCLMWpel0J7tyusKoMqHe2pVua3BbIQ/JfPrj86uZEywB7aSr2is9BmdPt
	YHy+XxCimIfaJHp6XycC3DSG+yppl65B/n7ESTLyUrp4RxU=
X-Received: by 2002:a53:d00e:0:b0:66c:fb45:77e2 with SMTP id
 956f58d0204a3-66d2575a752mr1255819d50.28.1787731957855; Wed, 26 Aug 2026
 01:12:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808093016.2738659-1-lgs201920130244@gmail.com> <218fb204-ad8d-4005-a995-6ae931fa9942@kernel.org>
In-Reply-To: <218fb204-ad8d-4005-a995-6ae931fa9942@kernel.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 26 Aug 2026 16:12:25 +0800
X-Gm-Features: AcwNN1VIwYHf-K-salUzkbrUObzNrM3k5T8nRh7TzSvSmg4UxobHgtjT9MejMlA
Message-ID: <CANUHTR8Mp2d16Va2uxrnwSw5ro353T9czc8vMvzUvn61Pa9eaw@mail.gmail.com>
Subject: Re: [PATCH] crypto: rockchip: fix autosuspend cleanup during teardown
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Corentin Labbe <clabbe@baylibre.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Heiko Stuebner <heiko@sntech.de>, John Keeping <john@keeping.me.uk>, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

On Thu, 20 Aug 2026 at 22:49, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 08/08/2026 11:30, Guangshuo Li wrote:
> > rk_crypto_pm_init() calls pm_runtime_use_autosuspend(), but the
> > autosuspend setting is not undone if pm_runtime_set_suspended() fails
> > or when runtime PM is later torn down by rk_crypto_pm_exit().
> >
> > If the autosuspend delay is set to a negative value while autosuspend
> > is enabled, the runtime PM core increments usage_count to prevent
> > runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> > during cleanup, this reference is not dropped and usage_count remains
> > unbalanced.
> >
> > Undo the autosuspend setting when pm_runtime_set_suspended() fails and
> > in rk_crypto_pm_exit() before disabling runtime PM.
> >
> > This issue was found by manual code inspection.
> >
> > Fixes: a216be3964c1 ("crypto: rockchip - introduce PM")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
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

Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7523B71A6
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 08:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731523; cv=pass; b=Da9kgLaicERQMZvBrMKLIWv2j2pT+T/v1ZRG57UN8+m71ok7YQmOrs8AHK7Zr1dJQiCDFFa7nIEKG8Ml4O9b16l4t9hDEoJ2jd9WRyYwPSYRydAIaD/ZxkTxWIvvOAzH3jnZL2OTcjqJOG+rE6JL71YWQRSvjA4fJwf0NHxKrLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731523; c=relaxed/simple;
	bh=KmuwxalehGuplFytR3vLTTzoSunk5f6Wa0R2J+XLigU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PAXAF0o7J1jWhCCMWgfawO4rH7By9e/dfPUUnxse7cokOQ/yZwb2SDwfem/6dxC0abVnl6I30HSfnQLTODrLSokm44rxf+2xPJScoh3PeH1F6cyvEFvWJIM+mp5MKS0H9WYg1OniSSCWguvUafCwimJcetiuaPduSdTFKvRHguw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rVoKBOYM; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rVoKBOYM"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-66c70cff944so633819d50.0
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 01:05:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787731521; cv=none;
        d=google.com; s=arc-20260327;
        b=pQbcFaue9Tw6K3sgrqmPBzJklgu8qKHj2CONdbXTJ1iwtSKUq6W/ZPd9wCfs7KSQIJ
         IexxW+QYOdtG3FIq7slein5tRYA7Fh8V7Mw+/Jc69x8nfgHUCRE76FhfEnn8XQd4K6Qz
         tQiIQip3zrViwxz/C+aXbBgB9AMOUwedZvSfGDh/WaIfhQvaTizRJHhY7wuOrmuEPyPI
         gacddHSq/nEKD9GQcdCeLqrBn1hosmdicN2xpckzPE7BptTDlNFbzBcrNpQNZMwSLtu3
         yC7qa9RsqebabOHpp+K9F/hXu7dD3bWqp9heTsaujx/PLbWlkcvnpMYQ6GWZLD/E9N5p
         uxeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KmuwxalehGuplFytR3vLTTzoSunk5f6Wa0R2J+XLigU=;
        fh=fA+HTOo13OMaJ9JTE6xasWXIkbrWxaRzWCq5L3Jf7t8=;
        b=bf/5ZFG4x8pnbre4T8HBpMveX1McCCuwi3mc0cgevu88reYMkuodIo2NDjeAH/QRkI
         Jjm3cJUi9N77TnrzYqjuWSJ4SISd1bYsbuXb0NQaAO4cUQBWHGiMGT3SOo8CWBPxZaEL
         IybEZzNUQGSONFHeykb5rTinbiUc7ZessqJSzy72PIVdxKBd9Itc3TKp+IcSX9/xci+q
         mIFJwcJzcHhhx6sMzCEQ7sagglrDoV/fBMbGMAKmrTH2NVmhMyHHO8/Eh2J5slLNe1Ds
         KSqhtSYJapQ0wIHUP/lAtruH6JtBUlLotrsd4r5LA1qFpaAAwhC0u4MRYNxP9vay01F9
         1j1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787731521; x=1788336321; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KmuwxalehGuplFytR3vLTTzoSunk5f6Wa0R2J+XLigU=;
        b=rVoKBOYMyQx/nEJ8ilxn06rd6DThfKVmJFChti3JoRTKV5oWi8kkVwKCQI/JHhsv7I
         0bg3Am7KttJBbzNoTgnoaLw/iJLwwAjxR4rVpJve+FPdTwuJetPzMhFi3wr9eypyyQMl
         tYIUUcBLHp6sYzchd74bEI7RCK7W3eyB3UBA2RFFhMJ1FIpE9QuE/Hse90Vm29gc7CFE
         aorh0Gve6tfFYw64nb59A45Kkv0+1/OF0K1IObLwUEeEr5yEkpMWv7AVkm3dpylKOdtE
         /dpa1l7ox72FgmIXsh2i6foxPTfA8Eb/lG0RTdQ5HYUuy+r39+xb6GPI3UYTxjjm0F5R
         a2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787731521; x=1788336321;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KmuwxalehGuplFytR3vLTTzoSunk5f6Wa0R2J+XLigU=;
        b=bRl4L0A6NSTx61d4+G8XBkUGqVT53g1dp3P/5cBxINe0YZFflGnyWbihOkaPRBnBZu
         xzEGW+nnIQ3jKd4vUKJxlixV236Qkzdc/RchvUPgrF6dK/E02EkpSMof32MlfFgnSUZ+
         o18OMgmC/DwNSBddMimCmeV0DbwmKsdTqy4+BKOFUF5usuH49BIyjkCBiyfZxw9sqi1o
         WWjCEJilNJ5pw5vXVzmH0B80g+9ejsyi2OlI/tlShcenxYHFUk104auWV9tKAmksSoMW
         J91e1hvB105VeYiUDWO50e2vAJqwmLWt17VgNSwjqfXuI2PRrobNib/wz1OC93rvCW/8
         1mZA==
X-Forwarded-Encrypted: i=1; AHgh+RqSBwvy4jUcdbnNTVCLpsOIONxzIcHrVBsFnpckE15a0ucsGeCCBAlhUy/964vUO9dpS4A4ArfqhGsn+2w=@vger.kernel.org
X-Gm-Message-State: AFuF++lzkFkavX7HA0nFUlomNC4vTinZ16Zf+9u5NW19tiXpAbPDNx1E
	lrBRqriWv2AQLagXMM6NPLt7ABpDiZyXA5RvZUB4r5728EtiUAoIjAkvcaQPhwDG+0K6cabOSAe
	V7qg6ZAirHMpirZTj9n1lUK1n0GqLuFQ=
X-Gm-Gg: AR+sD12iFJEPyDOXIDiBNMWimJ80TsEO0TrnRcgG7VBcv2SjOc4qp/HyqVjes7T+uVo
	9nkJcQPMgSpeSI56Z9Udd987qVgqwFY48tTvHSa94HJuDaOxJN6Fznn1RS7yDPJXZvCRYFtjbSe
	4YL2Y1W0nfu7nts/Vw8wihRdTJGKAeHKnc3deLNRAJzVjFfVV9Hb+lKeCHsIoN8CVe2HhoY+C9O
	WzKQaUPUOmR1982DQAby0FRrgSr0ATqgwCa/MiZbEmLs4x8zxxSPk+XKSbJUQAQWiAS7PQlFwl5
	EAyOsvrBNBKhDvAGWls5bz6abolGp19u6XVLdyBdjiSZalw=
X-Received: by 2002:a05:690e:4888:20b0:66c:71a4:6ef7 with SMTP id
 956f58d0204a3-66d25798ab6mr1235400d50.35.1787731521100; Wed, 26 Aug 2026
 01:05:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808093623.2744314-1-lgs201920130244@gmail.com> <56cdec83-94dd-4b9b-9c27-6bf9ce8d48e9@kernel.org>
In-Reply-To: <56cdec83-94dd-4b9b-9c27-6bf9ce8d48e9@kernel.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 26 Aug 2026 16:05:08 +0800
X-Gm-Features: AcwNN1WLK9t_-88mJlI7CZZJzYoCXYqy5liouPolaAwWkfdtLNaUTcfSb15eJoQ
Message-ID: <CANUHTR-RiXT6_rz4Wrq65FChRfZsbtb3kmn4K8xummaXOyn=wA@mail.gmail.com>
Subject: Re: [PATCH] crypto: stm32/cryp: fix autosuspend cleanup during teardown
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Thorsten Blum <thorsten.blum@linux.dev>, Kees Cook <kees@kernel.org>, 
	=?UTF-8?B?TWF4aW1lIE3DqXLDqQ==?= <maxime.mere@foss.st.com>, 
	Colin Ian King <colin.i.king@gmail.com>, "lionel.debieve@st.com" <lionel.debieve@st.com>, 
	linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

On Thu, 20 Aug 2026 at 22:50, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 08/08/2026 11:36, Guangshuo Li wrote:
> > stm32_cryp_probe() calls pm_runtime_use_autosuspend(), but neither the
> > probe failure path nor stm32_cryp_remove() calls the matching
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
> > Fixes: 65f9aa36ee47 ("crypto: stm32/cryp - Add power management support")
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

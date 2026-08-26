Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58191223336
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 08:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731505; cv=pass; b=E98raHzScUo//o9jFM7M3B1oosUMEGR5XaWArFTlFC5V5S34Wf/x1g37k1A6w+nDhAuDA3pBkREOY4oZwK21xmYdeeQjXpjJ4eoBDqcLrH1TZUVEO+QuaMNWw6vem2n73InuM2OwWhK7PoiNeEj1+s1Ey9DPwbe/m8SYSsiy4Cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731505; c=relaxed/simple;
	bh=q1ptEiUS27cJ8PNXiFVfigkQBm1gnQDUPUh9u8WMA1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qEqL8pT7HHSbI+u1AJjBS0hKCDrOzsqSv6l2E8d7uqh8YloX20MoA6AsRk95VZBfMzonwJBNym6pxkZBBlykzAd8JU2oa0nyMqXgBwu+hi9nLIarANX6/29Q/cobkZjm37qDWIhBatlcyop9f7fEEWUEQ3CF8/hpeV9021ooYds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rmutVuZJ; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rmutVuZJ"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66d0743503aso1076421d50.3
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 01:05:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787731503; cv=none;
        d=google.com; s=arc-20260327;
        b=UiUZY0roWtJ/YGDmeV7wWsvGDqXL26zU0pua6t4xFS6KkEtUd6xqX41UyqTnob+4oa
         m7B2n/V4drEIO1va/nG+BgE6m1b5yOTXeUaQBQ5Robm9Ua7MwJ5slc8rmWMmhfJKwV2J
         5vvalpM2zmQU6fwHhrvztRd0j3Qee6vmBeurc4+IKW0hJeLc1DIHZfzLlyI0Vh9q4Ycz
         MtiYWRk1ACsF5GcxmPQRD4Y37PaQCsHlD9mPNrUbzlNvHK8dH0vLtevjBUIRJU34jcm+
         w+8ud098JiI+SPaO4ooeIXWl2FktA4OGoH1g249XtWFo/1Vpq8Utf6fxuTMLyQ8gcWh/
         TF+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=q1ptEiUS27cJ8PNXiFVfigkQBm1gnQDUPUh9u8WMA1Y=;
        fh=MvGYw80IrzxtKg5fgysPrC6+dVir0LcP+Ws5h370LXI=;
        b=oZJQMJCCU0Zhu6S0sTiQzn5x9J0ec6sjDOlN+BxQW2qNskvn5W1TPP+OES1hayxPOw
         pErNg7R/jCiEgM4JqxD/QePaBm+XBXktNkiNPDeq8pHDzZilDX/c4Z6ShYyrJUus6sM9
         SNOEo1Bom18VZjmlrNK2fb/+s6coQCcclq1MnHdpxFV7MtYcxTvkp60tGil3E5Ka4C0O
         yf+lUkKs4CE4+V7XhHLVPsycGPqvgYFrF0iP5EIrU41577VlPIQq90sJGvQu8hwj1kSh
         ZqlBlCpbtz6QJ0WGdt/3Na0DRKJoRmT9cg1+2zwMTFldT/LbfoxDEM9reaCyA0qNWQnT
         UbQw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787731503; x=1788336303; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q1ptEiUS27cJ8PNXiFVfigkQBm1gnQDUPUh9u8WMA1Y=;
        b=rmutVuZJrhUkQ0WIN/iG8Jc+ObgT4mV+6DQ5NqJ/Iftbnyzqqg0y5oR7m2mUPUkC3g
         xBLQlmKoASwUVqcTwGqePoZCG49AePkUiXwC/qiFMTOkkzuL1mIXmf9acDo1NZaIsyAM
         IH6hzpsZPKYx5krW3l4ogmyTB9oW49yAIGKiSdTCnMjD7TDx1xjlWeZkFfkVCMq8Oy9R
         Se051HYJrJyrQ8HuOoA7q7ohjlrwbu+NONUal53B5vJDZNBvqxzF/6vDJEpu05CYs7pf
         EFliOComyWRxwBWNcmIomhPmZmzYV8BiIppKZDx8PdEUkJn2Ygv4FR6LiJPjKyjQxzcQ
         MCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787731503; x=1788336303;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=q1ptEiUS27cJ8PNXiFVfigkQBm1gnQDUPUh9u8WMA1Y=;
        b=WG9nubgqokm5jXynWMO2tJVvD9453TbHNYzCT3qc1D757HyWg1voPtdsuLDXxUu8SN
         wtU7Xxtf0WF3C81G30QoClohxbe2Za6jAk+A/N165jZqd7Ltff5+onfxO343aBXliqxK
         tGXw98R0tCLsm39ROhEEEszCh3q8bBzgUg7mNWPA9o0UvCkDSlaZNVxOuSXpSaz2iHCb
         b48lnLphmPyJaPyyUIYxjXF/kOvg0bDzEvsDRzqVSS0SBs8e6epUIn5wjQQOyNLhtpHG
         be3HMLVTp0iVj0aW79EEMiADvzFj60+g8MHoLw+dvBoHn5pgJMjrT06Bi9+Jwnqh+uLz
         BHGg==
X-Forwarded-Encrypted: i=1; AHgh+RpeLKY41y5xN4Ips25+yVzg7wVVYua85g5Lgqxik3MSM4MBkalCMUqZJ6Nb7+ExV/VCO+cVF4CrT3ZFUHU=@vger.kernel.org
X-Gm-Message-State: AFuF++n//GUEPErgxVCyT3J/APC23NIn2KQStnUU5mEDJtWfq/77fjQf
	0jjhacE8xDwAorBqa36zxGPp4UExIRCcnUgbm4Vlh9iHAcIWketDKZ+X8+1AzhHoOkxk1smJEE3
	HEkDRLUDApPQetTVD8KCjYvWIHh0r8Nk=
X-Gm-Gg: AR+sD10Jmkia9kuPP+gXTxFQWFKfTgyVJ4RV5mFGA5JSjEJCz5R5kz1YGGagb3QFauH
	8C1+Csol0ZCYjQdrJ3jB2ra/R/ik6eTMZENunL2AJYiFz7EK/8m3/A/1egWix7LJddSLCuGdqZY
	2X4BST/geSt0ttkhCJhHS9J2v1yABfDeAmHXZbQ6PS1HUqv5EPuCr1SgRLsHUZMO54xBGAVioKW
	fgzasUeaUI/kJEClkOtsxEEXsmF41SWwpyAUblhjg4/6plVuDmp9pt2hcYRl7AxFK/ITeWUVvn+
	rqhUIPcZKNbVI1cyRmbD2S16v0P5mLi3qJc0HcCK5tY8MI8=
X-Received: by 2002:a05:690e:b49:b0:667:dc6d:736b with SMTP id
 956f58d0204a3-66d257bd67fmr1671369d50.32.1787731502731; Wed, 26 Aug 2026
 01:05:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808084212.2704516-1-lgs201920130244@gmail.com> <cee7a7fa-25a7-4210-893b-2adeede359cc@kernel.org>
In-Reply-To: <cee7a7fa-25a7-4210-893b-2adeede359cc@kernel.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 26 Aug 2026 16:04:49 +0800
X-Gm-Features: AcwNN1VfY5pxYmdULwYtIxZ9KlhPIA1W0T9QQaUiBasP1BWhplGLoNCUt8lqaWk
Message-ID: <CANUHTR_icbJKGJGdnPAm=nrKoRnjC1_dM0oxiTNKnDzrJ-LoyQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: omap-des: fix autosuspend cleanup during teardown
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Tero Kristo <t-kristo@ti.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

On Thu, 20 Aug 2026 at 22:49, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 08/08/2026 10:42, Guangshuo Li wrote:
> > omap_des_probe() calls pm_runtime_use_autosuspend(), but neither the
> > probe failure path nor omap_des_remove() calls the matching
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
> > Fixes: 418f2a8cf2eb ("crypto: omap-des - use runtime_pm autosuspend for clock handling")
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

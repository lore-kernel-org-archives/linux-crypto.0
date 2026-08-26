Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D94D39DBCF
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 08:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731976; cv=pass; b=IshoVQx+C1U472+FER9TAGu6L8ldpfC1LzT+WnI6gKJN3Hhi80M5i6U0o09ycmoH0pvIB4M79IowXsLzR6kJ8srIOKaCHihaxJ7nvGnyBX+OsqAAv6UbABoOuk/ewthDunjSN/yTrRS9pp4D/Ek+QL1F2rqenJ2QbtbXhrAUCVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731976; c=relaxed/simple;
	bh=kAHZOCv7XkuLEBc02Z7R1yP0Zw1Cy7+DYa/ywssttks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dlCPmI0mLQc7wu3WnK9Wl2WUIQYu9n9RHMvhY8Wa7xA38pLBn7qAzijaVXQPJ3Wk++2ltxPqhphme7Py+8I8jcGt3kXP9q/cTCTfnQx5QlJVxiDxjXRYyWsUc2Fy8jw7szvbv6CGI0KnIvGBI5923cPWj3ZsAV8GP0SuleJcaRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IH41UP65; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IH41UP65"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-66c9995ca60so2910230d50.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 01:12:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787731974; cv=none;
        d=google.com; s=arc-20260327;
        b=YxeRFov4ZLg0uOt3bUvop3lxy1i53u3i4o5nPYA/2S9Qd/DurA/TQi3qOvmIa4RYqh
         YF9iFeNLU9jroutFWuW8kpLYC8TCaYuyXJNEwi2erSCjx6VKgWlGlZRMkQzdihstcD9a
         5tChtdS236Oyy3VGZaaFNxf+2GKbXNL7/x5do9Jz5gaEqfh7wHE3vwIauXnbhzGJlnXm
         CTtX0R9sWfLmT2aMupnMxmBLK2ntaJQfguGjx3JbWRJn6oZ3izwsYoaaANXs8qaraZ89
         QVjdqdDhF3f9Ey0Xz56VQUzoSrgyXVzFY8ylllDR/JMLQunMfdgfbyJer/a7HfaEZR6a
         tngQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kAHZOCv7XkuLEBc02Z7R1yP0Zw1Cy7+DYa/ywssttks=;
        fh=YvCLO9gGE/+VS/NwfjgNM241l4ywbqE85GTBtXGGygo=;
        b=fmMprBICtxjbM3Kjxjkccsm47kJE/f5/lhWsMnrjtpUJLnwhLfbhsI9pWSXrDl6eEt
         fv+dr+/QZdxr7OkWOY5ngYJsrcqlGkarLEqS5jhRpLvoGag12D62pTAGfl2wXYqJHH6R
         EA9Hgyup/p+wfBVE5FpkiQx509JbRkepQTzI2+lNJX4cQuCiM4V7XbiIWNRtq+mCWvTC
         jWyBCGcnTJYIoI/sCTayjG2zVaR0DfBp3g7UH/zDWQhWHHKkIZwVEP9hgxro6YA3W8ng
         IvdK96kRiptZ34NYe2cEeoDVTkAKZPPBXAS1qfnjzNIAltfYG7Lf3vu+e94v80SgOq/P
         PO4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787731974; x=1788336774; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kAHZOCv7XkuLEBc02Z7R1yP0Zw1Cy7+DYa/ywssttks=;
        b=IH41UP656+esuAlMfRC334PIae4kSk1F/SjEylJRZjLgfosVUIIeVgAayldx6xOEuT
         l3QZnQ3jN1iCZ7PA1aFvYqAMXWBWDouodHB/Xrg4/SxVPWiXiAGh5Msl38ZGc8KEu8+x
         rQAyug9MFePQA15JR3/6nHKJ3xzAPxIPyGnVMbHETc+xrM3/NYYWppcc7shZWcdd+s4Z
         UKYbIS6wPxq4WKHE3EuscEwpaY9bc4oONMq2B7IcBe9SbSgWl86g07ZIR+TK4ao0lfvq
         +iInecQsA3datfwJ+8YQQerSSjXNR127CUTYyj5NLbZriQs5nbO+tcFdvftW7sldovK0
         4CDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787731974; x=1788336774;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kAHZOCv7XkuLEBc02Z7R1yP0Zw1Cy7+DYa/ywssttks=;
        b=m+H5HOmHtOJGD/gxQnFdO4zR34s8CNV3Dj+O8utKumUqwafAvGd4MOUUstFuApKySy
         AyJw+0g2EzDEOii6WF22FyFRjXQLCU6tWW8lvDRkRgspwyZl0Xe7lAV+5IsX8T2W/QDj
         L4OxJ6VfnekGvvHgd79ktDp9MDCfPFibxd+IXfYhLvH045os6e+Twq8nZ+BtEawpe2Ce
         IfqnIR9vfAOYgc6VbFRCWMe0nXBlY/dT4/20qAyhZFAiuC2LkeKwwaXqrX98jkVmqp2B
         claXHJ/pIPX+mB+vI2NJOjOEVHwR/Sbyj7y87lXAnXMkLhYcL/4OeI/mdLThJ8aCxWs8
         xGTA==
X-Forwarded-Encrypted: i=1; AHgh+RojKJvnhlP1KBCERS3i5q76AJYgyJMr9V1RqSVonoEy7i+/uaMQrxipV0XyCBKG2IuxFGqiiuQk2RH/g4o=@vger.kernel.org
X-Gm-Message-State: AFuF++nuh8sB88wiwosYfKXrt7jAq0xecLQCHYwHHtZH8tcNve8rC/ss
	oWOl/Jwpk2zORjAJ5f1WD7eZqe1Agbkrh3s094m7o+HUoWKdvoYjPjFhR7OIyVgLqJWdFIA0jim
	ejGqgkRfHgkFEPiJaC0910Aanm/8eKGQ=
X-Gm-Gg: AR+sD121BUzpZ2+Z3SxKJJ0q8P5Lj2/JK79GWwA9ecFFZELPbdGXrJfhuAhKk6W5h2X
	MA1EuiM3M3uaJEHXhXcBNeb71AtNzsi/EXnqCE7uQAuUu/GUUiJ7UKUkkpOCd/xi7JVJn7bVKc6
	kf8GmyNaB9J3WIbFwKiQ8f9bKUFxz7czn8DGpH98GqlDiGYTwtXApMhELGJumzOpkiY2KsD8IHl
	OhrHPUe2YhjgWHjMNZ3o3WBVHOqPmKJpPGzAN7GLtHZx+RYsQ6TimMbgZUFYMzdC7WsRbRl7Ekh
	1+kdQ+SHJqEZTiyBw36L2ohoKBsNfqXdvHx7UhGSVTvxdqo=
X-Received: by 2002:a05:690e:1383:b0:66d:1a0c:d76d with SMTP id
 956f58d0204a3-66d1a0cea32mr3414212d50.5.1787731974283; Wed, 26 Aug 2026
 01:12:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260808064145.2615010-1-lgs201920130244@gmail.com> <4c21c057-a928-4723-86dd-2caffc7b0800@kernel.org>
In-Reply-To: <4c21c057-a928-4723-86dd-2caffc7b0800@kernel.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 26 Aug 2026 16:12:42 +0800
X-Gm-Features: AcwNN1UVRBXcZNCO39BCfYIp8FDpd17lRa5gn2KW9t2S0yPH-CXmwS9IVC-apKI
Message-ID: <CANUHTR-cUxCjjiyUsTt4=mG=S845oZVG+2OkMvOU2Ed5-DDV2A@mail.gmail.com>
Subject: Re: [PATCH] hwrng: cctrng: fix usage_count leak when
 autosuspend_delay is negative
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

On Thu, 20 Aug 2026 at 22:48, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 08/08/2026 08:41, Guangshuo Li wrote:
> > cc_trng_pm_init() calls pm_runtime_use_autosuspend(), but
> > cc_trng_pm_fini() does not call the matching
> > pm_runtime_dont_use_autosuspend() before disabling runtime PM.
> >
> > If the autosuspend delay is set to a negative value while autosuspend
> > is enabled, the runtime PM core increments usage_count to prevent
> > runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> > during teardown, this reference is not dropped and usage_count remains
> > unbalanced.
> >
> > Add the missing pm_runtime_dont_use_autosuspend() call before disabling
> > runtime PM.
> >
> > This issue was found by manual code inspection.
> >
> > Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
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

Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169108467
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051624; cv=none; b=UtIGSt1h7XO+SUmae4J+pxEVKfAhMvHcBicAdkdyr37BBecNxDSJK9lWfGn8iBslbEDRa8w4KYv6yA7wnej9irCQ2uS2ebCOo04WYdarpJcmSIGMDk1UkcmJo+zMswzgwgIbAWYLzhlOrXTytCGiq2FSJleQ3Xi2r5ddAmX/PQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051624; c=relaxed/simple;
	bh=8WWWgeWVvcbHTtv0RBP4r1XUoDGKd++Wm/OvMpeSFds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cc/Zr8f8fJ1Kchq64uBneTmXOcNLj8wsvoswMXGl9eE0W2oTxd+rpn0Av1x88jSokYZp5Bye+pxYqMvuMHNwD/EljcsTn3pP0c8F0+7uTMvoKVVAN2ubj20AjNoOV4J9DKXLCKDZsgHyq0ZYpT40NqEKSAi+XozmH3HLmvQmrzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XMUMeQXc; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XMUMeQXc"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-54b1095625dso5205212e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051621; x=1747656421; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WWWgeWVvcbHTtv0RBP4r1XUoDGKd++Wm/OvMpeSFds=;
        b=XMUMeQXcovQjNx2ZimJu/UlqDDyOLDgmgXlXFs61Pa1G1nF55+GUxWlksRbU6CUwhT
         gmCp0iTOGcZmx/l/og07QRf7BcOtbvtJg66+/2vv8CNLGfxqJ2X91Ti3FB61BQ23No03
         /lsxpICPQtwjBYskvVugWN10OsPnA8r4LLx0aLKJ05M05erHs9c9VoanTcvRX4f2ZAmO
         4XfOqlTHcJuYkq+KPFRHt/KxGioYhc6omWxxXaqRBiwrJC/TxZFiABx2EvJVKPkxJCEr
         aC9c5tBv0y3WcczQHl/dbkjO63tR4Yzd9ob2JfbJjEgI2k5nTjgCjvjNc/7Z8mf8Om9D
         NyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051621; x=1747656421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8WWWgeWVvcbHTtv0RBP4r1XUoDGKd++Wm/OvMpeSFds=;
        b=ZHUKSJsUQz33I9jD8fwns9/b7zqFXKbXIxcPuPSO5LRXUpbcRmshE8OMNxdtCEmKHU
         OGVFIEclx2QPPzQppARXlXDmRg/bjCrTIUedBbWGhtEAk/eSFXHQTr2+hlsnNyTUr5UT
         7oI667/eOp2K+XLVsmxgnCD5/7eLNaR7Zn07vGKxAU9vt7ALr8EkK2gyQyXY+MRUw7Lf
         deAxIcNTsmmnGxOwwoJprncckYfUngeMiST3i4/yTmJuOL6RVt/onlRfER79RQKUk9DZ
         7FXYos9pd36umgBGqa/nB/7UPMnYnjfUo/maJARWnGmTXKjdznAlwQpdl+gRhZaVU2JR
         dFkw==
X-Forwarded-Encrypted: i=1; AJvYcCUXhfbjGOYrWKL3N0UgBYerYeDltT8J/2lh1sNno2YWZgpb93tyLqDdjsyuPdZMXrZCEd0yc/mFNBahoWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6CMT3EVBfWNi/tv3LH349oUYZwqhoxjD+9KYNn/+hJcMUsNoA
	BbWlvOXVVn2dt71IHxGvjJPK3A0NVMblRCWl5YmIKKvDoKJkrtj3hqQ3o3pUNECLXQn8eEvQh4I
	efXlyDNqm5kuhWu+31skliEUL1HqU2ZegigJl+Q==
X-Gm-Gg: ASbGncvNERoYkLOYughIdBnGWF+nnfFrBFh2BkF4ybvVoDTWEEumtDyY4MoYeaX9YFE
	BhQM+eQJcVjh+rCH8Avob0G2Qg1EHpX8AKWolaX4UmqTDCl2OFa7UhYVLeVBpebG2jou0cIgIEP
	XyKXqt/XNDWPHQHCNqqIbBVt8TKBqqYHN8
X-Google-Smtp-Source: AGHT+IEx8k4So5xIBQnsOvPLJlE1JiI/knZvAo1IR6NtL1z/XpXpp8RjehZWw4mU/3r3Q3kmxi4fVz2sQoxO2BBk9mc=
X-Received: by 2002:a05:6512:6602:b0:549:38eb:d694 with SMTP id
 2adb3069b0e04-54fc67c477emr3402667e87.26.1747051621225; Mon, 12 May 2025
 05:07:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
 <dc47e9ba-e23d-45d2-bae1-cac8bac2310b@broadcom.com> <ac86467d6f0b2c531f7d1356ade78e17@mail.gmail.com>
In-Reply-To: <ac86467d6f0b2c531f7d1356ade78e17@mail.gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:06:50 +0200
X-Gm-Features: AX0GCFuoFVJJ2KLgVFQoQTOvfp299H6PlFukenI3FYuId0cEte28aXrmVaRLmh4
Message-ID: <CACRpkdY0_u_7J_6JLAiVRz-oX+UZViUhyD0fSfi2u3ogVOPdbA@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] ARM: bcm: Add some BCMBCA peripherals
To: William Zhang <william.zhang@broadcom.com>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Anand Gore <anand.gore@broadcom.com>, Kursad Oney <kursad.oney@broadcom.com>, 
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Olivia Mackall <olivia@selenic.com>, 
	Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 10, 2025 at 3:11=E2=80=AFAM William Zhang
<william.zhang@broadcom.com> wrote:

> > Linus can you resubmit a v3 addressing William's feedback? I will drop
> > your series for now. Thanks!
> > --
> > Florian
>
> I wonder if you get a chance to review my feedbacks on this series?
> Let me know if you have any questions.

Sorry William, it fell off my radar!

I fixed up the patch set and resent a v3 now!

Yours,
Linus Walleij

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736FB440634
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 09:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789465566; cv=none; b=ec0UFv8vXU9Gf++lTL7RokXgYYdQEfhMZHVHUolBymu85pJiPChssTjuejqQXU0Ba29JEPvMzFjEAXJo+1sXbmNWN4ur1WesRZhxbEUkv6eB0fODHrmrFYGZRKJgCojB6fRWuyxdD50AlfGJuTfRETRgmFePotyl8yV3rKbxho8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789465566; c=relaxed/simple;
	bh=TYjlm49BcWGKYpnUBnCMfZXgukHwMwdEfFaJhxbKT68=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YnIsSrex72KfCiogRxv4Jy6UkXDGdiAK9CSqBtlcyxo7GdpPSrNGTqVoMBN3eaHB34GwEnNWy/UTAFqWo5Ciu1B6DinvEgBIDrcOepMoQOHLIq4K89ovoEmS8PNUi3T17/y07JLWbU0uVslGnmIyfNzF9+Rclh0MGpp5fFYbPsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyfnwXLX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyfnwXLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349551F00898
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 09:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789465565;
	bh=xStObR1AHBg+HAP7HHBUo5VDjO6oJ/f1Z1Tj8oztVU4=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=oyfnwXLX48RQwrS1wsfWxQwmFFFAH0izC6vi9efX6StFqPtqfK7nB+twLT/kIDZwB
	 5r9YhH2t3a0BBMv7zPc0TsCX6H7ooHhXrdZiWelsWgzy7ICWlL8ktNWIx3Xh0J2DeY
	 urldKxypsr7wEjiCmKn9yzws5061Tzxk8kWbgJdSFhdEHkTPvqgZhhhTZe9MKvySnf
	 mizJwZQgR57exQUy0aN5DikXTxe+ZAsjQwtFzp9xg7/FqZ/cYg3X9IzwwNZyfr4Z+4
	 6AR+OKCMSVe8fvE+BDWs6IiYtS083UTETU0RjPvGeRuyRrMHHFcvAb6Bn1iuhwe38J
	 NxZfqH+tnPCEA==
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a59fa3112cso762061fa.3
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 02:46:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxhx2/gW4TJAzF+yM/OA2/Z75Cy42aA8Z3XP88HFYC1b5tFhj+jAriEVMpD2FDcu1iBd24V3o7tfeq4I58=@vger.kernel.org
X-Gm-Message-State: AFuF++k+KfSgkf6GFa5RjuYhic3frJc/T6bOZ2tVZpYnX72TE+QvSmG+
	5Em2dWuDUZheFF/bzzaazPndPJgMwO5WOT2YMlCgWnykcUQEZ/GE1z1p2X/EB1xaR704K7X6HUE
	TjmcYN3o48QKjQ3WU69H2Z/m0kka06iGfIFSy9pxTcg==
X-Received: by 2002:a05:651c:1508:b0:3a3:7680:67fa with SMTP id
 38308e7fff4ca-3a5d854ea14mr822991fa.25.1789465563847; Tue, 15 Sep 2026
 02:46:03 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 04:46:02 -0500
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 04:46:02 -0500
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <c08519bb-b912-4d34-a164-5a9d65162716@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
 <20260910-qce-fix-self-tests-v7-9-cdbd2718af14@oss.qualcomm.com>
 <20260910143140.GA5719@quark> <CAMRc=McDHXWRfYTwRasdBCXMnoVkXK9T7RB+gBNgCsGof-euyg@mail.gmail.com>
 <c08519bb-b912-4d34-a164-5a9d65162716@gmail.com>
Date: Tue, 15 Sep 2026 04:46:02 -0500
X-Gmail-Original-Message-ID: <CAMRc=Mf6A98R_NxFaBiMp+N8JuzwZsSdfowwe0XvkMsUCZCL5A@mail.gmail.com>
X-Gm-Features: AcwNN1V4irG-4tqXUxafIvp3ue4djdPcZGWZ9wnurkMI_vMMG3_EP65uAHzLt8c
Message-ID: <CAMRc=Mf6A98R_NxFaBiMp+N8JuzwZsSdfowwe0XvkMsUCZCL5A@mail.gmail.com>
Subject: Re: [PATCH v7 09/12] crypto: qce - remove the BROKEN label
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Bartosz Golaszewski <brgl@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 11 Sep 2026 20:35:58 +0200, Demi Marie Obenour
<demiobenour@gmail.com> said:
> On 9/11/26 07:14, Bartosz Golaszewski wrote:
>> On Thu, 10 Sep 2026 16:31:40 +0200, Eric Biggers <ebiggers@kernel.org> said:
>>> On Thu, Sep 10, 2026 at 03:00:50PM +0200, Bartosz Golaszewski wrote:
>>>> All self-tests now pass.
>>>
>>> Have the other bugs that were reported been fixed?  For example:
>>> https://lore.kernel.org/linux-crypto/20260723202704.GB110634@quark/
>>> https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/
>>> https://lore.kernel.org/linux-crypto/20260723205342.GC110634@quark/
>>>
>>
>> I will get to these too. For now, the series allows the self-tests to pass,
>> I assume it it's enough to not keep the BROKEN label.
>
> Personally, I think the driver should stay BROKEN until all the
> known bugs have been fixed.  The self-tests aren't enough for HW
> crypto drivers.
>
>>>>  	help
>>>>  	  This driver supports Qualcomm crypto engine accelerator
>>>
>>> As this patch would make the kconfig option visible again and would
>>> result in everyone running "make oldconfig" being asked about it, it
>>
>> I don't mind changing the symbol if you prefer it to avoid any accidental
>> `make oldconfig` carry-overs.
>>
>>> needs to be fixed to accurately document why anyone would want to enable
>>> this option.  As you've stated, it's actually just for "testing".  The
>>> false claim that it's an "accelerator" also needs to go.
>>>
>>
>> "Offloader" for lack of a better word?
> Could it be called a "decelerator"?  That would give users an idea
> of what to expect from the driver.  Maybe explicitly mention that
> you will take at least a 50x performance hit?
> --

Yeah, very funny. Jokes aside: "Offloader" says what it both *aims* to do and
really *does* without claiming it *accelerates* anything.

Bart

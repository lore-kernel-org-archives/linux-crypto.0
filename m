Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BE12FD694
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 07:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784878589; cv=none; b=EVFYHUcjl20N6+dP+WihEbwzFXO2dYKQZN2QLV98Hb5sGqeNFABRCkA8sSqD+jLlboZVQkcQlKMxZoQtQetC3KBwvA37DTWj2d1htP6XXsWf+D4SUH4mzQqcekyn9uqcJ7ONwTXypgQfi/N0DRG06mHW+OV8hPEVosVbiG7Yn9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784878589; c=relaxed/simple;
	bh=5FtLBMpQqcwilJSh6kla1fOiGISZIbkb6Rq7aIZtlFc=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pKudbfwJPEtTB+M9fe+hYsnarAhULtIadwnQkGzsH4T8Qclge1GS1d4ebPpM5x5ktFmPrtIKm1Bo0yqWvpqK1e/LrmJQdbYVQBFnGATY5SRQR00NGz4sWGdjA1g4asC23Yp31lblAr7nMc9yvkVTKWJUqXeOGyNKXMGO/8vT9pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLy06/I0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLy06/I0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88771F00ADF
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 07:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784878587;
	bh=eFnDdKu3Hxl7FTSkySekyyZQVF8xWD+m4hHcrRsAWRQ=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=MLy06/I0fd8Uq55S3u0uGmXIyTABIzm9KivElpqsecq90DoPS/uGrgW/wgMMUKGa0
	 NUI9lKLp2yOC3a61ntTBsbFGIiXyj+dOWY0vewNZr2FO3VMeWJ+lhpJ8WIGWOfmF53
	 qN/Gkv29CIf3B5XvZYifZGSgfKNSSqNGF7JfrxLQbWBp4HYKyvHzV5Xofyza72pxrd
	 iH39CspY+C/5EM74xFsFleT9Xmp3ToX79d03DbO1pxV2sIkxB3a/bvQhkaTA5kqo3R
	 Hm1CmGQq8x4mio7bTIzIwMHpPlLx/V7zPio5tZBeGKd+IEJGwSPrkUIeVZX848FNY5
	 i/RxPFrLD+xRA==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39da69c5ba3so983181fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 00:36:27 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxi6exZlVWgUoRLBuCBT/5Nfz3j9hFnpieLb9HGABxy0PnMiazw
	j4HT1jTgrl9X7yf22MvE1n84SlXVEvOXyJN4GxLl6sxTwqRsPSof1n3MxbAEqr5CPJe/I9v+Lip
	F4UAIX5EQioIdDs3wRi0nB81mFMy5xTdIhSMas2u7wg==
X-Received: by 2002:a05:651c:b1f:b0:39b:4371:dbeb with SMTP id
 38308e7fff4ca-39f07f1978cmr14723081fa.36.1784878586411; Fri, 24 Jul 2026
 00:36:26 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 00:36:24 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 00:36:24 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <2026072410-drained-acts-3502@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724050645.223799-1-ebiggers@kernel.org> <2026072410-drained-acts-3502@gregkh>
Date: Fri, 24 Jul 2026 00:36:24 -0700
X-Gmail-Original-Message-ID: <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
X-Gm-Features: AUfX_my5XZyE7UqXKRq4QXkQ89HpYi6P6qHi08NgO2eVL5ur0W8C7gKD-xXnu0M
Message-ID: <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bartosz Golaszewski <brgl@kernel.org>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 24 Jul 2026 07:28:53 +0200, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> said:
> On Thu, Jul 23, 2026 at 10:06:45PM -0700, Eric Biggers wrote:
>> This obsolete driver was already marked as BROKEN.  However, keeping
>> BROKEN code around in the tree is unnecessary and causes problems.  It's
>> much better to just remove it entirely.  Let's do that.
>>
>> Crypto acceleration remains well-supported on Qualcomm SoCs via the
>> Qualcomm Inline Crypto Engine and the ARMv8 Crypto Extensions, which are
>> what Linux actually uses in practice.  The obsolete QCE driver is a
>> dead-end approach.  It's extremely slow and just doesn't work well.
>>
>> While there's been discussion around using QCE for restricted media
>> content protection, that functionality has very little to do with the
>> current crypto API driver and belongs in a separate, clean proposal
>> (likely under a different subsystem/directory).
>>
>> The extensive reasons for marking this driver as BROKEN were already
>> documented in commit df373d39c6f0 ("crypto: qce - Mark QCE as BROKEN").
>>
>> Since then, it's also been found that under realistic workloads, the
>> driver is not only ~48x slower than ARMv8 CE, but due to massive driver
>> overhead it actually consumes significantly *more* CPU cycles than doing
>> the hashing directly on the CPU -- with much of that time spent in
>> non-preemptible hardirq and softirq contexts
>> (https://lore.kernel.org/linux-crypto/20260724020608.GA51735@sol/).  The
>> proposed BAM locking fixes would only further degrade performance.
>>
>> Additional bugs have been found as well
>> (https://lore.kernel.org/linux-crypto/20260723205801.GD110634@quark/).
>> Pending fixes for some bugs don't change the big picture.  Nor have
>> security-related claims held up.  Of course, these issues are largely
>> moot anyway when this driver's functionality isn't being used in
>> practice, beyond the module loading due to it being in the kconfig.
>>
>> Note that this removal does *not* imply that various other drivers in
>> drivers/crypto/ don't have similar issues.  They do.  Rather, the
>> evidence is just exceptionally clear for this one, in part because
>> hardware availability has enabled independent testing.
>>
>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>

Greg,

I'm against removing this driver but I have a kernel driver policy question
before I start arguing the case: If I say that I do use this driver and that
I volunteer to maintain it and had already started sending out fixes, can
Eric still force its removal? Because in this case I can name a whole lot of
drivers that I deem useless that we still keep around.

The alg priority of this driver has been decreased below that of ARM CE and
since CRYPTO_ALG_KERN_DRIVER_ONLY it can no longer be used accidentally by
user-space either.

Even if in practice the driver is used for testing purposes - does this warrant
its removal?

Thanks,
Bartosz

From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: [PATCH 1/5] crypto: talitos - add hmac algorithms
Date: Thu, 17 Nov 2011 09:01:16 -0600
Message-ID: <CALg11mhubBSZU=MxX_MAw115w5fQT6_v7mbQ74E=ZdWX6yt_2A@mail.gmail.com>
References: <20111116181916.e2473c5856b852dea7bcf83f@freescale.com>
Reply-To: lee.nipper@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45337 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab1KQPBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Nov 2011 10:01:17 -0500
Received: by ggnb2 with SMTP id b2so1149527ggn.19
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2011 07:01:17 -0800 (PST)
In-Reply-To: <20111116181916.e2473c5856b852dea7bcf83f@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 16, 2011 at 6:19 PM, Kim Phillips
<kim.phillips@freescale.com> wrote:
> From: Lee Nipper <lee.nipper@gmail.com>
>
> Add these hmac algorithms to talitos:
> =A0 =A0hmac(md5),
> =A0 =A0hmac(sha1),
> =A0 =A0hmac(sha224),
> =A0 =A0hmac(sha256),
> =A0 =A0hmac(sha384),
> =A0 =A0hmac(sha512).
> These are all type ahash.
>
> Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
>
> Fixed up to not register HMAC algorithms on sec2.0 devices.
> Rationale (from Lee):
>
> on an 8349E Rev1.1, there's a problem with hmac for any talitos
> hmac sequence requiring an intermediate hash context (Pointer
> DWORD 1); the result is an incorrect hmac. =A0An intermediate hash
> context is required for something longer than (65536-blocksize),
> and for other cases when update/finup/final are used inefficiently.
> Interestingly, a normal hash (without hmac) works perfectly
> when using an intermediate context.
>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Thanks Kim for re-submitting this patch, and the fix for avoiding
sec2.0 problem.

Since I don't have sec2.1+ h/w, I won't be able to hammer test it. :(
Does AH IPsec now function with talitos hmac with this patch ?

Cheers,
Lee

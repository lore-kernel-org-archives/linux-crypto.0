From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH][RFC] crypto: talitos - add hmac algorithms
Date: Thu, 29 Apr 2010 22:13:29 -0500
Message-ID: <20100429221329.b386cecb.kim.phillips@freescale.com>
References: <4bd82b35.064c640a.62c0.4de1@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:35336 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0EAHAG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 May 2010 03:00:06 -0400
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o3U30qTZ025496
	for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2010 20:00:52 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net [10.64.32.10])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id o3U3B4Dj002660
	for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2010 22:11:04 -0500 (CDT)
In-Reply-To: <4bd82b35.064c640a.62c0.4de1@mx.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 28 Apr 2010 05:33:57 -0700
<lee.nipper@gmail.com> wrote:

> Add the these hmac algorithms to talitos:
>     hmac(md5),
>     hmac(sha1),
>     hmac(sha256),
>     hmac(sha384),
>     hmac(sha512).
> These are all type ahash.
> 
> Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
> ---
> Currently on an 8349E, there's a problem with hmac for
> any talitos hmac sequence requiring an
> intermediate hash context (Pointer DWORD 1);
> the result is an incorrect hmac.
> An intermediate hash context is required for
> something longer than (65536-blocksize), and for other
> cases when update/finup/final are used inefficiently.
> Interestingly, a normal hash (without hmac) works perfectly
> when using an intermediate context.
> So, I solicit any hints/help for figuring this out,
> since this hmac patch is a bust without this being corrected.

I set up an IPsec AH transport mode tunnel between a sec3.0 (8572)
doing crypto in h/w and another in s/w.  When trying to tx a single 64
byte ICMP packet from s/w crypto host to h/w crypto host, I get 2728
(!) talitos IRQs all at once:

[root@hagrid ~]# grep tali /proc/interrupts 
 45:     161575          0    OpenPIC         Level        talitos
[root@hagrid ~]# grep tali /proc/interrupts 
 45:     164303          0    OpenPIC         Level        talitos

and no ICMP reply...will have to investigate this further.

Kim

From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: mv_cesa hash functions
Date: Wed, 22 Feb 2012 21:10:46 +0100
Message-ID: <4F454BC6.7000409@gnutls.org>
References: <005b01ccf162$64bd0520$2e370f60$@org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 'Sebastian Andrzej Siewior' <sebastian@breakpoint.cc>,
	uri@jdland.co.il, linux-crypto@vger.kernel.org
To: Frank <frank@debian-nas.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40287 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2BVUFJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Feb 2012 15:05:09 -0500
Received: by wics10 with SMTP id s10so291819wic.19
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2012 12:05:08 -0800 (PST)
In-Reply-To: <005b01ccf162$64bd0520$2e370f60$@org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/22/2012 02:03 PM, Frank wrote:

> Hi,
> 
> After doing some trials with hardware crypto offloading through usermode interfaces (af_alg and cryptodev) to Marvell CESA accelerated ciphers and hash functions with the 3.2.4 kernel's mv_cesa in Debian Wheezy on a Marvell Kirkwood system, I've noticed the following kernel output when I load the mv_cesa kernel module:
> 
> [490889.448060] alg: hash: Test 1 failed for mv-sha1
> [490889.452786] 00000000: c1 94 3f 2e a2 41 ce 88 d5 47 07 43 c4 a8 17 5d
> [490889.459368] 00000010: 77 e8 47 ca
> [490889.464321] alg: hash: Test 1 failed for mv-hmac-sha1
> [490889.469493] 00000000: 06 71 4d 7c cc cc b5 cf 1b d6 c7 ab d0 25 c4 21
> [490889.476068] 00000010: 66 0b 8e 70
> Using SHA1 in a ssl/tls handshake fails in tests with mv_cesa loaded, which might be related to this.


It might be related. I noticed the same issue in userspace with
/dev/crypto. It can be solved by adding a 50 ms delay after the
encryption, decryption and hashing operations. (a delay less than that
didn't work).

regards,
Nikos

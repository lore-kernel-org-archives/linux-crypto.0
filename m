From: "Frank" <frank@debian-nas.org>
Subject: mv_cesa hash functions
Date: Wed, 22 Feb 2012 14:03:38 +0100
Message-ID: <005b01ccf162$64bd0520$2e370f60$@org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "'Sebastian Andrzej Siewior'" <sebastian@breakpoint.cc>,
	<uri@jdland.co.il>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.leavis.eu ([46.182.104.51]:42064 "EHLO mail.leavis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab2BVNYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Feb 2012 08:24:12 -0500
Content-Language: en-us
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

After doing some trials with hardware crypto offloading through usermode interfaces (af_alg and cryptodev) to Marvell CESA accelerated ciphers and hash functions with the 3.2.4 kernel's mv_cesa in Debian Wheezy on a Marvell Kirkwood system, I've noticed the following kernel output when I load the mv_cesa kernel module:

[490889.448060] alg: hash: Test 1 failed for mv-sha1
[490889.452786] 00000000: c1 94 3f 2e a2 41 ce 88 d5 47 07 43 c4 a8 17 5d
[490889.459368] 00000010: 77 e8 47 ca
[490889.464321] alg: hash: Test 1 failed for mv-hmac-sha1
[490889.469493] 00000000: 06 71 4d 7c cc cc b5 cf 1b d6 c7 ab d0 25 c4 21
[490889.476068] 00000010: 66 0b 8e 70

Using SHA1 in a ssl/tls handshake fails in tests with mv_cesa loaded, which might be related to this.

Regards,
Frank

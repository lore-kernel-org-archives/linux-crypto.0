From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] Geode: Copy the IV back for chaining support
Date: Fri, 7 Dec 2007 19:34:56 +0100
Message-ID: <20071207183456.GD24292@Chamillionaire.breakpoint.cc>
References: <20071207182447.GB24292@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39482 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbXLGSe5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 13:34:57 -0500
Content-Disposition: inline
In-Reply-To: <20071207182447.GB24292@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sebastian Siewior | 2007-12-07 19:24:47 [+0100]:

>This is required for one or two crypto users in tree which
>chain the IV.

Snippets from tcrypt mode=200, before the patch:
| testing speed of cbc(aes) encryption
| test 5 (192 bit key, 16 byte blocks): 1 operation in 3109 cycles (16 bytes)
| test 9 (192 bit key, 8192 byte blocks): 1 operation in 680945 cycles (8192 bytes)
| test 10 (256 bit key, 16 byte blocks): 1 operation in 2143 cycles (16 bytes)
| test 14 (256 bit key, 8192 byte blocks): 1 operation in 757506 cycles (8192 bytes)
| 
| testing speed of cbc(aes) decryption
| test 5 (192 bit key, 16 byte blocks): 1 operation in 3222 cycles (16 bytes)
| test 9 (192 bit key, 8192 byte blocks): 1 operation in 706132 cycles (8192 bytes)
| test 10 (256 bit key, 16 byte blocks): 1 operation in 2279 cycles (16 bytes)
| test 14 (256 bit key, 8192 byte blocks): 1 operation in 781974 cycles (8192 bytes)

and after:

| testing speed of cbc(aes) encryption
| test 5 (192 bit key, 16 byte blocks): 1 operation in 3401 cycles (16 bytes)
| test 9 (192 bit key, 8192 byte blocks): 1 operation in 680604 cycles (8192 bytes)
| test 10 (256 bit key, 16 byte blocks): 1 operation in 2177 cycles (16 bytes)
| test 14 (256 bit key, 8192 byte blocks): 1 operation in 756906 cycles (8192 bytes)
| 
| testing speed of cbc(aes) decryption
| test 5 (192 bit key, 16 byte blocks): 1 operation in 3567 cycles (16 bytes)
| test 9 (192 bit key, 8192 byte blocks): 1 operation in 705889 cycles (8192 bytes)
| test 10 (256 bit key, 16 byte blocks): 1 operation in 2317 cycles (16 bytes)
| test 14 (256 bit key, 8192 byte blocks): 1 operation in 781241 cycles (8192 bytes)

it is about 9% slower for test 5, the others are less than three percent.

Sebastian

From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [v9 PATCH] crypto: caam - add support for RSA algorithm
Date: Mon, 4 Jul 2016 08:32:44 +0000
Message-ID: <AMSPR04MB5360073EB4B1C100F155FCFB8380@AMSPR04MB536.eurprd04.prod.outlook.com>
References: <1467387085-12212-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160703074358.GA25820@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Horia Ioan Geanta Neag" <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0073.outbound.protection.outlook.com ([104.47.2.73]:32864
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932739AbcGDJGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 05:06:21 -0400
In-Reply-To: <20160703074358.GA25820@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> Sorry, but this doesn't build:
> 
>   CC [M]  drivers/crypto/caam/caampkc.o
> ../drivers/crypto/caam/caampkc.c:17:28: fatal error: rsapubkey-asn1.h: No
> such file or directory
> compilation terminated.

I can't reproduce it. I tried on powerpc, arm and x86 (even if caam is not
present for x86). I've successfully built caampkc as built-in or
as a module for powerpc and arm.

I use git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
on latest master branch (27710b8ea3defcbd7d340dbd0423d911b4eb7c4f)
with my commit on top of it.

Thanks,
ta

From: Cristian Stoica <cristian.stoica@nxp.com>
Subject: Re: [v9 PATCH] crypto: caam - add support for RSA algorithm
Date: Mon, 4 Jul 2016 09:06:19 +0000
Message-ID: <AM4PR0401MB1876BEAE53531C7CE64128D7E7380@AM4PR0401MB1876.eurprd04.prod.outlook.com>
References: <1467387085-12212-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160703074358.GA25820@gondor.apana.org.au>
 <AMSPR04MB5360073EB4B1C100F155FCFB8380@AMSPR04MB536.eurprd04.prod.outlook.com>
 <20160704083612.GA31386@gondor.apana.org.au>
 <AMSPR04MB53644E0E1B8E6C1412D6F11B8380@AMSPR04MB536.eurprd04.prod.outlook.com>,<20160704084606.GA31460@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Horia Ioan Geanta Neag" <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0065.outbound.protection.outlook.com ([104.47.2.65]:61430
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750734AbcGDQjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 12:39:11 -0400
In-Reply-To: <20160704084606.GA31460@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I've tried the following builds and both fail:

make mrproper
make defconfig
make drivers/crypto/qat/qat_common/qat_asym_algs.o
....
drivers/crypto/qat/qat_common/qat_asym_algs.c:55:32: fatal error: qat_rsapubkey-asn1.h: No such file or directory
 #include "qat_rsapubkey-asn1.h"


make mrproper
make defconfig
make drivers/crypto/caam/caampkc.o
...
drivers/crypto/caam/caampkc.c:17:28: fatal error: rsapubkey-asn1.h: No such file or directory
 #include "rsapubkey-asn1.h"


Is there an expectation of building these modules as described above without using make config or  make menuconfig to properly set the dependencies?

Thanks for your time,

Cristian S.
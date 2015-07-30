From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 00/12] crypto: caam - Add i.MX6 support to the Freescale
 CAAM driver
Date: Thu, 30 Jul 2015 20:53:08 +0300
Message-ID: <55BA6484.9060305@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <ruchika.gupta@freescale.com>,
	<shawnguo@kernel.org>, <kernel@pengutronix.de>,
	<linux@arm.linux.org.uk>
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0103.outbound.protection.outlook.com ([207.46.100.103]:56672
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752538AbbG3RxT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 13:53:19 -0400
In-Reply-To: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/30/2015 6:58 AM, Victoria Milhoan wrote:
> This patch series adds i.MX6 support to the Freescale CAAM driver.
> 
> Modifications include:
> 
> - explicit cache coherency support in the driver

1. Please check the aead failures when enabling self-tests
(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS not set).
They seem related with the lack of cache coherency support in caamalg.c.

> - register I/O primitive support
> - scatter/gather entry modifications
> - clocking support
> - i.MX6 device tree support for CAAM
> - DMA fixes
> 
> These patches have been tested on the i.MX6 and regression tested
> on QorIQ platforms. These patches include changes based on responses
> to the original RFC.

2. i.MX60 and i.MX61 have CHAVID_LS[MDVID] (MDHA version ID) equal to 0.
Thus, there is no support for sha384 and sha512.
Accordingly, all algorithms (hash-only or aead) that use them fail with
MDHA Mode error.

The driver should not be advertising these algorithms to Crypto API
unless supported (MDVID >=1).

3. Another type of failures is the following:
caam_jr 2101000.jr0: 40001d0a: DECO: desc idx 29: Invalid FIFO LOAD Command
alg: aead: encryption failed on test 1 for rfc4106-gcm-aes-caam:
ret=-1073749258
caam_jr 2101000.jr0: 40001c0a: DECO: desc idx 28: Invalid FIFO LOAD Command
alg: aead: encryption failed on test 1 for rfc4543-gcm-aes-caam:
ret=-1073749002
caam_jr 2101000.jr0: 4000210a: DECO: desc idx 33: Invalid FIFO LOAD Command
alg: aead: encryption failed on test 1 for gcm-aes-caam: ret=-1073750282

Thanks,
Horia

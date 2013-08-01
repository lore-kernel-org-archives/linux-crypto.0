From: Stoica Cristian-B18196 <B18196@freescale.com>
Subject: RE: [PATCH] crypto: remove double execution of the same test suite
Date: Thu, 1 Aug 2013 08:11:25 +0000
Message-ID: <1628287275CAA9409F1E349DEF3C6CCE4D31E1@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
 <20130801004757.GA24286@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:30184
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab3HAILb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Aug 2013 04:11:31 -0400
In-Reply-To: <20130801004757.GA24286@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Which algorithm (apart from crc* which I know and will fix) uses the
> same driver name as its algorithm name? Doing this will cause issues
> when an alternative implementation for that algorithm gets added.

Fixing names resolves double calls only for the thread cryptomgr_test->alg_test where the call is:
    err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);

It doesn't fix the thread tcrypt_test->alg_test where the call is:
    ret = alg_test(alg, alg, 0, 0);

Cristian S.

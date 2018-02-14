From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 1/4] crypto: AF_ALG AIO - lock context IV
Date: Wed, 14 Feb 2018 13:52:37 +0100
Message-ID: <2080270.jPJprzxrh7@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <4507333.JelVKMRNjF@positron.chronox.de> <617281e5-543c-0d8c-1fa6-56c4a65cc515@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:10426 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967589AbeBNMwi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Feb 2018 07:52:38 -0500
In-Reply-To: <617281e5-543c-0d8c-1fa6-56c4a65cc515@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 14. Februar 2018, 06:43:53 CET schrieb Harsh Jain:

Hi Harsh,

> 
> Patch set is working fine with chelsio Driver.

Thank you.

> Do we really need IV locking mechanism for AEAD algo because AEAD algo's
> don't support Partial mode operation and Driver are not updating(atleast
> Chelsio) IV's on AEAD request completions.

Yes, I think we would need it. It is technically possible to have multiple 
IOCBs for AEAD ciphers. Even though your implementation may not write the IV 
back, others may do that. At least I do not see a guarantee that the IV is 
*not* written back by a driver.

In case your driver does not write the IV back and thus does not need to 
serialize, the driver can report CRYPTO_ALG_SERIALIZES_IV_ACCESS. In this 
case, the higher level functions would not serialize as the driver serializes 
the requests (or the driver deems it appropriate that no serialization is 
needed as is the case with your driver).

Ciao
Stephan

From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 1/4] crypto: AF_ALG AIO - lock context IV
Date: Thu, 15 Feb 2018 07:28:40 +0100
Message-ID: <2405649.UvqtvHuhOS@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <2080270.jPJprzxrh7@tauon.chronox.de> <d6890111-fc19-7f97-c13b-2c217145b0a5@chelsio.com>
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
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:35640 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754554AbeBOG2o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 01:28:44 -0500
In-Reply-To: <d6890111-fc19-7f97-c13b-2c217145b0a5@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. Februar 2018, 06:30:36 CET schrieb Harsh Jain:

Hi Harsh,

> On 14-02-2018 18:22, Stephan Mueller wrote:
> > Am Mittwoch, 14. Februar 2018, 06:43:53 CET schrieb Harsh Jain:
> > 
> > Hi Harsh,
> > 
> >> Patch set is working fine with chelsio Driver.
> > 
> > Thank you.
> > 
> >> Do we really need IV locking mechanism for AEAD algo because AEAD algo's
> >> don't support Partial mode operation and Driver are not updating(atleast
> >> Chelsio) IV's on AEAD request completions.
> > 
> > Yes, I think we would need it. It is technically possible to have multiple
> > IOCBs for AEAD ciphers. Even though your implementation may not write the
> > IV back, others may do that. At least I do not see a guarantee that the
> > IV is *not* written back by a driver.
> 
> There is no  use of writing IV back in AEAD algo till Framework starts
> supporting Partial mode.

I agree.

> Even if Driver starts updating IV for AEAD,
> Multiple IOCB's in both cases will yield wrong results only.

This would only be the case if the driver would not implicitly or explicitly 
serialize the requests.
> 
> Case 1 : If we have AEAD IV serialization  applied,  Encryption will be
> wrong if same IV gets used.

Agreed.

> Case 2: If we do not have IV serialization for
> AEAD. Encryption will be fine but user will have multiple Authentication 
> tag (that too with final block processed).  Its like 2nd Block encryption
> is based on IV received from 1st block  and Authentication Tag value is
> based on 2nd block content only.

Agreed.

But are we sure that all drivers behave correctly? Before you notified us of 
the issue, I was not even aware of the fact that this serialization may not be 
done in the driver. And we only have seen that issue with AF_ALG where we test 
for multiple concurrent AIO operations.

Besides, when we do not have the locking for AEAD, what would we gain: one 
less lock to take vs. guarantee that the AEAD operation is always properly 
serialized.

Ciao
Stephan

From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 1/4] crypto: AF_ALG AIO - lock context IV
Date: Thu, 15 Feb 2018 08:17:03 +0100
Message-ID: <2417115.3KYcYg1eVS@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <2405649.UvqtvHuhOS@tauon.chronox.de> <614650e1-66c7-ca0d-d642-ede029c15f58@chelsio.com>
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
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:12704 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754786AbeBOHRG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 02:17:06 -0500
In-Reply-To: <614650e1-66c7-ca0d-d642-ede029c15f58@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. Februar 2018, 08:03:20 CET schrieb Harsh Jain:

Hi Harsh,

> Even after guarantee of serialization, In the end we will get wrong result
> as mentioned above. which destination side cannot decrypt it. What I feel
> is scenario of sending 2 of more IOCB in case of AEAD itself is wrong.

Without the inline IV handling, I would concur.

> We
> should not allow this type of requests for AEAD.

"Not allow" as in "technically block"? As a user would only shoot itself when 
he does that not knowing the consequences, I am not in favor of such an 
artificial block.

> Can you think of any use
> case it is going to solve?

Well, I could fathom a use case of this. In FIPS 140-2 (yes, a term not well 
received by some here), NIST insists for GCM that the IV is handled by the 
cryptographic implementation.

So, when using GCM for TLS, for example, the GCM implementation would know a 
bit about how the IV is updated as a session ID. I.e. after the end of one 
AEAD operation, the IV is written back but modified such to comply with the 
rules of some higher level proto. Thus, if such a scenarios is implemented by 
a driver here, multiple IOCBs could be used with such "TLSified" GCM, for 
example.

And such "TLSification" could be as simple as implementing an IV generator 
that can be used with every (AEAD) cipher implementation.

> Can receiver decrypt(with 2 IOCB) the same request successfully without
> knowing  sender has done the operation in 2 request with size "x" each?
> > Ciao
> > Stephan



Ciao
Stephan

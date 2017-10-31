From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr: don't allocate IV on stack
Date: Tue, 31 Oct 2017 15:59:25 +0800
Message-ID: <20171031075925.GA26147@gondor.apana.org.au>
References: <1509436586-17500-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51436 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdJaH77 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2017 03:59:59 -0400
Content-Disposition: inline
In-Reply-To: <1509436586-17500-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 31, 2017 at 07:56:26AM +0000, Gilad Ben-Yossef wrote:
> The IV was allocated on the stack in testmgr skcipher tests.
> Since HW based tfm providers need to DMA the IV to the HW,
> this leads to problems and is detected by the DMA-API debug
> code.
> 
> Fix it by allocating the IV using kmalloc instead.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

The driver that is mapping the IV directly should be fixed instead.
Only input that is given in the form of SG lists can be mapped.
Everything else should be copied if they need to go over DMA.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - consolidation of duplicate code
Date: Wed, 16 Aug 2017 16:29:18 +0800
Message-ID: <20170816082917.GA21246@gondor.apana.org.au>
References: <2922624.oQubu9mOmR@positron.chronox.de>
 <3124682.PWyg91A0St@tauon.chronox.de>
 <20170810082153.GA4110@gondor.apana.org.au>
 <2012469.Yss5hQnVpr@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57342 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdHPI33 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 04:29:29 -0400
Content-Disposition: inline
In-Reply-To: <2012469.Yss5hQnVpr@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 10, 2017 at 10:25:58AM +0200, Stephan Mueller wrote:
>
> I think there is such patch already, see [1].
> 
> Your comment to that patch triggered my rewrite of the memory managment code.
> 
> [1] https://www.spinics.net/lists/linux-crypto/msg21618.html

Could you please post that patch to stable@vger.kernel.org with
the appropriate tags?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

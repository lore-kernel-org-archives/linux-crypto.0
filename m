From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] crypto: atmel: only treat EBUSY as transient if backlog
Date: Wed, 12 Jul 2017 18:51:37 +0800
Message-ID: <20170712105137.GB22109@gondor.apana.org.au>
References: <1498634523-2660-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:45588 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755884AbdGLKwH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jul 2017 06:52:07 -0400
Content-Disposition: inline
In-Reply-To: <1498634523-2660-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 28, 2017 at 10:22:03AM +0300, Gilad Ben-Yossef wrote:
> The Atmel SHA driver was treating -EBUSY as indication of queueing
> to backlog without checking that backlog is enabled for the request.
> 
> Fix it by checking request flags.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

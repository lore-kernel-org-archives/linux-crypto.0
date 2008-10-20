From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos Preempt overflow interrupts off-by-one
	fix
Date: Mon, 20 Oct 2008 21:15:54 +0800
Message-ID: <20081020131554.GA7986@gondor.apana.org.au>
References: <1224150291-28500-1-git-send-email-Vishnu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Lee.Nipper@freescale.com,
	Kim Phillips <kim.phillips@freescale.com>
To: Vishnu Suresh <Vishnu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37014 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535AbYJTNP7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Oct 2008 09:15:59 -0400
Content-Disposition: inline
In-Reply-To: <1224150291-28500-1-git-send-email-Vishnu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 16, 2008 at 09:44:51AM +0000, Vishnu Suresh wrote:
> In commit ec6644d6325b5a38525f1d5b20fd4bf7db05cf2a "crypto: talitos - Preempt
> overflow interrupts", the test in atomic_inc_not_zero was interpreted by the
> author to be applied after the increment operation (not before). This off-by-one
> fix prevents overflow error interrupts from occurring when requests are frequent
> and large enough to do so.
> 
> Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

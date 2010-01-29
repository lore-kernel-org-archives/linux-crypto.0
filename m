From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Async Crypto API
Date: Fri, 29 Jan 2010 22:03:02 +1300
Message-ID: <20100129090302.GC23140@gondor.apana.org.au>
References: <20100123032039.GA5551@gondor.apana.org.au> <4B5FE0F8.5090806@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45664 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752532Ab0A2JDH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2010 04:03:07 -0500
Content-Disposition: inline
In-Reply-To: <4B5FE0F8.5090806@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2010 at 08:45:12AM +0200, Dmitry Kasatkin wrote:
> Hi,
> 
> 1 more question.
> 
> >From what context "crypto_completion_t" can be called?
> irq/tasklet/process
> or something else?

tasklet or process with BH off.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] HIFN 795x driver.
Date: Mon, 1 Oct 2007 16:57:59 +0400
Message-ID: <20071001125759.GA26476@2ka.mipt.ru>
References: <20071001124822.GA16017@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34181 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbXJAM6M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Oct 2007 08:58:12 -0400
Content-Disposition: inline
In-Reply-To: <20071001124822.GA16017@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 01, 2007 at 04:48:22PM +0400, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> Hi.
> 
> This is a driver for HIFN 795x crypo accelerator chips.
> In the next mail I will send tcrypt default output related to this
> driver, it outlines several failures (I need to check what 'chunking'
> means in tcrypt and fix related issues). Driver also requires number of
> cleanups (like codying style, debug) and I plan to play with some
> optimisations. It also refuses to register 'ecb(des)' with min and max
> keylen set to the same number, so right now des and 3des are removed.
> Generally I consider its core as ready.
> Pleaser review with above in mind.
> 
> Thank you.
> 
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>


I need to admit that both encryption and decryption works ok
(reverse operations in hifn_test() for example), but tcrypt
decryption test fails. I will investigate this further tomorrow.

-- 
	Evgeniy Polyakov

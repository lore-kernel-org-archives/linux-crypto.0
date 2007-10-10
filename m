From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] fix lrw,pcbc and xts blockmode
Date: Wed, 10 Oct 2007 10:50:49 +0800
Message-ID: <20071010025049.GA26519@gondor.apana.org.au>
References: <E1IfOiI-0003kz-Uf@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2766 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751537AbXJJCuw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Oct 2007 22:50:52 -0400
Content-Disposition: inline
In-Reply-To: <E1IfOiI-0003kz-Uf@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 10, 2007 at 01:18:12AM +0200, Sebastian Siewior wrote:
> Commit 553011f7cc9b86e10f157bf175bf7c883039c8c6
> [CRYPTO] blkcipher: Add IV generation
> 
> broke the three block modes because the new logic expects the
> block mode to provide the IV instead of the crypto user.
> Now the three block modes are using the same "random" function
> for IV creating like cbc does.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Good catch.

Actually I'm going to just revert the geniv stuff for now and
add it back later.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

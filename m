From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] [crypto] AES x86_64, remove setkey
Date: Thu, 8 Nov 2007 21:26:33 +0800
Message-ID: <20071108132633.GB17186@gondor.apana.org.au>
References: <1193585742-26284-1-git-send-email-linux-crypto@ml.breakpoint.cc> <E1ImAGK-0006r6-Nw@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3459 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755339AbXKHN0g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Nov 2007 08:26:36 -0500
Content-Disposition: inline
In-Reply-To: <E1ImAGK-0006r6-Nw@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 28, 2007 at 01:30:09PM +0100, Sebastian Siewior wrote:
> 
> The setkey() function can be shared with the generic algorithm.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Beautiful.  All applied.  Thanks Sebastian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

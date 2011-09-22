From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: blowfish - split generic and common c code
Date: Thu, 22 Sep 2011 21:29:39 +1000
Message-ID: <20110922112938.GA32559@gondor.apana.org.au>
References: <20110901224506.7795.35128.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52032 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1IVL3n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Sep 2011 07:29:43 -0400
Content-Disposition: inline
In-Reply-To: <20110901224506.7795.35128.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 02, 2011 at 01:45:07AM +0300, Jussi Kivilinna wrote:
> Patch splits up the blowfish crypto routine into a common part (key setup)
> which will be used by blowfish crypto modules (x86_64 assembly and generic-c).
> 
> Also fixes errors/warnings reported by checkpatch.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

All applied to cryptodev.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

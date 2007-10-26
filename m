From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] do not unroll big stuff in twofish key setup if OPTIMIZE_FOR_SIZE
Date: Fri, 26 Oct 2007 16:24:44 +0800
Message-ID: <20071026082444.GA28534@gondor.apana.org.au>
References: <200710212016.25792.vda.linux@googlemail.com> <200710241844.54215.vda.linux@googlemail.com> <20071025010822.GB15154@gondor.apana.org.au> <200710251933.55853.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1992 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752655AbXJZIYv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 04:24:51 -0400
Content-Disposition: inline
In-Reply-To: <200710251933.55853.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 25, 2007 at 07:33:55PM +0100, Denys Vlasenko wrote:
>
> See attached patch.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Patch applied.  Thanks a lot Denys.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

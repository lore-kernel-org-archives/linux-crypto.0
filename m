From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Moving xor_* functions into common header file
Date: Tue, 20 Nov 2007 15:33:35 +0800
Message-ID: <20071120073335.GA15090@gondor.apana.org.au>
References: <fd3e431c0711191034qe0bda50r5123544076795b42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3952 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754651AbXKTHdj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Nov 2007 02:33:39 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711191034qe0bda50r5123544076795b42@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 20, 2007 at 02:34:48AM +0800, Tan Swee Heng wrote:
> Hi,
> 
> 'grep "static void xor_" crypto/*' shows that cbc.c, ctr.c, pcbc.c and
> xcbc.c share similar xor_* functions. It seems a good idea to
> encourage code reuse by putting them into a common header (iirc
> Evgeniy  suggested it when reviewing one of my earlier mail). It will
> also be useful to me when porting other eSTREAM ciphers. So I would
> like to move them into include/crypto/xor_n.h and make them all
> "static inline". Any objections?

Do you actually need to xor anything that's not a multiple of
8 bytes?

I'm currently working on a patch to just restrict the block
size for non-stream ciphers to multiples of 8 since that's what
we have anyway.  That allows us to just use bitmap_xor.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

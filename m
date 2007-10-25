From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] do not unroll big stuff in twofish key setup if OPTIMIZE_FOR_SIZE
Date: Thu, 25 Oct 2007 09:08:23 +0800
Message-ID: <20071025010822.GB15154@gondor.apana.org.au>
References: <200710212016.25792.vda.linux@googlemail.com> <20071023060748.GA27501@gondor.apana.org.au> <200710241844.54215.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1687 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752729AbXJYBI0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Oct 2007 21:08:26 -0400
Content-Disposition: inline
In-Reply-To: <200710241844.54215.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 24, 2007 at 06:44:54PM +0100, Denys Vlasenko wrote:
>
> 7% slower key setup (see patch - there is a comment about it).

Is it just the keying? If so please simply delete the unrolled
version because keying is supposed to be a rare event.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

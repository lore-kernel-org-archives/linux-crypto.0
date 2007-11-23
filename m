From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] salsa_generic.c: Renamed salsa20.c to salsa20_generic.c
Date: Fri, 23 Nov 2007 19:47:40 +0800
Message-ID: <20071123114740.GA18862@gondor.apana.org.au>
References: <fd3e431c0711211312v1b84f5c8x46850cf3ad986c70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1977 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755521AbXKWLrq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Nov 2007 06:47:46 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711211312v1b84f5c8x46850cf3ad986c70@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 05:12:39AM +0800, Tan Swee Heng wrote:
> Renamed salsa20.c to salsa20_generic.c for future support of optimized
> i586 version.
> 
> Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

Patch applied.  I've combined this patch with the patch introducing
salsa20 as otherwise we end up with a very short-lived salsa20.c
file.

I also add the missing salsa20 module alias :)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

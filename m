From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [CRYPTO] Extend sha256_generic.c to support SHA-224and SHA-224-HMAC
Date: Sat, 10 Nov 2007 20:10:59 +0800
Message-ID: <20071110121059.GE5485@gondor.apana.org.au>
References: <20071107195923.GA23977@compsoc.nuigalway.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jonathan Lynch <jonathan.lynch@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2024 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751632AbXKJMLG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 07:11:06 -0500
Content-Disposition: inline
In-Reply-To: <20071107195923.GA23977@compsoc.nuigalway.ie>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 07, 2007 at 07:59:23PM +0000, Jonathan Lynch wrote:
> Resubmitting this patch which extends sha256_generic.c to support SHA-224 as 
> described in FIPS 180-2 and RFC 3874. HMAC-SHA-224 as described in RFC4231 
> is then supported through the hmac interface.

Patch applied.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

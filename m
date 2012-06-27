From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algapi - Fix hang on crypto allocation
Date: Wed, 27 Jun 2012 20:58:32 +0800
Message-ID: <20120627125832.GA24923@gondor.apana.org.au>
References: <20120627113101.GB1869@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:34456 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772Ab2F0M6e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 08:58:34 -0400
Content-Disposition: inline
In-Reply-To: <20120627113101.GB1869@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 27, 2012 at 01:31:01PM +0200, Steffen Klassert wrote:
> git commit 398710379 (crypto: algapi - Move larval completion
> into algboss) replaced accidentally a call to complete_all() by
> a call to complete(). This causes a hang on crypto allocation
> if we have more than one larval waiter. This pach restores the
> call to complete_all().
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Good catch! Patch applied.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

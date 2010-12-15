From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ghash-clmulni-intel_glue needs err.h
Date: Wed, 15 Dec 2010 17:59:23 +0800
Message-ID: <20101215095923.GA24313@gondor.apana.org.au>
References: <20101214162641.3e229f12.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	akpm <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39316 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0LOJ71 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Dec 2010 04:59:27 -0500
Content-Disposition: inline
In-Reply-To: <20101214162641.3e229f12.randy.dunlap@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 14, 2010 at 04:26:41PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add missing header file:
> 
> arch/x86/crypto/ghash-clmulni-intel_glue.c:256: error: implicit declaration of function 'IS_ERR'
> arch/x86/crypto/ghash-clmulni-intel_glue.c:257: error: implicit declaration of function 'PTR_ERR'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

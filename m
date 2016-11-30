From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 00/10] crypto/chcr: AEAD support and bug fixes
Date: Wed, 30 Nov 2016 21:18:43 +0800
Message-ID: <20161130131843.GC4126@gondor.apana.org.au>
References: <cover.1480413079.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.carpenter@oracle.com, linux-crypto@vger.kernel.org,
        smueller@chronox.de, hariprasad@chelsio.com, jlulla@chelsio.com,
        atul.gupta@chelsio.com, yeshaswi@chelsio.com
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52842 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752786AbcK3NSv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:18:51 -0500
Content-Disposition: inline
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 29, 2016 at 07:00:33PM +0530, Harsh Jain wrote:
> This patch series includes Bug Fixes, performance improvement and
> support for following AEAD algos.
> GCM,CCM,RFC4106,RFC4303,authenc(hmac(shaXXX),cbc(aes))
> 
> v3:
> -Break patch 01 into 2.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

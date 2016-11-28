From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/9] crypto/chcr:Fix memory corruption done
Date: Mon, 28 Nov 2016 20:49:26 +0800
Message-ID: <20161128124925.GC2257@gondor.apana.org.au>
References: <cover.1479740559.git.harsh@chelsio.com>
 <0fae54e35bc10476e7e3c836219474c713f3be7e.1479740559.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.carpenter@oracle.com, linux-crypto@vger.kernel.org,
        smueller@chronox.de, jlulla@chelsio.com, atul.gupta@chelsio.com,
        yeshaswi@chelsio.com, hariprasad@chelsio.com
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51866 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932362AbcK1Mtj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 07:49:39 -0500
Content-Disposition: inline
In-Reply-To: <0fae54e35bc10476e7e3c836219474c713f3be7e.1479740559.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 21, 2016 at 09:30:47PM +0530, Harsh Jain wrote:
> Fix memory corruption done by  *((u32 *)dec_key + k) operation.
> 
> Signed-off-by: Jitendra Lulla <JLULLA@chelsio.com>

Please don't mix substantial changes with cosmetic ones such as
moving a function.  This should be split into two patches, the
first one being the fix and the second one doing the cosmetic
fixup.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: lz4: fixed decompress function to return error
 code
Date: Mon, 10 Apr 2017 19:23:04 +0800
Message-ID: <20170410112304.GC8800@gondor.apana.org.au>
References: <1491784462-31424-1-git-send-email-mhjungk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Myungho Jung <mhjungk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51950 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753723AbdDJLXb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 07:23:31 -0400
Content-Disposition: inline
In-Reply-To: <1491784462-31424-1-git-send-email-mhjungk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 09, 2017 at 05:34:22PM -0700, Myungho Jung wrote:
> Decompress function in LZ4 library is supposed to return an error code or
> negative result. But, it returns -1 when any error is detected. Return
> error code when the library returns negative value.
> 
> Signed-off-by: Myungho Jung <mhjungk@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

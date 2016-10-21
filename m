From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cmac - fix alignment of 'consts'
Date: Fri, 21 Oct 2016 11:15:08 +0800
Message-ID: <20161021031508.GI22979@gondor.apana.org.au>
References: <1476119715-71397-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57675 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752931AbcJUDPO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 23:15:14 -0400
Content-Disposition: inline
In-Reply-To: <1476119715-71397-2-git-send-email-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 10, 2016 at 10:15:15AM -0700, Eric Biggers wrote:
> The per-transform 'consts' array is accessed as __be64 in
> crypto_cmac_digest_setkey() but was only guaranteed to be aligned to
> __alignof__(long).  Fix this by aligning it to __alignof__(__be64).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

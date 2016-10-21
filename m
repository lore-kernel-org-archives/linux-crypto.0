From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cmac - return -EINVAL if block size is
 unsupported
Date: Fri, 21 Oct 2016 11:14:50 +0800
Message-ID: <20161021031450.GH22979@gondor.apana.org.au>
References: <1476119715-71397-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55371 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753228AbcJUDO4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 23:14:56 -0400
Content-Disposition: inline
In-Reply-To: <1476119715-71397-1-git-send-email-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 10, 2016 at 10:15:14AM -0700, Eric Biggers wrote:
> cmac_create() previously returned 0 if a cipher with a block size other
> than 8 or 16 bytes was specified.  It should return -EINVAL instead.
> Granted, this doesn't actually change any behavior because cryptomgr
> currently ignores any return value other than -EAGAIN from template
> ->create() functions.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

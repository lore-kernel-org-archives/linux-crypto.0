From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: acomp - don't use stack buffer in test_acomp()
Date: Mon, 28 Nov 2016 21:29:59 +0800
Message-ID: <20161128132959.GD2757@gondor.apana.org.au>
References: <1479925475-13732-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58881 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932127AbcK1Nbn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 08:31:43 -0500
Content-Disposition: inline
In-Reply-To: <1479925475-13732-1-git-send-email-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 23, 2016 at 10:24:35AM -0800, Eric Biggers wrote:
> With virtually-mapped stacks (CONFIG_VMAP_STACK=y), using the
> scatterlist crypto API with stack buffers is not allowed, and with
> appropriate debugging options will cause the
> 'BUG_ON(!virt_addr_valid(buf));' in sg_set_buf() to be triggered.
> Use a heap buffer instead.
> 
> Fixes: d7db7a882deb ("crypto: acomp - update testmgr with support for acomp")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

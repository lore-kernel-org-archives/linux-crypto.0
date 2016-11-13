From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Sun, 13 Nov 2016 19:29:23 +0800
Message-ID: <20161113112923.GD7399@gondor.apana.org.au>
References: <20161107191253.17998-1-Jason@zx2c4.com>
 <20161107194709.20457-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers@google.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48621 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934704AbcKML3q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 06:29:46 -0500
Content-Disposition: inline
In-Reply-To: <20161107194709.20457-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 07, 2016 at 08:47:09PM +0100, Jason A. Donenfeld wrote:
> By using the unaligned access helpers, we drastically improve
> performance on small MIPS routers that have to go through the exception
> fix-up handler for these unaligned accesses.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

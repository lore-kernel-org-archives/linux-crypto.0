From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam - treat SGT address pointer as u64
Date: Sun, 2 Oct 2016 22:47:50 +0800
Message-ID: <20161002144750.GJ18268@gondor.apana.org.au>
References: <1475226579-2078-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fabio.estevam@nxp.com, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54270 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbcJBOrz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Oct 2016 10:47:55 -0400
Content-Disposition: inline
In-Reply-To: <1475226579-2078-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 30, 2016 at 12:09:39PM +0300, Tudor Ambarus wrote:
> Even for i.MX, CAAM is able to use address pointers greater than
> 32 bits, the address pointer field being interpreted as a double word.
> Enforce u64 address pointer in the sec4_sg_entry struct.
> 
> This patch fixes the SGT address pointer endianness issue for
> 32bit platforms where core endianness != caam endianness.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

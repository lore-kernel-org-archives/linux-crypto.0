From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 09/11] crypto: remove LZO fallback from crypto 842
Date: Wed, 8 Apr 2015 22:16:00 +0800
Message-ID: <20150408141600.GA30338@gondor.apana.org.au>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1428428070-17803-10-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50784 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbbDHOQe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 10:16:34 -0400
Content-Disposition: inline
In-Reply-To: <1428428070-17803-10-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 07, 2015 at 01:34:28PM -0400, Dan Streetman wrote:
> Update the crypto 842 driver to no longer fallback to LZO if the 842
> hardware is unavailable.  Simplify the crpypto 842 driver to remove all
> headers indicating 842/lzo.
> 
> The crypto 842 driver should do 842-format compression and decompression
> only.  It should not fallback to LZO compression/decompression.  The
> user of the crypto 842 driver can fallback to another format if desired.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Thanks for the series.  I don't know how I missed it when it was
merged originally but crypto/842.c needs to be moved over to
drivers/crypto.  Your software implementation should take its
places as the reference implementation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

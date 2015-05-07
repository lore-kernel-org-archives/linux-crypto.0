From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 10/10] drivers/crypto/nx: add hardware 842 crypto comp alg
Date: Thu, 7 May 2015 11:12:38 +0800
Message-ID: <20150507031238.GC29395@gondor.apana.org.au>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-11-git-send-email-ddstreet@ieee.org>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:42158 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbbEGDNC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 23:13:02 -0400
Content-Disposition: inline
In-Reply-To: <1430931066-4536-11-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 06, 2015 at 12:51:06PM -0400, Dan Streetman wrote:
> Add crypto compression alg for 842 hardware compression and decompression.
> 
> This crypto compression alg is named "nx842" to indicate it uses hardware
> to perform the compression and decompression, while the software 842
> compression alg is named "sw842".  However, since before this split there
> was only one 842 compression alg named "842" which only used hardware,
> this is also aliased "842" for backwards compatibility.

This should still be called 842.  You can set the driver name to
nx842 or 842-nx.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

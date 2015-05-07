From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 04/10] crypto: change 842 alg to use software
Date: Thu, 7 May 2015 11:07:17 +0800
Message-ID: <20150507030717.GB29395@gondor.apana.org.au>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-5-git-send-email-ddstreet@ieee.org>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:46516 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbbEGDHr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 23:07:47 -0400
Content-Disposition: inline
In-Reply-To: <1430931066-4536-5-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 06, 2015 at 12:51:00PM -0400, Dan Streetman wrote:
> Change the crypto 842 compression alg to use the software 842 compression
> and decompression library.  Change the name of this crypto alg to "sw842".
> Remove the fallback to LZO compression.

That's not how the name works.  All implementations of 842 should
bear that name.  They should differentiate themselves based on
cra_driver_name.  For example, we generally call the software
implementation of foo "foo-generic".

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

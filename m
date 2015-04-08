From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 11/11] crypto: add crypto compression sefltest
Date: Wed, 8 Apr 2015 22:16:31 +0800
Message-ID: <20150408141631.GB30338@gondor.apana.org.au>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1428428070-17803-12-git-send-email-ddstreet@ieee.org>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:49630 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbbDHOQ4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 10:16:56 -0400
Content-Disposition: inline
In-Reply-To: <1428428070-17803-12-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 07, 2015 at 01:34:30PM -0400, Dan Streetman wrote:
> Add configurable module to perform self-tests on any crypto compression
> driver.
> 
> This allows testing any crypto compression driver with any input buffer,
> at varying alignments and lengths.  It calculates the average bytes per
> second compression and decompression rates.  Any errors reported by the
> compressor during compression or decompression will end the test and
> be logged.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Please use the existing infrastructure in testmgr/tcrypt.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

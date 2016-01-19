From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Fix crc32c soft dependency
Date: Tue, 19 Jan 2016 15:57:26 +0800
Message-ID: <20160119075726.GA7842@gondor.apana.org.au>
References: <20160118170605.4e4a022f@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Michal Marek <mmarek@suse.cz>
To: Jean Delvare <jdelvare@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57033 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbcASH5d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 02:57:33 -0500
Content-Disposition: inline
In-Reply-To: <20160118170605.4e4a022f@endymion.delvare>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 18, 2016 at 05:06:05PM +0100, Jean Delvare wrote:
> I don't think it makes sense for a module to have a soft dependency
> on itself. This seems quite cyclic by nature and I can't see what
> purpose it could serve.
> 
> OTOH libcrc32c calls crypto_alloc_shash("crc32c", 0, 0) so it pretty
> much assumes that some incarnation of the "crc32c" hash algorithm has
> been loaded. Therefore it makes sense to have the soft dependency
> there (as crc-t10dif does.)
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>

Well caught.  Patch applied, thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

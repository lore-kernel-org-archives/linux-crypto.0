From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Tue, 13 Oct 2015 22:33:12 +0800
Message-ID: <20151013143312.GA7903@gondor.apana.org.au>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51802 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbbJMOd0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 10:33:26 -0400
Content-Disposition: inline
In-Reply-To: <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 09, 2015 at 08:43:33PM +0100, Russell King wrote:
> If the algorithm passed a zero statesize, do not pass a valid pointer
> into the export/import functions.  Passing a valid pointer covers up
> bugs in driver code which then go on to smash the kernel stack.
> Instead, pass NULL, which will cause any attempt to write to the
> pointer to fail.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Patch applied without the shash hunk.  I also replaced your commit
message as it no longer makes any sense:

    crypto: ahash - ensure statesize is non-zero

    Unlike shash algorithms, ahash drivers must implement export
    and import as their descriptors may contain hardware state and
    cannot be exported as is.  Unfortunately some ahash drivers did
    not provide them and end up causing crashes with algif_hash.

    This patch adds a check to prevent these drivers from registering
    ahash algorithms until they are fixed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Sun, 11 Oct 2015 14:57:46 +0800
Message-ID: <20151011065746.GB17272@gondor.apana.org.au>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
 <20151010184607.353cb5f3@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36545 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbbJKG56 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Oct 2015 02:57:58 -0400
Content-Disposition: inline
In-Reply-To: <20151010184607.353cb5f3@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 10, 2015 at 06:46:07PM +0200, Boris Brezillon wrote:
>
> I mean, the only valid case where statesize can be zero is when you
> don't have any state associated to the crypto algorithm, and if that's
> the case, ->import() and ->export() functions are useless, isn't ?

The import/export functions are used by algif_hash and must be
implemented by the driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

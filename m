From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] geode: Fix cip/blk confusion
Date: Thu, 4 Feb 2010 11:39:36 +1100
Message-ID: <20100204003936.GA28890@gondor.apana.org.au>
References: <4B62E388.1070707@gmail.com> <20100129145152.GA31953@Chamillionaire.breakpoint.cc> <25e057c01001290720k529a5ee3i6bef74c9217abbf8@mail.gmail.com> <20100129203008.GA5828@gondor.apana.org.au> <4B6454C3.1030606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sergey Mironov <ierton@gmail.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43896 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756225Ab0BDAkG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2010 19:40:06 -0500
Content-Disposition: inline
In-Reply-To: <4B6454C3.1030606@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 30, 2010 at 04:48:19PM +0100, Roel Kluin wrote:
> a crypto_cipher cip member was set where a crypto_cipher blk members
> should have been.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Patch applied.  Thank you.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Date: Mon, 4 Aug 2008 22:54:11 +0800
Message-ID: <20080804145411.GA11889@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain> <1217844725.3454.580.camel@pmac.infradead.org> <1217846139.20845.25.camel@localhost.localdomain> <1217846726.3454.589.camel@pmac.infradead.org> <20080804140435.GA11227@gondor.apana.org.au> <20080804072015.0fcd23e7@infradead.org> <1217861341.3454.641.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arjan van de Ven <arjan@infradead.org>,
	Austin Zhang <austin_zhang@linux.intel.com>,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43127 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756970AbYHDOyV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 10:54:21 -0400
Content-Disposition: inline
In-Reply-To: <1217861341.3454.641.camel@pmac.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 04, 2008 at 03:49:01PM +0100, David Woodhouse wrote:
>
> And even for people who don't care about that, it doesn't look
> particularly good. It looks like btrfs would need either to keep setting
> up a crypto context and then tearing it down, or have a pool of
> long-standing contexts and do some kind of locking on them -- neither of
> which seem particularly optimal compared with just calling into
> libcrc32c.

No you don't have to set things up every time you use crc32c.
The crypto interface lets you have a single tfm that can be
used by multiple users simultaneously.  For ahash algorithms
all the state is stored in the request which can stay on the
stack.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

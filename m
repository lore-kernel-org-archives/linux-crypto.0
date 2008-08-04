From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Date: Mon, 04 Aug 2008 23:12:07 +0800
Message-ID: <E1KQ1jD-00039b-00@gondolin.me.apana.org.au>
References: <20080804072015.0fcd23e7@infradead.org>
Cc: herbert@gondor.apana.org.au, dwmw2@infradead.org,
	austin_zhang@linux.intel.com, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: arjan@infradead.org (Arjan van de Ven)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44841 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbYHDPMR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 11:12:17 -0400
In-Reply-To: <20080804072015.0fcd23e7@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 4 Aug 2008 22:04:35 +0800
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
>> There only three crc32c users in the kernel tree and the crypto
>> interface will serve the perfectly.
> 
> isn't it a bit heavy for something as simple as a crc?
> (which after all is one instruction now ;0)

Well AES on the PadLock is also a single instruction and nobody
has ever complained :)

Seriously, the crypto code is extremely small on the data path.
The heaviest part is the indirect function call but you have to
have that in order to support multiple implementations cleanly.

All the fat is on the control path, i.e., tfm allocation.  For
crc32c you only need a single tfm since all the state is stored
in the request object.

Note that you should ignore the existing crc32c user, iSCSI as
it was written before the new crypto hash interface was available.
I will be converting it along with the other two crc32c users. to
the new ahash interface.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

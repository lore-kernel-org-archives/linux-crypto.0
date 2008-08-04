From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate	CRC32c
 algorithm by new crypto API.
Date: Mon, 4 Aug 2008 10:06:05 -0700
Message-ID: <20080804100605.4f0921f4@infradead.org>
References: <1217866496.29139.75.camel@think.oraclecorp.com>
	<E1KQ3Be-0003T3-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: chris.mason@oracle.com (Chris Mason), herbert@gondor.apana.org.au,
	dwmw2@infradead.org, austin_zhang@linux.intel.com,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:32867 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYHDRGP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 13:06:15 -0400
In-Reply-To: <E1KQ3Be-0003T3-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 05 Aug 2008 00:45:34 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On the other hand, one of the advantages of doing it through the
> crypto API is that this kind of selection is useful for quite a
> few operations, e.g., xor or even memcpy.

well you still have that indirect function call

for libcrc32 we could alternatives() that...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

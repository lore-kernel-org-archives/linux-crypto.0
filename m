From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Fwd: Re: [PATCH] iSCSI fix endieness of digest to be network
 byte order
Date: Thu, 08 Nov 2007 17:04:09 +0900
Message-ID: <20071108170409B.fujita.tomonori@lab.ntt.co.jp>
References: <47320C54.10406@panasas.com>
	<20071108011849.GA12428@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: bhalevy@panasas.com, linux-crypto@vger.kernel.org,
	fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:65198 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbXKHJ0Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Nov 2007 04:26:16 -0500
In-Reply-To: <20071108011849.GA12428@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 8 Nov 2007 09:18:49 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Nov 07, 2007 at 07:04:52PM +0000, Benny Halevy wrote:
> > Am I dreaming (or just sleep deprived ;), or crc32c swabs the crc
> > one too many times on big-endian machines when CRC_LE_BITS != 1?
> 
> Your patch looks good to me since nobody in the kernel actually
> uses the crc32c functions directly.

I wonder why crc32c isn't used directly while crc32 is used directly
since they vary by only the polynomial.

Using crc32c directly might enable us to kill net/sctp/crc32c.c and
merge lib/crc32.c and lib/libcrc32c?

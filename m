From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Thu, 4 Oct 2007 19:04:53 +0400
Message-ID: <20071004150453.GA16027@2ka.mipt.ru>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071002190512.GA8761@Chamillionaire.breakpoint.cc> <20071003084118.GA19117@2ka.mipt.ru> <20071003115405.GA8920@gondor.apana.org.au> <20071003120518.GA20250@2ka.mipt.ru> <20071004054923.GA16226@gondor.apana.org.au> <20071004092218.GA23613@2ka.mipt.ru> <20071004100414.GA24602@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43499 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbXJDPFc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 11:05:32 -0400
Content-Disposition: inline
In-Reply-To: <20071004100414.GA24602@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.

On Thu, Oct 04, 2007 at 06:04:14PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> But we still need to fix the partial block case.

Just a note: blkcipher_walk_* was not designed for async hardware, since
there is no way to know in advance how many pages will be required for 
single request. For example DES second multipage test says it has three
pages, but actually it will have 4 requests and thus 4 DMA
descriptors in HIFN, but when new interrupt says about completed
descriptor, it can not know if it is the last descriptor or not, so that
callback for request should or should not be called. I've fixed that
with additional atomic ops...

Given that, new driver passes all except one DES tcrypt tests, it fails
on cbc multipage encryption (decryption works ok), which provides 13
bytes of misaligned data.

Here is a code snippet for current driver (error handling was ommitted):

	blkcipher_walk_init(&walk, req->dst, req->src, nbytes);
	err = blkcipher_walk_phys(&desc, &walk);

	while ((nbytes = walk.nbytes)) {
		spage = walk.src.phys.page;
		soff = walk.src.phys.offset;

		dpage = walk.dst.phys.page;
		doff = walk.dst.phys.offset;
		
		ctx->iv = walk.iv;

		++i;

		spin_lock_irqsave(&dev->lock, flags);
		err = hifn_setup_dma(dev, spage, soff, dpage, doff, nbytes,
				req, ctx);
		spin_unlock_irqrestore(&dev->lock, flags);

		nbytes &= blocksize - 1;
		err = blkcipher_walk_done(&desc, &walk, nbytes);
	}

And debug output:
Testing cbc(des) encryption across pages (chunking)
test 1 (64 bit key):
hifn0: spage: ffff81003fe8f1e8, soffset: 0, dpage: ffff81003fe8f1e8, doffset: 0, nbytes: 13, priv: ffff81003dc74138, ctx: ffff81003a9d7210.
hifn0: spage: ffff81003fe8f1e8, soffset: 8, dpage: ffff81003fe8f1e8, doffset: 0, nbytes: 8, priv: ffff81003dc74138, ctx: ffff81003a9d7210.
hifn0: spage: ffff81003fe8f1e8, soffset: 0, dpage: ffff81003fe8f1e8, doffset: 0, nbytes: 8, priv: ffff81003dc74138, ctx: ffff81003a9d7210.
page 0
ccd173ffab2039f47f81654121
fail
page 1
dbd4cf266da007deeadb88
fail


And actually there is a huge problem with blkcipher_walk* interface - it
always provides the same destination buffer, so it is possible to
overwrite it if second crypto block was encrypted before the first one.

It just can not be used in asynchronous hardware, so I will create
soemthing new for HIFN driver specially.

-- 
	Evgeniy Polyakov

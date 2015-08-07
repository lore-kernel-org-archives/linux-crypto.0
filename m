From: Christoph Hellwig <hch@lst.de>
Subject: scatterlist cleanups
Date: Fri,  7 Aug 2015 18:15:10 +0200
Message-ID: <1438964116-24321-1-git-send-email-hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series contains various scatterlist cleanups.  It makes the chained
scatterlist helpers generally available, even if a architecture doesn't
allow a DMA mapping for it, and changes two callers to make use of this
as well as cleans up various opencoded access to scatterlist internals.

A large part of this work is based on older patches from Dan.

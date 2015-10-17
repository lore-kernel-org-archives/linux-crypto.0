From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3/5] crypto: caam: fix non-block aligned hash calculation
Date: Sat, 17 Oct 2015 19:51:33 +0100
Message-ID: <E1ZnWZp-0001n5-O1@rmk-PC.arm.linux.org.uk>
References: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	horia.geanta@freescale.com, fabio.estevam@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43443 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbJQSvm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 14:51:42 -0400
In-Reply-To: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caam does not properly calculate the size of the retained state
when non-block aligned hashes are requested - it uses the wrong
buffer sizes, which results in errors such as:

caam_jr 2102000.jr1: 40000501: DECO: desc idx 5: SGT Length Error. The descriptor is trying to read more data than is contained in the SGT table.

We end up here with:

in_len 0x46 blocksize 0x40 last_bufsize 0x0 next_bufsize 0x6
to_hash 0x40 ctx_len 0x28 nbytes 0x20

which results in a job descriptor of:

jobdesc@889: ed03d918: b0861c08 3daa0080 f1400000 3d03d938
jobdesc@889: ed03d928: 00000068 f8400000 3cde2a40 00000028

where the word at 0xed03d928 is the expected data size (0x68), and a
scatterlist containing:

sg@892: ed03d938: 00000000 3cde2a40 00000028 00000000
sg@892: ed03d948: 00000000 3d03d100 00000006 00000000
sg@892: ed03d958: 00000000 7e8aa700 40000020 00000000

0x68 comes from 0x28 (the context size) plus the "in_len" rounded down
to a block size (0x40).  in_len comes from 0x26 bytes of unhashed data
from the previous operation, plus the 0x20 bytes from the latest
operation.

The fixed version would create:

sg@892: ed03d938: 00000000 3cde2a40 00000028 00000000
sg@892: ed03d948: 00000000 3d03d100 00000026 00000000
sg@892: ed03d958: 00000000 7e8aa700 40000020 00000000

which replaces the 0x06 length with the correct 0x26 bytes of previously
unhashed data.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 3ce6083c2e43..dcee360065f3 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -829,7 +829,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		state->buf_dma = try_buf_map_to_sec4_sg(jrdev,
 							edesc->sec4_sg + 1,
 							buf, state->buf_dma,
-							*next_buflen, *buflen);
+							*buflen, last_buflen);
 
 		if (src_nents) {
 			src_map_to_sec4_sg(jrdev, req->src, src_nents,
-- 
2.1.0

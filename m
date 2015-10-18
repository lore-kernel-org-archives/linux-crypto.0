From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 04/18] crypto: marvell: fix the bit length endianness
Date: Sun, 18 Oct 2015 17:23:46 +0100
Message-ID: <E1ZnqkM-0005WN-0o@rmk-PC.arm.linux.org.uk>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45209 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbbJRQX4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:23:56 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The endianness of the bit length used in the final stage depends on the
endianness of the algorithm - md5 hashes need it to be in little endian
format, whereas SHA hashes need it in big endian format.  Use the
previously added algorithm endianness flag to control this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index aa12274608ab..dc2c65b52d7a 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -179,7 +179,6 @@ static int mv_cesa_ahash_pad_len(struct mv_cesa_ahash_req *creq)
 
 static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *buf)
 {
-	__be64 bits = cpu_to_be64(creq->len << 3);
 	unsigned int index, padlen;
 
 	buf[0] = 0x80;
@@ -187,7 +186,14 @@ static int mv_cesa_ahash_pad_req(struct mv_cesa_ahash_req *creq, u8 *buf)
 	index = creq->len & CESA_HASH_BLOCK_SIZE_MSK;
 	padlen = mv_cesa_ahash_pad_len(creq);
 	memset(buf + 1, 0, padlen - 1);
-	memcpy(buf + padlen, &bits, sizeof(bits));
+
+	if (creq->algo_le) {
+		__le64 bits = cpu_to_le64(creq->len << 3);
+		memcpy(buf + padlen, &bits, sizeof(bits));
+	} else {
+		__be64 bits = cpu_to_be64(creq->len << 3);
+		memcpy(buf + padlen, &bits, sizeof(bits));
+	}
 
 	return padlen + 8;
 }
-- 
2.1.0

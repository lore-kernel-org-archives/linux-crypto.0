From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 06/18] crypto: marvell: const-ify argument to
 mv_cesa_get_op_cfg()
Date: Sun, 18 Oct 2015 17:23:56 +0100
Message-ID: <E1ZnqkW-0005WZ-8x@rmk-PC.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45220 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbJRQYH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:24:07 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

mv_cesa_get_op_cfg() does not write to its argument, it only reads.
So, let's make it const.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/cesa.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index 5d5b66ea2ceb..cd646d7c14e2 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -627,7 +627,7 @@ static inline void mv_cesa_update_op_cfg(struct mv_cesa_op_ctx *op,
 	op->desc.config |= cpu_to_le32(cfg);
 }
 
-static inline u32 mv_cesa_get_op_cfg(struct mv_cesa_op_ctx *op)
+static inline u32 mv_cesa_get_op_cfg(const struct mv_cesa_op_ctx *op)
 {
 	return le32_to_cpu(op->desc.config);
 }
-- 
2.1.0

From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 14/17] crypto: talitos - Add a helper function to clear j_extent field
Date: Thu,  5 Mar 2015 17:46:07 +0100 (CET)
Message-ID: <20150305164607.33E4A1A2428@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

j_extent field is specific to SEC2 so we add a helper function to clear it
so that SEC1 can redefine that function as nop
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.c  | 2 +-
 drivers/crypto/talitos2.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index fc30196..37d7746 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -628,7 +628,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/* cipher iv */
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
 	desc->ptr[1].len = cpu_to_be16(ivsize);
-	desc->ptr[1].j_extent = 0;
+	to_talitos_ptr_extent_clear(&desc->ptr[1]);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
diff --git a/drivers/crypto/talitos2.h b/drivers/crypto/talitos2.h
index 7177088..6f98b12 100644
--- a/drivers/crypto/talitos2.h
+++ b/drivers/crypto/talitos2.h
@@ -90,6 +90,11 @@ static inline void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr)
 	ptr->eptr = upper_32_bits(dma_addr);
 }
 
+static inline void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr)
+{
+	ptr->j_extent = 0;
+}
+
 /*
  * map virtual single (contiguous) pointer to h/w descriptor pointer
  */
-- 
2.1.0

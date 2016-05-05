From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 5/8] crypto: caam - fix offset field in hw sg entries
Date: Thu, 5 May 2016 18:36:22 +0300
Message-ID: <1462462582-27826-1-git-send-email-horia.geanta@nxp.com>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Fabio Estevam <fabio.estevam@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Cristian Stoica <cristian.stoica@freescale.com>

The offset field is 13 bits wide; make sure we don't overwrite more tha=
n
that in the caam hardware scatter gather structure.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 drivers/crypto/caam/desc.h       | 2 +-
 drivers/crypto/caam/sg_sw_sec4.h | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 1e93c6af2275..fe30ff69088c 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -20,7 +20,7 @@
 #define SEC4_SG_BPID_MASK	0x000000ff
 #define SEC4_SG_BPID_SHIFT	16
 #define SEC4_SG_LEN_MASK	0x3fffffff	/* Excludes EXT and FINAL */
-#define SEC4_SG_OFFS_MASK	0x00001fff
+#define SEC4_SG_OFFSET_MASK	0x00001fff
=20
 struct sec4_sg_entry {
 #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_=
sw_sec4.h
index 12ec6616e89d..2311341b7356 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -11,12 +11,12 @@ struct sec4_sg_entry;
  * convert single dma address to h/w link table format
  */
 static inline void dma_to_sec4_sg_one(struct sec4_sg_entry *sec4_sg_pt=
r,
-				      dma_addr_t dma, u32 len, u32 offset)
+				      dma_addr_t dma, u32 len, u16 offset)
 {
 	sec4_sg_ptr->ptr =3D dma;
 	sec4_sg_ptr->len =3D len;
 	sec4_sg_ptr->buf_pool_id =3D 0;
-	sec4_sg_ptr->offset =3D offset;
+	sec4_sg_ptr->offset =3D offset & SEC4_SG_OFFSET_MASK;
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "sec4_sg_ptr@: ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sec4_sg_ptr,
@@ -30,7 +30,7 @@ static inline void dma_to_sec4_sg_one(struct sec4_sg_=
entry *sec4_sg_ptr,
  */
 static inline struct sec4_sg_entry *
 sg_to_sec4_sg(struct scatterlist *sg, int sg_count,
-	      struct sec4_sg_entry *sec4_sg_ptr, u32 offset)
+	      struct sec4_sg_entry *sec4_sg_ptr, u16 offset)
 {
 	while (sg_count) {
 		dma_to_sec4_sg_one(sec4_sg_ptr, sg_dma_address(sg),
@@ -48,7 +48,7 @@ sg_to_sec4_sg(struct scatterlist *sg, int sg_count,
  */
 static inline void sg_to_sec4_sg_last(struct scatterlist *sg, int sg_c=
ount,
 				      struct sec4_sg_entry *sec4_sg_ptr,
-				      u32 offset)
+				      u16 offset)
 {
 	sec4_sg_ptr =3D sg_to_sec4_sg(sg, sg_count, sec4_sg_ptr, offset);
 	sec4_sg_ptr->len |=3D SEC4_SG_LEN_FIN;
--=20
2.4.4

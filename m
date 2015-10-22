From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/4] crypto: hifn_795x: fix coding style
Date: Thu, 22 Oct 2015 08:51:52 +0200
Message-ID: <1445496712-5654-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1445496712-5654-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445496712-5654-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The hifn_795x driver is old and have lots of style issue.
This patch try to solve easy ones.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/hifn_795x.c | 301 +++++++++++++++++++++------------------------
 1 file changed, 138 insertions(+), 163 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index ea490bd..f398f5b 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -11,10 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
@@ -73,12 +69,12 @@ static atomic_t hifn_dev_number;
 
 /* DMA registres */
 
-#define HIFN_DMA_CRA 			0x0C	/* DMA Command Ring Address */
-#define HIFN_DMA_SDRA 			0x1C	/* DMA Source Data Ring Address */
+#define HIFN_DMA_CRA			0x0C	/* DMA Command Ring Address */
+#define HIFN_DMA_SDRA			0x1C	/* DMA Source Data Ring Address */
 #define HIFN_DMA_RRA			0x2C	/* DMA Result Ring Address */
 #define HIFN_DMA_DDRA			0x3C	/* DMA Destination Data Ring Address */
 #define HIFN_DMA_STCTL			0x40	/* DMA Status and Control */
-#define HIFN_DMA_INTREN 		0x44	/* DMA Interrupt Enable */
+#define HIFN_DMA_INTREN			0x44	/* DMA Interrupt Enable */
 #define HIFN_DMA_CFG1			0x48	/* DMA Configuration #1 */
 #define HIFN_DMA_CFG2			0x6C	/* DMA Configuration #2 */
 #define HIFN_CHIP_ID			0x98	/* Chip ID */
@@ -352,10 +348,10 @@ static atomic_t hifn_dev_number;
 #define HIFN_NAMESIZE			32
 #define HIFN_MAX_RESULT_ORDER		5
 
-#define	HIFN_D_CMD_RSIZE		24*1
-#define	HIFN_D_SRC_RSIZE		80*1
-#define	HIFN_D_DST_RSIZE		80*1
-#define	HIFN_D_RES_RSIZE		24*1
+#define	HIFN_D_CMD_RSIZE		(24 * 1)
+#define	HIFN_D_SRC_RSIZE		(80 * 1)
+#define	HIFN_D_DST_RSIZE		(80 * 1)
+#define	HIFN_D_RES_RSIZE		(24 * 1)
 
 #define HIFN_D_DST_DALIGN		4
 
@@ -380,17 +376,16 @@ static atomic_t hifn_dev_number;
 #define	HIFN_MAX_RESULT			(8 + 4 + 4 + 20 + 4)
 #define HIFN_USED_RESULT		12
 
-struct hifn_desc
-{
+struct hifn_desc {
 	volatile __le32		l;
 	volatile __le32		p;
 };
 
 struct hifn_dma {
-	struct hifn_desc	cmdr[HIFN_D_CMD_RSIZE+1];
-	struct hifn_desc	srcr[HIFN_D_SRC_RSIZE+1];
-	struct hifn_desc	dstr[HIFN_D_DST_RSIZE+1];
-	struct hifn_desc	resr[HIFN_D_RES_RSIZE+1];
+	struct hifn_desc	cmdr[HIFN_D_CMD_RSIZE + 1];
+	struct hifn_desc	srcr[HIFN_D_SRC_RSIZE + 1];
+	struct hifn_desc	dstr[HIFN_D_DST_RSIZE + 1];
+	struct hifn_desc	resr[HIFN_D_RES_RSIZE + 1];
 
 	u8			command_bufs[HIFN_D_CMD_RSIZE][HIFN_MAX_COMMAND];
 	u8			result_bufs[HIFN_D_CMD_RSIZE][HIFN_MAX_RESULT];
@@ -404,16 +399,15 @@ struct hifn_dma {
 	int			cmdk, srck, dstk, resk;
 };
 
-#define HIFN_FLAG_CMD_BUSY	(1<<0)
-#define HIFN_FLAG_SRC_BUSY	(1<<1)
-#define HIFN_FLAG_DST_BUSY	(1<<2)
-#define HIFN_FLAG_RES_BUSY	(1<<3)
-#define HIFN_FLAG_OLD_KEY	(1<<4)
+#define HIFN_FLAG_CMD_BUSY	(1 << 0)
+#define HIFN_FLAG_SRC_BUSY	(1 << 1)
+#define HIFN_FLAG_DST_BUSY	(1 << 2)
+#define HIFN_FLAG_RES_BUSY	(1 << 3)
+#define HIFN_FLAG_OLD_KEY	(1 << 4)
 
 #define HIFN_DEFAULT_ACTIVE_NUM	5
 
-struct hifn_device
-{
+struct hifn_device {
 	char			name[HIFN_NAMESIZE];
 
 	int			irq;
@@ -426,7 +420,7 @@ struct hifn_device
 
 	u32			dmareg;
 
-	void 			*sa[HIFN_D_RES_RSIZE];
+	void			*sa[HIFN_D_RES_RSIZE];
 
 	spinlock_t		lock;
 
@@ -441,7 +435,7 @@ struct hifn_device
 
 	struct tasklet_struct	tasklet;
 
-	struct crypto_queue 	queue;
+	struct crypto_queue	queue;
 	struct list_head	alg_list;
 
 	unsigned int		pk_clk_freq;
@@ -462,8 +456,7 @@ struct hifn_device
 #define	HIFN_D_JUMP			0x40000000
 #define	HIFN_D_VALID			0x80000000
 
-struct hifn_base_command
-{
+struct hifn_base_command {
 	volatile __le16		masks;
 	volatile __le16		session_num;
 	volatile __le16		total_source_count;
@@ -485,12 +478,11 @@ struct hifn_base_command
 /*
  * Structure to help build up the command data structure.
  */
-struct hifn_crypt_command
-{
-	volatile __le16 		masks;
-	volatile __le16 		header_skip;
-	volatile __le16 		source_count;
-	volatile __le16 		reserved;
+struct hifn_crypt_command {
+	volatile __le16		masks;
+	volatile __le16		header_skip;
+	volatile __le16		source_count;
+	volatile __le16		reserved;
 };
 
 #define	HIFN_CRYPT_CMD_ALG_MASK		0x0003		/* algorithm: */
@@ -516,12 +508,11 @@ struct hifn_crypt_command
 /*
  * Structure to help build up the command data structure.
  */
-struct hifn_mac_command
-{
-	volatile __le16 	masks;
-	volatile __le16 	header_skip;
-	volatile __le16 	source_count;
-	volatile __le16 	reserved;
+struct hifn_mac_command {
+	volatile __le16	masks;
+	volatile __le16	header_skip;
+	volatile __le16	source_count;
+	volatile __le16	reserved;
 };
 
 #define	HIFN_MAC_CMD_ALG_MASK		0x0001
@@ -545,12 +536,11 @@ struct hifn_mac_command
 #define	HIFN_MAC_CMD_POS_IPSEC		0x0200
 #define	HIFN_MAC_CMD_NEW_KEY		0x0800
 
-struct hifn_comp_command
-{
-	volatile __le16 	masks;
-	volatile __le16 	header_skip;
-	volatile __le16 	source_count;
-	volatile __le16 	reserved;
+struct hifn_comp_command {
+	volatile __le16		masks;
+	volatile __le16		header_skip;
+	volatile __le16		source_count;
+	volatile __le16		reserved;
 };
 
 #define	HIFN_COMP_CMD_SRCLEN_M		0xc000
@@ -564,12 +554,11 @@ struct hifn_comp_command
 #define	HIFN_COMP_CMD_ALG_MPPC		0x0001	/*   MPPC */
 #define	HIFN_COMP_CMD_ALG_LZS		0x0000	/*   LZS */
 
-struct hifn_base_result
-{
-	volatile __le16 	flags;
-	volatile __le16 	session;
-	volatile __le16 	src_cnt;		/* 15:0 of source count */
-	volatile __le16 	dst_cnt;		/* 15:0 of dest count */
+struct hifn_base_result {
+	volatile __le16		flags;
+	volatile __le16		session;
+	volatile __le16		src_cnt;		/* 15:0 of source count */
+	volatile __le16		dst_cnt;		/* 15:0 of dest count */
 };
 
 #define	HIFN_BASE_RES_DSTOVERRUN	0x0200	/* destination overrun */
@@ -578,8 +567,7 @@ struct hifn_base_result
 #define	HIFN_BASE_RES_DSTLEN_M		0x3000	/* 17:16 of dest count */
 #define	HIFN_BASE_RES_DSTLEN_S		12
 
-struct hifn_comp_result
-{
+struct hifn_comp_result {
 	volatile __le16		flags;
 	volatile __le16		crc;
 };
@@ -590,18 +578,16 @@ struct hifn_comp_result
 #define	HIFN_COMP_RES_ENDMARKER		0x0002	/* LZS: end marker seen */
 #define	HIFN_COMP_RES_SRC_NOTZERO	0x0001	/* source expired */
 
-struct hifn_mac_result
-{
-	volatile __le16 	flags;
-	volatile __le16 	reserved;
+struct hifn_mac_result {
+	volatile __le16		flags;
+	volatile __le16		reserved;
 	/* followed by 0, 6, 8, or 10 u16's of the MAC, then crypt */
 };
 
 #define	HIFN_MAC_RES_MISCOMPARE		0x0002	/* compare failed */
 #define	HIFN_MAC_RES_SRC_NOTZERO	0x0001	/* source expired */
 
-struct hifn_crypt_result
-{
+struct hifn_crypt_result {
 	volatile __le16		flags;
 	volatile __le16		reserved;
 };
@@ -616,11 +602,10 @@ struct hifn_crypt_result
 #define	HIFN_POLL_SCALAR	0x0
 #endif
 
-#define	HIFN_MAX_SEGLEN 	0xffff		/* maximum dma segment len */
+#define	HIFN_MAX_SEGLEN		0xffff		/* maximum dma segment len */
 #define	HIFN_MAX_DMALEN		0x3ffff		/* maximum dma length */
 
-struct hifn_crypto_alg
-{
+struct hifn_crypto_alg {
 	struct list_head	entry;
 	struct crypto_alg	alg;
 	struct hifn_device	*dev;
@@ -628,24 +613,21 @@ struct hifn_crypto_alg
 
 #define ASYNC_SCATTERLIST_CACHE	16
 
-#define ASYNC_FLAGS_MISALIGNED	(1<<0)
+#define ASYNC_FLAGS_MISALIGNED	(1 << 0)
 
-struct hifn_cipher_walk
-{
+struct hifn_cipher_walk {
 	struct scatterlist	cache[ASYNC_SCATTERLIST_CACHE];
 	u32			flags;
 	int			num;
 };
 
-struct hifn_context
-{
+struct hifn_context {
 	u8			key[HIFN_MAX_CRYPT_KEY_LENGTH];
 	struct hifn_device	*dev;
 	unsigned int		keysize;
 };
 
-struct hifn_request_context
-{
+struct hifn_request_context {
 	u8			*iv;
 	unsigned int		ivsize;
 	u8			op, type, mode, unused;
@@ -687,7 +669,7 @@ static void hifn_wait_puc(struct hifn_device *dev)
 	int i;
 	u32 ret;
 
-	for (i=10000; i > 0; --i) {
+	for (i = 10000; i > 0; --i) {
 		ret = hifn_read_0(dev, HIFN_0_PUCTRL);
 		if (!(ret & HIFN_PUCTRL_RESET))
 			break;
@@ -743,13 +725,12 @@ static void hifn_reset_dma(struct hifn_device *dev, int full)
 	hifn_reset_puc(dev);
 }
 
-static u32 hifn_next_signature(u_int32_t a, u_int cnt)
+static u32 hifn_next_signature(u32 a, u_int cnt)
 {
 	int i;
 	u32 v;
 
 	for (i = 0; i < cnt; i++) {
-
 		/* get the parity */
 		v = a & 0x80080125;
 		v ^= v >> 16;
@@ -840,16 +821,16 @@ static int hifn_init_pubrng(struct hifn_device *dev)
 	hifn_write_1(dev, HIFN_1_PUB_RESET, hifn_read_1(dev, HIFN_1_PUB_RESET) |
 			HIFN_PUBRST_RESET);
 
-	for (i=100; i > 0; --i) {
+	for (i = 100; i > 0; --i) {
 		mdelay(1);
 
 		if ((hifn_read_1(dev, HIFN_1_PUB_RESET) & HIFN_PUBRST_RESET) == 0)
 			break;
 	}
 
-	if (!i)
+	if (!i) {
 		dev_err(&dev->pdev->dev, "Failed to initialise public key engine.\n");
-	else {
+	} else {
 		hifn_write_1(dev, HIFN_1_PUB_IEN, HIFN_PUBIEN_DONE);
 		dev->dmareg |= HIFN_DMAIER_PUBDONE;
 		hifn_write_1(dev, HIFN_1_DMA_IER, dev->dmareg);
@@ -857,9 +838,7 @@ static int hifn_init_pubrng(struct hifn_device *dev)
 		dev_dbg(&dev->pdev->dev, "Public key engine has been successfully initialised.\n");
 	}
 
-	/*
-	 * Enable RNG engine.
-	 */
+	/* Enable RNG engine. */
 
 	hifn_write_1(dev, HIFN_1_RNG_CONFIG,
 			hifn_read_1(dev, HIFN_1_RNG_CONFIG) | HIFN_RNGCFG_ENA);
@@ -887,7 +866,7 @@ static int hifn_enable_crypto(struct hifn_device *dev)
 		}
 	}
 
-	if (offtbl == NULL) {
+	if (!offtbl) {
 		dev_err(&dev->pdev->dev, "Unknown card!\n");
 		return -ENODEV;
 	}
@@ -903,7 +882,7 @@ static int hifn_enable_crypto(struct hifn_device *dev)
 	hifn_write_1(dev, HIFN_1_UNLOCK_SECRET2, 0);
 	mdelay(1);
 
-	for (i=0; i<12; ++i) {
+	for (i = 0; i < 12; ++i) {
 		addr = hifn_next_signature(addr, offtbl[i] + 0x101);
 		hifn_write_1(dev, HIFN_1_UNLOCK_SECRET2, addr);
 
@@ -922,16 +901,14 @@ static void hifn_init_dma(struct hifn_device *dev)
 	u32 dptr = dev->desc_dma;
 	int i;
 
-	for (i=0; i<HIFN_D_CMD_RSIZE; ++i)
+	for (i = 0; i < HIFN_D_CMD_RSIZE; ++i)
 		dma->cmdr[i].p = __cpu_to_le32(dptr +
 				offsetof(struct hifn_dma, command_bufs[i][0]));
-	for (i=0; i<HIFN_D_RES_RSIZE; ++i)
+	for (i = 0; i < HIFN_D_RES_RSIZE; ++i)
 		dma->resr[i].p = __cpu_to_le32(dptr +
 				offsetof(struct hifn_dma, result_bufs[i][0]));
 
-	/*
-	 * Setup LAST descriptors.
-	 */
+	/* Setup LAST descriptors. */
 	dma->cmdr[HIFN_D_CMD_RSIZE].p = __cpu_to_le32(dptr +
 			offsetof(struct hifn_dma, cmdr[0]));
 	dma->srcr[HIFN_D_SRC_RSIZE].p = __cpu_to_le32(dptr +
@@ -951,7 +928,7 @@ static void hifn_init_dma(struct hifn_device *dev)
  * to calculate the optimal multiplier. For PCI we assume 66MHz, since that
  * allows us to operate without the risk of overclocking the chip. If it
  * actually uses 33MHz, the chip will operate at half the speed, this can be
- * overriden by specifying the frequency as module parameter (pci33).
+ * overridden by specifying the frequency as module parameter (pci33).
  *
  * Unfortunately the PCI clock is not very suitable since the HIFN needs a
  * stable clock and the PCI clock frequency may vary, so the default is the
@@ -1172,17 +1149,17 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 
 	mask = 0;
 	switch (rctx->op) {
-		case ACRYPTO_OP_DECRYPT:
-			mask = HIFN_BASE_CMD_CRYPT | HIFN_BASE_CMD_DECODE;
-			break;
-		case ACRYPTO_OP_ENCRYPT:
-			mask = HIFN_BASE_CMD_CRYPT;
-			break;
-		case ACRYPTO_OP_HMAC:
-			mask = HIFN_BASE_CMD_MAC;
-			break;
-		default:
-			goto err_out;
+	case ACRYPTO_OP_DECRYPT:
+		mask = HIFN_BASE_CMD_CRYPT | HIFN_BASE_CMD_DECODE;
+		break;
+	case ACRYPTO_OP_ENCRYPT:
+		mask = HIFN_BASE_CMD_CRYPT;
+		break;
+	case ACRYPTO_OP_HMAC:
+		mask = HIFN_BASE_CMD_MAC;
+		break;
+	default:
+		goto err_out;
 	}
 
 	buf_pos += hifn_setup_base_command(dev, buf_pos, nbytes,
@@ -1197,53 +1174,53 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 			md |= HIFN_CRYPT_CMD_NEW_IV;
 
 		switch (rctx->mode) {
-			case ACRYPTO_MODE_ECB:
-				md |= HIFN_CRYPT_CMD_MODE_ECB;
-				break;
-			case ACRYPTO_MODE_CBC:
-				md |= HIFN_CRYPT_CMD_MODE_CBC;
-				break;
-			case ACRYPTO_MODE_CFB:
-				md |= HIFN_CRYPT_CMD_MODE_CFB;
-				break;
-			case ACRYPTO_MODE_OFB:
-				md |= HIFN_CRYPT_CMD_MODE_OFB;
-				break;
-			default:
-				goto err_out;
+		case ACRYPTO_MODE_ECB:
+			md |= HIFN_CRYPT_CMD_MODE_ECB;
+			break;
+		case ACRYPTO_MODE_CBC:
+			md |= HIFN_CRYPT_CMD_MODE_CBC;
+			break;
+		case ACRYPTO_MODE_CFB:
+			md |= HIFN_CRYPT_CMD_MODE_CFB;
+			break;
+		case ACRYPTO_MODE_OFB:
+			md |= HIFN_CRYPT_CMD_MODE_OFB;
+			break;
+		default:
+			goto err_out;
 		}
 
 		switch (rctx->type) {
-			case ACRYPTO_TYPE_AES_128:
-				if (ctx->keysize != 16)
-					goto err_out;
-				md |= HIFN_CRYPT_CMD_KSZ_128 |
-					HIFN_CRYPT_CMD_ALG_AES;
-				break;
-			case ACRYPTO_TYPE_AES_192:
-				if (ctx->keysize != 24)
-					goto err_out;
-				md |= HIFN_CRYPT_CMD_KSZ_192 |
-					HIFN_CRYPT_CMD_ALG_AES;
-				break;
-			case ACRYPTO_TYPE_AES_256:
-				if (ctx->keysize != 32)
-					goto err_out;
-				md |= HIFN_CRYPT_CMD_KSZ_256 |
-					HIFN_CRYPT_CMD_ALG_AES;
-				break;
-			case ACRYPTO_TYPE_3DES:
-				if (ctx->keysize != 24)
-					goto err_out;
-				md |= HIFN_CRYPT_CMD_ALG_3DES;
-				break;
-			case ACRYPTO_TYPE_DES:
-				if (ctx->keysize != 8)
-					goto err_out;
-				md |= HIFN_CRYPT_CMD_ALG_DES;
-				break;
-			default:
+		case ACRYPTO_TYPE_AES_128:
+			if (ctx->keysize != 16)
+				goto err_out;
+			md |= HIFN_CRYPT_CMD_KSZ_128 |
+				HIFN_CRYPT_CMD_ALG_AES;
+			break;
+		case ACRYPTO_TYPE_AES_192:
+			if (ctx->keysize != 24)
+				goto err_out;
+			md |= HIFN_CRYPT_CMD_KSZ_192 |
+				HIFN_CRYPT_CMD_ALG_AES;
+			break;
+		case ACRYPTO_TYPE_AES_256:
+			if (ctx->keysize != 32)
+				goto err_out;
+			md |= HIFN_CRYPT_CMD_KSZ_256 |
+				HIFN_CRYPT_CMD_ALG_AES;
+			break;
+		case ACRYPTO_TYPE_3DES:
+			if (ctx->keysize != 24)
 				goto err_out;
+			md |= HIFN_CRYPT_CMD_ALG_3DES;
+			break;
+		case ACRYPTO_TYPE_DES:
+			if (ctx->keysize != 8)
+				goto err_out;
+			md |= HIFN_CRYPT_CMD_ALG_DES;
+			break;
+		default:
+			goto err_out;
 		}
 
 		buf_pos += hifn_setup_crypto_command(dev, buf_pos,
@@ -1263,8 +1240,9 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 			HIFN_D_VALID | HIFN_D_LAST |
 			HIFN_D_MASKDONEIRQ | HIFN_D_JUMP);
 		dma->cmdi = 0;
-	} else
-		dma->cmdr[dma->cmdi-1].l |= __cpu_to_le32(HIFN_D_VALID);
+	} else {
+		dma->cmdr[dma->cmdi - 1].l |= __cpu_to_le32(HIFN_D_VALID);
+	}
 
 	if (!(dev->flags & HIFN_FLAG_CMD_BUSY)) {
 		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_C_CTRL_ENA);
@@ -1422,7 +1400,7 @@ static int hifn_cipher_walk_init(struct hifn_cipher_walk *w,
 	sg_init_table(w->cache, num);
 
 	w->num = 0;
-	for (i=0; i<num; ++i) {
+	for (i = 0; i < num; ++i) {
 		struct page *page = alloc_page(gfp_flags);
 		struct scatterlist *s;
 
@@ -1442,7 +1420,7 @@ static void hifn_cipher_walk_exit(struct hifn_cipher_walk *w)
 {
 	int i;
 
-	for (i=0; i<w->num; ++i) {
+	for (i = 0; i < w->num; ++i) {
 		struct scatterlist *s = &w->cache[i];
 
 		__free_page(sg_page(s));
@@ -1523,10 +1501,10 @@ static int hifn_cipher_walk(struct ablkcipher_request *req,
 				 * to put there additional blocksized chunk,
 				 * so we mark that page as containing only
 				 * blocksize aligned chunks:
-				 * 	t->length = (slen & ~(HIFN_D_DST_DALIGN - 1));
+				 *	t->length = (slen & ~(HIFN_D_DST_DALIGN - 1));
 				 * and increase number of bytes to be processed
 				 * in next chunk:
-				 * 	nbytes += diff;
+				 *	nbytes += diff;
 				 */
 				nbytes += diff;
 
@@ -1873,7 +1851,7 @@ static void hifn_work(struct work_struct *work)
 				 reset);
 
 			dev_info(&dev->pdev->dev, "%s: res: ", __func__);
-			for (i=0; i<HIFN_D_RES_RSIZE; ++i) {
+			for (i = 0; i < HIFN_D_RES_RSIZE; ++i) {
 				pr_info("%x.%p ", dma->resr[i].l, dev->sa[i]);
 				if (dev->sa[i]) {
 					hifn_process_ready(dev->sa[i], -ENODEV);
@@ -1965,12 +1943,12 @@ static void hifn_flush(struct hifn_device *dev)
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int i;
 
-	for (i=0; i<HIFN_D_RES_RSIZE; ++i) {
+	for (i = 0; i < HIFN_D_RES_RSIZE; ++i) {
 		struct hifn_desc *d = &dma->resr[i];
 
 		if (dev->sa[i]) {
 			hifn_process_ready(dev->sa[i],
-				(d->l & __cpu_to_le32(HIFN_D_VALID))?-ENODEV:0);
+				(d->l & __cpu_to_le32(HIFN_D_VALID)) ? -ENODEV : 0);
 			hifn_complete_sa(dev, i);
 		}
 	}
@@ -2002,7 +1980,7 @@ static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	if (len == HIFN_DES_KEY_LENGTH) {
 		u32 tmp[DES_EXPKEY_WORDS];
 		int ret = des_ekey(tmp, key);
-		
+
 		if (unlikely(ret == 0) && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
 			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 			return -EINVAL;
@@ -2243,9 +2221,7 @@ static inline int hifn_encrypt_3des_ofb(struct ablkcipher_request *req)
 			ACRYPTO_TYPE_3DES, ACRYPTO_MODE_OFB);
 }
 
-/*
- * 3DES decryption functions.
- */
+/* 3DES decryption functions. */
 static inline int hifn_decrypt_3des_ecb(struct ablkcipher_request *req)
 {
 	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
@@ -2267,8 +2243,7 @@ static inline int hifn_decrypt_3des_ofb(struct ablkcipher_request *req)
 			ACRYPTO_TYPE_3DES, ACRYPTO_MODE_OFB);
 }
 
-struct hifn_alg_template
-{
+struct hifn_alg_template {
 	char name[CRYPTO_MAX_ALG_NAME];
 	char drv_name[CRYPTO_MAX_ALG_NAME];
 	unsigned int bsize;
@@ -2428,7 +2403,7 @@ static int hifn_alg_alloc(struct hifn_device *dev, struct hifn_alg_template *t)
 	struct hifn_crypto_alg *alg;
 	int err;
 
-	alg = kzalloc(sizeof(struct hifn_crypto_alg), GFP_KERNEL);
+	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
 	if (!alg)
 		return -ENOMEM;
 
@@ -2475,7 +2450,7 @@ static int hifn_register_alg(struct hifn_device *dev)
 {
 	int i, err;
 
-	for (i=0; i<ARRAY_SIZE(hifn_alg_templates); ++i) {
+	for (i = 0; i < ARRAY_SIZE(hifn_alg_templates); ++i) {
 		err = hifn_alg_alloc(dev, &hifn_alg_templates[i]);
 		if (err)
 			goto err_out_exit;
@@ -2520,7 +2495,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_out_disable_pci_device;
 
 	snprintf(name, sizeof(name), "hifn%d",
-			atomic_inc_return(&hifn_dev_number)-1);
+			atomic_inc_return(&hifn_dev_number) - 1);
 
 	err = pci_request_regions(pdev, name);
 	if (err)
@@ -2546,7 +2521,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	snprintf(dev->name, sizeof(dev->name), "%s", name);
 	spin_lock_init(&dev->lock);
 
-	for (i=0; i<3; ++i) {
+	for (i = 0; i < 3; ++i) {
 		unsigned long addr, size;
 
 		addr = pci_resource_start(pdev, i);
@@ -2570,7 +2545,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->pdev = pdev;
 	dev->irq = pdev->irq;
 
-	for (i=0; i<HIFN_D_RES_RSIZE; ++i)
+	for (i = 0; i < HIFN_D_RES_RSIZE; ++i)
 		dev->sa[i] = NULL;
 
 	pci_set_drvdata(pdev, dev);
@@ -2621,7 +2596,7 @@ err_out_free_desc:
 			dev->desc_virt, dev->desc_dma);
 
 err_out_unmap_bars:
-	for (i=0; i<3; ++i)
+	for (i = 0; i < 3; ++i)
 		if (dev->bar[i])
 			iounmap(dev->bar[i]);
 
@@ -2656,7 +2631,7 @@ static void hifn_remove(struct pci_dev *pdev)
 
 		pci_free_consistent(pdev, sizeof(struct hifn_dma),
 				dev->desc_virt, dev->desc_dma);
-		for (i=0; i<3; ++i)
+		for (i = 0; i < 3; ++i)
 			if (dev->bar[i])
 				iounmap(dev->bar[i]);
 
-- 
2.4.10

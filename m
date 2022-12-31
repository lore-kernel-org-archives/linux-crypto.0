Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 062BFC4332F
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Dec 2022 16:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiLaQZe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Dec 2022 11:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLaQZc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Dec 2022 11:25:32 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB61E631E
        for <linux-crypto@vger.kernel.org>; Sat, 31 Dec 2022 08:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672503929; bh=jNUySzNKe0tIotsU1ORRjsqfOdfoWfXnglNjKuUm+yo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CrExOXIfpuNEb4M9w4pmD36y45g7mir9Mu3lymKkYMAXSt/rsCWp/IgwXUc3oC8Ue
         p9fo6DZtX8vYKEGnWv1cEySmud93e3SzPXKOuJvb2IyH+OJ6MZpYseLHvUQWeXNLWt
         N0CFVV6Q4wXD74BRbBg0oAlAKrJ58AiVzQna1pT0X2z0HhUU4X0Sz6BD888ftpjsbt
         yjla/35jpiGkVP6yBFNEt68AsLT508ulkGobKS1x3vS1Pt5wHohcKT7kqtcnVSEyHX
         RrJkbvbL3NeCwRzZriP8WVsXigpd5hXaYD9bzK+le0jS3kaFxSNw3knYCSCxO0oLP8
         QVCB9Ph0GOUKQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.82.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M5wLT-1pAIxG0Na7-007XBU; Sat, 31
 Dec 2022 17:25:29 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v3 1/6] crypto/realtek: header definitions
Date:   Sat, 31 Dec 2022 17:25:20 +0100
Message-Id: <20221231162525.416709-2-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221231162525.416709-1-markus.stockhausen@gmx.de>
References: <20221231162525.416709-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:iDCJQ1tORjXACv0DfUpcAQYurzY/NKVKXZ53F9rpA7vuYwsdLct
 H1W4t82Q8tz4IH23+JuqTh9UjlULVIzGt5FY+KckK+/vaYwzV4i+QKKSzuqyeLe4I9jZHG9
 lgu+S5wP/YYJUeu/ti5pJHdN/qO3aM1Sggat0W6sZ5Ei1hNLGdb9TUijvJch3Kv6OF3ipFD
 /uRu6qlxiWXmgyZrU5mkA==
UI-OutboundReport: notjunk:1;M01:P0:rspuIXFmidE=;61oKe+G5fKV/H27DeI/4+g3qQIE
 sZWX6fQuhtEH9Hd+CPfsiSpJ12ZTjYWLBVqPXXyJHHhUjVKwXuONQDSA1HwH4RDvSfkLjZlQX
 oTOt1NJkiqGxxKvsXXfLvCXWD/bdhkjpmpk3HA0kKb9TaTL844do2hthKm3jJ2uzYPdX0KOPn
 pfGjbCbE0QrLAd6D9Ashl/in1mGpstVtbxazerPSWQnCzRktfD4tqZfPA0JIhkjDuJy9xToOT
 NS8anVjfX7O7i2q4kXzn4I6SKw+4o1TY+6t1Z+Uac3pa+or+yZilbm02Abw/SyVqxzT963MPu
 PPmSFq6O0b5Pv1HvIY9hIqJ5PfDdS1CVlSIiJQrSCh3X0Lv9ubROxM7SyzUSwP2X1vj7ZNyZY
 K9ikRm3jpEgfu56JWRRuWDHeO5YrgM+jnxBYKfa7mY9ucOBoSqphZPMU3DlPB3UEXIfVH6NKA
 qISCl/G4I+c+r8WQ/i89T9Z/gSNofF84XrSbf6Rj03b2l4AAhkcbMMagVW86Qw25Sf500m/7C
 p5zIv4rI25nyuCoxKOm9yVoROQCTU+I0nEv/DlSPa7Uu29SvAquJkcBDI0RcH4xS5mgFm8mMa
 4YtulxvgmFKlNT4B4ZQyAZY56y9q47WsOXoFTGoGf91uioXO+Mfq8LQxQ3qIf9jy0VYZk561S
 7kgPYsFqKoPRrNSw0G9gZ2fEOCIelR2U12IgdNyFyIYKukb0YQTk7jcdUlG+Rv/f1C6KM6VZc
 sCgzHrXTQuEknOfU7pcgEbgRNW1zOAlg/yGxuUPdAZdsqCVSB0VZgMAtDYzaKH+gIVhROXs1q
 ibXH2hjZW9mWL0jRfSEp5pJRrbPCo2g7XeA9ZOF5aT0YrU+gAVa+9/iyq97RmWu9GVDZkO5kk
 se/ncqJ9vRUTYQVwz7H6EnqG2MKOnxyogPmFHfqI4/SYQFODeCNobtPjTLk7HNGYKuSM9LQL2
 ZAViGieueFMSMmXRuZpoYAkxkOc=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add header definitions for new Realtek crypto device.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
=2D--
 drivers/crypto/realtek/realtek_crypto.h | 328 ++++++++++++++++++++++++
 1 file changed, 328 insertions(+)
 create mode 100644 drivers/crypto/realtek/realtek_crypto.h

diff --git a/drivers/crypto/realtek/realtek_crypto.h b/drivers/crypto/real=
tek/realtek_crypto.h
new file mode 100644
index 000000000000..66b977c082fd
=2D-- /dev/null
+++ b/drivers/crypto/realtek/realtek_crypto.h
@@ -0,0 +1,328 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Crypto acceleration support for Realtek crypto engine. Based on ideas =
from
+ * Rockchip & SafeXcel driver plus Realtek OpenWrt RTK.
+ *
+ * Copyright (c) 2022, Markus Stockhausen <markus.stockhausen@gmx.de>
+ */
+
+#ifndef __REALTEK_CRYPTO_H__
+#define __REALTEK_CRYPTO_H__
+
+#include <linux/interrupt.h>
+#include <crypto/aes.h>
+#include <crypto/md5.h>
+#include <crypto/hash.h>
+#include <crypto/sha1.h>
+#include <crypto/skcipher.h>
+
+/*
+ * The four engine registers for instrumentation of the hardware.
+ */
+#define RTCR_REG_SRC	0x0	/* Source descriptor starting address */
+#define RTCR_REG_DST	0x4	/* Destination Descriptor starting address */
+#define RTCR_REG_CMD	0x8	/* Command/Status Register */
+#define RTCR_REG_CTR	0xC	/* Control Register */
+/*
+ * Engine Command/Status Register.
+ */
+#define RTCR_CMD_SDUEIP	BIT(15)	/* Src desc unavail error interrupt pendi=
ng */
+#define RTCR_CMD_SDLEIP	BIT(14)	/* Src desc length error interrupt pendin=
g */
+#define RTCR_CMD_DDUEIP	BIT(13)	/* Dst desc unavail error interrupt pendi=
ng */
+#define RTCR_CMD_DDOKIP	BIT(12)	/* Dst dsec ok interrupt pending */
+#define	RTCR_CMD_DABFIP	BIT(11)	/* Data address buffer interrupt pending =
*/
+#define RTCR_CMD_POLL	BIT(1)	/* Descriptor polling. Set to kick engine */
+#define RTCR_CMD_SRST	BIT(0)	/* Software reset, write 1 to reset */
+/*
+ * Engine Control Register
+ */
+#define RTCR_CTR_SDUEIE	BIT(15)	/* Src desc unavail error interrupt enabl=
e */
+#define RTCR_CTR_SDLEIE	BIT(14)	/* Src desc length error interrupt enable=
 */
+#define RTCR_CTR_DDUEIE	BIT(13)	/* Dst desc unavail error interrupt enabl=
e */
+#define RTCR_CTR_DDOKIE	BIT(12)	/* Dst desc ok interrupt enable */
+#define RTCR_CTR_DABFIE	BIT(11)	/* Data address buffer interrupt enable *=
/
+#define RTCR_CTR_LBKM	BIT(8)	/* Loopback mode enable */
+#define RTCR_CTR_SAWB	BIT(7)	/* Source address write back =3D work inplac=
e */
+#define RTCR_CTR_CKE	BIT(6)	/* Clock enable */
+#define RTCR_CTR_DDMMSK	0x38	/* Destination DMA max burst size mask */
+#define RTCR_CTR_DDM16	0x00	/* Destination DMA max burst size 16 bytes */
+#define RTCR_CTR_DDM32	0x08	/* Destination DMA max burst size 32 bytes */
+#define RTCR_CTR_DDM64	0x10	/* Destination DMA max burst size 64 bytes */
+#define RTCR_CTR_DDM128	0x18	/* Destination DMA max burst size 128 bytes =
*/
+#define RTCR_CTR_SDMMSK	0x07	/* Source DMA max burst size mask */
+#define RTCR_CTR_SDM16	0x00	/* Source DMA max burst size 16 bytes */
+#define RTCR_CTR_SDM32	0x01	/* Source DMA max burst size 32 bytes */
+#define RTCR_CTR_SDM64	0x02	/* Source DMA max burst size 64 bytes */
+#define RTCR_CTR_SDM128	0x03	/* Source DMA max burst size 128 bytes */
+
+/*
+ * Module settings and constants. Some of the limiter values have been ch=
osen
+ * based on testing (e.g. ring sizes). Others are based on real hardware
+ * limits (e.g. scatter, request size, hash size).
+ */
+#define RTCR_SRC_RING_SIZE		64
+#define RTCR_DST_RING_SIZE		16
+#define RTCR_BUF_RING_SIZE		32768
+#define RTCR_MAX_REQ_SIZE		8192
+#define RTCR_MAX_SG			8
+#define RTCR_MAX_SG_AHASH		(RTCR_MAX_SG - 1)
+#define RTCR_MAX_SG_SKCIPHER		(RTCR_MAX_SG - 3)
+#define RTCR_HASH_VECTOR_SIZE		SHA1_DIGEST_SIZE
+
+#define RTCR_ALG_AHASH			0
+#define RTCR_ALG_SKCIPHER		1
+
+#define RTCR_HASH_UPDATE		BIT(0)
+#define RTCR_HASH_FINAL			BIT(1)
+#define RTCR_HASH_BUF_SIZE		SHA1_BLOCK_SIZE
+#define RTCR_HASH_PAD_SIZE		((SHA1_BLOCK_SIZE + 8) / sizeof(u64))
+
+#define RTCR_REQ_SG_MASK		0xff
+#define RTCR_REQ_MD5			BIT(8)
+#define RTCR_REQ_SHA1			BIT(9)
+#define RTCR_REQ_FB_ACT			BIT(10)
+#define RTCR_REQ_FB_RDY			BIT(11)
+
+/*
+ * Crypto ring source data descripter. This data is fed into the engine. =
It
+ * takes all information about the input data and the type of cypher/hash
+ * algorithm that we want to apply. Each request consists of several sour=
ce
+ * descriptors.
+ */
+struct rtcr_src_desc {
+	u32		opmode;
+	u32		len;
+	u32		dummy;
+	phys_addr_t	paddr;
+};
+
+#define RTCR_SRC_DESC_SIZE		(sizeof(struct rtcr_src_desc))
+/*
+ * Owner: This flag identifies the owner of the block. When we send the
+ * descripter to the ring set this flag to 1. Once the crypto engine has
+ * finished processing this will be reset to 0.
+ */
+#define RTCR_SRC_OP_OWN_ASIC		BIT(31)
+#define RTCR_SRC_OP_OWN_CPU		0
+/*
+ * End of ring: Setting this flag to 1 tells the crypto engine that this =
is
+ * the last descriptor of the whole ring (not the request). If set the en=
gine
+ * will not increase the processing pointer afterwards but will jump back=
 to
+ * the first descriptor address it was initialized with.
+ */
+#define	RTCR_SRC_OP_EOR			BIT(30)
+#define RTCR_SRC_OP_CALC_EOR(idx)	((idx =3D=3D RTCR_SRC_RING_SIZE - 1) ? =
\
+					RTCR_SRC_OP_EOR : 0)
+/*
+ * First segment: If set to 1 this is the first descriptor of a request. =
All
+ * descriptors that follow will have this flag set to 0 belong to the sam=
e
+ * request.
+ */
+#define RTCR_SRC_OP_FS			BIT(29)
+/*
+ * Mode select: Set to 00b for crypto only, set to 01b for hash only, 10b=
 for
+ * hash then crypto or 11b for crypto then hash.
+ */
+#define RTCR_SRC_OP_MS_CRYPTO		0
+#define RTCR_SRC_OP_MS_HASH		BIT(26)
+#define RTCR_SRC_OP_MS_HASH_CRYPTO	BIT(27)
+#define RTCR_SRC_OP_MS_CRYPTO_HASH	GENMASK(27, 26)
+/*
+ * Key application management: Only relevant for cipher (AES/3DES/DES) mo=
de. If
+ * using AES or DES it has to be set to 0 (000b) for decryption and 7 (11=
1b) for
+ * encryption. For 3DES it has to be set to 2 (010b =3D decrypt, encrypt,=
 decrypt)
+ * for decryption and 5 (101b =3D encrypt, decrypt, encrypt) for encrypti=
on.
+ */
+#define RTCR_SRC_OP_KAM_DEC		0
+#define RTCR_SRC_OP_KAM_ENC		GENMASK(25, 23)
+#define RTCR_SRC_OP_KAM_3DES_DEC	BIT(24)
+#define RTCR_SRC_OP_KAM_3DES_ENC	(BIT(23) | BIT(25))
+/*
+ * AES/3DES/DES mode & key length: Upper two bits for AES mode. If set to=
 values
+ * other than 0 we want to encrypt/decrypt with AES. The values are 01b f=
or 128
+ * bit key length, 10b for 192 bit key length and 11b for 256 bit key len=
gth.
+ * If AES is disabled (upper two bits 00b) then the lowest bit determines=
 if we
+ * want to use 3DES (1) or DES (0).
+ */
+#define RTCR_SRC_OP_CIPHER_FROM_KEY(k)	((k - 8) << 18)
+#define RTCR_SRC_OP_CIPHER_AES_128	BIT(21)
+#define RTCR_SRC_OP_CIPHER_AES_192	BIT(22)
+#define RTCR_SRC_OP_CIPHER_AES_256	GENMASK(22, 21)
+#define RTCR_SRC_OP_CIPHER_3DES		BIT(20)
+#define RTCR_SRC_OP_CIPHER_DES		0
+#define RTCR_SRC_OP_CIPHER_MASK		GENMASK(22, 20)
+/*
+ * Cipher block mode: Determines the block mode of a cipher request. Set =
to 00b
+ * for ECB, 01b for CTR and 10b for CTR.
+ */
+#define RTCR_SRC_OP_CRYPT_ECB		0
+#define RTCR_SRC_OP_CRYPT_CTR		BIT(18)
+#define RTCR_SRC_OP_CRYPT_CBC		BIT(19)
+/*
+ * Hash mode: Set to 1 for MD5 or 0 for SHA1 calculation.
+ */
+#define RTCR_SRC_OP_HASH_MD5		BIT(16)
+#define	RTCR_SRC_OP_HASH_SHA1		0
+
+#define RTCR_SRC_OP_DUMMY_LEN		128
+
+/*
+ * Crypto ring destination data descriptor. Data inside will be fed to th=
e
+ * engine and if we process a hash request we get the resulting hash from=
 here.
+ * Each request consists of exactly one destination descriptor.
+ */
+struct rtcr_dst_desc {
+	u32		opmode;
+	phys_addr_t	paddr;
+	u32		dummy;
+	u32		vector[RTCR_HASH_VECTOR_SIZE / sizeof(u32)];
+};
+
+#define RTCR_DST_DESC_SIZE		(sizeof(struct rtcr_dst_desc))
+/*
+ * Owner: This flag identifies the owner of the block. When we send the
+ * descripter to the ring set this flag to 1. Once the crypto engine has
+ * finished processing this will be reset to 0.
+ */
+#define RTCR_DST_OP_OWN_ASIC		BIT(31)
+#define RTCR_DST_OP_OWN_CPU		0
+/*
+ * End of ring: Setting this flag to 1 tells the crypto engine that this =
is
+ * the last descriptor of the whole ring (not the request). If set the en=
gine
+ * will not increase the processing pointer afterwards but will jump back=
 to
+ * the first descriptor address it was initialized with.
+ */
+#define	RTCR_DST_OP_EOR			BIT(30)
+#define RTCR_DST_OP_CALC_EOR(idx)	((idx =3D=3D RTCR_DST_RING_SIZE - 1) ? =
\
+					RTCR_DST_OP_EOR : 0)
+
+/*
+ * Writeback descriptor. This descriptor maintains additional data per re=
quest
+ * about post processing. E.g. the hash result or a cipher that was writt=
en to
+ * the internal buffer only.
+ */
+struct rtcr_wbk_desc {
+	void				*dst;
+	void				*src;
+	int				off;
+	int				len;
+};
+/*
+ * To keep the size of the descriptor a power of 2 (cache line aligned) t=
he
+ * length field can denote special writeback requests that need another t=
ype of
+ * postprocessing.
+ */
+#define RTCR_WB_LEN_DONE		(0)
+#define RTCR_WB_LEN_HASH		(-1)
+#define RTCR_WB_LEN_SG_DIRECT		(-2)
+
+struct rtcr_crypto_dev {
+	char				buf_ring[RTCR_BUF_RING_SIZE];
+	struct rtcr_src_desc		src_ring[RTCR_SRC_RING_SIZE];
+	struct rtcr_dst_desc		dst_ring[RTCR_DST_RING_SIZE];
+	struct rtcr_wbk_desc		wbk_ring[RTCR_DST_RING_SIZE];
+
+	/* modified under ring lock */
+	int				cpu_src_idx;
+	int				cpu_dst_idx;
+	int				cpu_buf_idx;
+
+	/* modified in (serialized) tasklet */
+	int				pp_src_idx;
+	int				pp_dst_idx;
+	int				pp_buf_idx;
+
+	/* modified under asic lock */
+	int				asic_dst_idx;
+	int				asic_src_idx;
+	bool				busy;
+
+	int				irq;
+	spinlock_t			asiclock;
+	spinlock_t			ringlock;
+	struct tasklet_struct		done_task;
+	wait_queue_head_t		done_queue;
+
+	void __iomem			*base;
+	dma_addr_t			src_dma;
+	dma_addr_t			dst_dma;
+
+	struct platform_device		*pdev;
+	struct device			*dev;
+};
+
+struct rtcr_alg_template {
+	struct rtcr_crypto_dev *cdev;
+	int type;
+	int opmode;
+	union {
+		struct skcipher_alg skcipher;
+		struct ahash_alg ahash;
+	} alg;
+};
+
+struct rtcr_ahash_ctx {
+	struct rtcr_crypto_dev	*cdev;
+	struct crypto_ahash	*fback;
+	int			opmode;
+};
+
+struct rtcr_ahash_req {
+	int state;
+	/* Data from here is lost if fallback switch happens */
+	u32 vector[RTCR_HASH_VECTOR_SIZE];
+	u64 totallen;
+	char buf[RTCR_HASH_BUF_SIZE];
+	int buflen;
+};
+
+union rtcr_fallback_state {
+	struct md5_state md5;
+	struct sha1_state sha1;
+};
+
+struct rtcr_skcipher_ctx {
+	struct rtcr_crypto_dev	*cdev;
+	int			opmode;
+	int			keylen;
+	dma_addr_t		keydma;
+	u32			keyenc[AES_KEYSIZE_256 / sizeof(u32)];
+	u32			keydec[AES_KEYSIZE_256 / sizeof(u32)];
+};
+
+extern struct rtcr_alg_template rtcr_ahash_md5;
+extern struct rtcr_alg_template rtcr_ahash_sha1;
+extern struct rtcr_alg_template rtcr_skcipher_ecb_aes;
+extern struct rtcr_alg_template rtcr_skcipher_cbc_aes;
+extern struct rtcr_alg_template rtcr_skcipher_ctr_aes;
+
+extern void rtcr_lock_ring(struct rtcr_crypto_dev *cdev);
+extern void rtcr_unlock_ring(struct rtcr_crypto_dev *cdev);
+
+extern int rtcr_alloc_ring(struct rtcr_crypto_dev *cdev, int srclen,
+			   int *srcidx, int *dstidx, int buflen, char **buf);
+extern void rtcr_add_src_ahash_to_ring(struct rtcr_crypto_dev *cdev, int =
idx,
+				       int opmode, int totallen);
+extern void rtcr_add_src_pad_to_ring(struct rtcr_crypto_dev *cdev,
+				     int idx, int len);
+extern void rtcr_add_src_skcipher_to_ring(struct rtcr_crypto_dev *cdev, i=
nt idx,
+					  int opmode, int totallen,
+					  struct rtcr_skcipher_ctx *sctx);
+extern void rtcr_add_src_to_ring(struct rtcr_crypto_dev *cdev, int idx,
+				 void *vaddr, int blocklen, int totallen);
+extern void rtcr_add_wbk_to_ring(struct rtcr_crypto_dev *cdev, int idx,
+				 void *dst, int off);
+extern void rtcr_add_dst_to_ring(struct rtcr_crypto_dev *cdev, int idx,
+				 void *reqdst, int reqlen, void *wbkdst,
+				 int wbkoff);
+
+extern void rtcr_kick_engine(struct rtcr_crypto_dev *cdev);
+
+extern void rtcr_prepare_request(struct rtcr_crypto_dev *cdev);
+extern void rtcr_finish_request(struct rtcr_crypto_dev *cdev, int opmode,
+				int totallen);
+extern int rtcr_wait_for_request(struct rtcr_crypto_dev *cdev, int idx);
+
+extern inline int rtcr_inc_src_idx(int idx, int cnt);
+extern inline int rtcr_inc_dst_idx(int idx, int cnt);
+#endif
=2D-
2.38.1


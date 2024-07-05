Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A3B5FBB7
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jul 2024 17:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720199611; cv=none; b=nNTdxSITZuekk4j3XV1CXWmpZhemgVCMvfmdRHa5GyAittrUYrVL1xp2GhJezYheftmg5yzvDOc1pQHCAfbRz5czPw0wbvyq4AMZ98Wtsmi1dWe4tRfsrvRde/zjfRhGv/z43O+rvAnBg3WRK/eCKup1+fdodZEFb/KTHHD/+BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720199611; c=relaxed/simple;
	bh=37O1g8bWOSroMvCA4Wc/V5z5JyfK/guhgVpJNW+nMEg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g63nHZK3DIpjX+7CmZOeNrufdG7sPEq67hxKtO/kFLIzzVAwRG2x6WSy+HhaqI5RcEcaXZJ9G7R6chbFzungCOkA+g+ZwDdC7/3A8WzMkIAuMikqkY2m3AuCddKFQzpt8KML4I5zJ3sfv5pDoJtiQSLCMuZw//mfq6AXqxZf+0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=WL33rjHu; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="WL33rjHu"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-376266a65c8so6960535ab.3
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jul 2024 10:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1720199604; x=1720804404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fqZmwwOXwRyy4W0r/yP6ae3TORpsWXC7TGjz+FZoPY=;
        b=WL33rjHuqH9hDPYp9qe5KbRxlRNf/hrtYv891ZuCuWyqeB7KPrPCzTJHxMD1iF08Uc
         U/lWoL+Hk8UfZ55NLBPh5n2ADVc0MZzoD+Zd+bYW6uwqXYB5nhcbszuHgKAP8baHXUGG
         LtbzMRNBN8pmw4YE4zW+WinbGmXt2vytRa8w0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720199604; x=1720804404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5fqZmwwOXwRyy4W0r/yP6ae3TORpsWXC7TGjz+FZoPY=;
        b=f8mn9SWnHoq9UJ1+nxOGPfx6etb0HMUKqalerfNc8+lJNGUmWLH7+Hxp7hjZxR6ST9
         KJrJkl9XmsyWQfeFA7i7ThPKXpQUjnabvCXxYKaIbXc98UiAbQkJyjgvBM6F4T2q2xqP
         lLAISsv2oy/unjWOMr/RNN1ULjwEX6F1p9O/HcLYwq4khtrfl/wwHvd9WKdNYUJOxrZG
         oHQ6cKTwXobWH7MzwzQGqoOtvKCAzhK8ltusHRgbjWLrOL04IVB+o+CajPRTZemMl2tb
         3FT3bNwOr+zI1dooV0gDS+yht9CqaQlH05+hSKtFf9g/xEWm6oANgQLfWvBoukIxil8j
         qXyw==
X-Forwarded-Encrypted: i=1; AJvYcCX0ovNz6FVIA8cV6BCec8dLxfy8KDFkdH1609EEMJHMRcFLsvt+FlYg8nmNZmMBZzd579ovzQhKEwaBp7+hFeBi/drUpMdHkSwAaGYj
X-Gm-Message-State: AOJu0Yy7UVtMKlKOf3mBiQmec+AMC68OHYupwdu3pDsxlvKx+Lvm3j/J
	mSMO9uwRrMxTXDqEXzCywIOUltJdN9iwaMNr4hMAGXRd8F1oGjMhokQ5CZJLqs4=
X-Google-Smtp-Source: AGHT+IGSfy9jSHgNYtz0tZS59k5getYukN+ZF42FYBBaAkaJeJBZZy3YnVVLV5doqFNN+fDdyc+YuA==
X-Received: by 2002:a05:6e02:1785:b0:376:21ee:4f7 with SMTP id e9e14a558f8ab-38398af7a21mr63673585ab.14.1720199603784;
        Fri, 05 Jul 2024 10:13:23 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b030d5d0bsm3174889b3a.14.2024.07.05.10.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jul 2024 10:13:22 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v6 1/6] Add SPAcc Skcipher support
Date: Fri,  5 Jul 2024 22:42:50 +0530
Message-Id: <20240705171255.2618994-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240705171255.2618994-1-pavitrakumarm@vayavyalabs.com>
References: <20240705171255.2618994-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/dwc-spacc/spacc_core.c      | 1129 ++++++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h      |  826 ++++++++++++++
 drivers/crypto/dwc-spacc/spacc_device.c    |  340 ++++++
 drivers/crypto/dwc-spacc/spacc_device.h    |  231 ++++
 drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++++++
 drivers/crypto/dwc-spacc/spacc_hal.h       |  114 ++
 drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 ++++++
 drivers/crypto/dwc-spacc/spacc_manager.c   |  650 +++++++++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c  |  712 ++++++++++++
 9 files changed, 4685 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c

diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
new file mode 100644
index 000000000000..2bad071efd9b
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_core.c
@@ -0,0 +1,1129 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/of_device.h>
+#include <linux/vmalloc.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include "spacc_hal.h"
+#include "spacc_core.h"
+
+static const u8 spacc_ctrl_map[SPACC_CTRL_VER_SIZE][SPACC_CTRL_MAPSIZE] = {
+	{ 0, 8, 4, 12, 24, 16, 31, 25, 26, 27, 28, 29, 14, 15 },
+	{ 0, 8, 3, 12, 24, 16, 31, 25, 26, 27, 28, 29, 14, 15 },
+	{ 0, 4, 8, 13, 15, 16, 24, 25, 26, 27, 28, 29, 30, 31 }
+};
+
+static const int keysizes[2][7] = {
+	/*   1    2   4   8  16  32   64 */
+	{ 5,   8, 16, 24, 32,  0,   0 },  /* cipher key sizes*/
+	{ 8,  16, 20, 24, 32, 64, 128 },  /* hash key sizes*/
+};
+
+
+/* bits are 40, 64, 128, 192, 256, and top bit for hash */
+static const unsigned char template[] = {
+	[CRYPTO_MODE_NULL]              = 0,
+	[CRYPTO_MODE_AES_ECB]           = 28,	/* AESECB 128/224/256 */
+	[CRYPTO_MODE_AES_CBC]           = 28,	/* AESCBC 128/224/256 */
+	[CRYPTO_MODE_AES_CTR]           = 28,	/* AESCTR 128/224/256 */
+	[CRYPTO_MODE_AES_CCM]           = 28,	/* AESCCM 128/224/256 */
+	[CRYPTO_MODE_AES_GCM]           = 28,	/* AESGCM 128/224/256 */
+	[CRYPTO_MODE_AES_F8]            = 28,	/* AESF8  128/224/256 */
+	[CRYPTO_MODE_AES_XTS]           = 20,	/* AESXTS 128/256 */
+	[CRYPTO_MODE_AES_CFB]           = 28,	/* AESCFB 128/224/256 */
+	[CRYPTO_MODE_AES_OFB]           = 28,	/* AESOFB 128/224/256 */
+	[CRYPTO_MODE_AES_CS1]           = 28,	/* AESCS1 128/224/256 */
+	[CRYPTO_MODE_AES_CS2]           = 28,	/* AESCS2 128/224/256 */
+	[CRYPTO_MODE_AES_CS3]           = 28,	/* AESCS3 128/224/256 */
+	[CRYPTO_MODE_MULTI2_ECB]        = 0,	/* MULTI2 */
+	[CRYPTO_MODE_MULTI2_CBC]        = 0,	/* MULTI2 */
+	[CRYPTO_MODE_MULTI2_OFB]        = 0,	/* MULTI2 */
+	[CRYPTO_MODE_MULTI2_CFB]        = 0,	/* MULTI2 */
+	[CRYPTO_MODE_3DES_CBC]          = 8,	/* 3DES CBC */
+	[CRYPTO_MODE_3DES_ECB]          = 8,	/* 3DES ECB */
+	[CRYPTO_MODE_DES_CBC]           = 2,	/* DES CBC */
+	[CRYPTO_MODE_DES_ECB]           = 2,	/* DES ECB */
+	[CRYPTO_MODE_KASUMI_ECB]        = 4,	/* KASUMI ECB */
+	[CRYPTO_MODE_KASUMI_F8]         = 4,	/* KASUMI F8 */
+	[CRYPTO_MODE_SNOW3G_UEA2]       = 4,	/* SNOW3G */
+	[CRYPTO_MODE_ZUC_UEA3]          = 4,	/* ZUC */
+	[CRYPTO_MODE_CHACHA20_STREAM]   = 16,	/* CHACHA20 */
+	[CRYPTO_MODE_CHACHA20_POLY1305] = 16,	/* CHACHA20 */
+	[CRYPTO_MODE_SM4_ECB]           = 4,	/* SM4ECB 128 */
+	[CRYPTO_MODE_SM4_CBC]           = 4,	/* SM4CBC 128 */
+	[CRYPTO_MODE_SM4_CFB]           = 4,	/* SM4CFB 128 */
+	[CRYPTO_MODE_SM4_OFB]           = 4,	/* SM4OFB 128 */
+	[CRYPTO_MODE_SM4_CTR]           = 4,	/* SM4CTR 128 */
+	[CRYPTO_MODE_SM4_CCM]           = 4,	/* SM4CCM 128 */
+	[CRYPTO_MODE_SM4_GCM]           = 4,	/* SM4GCM 128 */
+	[CRYPTO_MODE_SM4_F8]            = 4,	/* SM4F8  128 */
+	[CRYPTO_MODE_SM4_XTS]           = 4,	/* SM4XTS 128 */
+	[CRYPTO_MODE_SM4_CS1]           = 4,	/* SM4CS1 128 */
+	[CRYPTO_MODE_SM4_CS2]           = 4,	/* SM4CS2 128 */
+	[CRYPTO_MODE_SM4_CS3]           = 4,	/* SM4CS3 128 */
+
+	[CRYPTO_MODE_HASH_MD5]          = 242,
+	[CRYPTO_MODE_HMAC_MD5]          = 242,
+	[CRYPTO_MODE_HASH_SHA1]         = 242,
+	[CRYPTO_MODE_HMAC_SHA1]         = 242,
+	[CRYPTO_MODE_HASH_SHA224]       = 242,
+	[CRYPTO_MODE_HMAC_SHA224]       = 242,
+	[CRYPTO_MODE_HASH_SHA256]       = 242,
+	[CRYPTO_MODE_HMAC_SHA256]       = 242,
+	[CRYPTO_MODE_HASH_SHA384]       = 242,
+	[CRYPTO_MODE_HMAC_SHA384]       = 242,
+	[CRYPTO_MODE_HASH_SHA512]       = 242,
+	[CRYPTO_MODE_HMAC_SHA512]       = 242,
+	[CRYPTO_MODE_HASH_SHA512_224]   = 242,
+	[CRYPTO_MODE_HMAC_SHA512_224]   = 242,
+	[CRYPTO_MODE_HASH_SHA512_256]   = 242,
+	[CRYPTO_MODE_HMAC_SHA512_256]   = 242,
+	[CRYPTO_MODE_MAC_XCBC]          = 154,	/* XaCBC */
+	[CRYPTO_MODE_MAC_CMAC]          = 154,	/* CMAC */
+	[CRYPTO_MODE_MAC_KASUMI_F9]     = 130,	/* KASUMI */
+	[CRYPTO_MODE_MAC_SNOW3G_UIA2]   = 130,	/* SNOW */
+	[CRYPTO_MODE_MAC_ZUC_UIA3]      = 130,	/* ZUC */
+	[CRYPTO_MODE_MAC_POLY1305]      = 144,
+	[CRYPTO_MODE_SSLMAC_MD5]        = 130,
+	[CRYPTO_MODE_SSLMAC_SHA1]       = 132,
+	[CRYPTO_MODE_HASH_CRC32]        = 0,
+	[CRYPTO_MODE_MAC_MICHAEL]       = 129,
+
+	[CRYPTO_MODE_HASH_SHA3_224]     = 242,
+	[CRYPTO_MODE_HASH_SHA3_256]     = 242,
+	[CRYPTO_MODE_HASH_SHA3_384]     = 242,
+	[CRYPTO_MODE_HASH_SHA3_512]     = 242,
+	[CRYPTO_MODE_HASH_SHAKE128]     = 242,
+	[CRYPTO_MODE_HASH_SHAKE256]     = 242,
+	[CRYPTO_MODE_HASH_CSHAKE128]    = 130,
+	[CRYPTO_MODE_HASH_CSHAKE256]    = 130,
+	[CRYPTO_MODE_MAC_KMAC128]       = 242,
+	[CRYPTO_MODE_MAC_KMAC256]       = 242,
+	[CRYPTO_MODE_MAC_KMACXOF128]    = 242,
+	[CRYPTO_MODE_MAC_KMACXOF256]    = 242,
+	[CRYPTO_MODE_HASH_SM3]          = 242,
+	[CRYPTO_MODE_HMAC_SM3]          = 242,
+	[CRYPTO_MODE_MAC_SM4_XCBC]      = 242,
+	[CRYPTO_MODE_MAC_SM4_CMAC]      = 242,
+};
+
+int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
+		    int nbytes, struct pdu_ddt *ddt, int dma_direction)
+{
+	struct scatterlist *sg_entry, *sgl;
+	int nents, orig_nents;
+	int i, rc;
+
+	orig_nents = sg_nents(sg);
+	if (orig_nents > 1) {
+		sgl = sg_last(sg, orig_nents);
+		if (sgl->length == 0)
+			orig_nents--;
+	}
+	nents = dma_map_sg(dev, sg, orig_nents, dma_direction);
+
+	if (nents <= 0)
+		return -ENOMEM;
+
+	/* require ATOMIC operations */
+	rc = pdu_ddt_init(ddt, nents | 0x80000000);
+	if (rc < 0) {
+		dma_unmap_sg(dev, sg, nents, dma_direction);
+		return -EIO;
+	}
+
+	for_each_sg(sg, sg_entry, nents, i) {
+		pdu_ddt_add(ddt, sg_dma_address(sg_entry),
+			    sg_dma_len(sg_entry));
+	}
+
+	dma_sync_sg_for_device(dev, sg, nents, dma_direction);
+
+	return nents;
+}
+
+int spacc_set_operation(struct spacc_device *spacc, int handle, int op,
+			u32 prot, uint32_t icvcmd, uint32_t icvoff,
+			uint32_t icvsz, uint32_t sec_key)
+{
+	int ret = CRYPTO_OK;
+	struct spacc_job *job = NULL;
+
+	if (handle < 0 || handle > SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	job = &spacc->job[handle];
+	if (!job)
+		return -EIO;
+
+	job->op = op;
+	if (op == OP_ENCRYPT)
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ENCRYPT);
+	else
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ENCRYPT);
+
+	switch (prot) {
+	case ICV_HASH:        /* HASH of plaintext */
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_PT);
+		break;
+	case ICV_HASH_ENCRYPT:
+		/* HASH the plaintext and encrypt the lot */
+		/* ICV_PT and ICV_APPEND must be set too */
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC);
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_PT);
+		 /* This mode is not valid when BIT_ALIGN != 0 */
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_APPEND);
+		break;
+	case ICV_ENCRYPT_HASH: /* HASH the ciphertext */
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ICV_PT);
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC);
+		break;
+	case ICV_IGNORE:
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	job->icv_len = icvsz;
+
+	switch (icvcmd) {
+	case IP_ICV_OFFSET:
+		job->icv_offset = icvoff;
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_ICV_APPEND);
+		break;
+	case IP_ICV_APPEND:
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_ICV_APPEND);
+		break;
+	case IP_ICV_IGNORE:
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (sec_key)
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_SEC_KEY);
+
+	return ret;
+}
+
+static int _spacc_fifo_full(struct spacc_device *spacc, uint32_t prio)
+{
+	if (spacc->config.is_qos)
+		return readl(spacc->regmap + SPACC_REG_FIFO_STAT) &
+		       SPACC_FIFO_STAT_CMDX_FULL(prio);
+	else
+		return readl(spacc->regmap + SPACC_REG_FIFO_STAT) &
+		       SPACC_FIFO_STAT_CMD0_FULL;
+}
+
+/* When proc_sz != 0 it overrides the ddt_len value
+ * defined in the context referenced by 'job_idx'
+ */
+int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
+				int job_idx, struct pdu_ddt *src_ddt,
+				struct pdu_ddt *dst_ddt, u32 proc_sz,
+				uint32_t aad_offset, uint32_t pre_aad_sz,
+				u32 post_aad_sz, uint32_t iv_offset,
+				uint32_t prio)
+{
+	int i;
+	struct spacc_job *job;
+	int ret = CRYPTO_OK, proc_len;
+
+	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	switch (prio)  {
+	case SPACC_SW_CTRL_PRIO_MED:
+		if (spacc->config.cmd1_fifo_depth == 0)
+			return -EINVAL;
+		break;
+	case SPACC_SW_CTRL_PRIO_LOW:
+		if (spacc->config.cmd2_fifo_depth == 0)
+			return -EINVAL;
+		break;
+	}
+
+	job = &spacc->job[job_idx];
+	if (!job)
+		return -EIO;
+
+	/* process any jobs in the jb*/
+	if (use_jb && spacc_process_jb(spacc) != 0)
+		goto fifo_full;
+
+	if (_spacc_fifo_full(spacc, prio)) {
+		if (use_jb)
+			goto fifo_full;
+		else
+			return -EBUSY;
+	}
+
+	/* compute the length we must process, in decrypt mode
+	 * with an ICV (hash, hmac or CCM modes)
+	 * we must subtract the icv length from the buffer size
+	 */
+	if (proc_sz == SPACC_AUTO_SIZE) {
+		proc_len = src_ddt->len;
+
+		if (job->op == OP_DECRYPT &&
+		    (job->hash_mode > 0 ||
+		     job->enc_mode == CRYPTO_MODE_AES_CCM ||
+		     job->enc_mode == CRYPTO_MODE_AES_GCM)  &&
+		    !(job->ctrl & SPACC_CTRL_MASK(SPACC_CTRL_ICV_ENC)))
+			proc_len = src_ddt->len - job->icv_len;
+	} else {
+		proc_len = proc_sz;
+	}
+
+	if (pre_aad_sz & SPACC_AADCOPY_FLAG) {
+		job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
+		pre_aad_sz &= ~(SPACC_AADCOPY_FLAG);
+	} else {
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_AAD_COPY);
+	}
+
+	job->pre_aad_sz  = pre_aad_sz;
+	job->post_aad_sz = post_aad_sz;
+
+	if (spacc->config.dma_type == SPACC_DMA_DDT) {
+		pdu_io_cached_write(spacc->regmap + SPACC_REG_SRC_PTR,
+				    (uint32_t)src_ddt->phys,
+				    &spacc->cache.src_ptr);
+		pdu_io_cached_write(spacc->regmap + SPACC_REG_DST_PTR,
+				    (uint32_t)dst_ddt->phys,
+				    &spacc->cache.dst_ptr);
+	} else if (spacc->config.dma_type == SPACC_DMA_LINEAR) {
+		pdu_io_cached_write(spacc->regmap + SPACC_REG_SRC_PTR,
+				    (uint32_t)src_ddt->virt[0],
+				    &spacc->cache.src_ptr);
+		pdu_io_cached_write(spacc->regmap + SPACC_REG_DST_PTR,
+				    (uint32_t)dst_ddt->virt[0],
+				    &spacc->cache.dst_ptr);
+	} else {
+		return -EIO;
+	}
+
+	pdu_io_cached_write(spacc->regmap + SPACC_REG_PROC_LEN,
+			    proc_len - job->post_aad_sz,
+			    &spacc->cache.proc_len);
+	pdu_io_cached_write(spacc->regmap + SPACC_REG_ICV_LEN,
+			    job->icv_len, &spacc->cache.icv_len);
+	pdu_io_cached_write(spacc->regmap + SPACC_REG_ICV_OFFSET,
+			    job->icv_offset, &spacc->cache.icv_offset);
+	pdu_io_cached_write(spacc->regmap + SPACC_REG_PRE_AAD_LEN,
+			    job->pre_aad_sz, &spacc->cache.pre_aad);
+	pdu_io_cached_write(spacc->regmap + SPACC_REG_POST_AAD_LEN,
+			    job->post_aad_sz, &spacc->cache.post_aad);
+	pdu_io_cached_write(spacc->regmap + SPACC_REG_IV_OFFSET,
+			    iv_offset, &spacc->cache.iv_offset);
+	pdu_io_cached_write(spacc->regmap + SPACC_REG_OFFSET,
+			    aad_offset, &spacc->cache.offset);
+	pdu_io_cached_write(spacc->regmap + SPACC_REG_AUX_INFO,
+			    AUX_DIR(job->auxinfo_dir) |
+			    AUX_BIT_ALIGN(job->auxinfo_bit_align) |
+			    AUX_CBC_CS(job->auxinfo_cs_mode),
+			    &spacc->cache.aux);
+
+	if (job->first_use == 1) {
+		writel(job->ckey_sz | SPACC_SET_KEY_CTX(job->ctx_idx),
+		       spacc->regmap + SPACC_REG_KEY_SZ);
+		writel(job->hkey_sz | SPACC_SET_KEY_CTX(job->ctx_idx),
+		       spacc->regmap + SPACC_REG_KEY_SZ);
+	}
+
+	job->job_swid = spacc->job_next_swid;
+	spacc->job_lookup[job->job_swid] = job_idx;
+	spacc->job_next_swid =
+		(spacc->job_next_swid + 1) % SPACC_MAX_JOBS;
+	writel(SPACC_SW_CTRL_ID_SET(job->job_swid) |
+	       SPACC_SW_CTRL_PRIO_SET(prio),
+	       spacc->regmap + SPACC_REG_SW_CTRL);
+	writel(job->ctrl, spacc->regmap + SPACC_REG_CTRL);
+
+	/* Clear an expansion key after the first call*/
+	if (job->first_use == 1) {
+		job->first_use = 0;
+		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
+	}
+
+	return ret;
+
+fifo_full:
+	/* try to add a job to the job buffers*/
+	i = spacc->jb_head + 1;
+	if (i == SPACC_MAX_JOB_BUFFERS)
+		i = 0;
+
+	if (i == spacc->jb_tail)
+		return -EBUSY;
+
+	spacc->job_buffer[spacc->jb_head] = (struct spacc_job_buffer) {
+		.active		= 1,
+		.job_idx	= job_idx,
+		.src		= src_ddt,
+		.dst		= dst_ddt,
+		.proc_sz	= proc_sz,
+		.aad_offset	= aad_offset,
+		.pre_aad_sz	= pre_aad_sz,
+		.post_aad_sz	= post_aad_sz,
+		.iv_offset	= iv_offset,
+		.prio		= prio
+	};
+
+	spacc->jb_head = i;
+
+	return CRYPTO_USED_JB;
+}
+
+int spacc_packet_enqueue_ddt(struct spacc_device *spacc, int job_idx,
+			     struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
+			     u32 proc_sz, u32 aad_offset, uint32_t pre_aad_sz,
+			     uint32_t post_aad_sz, u32 iv_offset, uint32_t prio)
+{
+	int ret;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(&spacc->lock, lock_flags);
+	ret = spacc_packet_enqueue_ddt_ex(spacc, 1, job_idx, src_ddt,
+					  dst_ddt, proc_sz, aad_offset,
+					  pre_aad_sz, post_aad_sz,
+					  iv_offset, prio);
+	spin_unlock_irqrestore(&spacc->lock, lock_flags);
+
+	return ret;
+}
+
+static int spacc_packet_dequeue(struct spacc_device *spacc, int job_idx)
+{
+	int ret = CRYPTO_OK;
+	struct spacc_job *job = &spacc->job[job_idx];
+	unsigned long lock_flag;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	if (!job && !(job_idx == SPACC_JOB_IDX_UNUSED)) {
+		ret = -EIO;
+	} else if (job->job_done) {
+		job->job_done  = 0;
+		ret = job->job_err;
+	} else {
+		ret = -EINPROGRESS;
+	}
+
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+int spacc_isenabled(struct spacc_device *spacc, int mode, int keysize)
+{
+	int x;
+
+	if (mode < 0 || mode > CRYPTO_MODE_LAST)
+		return 0;
+
+	if (mode == CRYPTO_MODE_NULL    ||
+	    mode == CRYPTO_MODE_AES_XTS ||
+	    mode == CRYPTO_MODE_SM4_XTS ||
+	    mode == CRYPTO_MODE_AES_F8  ||
+	    mode == CRYPTO_MODE_SM4_F8  ||
+	    spacc->config.modes[mode] & 128)
+		return 1;
+
+	for (x = 0; x < 6; x++) {
+		if (keysizes[0][x] == keysize) {
+			if (spacc->config.modes[mode] & (1 << x))
+				return 1;
+			else
+				return 0;
+		}
+	}
+
+	return 0;
+}
+
+/* Releases a crypto context back into appropriate module's pool*/
+int spacc_close(struct spacc_device *dev, int handle)
+{
+	return spacc_job_release(dev, handle);
+}
+
+static void spacc_static_modes(struct spacc_device *spacc, int x, int y)
+{
+	/* Disable the algos that as not supported here */
+	switch (x) {
+	case CRYPTO_MODE_AES_F8:
+	case CRYPTO_MODE_AES_CFB:
+	case CRYPTO_MODE_AES_OFB:
+	case CRYPTO_MODE_MULTI2_ECB:
+	case CRYPTO_MODE_MULTI2_CBC:
+	case CRYPTO_MODE_MULTI2_CFB:
+	case CRYPTO_MODE_MULTI2_OFB:
+	case CRYPTO_MODE_MAC_POLY1305:
+	case CRYPTO_MODE_HASH_CRC32:
+		/* Disable the modes */
+		spacc->config.modes[x] &= ~(1 << y);
+		break;
+	default:
+		break;/* Algos are enabled */
+	}
+}
+
+int spacc_static_config(struct spacc_device *spacc)
+{
+
+	int x, y;
+
+	for (x = 0; x < ARRAY_SIZE(template); x++) {
+		spacc->config.modes[x] = template[x];
+
+		for (y = 0; y < (ARRAY_SIZE(keysizes[0])); y++) {
+			/* List static modes */
+			spacc_static_modes(spacc, x, y);
+		}
+	}
+
+	return 0;
+}
+
+int spacc_clone_handle(struct spacc_device *spacc, int old_handle,
+		       void *cbdata)
+{
+	int new_handle;
+
+	new_handle = spacc_job_request(spacc, spacc->job[old_handle].ctx_idx);
+	if (new_handle < 0)
+		return new_handle;
+
+	spacc->job[new_handle]          = spacc->job[old_handle];
+	spacc->job[new_handle].job_used = new_handle;
+	spacc->job[new_handle].cbdata   = cbdata;
+
+	return new_handle;
+}
+
+/* Allocates a job for spacc module context and initialize
+ * it with an appropriate type.
+ */
+int spacc_open(struct spacc_device *spacc, int enc, int hash, int ctxid,
+	       int secure_mode, spacc_callback cb, void *cbdata)
+{
+	u32 ctrl = 0;
+	int job_idx = 0;
+	int ret = CRYPTO_OK;
+	struct spacc_job *job = NULL;
+
+	job_idx = spacc_job_request(spacc, ctxid);
+	if (job_idx < 0)
+		return -EIO;
+
+	job = &spacc->job[job_idx];
+
+	if (secure_mode && job->ctx_idx > spacc->config.num_sec_ctx) {
+		pr_debug("ERR: For secure contexts");
+		pr_debug("ERR: Job ctx ID is outside allowed range\n");
+		spacc_job_release(spacc, job_idx);
+		return -EIO;
+	}
+
+	job->auxinfo_cs_mode	= 0;
+	job->auxinfo_bit_align	= 0;
+	job->auxinfo_dir	= 0;
+	job->icv_len		= 0;
+
+	switch (enc) {
+	case CRYPTO_MODE_NULL:
+		break;
+	case CRYPTO_MODE_AES_ECB:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+		break;
+	case CRYPTO_MODE_AES_CBC:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+		break;
+	case CRYPTO_MODE_AES_CS3:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+		job->auxinfo_cs_mode = 3;
+		break;
+	case CRYPTO_MODE_AES_CTR:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CTR);
+		break;
+	case CRYPTO_MODE_AES_XTS:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_AES);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_XTS);
+		break;
+	case CRYPTO_MODE_3DES_CBC:
+	case CRYPTO_MODE_DES_CBC:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_DES);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+		break;
+	case CRYPTO_MODE_3DES_ECB:
+	case CRYPTO_MODE_DES_ECB:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_DES);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+		break;
+	case CRYPTO_MODE_CHACHA20_STREAM:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_CHACHA20);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CHACHA_STREAM);
+		break;
+	case CRYPTO_MODE_SM4_ECB:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_ECB);
+		break;
+	case CRYPTO_MODE_SM4_CBC:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+		break;
+	case CRYPTO_MODE_SM4_CS3:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CBC);
+		job->auxinfo_cs_mode = 3;
+		break;
+	case CRYPTO_MODE_SM4_CTR:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_CTR);
+		break;
+	case CRYPTO_MODE_SM4_XTS:
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_ALG, C_SM4);
+		ctrl |= SPACC_CTRL_SET(SPACC_CTRL_CIPH_MODE, CM_XTS);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_MSG_BEGIN) |
+		SPACC_CTRL_MASK(SPACC_CTRL_MSG_END);
+
+	if (ret != CRYPTO_OK) {
+		spacc_job_release(spacc, job_idx);
+	} else {
+		ret		= job_idx;
+		job->first_use	= 1;
+		job->enc_mode	= enc;
+		job->hash_mode	= hash;
+		job->ckey_sz	= 0;
+		job->hkey_sz	= 0;
+		job->job_done	= 0;
+		job->job_swid	= 0;
+		job->job_secure	= !!secure_mode;
+
+		job->auxinfo_bit_align = 0;
+		job->job_err	= -EINPROGRESS;
+		job->ctrl	= ctrl |
+				  SPACC_CTRL_SET(SPACC_CTRL_CTX_IDX,
+						 job->ctx_idx);
+		job->cb		= cb;
+		job->cbdata	= cbdata;
+	}
+
+	return ret;
+}
+
+static int spacc_xof_stringsize_autodetect(struct spacc_device *spacc)
+{
+	void *virt;
+	dma_addr_t dma;
+	struct pdu_ddt	ddt;
+	int ss, alg, i, stat;
+	unsigned long spacc_ctrl[2] = {0xF400B400, 0xF400D400};
+	unsigned char buf[256];
+	unsigned long buflen, rbuf;
+	unsigned char test_str[6] = {0x01, 0x20, 0x54, 0x45, 0x53, 0x54};
+	unsigned char md[2][16] = {
+			 {0xc3, 0x6d, 0x0a, 0x88, 0xfa, 0x37, 0x4c, 0x9b,
+			  0x44, 0x74, 0xeb, 0x00, 0x5f, 0xe8, 0xca, 0x25},
+			 {0x68, 0x77, 0x04, 0x11, 0xf8, 0xe3, 0xb0, 0x1e,
+			  0x0d, 0xbf, 0x71, 0x6a, 0xe9, 0x87, 0x1a, 0x0d}};
+
+	virt = dma_alloc_coherent(get_ddt_device(), 256, &dma, GFP_KERNEL);
+	if (!virt)
+		return -EIO;
+
+	if (pdu_ddt_init(&ddt, 1)) {
+		dma_free_coherent(get_ddt_device(), 256, virt, dma);
+		return -EIO;
+	}
+	pdu_ddt_add(&ddt, dma, 256);
+
+	/* populate registers for jobs*/
+	writel((uint32_t)ddt.phys, spacc->regmap + SPACC_REG_SRC_PTR);
+	writel((uint32_t)ddt.phys, spacc->regmap + SPACC_REG_DST_PTR);
+
+	writel(16, spacc->regmap + SPACC_REG_PROC_LEN);
+	writel(16, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
+	writel(16, spacc->regmap + SPACC_REG_ICV_LEN);
+	writel(6, spacc->regmap + SPACC_REG_KEY_SZ);
+	writel(0, spacc->regmap + SPACC_REG_SW_CTRL);
+
+	/* repeat for 2 algorithms, CSHAKE128 and KMAC128*/
+	for (alg = 0; (alg < 2) && (spacc->config.string_size == 0); alg++) {
+		/* repeat for 4 string_size sizes*/
+		for (ss = 0; ss < 4; ss++) {
+			buflen = (32UL << ss);
+			if (buflen > spacc->config.hash_page_size)
+				break;
+
+			/* clear I/O memory*/
+			memset(virt, 0, 256);
+
+			/* clear buf and then insert test string*/
+			memset(buf, 0, sizeof(buf));
+			memcpy(buf, test_str, sizeof(test_str));
+			memcpy(buf + (buflen >> 1), test_str, sizeof(test_str));
+
+			/* write key context */
+			pdu_to_dev_s(spacc->regmap + SPACC_CTX_HASH_KEY,
+				     buf,
+				     spacc->config.hash_page_size >> 2,
+				     spacc->config.spacc_endian);
+
+			/* write ctrl register */
+			writel(spacc_ctrl[alg], spacc->regmap + SPACC_REG_CTRL);
+
+			/* wait for job to complete */
+			for (i = 0; i < 20; i++) {
+				rbuf = 0;
+				rbuf = readl(spacc->regmap +
+					     SPACC_REG_FIFO_STAT) &
+				       SPACC_FIFO_STAT_STAT_EMPTY;
+				if (!rbuf) {
+					/* check result, if it matches,
+					 * we have string_size
+					 */
+					writel(1, spacc->regmap +
+					       SPACC_REG_STAT_POP);
+					rbuf = 0;
+					rbuf = readl(spacc->regmap +
+						     SPACC_REG_STATUS);
+					stat = SPACC_GET_STATUS_RET_CODE(rbuf);
+					if ((!memcmp(virt, md[alg], 16)) &&
+					    stat == SPACC_OK) {
+						spacc->config.string_size =
+								(16 << ss);
+					}
+					break;
+				}
+			}
+		}
+	}
+
+	/* reset registers */
+	writel(0, spacc->regmap + SPACC_REG_IRQ_CTRL);
+	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
+	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_IRQ_STAT);
+
+	writel(0, spacc->regmap + SPACC_REG_SRC_PTR);
+	writel(0, spacc->regmap + SPACC_REG_DST_PTR);
+	writel(0, spacc->regmap + SPACC_REG_PROC_LEN);
+	writel(0, spacc->regmap + SPACC_REG_ICV_LEN);
+	writel(0, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
+
+	pdu_ddt_free(&ddt);
+	dma_free_coherent(get_ddt_device(), 256, virt, dma);
+
+	return CRYPTO_OK;
+}
+
+/* free up the memory */
+void spacc_fini(struct spacc_device *spacc)
+{
+	vfree(spacc->ctx);
+	vfree(spacc->job);
+}
+
+int spacc_init(void __iomem *baseaddr, struct spacc_device *spacc,
+	       struct pdu_info *info)
+{
+	unsigned long id;
+	char version_string[3][16]  = { "SPACC", "SPACC-PDU" };
+	char idx_string[2][16]      = { "(Normal Port)", "(Secure Port)" };
+	char dma_type_string[4][16] = { "Unknown", "Scattergather", "Linear",
+					"Unknown" };
+
+	if (!baseaddr) {
+		pr_debug("ERR: baseaddr is NULL\n");
+		return -1;
+	}
+	if (!spacc) {
+		pr_debug("ERR: spacc is NULL\n");
+		return -1;
+	}
+
+	memset(spacc, 0, sizeof(*spacc));
+	spin_lock_init(&spacc->lock);
+	spin_lock_init(&spacc->ctx_lock);
+
+	/* assign the baseaddr*/
+	spacc->regmap = baseaddr;
+
+	/* version info*/
+	spacc->config.version     = info->spacc_version.version;
+	spacc->config.pdu_version = (info->pdu_config.major << 4) |
+				    info->pdu_config.minor;
+	spacc->config.project     = info->spacc_version.project;
+	spacc->config.is_pdu      = info->spacc_version.is_pdu;
+	spacc->config.is_qos      = info->spacc_version.qos;
+
+	/* misc*/
+	spacc->config.is_partial        = info->spacc_version.partial;
+	spacc->config.num_ctx           = info->spacc_config.num_ctx;
+	spacc->config.ciph_page_size    = 1U <<
+					  info->spacc_config.ciph_ctx_page_size;
+
+	spacc->config.hash_page_size    = 1U <<
+					  info->spacc_config.hash_ctx_page_size;
+
+	spacc->config.dma_type          = info->spacc_config.dma_type;
+	spacc->config.idx               = info->spacc_version.vspacc_idx;
+	spacc->config.cmd0_fifo_depth   = info->spacc_config.cmd0_fifo_depth;
+	spacc->config.cmd1_fifo_depth   = info->spacc_config.cmd1_fifo_depth;
+	spacc->config.cmd2_fifo_depth   = info->spacc_config.cmd2_fifo_depth;
+	spacc->config.stat_fifo_depth   = info->spacc_config.stat_fifo_depth;
+	spacc->config.fifo_cnt          = 1;
+	spacc->config.is_ivimport       = info->spacc_version.ivimport;
+
+	/* ctrl register map*/
+	if (spacc->config.version <= 0x4E)
+		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_0];
+	else if (spacc->config.version <= 0x60)
+		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_1];
+	else
+		spacc->config.ctrl_map = spacc_ctrl_map[SPACC_CTRL_VER_2];
+
+	spacc->job_next_swid   = 0;
+	spacc->wdcnt           = 0;
+	spacc->config.wd_timer = SPACC_WD_TIMER_INIT;
+
+	/* version 4.10 uses IRQ,
+	 * above uses WD and we don't support below 4.00
+	 */
+	if (spacc->config.version < 0x40) {
+		pr_debug("ERR: Unsupported SPAcc version\n");
+		return -EIO;
+	} else if (spacc->config.version < 0x4B) {
+		spacc->op_mode = SPACC_OP_MODE_IRQ;
+	} else {
+		spacc->op_mode = SPACC_OP_MODE_WD;
+	}
+
+	/* set threshold and enable irq
+	 * on 4.11 and newer cores we can derive this
+	 * from the HW reported depths.
+	 */
+	if (spacc->config.stat_fifo_depth == 1)
+		spacc->config.ideal_stat_level = 1;
+	else if (spacc->config.stat_fifo_depth <= 4)
+		spacc->config.ideal_stat_level =
+					spacc->config.stat_fifo_depth - 1;
+	else if (spacc->config.stat_fifo_depth <= 8)
+		spacc->config.ideal_stat_level =
+					spacc->config.stat_fifo_depth - 2;
+	else
+		spacc->config.ideal_stat_level =
+					spacc->config.stat_fifo_depth - 4;
+
+	/* determine max PROClen value */
+	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_PROC_LEN);
+	spacc->config.max_msg_size = readl(spacc->regmap + SPACC_REG_PROC_LEN);
+
+	/* read config info*/
+	if (spacc->config.is_pdu) {
+		pr_debug("PDU:\n");
+		pr_debug("   MAJOR      : %u\n", info->pdu_config.major);
+		pr_debug("   MINOR      : %u\n", info->pdu_config.minor);
+	}
+
+	id = readl(spacc->regmap + SPACC_REG_ID);
+	pr_debug("SPACC ID: (%08lx)\n", (unsigned long)id);
+	pr_debug("   MAJOR      : %x\n", info->spacc_version.major);
+	pr_debug("   MINOR      : %x\n", info->spacc_version.minor);
+	pr_debug("   QOS        : %x\n", info->spacc_version.qos);
+	pr_debug("   IVIMPORT   : %x\n", spacc->config.is_ivimport);
+
+	if (spacc->config.version >= 0x48)
+		pr_debug("   TYPE       : %lx (%s)\n", SPACC_ID_TYPE(id),
+			version_string[SPACC_ID_TYPE(id) & 3]);
+
+	pr_debug("   AUX        : %x\n", info->spacc_version.qos);
+	pr_debug("   IDX        : %lx %s\n", SPACC_ID_VIDX(id),
+			spacc->config.is_secure ?
+			(idx_string[spacc->config.is_secure_port & 1]) : "");
+	pr_debug("   PARTIAL    : %x\n", info->spacc_version.partial);
+	pr_debug("   PROJECT    : %x\n", info->spacc_version.project);
+
+	if (spacc->config.version >= 0x48)
+		id = readl(spacc->regmap + SPACC_REG_CONFIG);
+	else
+		id = 0xFFFFFFFF;
+
+	pr_debug("SPACC CFG: (%08lx)\n", id);
+	pr_debug("   CTX CNT    : %u\n", info->spacc_config.num_ctx);
+	pr_debug("   VSPACC CNT : %u\n", info->spacc_config.num_vspacc);
+	pr_debug("   CIPH SZ    : %-3lu bytes\n", 1UL <<
+				  info->spacc_config.ciph_ctx_page_size);
+	pr_debug("   HASH SZ    : %-3lu bytes\n", 1UL <<
+				  info->spacc_config.hash_ctx_page_size);
+	pr_debug("   DMA TYPE   : %u (%s)\n", info->spacc_config.dma_type,
+			dma_type_string[info->spacc_config.dma_type & 3]);
+	pr_debug("   MAX PROCLEN: %lu bytes\n", (unsigned long)
+				  spacc->config.max_msg_size);
+	pr_debug("   FIFO CONFIG :\n");
+	pr_debug("      CMD0 DEPTH: %d\n", spacc->config.cmd0_fifo_depth);
+
+	if (spacc->config.is_qos) {
+		pr_debug("      CMD1 DEPTH: %d\n",
+				spacc->config.cmd1_fifo_depth);
+		pr_debug("      CMD2 DEPTH: %d\n",
+				spacc->config.cmd2_fifo_depth);
+	}
+	pr_debug("      STAT DEPTH: %d\n", spacc->config.stat_fifo_depth);
+
+	if (spacc->config.dma_type == SPACC_DMA_DDT) {
+		writel(0x1234567F, baseaddr + SPACC_REG_DST_PTR);
+		writel(0xDEADBEEF, baseaddr + SPACC_REG_SRC_PTR);
+
+		if (((readl(baseaddr + SPACC_REG_DST_PTR)) !=
+					(0x1234567F & SPACC_DST_PTR_PTR)) ||
+		    ((readl(baseaddr + SPACC_REG_SRC_PTR)) !=
+		     (0xDEADBEEF & SPACC_SRC_PTR_PTR))) {
+			pr_debug("ERR: Failed to set pointers\n");
+			goto ERR;
+		}
+	}
+
+	/* zero the IRQ CTRL/EN register
+	 * (to make sure we're in a sane state)
+	 */
+	writel(0, spacc->regmap + SPACC_REG_IRQ_CTRL);
+	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
+	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_IRQ_STAT);
+
+	/* init cache*/
+	memset(&spacc->cache, 0, sizeof(spacc->cache));
+	writel(0, spacc->regmap + SPACC_REG_SRC_PTR);
+	writel(0, spacc->regmap + SPACC_REG_DST_PTR);
+	writel(0, spacc->regmap + SPACC_REG_PROC_LEN);
+	writel(0, spacc->regmap + SPACC_REG_ICV_LEN);
+	writel(0, spacc->regmap + SPACC_REG_ICV_OFFSET);
+	writel(0, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
+	writel(0, spacc->regmap + SPACC_REG_POST_AAD_LEN);
+	writel(0, spacc->regmap + SPACC_REG_IV_OFFSET);
+	writel(0, spacc->regmap + SPACC_REG_OFFSET);
+	writel(0, spacc->regmap + SPACC_REG_AUX_INFO);
+
+	spacc->ctx = vmalloc(sizeof(struct spacc_ctx) * spacc->config.num_ctx);
+	if (!spacc->ctx)
+		goto ERR;
+
+	spacc->job = vmalloc(sizeof(struct spacc_job) * SPACC_MAX_JOBS);
+	if (!spacc->job)
+		goto ERR;
+
+	/* initialize job_idx and lookup table */
+	spacc_job_init_all(spacc);
+
+	/* initialize contexts */
+	spacc_ctx_init_all(spacc);
+
+	/* autodetect and set string size setting*/
+	if (spacc->config.version == 0x61 || spacc->config.version >= 0x65)
+		spacc_xof_stringsize_autodetect(spacc);
+
+	return CRYPTO_OK;
+ERR:
+	spacc_fini(spacc);
+	pr_debug("ERR: Crypto Failed\n");
+
+	return -EIO;
+}
+
+/* callback function to initialize tasklet running */
+void spacc_pop_jobs(unsigned long data)
+{
+	int num = 0;
+	struct spacc_priv *priv =  (struct spacc_priv *)data;
+	struct spacc_device *spacc = &priv->spacc;
+
+	/* decrement the WD CNT here since
+	 * now we're actually going to respond
+	 * to the IRQ completely
+	 */
+	if (spacc->wdcnt)
+		--(spacc->wdcnt);
+
+	spacc_pop_packets(spacc, &num);
+}
+
+int spacc_remove(struct platform_device *pdev)
+{
+	struct spacc_device *spacc;
+	struct spacc_priv *priv = platform_get_drvdata(pdev);
+
+	/* free test vector memory*/
+	spacc = &priv->spacc;
+	spacc_fini(spacc);
+
+	tasklet_kill(&priv->pop_jobs);
+
+	/* devm functions do proper cleanup */
+	pdu_mem_deinit(&pdev->dev);
+	dev_dbg(&pdev->dev, "removed!\n");
+
+	return 0;
+}
+
+int spacc_set_key_exp(struct spacc_device *spacc, int job_idx)
+{
+	struct spacc_ctx *ctx = NULL;
+	struct spacc_job *job = NULL;
+
+	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS) {
+		pr_debug("ERR: Invalid Job id specified (out of range)\n");
+		return -ENXIO;
+	}
+
+	job = &spacc->job[job_idx];
+	ctx = context_lookup_by_job(spacc, job_idx);
+
+	if (!ctx) {
+		pr_debug("ERR: Failed to find ctx id\n");
+		return -EIO;
+	}
+
+	job->ctrl |= SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
+
+	return CRYPTO_OK;
+}
+
+int spacc_compute_xcbc_key(struct spacc_device *spacc, int mode_id,
+			   int job_idx, const unsigned char *key,
+			   int keylen, unsigned char *xcbc_out)
+{
+	unsigned char *buf;
+	dma_addr_t bufphys;
+	struct pdu_ddt ddt;
+	unsigned char iv[16];
+	int err, i, handle, usecbc, ctx_idx;
+
+	if (job_idx >= 0 && job_idx < SPACC_MAX_JOBS)
+		ctx_idx = spacc->job[job_idx].ctx_idx;
+	else
+		ctx_idx = -1;
+
+	if (mode_id == CRYPTO_MODE_MAC_XCBC) {
+		/* figure out if we can schedule the key  */
+		if (spacc_isenabled(spacc, CRYPTO_MODE_AES_ECB, 16))
+			usecbc = 0;
+		else if (spacc_isenabled(spacc, CRYPTO_MODE_AES_CBC, 16))
+			usecbc = 1;
+		else
+			return -1;
+	} else if (mode_id == CRYPTO_MODE_MAC_SM4_XCBC) {
+		/* figure out if we can schedule the key  */
+		if (spacc_isenabled(spacc, CRYPTO_MODE_SM4_ECB, 16))
+			usecbc = 0;
+		else if (spacc_isenabled(spacc, CRYPTO_MODE_SM4_CBC, 16))
+			usecbc = 1;
+		else
+			return -1;
+	} else {
+		return -1;
+	}
+
+	memset(iv, 0, sizeof(iv));
+	memset(&ddt, 0, sizeof(ddt));
+
+	buf = dma_alloc_coherent(get_ddt_device(), 64, &bufphys, GFP_KERNEL);
+	if (!buf)
+		return -EINVAL;
+
+	handle = -1;
+
+	/* set to 1111...., 2222...., 333... */
+	for (i = 0; i < 48; i++)
+		buf[i] = (i >> 4) + 1;
+
+	/* build DDT */
+	err = pdu_ddt_init(&ddt, 1);
+	if (err)
+		goto xcbc_err;
+
+	pdu_ddt_add(&ddt, bufphys, 48);
+
+	/* open a handle in either CBC or ECB mode */
+	if (mode_id == CRYPTO_MODE_MAC_XCBC) {
+		handle = spacc_open(spacc, (usecbc ?
+				    CRYPTO_MODE_AES_CBC : CRYPTO_MODE_AES_ECB),
+				    CRYPTO_MODE_NULL, ctx_idx, 0, NULL, NULL);
+		if (handle < 0) {
+			err = handle;
+			goto xcbc_err;
+		}
+	} else if (mode_id == CRYPTO_MODE_MAC_SM4_XCBC) {
+		handle = spacc_open(spacc, (usecbc ?
+				    CRYPTO_MODE_SM4_CBC : CRYPTO_MODE_SM4_ECB),
+				    CRYPTO_MODE_NULL, ctx_idx, 0, NULL, NULL);
+		if (handle < 0) {
+			err = handle;
+			goto xcbc_err;
+		}
+	}
+	spacc_set_operation(spacc, handle, OP_ENCRYPT, 0, 0, 0, 0, 0);
+
+	if (usecbc) {
+		/* we can do the ECB work in CBC using three
+		 * jobs with the IVreset to zero each time
+		 */
+		for (i = 0; i < 3; i++) {
+			spacc_write_context(spacc, handle,
+					    SPACC_CRYPTO_OPERATION, key,
+					    keylen, iv, 16);
+			err = spacc_packet_enqueue_ddt(spacc, handle, &ddt,
+						&ddt, 16, (i * 16) |
+						((i * 16) << 16), 0, 0, 0, 0);
+			if (err != CRYPTO_OK)
+				goto xcbc_err;
+
+			do {
+				err = spacc_packet_dequeue(spacc, handle);
+			} while (err == -EINPROGRESS);
+			if (err != CRYPTO_OK)
+				goto xcbc_err;
+		}
+	} else {
+		/* do the 48 bytes as a single SPAcc job this is the ideal case
+		 * but only possible if ECB was enabled in the core
+		 */
+		spacc_write_context(spacc, handle, SPACC_CRYPTO_OPERATION,
+				    key, keylen, iv, 16);
+		err = spacc_packet_enqueue_ddt(spacc, handle, &ddt, &ddt, 48,
+					       0, 0, 0, 0, 0);
+		if (err != CRYPTO_OK)
+			goto xcbc_err;
+
+		do {
+			err = spacc_packet_dequeue(spacc, handle);
+		} while (err == -EINPROGRESS);
+		if (err != CRYPTO_OK)
+			goto xcbc_err;
+	}
+
+	/* now we can copy the key*/
+	memcpy(xcbc_out, buf, 48);
+	memset(buf, 0, 64);
+
+xcbc_err:
+	dma_free_coherent(get_ddt_device(), 64, buf, bufphys);
+	pdu_ddt_free(&ddt);
+	if (handle >= 0)
+		spacc_close(spacc, handle);
+
+	if (err)
+		return -EINVAL;
+
+	return 0;
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_core.h b/drivers/crypto/dwc-spacc/spacc_core.h
new file mode 100644
index 000000000000..399b7c976151
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_core.h
@@ -0,0 +1,826 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+
+#ifndef SPACC_CORE_H_
+#define SPACC_CORE_H_
+
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/of_device.h>
+#include <linux/dma-mapping.h>
+#include <crypto/skcipher.h>
+#include "spacc_hal.h"
+
+enum {
+	SPACC_DMA_UNDEF  = 0,
+	SPACC_DMA_DDT	 = 1,
+	SPACC_DMA_LINEAR = 2
+};
+
+enum {
+	SPACC_OP_MODE_IRQ = 0,
+	SPACC_OP_MODE_WD  = 1	/* watchdog */
+};
+
+#define OP_ENCRYPT		0
+#define OP_DECRYPT		1
+
+#define SPACC_CRYPTO_OPERATION	1
+#define SPACC_HASH_OPERATION	2
+
+#define SPACC_AADCOPY_FLAG	0x80000000
+
+#define SPACC_AUTO_SIZE		(-1)
+
+#define SPACC_WD_LIMIT		0x80
+#define SPACC_WD_TIMER_INIT	0x40000
+
+/********* Register Offsets **********/
+#define SPACC_REG_IRQ_EN	0x00000L
+#define SPACC_REG_IRQ_STAT	0x00004L
+#define SPACC_REG_IRQ_CTRL	0x00008L
+#define SPACC_REG_FIFO_STAT	0x0000CL
+#define SPACC_REG_SDMA_BRST_SZ	0x00010L
+
+#define SPACC_REG_SRC_PTR	0x00020L
+#define SPACC_REG_DST_PTR	0x00024L
+#define SPACC_REG_OFFSET	0x00028L
+#define SPACC_REG_PRE_AAD_LEN	0x0002CL
+#define SPACC_REG_POST_AAD_LEN	0x00030L
+
+#define SPACC_REG_PROC_LEN	0x00034L
+#define SPACC_REG_ICV_LEN	0x00038L
+#define SPACC_REG_ICV_OFFSET	0x0003CL
+#define SPACC_REG_IV_OFFSET	0x00040L
+
+#define SPACC_REG_SW_CTRL	0x00044L
+#define SPACC_REG_AUX_INFO	0x00048L
+#define SPACC_REG_CTRL		0x0004CL
+
+#define SPACC_REG_STAT_POP	0x00050L
+#define SPACC_REG_STATUS	0x00054L
+
+#define SPACC_REG_STAT_WD_CTRL	0x00080L
+
+#define SPACC_REG_KEY_SZ	0x00100L
+
+#define SPACC_REG_VIRTUAL_RQST	0x00140L
+#define SPACC_REG_VIRTUAL_ALLOC	0x00144L
+#define SPACC_REG_VIRTUAL_PRIO	0x00148L
+
+#define SPACC_REG_ID		0x00180L
+#define SPACC_REG_CONFIG	0x00184L
+#define SPACC_REG_CONFIG2	0x00190L
+
+#define SPACC_REG_SECURE_CTRL		0x001C0L
+#define SPACC_REG_SECURE_RELEASE	0x001C4
+
+#define SPACC_REG_SK_LOAD	0x00200L
+#define SPACC_REG_SK_STAT	0x00204L
+#define SPACC_REG_SK_KEY	0x00240L
+
+#define SPACC_REG_VERSION_EXT_3	0x00194L
+
+/* out 8MB from base of SPACC */
+#define SPACC_REG_SKP		0x800000UL
+
+/********** Context Offsets **********/
+#define SPACC_CTX_CIPH_KEY	0x04000L
+#define SPACC_CTX_HASH_KEY	0x08000L
+
+/******** Sub-Context Offsets ********/
+#define SPACC_CTX_AES_KEY	0x00
+#define SPACC_CTX_AES_IV	0x20
+
+#define SPACC_CTX_DES_KEY	0x08
+#define SPACC_CTX_DES_IV	0x00
+
+/* use these to loop over CMDX macros */
+#define SPACC_CMDX_MAX		1
+#define SPACC_CMDX_MAX_QOS	3
+/********** IRQ_EN Bit Masks **********/
+
+#define _SPACC_IRQ_CMD0		0
+#define _SPACC_IRQ_STAT		4
+#define _SPACC_IRQ_STAT_WD	12
+#define _SPACC_IRQ_GLBL		31
+
+#define SPACC_IRQ_EN_CMD(x)	(1UL << _SPACC_IRQ_CMD0 << (x))
+#define SPACC_IRQ_EN_STAT	BIT(_SPACC_IRQ_STAT)
+#define SPACC_IRQ_EN_STAT_WD	BIT(_SPACC_IRQ_STAT_WD)
+#define SPACC_IRQ_EN_GLBL	BIT(_SPACC_IRQ_GLBL)
+
+/********* IRQ_STAT Bitmasks *********/
+
+#define SPACC_IRQ_STAT_CMDX(x)	(1UL << _SPACC_IRQ_CMD0 << (x))
+#define SPACC_IRQ_STAT_STAT	BIT(_SPACC_IRQ_STAT)
+#define SPACC_IRQ_STAT_STAT_WD	BIT(_SPACC_IRQ_STAT_WD)
+
+#define SPACC_IRQ_STAT_CLEAR_STAT(spacc)    writel(SPACC_IRQ_STAT_STAT, \
+		(spacc)->regmap + SPACC_REG_IRQ_STAT)
+
+#define SPACC_IRQ_STAT_CLEAR_STAT_WD(spacc) writel(SPACC_IRQ_STAT_STAT_WD, \
+		(spacc)->regmap + SPACC_REG_IRQ_STAT)
+
+#define SPACC_IRQ_STAT_CLEAR_CMDX(spacc, x) writel(SPACC_IRQ_STAT_CMDX(x), \
+		(spacc)->regmap + SPACC_REG_IRQ_STAT)
+
+/********* IRQ_CTRL Bitmasks *********/
+/* CMD0 = 0; for QOS, CMD1 = 8, CMD2 = 16 */
+#define _SPACC_IRQ_CTRL_CMDX_CNT(x)       (8 * (x))
+#define SPACC_IRQ_CTRL_CMDX_CNT_SET(x, n) \
+	(((n) & 0xFF) << _SPACC_IRQ_CTRL_CMDX_CNT(x))
+#define SPACC_IRQ_CTRL_CMDX_CNT_MASK(x) \
+	(0xFF << _SPACC_IRQ_CTRL_CMDX_CNT(x))
+
+/* STAT_CNT is at 16 and for QOS at 24 */
+#define _SPACC_IRQ_CTRL_STAT_CNT          16
+#define SPACC_IRQ_CTRL_STAT_CNT_SET(n)    ((n) << _SPACC_IRQ_CTRL_STAT_CNT)
+#define SPACC_IRQ_CTRL_STAT_CNT_MASK      (0x1FF << _SPACC_IRQ_CTRL_STAT_CNT)
+
+#define _SPACC_IRQ_CTRL_STAT_CNT_QOS         24
+#define SPACC_IRQ_CTRL_STAT_CNT_SET_QOS(n) \
+	((n) << _SPACC_IRQ_CTRL_STAT_CNT_QOS)
+#define SPACC_IRQ_CTRL_STAT_CNT_MASK_QOS \
+	(0x7F << _SPACC_IRQ_CTRL_STAT_CNT_QOS)
+
+/******** FIFO_STAT Bitmasks *********/
+
+/* SPACC with QOS */
+#define SPACC_FIFO_STAT_CMDX_CNT_MASK(x) \
+	(0x7F << ((x) * 8))
+#define SPACC_FIFO_STAT_CMDX_CNT_GET(x, y) \
+	(((y) & SPACC_FIFO_STAT_CMDX_CNT_MASK(x)) >> ((x) * 8))
+#define SPACC_FIFO_STAT_CMDX_FULL(x)          (1UL << (7 + (x) * 8))
+
+#define _SPACC_FIFO_STAT_STAT_CNT_QOS         24
+#define SPACC_FIFO_STAT_STAT_CNT_MASK_QOS \
+	(0x7F << _SPACC_FIFO_STAT_STAT_CNT_QOS)
+#define SPACC_FIFO_STAT_STAT_CNT_GET_QOS(y)	\
+	(((y) &					\
+	SPACC_FIFO_STAT_STAT_CNT_MASK_QOS) >> _SPACC_FIFO_STAT_STAT_CNT_QOS)
+
+/* SPACC without QOS */
+#define SPACC_FIFO_STAT_CMD0_CNT_MASK	(0x1FF)
+#define SPACC_FIFO_STAT_CMD0_CNT_GET(y)	((y) & SPACC_FIFO_STAT_CMD0_CNT_MASK)
+#define _SPACC_FIFO_STAT_CMD0_FULL      15
+#define SPACC_FIFO_STAT_CMD0_FULL       BIT(_SPACC_FIFO_STAT_CMD0_FULL)
+
+#define _SPACC_FIFO_STAT_STAT_CNT       16
+#define SPACC_FIFO_STAT_STAT_CNT_MASK   (0x1FF << _SPACC_FIFO_STAT_STAT_CNT)
+#define SPACC_FIFO_STAT_STAT_CNT_GET(y) \
+	(((y) & SPACC_FIFO_STAT_STAT_CNT_MASK) >> _SPACC_FIFO_STAT_STAT_CNT)
+
+/* both */
+#define _SPACC_FIFO_STAT_STAT_EMPTY	31
+#define SPACC_FIFO_STAT_STAT_EMPTY	BIT(_SPACC_FIFO_STAT_STAT_EMPTY)
+
+/********* SRC/DST_PTR Bitmasks **********/
+
+#define SPACC_SRC_PTR_PTR           0xFFFFFFF8
+#define SPACC_DST_PTR_PTR           0xFFFFFFF8
+
+/********** OFFSET Bitmasks **********/
+
+#define SPACC_OFFSET_SRC_O          0
+#define SPACC_OFFSET_SRC_W          16
+#define SPACC_OFFSET_DST_O          16
+#define SPACC_OFFSET_DST_W          16
+
+#define SPACC_MIN_CHUNK_SIZE        1024
+#define SPACC_MAX_CHUNK_SIZE        16384
+
+/********* PKT_LEN Bitmasks **********/
+
+#ifndef _SPACC_PKT_LEN_PROC_LEN
+#define _SPACC_PKT_LEN_PROC_LEN     0
+#endif
+#ifndef _SPACC_PKT_LEN_AAD_LEN
+#define _SPACC_PKT_LEN_AAD_LEN      16
+#endif
+
+/********* SW_CTRL Bitmasks ***********/
+
+#define _SPACC_SW_CTRL_ID_0          0
+#define SPACC_SW_CTRL_ID_W           8
+#define SPACC_SW_CTRL_ID_MASK        (0xFF << _SPACC_SW_CTRL_ID_0)
+#define SPACC_SW_CTRL_ID_GET(y) \
+	(((y) & SPACC_SW_CTRL_ID_MASK) >> _SPACC_SW_CTRL_ID_0)
+#define SPACC_SW_CTRL_ID_SET(id) \
+	(((id) & SPACC_SW_CTRL_ID_MASK) >> _SPACC_SW_CTRL_ID_0)
+
+#define _SPACC_SW_CTRL_PRIO          30
+#define SPACC_SW_CTRL_PRIO_MASK      0x3
+#define SPACC_SW_CTRL_PRIO_SET(prio) \
+	(((prio) & SPACC_SW_CTRL_PRIO_MASK) << _SPACC_SW_CTRL_PRIO)
+
+/* Priorities */
+#define SPACC_SW_CTRL_PRIO_HI         0
+#define SPACC_SW_CTRL_PRIO_MED        1
+#define SPACC_SW_CTRL_PRIO_LOW        2
+
+/*********** SECURE_CTRL bitmasks *********/
+#define _SPACC_SECURE_CTRL_MS_SRC     0
+#define _SPACC_SECURE_CTRL_MS_DST     1
+#define _SPACC_SECURE_CTRL_MS_DDT     2
+#define _SPACC_SECURE_CTRL_LOCK       31
+
+#define SPACC_SECURE_CTRL_MS_SRC    BIT(_SPACC_SECURE_CTRL_MS_SRC)
+#define SPACC_SECURE_CTRL_MS_DST    BIT(_SPACC_SECURE_CTRL_MS_DST)
+#define SPACC_SECURE_CTRL_MS_DDT    BIT(_SPACC_SECURE_CTRL_MS_DDT)
+#define SPACC_SECURE_CTRL_LOCK      BIT(_SPACC_SECURE_CTRL_LOCK)
+
+/********* SKP bits **************/
+#define _SPACC_SK_LOAD_CTX_IDX	0
+#define _SPACC_SK_LOAD_ALG	8
+#define _SPACC_SK_LOAD_MODE	12
+#define _SPACC_SK_LOAD_SIZE	16
+#define _SPACC_SK_LOAD_ENC_EN	30
+#define _SPACC_SK_LOAD_DEC_EN	31
+#define _SPACC_SK_STAT_BUSY	0
+
+#define SPACC_SK_LOAD_ENC_EN         BIT(_SPACC_SK_LOAD_ENC_EN)
+#define SPACC_SK_LOAD_DEC_EN         BIT(_SPACC_SK_LOAD_DEC_EN)
+#define SPACC_SK_STAT_BUSY           BIT(_SPACC_SK_STAT_BUSY)
+
+/*********** CTRL Bitmasks ***********/
+/* These CTRL field locations vary with SPACC version
+ * and if they are used, they should be set accordingly
+ */
+#define _SPACC_CTRL_CIPH_ALG	0
+#define _SPACC_CTRL_HASH_ALG	4
+#define _SPACC_CTRL_CIPH_MODE	8
+#define _SPACC_CTRL_HASH_MODE	12
+#define _SPACC_CTRL_MSG_BEGIN	14
+#define _SPACC_CTRL_MSG_END	15
+#define _SPACC_CTRL_CTX_IDX	16
+#define _SPACC_CTRL_ENCRYPT	24
+#define _SPACC_CTRL_AAD_COPY	25
+#define _SPACC_CTRL_ICV_PT	26
+#define _SPACC_CTRL_ICV_ENC	27
+#define _SPACC_CTRL_ICV_APPEND	28
+#define _SPACC_CTRL_KEY_EXP	29
+#define _SPACC_CTRL_SEC_KEY	31
+
+/* CTRL bitmasks for 4.15+ cores */
+#define _SPACC_CTRL_CIPH_ALG_415	0
+#define _SPACC_CTRL_HASH_ALG_415	3
+#define _SPACC_CTRL_CIPH_MODE_415	8
+#define _SPACC_CTRL_HASH_MODE_415	12
+
+/********* Virtual Spacc Priority Bitmasks **********/
+#define _SPACC_VPRIO_MODE		0
+#define _SPACC_VPRIO_WEIGHT		8
+
+/********* AUX INFO Bitmasks *********/
+#define _SPACC_AUX_INFO_DIR		0
+#define _SPACC_AUX_INFO_BIT_ALIGN	1
+#define _SPACC_AUX_INFO_CBC_CS		16
+
+/********* STAT_POP Bitmasks *********/
+#define _SPACC_STAT_POP_POP	0
+#define SPACC_STAT_POP_POP	BIT(_SPACC_STAT_POP_POP)
+
+/********** STATUS Bitmasks **********/
+#define _SPACC_STATUS_SW_ID	0
+#define _SPACC_STATUS_RET_CODE	24
+#define _SPACC_STATUS_SEC_CMD	31
+#define SPACC_GET_STATUS_RET_CODE(s) \
+	(((s) >> _SPACC_STATUS_RET_CODE) & 0x7)
+
+#define SPACC_STATUS_SW_ID_MASK		(0xFF << _SPACC_STATUS_SW_ID)
+#define SPACC_STATUS_SW_ID_GET(y) \
+	(((y) & SPACC_STATUS_SW_ID_MASK) >> _SPACC_STATUS_SW_ID)
+
+/********** KEY_SZ Bitmasks **********/
+#define _SPACC_KEY_SZ_SIZE	0
+#define _SPACC_KEY_SZ_CTX_IDX	8
+#define _SPACC_KEY_SZ_CIPHER	31
+
+#define SPACC_KEY_SZ_CIPHER        BIT(_SPACC_KEY_SZ_CIPHER)
+
+#define SPACC_SET_CIPHER_KEY_SZ(z) \
+	(((z) << _SPACC_KEY_SZ_SIZE) | (1UL << _SPACC_KEY_SZ_CIPHER))
+#define SPACC_SET_HASH_KEY_SZ(z)   ((z) << _SPACC_KEY_SZ_SIZE)
+#define SPACC_SET_KEY_CTX(ctx)     ((ctx) << _SPACC_KEY_SZ_CTX_IDX)
+
+/*****************************************************************************/
+
+#define AUX_DIR(a)       ((a) << _SPACC_AUX_INFO_DIR)
+#define AUX_BIT_ALIGN(a) ((a) << _SPACC_AUX_INFO_BIT_ALIGN)
+#define AUX_CBC_CS(a)    ((a) << _SPACC_AUX_INFO_CBC_CS)
+
+#define VPRIO_SET(mode, weight) \
+	(((mode) << _SPACC_VPRIO_MODE) | ((weight) << _SPACC_VPRIO_WEIGHT))
+
+#ifndef MAX_DDT_ENTRIES
+/* add one for null at end of list */
+#define MAX_DDT_ENTRIES \
+	((SPACC_MAX_MSG_MALLOC_SIZE / SPACC_MAX_PARTICLE_SIZE) + 1)
+#endif
+
+#define DDT_ENTRY_SIZE (sizeof(ddt_entry) * MAX_DDT_ENTRIES)
+
+#ifndef SPACC_MAX_JOBS
+#define SPACC_MAX_JOBS  BIT(SPACC_SW_CTRL_ID_W)
+#endif
+
+#if SPACC_MAX_JOBS > 256
+#  error SPACC_MAX_JOBS cannot exceed 256.
+#endif
+
+#ifndef SPACC_MAX_JOB_BUFFERS
+#define SPACC_MAX_JOB_BUFFERS	192
+#endif
+
+#define CRYPTO_USED_JB	256
+
+/* max DDT particle size */
+#ifndef SPACC_MAX_PARTICLE_SIZE
+#define SPACC_MAX_PARTICLE_SIZE	4096
+#endif
+
+/* max message size from HW configuration */
+/* usually defined in ICD as (2 exponent 16) -1 */
+#ifndef _SPACC_MAX_MSG_MALLOC_SIZE
+#define _SPACC_MAX_MSG_MALLOC_SIZE	16
+#endif
+#define SPACC_MAX_MSG_MALLOC_SIZE	BIT(_SPACC_MAX_MSG_MALLOC_SIZE)
+
+#ifndef SPACC_MAX_MSG_SIZE
+#define SPACC_MAX_MSG_SIZE	(SPACC_MAX_MSG_MALLOC_SIZE - 1)
+#endif
+
+#define SPACC_LOOP_WAIT		1000000
+#define SPACC_CTR_IV_MAX8	((u32)0xFF)
+#define SPACC_CTR_IV_MAX16	((u32)0xFFFF)
+#define SPACC_CTR_IV_MAX32	((u32)0xFFFFFFFF)
+#define SPACC_CTR_IV_MAX64	((u64)0xFFFFFFFFFFFFFFFF)
+
+/* cipher algos */
+enum ecipher {
+	C_NULL		= 0,
+	C_DES		= 1,
+	C_AES		= 2,
+	C_RC4		= 3,
+	C_MULTI2	= 4,
+	C_KASUMI	= 5,
+	C_SNOW3G_UEA2	= 6,
+	C_ZUC_UEA3	= 7,
+	C_CHACHA20	= 8,
+	C_SM4		= 9,
+	C_MAX		= 10
+};
+
+/* ctrl reg cipher modes */
+enum eciphermode {
+	CM_ECB = 0,
+	CM_CBC = 1,
+	CM_CTR = 2,
+	CM_CCM = 3,
+	CM_GCM = 5,
+	CM_OFB = 7,
+	CM_CFB = 8,
+	CM_F8  = 9,
+	CM_XTS = 10,
+	CM_MAX = 11
+};
+
+enum echachaciphermode {
+	CM_CHACHA_STREAM = 2,
+	CM_CHACHA_AEAD	 = 5
+};
+
+enum ehash {
+	H_NULL		 = 0,
+	H_MD5		 = 1,
+	H_SHA1		 = 2,
+	H_SHA224	 = 3,
+	H_SHA256	 = 4,
+	H_SHA384	 = 5,
+	H_SHA512	 = 6,
+	H_XCBC		 = 7,
+	H_CMAC		 = 8,
+	H_KF9		 = 9,
+	H_SNOW3G_UIA2	 = 10,
+	H_CRC32_I3E802_3 = 11,
+	H_ZUC_UIA3	 = 12,
+	H_SHA512_224	 = 13,
+	H_SHA512_256	 = 14,
+	H_MICHAEL	 = 15,
+	H_SHA3_224	 = 16,
+	H_SHA3_256	 = 17,
+	H_SHA3_384	 = 18,
+	H_SHA3_512	 = 19,
+	H_SHAKE128	 = 20,
+	H_SHAKE256	 = 21,
+	H_POLY1305	 = 22,
+	H_SM3		 = 23,
+	H_SM4_XCBC_MAC	 = 24,
+	H_SM4_CMAC	 = 25,
+	H_MAX		 = 26
+};
+
+enum ehashmode {
+	HM_RAW    = 0,
+	HM_SSLMAC = 1,
+	HM_HMAC   = 2,
+	HM_MAX	  = 3
+};
+
+enum eshakehashmode {
+	HM_SHAKE_SHAKE  = 0,
+	HM_SHAKE_CSHAKE = 1,
+	HM_SHAKE_KMAC   = 2
+};
+
+enum spacc_ret_code {
+	SPACC_OK	= 0,
+	SPACC_ICVFAIL	= 1,
+	SPACC_MEMERR	= 2,
+	SPACC_BLOCKERR	= 3,
+	SPACC_SECERR	= 4
+};
+
+enum eicvpos {
+	IP_ICV_OFFSET = 0,
+	IP_ICV_APPEND = 1,
+	IP_ICV_IGNORE = 2,
+	IP_MAX	      = 3
+};
+
+enum {
+	/* HASH of plaintext */
+	ICV_HASH	 = 0,
+	/* HASH the plaintext and encrypt the plaintext and ICV */
+	ICV_HASH_ENCRYPT = 1,
+	/* HASH the ciphertext */
+	ICV_ENCRYPT_HASH = 2,
+	ICV_IGNORE	 = 3,
+	IM_MAX		 = 4
+};
+
+enum {
+	NO_PARTIAL_PCK	   = 0,
+	FIRST_PARTIAL_PCK  = 1,
+	MIDDLE_PARTIAL_PCK = 2,
+	LAST_PARTIAL_PCK   = 3
+};
+
+enum crypto_modes {
+	CRYPTO_MODE_NULL,
+	CRYPTO_MODE_AES_ECB,
+	CRYPTO_MODE_AES_CBC,
+	CRYPTO_MODE_AES_CTR,
+	CRYPTO_MODE_AES_CCM,
+	CRYPTO_MODE_AES_GCM,
+	CRYPTO_MODE_AES_F8,
+	CRYPTO_MODE_AES_XTS,
+	CRYPTO_MODE_AES_CFB,
+	CRYPTO_MODE_AES_OFB,
+	CRYPTO_MODE_AES_CS1,
+	CRYPTO_MODE_AES_CS2,
+	CRYPTO_MODE_AES_CS3,
+	CRYPTO_MODE_MULTI2_ECB,
+	CRYPTO_MODE_MULTI2_CBC,
+	CRYPTO_MODE_MULTI2_OFB,
+	CRYPTO_MODE_MULTI2_CFB,
+	CRYPTO_MODE_3DES_CBC,
+	CRYPTO_MODE_3DES_ECB,
+	CRYPTO_MODE_DES_CBC,
+	CRYPTO_MODE_DES_ECB,
+	CRYPTO_MODE_KASUMI_ECB,
+	CRYPTO_MODE_KASUMI_F8,
+	CRYPTO_MODE_SNOW3G_UEA2,
+	CRYPTO_MODE_ZUC_UEA3,
+	CRYPTO_MODE_CHACHA20_STREAM,
+	CRYPTO_MODE_CHACHA20_POLY1305,
+	CRYPTO_MODE_SM4_ECB,
+	CRYPTO_MODE_SM4_CBC,
+	CRYPTO_MODE_SM4_CFB,
+	CRYPTO_MODE_SM4_OFB,
+	CRYPTO_MODE_SM4_CTR,
+	CRYPTO_MODE_SM4_CCM,
+	CRYPTO_MODE_SM4_GCM,
+	CRYPTO_MODE_SM4_F8,
+	CRYPTO_MODE_SM4_XTS,
+	CRYPTO_MODE_SM4_CS1,
+	CRYPTO_MODE_SM4_CS2,
+	CRYPTO_MODE_SM4_CS3,
+
+	CRYPTO_MODE_HASH_MD5,
+	CRYPTO_MODE_HMAC_MD5,
+	CRYPTO_MODE_HASH_SHA1,
+	CRYPTO_MODE_HMAC_SHA1,
+	CRYPTO_MODE_HASH_SHA224,
+	CRYPTO_MODE_HMAC_SHA224,
+	CRYPTO_MODE_HASH_SHA256,
+	CRYPTO_MODE_HMAC_SHA256,
+	CRYPTO_MODE_HASH_SHA384,
+	CRYPTO_MODE_HMAC_SHA384,
+	CRYPTO_MODE_HASH_SHA512,
+	CRYPTO_MODE_HMAC_SHA512,
+	CRYPTO_MODE_HASH_SHA512_224,
+	CRYPTO_MODE_HMAC_SHA512_224,
+	CRYPTO_MODE_HASH_SHA512_256,
+	CRYPTO_MODE_HMAC_SHA512_256,
+
+	CRYPTO_MODE_MAC_XCBC,
+	CRYPTO_MODE_MAC_CMAC,
+	CRYPTO_MODE_MAC_KASUMI_F9,
+	CRYPTO_MODE_MAC_SNOW3G_UIA2,
+	CRYPTO_MODE_MAC_ZUC_UIA3,
+	CRYPTO_MODE_MAC_POLY1305,
+
+	CRYPTO_MODE_SSLMAC_MD5,
+	CRYPTO_MODE_SSLMAC_SHA1,
+	CRYPTO_MODE_HASH_CRC32,
+	CRYPTO_MODE_MAC_MICHAEL,
+
+	CRYPTO_MODE_HASH_SHA3_224,
+	CRYPTO_MODE_HASH_SHA3_256,
+	CRYPTO_MODE_HASH_SHA3_384,
+	CRYPTO_MODE_HASH_SHA3_512,
+
+	CRYPTO_MODE_HASH_SHAKE128,
+	CRYPTO_MODE_HASH_SHAKE256,
+	CRYPTO_MODE_HASH_CSHAKE128,
+	CRYPTO_MODE_HASH_CSHAKE256,
+	CRYPTO_MODE_MAC_KMAC128,
+	CRYPTO_MODE_MAC_KMAC256,
+	CRYPTO_MODE_MAC_KMACXOF128,
+	CRYPTO_MODE_MAC_KMACXOF256,
+
+	CRYPTO_MODE_HASH_SM3,
+	CRYPTO_MODE_HMAC_SM3,
+	CRYPTO_MODE_MAC_SM4_XCBC,
+	CRYPTO_MODE_MAC_SM4_CMAC,
+
+	CRYPTO_MODE_LAST
+};
+
+/* job descriptor */
+typedef void (*spacc_callback)(void *spacc_dev, void *data);
+
+struct spacc_job {
+	unsigned long
+		enc_mode,	/* Encryption Algorithm mode */
+		hash_mode,	/* HASH Algorithm mode */
+		icv_len,
+		icv_offset,
+		op,		/* Operation */
+		ctrl,		/* CTRL shadow register */
+
+		/* context just initialized or taken,
+		 * and this is the first use.
+		 */
+		first_use,
+		pre_aad_sz, post_aad_sz,  /* size of AAD for the latest packet*/
+		hkey_sz,
+		ckey_sz;
+
+	/* Direction and bit alignment parameters for the AUX_INFO reg */
+	unsigned int auxinfo_dir, auxinfo_bit_align;
+	unsigned int auxinfo_cs_mode; /* AUX info setting for CBC-CS */
+
+	u32	ctx_idx;
+	unsigned int job_used, job_swid, job_done, job_err, job_secure;
+	spacc_callback cb;
+	void	*cbdata;
+
+};
+
+#define SPACC_CTX_IDX_UNUSED	0xFFFFFFFF
+#define SPACC_JOB_IDX_UNUSED	0xFFFFFFFF
+
+struct spacc_ctx {
+	/* Memory context to store cipher keys*/
+	void __iomem *ciph_key;
+	/* Memory context to store hash keys*/
+	void __iomem *hash_key;
+	/* reference count of jobs using this context */
+	int ref_cnt;
+	/* number of contexts following related to this one */
+	int ncontig;
+};
+
+#define SPACC_CTRL_MASK(field) \
+	(1UL << spacc->config.ctrl_map[(field)])
+#define SPACC_CTRL_SET(field, value) \
+	((value) << spacc->config.ctrl_map[(field)])
+
+enum {
+	SPACC_CTRL_VER_0,
+	SPACC_CTRL_VER_1,
+	SPACC_CTRL_VER_2,
+	SPACC_CTRL_VER_SIZE
+};
+
+enum {
+	SPACC_CTRL_CIPH_ALG,
+	SPACC_CTRL_CIPH_MODE,
+	SPACC_CTRL_HASH_ALG,
+	SPACC_CTRL_HASH_MODE,
+	SPACC_CTRL_ENCRYPT,
+	SPACC_CTRL_CTX_IDX,
+	SPACC_CTRL_SEC_KEY,
+	SPACC_CTRL_AAD_COPY,
+	SPACC_CTRL_ICV_PT,
+	SPACC_CTRL_ICV_ENC,
+	SPACC_CTRL_ICV_APPEND,
+	SPACC_CTRL_KEY_EXP,
+	SPACC_CTRL_MSG_BEGIN,
+	SPACC_CTRL_MSG_END,
+	SPACC_CTRL_MAPSIZE
+};
+
+struct spacc_device {
+	void __iomem *regmap;
+	int	zero_key;
+
+	/* hardware configuration */
+	struct {
+		unsigned int version,
+			     pdu_version,
+			     project;
+		uint32_t max_msg_size; /* max PROCLEN value */
+
+		unsigned char modes[CRYPTO_MODE_LAST];
+
+		int num_ctx,           /* no. of contexts */
+		    num_sec_ctx,       /* no. of SKP contexts*/
+		    sec_ctx_page_size, /* page size of SKP context in bytes*/
+		    ciph_page_size,    /* cipher context page size in bytes*/
+		    hash_page_size,    /* hash context page size in bytes*/
+		    string_size,
+		    is_qos,            /* QOS spacc? */
+		    is_pdu,            /* PDU spacc? */
+		    is_secure,
+		    is_secure_port,    /* Are we on the secure port? */
+		    is_partial,        /* Is partial processing enabled? */
+		    is_ivimport,       /* is ivimport enabled? */
+		    dma_type,          /* DMA type: linear or scattergather */
+		    idx,               /* Which virtual spacc IDX is this? */
+		    priority,          /* Weighted priority of virtual spacc */
+		    cmd0_fifo_depth,   /* CMD FIFO depths */
+		    cmd1_fifo_depth,
+		    cmd2_fifo_depth,
+		    stat_fifo_depth,   /* depth of STATUS FIFO */
+		    fifo_cnt,
+		    ideal_stat_level,
+		    spacc_endian;
+
+		uint32_t wd_timer;
+		u64 oldtimer, timer;
+
+		const u8 *ctrl_map;    /* map of ctrl register field offsets */
+	} config;
+
+	struct spacc_job_buffer {
+		int active;
+		int job_idx;
+		struct pdu_ddt *src, *dst;
+		u32 proc_sz, aad_offset, pre_aad_sz,
+		post_aad_sz, iv_offset, prio;
+	} job_buffer[SPACC_MAX_JOB_BUFFERS];
+
+	int jb_head, jb_tail;
+
+	int op_mode,	/* operating mode and watchdog functionality */
+	    wdcnt;	/* number of pending WD IRQs*/
+
+	/* SW_ID value which will be used for next job. */
+	unsigned int job_next_swid;
+
+	struct spacc_ctx *ctx;	/* This size changes per configured device */
+	struct spacc_job *job;	/* allocate memory for [SPACC_MAX_JOBS]; */
+	int job_lookup[SPACC_MAX_JOBS];	/* correlate SW_ID back to job index */
+
+	spinlock_t lock;	/* lock for register access */
+	spinlock_t ctx_lock;	/* lock for context manager */
+
+	/* callback functions for IRQ processing */
+	void (*irq_cb_cmdx)(struct spacc_device *spacc, int x);
+	void (*irq_cb_stat)(struct spacc_device *spacc);
+	void (*irq_cb_stat_wd)(struct spacc_device *spacc);
+
+	/* this is called after jobs have been popped off the STATUS FIFO
+	 * useful so you can be told when there might be space available
+	 * in the CMD FIFO
+	 */
+	void (*spacc_notify_jobs)(struct spacc_device *spacc);
+
+	/* cache*/
+	struct {
+		u32 src_ptr,
+		    dst_ptr,
+		    proc_len,
+		    icv_len,
+		    icv_offset,
+		    pre_aad,
+		    post_aad,
+		    iv_offset,
+		    offset,
+		    aux;
+	} cache;
+
+	struct device *dptr;
+};
+
+enum {
+	SPACC_IRQ_MODE_WD   = 1,  /* use WD*/
+	SPACC_IRQ_MODE_STEP = 2	  /* older use CMD/STAT stepping */
+};
+
+enum {
+	SPACC_IRQ_CMD_GET = 0,
+	SPACC_IRQ_CMD_SET = 1
+};
+
+struct spacc_priv {
+	struct spacc_device spacc;
+	struct semaphore core_running;
+	struct tasklet_struct pop_jobs;
+	spinlock_t hw_lock;
+	unsigned long max_msg_len;
+};
+
+
+int spacc_open(struct spacc_device *spacc, int enc, int hash, int ctx,
+	       int secure_mode, spacc_callback cb, void *cbdata);
+int spacc_clone_handle(struct spacc_device *spacc, int old_handle,
+		       void *cbdata);
+int spacc_close(struct spacc_device *spacc, int job_idx);
+int spacc_set_operation(struct spacc_device *spacc, int job_idx, int op,
+			u32 prot, uint32_t icvcmd, uint32_t icvoff,
+			uint32_t icvsz, uint32_t sec_key);
+int spacc_set_key_exp(struct spacc_device *spacc, int job_idx);
+
+int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
+		int job_idx, struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
+		u32 proc_sz, uint32_t aad_offset, uint32_t pre_aad_sz,
+		u32 post_aad_sz, uint32_t iv_offset, uint32_t prio);
+int spacc_packet_enqueue_ddt(struct spacc_device *spacc, int job_idx,
+		struct pdu_ddt *src_ddt, struct pdu_ddt *dst_ddt,
+		uint32_t proc_sz, u32 aad_offset, uint32_t pre_aad_sz,
+		uint32_t post_aad_sz, u32 iv_offset, uint32_t prio);
+
+/* IRQ handling functions */
+void spacc_irq_cmdx_enable(struct spacc_device *spacc, int cmdx, int cmdx_cnt);
+void spacc_irq_cmdx_disable(struct spacc_device *spacc, int cmdx);
+void spacc_irq_stat_enable(struct spacc_device *spacc, int stat_cnt);
+void spacc_irq_stat_disable(struct spacc_device *spacc);
+void spacc_irq_stat_wd_enable(struct spacc_device *spacc);
+void spacc_irq_stat_wd_disable(struct spacc_device *spacc);
+void spacc_irq_glbl_enable(struct spacc_device *spacc);
+void spacc_irq_glbl_disable(struct spacc_device *spacc);
+uint32_t spacc_process_irq(struct spacc_device *spacc);
+void spacc_set_wd_count(struct spacc_device *spacc, uint32_t val);
+irqreturn_t spacc_irq_handler(int irq, void *dev);
+int spacc_sgs_to_ddt(struct device *dev,
+		     struct scatterlist *sg1, int len1, int *ents1,
+		     struct scatterlist *sg2, int len2, int *ents2,
+		     struct scatterlist *sg3, int len3, int *ents3,
+		     struct pdu_ddt *ddt, int dma_direction);
+int spacc_sg_to_ddt(struct device *dev, struct scatterlist *sg,
+		    int nbytes, struct pdu_ddt *ddt, int dma_direction);
+
+/* Context Manager */
+void spacc_ctx_init_all(struct spacc_device *spacc);
+
+/* SPAcc specific manipulation of context memory */
+int spacc_write_context(struct spacc_device *spacc, int job_idx, int op,
+			const unsigned char *key, int ksz,
+			const unsigned char *iv, int ivsz);
+
+int spacc_read_context(struct spacc_device *spacc, int job_idx, int op,
+		       unsigned char *key, int ksz, unsigned char *iv,
+		       int ivsz);
+
+/* Job Manager */
+void spacc_job_init_all(struct spacc_device *spacc);
+int  spacc_job_request(struct spacc_device *dev, int job_idx);
+int  spacc_job_release(struct spacc_device *dev, int job_idx);
+int  spacc_handle_release(struct spacc_device *spacc, int job_idx);
+
+/* Helper functions */
+struct spacc_ctx *context_lookup_by_job(struct spacc_device *spacc,
+					int job_idx);
+int spacc_isenabled(struct spacc_device *spacc, int mode, int keysize);
+int spacc_compute_xcbc_key(struct spacc_device *spacc, int mode_id,
+			   int job_idx, const unsigned char *key,
+			   int keylen, unsigned char *xcbc_out);
+
+int  spacc_process_jb(struct spacc_device *spacc);
+int  spacc_remove(struct platform_device *pdev);
+int  spacc_static_config(struct spacc_device *spacc);
+int  spacc_autodetect(struct spacc_device *spacc);
+void spacc_pop_jobs(unsigned long data);
+void spacc_fini(struct spacc_device *spacc);
+int  spacc_init(void __iomem *baseaddr, struct spacc_device *spacc,
+		struct pdu_info *info);
+int  spacc_pop_packets(struct spacc_device *spacc, int *num_popped);
+void spacc_stat_process(struct spacc_device *spacc);
+void spacc_cmd_process(struct spacc_device *spacc, int x);
+
+#endif
diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/dwc-spacc/spacc_device.c
new file mode 100644
index 000000000000..a723aaf8784a
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_device.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/of_device.h>
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include "spacc_device.h"
+
+static struct platform_device *spacc_pdev[MAX_DEVICES];
+
+#define VSPACC_PRIORITY_MAX 15
+
+void spacc_cmd_process(struct spacc_device *spacc, int x)
+{
+	struct spacc_priv *priv = container_of(spacc, struct spacc_priv, spacc);
+
+	/* run tasklet to pop jobs off fifo */
+	tasklet_schedule(&priv->pop_jobs);
+}
+void spacc_stat_process(struct spacc_device *spacc)
+{
+	struct spacc_priv *priv = container_of(spacc, struct spacc_priv, spacc);
+
+	/* run tasklet to pop jobs off fifo */
+	tasklet_schedule(&priv->pop_jobs);
+}
+
+
+int spacc_probe(struct platform_device *pdev,
+		const struct of_device_id snps_spacc_id[])
+{
+	int spacc_idx = -1;
+	struct resource *mem;
+	int spacc_endian = 0;
+	void __iomem *baseaddr;
+	struct pdu_info   info;
+	int spacc_priority = -1;
+	struct spacc_priv *priv;
+	int x = 0, err, oldmode, irq_num;
+	const struct of_device_id *match, *id;
+	u64 oldtimer = 100000, timer = 100000;
+
+	if (pdev->dev.of_node) {
+		id = of_match_node(snps_spacc_id, pdev->dev.of_node);
+		if (!id) {
+			dev_err(&pdev->dev, "DT node did not match\n");
+			return -EINVAL;
+		}
+	}
+
+	/* Initialize DDT DMA pools based on this device's resources */
+	if (pdu_mem_init(&pdev->dev)) {
+		dev_err(&pdev->dev, "Could not initialize DMA pools\n");
+		return -ENOMEM;
+	}
+
+	match = of_match_device(of_match_ptr(snps_spacc_id), &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "SPAcc dtb missing");
+		return -ENODEV;
+	}
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "no memory resource for spacc\n");
+		err = -ENXIO;
+		goto free_ddt_mem_pool;
+	}
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		err = -ENOMEM;
+		goto free_ddt_mem_pool;
+	}
+
+	/* Read spacc priority and index and save inside priv.spacc.config */
+	if (of_property_read_u32(pdev->dev.of_node, "spacc_priority",
+				 &spacc_priority)) {
+		dev_err(&pdev->dev, "No vspacc priority specified\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+
+	if (spacc_priority < 0 && spacc_priority > VSPACC_PRIORITY_MAX) {
+		dev_err(&pdev->dev, "Invalid vspacc priority\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+	priv->spacc.config.priority = spacc_priority;
+
+	if (of_property_read_u32(pdev->dev.of_node, "spacc_index",
+				 &spacc_idx)) {
+		dev_err(&pdev->dev, "No vspacc index specified\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+	priv->spacc.config.idx = spacc_idx;
+
+	if (of_property_read_u32(pdev->dev.of_node, "spacc_endian",
+				 &spacc_endian)) {
+		dev_dbg(&pdev->dev, "No spacc_endian specified\n");
+		dev_dbg(&pdev->dev, "Default spacc Endianness (0==little)\n");
+		spacc_endian = 0;
+	}
+	priv->spacc.config.spacc_endian = spacc_endian;
+
+	if (of_property_read_u64(pdev->dev.of_node, "oldtimer",
+				 &oldtimer)) {
+		dev_dbg(&pdev->dev, "No oldtimer specified\n");
+		dev_dbg(&pdev->dev, "Default oldtimer (100000)\n");
+		oldtimer = 100000;
+	}
+	priv->spacc.config.oldtimer = oldtimer;
+
+	if (of_property_read_u64(pdev->dev.of_node, "timer", &timer)) {
+		dev_dbg(&pdev->dev, "No timer specified\n");
+		dev_dbg(&pdev->dev, "Default timer (100000)\n");
+		timer = 100000;
+	}
+	priv->spacc.config.timer = timer;
+
+	baseaddr = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(baseaddr)) {
+		dev_err(&pdev->dev, "unable to map iomem\n");
+		err = PTR_ERR(baseaddr);
+		goto free_ddt_mem_pool;
+	}
+
+	pdu_get_version(baseaddr, &info);
+	if (pdev->dev.platform_data) {
+		struct pdu_info *parent_info = pdev->dev.platform_data;
+
+		memcpy(&info.pdu_config, &parent_info->pdu_config,
+		       sizeof(info.pdu_config));
+	}
+
+	dev_dbg(&pdev->dev, "EPN %04X : virt [%d]\n",
+				info.spacc_version.project,
+				info.spacc_version.vspacc_idx);
+
+	/* Validate virtual spacc index with vspacc count read from
+	 * VERSION_EXT.VSPACC_CNT. Thus vspacc count=3, gives valid index 0,1,2
+	 */
+	if (spacc_idx != info.spacc_version.vspacc_idx) {
+		dev_err(&pdev->dev, "DTS vspacc_idx mismatch read value\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+
+	if (spacc_idx < 0 || spacc_idx > (info.spacc_config.num_vspacc - 1)) {
+		dev_err(&pdev->dev, "Invalid vspacc index specified\n");
+		err = -EINVAL;
+		goto free_ddt_mem_pool;
+	}
+
+	err = spacc_init(baseaddr, &priv->spacc, &info);
+	if (err != CRYPTO_OK) {
+		dev_err(&pdev->dev, "Failed to initialize device %d\n", x);
+		err = -ENXIO;
+		goto free_ddt_mem_pool;
+	}
+
+	spin_lock_init(&priv->hw_lock);
+	spacc_irq_glbl_disable(&priv->spacc);
+	tasklet_init(&priv->pop_jobs, spacc_pop_jobs, (unsigned long)priv);
+
+	priv->spacc.dptr = &pdev->dev;
+	platform_set_drvdata(pdev, priv);
+
+	irq_num = platform_get_irq(pdev, 0);
+	if (irq_num < 0) {
+		dev_err(&pdev->dev, "no irq resource for spacc\n");
+		err = -ENXIO;
+		goto free_ddt_mem_pool;
+	}
+
+	/* Determine configured maximum message length. */
+	priv->max_msg_len = priv->spacc.config.max_msg_size;
+
+	if (devm_request_irq(&pdev->dev, irq_num, spacc_irq_handler,
+			     IRQF_SHARED, dev_name(&pdev->dev),
+			     &pdev->dev)) {
+		dev_err(&pdev->dev, "failed to request IRQ\n");
+		err = -EBUSY;
+		goto err_tasklet_kill;
+	}
+
+	priv->spacc.irq_cb_stat = spacc_stat_process;
+	priv->spacc.irq_cb_cmdx = spacc_cmd_process;
+	oldmode			= priv->spacc.op_mode;
+	priv->spacc.op_mode     = SPACC_OP_MODE_IRQ;
+
+	spacc_irq_stat_enable(&priv->spacc, 1);
+	spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
+	spacc_irq_stat_wd_disable(&priv->spacc);
+	spacc_irq_glbl_enable(&priv->spacc);
+
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)
+	err = spacc_autodetect(&priv->spacc);
+	if (err < 0) {
+		spacc_irq_glbl_disable(&priv->spacc);
+		goto err_tasklet_kill;
+	}
+#else
+	err = spacc_static_config(&priv->spacc);
+	if (err < 0) {
+		spacc_irq_glbl_disable(&priv->spacc);
+		goto err_tasklet_kill;
+	}
+#endif
+
+	priv->spacc.op_mode = oldmode;
+
+	if (priv->spacc.op_mode == SPACC_OP_MODE_IRQ) {
+		priv->spacc.irq_cb_stat = spacc_stat_process;
+		priv->spacc.irq_cb_cmdx = spacc_cmd_process;
+
+		spacc_irq_stat_enable(&priv->spacc, 1);
+		spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
+		spacc_irq_glbl_enable(&priv->spacc);
+	} else {
+		priv->spacc.irq_cb_stat = spacc_stat_process;
+		priv->spacc.irq_cb_stat_wd = spacc_stat_process;
+
+		spacc_irq_stat_enable(&priv->spacc,
+				      priv->spacc.config.ideal_stat_level);
+
+		spacc_irq_cmdx_disable(&priv->spacc, 0);
+		spacc_irq_stat_wd_enable(&priv->spacc);
+		spacc_irq_glbl_enable(&priv->spacc);
+
+		/* enable the wd by setting the wd_timer = 100000 */
+		spacc_set_wd_count(&priv->spacc,
+				   priv->spacc.config.wd_timer =
+						priv->spacc.config.timer);
+	}
+
+	/* unlock normal*/
+	if (priv->spacc.config.is_secure_port) {
+		u32 t;
+
+		t = readl(baseaddr + SPACC_REG_SECURE_CTRL);
+		t &= ~(1UL << 31);
+		writel(t, baseaddr + SPACC_REG_SECURE_CTRL);
+	}
+
+	/* unlock device by default */
+	writel(0, baseaddr + SPACC_REG_SECURE_CTRL);
+
+	return err;
+
+err_tasklet_kill:
+	tasklet_kill(&priv->pop_jobs);
+	spacc_fini(&priv->spacc);
+
+free_ddt_mem_pool:
+	pdu_mem_deinit(&pdev->dev);
+
+	return err;
+}
+
+static void spacc_unregister_algs(void)
+{
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
+	spacc_unregister_hash_algs();
+#endif
+#if  IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AEAD)
+	spacc_unregister_aead_algs();
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_CIPHER)
+	spacc_unregister_cipher_algs();
+#endif
+}
+
+static const struct of_device_id snps_spacc_id[] = {
+	{.compatible = "snps-dwc-spacc" },
+	{ /*sentinel */        }
+};
+
+MODULE_DEVICE_TABLE(of, snps_spacc_id);
+
+static int spacc_crypto_probe(struct platform_device *pdev)
+{
+	int rc;
+
+	rc = spacc_probe(pdev, snps_spacc_id);
+	if (rc < 0)
+		goto err;
+
+	spacc_pdev[0] = pdev;
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
+	rc = probe_hashes(pdev);
+	if (rc < 0)
+		goto err;
+#endif
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_CIPHER)
+	rc = probe_ciphers(pdev);
+	if (rc < 0)
+		goto err;
+#endif
+
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AEAD)
+	rc = probe_aeads(pdev);
+	if (rc < 0)
+		goto err;
+#endif
+
+	return 0;
+err:
+	spacc_unregister_algs();
+
+	return rc;
+}
+
+static int spacc_crypto_remove(struct platform_device *pdev)
+{
+	spacc_unregister_algs();
+	spacc_remove(pdev);
+
+	return 0;
+}
+
+static struct platform_driver spacc_driver = {
+	.probe  = spacc_crypto_probe,
+	.remove = spacc_crypto_remove,
+	.driver = {
+		.name  = "spacc",
+		.of_match_table = of_match_ptr(snps_spacc_id),
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(spacc_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Synopsys, Inc.");
+MODULE_DESCRIPTION("SPAcc Crypto Accelerator Driver");
diff --git a/drivers/crypto/dwc-spacc/spacc_device.h b/drivers/crypto/dwc-spacc/spacc_device.h
new file mode 100644
index 000000000000..be7fde25046b
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_device.h
@@ -0,0 +1,231 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SPACC_DEVICE_H_
+#define SPACC_DEVICE_H_
+
+#include <crypto/hash.h>
+#include <crypto/ctr.h>
+#include <crypto/internal/aead.h>
+#include <linux/of.h>
+#include "spacc_core.h"
+
+#define MODE_TAB_AEAD(_name, _ciph, _hash, _hashlen, _ivlen, _blocklen) \
+	.name = _name, .aead = { .ciph = _ciph, .hash = _hash }, \
+	.hashlen = _hashlen, .ivlen = _ivlen, .blocklen = _blocklen
+
+/* Helper macros for initializing the hash/cipher tables. */
+#define MODE_TAB_COMMON(_name, _id_name, _blocklen) \
+	.name = _name, .id = CRYPTO_MODE_##_id_name, .blocklen = _blocklen
+
+#define MODE_TAB_HASH(_name, _id_name, _hashlen, _blocklen) \
+	MODE_TAB_COMMON(_name, _id_name, _blocklen), \
+	.hashlen = _hashlen, .testlen = _hashlen
+
+#define MODE_TAB_CIPH(_name, _id_name, _ivlen, _blocklen) \
+	MODE_TAB_COMMON(_name, _id_name, _blocklen), \
+	.ivlen = _ivlen
+
+#define MODE_TAB_HASH_XCBC	0x8000
+
+#define SPACC_MAX_DIGEST_SIZE	64
+#define SPACC_MAX_KEY_SIZE	32
+#define SPACC_MAX_IV_SIZE	16
+
+#define SPACC_DMA_ALIGN		4
+#define SPACC_DMA_BOUNDARY	0x10000
+
+#define MAX_DEVICES		2
+/* flag means the IV is computed from setkey and crypt*/
+#define SPACC_MANGLE_IV_FLAG	0x8000
+
+/* we're doing a CTR mangle (for RFC3686/IPsec)*/
+#define SPACC_MANGLE_IV_RFC3686	0x0100
+
+/* we're doing GCM */
+#define SPACC_MANGLE_IV_RFC4106	0x0200
+
+/* we're doing GMAC */
+#define SPACC_MANGLE_IV_RFC4543	0x0300
+
+/* we're doing CCM */
+#define SPACC_MANGLE_IV_RFC4309	0x0400
+
+/* we're doing SM4 GCM/CCM */
+#define SPACC_MANGLE_IV_RFC8998	0x0500
+
+#define CRYPTO_MODE_AES_CTR_RFC3686 (CRYPTO_MODE_AES_CTR \
+		| SPACC_MANGLE_IV_FLAG \
+		| SPACC_MANGLE_IV_RFC3686)
+#define CRYPTO_MODE_AES_GCM_RFC4106 (CRYPTO_MODE_AES_GCM \
+		| SPACC_MANGLE_IV_FLAG \
+		| SPACC_MANGLE_IV_RFC4106)
+#define CRYPTO_MODE_AES_GCM_RFC4543 (CRYPTO_MODE_AES_GCM \
+		| SPACC_MANGLE_IV_FLAG \
+		| SPACC_MANGLE_IV_RFC4543)
+#define CRYPTO_MODE_AES_CCM_RFC4309 (CRYPTO_MODE_AES_CCM \
+		| SPACC_MANGLE_IV_FLAG \
+		| SPACC_MANGLE_IV_RFC4309)
+#define CRYPTO_MODE_SM4_GCM_RFC8998 (CRYPTO_MODE_SM4_GCM)
+#define CRYPTO_MODE_SM4_CCM_RFC8998 (CRYPTO_MODE_SM4_CCM)
+
+struct spacc_crypto_ctx {
+	struct device *dev;
+
+	spinlock_t lock;
+	struct list_head jobs;
+	int handle, mode, auth_size, key_len;
+	unsigned char *cipher_key;
+
+	/*
+	 * Indicates that the H/W context has been setup and can be used for
+	 * crypto; otherwise, the software fallback will be used.
+	 */
+	bool ctx_valid;
+	unsigned int flag_ppp;
+
+	/* salt used for rfc3686/givencrypt mode */
+	unsigned char csalt[16];
+	u8 ipad[128] __aligned(sizeof(u32));
+	u8 digest_ctx_buf[128] __aligned(sizeof(u32));
+	u8 tmp_buffer[128] __aligned(sizeof(u32));
+
+	/* Save keylen from setkey */
+	int keylen;
+	u8  key[256];
+	int zero_key;
+	unsigned char *tmp_sgl_buff;
+	struct scatterlist *tmp_sgl;
+
+	union{
+		struct crypto_ahash      *hash;
+		struct crypto_aead       *aead;
+		struct crypto_skcipher   *cipher;
+	} fb;
+};
+
+struct spacc_crypto_reqctx {
+	struct pdu_ddt src, dst;
+	void *digest_buf, *iv_buf;
+	dma_addr_t digest_dma;
+	int dst_nents, src_nents, aead_nents, total_nents;
+	int encrypt_op, mode, single_shot;
+	unsigned int spacc_cipher_cryptlen, rem_nents;
+
+	struct aead_cb_data {
+		int new_handle;
+		struct spacc_crypto_ctx    *tctx;
+		struct spacc_crypto_reqctx *ctx;
+		struct aead_request        *req;
+		struct spacc_device        *spacc;
+	} cb;
+
+	struct ahash_cb_data {
+		int new_handle;
+		struct spacc_crypto_ctx    *tctx;
+		struct spacc_crypto_reqctx *ctx;
+		struct ahash_request       *req;
+		struct spacc_device        *spacc;
+	} acb;
+
+	struct cipher_cb_data {
+		int new_handle;
+		struct spacc_crypto_ctx    *tctx;
+		struct spacc_crypto_reqctx *ctx;
+		struct skcipher_request    *req;
+		struct spacc_device        *spacc;
+	} ccb;
+
+	union {
+		struct ahash_request hash_req;
+		struct skcipher_request cipher_req;
+		struct aead_request aead_req;
+	} fb;
+};
+
+struct mode_tab {
+	char name[128];
+
+	int valid;
+
+	/* mode ID used in hash/cipher mode but not aead*/
+	int id;
+
+	/* ciph/hash mode used in aead */
+	struct {
+		int ciph, hash;
+	} aead;
+
+	unsigned int hashlen, ivlen, blocklen, keylen[3];
+	unsigned int keylen_mask, testlen;
+	unsigned int chunksize, walksize, min_keysize, max_keysize;
+
+	bool sw_fb;
+
+	union {
+		unsigned char hash_test[SPACC_MAX_DIGEST_SIZE];
+		unsigned char ciph_test[3][2 * SPACC_MAX_IV_SIZE];
+	};
+};
+
+struct spacc_alg {
+	struct mode_tab *mode;
+	unsigned int keylen_mask;
+
+	struct device *dev[MAX_DEVICES];
+
+	struct list_head list;
+	struct crypto_alg *calg;
+	struct crypto_tfm *tfm;
+
+	union {
+		struct ahash_alg hash;
+		struct aead_alg aead;
+		struct skcipher_alg skcipher;
+	} alg;
+};
+
+static inline const struct spacc_alg *spacc_tfm_ahash(struct crypto_tfm *tfm)
+{
+	const struct crypto_alg *calg = tfm->__crt_alg;
+
+	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AHASH)
+		return container_of(calg, struct spacc_alg, alg.hash.halg.base);
+
+	return NULL;
+}
+
+static inline const struct spacc_alg *spacc_tfm_skcipher(struct crypto_tfm *tfm)
+{
+	const struct crypto_alg *calg = tfm->__crt_alg;
+
+	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+					CRYPTO_ALG_TYPE_SKCIPHER)
+		return container_of(calg, struct spacc_alg, alg.skcipher.base);
+
+	return NULL;
+}
+
+static inline const struct spacc_alg *spacc_tfm_aead(struct crypto_tfm *tfm)
+{
+	const struct crypto_alg *calg = tfm->__crt_alg;
+
+	if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AEAD)
+		return container_of(calg, struct spacc_alg, alg.aead.base);
+
+	return NULL;
+}
+
+int probe_hashes(struct platform_device *spacc_pdev);
+int spacc_unregister_hash_algs(void);
+
+int probe_aeads(struct platform_device *spacc_pdev);
+int spacc_unregister_aead_algs(void);
+
+int probe_ciphers(struct platform_device *spacc_pdev);
+int spacc_unregister_cipher_algs(void);
+
+int spacc_probe(struct platform_device *pdev,
+		const struct of_device_id snps_spacc_id[]);
+
+irqreturn_t spacc_irq_handler(int irq, void *dev);
+#endif
diff --git a/drivers/crypto/dwc-spacc/spacc_hal.c b/drivers/crypto/dwc-spacc/spacc_hal.c
new file mode 100644
index 000000000000..0d460c4df542
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_hal.c
@@ -0,0 +1,367 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
+#include "spacc_hal.h"
+
+static struct dma_pool *ddt_pool, *ddt16_pool, *ddt4_pool;
+static struct device *ddt_device;
+
+#define PDU_REG_SPACC_VERSION   0x00180UL
+#define PDU_REG_SPACC_CONFIG    0x00184UL
+#define PDU_REG_SPACC_CONFIG2   0x00190UL
+#define PDU_REG_SPACC_IV_OFFSET 0x00040UL
+#define PDU_REG_PDU_CONFIG      0x00188UL
+#define PDU_REG_SECURE_LOCK     0x001C0UL
+
+int pdu_get_version(void __iomem *dev, struct pdu_info *inf)
+{
+	unsigned long tmp;
+
+	if (!inf)
+		return -1;
+
+	memset(inf, 0, sizeof(*inf));
+	tmp = readl(dev + PDU_REG_SPACC_VERSION);
+
+	/* Read the SPAcc version block this tells us the revision,
+	 * project, and a few other feature bits
+	 *
+	 * layout for v6.5+
+	 */
+	inf->spacc_version = (struct spacc_version_block) {
+		.minor      = SPACC_ID_MINOR(tmp),
+		.major      = SPACC_ID_MAJOR(tmp),
+		.version    = (SPACC_ID_MAJOR(tmp) << 4) | SPACC_ID_MINOR(tmp),
+		.qos        = SPACC_ID_QOS(tmp),
+		.is_spacc   = SPACC_ID_TYPE(tmp) == SPACC_TYPE_SPACCQOS,
+		.is_pdu     = SPACC_ID_TYPE(tmp) == SPACC_TYPE_PDU,
+		.aux        = SPACC_ID_AUX(tmp),
+		.vspacc_idx = SPACC_ID_VIDX(tmp),
+		.partial    = SPACC_ID_PARTIAL(tmp),
+		.project    = SPACC_ID_PROJECT(tmp),
+	};
+
+	/* try to autodetect */
+	writel(0x80000000, dev + PDU_REG_SPACC_IV_OFFSET);
+
+	if (readl(dev + PDU_REG_SPACC_IV_OFFSET) == 0x80000000)
+		inf->spacc_version.ivimport = 1;
+	else
+		inf->spacc_version.ivimport = 0;
+
+
+	/* Read the SPAcc config block (v6.5+) which tells us how many
+	 * contexts there are and context page sizes
+	 * this register is only available in v6.5 and up
+	 */
+	tmp = readl(dev + PDU_REG_SPACC_CONFIG);
+	inf->spacc_config = (struct spacc_config_block) {
+		SPACC_CFG_CTX_CNT(tmp),
+		SPACC_CFG_VSPACC_CNT(tmp),
+		SPACC_CFG_CIPH_CTX_SZ(tmp),
+		SPACC_CFG_HASH_CTX_SZ(tmp),
+		SPACC_CFG_DMA_TYPE(tmp),
+		0, 0, 0, 0
+	};
+
+	/* CONFIG2 only present in v6.5+ cores */
+	tmp = readl(dev + PDU_REG_SPACC_CONFIG2);
+	if (inf->spacc_version.qos) {
+		inf->spacc_config.cmd0_fifo_depth =
+				SPACC_CFG_CMD0_FIFO_QOS(tmp);
+		inf->spacc_config.cmd1_fifo_depth =
+				SPACC_CFG_CMD1_FIFO(tmp);
+		inf->spacc_config.cmd2_fifo_depth =
+				SPACC_CFG_CMD2_FIFO(tmp);
+		inf->spacc_config.stat_fifo_depth =
+				SPACC_CFG_STAT_FIFO_QOS(tmp);
+	} else {
+		inf->spacc_config.cmd0_fifo_depth =
+				SPACC_CFG_CMD0_FIFO(tmp);
+		inf->spacc_config.stat_fifo_depth =
+				SPACC_CFG_STAT_FIFO(tmp);
+	}
+
+	/* only read PDU config if it's actually a PDU engine */
+	if (inf->spacc_version.is_pdu) {
+		tmp = readl(dev + PDU_REG_PDU_CONFIG);
+		inf->pdu_config = (struct pdu_config_block)
+			{SPACC_PDU_CFG_MINOR(tmp),
+			 SPACC_PDU_CFG_MAJOR(tmp)};
+
+		/* unlock all cores by default */
+		writel(0, dev + PDU_REG_SECURE_LOCK);
+	}
+
+	return 0;
+}
+
+void pdu_to_dev(void __iomem *addr_, uint32_t *src, unsigned long nword)
+{
+	void __iomem *addr = addr_;
+
+	while (nword--) {
+		writel(*src++, addr);
+		addr += 4;
+	}
+}
+
+void pdu_from_dev(u32 *dst, void __iomem *addr_, unsigned long nword)
+{
+	void __iomem *addr = addr_;
+
+	while (nword--) {
+		*dst++ = readl(addr);
+		addr += 4;
+	}
+}
+
+static void pdu_to_dev_big(void __iomem *addr_, const unsigned char *src,
+			   unsigned long nword)
+{
+	unsigned long v;
+	void __iomem *addr = addr_;
+
+	while (nword--) {
+		v = 0;
+		v = (v << 8) | ((unsigned long)*src++);
+		v = (v << 8) | ((unsigned long)*src++);
+		v = (v << 8) | ((unsigned long)*src++);
+		v = (v << 8) | ((unsigned long)*src++);
+		writel(v, addr);
+		addr += 4;
+	}
+}
+
+static void pdu_from_dev_big(unsigned char *dst, void __iomem *addr_,
+			     unsigned long nword)
+{
+	unsigned long v;
+	void __iomem *addr = addr_;
+
+	while (nword--) {
+		v = readl(addr);
+		addr += 4;
+		*dst++ = (v >> 24) & 0xFF; v <<= 8;
+		*dst++ = (v >> 24) & 0xFF; v <<= 8;
+		*dst++ = (v >> 24) & 0xFF; v <<= 8;
+		*dst++ = (v >> 24) & 0xFF; v <<= 8;
+	}
+}
+
+static void pdu_to_dev_little(void __iomem *addr_, const unsigned char *src,
+			      unsigned long nword)
+{
+	unsigned long v;
+	void __iomem *addr = addr_;
+
+	while (nword--) {
+		v = 0;
+		v = (v >> 8) | ((unsigned long)*src++ << 24UL);
+		v = (v >> 8) | ((unsigned long)*src++ << 24UL);
+		v = (v >> 8) | ((unsigned long)*src++ << 24UL);
+		v = (v >> 8) | ((unsigned long)*src++ << 24UL);
+		writel(v, addr);
+		addr += 4;
+	}
+}
+
+static void pdu_from_dev_little(unsigned char *dst, void __iomem *addr_,
+				unsigned long nword)
+{
+	unsigned long v;
+	void __iomem *addr = addr_;
+
+	while (nword--) {
+		v = readl(addr);
+		addr += 4;
+		*dst++ = v & 0xFF; v >>= 8;
+		*dst++ = v & 0xFF; v >>= 8;
+		*dst++ = v & 0xFF; v >>= 8;
+		*dst++ = v & 0xFF; v >>= 8;
+	}
+}
+
+void pdu_to_dev_s(void __iomem *addr, const unsigned char *src,
+		  unsigned long nword, int endian)
+{
+	if (endian)
+		pdu_to_dev_big(addr, src, nword);
+	else
+		pdu_to_dev_little(addr, src, nword);
+}
+
+void pdu_from_dev_s(unsigned char *dst, void __iomem *addr,
+		    unsigned long nword, int endian)
+{
+	if (endian)
+		pdu_from_dev_big(dst, addr, nword);
+	else
+		pdu_from_dev_little(dst, addr, nword);
+}
+
+void pdu_io_cached_write(void __iomem *addr, unsigned long val,
+			 uint32_t *cache)
+{
+	if (*cache == val) {
+#ifdef CONFIG_CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
+		pr_debug("PDU: write %.8lx -> %p (cached)\n", val, addr);
+#endif
+		return;
+	}
+
+	*cache = val;
+	writel(val, addr);
+}
+
+struct device *get_ddt_device(void)
+{
+	return ddt_device;
+}
+
+/* Platform specific DDT routines */
+
+/* create a DMA pool for DDT entries this should help from splitting
+ * pages for DDTs which by default are 520 bytes long meaning we would
+ * otherwise waste 3576 bytes per DDT allocated...
+ * we also maintain a smaller table of 4 entries common for simple jobs
+ * which uses 480 fewer bytes of DMA memory.
+ * and for good measure another table for 16 entries saving 384 bytes
+ */
+int pdu_mem_init(void *device)
+{
+	if (ddt_device)
+		return 0; /* Already setup */
+
+	ddt_device = device;
+	ddt_pool = dma_pool_create("spaccddt", device, (PDU_MAX_DDT + 1) * 8,
+				   8, 0); /* max of 64 DDT entries */
+
+	if (!ddt_pool)
+		return -1;
+
+#if PDU_MAX_DDT > 16
+	/* max of 16 DDT entries */
+	ddt16_pool = dma_pool_create("spaccddt16", device, (16 + 1) * 8, 8, 0);
+	if (!ddt16_pool) {
+		dma_pool_destroy(ddt_pool);
+		return -1;
+	}
+#else
+	ddt16_pool = ddt_pool;
+#endif
+	/* max of 4 DDT entries */
+	ddt4_pool = dma_pool_create("spaccddt4", device, (4 + 1) * 8, 8, 0);
+	if (!ddt4_pool) {
+		dma_pool_destroy(ddt_pool);
+#if PDU_MAX_DDT > 16
+		dma_pool_destroy(ddt16_pool);
+#endif
+		return -1;
+	}
+
+	return 0;
+}
+
+/* destroy the pool */
+void pdu_mem_deinit(void *device)
+{
+	/* For now, just skip deinit except for matching device */
+	if (device != ddt_device)
+		return;
+
+	dma_pool_destroy(ddt_pool);
+
+#if PDU_MAX_DDT > 16
+	dma_pool_destroy(ddt16_pool);
+#endif
+	dma_pool_destroy(ddt4_pool);
+
+	ddt_device = NULL;
+}
+
+int pdu_ddt_init(struct pdu_ddt *ddt, unsigned long limit)
+{
+	/* set the MSB if we want to use an ATOMIC
+	 * allocation required for top half processing
+	 */
+	int flag = (limit & 0x80000000);
+
+	limit &= 0x7FFFFFFF;
+	if (limit + 1 >= SIZE_MAX / 8) {
+		/* Too big to even compute DDT size */
+		return -1;
+	} else if (limit > PDU_MAX_DDT) {
+		size_t len = 8 * ((size_t)limit + 1);
+
+		ddt->virt = dma_alloc_coherent(ddt_device, len, &ddt->phys,
+					       flag ? GFP_ATOMIC : GFP_KERNEL);
+	} else if (limit > 16) {
+		ddt->virt = dma_pool_alloc(ddt_pool, flag ? GFP_ATOMIC :
+				GFP_KERNEL, &ddt->phys);
+	} else if (limit > 4) {
+		ddt->virt = dma_pool_alloc(ddt16_pool, flag ? GFP_ATOMIC :
+				GFP_KERNEL, &ddt->phys);
+	} else {
+		ddt->virt = dma_pool_alloc(ddt4_pool, flag ? GFP_ATOMIC :
+				GFP_KERNEL, &ddt->phys);
+	}
+
+	ddt->idx = 0;
+	ddt->len = 0;
+	ddt->limit = limit;
+
+	if (!ddt->virt)
+		return -1;
+
+#ifdef CONFIG_CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+	pr_debug("   DDT[%.8lx]: allocated %lu fragments\n",
+				(unsigned long)ddt->phys, limit);
+#endif
+
+	return 0;
+}
+
+int pdu_ddt_add(struct pdu_ddt *ddt, dma_addr_t phys, unsigned long size)
+{
+#ifdef CONFIG_CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
+	pr_debug("   DDT[%.8lx]: 0x%.8lx size %lu\n",
+				(unsigned long)ddt->phys,
+				(unsigned long)phys, size);
+#endif
+
+	if (ddt->idx == ddt->limit)
+		return -1;
+
+	ddt->virt[ddt->idx * 2 + 0] = (uint32_t)phys;
+	ddt->virt[ddt->idx * 2 + 1] = size;
+	ddt->virt[ddt->idx * 2 + 2] = 0;
+	ddt->virt[ddt->idx * 2 + 3] = 0;
+	ddt->len += size;
+	++(ddt->idx);
+
+	return 0;
+}
+
+int pdu_ddt_free(struct pdu_ddt *ddt)
+{
+	if (ddt->virt) {
+		if (ddt->limit > PDU_MAX_DDT) {
+			size_t len = 8 * ((size_t)ddt->limit + 1);
+
+			dma_free_coherent(ddt_device, len, ddt->virt,
+					  ddt->phys);
+		} else if (ddt->limit > 16) {
+			dma_pool_free(ddt_pool, ddt->virt, ddt->phys);
+		} else if (ddt->limit > 4) {
+			dma_pool_free(ddt16_pool, ddt->virt, ddt->phys);
+		} else {
+			dma_pool_free(ddt4_pool, ddt->virt, ddt->phys);
+		}
+
+		ddt->virt = NULL;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_hal.h b/drivers/crypto/dwc-spacc/spacc_hal.h
new file mode 100644
index 000000000000..8b817f993f3d
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_hal.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SPACC_HAL_H
+#define SPACC_HAL_H
+
+/* Maximum number of DDT entries allowed*/
+#ifndef PDU_MAX_DDT
+#define PDU_MAX_DDT		64
+#endif
+
+/* Platform Generic */
+#define PDU_IRQ_EN_GLBL		BIT(31)
+#define PDU_IRQ_EN_VSPACC(x)	(1UL << (x))
+#define PDU_IRQ_EN_RNG		BIT(16)
+
+#ifndef SPACC_ID_MINOR
+	#define SPACC_ID_MINOR(x)		((x)         & 0x0F)
+	#define SPACC_ID_MAJOR(x)		(((x) >>  4) & 0x0F)
+	#define SPACC_ID_QOS(x)			(((x) >>  8) & 0x01)
+	#define SPACC_ID_TYPE(x)		(((x) >>  9) & 0x03)
+	#define SPACC_ID_AUX(x)			(((x) >> 11) & 0x01)
+	#define SPACC_ID_VIDX(x)		(((x) >> 12) & 0x07)
+	#define SPACC_ID_PARTIAL(x)		(((x) >> 15) & 0x01)
+	#define SPACC_ID_PROJECT(x)		((x) >> 16)
+
+	#define SPACC_TYPE_SPACCQOS		0
+	#define SPACC_TYPE_PDU			1
+
+	#define SPACC_CFG_CTX_CNT(x)		((x) & 0x7F)
+	#define SPACC_CFG_RC4_CTX_CNT(x)	(((x) >> 8) & 0x7F)
+	#define SPACC_CFG_VSPACC_CNT(x)		(((x) >> 16) & 0x0F)
+	#define SPACC_CFG_CIPH_CTX_SZ(x)	(((x) >> 20) & 0x07)
+	#define SPACC_CFG_HASH_CTX_SZ(x)	(((x) >> 24) & 0x0F)
+	#define SPACC_CFG_DMA_TYPE(x)		(((x) >> 28) & 0x03)
+
+	#define SPACC_CFG_CMD0_FIFO_QOS(x)	(((x) >> 0) & 0x7F)
+	#define SPACC_CFG_CMD0_FIFO(x)		(((x) >> 0) & 0x1FF)
+	#define SPACC_CFG_CMD1_FIFO(x)		(((x) >> 8) & 0x7F)
+	#define SPACC_CFG_CMD2_FIFO(x)		(((x) >> 16) & 0x7F)
+	#define SPACC_CFG_STAT_FIFO_QOS(x)	(((x) >> 24) & 0x7F)
+	#define SPACC_CFG_STAT_FIFO(x)		(((x) >> 16) & 0x1FF)
+
+	#define SPACC_PDU_CFG_MINOR(x)		((x) & 0x0F)
+	#define SPACC_PDU_CFG_MAJOR(x)		(((x) >> 4)  & 0x0F)
+
+	#define PDU_SECURE_LOCK_SPACC(x)	(x)
+	#define PDU_SECURE_LOCK_CFG		BIT(30)
+	#define PDU_SECURE_LOCK_GLBL		BIT(31)
+#endif /* SPACC_ID_MINOR */
+
+#define CRYPTO_OK                      (0)
+
+struct spacc_version_block {
+	unsigned int minor,
+		     major,
+		     version,
+		     qos,
+		     is_spacc,
+		     is_pdu,
+		     aux,
+		     vspacc_idx,
+		     partial,
+		     project,
+		     ivimport;
+};
+
+struct spacc_config_block {
+	unsigned int num_ctx,
+		     num_vspacc,
+		     ciph_ctx_page_size,
+		     hash_ctx_page_size,
+		     dma_type,
+		     cmd0_fifo_depth,
+		     cmd1_fifo_depth,
+		     cmd2_fifo_depth,
+		     stat_fifo_depth;
+};
+
+struct pdu_config_block {
+	unsigned int minor,
+		     major;
+};
+
+struct pdu_info {
+	u32    clockrate;
+	struct spacc_version_block spacc_version;
+	struct spacc_config_block  spacc_config;
+	struct pdu_config_block    pdu_config;
+};
+
+struct pdu_ddt {
+	dma_addr_t phys;
+	u32 *virt;
+	u32 *virt_orig;
+	unsigned long idx, limit, len;
+};
+
+void pdu_io_cached_write(void __iomem *addr, unsigned long val,
+			uint32_t *cache);
+void pdu_to_dev(void  __iomem *addr, uint32_t *src, unsigned long nword);
+void pdu_from_dev(u32 *dst, void __iomem *addr, unsigned long nword);
+void pdu_from_dev_s(unsigned char *dst, void __iomem *addr, unsigned long nword,
+		    int endian);
+void pdu_to_dev_s(void __iomem *addr, const unsigned char *src,
+		  unsigned long nword, int endian);
+struct device *get_ddt_device(void);
+int pdu_mem_init(void *device);
+void pdu_mem_deinit(void *device);
+int pdu_ddt_init(struct pdu_ddt *ddt, unsigned long limit);
+int pdu_ddt_add(struct pdu_ddt *ddt, dma_addr_t phys, unsigned long size);
+int pdu_ddt_free(struct pdu_ddt *ddt);
+int pdu_get_version(void __iomem *dev, struct pdu_info *inf);
+
+#endif
diff --git a/drivers/crypto/dwc-spacc/spacc_interrupt.c b/drivers/crypto/dwc-spacc/spacc_interrupt.c
new file mode 100644
index 000000000000..176b3d6be25d
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_interrupt.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include "spacc_core.h"
+
+/* Read the IRQ status register and process as needed */
+
+
+void spacc_disable_int (struct spacc_device *spacc);
+
+static inline uint32_t _spacc_get_stat_cnt(struct spacc_device *spacc)
+{
+	u32 fifo;
+
+	if (spacc->config.is_qos)
+		fifo = SPACC_FIFO_STAT_STAT_CNT_GET_QOS(readl(spacc->regmap +
+					SPACC_REG_FIFO_STAT));
+	else
+		fifo = SPACC_FIFO_STAT_STAT_CNT_GET(readl(spacc->regmap +
+					SPACC_REG_FIFO_STAT));
+
+	return fifo;
+}
+
+static int spacc_pop_packets_ex(struct spacc_device *spacc, int *num_popped,
+				unsigned long *lock_flag)
+{
+	int jobs;
+	int ret = -EINPROGRESS;
+	struct spacc_job *job = NULL;
+	u32 cmdstat, swid, spacc_errcode = SPACC_OK;
+
+	*num_popped = 0;
+
+	while ((jobs = _spacc_get_stat_cnt(spacc))) {
+		while (jobs-- > 0) {
+			/* write the pop register to get the next job */
+			writel(1, spacc->regmap + SPACC_REG_STAT_POP);
+			cmdstat = readl(spacc->regmap + SPACC_REG_STATUS);
+
+			swid = SPACC_STATUS_SW_ID_GET(cmdstat);
+
+			if (spacc->job_lookup[swid] == SPACC_JOB_IDX_UNUSED) {
+				ret = -EIO;
+				goto ERR;
+			}
+
+			/* find the associated job with popped swid */
+			if (swid < 0 || swid >= SPACC_MAX_JOBS)
+				job = NULL;
+			else
+				job = &spacc->job[spacc->job_lookup[swid]];
+
+			if (!job) {
+				ret = -EIO;
+				goto ERR;
+			}
+
+			/* mark job as done */
+			job->job_done = 1;
+			spacc->job_lookup[swid] = SPACC_JOB_IDX_UNUSED;
+			spacc_errcode = SPACC_GET_STATUS_RET_CODE(cmdstat);
+
+			switch (spacc_errcode) {
+			case SPACC_ICVFAIL:
+				ret = -EBADMSG;
+				break;
+			case SPACC_MEMERR:
+				ret = -EINVAL;
+				break;
+			case SPACC_BLOCKERR:
+				ret = -EINVAL;
+				break;
+			case SPACC_SECERR:
+				ret = -EIO;
+				break;
+			case SPACC_OK:
+				ret = CRYPTO_OK;
+				break;
+			default:
+				pr_debug("Invalid SPAcc Error");
+			}
+
+			job->job_err = ret;
+
+			/*
+			 * We're done touching the SPAcc hw, so release the
+			 * lock across the job callback.  It must be reacquired
+			 * before continuing to the next iteration.
+			 */
+
+			if (job->cb) {
+				spin_unlock_irqrestore(&spacc->lock,
+							*lock_flag);
+				job->cb(spacc, job->cbdata);
+				spin_lock_irqsave(&spacc->lock,
+							*lock_flag);
+			}
+
+			(*num_popped)++;
+		}
+	}
+
+	if (!*num_popped)
+		pr_debug("   Failed to pop a single job\n");
+
+ERR:
+	spacc_process_jb(spacc);
+
+	/* reset the WD timer to the original value*/
+	if (spacc->op_mode == SPACC_OP_MODE_WD)
+		spacc_set_wd_count(spacc, spacc->config.wd_timer);
+
+	if (*num_popped && spacc->spacc_notify_jobs)
+		spacc->spacc_notify_jobs(spacc);
+
+	return ret;
+}
+
+int spacc_pop_packets(struct spacc_device *spacc, int *num_popped)
+{
+	int err;
+	unsigned long lock_flag;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+	err = spacc_pop_packets_ex(spacc, num_popped, &lock_flag);
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return err;
+}
+
+uint32_t spacc_process_irq(struct spacc_device *spacc)
+{
+	u32 temp;
+	int x, cmd_max;
+	unsigned long lock_flag;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	temp = readl(spacc->regmap + SPACC_REG_IRQ_STAT);
+
+	/* clear interrupt pin and run registered callback */
+	if (temp & SPACC_IRQ_STAT_STAT) {
+		SPACC_IRQ_STAT_CLEAR_STAT(spacc);
+		if (spacc->op_mode == SPACC_OP_MODE_IRQ) {
+			spacc->config.fifo_cnt <<= 2;
+			if (spacc->config.fifo_cnt >=
+					spacc->config.stat_fifo_depth)
+				spacc->config.fifo_cnt =
+					spacc->config.stat_fifo_depth;
+
+			/* update fifo count to allow more stati to pile up*/
+			spacc_irq_stat_enable(spacc, spacc->config.fifo_cnt);
+			 /* reenable CMD0 empty interrupt*/
+			spacc_irq_cmdx_enable(spacc, 0, 0);
+		}
+
+		if (spacc->irq_cb_stat)
+			spacc->irq_cb_stat(spacc);
+	}
+
+	/* Watchdog IRQ */
+	if (spacc->op_mode == SPACC_OP_MODE_WD) {
+		if (temp & SPACC_IRQ_STAT_STAT_WD) {
+			if (++spacc->wdcnt == SPACC_WD_LIMIT) {
+				/* this happens when you get too many IRQs that
+				 * go unanswered
+				 */
+				spacc_irq_stat_wd_disable(spacc);
+				 /* we set the STAT CNT to 1 so that every job
+				  * generates an IRQ now
+				  */
+				spacc_irq_stat_enable(spacc, 1);
+				spacc->op_mode = SPACC_OP_MODE_IRQ;
+			} else if (spacc->config.wd_timer < (0xFFFFFFUL >> 4)) {
+				/* if the timer isn't too high lets bump it up
+				 * a bit so as to give the IRQ a chance to
+				 * reply
+				 */
+				spacc_set_wd_count(spacc,
+						   spacc->config.wd_timer << 4);
+			}
+
+			SPACC_IRQ_STAT_CLEAR_STAT_WD(spacc);
+			if (spacc->irq_cb_stat_wd)
+				spacc->irq_cb_stat_wd(spacc);
+		}
+	}
+
+	if (spacc->op_mode == SPACC_OP_MODE_IRQ) {
+		cmd_max = (spacc->config.is_qos ? SPACC_CMDX_MAX_QOS :
+				SPACC_CMDX_MAX);
+		for (x = 0; x < cmd_max; x++) {
+			if (temp & SPACC_IRQ_STAT_CMDX(x)) {
+				spacc->config.fifo_cnt = 1;
+				/* disable CMD0 interrupt since STAT=1 */
+				spacc_irq_cmdx_disable(spacc, x);
+				spacc_irq_stat_enable(spacc,
+						      spacc->config.fifo_cnt);
+
+				SPACC_IRQ_STAT_CLEAR_CMDX(spacc, x);
+				/* run registered callback */
+				if (spacc->irq_cb_cmdx)
+					spacc->irq_cb_cmdx(spacc, x);
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return temp;
+}
+
+void spacc_set_wd_count(struct spacc_device *spacc, uint32_t val)
+{
+	writel(val, spacc->regmap + SPACC_REG_STAT_WD_CTRL);
+}
+
+/* cmdx and cmdx_cnt depend on HW config
+ * cmdx can be 0, 1 or 2
+ * cmdx_cnt must be 2^6 or less
+ */
+void spacc_irq_cmdx_enable(struct spacc_device *spacc, int cmdx, int cmdx_cnt)
+{
+	u32 temp;
+
+	/* read the reg, clear the bit range and set the new value */
+	temp = readl(spacc->regmap + SPACC_REG_IRQ_CTRL) &
+	       (~SPACC_IRQ_CTRL_CMDX_CNT_MASK(cmdx));
+	temp |= SPACC_IRQ_CTRL_CMDX_CNT_SET(cmdx, cmdx_cnt);
+
+	writel(temp | SPACC_IRQ_CTRL_CMDX_CNT_SET(cmdx, cmdx_cnt),
+	       spacc->regmap + SPACC_REG_IRQ_CTRL);
+
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) | SPACC_IRQ_EN_CMD(cmdx),
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_cmdx_disable(struct spacc_device *spacc, int cmdx)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
+	       (~SPACC_IRQ_EN_CMD(cmdx)), spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_enable(struct spacc_device *spacc, int stat_cnt)
+{
+	u32 temp;
+
+	temp = readl(spacc->regmap + SPACC_REG_IRQ_CTRL);
+	if (spacc->config.is_qos) {
+		temp &= (~SPACC_IRQ_CTRL_STAT_CNT_MASK_QOS);
+		temp |= SPACC_IRQ_CTRL_STAT_CNT_SET_QOS(stat_cnt);
+	} else {
+		temp &= (~SPACC_IRQ_CTRL_STAT_CNT_MASK);
+		temp |= SPACC_IRQ_CTRL_STAT_CNT_SET(stat_cnt);
+	}
+
+	writel(temp, spacc->regmap + SPACC_REG_IRQ_CTRL);
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) | SPACC_IRQ_EN_STAT,
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_disable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) & (~SPACC_IRQ_EN_STAT),
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_wd_enable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) | SPACC_IRQ_EN_STAT_WD,
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_stat_wd_disable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
+	       (~SPACC_IRQ_EN_STAT_WD), spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_glbl_enable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) | SPACC_IRQ_EN_GLBL,
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_irq_glbl_disable(struct spacc_device *spacc)
+{
+	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) & (~SPACC_IRQ_EN_GLBL),
+	       spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+void spacc_disable_int (struct spacc_device *spacc)
+{
+	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
+}
+
+/* a function to run callbacks in the IRQ handler */
+irqreturn_t spacc_irq_handler(int irq, void *dev)
+{
+	struct spacc_priv *priv = platform_get_drvdata(to_platform_device(dev));
+	struct spacc_device *spacc = &priv->spacc;
+
+	if (spacc->config.oldtimer != spacc->config.timer) {
+		priv->spacc.config.wd_timer = spacc->config.timer;
+		spacc_set_wd_count(&priv->spacc, priv->spacc.config.wd_timer);
+		spacc->config.oldtimer = spacc->config.timer;
+	}
+
+	/* check irq flags and process as required */
+	if (!spacc_process_irq(spacc))
+		return IRQ_NONE;
+
+	return IRQ_HANDLED;
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_manager.c b/drivers/crypto/dwc-spacc/spacc_manager.c
new file mode 100644
index 000000000000..3b26b27a998f
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_manager.c
@@ -0,0 +1,650 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "spacc_core.h"
+
+#define MIN(x, y) (((x) < (y)) ? (x) : (y))
+
+/* prevent reading past the end of the buffer */
+static void read_from_buf(unsigned char *dst, unsigned char *src,
+			  int off, int n, int max)
+{
+	if (!dst)
+		return;
+
+	while (off < max && n) {
+		*dst++ = src[off++];
+		--n;
+	}
+}
+
+static void write_to_buf(unsigned char *dst, const unsigned char *src,
+			 int off, int n, int len)
+{
+	if (!src)
+		return;
+
+	while (n && (off < len)) {
+		dst[off++] = *src++;
+		--n;
+	}
+}
+
+/* This function is not meant to be called directly,
+ * it should be called from the job manager
+ */
+static int spacc_ctx_request(struct spacc_device *spacc,
+			     int ctx_id, int ncontig)
+{
+	int ret;
+	int x, y, count;
+	unsigned long lock_flag;
+
+	if (!spacc)
+		return -1;
+
+	if (ctx_id > spacc->config.num_ctx)
+		return -1;
+
+	if (ncontig < 1 || ncontig > spacc->config.num_ctx)
+		return -1;
+
+	ret = CRYPTO_OK;
+
+	spin_lock_irqsave(&spacc->ctx_lock, lock_flag);
+	/* allocating scheme, look for contiguous contexts. Free contexts have
+	 * a ref_cnt of 0.
+	 * If specific ctx_id is requested,
+	 * test the ncontig and then bump the ref_cnt
+	 */
+	if (ctx_id != -1) {
+		if ((&spacc->ctx[ctx_id])->ncontig != ncontig - 1)
+			ret = -1;
+	} else {
+		/* check to see if ncontig are free
+		 * loop over all available contexts to find the first
+		 * ncontig empty ones
+		 */
+		for (x = 0; x <= (spacc->config.num_ctx - ncontig); ) {
+			count = ncontig;
+			while (count) {
+				if ((&spacc->ctx[x + count - 1])->ref_cnt != 0) {
+					/* incr x to past failed count
+					 * location
+					 */
+					x = x + count;
+					break;
+				}
+				count--;
+			}
+			if (count != 0) {
+				ret = -1;
+				/* test next x */
+			} else {
+				ctx_id = x;
+				ret = CRYPTO_OK;
+				break;
+			}
+		}
+	}
+
+	if (ret == CRYPTO_OK) {
+		/* ctx_id is good so mark used */
+		for (y = 0; y < ncontig; y++)
+			(&spacc->ctx[ctx_id + y])->ref_cnt++;
+		(&spacc->ctx[ctx_id])->ncontig = ncontig - 1;
+	} else {
+		ctx_id = -1;
+	}
+
+	spin_unlock_irqrestore(&spacc->ctx_lock, lock_flag);
+
+	return ctx_id;
+}
+
+static int spacc_ctx_release(struct spacc_device *spacc, int ctx_id)
+{
+	int y;
+	int ncontig;
+	unsigned long lock_flag;
+
+	if (ctx_id < 0 || ctx_id > spacc->config.num_ctx)
+		return -EINVAL;
+
+	spin_lock_irqsave(&spacc->ctx_lock, lock_flag);
+	/* release the base context and contiguous block */
+	ncontig = (&spacc->ctx[ctx_id])->ncontig;
+	for (y = 0; y <= ncontig; y++) {
+		if ((&spacc->ctx[ctx_id + y])->ref_cnt > 0)
+			(&spacc->ctx[ctx_id + y])->ref_cnt--;
+	}
+
+	if ((&spacc->ctx[ctx_id])->ref_cnt == 0) {
+		(&spacc->ctx[ctx_id])->ncontig = 0;
+#ifdef CONFIG_CRYPTO_DEV_SPACC_SECURE_MODE
+		/* TODO:  This driver works in harmony with "normal" kernel
+		 * processes so we release the context all the time
+		 * normally this would be done from a "secure" kernel process
+		 * (trustzone/etc).  This hack is so that SPACC.0
+		 * cores can both use the same context space.
+		 */
+		writel(ctx_id, spacc->regmap + SPACC_REG_SECURE_RELEASE);
+#endif
+	}
+
+	spin_unlock_irqrestore(&spacc->ctx_lock, lock_flag);
+
+	return CRYPTO_OK;
+}
+
+/* Job manager: This will reset all job data, pointers, etc */
+void spacc_job_init_all(struct spacc_device *spacc)
+{
+	int x;
+	struct spacc_job *job;
+
+	for (x = 0; x < (SPACC_MAX_JOBS); x++) {
+		job = &spacc->job[x];
+		memset(job, 0, sizeof(struct spacc_job));
+
+		job->job_swid	     = SPACC_JOB_IDX_UNUSED;
+		job->job_used	     = SPACC_JOB_IDX_UNUSED;
+		spacc->job_lookup[x] = SPACC_JOB_IDX_UNUSED;
+	}
+}
+
+/* get a new job id and use a specific ctx_idx or -1 for a new one */
+int spacc_job_request(struct spacc_device *spacc, int ctx_idx)
+{
+	int x, ret;
+	struct spacc_job *job;
+	unsigned long lock_flag;
+
+	if (!spacc)
+		return -1;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	/* find the first available job id */
+	for (x = 0; x < SPACC_MAX_JOBS; x++) {
+		job = &spacc->job[x];
+		if (job->job_used == SPACC_JOB_IDX_UNUSED) {
+			job->job_used = x;
+			break;
+		}
+	}
+
+	if (x == SPACC_MAX_JOBS) {
+		ret = -1;
+	} else {
+		/* associate a single context to go with job */
+		ret = spacc_ctx_request(spacc, ctx_idx, 1);
+		if (ret != -1) {
+			job->ctx_idx = ret;
+			ret = x;
+		}
+	}
+
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+int spacc_job_release(struct spacc_device *spacc, int job_idx)
+{
+	int ret;
+	struct spacc_job *job;
+	unsigned long lock_flag;
+
+	if (!spacc)
+		return -EINVAL;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	job	      = &spacc->job[job_idx];
+	/* release context that goes with job */
+	ret	      = spacc_ctx_release(spacc, job->ctx_idx);
+	job->ctx_idx  = SPACC_CTX_IDX_UNUSED;
+	job->job_used = SPACC_JOB_IDX_UNUSED;
+	/* disable any callback*/
+	job->cb       = NULL;
+
+	/* NOTE: this leaves ctrl data in memory */
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+int spacc_handle_release(struct spacc_device *spacc, int job_idx)
+{
+	int ret = 0;
+	struct spacc_job *job;
+	unsigned long lock_flag;
+
+	if (!spacc)
+		return -EINVAL;
+
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	spin_lock_irqsave(&spacc->lock, lock_flag);
+
+	job	      = &spacc->job[job_idx];
+	job->job_used = SPACC_JOB_IDX_UNUSED;
+	job->cb       = NULL; /* disable any callback*/
+
+	/* NOTE: this leaves ctrl data in memory */
+	spin_unlock_irqrestore(&spacc->lock, lock_flag);
+
+	return ret;
+}
+
+/* Return a context structure for a job idx or null if invalid */
+struct spacc_ctx *context_lookup_by_job(struct spacc_device *spacc, int job_idx)
+{
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
+		return NULL;
+
+	return &spacc->ctx[(&spacc->job[job_idx])->ctx_idx];
+}
+
+int spacc_process_jb(struct spacc_device *spacc)
+{
+	int tail, ret;
+
+	/* are there jobs in the buffer? */
+	while (spacc->jb_head != spacc->jb_tail) {
+		tail = spacc->jb_tail;
+
+		if (spacc->job_buffer[tail].active) {
+			ret = spacc_packet_enqueue_ddt_ex(spacc, 0,
+					spacc->job_buffer[tail].job_idx,
+					spacc->job_buffer[tail].src,
+					spacc->job_buffer[tail].dst,
+					spacc->job_buffer[tail].proc_sz,
+					spacc->job_buffer[tail].aad_offset,
+					spacc->job_buffer[tail].pre_aad_sz,
+					spacc->job_buffer[tail].post_aad_sz,
+					spacc->job_buffer[tail].iv_offset,
+					spacc->job_buffer[tail].prio);
+
+			if (ret != -EBUSY)
+				spacc->job_buffer[tail].active = 0;
+			else
+				return -1;
+		}
+
+		tail++;
+		if (tail == SPACC_MAX_JOB_BUFFERS)
+			tail = 0;
+
+		spacc->jb_tail = tail;
+	}
+
+	return 0;
+}
+
+/* Write appropriate context data which depends on operation and mode */
+int spacc_write_context(struct spacc_device *spacc, int job_idx, int op,
+			const unsigned char *key, int ksz,
+			const unsigned char *iv, int ivsz)
+{
+	int buflen;
+	int ret = CRYPTO_OK;
+	unsigned char buf[300];
+	struct spacc_ctx *ctx = NULL;
+	struct spacc_job *job = NULL;
+
+	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	job = &spacc->job[job_idx];
+	ctx = context_lookup_by_job(spacc, job_idx);
+
+	if (!job || !ctx)
+		return -EIO;
+
+	switch (op) {
+	case SPACC_CRYPTO_OPERATION:
+		/* get page size and then read so we can do a
+		 * read-modify-write cycle
+		 */
+		buflen = MIN(sizeof(buf),
+			   (unsigned int)spacc->config.ciph_page_size);
+
+		pdu_from_dev_s(buf, ctx->ciph_key, buflen >> 2,
+			       spacc->config.spacc_endian);
+
+		switch (job->enc_mode) {
+		case CRYPTO_MODE_SM4_ECB:
+		case CRYPTO_MODE_SM4_CBC:
+		case CRYPTO_MODE_SM4_CFB:
+		case CRYPTO_MODE_SM4_OFB:
+		case CRYPTO_MODE_SM4_CTR:
+		case CRYPTO_MODE_SM4_CCM:
+		case CRYPTO_MODE_SM4_GCM:
+		case CRYPTO_MODE_SM4_CS1:
+		case CRYPTO_MODE_SM4_CS2:
+		case CRYPTO_MODE_SM4_CS3:
+		case CRYPTO_MODE_AES_ECB:
+		case CRYPTO_MODE_AES_CBC:
+		case CRYPTO_MODE_AES_CS1:
+		case CRYPTO_MODE_AES_CS2:
+		case CRYPTO_MODE_AES_CS3:
+		case CRYPTO_MODE_AES_CFB:
+		case CRYPTO_MODE_AES_OFB:
+		case CRYPTO_MODE_AES_CTR:
+		case CRYPTO_MODE_AES_CCM:
+		case CRYPTO_MODE_AES_GCM:
+			write_to_buf(buf, key, 0, ksz, buflen);
+			if (iv) {
+				unsigned char one[4] = { 0, 0, 0, 1 };
+				unsigned long enc1, enc2;
+
+				enc1 = CRYPTO_MODE_AES_GCM;
+				enc2 = CRYPTO_MODE_SM4_GCM;
+
+				write_to_buf(buf, iv, 32, ivsz, buflen);
+				if (ivsz == 12 &&
+				    (job->enc_mode ==  enc1 ||
+				     job->enc_mode == enc2))
+					write_to_buf(buf, one, 11 * 4, 4,
+						     buflen);
+			}
+			break;
+		case CRYPTO_MODE_SM4_F8:
+		case CRYPTO_MODE_AES_F8:
+			if (key) {
+				write_to_buf(buf, key + ksz, 0, ksz, buflen);
+				write_to_buf(buf, key, 48, ksz, buflen);
+			}
+			write_to_buf(buf, iv, 32,  16, buflen);
+			break;
+		case CRYPTO_MODE_SM4_XTS:
+		case CRYPTO_MODE_AES_XTS:
+			if (key) {
+				write_to_buf(buf, key, 0,
+					     ksz >> 1, buflen);
+				write_to_buf(buf, key + (ksz >> 1), 48,
+					     ksz >> 1, buflen);
+				/* divide by two since that's
+				 * what we program the hardware
+				 */
+				ksz = ksz >> 1;
+			}
+			write_to_buf(buf, iv, 32, 16, buflen);
+			break;
+		case CRYPTO_MODE_MULTI2_ECB:
+		case CRYPTO_MODE_MULTI2_CBC:
+		case CRYPTO_MODE_MULTI2_OFB:
+		case CRYPTO_MODE_MULTI2_CFB:
+			write_to_buf(buf, key, 0, ksz, buflen);
+			write_to_buf(buf, iv, 0x28, ivsz, buflen);
+			if (ivsz <= 8) {
+				/*default to 128 rounds*/
+				unsigned char rounds[4] = { 0, 0, 0, 128};
+
+				write_to_buf(buf, rounds, 0x30, 4, buflen);
+			}
+			break;
+		case CRYPTO_MODE_3DES_CBC:
+		case CRYPTO_MODE_3DES_ECB:
+		case CRYPTO_MODE_DES_CBC:
+		case CRYPTO_MODE_DES_ECB:
+			write_to_buf(buf, iv, 0, 8, buflen);
+			write_to_buf(buf, key, 8, ksz, buflen);
+			break;
+		case CRYPTO_MODE_KASUMI_ECB:
+		case CRYPTO_MODE_KASUMI_F8:
+			write_to_buf(buf, iv, 16, 8, buflen);
+			write_to_buf(buf, key, 0, 16, buflen);
+			break;
+		case CRYPTO_MODE_SNOW3G_UEA2:
+		case CRYPTO_MODE_ZUC_UEA3:
+			write_to_buf(buf, key, 0, 32, buflen);
+			break;
+		case CRYPTO_MODE_CHACHA20_STREAM:
+		case CRYPTO_MODE_CHACHA20_POLY1305:
+			write_to_buf(buf, key, 0, ksz, buflen);
+			write_to_buf(buf, iv, 32, ivsz, buflen);
+			break;
+		case CRYPTO_MODE_NULL:
+			break;
+		}
+
+		if (key) {
+			job->ckey_sz = SPACC_SET_CIPHER_KEY_SZ(ksz);
+			job->first_use = 1;
+		}
+		pdu_to_dev_s(ctx->ciph_key, buf, buflen >> 2,
+			     spacc->config.spacc_endian);
+		break;
+
+	case SPACC_HASH_OPERATION:
+		/* get page size and then read so we can do a
+		 * read-modify-write cycle
+		 */
+		buflen = MIN(sizeof(buf),
+			     (u32)spacc->config.hash_page_size);
+		pdu_from_dev_s(buf, ctx->hash_key, buflen >> 2,
+			       spacc->config.spacc_endian);
+
+		switch (job->hash_mode) {
+		case CRYPTO_MODE_MAC_XCBC:
+		case CRYPTO_MODE_MAC_SM4_XCBC:
+			if (key) {
+				write_to_buf(buf, key + (ksz - 32), 32, 32,
+					     buflen);
+				write_to_buf(buf, key, 0, (ksz - 32),
+					     buflen);
+				job->hkey_sz = SPACC_SET_HASH_KEY_SZ(ksz - 32);
+			}
+			break;
+		case CRYPTO_MODE_HASH_CRC32:
+		case CRYPTO_MODE_MAC_SNOW3G_UIA2:
+		case CRYPTO_MODE_MAC_ZUC_UIA3:
+			if (key) {
+				write_to_buf(buf, key, 0, ksz, buflen);
+				job->hkey_sz = SPACC_SET_HASH_KEY_SZ(ksz);
+			}
+			break;
+		case CRYPTO_MODE_MAC_POLY1305:
+			write_to_buf(buf, key, 0, ksz, buflen);
+			write_to_buf(buf, iv, 32, ivsz, buflen);
+			break;
+		case CRYPTO_MODE_HASH_CSHAKE128:
+		case CRYPTO_MODE_HASH_CSHAKE256:
+			/* use "iv" and "key" to */
+			/* pass s-string and n-string */
+			write_to_buf(buf, iv, 0, ivsz, buflen);
+			write_to_buf(buf, key,
+				spacc->config.string_size, ksz, buflen);
+			break;
+		case CRYPTO_MODE_MAC_KMAC128:
+		case CRYPTO_MODE_MAC_KMAC256:
+		case CRYPTO_MODE_MAC_KMACXOF128:
+		case CRYPTO_MODE_MAC_KMACXOF256:
+			/* use "iv" and "key" to pass s-string & key */
+			write_to_buf(buf, iv, 0, ivsz, buflen);
+			write_to_buf(buf, key,
+				spacc->config.string_size, ksz, buflen);
+			job->hkey_sz = SPACC_SET_HASH_KEY_SZ(ksz);
+			break;
+		default:
+			if (key) {
+				job->hkey_sz = SPACC_SET_HASH_KEY_SZ(ksz);
+				write_to_buf(buf, key, 0, ksz, buflen);
+			}
+		}
+		pdu_to_dev_s(ctx->hash_key, buf, buflen >> 2,
+			     spacc->config.spacc_endian);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+int spacc_read_context(struct spacc_device *spacc, int job_idx,
+		       int op, unsigned char *key, int ksz,
+		       unsigned char *iv, int ivsz)
+{
+	int buflen;
+	int ret = CRYPTO_OK;
+	unsigned char buf[300];
+	struct spacc_ctx *ctx = NULL;
+	struct spacc_job *job = NULL;
+
+	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
+		return -ENXIO;
+
+	job = &spacc->job[job_idx];
+	ctx = context_lookup_by_job(spacc, job_idx);
+
+	if (!ctx)
+		return  -EIO;
+
+	switch (op) {
+	case SPACC_CRYPTO_OPERATION:
+		buflen = MIN(sizeof(buf),
+			     (u32)spacc->config.ciph_page_size);
+		pdu_from_dev_s(buf, ctx->ciph_key, buflen >> 2,
+			       spacc->config.spacc_endian);
+
+		switch (job->enc_mode) {
+		case CRYPTO_MODE_SM4_ECB:
+		case CRYPTO_MODE_SM4_CBC:
+		case CRYPTO_MODE_SM4_CFB:
+		case CRYPTO_MODE_SM4_OFB:
+		case CRYPTO_MODE_SM4_CTR:
+		case CRYPTO_MODE_SM4_CCM:
+		case CRYPTO_MODE_SM4_GCM:
+		case CRYPTO_MODE_SM4_CS1:
+		case CRYPTO_MODE_SM4_CS2:
+		case CRYPTO_MODE_SM4_CS3:
+		case CRYPTO_MODE_AES_ECB:
+		case CRYPTO_MODE_AES_CBC:
+		case CRYPTO_MODE_AES_CS1:
+		case CRYPTO_MODE_AES_CS2:
+		case CRYPTO_MODE_AES_CS3:
+		case CRYPTO_MODE_AES_CFB:
+		case CRYPTO_MODE_AES_OFB:
+		case CRYPTO_MODE_AES_CTR:
+		case CRYPTO_MODE_AES_CCM:
+		case CRYPTO_MODE_AES_GCM:
+			read_from_buf(key, buf, 0, ksz, buflen);
+			read_from_buf(iv, buf,  32, 16, buflen);
+			break;
+		case CRYPTO_MODE_CHACHA20_STREAM:
+			read_from_buf(key, buf, 0, ksz, buflen);
+			read_from_buf(iv, buf, 32, 16, buflen);
+			break;
+		case CRYPTO_MODE_SM4_F8:
+		case CRYPTO_MODE_AES_F8:
+			if (key) {
+				read_from_buf(key + ksz, buf, 0,  ksz, buflen);
+				read_from_buf(key, buf, 48, ksz, buflen);
+			}
+			read_from_buf(iv, buf, 32, 16, buflen);
+			break;
+		case CRYPTO_MODE_SM4_XTS:
+		case CRYPTO_MODE_AES_XTS:
+			if (key) {
+				read_from_buf(key, buf, 0, ksz >> 1, buflen);
+				read_from_buf(key + (ksz >> 1), buf,
+					  48, ksz >> 1, buflen);
+			}
+			read_from_buf(iv, buf, 32, 16, buflen);
+			break;
+		case CRYPTO_MODE_MULTI2_ECB:
+		case CRYPTO_MODE_MULTI2_CBC:
+		case CRYPTO_MODE_MULTI2_OFB:
+		case CRYPTO_MODE_MULTI2_CFB:
+			read_from_buf(key, buf, 0, ksz, buflen);
+			/* Number of rounds at the end of the IV */
+			read_from_buf(iv, buf, 0x28, ivsz, buflen);
+			break;
+		case CRYPTO_MODE_3DES_CBC:
+		case CRYPTO_MODE_3DES_ECB:
+			read_from_buf(iv,  buf, 0,  8, buflen);
+			read_from_buf(key, buf, 8, 24, buflen);
+			break;
+		case CRYPTO_MODE_DES_CBC:
+		case CRYPTO_MODE_DES_ECB:
+			read_from_buf(iv,  buf, 0, 8, buflen);
+			read_from_buf(key, buf, 8, 8, buflen);
+			break;
+		case CRYPTO_MODE_KASUMI_ECB:
+		case CRYPTO_MODE_KASUMI_F8:
+			read_from_buf(iv,  buf, 16,  8, buflen);
+			read_from_buf(key, buf, 0,  16, buflen);
+			break;
+		case CRYPTO_MODE_SNOW3G_UEA2:
+		case CRYPTO_MODE_ZUC_UEA3:
+			read_from_buf(key, buf, 0, 32, buflen);
+			break;
+		case CRYPTO_MODE_NULL:
+			break;
+		}
+		break;
+
+	case SPACC_HASH_OPERATION:
+		buflen = MIN(sizeof(buf),
+			     (u32)spacc->config.hash_page_size);
+		pdu_from_dev_s(buf, ctx->hash_key, buflen >> 2,
+			       spacc->config.spacc_endian);
+
+		switch (job->hash_mode) {
+		case CRYPTO_MODE_MAC_XCBC:
+		case CRYPTO_MODE_MAC_SM4_XCBC:
+			if (key && ksz <= 64) {
+				read_from_buf(key + (ksz - 32), buf,
+					  32, 32, buflen);
+				read_from_buf(key, buf, 0,  ksz - 32, buflen);
+			}
+			break;
+		case CRYPTO_MODE_HASH_CRC32:
+			read_from_buf(iv, buf, 0, ivsz, buflen);
+			break;
+		case CRYPTO_MODE_MAC_SNOW3G_UIA2:
+		case CRYPTO_MODE_MAC_ZUC_UIA3:
+			read_from_buf(key, buf, 0,  32, buflen);
+			break;
+		default:
+			read_from_buf(key, buf, 0, ksz, buflen);
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/* Context manager: This will reset all reference counts, pointers, etc */
+void spacc_ctx_init_all(struct spacc_device *spacc)
+{
+	int x;
+	struct spacc_ctx *ctx;
+	unsigned long lock_flag;
+
+	spin_lock_irqsave(&spacc->ctx_lock, lock_flag);
+
+	/* initialize contexts */
+	for (x = 0; x < spacc->config.num_ctx; x++) {
+		ctx = &spacc->ctx[x];
+
+		/* sets everything including ref_cnt and ncontig to 0 */
+		memset(ctx, 0, sizeof(*ctx));
+
+		ctx->ciph_key = spacc->regmap + SPACC_CTX_CIPH_KEY +
+				(x * spacc->config.ciph_page_size);
+		ctx->hash_key = spacc->regmap + SPACC_CTX_HASH_KEY +
+				(x * spacc->config.hash_page_size);
+	}
+
+	spin_unlock_irqrestore(&spacc->ctx_lock, lock_flag);
+}
diff --git a/drivers/crypto/dwc-spacc/spacc_skcipher.c b/drivers/crypto/dwc-spacc/spacc_skcipher.c
new file mode 100644
index 000000000000..488c03ff6c36
--- /dev/null
+++ b/drivers/crypto/dwc-spacc/spacc_skcipher.c
@@ -0,0 +1,712 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <crypto/ctr.h>
+#include <crypto/des.h>
+#include <linux/dma-mapping.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/des.h>
+#include <linux/platform_device.h>
+
+#include "spacc_device.h"
+#include "spacc_core.h"
+
+static LIST_HEAD(spacc_cipher_alg_list);
+static DEFINE_MUTEX(spacc_cipher_alg_mutex);
+
+static struct mode_tab possible_ciphers[] = {
+	/* {keylen, MODE_TAB_CIPH(name, id, iv_len, blk_len)} */
+
+	/* SM4 */
+	{ MODE_TAB_CIPH("cbc(sm4)", SM4_CBC, 16,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("ecb(sm4)", SM4_ECB, 0,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("ctr(sm4)", SM4_CTR, 16,  1), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+	{ MODE_TAB_CIPH("xts(sm4)", SM4_XTS, 16,  16), .keylen[0] = 32,
+	.chunksize = 16, .walksize = 16, .min_keysize = 32, .max_keysize = 32 },
+	{ MODE_TAB_CIPH("cts(cbc(sm4))", SM4_CS3, 16,  16), .keylen[0] = 16,
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 16 },
+
+	/* AES */
+	{ MODE_TAB_CIPH("cbc(aes)", AES_CBC, 16,  16), .keylen = { 16, 24, 32 },
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 32 },
+	{ MODE_TAB_CIPH("ecb(aes)", AES_ECB, 0,  16), .keylen = { 16, 24, 32 },
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 32 },
+	{ MODE_TAB_CIPH("xts(aes)", AES_XTS, 16,  16), .keylen = { 32, 48, 64 },
+	.chunksize = 16, .walksize = 16, .min_keysize = 32, .max_keysize = 64 },
+	{ MODE_TAB_CIPH("cts(cbc(aes))", AES_CS3, 16,  16),
+	.keylen = { 16, 24, 32 }, .chunksize = 16, .walksize = 16,
+	.min_keysize = 16, .max_keysize = 32 },
+	{ MODE_TAB_CIPH("ctr(aes)", AES_CTR, 16,  1), .keylen = { 16, 24, 32 },
+	.chunksize = 16, .walksize = 16, .min_keysize = 16, .max_keysize = 32 },
+
+	/* CHACHA20 */
+	{ MODE_TAB_CIPH("chacha20", CHACHA20_STREAM, 16, 1), .keylen[0] = 32,
+	.chunksize = 64, .walksize = 64, .min_keysize = 32, .max_keysize = 32 },
+
+	/* DES */
+	{ MODE_TAB_CIPH("ecb(des)", DES_ECB, 0,  8), .keylen[0] = 8,
+	.chunksize = 8, .walksize = 8, .min_keysize = 8, .max_keysize = 8},
+	{ MODE_TAB_CIPH("cbc(des)", DES_CBC, 8,  8), .keylen[0] = 8,
+	.chunksize = 8, .walksize = 8, .min_keysize = 8, .max_keysize = 8},
+	{ MODE_TAB_CIPH("ecb(des3_ede)", 3DES_ECB, 0,  8), .keylen[0] = 24,
+	.chunksize = 8, .walksize = 8, .min_keysize = 24, .max_keysize = 24 },
+	{ MODE_TAB_CIPH("cbc(des3_ede)", 3DES_CBC, 8,  8), .keylen[0] = 24,
+	.chunksize = 8, .walksize = 8, .min_keysize = 24, .max_keysize = 24 },
+};
+
+static int spacc_skcipher_fallback(unsigned char *name,
+				   struct skcipher_request *req, int enc_dec)
+{
+	int ret = 0;
+	struct crypto_skcipher *reqtfm   = crypto_skcipher_reqtfm(req);
+	struct spacc_crypto_ctx *tctx    = crypto_skcipher_ctx(reqtfm);
+	struct  spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+
+	tctx->fb.cipher = crypto_alloc_skcipher(name,
+						CRYPTO_ALG_TYPE_SKCIPHER,
+						CRYPTO_ALG_NEED_FALLBACK);
+
+	crypto_skcipher_set_reqsize(reqtfm,
+				    sizeof(struct spacc_crypto_reqctx) +
+				    crypto_skcipher_reqsize(tctx->fb.cipher));
+	ret = crypto_skcipher_setkey(tctx->fb.cipher, tctx->cipher_key,
+				     tctx->key_len);
+	if (ret)
+		return ret;
+
+	skcipher_request_set_tfm(&ctx->fb.cipher_req, tctx->fb.cipher);
+	skcipher_request_set_crypt(&ctx->fb.cipher_req, req->src, req->dst,
+				   req->cryptlen, req->iv);
+
+	if (enc_dec)
+		ret = crypto_skcipher_decrypt(&ctx->fb.cipher_req);
+	else
+		ret = crypto_skcipher_encrypt(&ctx->fb.cipher_req);
+
+	crypto_free_skcipher(tctx->fb.cipher);
+	tctx->fb.cipher = NULL;
+
+	kfree(tctx->cipher_key);
+	tctx->cipher_key = NULL;
+
+	return ret;
+}
+
+static void spacc_cipher_cleanup_dma(struct device *dev,
+				     struct skcipher_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+	struct spacc_crypto_ctx *tctx = ctx->ccb.tctx;
+
+	if (req->dst != req->src) {
+		if (ctx->src_nents) {
+			dma_unmap_sg(dev, req->src, ctx->src_nents,
+					DMA_TO_DEVICE);
+			pdu_ddt_free(&ctx->src);
+		}
+
+		if (ctx->dst_nents) {
+			dma_unmap_sg(dev, req->dst, ctx->dst_nents,
+					DMA_FROM_DEVICE);
+			pdu_ddt_free(&ctx->dst);
+		}
+	} else {
+		if (ctx->src_nents) {
+			dma_unmap_sg(dev, req->src, ctx->src_nents,
+					DMA_TO_DEVICE);
+			pdu_ddt_free(&ctx->src);
+		}
+	}
+
+	kfree(tctx->cipher_key);
+	tctx->cipher_key = NULL;
+}
+
+static void spacc_cipher_cb(void *spacc, void *tfm)
+{
+	int err = -1;
+	struct cipher_cb_data *cb = tfm;
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(cb->req);
+
+	u32 status_reg = readl(cb->spacc->regmap + SPACC_REG_STATUS);
+	u32 status_ret = (status_reg >> 24) & 0x03;
+
+	if (ctx->mode == CRYPTO_MODE_DES_CBC ||
+	    ctx->mode == CRYPTO_MODE_3DES_CBC) {
+		spacc_read_context(cb->spacc, cb->tctx->handle,
+					SPACC_CRYPTO_OPERATION, NULL, 0,
+					cb->req->iv, 8);
+	} else if (ctx->mode != CRYPTO_MODE_DES_ECB  &&
+		   ctx->mode != CRYPTO_MODE_3DES_ECB &&
+		   ctx->mode != CRYPTO_MODE_SM4_ECB  &&
+		   ctx->mode != CRYPTO_MODE_AES_ECB  &&
+		   ctx->mode != CRYPTO_MODE_SM4_XTS  &&
+		   ctx->mode != CRYPTO_MODE_KASUMI_ECB) {
+		if (status_ret == 0x3) {
+			err = -EINVAL;
+			goto CALLBACK_ERR;
+		}
+		spacc_read_context(cb->spacc, cb->tctx->handle,
+				   SPACC_CRYPTO_OPERATION, NULL, 0,
+				   cb->req->iv, 16);
+	}
+
+	if (ctx->mode != CRYPTO_MODE_DES_ECB  &&
+	    ctx->mode != CRYPTO_MODE_DES_CBC  &&
+	    ctx->mode != CRYPTO_MODE_3DES_ECB &&
+	    ctx->mode != CRYPTO_MODE_3DES_CBC) {
+		if (status_ret == 0x03) {
+			err = -EINVAL;
+			goto CALLBACK_ERR;
+		}
+	}
+
+	if (ctx->mode == CRYPTO_MODE_SM4_ECB && status_ret == 0x03) {
+		err = -EINVAL;
+		goto CALLBACK_ERR;
+	}
+
+	if (cb->req->dst != cb->req->src)
+		dma_sync_sg_for_cpu(cb->tctx->dev, cb->req->dst, ctx->dst_nents,
+			    DMA_FROM_DEVICE);
+
+	err = cb->spacc->job[cb->new_handle].job_err;
+
+CALLBACK_ERR:
+	spacc_cipher_cleanup_dma(cb->tctx->dev, cb->req);
+	spacc_close(cb->spacc, cb->new_handle);
+	skcipher_request_complete(cb->req, err);
+}
+
+static int spacc_cipher_init_dma(struct device *dev,
+				 struct skcipher_request *req)
+{
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+	int rc;
+
+	if (req->src == req->dst) {
+		rc = spacc_sg_to_ddt(dev, req->src, req->cryptlen, &ctx->src,
+				DMA_TO_DEVICE);
+		if (rc < 0) {
+			pdu_ddt_free(&ctx->src);
+			return rc;
+		}
+		ctx->src_nents = rc;
+	} else {
+		rc = spacc_sg_to_ddt(dev, req->src, req->cryptlen, &ctx->src,
+				DMA_TO_DEVICE);
+		if (rc < 0) {
+			pdu_ddt_free(&ctx->src);
+			return rc;
+		}
+		ctx->src_nents = rc;
+
+		rc = spacc_sg_to_ddt(dev, req->dst, req->cryptlen, &ctx->dst,
+				DMA_FROM_DEVICE);
+		if (rc < 0) {
+			pdu_ddt_free(&ctx->dst);
+			return rc;
+		}
+		ctx->dst_nents = rc;
+	}
+
+	return 0;
+}
+
+static int spacc_cipher_cra_init(struct crypto_tfm *tfm)
+{
+	struct spacc_crypto_ctx *tctx = crypto_tfm_ctx(tfm);
+	const struct spacc_alg *salg = spacc_tfm_skcipher(tfm);
+
+	tctx->keylen	 = 0;
+	tctx->cipher_key = NULL;
+	tctx->handle	 = -1;
+	tctx->ctx_valid	 = false;
+	tctx->dev	 = get_device(salg->dev[0]);
+
+	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+				    sizeof(struct spacc_crypto_reqctx));
+
+	return 0;
+}
+
+static void spacc_cipher_cra_exit(struct crypto_tfm *tfm)
+{
+	struct spacc_crypto_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
+
+
+	if (tctx->handle >= 0)
+		spacc_close(&priv->spacc, tctx->handle);
+
+	put_device(tctx->dev);
+}
+
+
+static int spacc_check_keylen(const struct spacc_alg *salg, unsigned int keylen)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(salg->mode->keylen); i++)
+		if (salg->mode->keylen[i] == keylen)
+			return 0;
+
+	return -EINVAL;
+}
+
+static int spacc_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			       unsigned int keylen)
+{
+	int ret = 0, rc = 0, err;
+	const struct spacc_alg *salg    =  spacc_tfm_skcipher(&tfm->base);
+	struct spacc_crypto_ctx *tctx   = crypto_skcipher_ctx(tfm);
+	struct spacc_priv *priv         = dev_get_drvdata(tctx->dev);
+	struct spacc_crypto_reqctx *ctx	= crypto_skcipher_ctx(tfm);
+
+	err = spacc_check_keylen(salg, keylen);
+	if (err)
+		return err;
+
+	ctx->mode        = salg->mode->id;
+	tctx->key_len    = keylen;
+	tctx->cipher_key = kmalloc(keylen, GFP_KERNEL);
+	memcpy(tctx->cipher_key, key, keylen);
+
+	if (tctx->handle >= 0) {
+		spacc_close(&priv->spacc, tctx->handle);
+		put_device(tctx->dev);
+		tctx->handle = -1;
+		tctx->dev    = NULL;
+	}
+
+	priv = NULL;
+	priv = dev_get_drvdata(salg->dev[0]);
+	tctx->dev = get_device(salg->dev[0]);
+	ret = spacc_isenabled(&priv->spacc, salg->mode->id,
+				       keylen);
+	if (ret)
+		tctx->handle = spacc_open(&priv->spacc, salg->mode->id,
+					  CRYPTO_MODE_NULL, -1, 0,
+					  spacc_cipher_cb, tfm);
+
+	if (tctx->handle < 0) {
+		put_device(salg->dev[0]);
+		dev_dbg(salg->dev[0], "failed to open SPAcc context\n");
+		return -EINVAL;
+	}
+
+	/* Weak key Implementation for DES_ECB */
+	if (salg->mode->id == CRYPTO_MODE_DES_ECB) {
+		err = verify_skcipher_des_key(tfm, key);
+		if (err)
+			return -EINVAL;
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_SM4_F8 ||
+	    salg->mode->id == CRYPTO_MODE_AES_F8) {
+		/* f8 mode requires an IV of 128-bits and a key-salt mask,
+		 * equivalent in size to the key.
+		 * AES-F8 or SM4-F8 mode has a SALTKEY prepended to the base
+		 * key.
+		 */
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_CRYPTO_OPERATION, key, 16,
+					 NULL, 0);
+	} else {
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_CRYPTO_OPERATION, key, keylen,
+					 NULL, 0);
+	}
+
+	if (rc < 0) {
+		dev_dbg(salg->dev[0], "failed with SPAcc write context\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int spacc_cipher_process(struct skcipher_request *req, int enc_dec)
+{
+	u8 ivc1[16];
+	unsigned char *name;
+	unsigned int len = 0;
+	u32 num_iv = 0, diff;
+	u64 num_iv64 = 0, diff64;
+	unsigned char chacha20_iv[16];
+	int rc = 0, ret = 0, i = 0, j = 0;
+	struct crypto_skcipher *reqtfm  = crypto_skcipher_reqtfm(req);
+	struct spacc_crypto_ctx *tctx	= crypto_skcipher_ctx(reqtfm);
+	struct spacc_crypto_reqctx *ctx	= skcipher_request_ctx(req);
+	struct spacc_priv *priv		= dev_get_drvdata(tctx->dev);
+	const struct spacc_alg *salg	= spacc_tfm_skcipher(&reqtfm->base);
+	struct spacc_device *device_h	= &priv->spacc;
+
+	len = ctx->spacc_cipher_cryptlen / 16;
+
+	if (req->cryptlen == 0) {
+		if (salg->mode->id == CRYPTO_MODE_SM4_CS3  ||
+		    salg->mode->id == CRYPTO_MODE_SM4_XTS  ||
+		    salg->mode->id == CRYPTO_MODE_AES_XTS  ||
+		    salg->mode->id == CRYPTO_MODE_AES_CS3)
+			return -EINVAL;
+		else
+			return 0;
+	}
+
+	/* Given IV - <1st 4-bytes as counter value>
+	 *            <last 12-bytes as nonce>
+	 * Reversing the order of nonce & counter as,
+	 *            <1st 12-bytes as nonce>
+	 *            <last 4-bytes as counter>
+	 * and then write to HW context,
+	 * ex:
+	 * Given IV - 2a000000000000000000000000000002
+	 * Reverse order - 0000000000000000000000020000002a
+	 */
+	if (salg->mode->id == CRYPTO_MODE_CHACHA20_STREAM) {
+		for (i = 4; i < 16; i++) {
+			chacha20_iv[j] = req->iv[i];
+			j++;
+		}
+
+		j = j + 3;
+
+		for (i = 0; i <= 3; i++) {
+			chacha20_iv[j] = req->iv[i];
+			j--;
+		}
+		memcpy(req->iv, chacha20_iv, 16);
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_SM4_CFB) {
+		if (req->cryptlen % 16 != 0) {
+			name = salg->calg->cra_name;
+			ret = spacc_skcipher_fallback(name, req, enc_dec);
+			return ret;
+		}
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_SM4_XTS ||
+	    salg->mode->id == CRYPTO_MODE_SM4_CS3 ||
+	    salg->mode->id == CRYPTO_MODE_AES_XTS ||
+	    salg->mode->id == CRYPTO_MODE_AES_CS3) {
+		if (req->cryptlen == 16) {
+			name = salg->calg->cra_name;
+			ret = spacc_skcipher_fallback(name, req, enc_dec);
+			return ret;
+		}
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_AES_CTR ||
+	    salg->mode->id == CRYPTO_MODE_SM4_CTR) {
+		/* copy the IV to local buffer */
+		for (i = 0; i < 16; i++)
+			ivc1[i] = req->iv[i];
+
+		/* 32-bit counter width */
+		if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3) & (0x2)) {
+
+			for (i = 12; i < 16; i++) {
+				num_iv <<= 8;
+				num_iv |= ivc1[i];
+			}
+
+			diff = SPACC_CTR_IV_MAX32 - num_iv;
+
+			if (len > diff) {
+				name = salg->calg->cra_name;
+				ret = spacc_skcipher_fallback(name,
+							      req, enc_dec);
+				return ret;
+			}
+		} else if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
+			  & (0x3)) { /* 64-bit counter width */
+
+			for (i = 8; i < 16; i++) {
+				num_iv64 <<= 8;
+				num_iv64 |= ivc1[i];
+			}
+
+			diff64 = SPACC_CTR_IV_MAX64 - num_iv64;
+
+			if (len > diff64) {
+				name = salg->calg->cra_name;
+				ret = spacc_skcipher_fallback(name,
+							      req, enc_dec);
+				return ret;
+			}
+		} else if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
+			   & (0x1)) { /* 16-bit counter width */
+
+			for (i = 14; i < 16; i++) {
+				num_iv <<= 8;
+				num_iv |= ivc1[i];
+			}
+
+			diff = SPACC_CTR_IV_MAX16 - num_iv;
+
+			if (len > diff) {
+				name = salg->calg->cra_name;
+				ret = spacc_skcipher_fallback(name,
+							      req, enc_dec);
+				return ret;
+			}
+		} else if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
+			   & (0x0)) { /* 8-bit counter width */
+
+			for (i = 15; i < 16; i++) {
+				num_iv <<= 8;
+				num_iv |= ivc1[i];
+			}
+
+			diff = SPACC_CTR_IV_MAX8 - num_iv;
+
+			if (len > diff) {
+				name = salg->calg->cra_name;
+				ret = spacc_skcipher_fallback(name,
+							      req, enc_dec);
+				return ret;
+			}
+		}
+	}
+
+	if (salg->mode->id == CRYPTO_MODE_DES_CBC ||
+	    salg->mode->id == CRYPTO_MODE_3DES_CBC)
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_CRYPTO_OPERATION, NULL, 0,
+					 req->iv, 8);
+	else if (salg->mode->id != CRYPTO_MODE_DES_ECB  &&
+		 salg->mode->id != CRYPTO_MODE_3DES_ECB &&
+		 salg->mode->id != CRYPTO_MODE_SM4_ECB  &&
+		 salg->mode->id != CRYPTO_MODE_AES_ECB  &&
+		 salg->mode->id != CRYPTO_MODE_KASUMI_ECB)
+		rc = spacc_write_context(&priv->spacc, tctx->handle,
+					 SPACC_CRYPTO_OPERATION, NULL, 0,
+					 req->iv, 16);
+
+	if (rc < 0)
+		pr_err("ERR: spacc_write_context\n");
+
+	/* Initialize the DMA */
+	rc = spacc_cipher_init_dma(tctx->dev, req);
+
+	ctx->ccb.new_handle = spacc_clone_handle(&priv->spacc, tctx->handle,
+						 &ctx->ccb);
+	if (ctx->ccb.new_handle < 0) {
+		spacc_cipher_cleanup_dma(tctx->dev, req);
+		dev_dbg(salg->dev[0], "failed to clone handle\n");
+		return -EINVAL;
+	}
+
+	/* copying the data to clone handle */
+	ctx->ccb.tctx  = tctx;
+	ctx->ccb.ctx   = ctx;
+	ctx->ccb.req   = req;
+	ctx->ccb.spacc = &priv->spacc;
+
+	if (salg->mode->id == CRYPTO_MODE_SM4_CS3) {
+		int handle = ctx->ccb.new_handle;
+
+		if (handle < 0 || handle > SPACC_MAX_JOBS)
+			return -ENXIO;
+
+		device_h->job[handle].auxinfo_cs_mode = 3;
+	}
+
+	if (enc_dec) {  /* for decrypt */
+		rc = spacc_set_operation(&priv->spacc, ctx->ccb.new_handle, 1,
+					 ICV_IGNORE, IP_ICV_IGNORE, 0, 0, 0);
+		spacc_set_key_exp(&priv->spacc, ctx->ccb.new_handle);
+	} else {       /* for encrypt */
+		rc = spacc_set_operation(&priv->spacc, ctx->ccb.new_handle, 0,
+					 ICV_IGNORE, IP_ICV_IGNORE, 0, 0, 0);
+	}
+
+	rc = spacc_packet_enqueue_ddt(&priv->spacc, ctx->ccb.new_handle,
+				      &ctx->src,
+				      (req->dst == req->src) ? &ctx->src :
+				      &ctx->dst,
+				      req->cryptlen,
+				      0, 0, 0, 0, 0);
+	if (rc < 0) {
+		spacc_cipher_cleanup_dma(tctx->dev, req);
+		spacc_close(&priv->spacc, ctx->ccb.new_handle);
+
+		if (rc != -EBUSY && rc < 0) {
+			dev_err(tctx->dev,
+				"failed to enqueue job, ERR: %d\n", rc);
+			return rc;
+		} else if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
+			return -EBUSY;
+		}
+	}
+
+	priv->spacc.job[tctx->handle].first_use  = 0;
+	priv->spacc.job[tctx->handle].ctrl &=
+		~(1UL << priv->spacc.config.ctrl_map[SPACC_CTRL_KEY_EXP]);
+
+	return -EINPROGRESS;
+}
+
+static int spacc_cipher_encrypt(struct skcipher_request *req)
+{
+	int rv = 0;
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+
+	ctx->spacc_cipher_cryptlen = req->cryptlen;
+
+	/* enc_dec - 0(encrypt), 1(decrypt) */
+	rv = spacc_cipher_process(req, 0);
+
+	return rv;
+}
+
+static int spacc_cipher_decrypt(struct skcipher_request *req)
+{
+	int rv = 0;
+	struct spacc_crypto_reqctx *ctx = skcipher_request_ctx(req);
+
+	ctx->spacc_cipher_cryptlen = req->cryptlen;
+
+	/* enc_dec - 0(encrypt), 1(decrypt) */
+	rv = spacc_cipher_process(req, 1);
+
+	return rv;
+}
+
+static struct skcipher_alg spacc_skcipher_alg = {
+	.setkey = spacc_cipher_setkey,
+	.encrypt = spacc_cipher_encrypt,
+	.decrypt = spacc_cipher_decrypt,
+	/*
+	 * Chunksize: Equal to the block size except for stream cipher
+	 * such as CTR where it is set to the underlying block size.
+	 *
+	 * Walksize: Equal to the chunk size except in cases where the
+	 * algorithm is considerably more efficient if it can operate on
+	 * multiple chunks in parallel. Should be a multiple of chunksize.
+	 */
+	.min_keysize	= 16,
+	.max_keysize	= 64,
+	.ivsize		= 16,
+	.chunksize	= 16,
+	.walksize	= 16,
+	.base = {
+		.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER	 |
+			     CRYPTO_ALG_ASYNC		 |
+			     CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize	= 16,
+		.cra_ctxsize	= sizeof(struct spacc_crypto_ctx),
+		.cra_priority	= 300,
+		.cra_init	= spacc_cipher_cra_init,
+		.cra_exit	= spacc_cipher_cra_exit,
+		.cra_module	= THIS_MODULE,
+	},
+};
+
+static void spacc_init_calg(struct crypto_alg *calg,
+			    const struct mode_tab *mode)
+{
+
+	strscpy(calg->cra_name, mode->name, sizeof(mode->name) - 1);
+	calg->cra_name[sizeof(mode->name) - 1] = '\0';
+
+	strscpy(calg->cra_driver_name, "spacc-");
+	strcat(calg->cra_driver_name, mode->name);
+	calg->cra_driver_name[sizeof(calg->cra_driver_name) - 1] = '\0';
+	calg->cra_blocksize = mode->blocklen;
+}
+
+static int spacc_register_cipher(struct spacc_alg *salg,
+				 unsigned int algo_idx)
+{
+	int rc;
+
+	salg->calg         = &salg->alg.skcipher.base;
+	salg->alg.skcipher = spacc_skcipher_alg;
+
+	/* this function will assign mode->name to calg->cra_name &
+	 * calg->cra_driver_name
+	 */
+	spacc_init_calg(salg->calg, salg->mode);
+	salg->alg.skcipher.ivsize = salg->mode->ivlen;
+	salg->alg.skcipher.base.cra_blocksize = salg->mode->blocklen;
+
+	salg->alg.skcipher.chunksize   = possible_ciphers[algo_idx].chunksize;
+	salg->alg.skcipher.walksize    = possible_ciphers[algo_idx].walksize;
+	salg->alg.skcipher.min_keysize = possible_ciphers[algo_idx].min_keysize;
+	salg->alg.skcipher.max_keysize = possible_ciphers[algo_idx].max_keysize;
+
+	rc = crypto_register_skcipher(&salg->alg.skcipher);
+	if (rc < 0)
+		return rc;
+
+	mutex_lock(&spacc_cipher_alg_mutex);
+	list_add(&salg->list, &spacc_cipher_alg_list);
+	mutex_unlock(&spacc_cipher_alg_mutex);
+
+	return 0;
+}
+
+int probe_ciphers(struct platform_device *spacc_pdev)
+{
+	int rc;
+	unsigned int i, y;
+	int registered = 0;
+	struct spacc_alg *salg;
+	struct spacc_priv *priv = dev_get_drvdata(&spacc_pdev->dev);
+
+	for (i = 0; i < ARRAY_SIZE(possible_ciphers); i++)
+		possible_ciphers[i].valid = 0;
+
+	for (i = 0; i < ARRAY_SIZE(possible_ciphers) &&
+	     (possible_ciphers[i].valid == 0); i++) {
+		for (y = 0; y < 3; y++) {
+			if (spacc_isenabled(&priv->spacc,
+					    possible_ciphers[i].id & 0xFF,
+					    possible_ciphers[i].keylen[y])) {
+				salg = kmalloc(sizeof(*salg), GFP_KERNEL);
+				if (!salg)
+					return -ENOMEM;
+
+				salg->mode = &possible_ciphers[i];
+				salg->dev[0] = &spacc_pdev->dev;
+
+				if (possible_ciphers[i].valid == 0) {
+					rc = spacc_register_cipher(salg, i);
+					if (rc < 0) {
+						kfree(salg);
+						continue;
+					}
+				}
+				dev_dbg(&spacc_pdev->dev, "registered %s\n",
+					 possible_ciphers[i].name);
+				registered++;
+				possible_ciphers[i].valid = 1;
+			}
+		}
+	}
+
+	return registered;
+}
+
+int spacc_unregister_cipher_algs(void)
+{
+	struct spacc_alg *salg, *tmp;
+
+	mutex_lock(&spacc_cipher_alg_mutex);
+
+	list_for_each_entry_safe(salg, tmp, &spacc_cipher_alg_list, list) {
+		crypto_unregister_skcipher(&salg->alg.skcipher);
+		list_del(&salg->list);
+		kfree(salg);
+	}
+
+	mutex_unlock(&spacc_cipher_alg_mutex);
+
+	return 0;
+}
-- 
2.25.1


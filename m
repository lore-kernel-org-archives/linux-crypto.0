Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533DE23A98E;
	Sun, 25 Jan 2026 03:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312176; cv=none; b=ecsy3eenbpHiyh63ltXMyE5FGNRPR3Su/UmIw3dqf1PaLRGv3ohcFFjD6lOjZhoiW9I0eTj/UM6ZWH/5x7YovbpvH1l9aYFBMz0p1Z0X3MnEy+46UALlYIo17MH/I6UqxSN7dCgtEU57BhSB6n8BKq0u32LIj6CQJeosZYX6HJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312176; c=relaxed/simple;
	bh=HLaFsbk/WrU5xBQBaq3E/7AsJAKP0Y0Tu3LFo8r9u9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fD1Rz3OQjlsz+7mDtCmzvvoiuO44HC8vW0THTDzlGpkOOPpZJUOB7l2uQiQlff7B5akzKcfGdf9QiuoH/C1pdZbsrvFzYnI/5zgceNnGw9UPG0tibomUbx2EpGSVYEUZ0KJ2c8x1FV6/k80myZndhZVEdnuC5aKRPc65kLrCuws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hmYHw8Sg; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hmYHw8Sg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312173; x=1800848173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HLaFsbk/WrU5xBQBaq3E/7AsJAKP0Y0Tu3LFo8r9u9E=;
  b=hmYHw8Sg560D0KITtDspDHXSiQF80tczWyKxvMz+qsw+17Jzf3WB3oDA
   MNQbjY3sFz6E2IzNmAQx5XanYu8iL0j3UZqH981tF/BT1dvc58mpunDb8
   g+bx/DpmnePD/3wWmU8FJONoA+ZflH78by31KK7O1e/2OzcY1orlTVm+V
   5LqgRdmGBtk0J7kP3NmT17h3aXFagqm3lp/B9E4rzVhOd6grCuzpvAHBn
   /CrRzcoMd28awO9Kx4CH1VKY5Fo8nJDVcMaoCWgPx4bS7gx7UhnRkkH8P
   JWHJmemh4B7Kuxnjv7QmG1d5DXRHg6jti8pCr74XoDLWoCaebvWe1SLSv
   A==;
X-CSE-ConnectionGUID: ymwG6GQrRNW+yW6ZzPZR0g==
X-CSE-MsgGUID: BwhV9dgySD2MKbiryMxasQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887619"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887619"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:09 -0800
X-CSE-ConnectionGUID: +HZfjPfCTf+VG6Vf0RSYrg==
X-CSE-MsgGUID: U0TlPW03T+6O/lfbu5BhWw==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:08 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 21/26] crypto: iaa - Add deflate-iaa-dynamic compression mode.
Date: Sat, 24 Jan 2026 19:35:32 -0800
Message-Id: <20260125033537.334628-22-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some versions of Intel IAA such as Granite Rapids, support dynamic
compression where the hardware dynamically computes the Huffman tables
and generates a Deflate header if the input size is no larger than
4KB. This patch will use IAA for dynamic compression if an appropriate
IAA is present and the input size is not greater than 4KB. If an IAA is
not present, the algorithm will not be available. Otherwise, if the size
of the input is greater than PAGE_SIZE, zlib is used to do the
compression. If the algorithm is selected, IAA will be used for
decompression. If the compressed stream contains a reference whose
distance is greater than 4KB, hardware decompression will fail, and the
decompression will be done with zlib.

Intel IAA dynamic compression results in a compression ratio that is
better than or equal to the currently supported "fixed" compression mode
on the same data set. Compressing a data set of 4300 4KB pages sampled
from SPEC CPU17 workloads produces a compression ratio of 3.14 for IAA
dynamic compression and 2.69 for IAA fixed compression.

If an appropriate IAA exists, dynamic mode can be chosen as the IAA
compression mode by selecting the corresponding algorithm.

For example, to use IAA dynamic mode in zswap:

      echo deflate-iaa-dynamic > /sys/module/zswap/parameters/compressor

This patch also adds a deflate_generic_compress() fallback when dynamic
mode is selected and the input size is over 4KB; along with stats
support that will count these software fallback calls as
"total_sw_comp_calls" in the driver's global_stats.

Furthermore, we define IAA_DYN_ALLOC_DESC_COMP_TIMEOUT as 2000 for
dynamic mode compression on Granite Rapids.

The acomp_alg flags for deflate-iaa-dynamic indicate support for
segmentation.

Signed-off-by: Andre Glover <andre.glover@linux.intel.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 .../driver-api/crypto/iaa/iaa-crypto.rst      |  21 ++++
 crypto/testmgr.c                              |  10 ++
 crypto/testmgr.h                              |  74 +++++++++++++
 drivers/crypto/intel/iaa/Makefile             |   2 +-
 drivers/crypto/intel/iaa/iaa_crypto.h         |   8 +-
 .../intel/iaa/iaa_crypto_comp_dynamic.c       |  22 ++++
 drivers/crypto/intel/iaa/iaa_crypto_main.c    | 104 ++++++++++++++++--
 drivers/crypto/intel/iaa/iaa_crypto_stats.c   |   8 ++
 drivers/crypto/intel/iaa/iaa_crypto_stats.h   |   2 +
 9 files changed, 241 insertions(+), 10 deletions(-)
 create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index 81a7dbd15f8b..e841a33564db 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -33,6 +33,8 @@ compresses and decompresses.
 Currently, there is only one compression modes available, 'fixed'
 mode.
 
+'dynamic' mode is available on certain generations of IAA hardware.
+
 The 'fixed' compression mode implements the compression scheme
 specified by RFC 1951 and is given the crypto algorithm name
 'deflate-iaa'.  (Because the IAA hardware has a 4k history-window
@@ -43,6 +45,25 @@ the IAA fixed mode deflate algorithm is given its own algorithm name
 rather than simply 'deflate').
 
 
+The 'dynamic' compression mode implements a compression scheme where
+the IAA hardware will internally do one pass through the data, compute the
+Huffman tables and generate a Deflate header, then automatically do a
+second pass through the data, generating the final compressed output. IAA
+dynamic compression can be used if an appropriate IAA is present and the
+input size is not too big.  If an appropriate IAA is not present, the
+algorithm will not be available. Otherwise, if the size of the input is too
+big, zlib is used to do the compression. If the algorithm is selected,
+IAA will be used for decompression. If the compressed stream contains a
+reference whose distance is greater than 4KB, hardware decompression will
+fail, and the decompression will be done with zlib. If an appropriate IAA
+exists, 'dynamic' compression, it is implemented by the
+'deflate-iaa-dynamic' crypto algorithm.
+
+A zswap device can select the IAA 'dynamic' mode represented by
+selecting the 'deflate-iaa-dynamic' crypto compression algorithm::
+
+  # echo deflate-iaa-dynamic> /sys/module/zswap/parameters/compressor
+
 Config options and other setup
 ==============================
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a302be53896d..de91d23e6d40 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4571,6 +4571,16 @@ static const struct alg_test_desc alg_test_descs[] = {
 				.decomp = __VECS(deflate_decomp_tv_template)
 			}
 		}
+	}, {
+		.alg = "deflate-iaa-dynamic",
+		.test = alg_test_comp,
+		.fips_allowed = 1,
+		.suite = {
+			.comp = {
+				.comp = __VECS(deflate_iaa_dynamic_comp_tv_template),
+				.decomp = __VECS(deflate_iaa_dynamic_decomp_tv_template)
+			}
+		}
 	}, {
 		.alg = "dh",
 		.test = alg_test_kpp,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 80bf5f1b67a6..819503131cdd 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -33364,6 +33364,80 @@ static const struct comp_testvec deflate_decomp_tv_template[] = {
 	},
 };
 
+static const struct comp_testvec deflate_iaa_dynamic_comp_tv_template[] = {
+	{
+		.inlen	= 70,
+		.outlen	= 46,
+		.input	= "Join us now and share the software "
+			"Join us now and share the software ",
+		.output = "\x85\xca\xc1\x09\x00\x20\x08\x05"
+			  "\xd0\x55\xfe\x3c\x6e\x21\x64\xd8"
+			  "\x45\x21\x0d\xd7\xb7\x26\xe8\xf8"
+			  "\xe0\x91\x2f\xc3\x09\x98\x17\xd8"
+			  "\x06\x42\x79\x0b\x52\x05\xe1\x33"
+			  "\xeb\x81\x3e\xe5\xa2\x01",
+	}, {
+		.inlen	= 191,
+		.outlen	= 121,
+		.input	= "This document describes a compression method based on the DEFLATE "
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+		.output = "\x5d\x8d\xc1\x0d\xc2\x30\x10\x04"
+			  "\x5b\xd9\x0a\xd2\x03\x82\x20\x21"
+			  "\xf1\xf0\x23\x0d\x5c\xec\x0b\xb6"
+			  "\x64\xfb\x2c\xdf\xf1\xa0\x7b\x12"
+			  "\x3e\x58\x79\xae\x76\x67\x76\x89"
+			  "\x49\x11\xc4\xbf\x0b\x57\x43\x60"
+			  "\xf5\x3d\xad\xac\x20\x78\x29\xad"
+			  "\xb3\x6a\x92\x8a\xc2\x16\x25\x60"
+			  "\x25\xe5\x80\x3d\x5b\x64\xdc\xe6"
+			  "\xfb\xf3\xb2\xcc\xe3\x8c\xf2\x4b"
+			  "\x7a\xb2\x58\x26\xe0\x2c\xde\x52"
+			  "\xdd\xb5\x07\x48\xad\xe5\xe4\xc9"
+			  "\x0e\x42\xb6\xd1\xf5\x17\xc0\xe4"
+			  "\x57\x3c\x1c\x1c\x7d\xb2\x50\xc0"
+			  "\x75\x38\x72\x5d\x4c\xbc\xe4\xe9"
+			  "\x0b",
+	},
+};
+
+static const struct comp_testvec deflate_iaa_dynamic_decomp_tv_template[] = {
+	{
+		.inlen	= 121,
+		.outlen	= 191,
+		.input	= "\x5d\x8d\xc1\x0d\xc2\x30\x10\x04"
+			  "\x5b\xd9\x0a\xd2\x03\x82\x20\x21"
+			  "\xf1\xf0\x23\x0d\x5c\xec\x0b\xb6"
+			  "\x64\xfb\x2c\xdf\xf1\xa0\x7b\x12"
+			  "\x3e\x58\x79\xae\x76\x67\x76\x89"
+			  "\x49\x11\xc4\xbf\x0b\x57\x43\x60"
+			  "\xf5\x3d\xad\xac\x20\x78\x29\xad"
+			  "\xb3\x6a\x92\x8a\xc2\x16\x25\x60"
+			  "\x25\xe5\x80\x3d\x5b\x64\xdc\xe6"
+			  "\xfb\xf3\xb2\xcc\xe3\x8c\xf2\x4b"
+			  "\x7a\xb2\x58\x26\xe0\x2c\xde\x52"
+			  "\xdd\xb5\x07\x48\xad\xe5\xe4\xc9"
+			  "\x0e\x42\xb6\xd1\xf5\x17\xc0\xe4"
+			  "\x57\x3c\x1c\x1c\x7d\xb2\x50\xc0"
+			  "\x75\x38\x72\x5d\x4c\xbc\xe4\xe9"
+			  "\x0b",
+		.output	= "This document describes a compression method based on the DEFLATE "
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+	}, {
+		.inlen	= 46,
+		.outlen	= 70,
+		.input	= "\x85\xca\xc1\x09\x00\x20\x08\x05"
+			  "\xd0\x55\xfe\x3c\x6e\x21\x64\xd8"
+			  "\x45\x21\x0d\xd7\xb7\x26\xe8\xf8"
+			  "\xe0\x91\x2f\xc3\x09\x98\x17\xd8"
+			  "\x06\x42\x79\x0b\x52\x05\xe1\x33"
+			  "\xeb\x81\x3e\xe5\xa2\x01",
+		.output	= "Join us now and share the software "
+			"Join us now and share the software ",
+	},
+};
+
 /*
  * LZO test vectors (null-terminated strings).
  */
diff --git a/drivers/crypto/intel/iaa/Makefile b/drivers/crypto/intel/iaa/Makefile
index ebfa1a425f80..96f22cd39924 100644
--- a/drivers/crypto/intel/iaa/Makefile
+++ b/drivers/crypto/intel/iaa/Makefile
@@ -7,6 +7,6 @@ ccflags-y += -I $(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE='"CRYPTO_
 
 obj-$(CONFIG_CRYPTO_DEV_IAA_CRYPTO) := iaa_crypto.o
 
-iaa_crypto-y := iaa_crypto_main.o iaa_crypto_comp_fixed.o
+iaa_crypto-y := iaa_crypto_main.o iaa_crypto_comp_fixed.o iaa_crypto_comp_dynamic.o
 
 iaa_crypto-$(CONFIG_CRYPTO_DEV_IAA_CRYPTO_STATS) += iaa_crypto_stats.o
diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index d85a8f1cbb93..e523e4476282 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -19,12 +19,15 @@
 
 #define IAA_COMP_FLUSH_OUTPUT		BIT(1)
 #define IAA_COMP_APPEND_EOB		BIT(2)
+#define IAA_COMP_GEN_HDR_1_PASS		(BIT(12) | BIT(13))
 
 #define IAA_COMPLETION_TIMEOUT		1000000
 
 #define IAA_ALLOC_DESC_COMP_TIMEOUT	   1000
 #define IAA_ALLOC_DESC_DECOMP_TIMEOUT	    500
 
+#define IAA_DYN_ALLOC_DESC_COMP_TIMEOUT	   2000
+
 #define IAA_ANALYTICS_ERROR		0x0a
 #define IAA_ERROR_DECOMP_BUF_OVERFLOW	0x0b
 #define IAA_ERROR_COMP_BUF_OVERFLOW	0x19
@@ -82,7 +85,8 @@ struct iaa_batch_ctx {
 
 enum iaa_mode {
 	IAA_MODE_FIXED = 0,
-	IAA_MODE_NONE = 1,
+	IAA_MODE_DYNAMIC = 1,
+	IAA_MODE_NONE = 2,
 };
 
 struct iaa_req {
@@ -168,6 +172,8 @@ struct aecs_comp_table_record {
 
 int iaa_aecs_init_fixed(void);
 void iaa_aecs_cleanup_fixed(void);
+int iaa_aecs_init_dynamic(void);
+void iaa_aecs_cleanup_dynamic(void);
 
 typedef int (*iaa_dev_comp_init_fn_t) (struct iaa_device_compression_mode *mode);
 typedef int (*iaa_dev_comp_free_fn_t) (struct iaa_device_compression_mode *mode);
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c b/drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
new file mode 100644
index 000000000000..3a93d7913443
--- /dev/null
+++ b/drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Intel Corporation. All rights rsvd. */
+
+#include "idxd.h"
+#include "iaa_crypto.h"
+
+int iaa_aecs_init_dynamic(void)
+{
+	int ret;
+
+	ret = add_iaa_compression_mode("dynamic", NULL, 0, NULL, 0, NULL, NULL);
+
+	if (!ret)
+		pr_debug("IAA dynamic compression mode initialized\n");
+
+	return ret;
+}
+
+void iaa_aecs_cleanup_dynamic(void)
+{
+	remove_iaa_compression_mode("dynamic");
+}
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 7bc4a80bd68b..fe9f59ede577 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -103,10 +103,12 @@ DEFINE_MUTEX(first_wq_found_lock);
 
 const char *iaa_compression_mode_names[IAA_COMP_MODES_MAX] = {
 	"fixed",
+	"dynamic",
 };
 
 const char *iaa_compression_alg_names[IAA_COMP_MODES_MAX] = {
 	"deflate-iaa",
+	"deflate-iaa-dynamic",
 };
 
 static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
@@ -1493,6 +1495,27 @@ static int deflate_generic_decompress(struct iaa_req *req)
 	return ret;
 }
 
+static int deflate_generic_compress(struct iaa_req *req)
+{
+	ACOMP_REQUEST_ON_STACK(fbreq, deflate_crypto_acomp);
+	int ret;
+
+	acomp_request_set_callback(fbreq, 0, NULL, NULL);
+	acomp_request_set_params(fbreq, req->src, req->dst, req->slen,
+				 PAGE_SIZE);
+
+	mutex_lock(&deflate_crypto_acomp_lock);
+
+	ret = crypto_acomp_compress(fbreq);
+	req->dlen = fbreq->dlen;
+
+	mutex_unlock(&deflate_crypto_acomp_lock);
+
+	update_total_sw_comp_calls();
+
+	return ret;
+}
+
 static __always_inline void acomp_to_iaa(struct acomp_req *areq,
 					 struct iaa_req *req,
 					 struct iaa_compression_ctx *ctx)
@@ -1822,9 +1845,13 @@ iaa_setup_compress_hw_desc(struct idxd_desc *idxd_desc,
 	desc->src1_size = slen;
 	desc->dst_addr = (u64)dst_addr;
 	desc->max_dst_size = dlen;
-	desc->flags |= IDXD_OP_FLAG_RD_SRC2_AECS;
-	desc->src2_addr = active_compression_mode->aecs_comp_table_dma_addr;
-	desc->src2_size = sizeof(struct aecs_comp_table_record);
+	if (mode == IAA_MODE_DYNAMIC) {
+		desc->compr_flags |= IAA_COMP_GEN_HDR_1_PASS;
+	} else {
+		desc->flags |= IDXD_OP_FLAG_RD_SRC2_AECS;
+		desc->src2_addr = active_compression_mode->aecs_comp_table_dma_addr;
+		desc->src2_size = sizeof(struct aecs_comp_table_record);
+	}
 	desc->completion_addr = idxd_desc->compl_dma;
 
 	return desc;
@@ -2078,6 +2105,9 @@ static int iaa_comp_acompress(struct iaa_compression_ctx *ctx, struct iaa_req *r
 		return -EINVAL;
 	}
 
+	if (ctx->mode == IAA_MODE_DYNAMIC && req->slen > PAGE_SIZE)
+		return deflate_generic_compress(req);
+
 	cpu = get_cpu();
 	wq = comp_wq_table_next_wq(cpu);
 	put_cpu();
@@ -2513,7 +2543,9 @@ static int __maybe_unused iaa_comp_adecompress_batch(
 static void compression_ctx_init(struct iaa_compression_ctx *ctx, enum iaa_mode mode)
 {
 	ctx->mode = mode;
-	ctx->alloc_comp_desc_timeout = IAA_ALLOC_DESC_COMP_TIMEOUT;
+	ctx->alloc_comp_desc_timeout = (mode == IAA_MODE_DYNAMIC ?
+					IAA_DYN_ALLOC_DESC_COMP_TIMEOUT :
+					IAA_ALLOC_DESC_COMP_TIMEOUT);
 	ctx->alloc_decomp_desc_timeout = IAA_ALLOC_DESC_DECOMP_TIMEOUT;
 	ctx->verify_compress = iaa_verify_compress;
 	ctx->async_mode = async_mode;
@@ -2708,6 +2740,32 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	}
 };
 
+static int iaa_crypto_acomp_init_dynamic(struct crypto_acomp *acomp_tfm)
+{
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
+	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx = iaa_ctx[IAA_MODE_DYNAMIC];
+
+	return 0;
+}
+
+static struct acomp_alg iaa_acomp_dynamic_deflate = {
+	.init			= iaa_crypto_acomp_init_dynamic,
+	.compress		= iaa_crypto_acomp_acompress_main,
+	.decompress		= iaa_crypto_acomp_adecompress_main,
+	.batch_completed	= iaa_crypto_acomp_batch_completed,
+	.base			= {
+		.cra_name		= "deflate",
+		.cra_driver_name	= "deflate-iaa-dynamic",
+		.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_SEG,
+		.cra_ctxsize		= sizeof(struct iaa_compression_ctx),
+		.cra_reqsize		= sizeof(u32),
+		.cra_module		= THIS_MODULE,
+		.cra_priority		= IAA_ALG_PRIORITY + 1,
+	}
+};
+
 /*******************************************
  * Implement idxd_device_driver interfaces.
  *******************************************/
@@ -2727,7 +2785,7 @@ static void iaa_unregister_compression_device(void)
 	num_iaa_modes_registered = 0;
 }
 
-static int iaa_register_compression_device(void)
+static int iaa_register_compression_device(struct idxd_device *idxd)
 {
 	struct iaa_compression_mode *mode;
 	int i, idx;
@@ -2736,6 +2794,13 @@ static int iaa_register_compression_device(void)
 		iaa_mode_registered[i] = false;
 		mode = find_iaa_compression_mode(iaa_compression_mode_names[i], &idx);
 		if (mode) {
+			/* Header Generation Capability is required for the dynamic algorithm. */
+			if ((!strcmp(mode->name, "dynamic")) && !idxd->hw.iaa_cap.header_gen) {
+				if (num_iaa_modes_registered > 0)
+					--num_iaa_modes_registered;
+				continue;
+			}
+
 			iaa_ctx[i] = kmalloc(sizeof(struct iaa_compression_ctx), GFP_KERNEL);
 			if (!iaa_ctx[i])
 				goto err;
@@ -2755,7 +2820,7 @@ static int iaa_register_compression_device(void)
 	return -ENODEV;
 }
 
-static int iaa_register_acomp_compression_device(void)
+static int iaa_register_acomp_compression_device(struct idxd_device *idxd)
 {
 	int ret = -ENOMEM;
 
@@ -2765,8 +2830,19 @@ static int iaa_register_acomp_compression_device(void)
 		goto err_fixed;
 	}
 
+	if (iaa_mode_registered[IAA_MODE_DYNAMIC]) {
+		ret = crypto_register_acomp(&iaa_acomp_dynamic_deflate);
+		if (ret) {
+			pr_err("deflate algorithm acomp dynamic registration failed (%d)\n", ret);
+			goto err_dynamic;
+		}
+	}
+
 	return 0;
 
+err_dynamic:
+	crypto_unregister_acomp(&iaa_acomp_fixed_deflate);
+
 err_fixed:
 	iaa_unregister_compression_device();
 	return ret;
@@ -2778,6 +2854,9 @@ static void iaa_unregister_acomp_compression_device(void)
 
 	if (iaa_mode_registered[IAA_MODE_FIXED])
 		crypto_unregister_acomp(&iaa_acomp_fixed_deflate);
+
+	if (iaa_mode_registered[IAA_MODE_DYNAMIC])
+		crypto_unregister_acomp(&iaa_acomp_dynamic_deflate);
 }
 
 static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
@@ -2841,13 +2920,13 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 	atomic_set(&iaa_crypto_enabled, 1);
 
 	if (first_wq) {
-		ret = iaa_register_compression_device();
+		ret = iaa_register_compression_device(idxd);
 		if (ret != 0) {
 			dev_dbg(dev, "IAA compression device registration failed\n");
 			goto err_register;
 		}
 
-		ret = iaa_register_acomp_compression_device();
+		ret = iaa_register_acomp_compression_device(idxd);
 		if (ret != 0) {
 			dev_dbg(dev, "IAA compression device acomp registration failed\n");
 			goto err_register;
@@ -3007,6 +3086,12 @@ static int __init iaa_crypto_init_module(void)
 		goto err_aecs_init;
 	}
 
+	ret = iaa_aecs_init_dynamic();
+	if (ret < 0) {
+		pr_debug("IAA dynamic compression mode init failed\n");
+		goto err_dynamic;
+	}
+
 	ret = idxd_driver_register(&iaa_crypto_driver);
 	if (ret) {
 		pr_debug("IAA wq sub-driver registration failed\n");
@@ -3110,6 +3195,8 @@ static int __init iaa_crypto_init_module(void)
 err_g_comp_wqs_per_iaa_attr_create:
 	idxd_driver_unregister(&iaa_crypto_driver);
 err_driver_reg:
+	iaa_aecs_cleanup_dynamic();
+err_dynamic:
 	iaa_aecs_cleanup_fixed();
 err_aecs_init:
 	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
@@ -3139,6 +3226,7 @@ static void __exit iaa_crypto_cleanup_module(void)
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_g_comp_wqs_per_iaa);
 	idxd_driver_unregister(&iaa_crypto_driver);
+	iaa_aecs_cleanup_dynamic();
 	iaa_aecs_cleanup_fixed();
 
 	if (!IS_ERR_OR_NULL(deflate_crypto_acomp)) {
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_stats.c b/drivers/crypto/intel/iaa/iaa_crypto_stats.c
index f5cc3d29ca19..42aae8a738ac 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_stats.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_stats.c
@@ -19,6 +19,7 @@
 
 static atomic64_t total_comp_calls;
 static atomic64_t total_decomp_calls;
+static atomic64_t total_sw_comp_calls;
 static atomic64_t total_sw_decomp_calls;
 static atomic64_t total_comp_bytes_out;
 static atomic64_t total_decomp_bytes_in;
@@ -43,6 +44,11 @@ void update_total_decomp_calls(void)
 	atomic64_inc(&total_decomp_calls);
 }
 
+void update_total_sw_comp_calls(void)
+{
+	atomic64_inc(&total_sw_comp_calls);
+}
+
 void update_total_sw_decomp_calls(void)
 {
 	atomic64_inc(&total_sw_decomp_calls);
@@ -174,6 +180,8 @@ static int global_stats_show(struct seq_file *m, void *v)
 		   atomic64_read(&total_comp_calls));
 	seq_printf(m, "  total_decomp_calls: %llu\n",
 		   atomic64_read(&total_decomp_calls));
+	seq_printf(m, "  total_sw_comp_calls: %llu\n",
+		   atomic64_read(&total_sw_comp_calls));
 	seq_printf(m, "  total_sw_decomp_calls: %llu\n",
 		   atomic64_read(&total_sw_decomp_calls));
 	seq_printf(m, "  total_comp_bytes_out: %llu\n",
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_stats.h b/drivers/crypto/intel/iaa/iaa_crypto_stats.h
index 3787a5f507eb..6e0c6f9939bf 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_stats.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto_stats.h
@@ -11,6 +11,7 @@ void	iaa_crypto_debugfs_cleanup(void);
 void	update_total_comp_calls(void);
 void	update_total_comp_bytes_out(int n);
 void	update_total_decomp_calls(void);
+void	update_total_sw_comp_calls(void);
 void	update_total_sw_decomp_calls(void);
 void	update_total_decomp_bytes_in(int n);
 void	update_completion_einval_errs(void);
@@ -29,6 +30,7 @@ static inline void	iaa_crypto_debugfs_cleanup(void) {}
 static inline void	update_total_comp_calls(void) {}
 static inline void	update_total_comp_bytes_out(int n) {}
 static inline void	update_total_decomp_calls(void) {}
+static inline void	update_total_sw_comp_calls(void) {}
 static inline void	update_total_sw_decomp_calls(void) {}
 static inline void	update_total_decomp_bytes_in(int n) {}
 static inline void	update_completion_einval_errs(void) {}
-- 
2.27.0


Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F9128EC75
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jan 2025 10:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736852170; cv=none; b=YtJn2eLP88j8jbFR5ze6qCMyVDvdyzIedPF0RpAn30UyJQDdEOz9qVqs7q7JbGZUNOP0E0FxA4QjrsfqA8CKcj21ArsF3txqLRbY2zIiKiszicps3rdwr4bDPgKo7FxxDggdmukNf2YY64B/W8hrt2fFm2mI6XStf3gg43qFUyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736852170; c=relaxed/simple;
	bh=5iLy2hS7XOaApDudXBmJDbTDRFkhrr67i5YCTiK8Olo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AcIG/L0AUc8PtptcSzX3M89GfeX75XWaWahVJqQMtgSCCMNKWP8Skb5YnBggS8DaT2a0ayOlUy/lH7IkKktQ9owsNbT9EdFIths3FWOTuumoFOV1YCHBBrh6n1QmXFsHoaGX6pKe8XkdGG2n191DG6pjBxW8BbbrnXxKLEQvfFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YyOJGFB7; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YyOJGFB7"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa6b7f3c6edso82961266b.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jan 2025 02:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736852167; x=1737456967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8MfSYP+zHL+pnuiJhgBQ6vL5nCjPi7bURf1tspTScy8=;
        b=YyOJGFB7i58IkC0skJ+dc7y87kf+uvEMjAXKNvlvJnA7mTYw5gLnO3QjjaxyG6FFDq
         kO7NjGzyBBO+qv+sawqLtOALAAjh+AhBf4ph2d43nFG1ApY8N0gxOYMF+DwdqoFcK9f/
         hlXuYuQtZ1jwdTK+1D9D1NtBGTfKEJ8Lp5IzarDKYClBoxg+vr9O8ydLKo+LbxlyRpDH
         0rW+YxnUDTLROFUYUsW7iR3S4JZP7pw1HEU1gn5VLVkEfxgworeDGSiiSHaiuyzSOasn
         XP4+Alov0HFK1DwUtNy5gf+UYy7Ka/vA8hUfFf2VraRUeCrw1DwniM/6f0GfyF0KG8mX
         066w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736852167; x=1737456967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8MfSYP+zHL+pnuiJhgBQ6vL5nCjPi7bURf1tspTScy8=;
        b=anFcRKGSo+Eh8bT5nNx4nIYPPb2UcvwXU2rGE96p25BzUJRDPx7TIQZl0UeaxqlXGB
         sfE5It2BebqXOV1hoSJLR6X2BRlnp/cyxFE1x7FqDAsS9sBSTya5kAExpF3seexU5BVv
         irLia7Vg/B2LI2F8Bz4/FYFvm/gYkfFAh9NZN4RG7j+9l218mKU5xm0OedTUrlD566j/
         o47C6VypPStTB0VLe3quEDJg4fqTYzDQ1XL5l+nQAI+AyPY5tUuIzVBA1/vpgo+VpV8U
         xBnL4a/+F15On23yQnKrjGhxfXAPdBS3srckkN4nTmCs74nwYFLI6S/2GQBuibbk79vw
         xxgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmfOIOblp04nqnOW2s4VHKmGemOiL0dBwJ3e5o0DZYdToREenw8yNjrOC7VYoPOtKYnjPdSSWh+dqXb0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRWKFJdebCcwharVH7DU5VmJh0dv8qecsauHVxIn6GtBSqJYWk
	8hlTpBIaTMYEDBwN4mMqMr2FakKC0MZtgcSx1G7RrRADbwJ3mjd/rzWGjWNRRng=
X-Gm-Gg: ASbGncvAfrr+aSi0nrXYISqChHY41GlauhXklRStGEaHsp2HLKN8f3/OIDdmjBTSDVS
	46Yu9Ka0LXWYqsHFFHYzFz1slpsycXBmmfd66W+42trt2rOeM8EJjyThGYxjKPlW/Q1PaofymCg
	K0gGVq434tzPEewf2jN0TmR+FGhpxbuTLrcn7PQUOfwi/BkdTfnDHm419g6XVsQXGNNexScz1X6
	asR1jBFJV9hnvIxre5GARKwvSKUcEYXxYdpeVT8xQrqQJR+jgOc3aodQHZJD8cwK4/0Z/g=
X-Google-Smtp-Source: AGHT+IEGacWavSt1ZemW96X2/5CF52o/Rb8UF/rMn9Kj0ERefG3jnd1ifdAhMXGxA87TqYevuWfBVA==
X-Received: by 2002:a17:907:3f95:b0:aae:b259:ef5c with SMTP id a640c23a62f3a-ab2aad0b170mr894511266b.0.1736852166981;
        Tue, 14 Jan 2025 02:56:06 -0800 (PST)
Received: from krzk-bin.. ([178.197.223.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c913804esm610170966b.84.2025.01.14.02.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 02:56:06 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] crypto: Use str_enable_disable-like helpers
Date: Tue, 14 Jan 2025 11:56:03 +0100
Message-ID: <20250114105603.273161-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace ternary (condition ? "enable" : "disable") syntax with helpers
from string_choices.h because:
1. Simple function call with one argument is easier to read.  Ternary
   operator has three arguments and with wrapping might lead to quite
   long code.
2. Is slightly shorter thus also easier to read.
3. It brings uniformity in the text - same string.
4. Allows deduping by the linker, which results in a smaller binary
   file.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/crypto/bcm/cipher.c                         |  3 ++-
 drivers/crypto/bcm/spu2.c                           |  3 ++-
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c     | 10 +++-------
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c   |  5 +++--
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c |  3 ++-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 9e6798efbfb7..66accd8e08f6 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -15,6 +15,7 @@
 #include <linux/kthread.h>
 #include <linux/rtnetlink.h>
 #include <linux/sched.h>
+#include <linux/string_choices.h>
 #include <linux/of.h>
 #include <linux/io.h>
 #include <linux/bitops.h>
@@ -2687,7 +2688,7 @@ static int aead_enqueue(struct aead_request *req, bool is_encrypt)
 	flow_log("  iv_ctr_len:%u\n", rctx->iv_ctr_len);
 	flow_dump("  iv: ", req->iv, rctx->iv_ctr_len);
 	flow_log("  authkeylen:%u\n", ctx->authkeylen);
-	flow_log("  is_esp: %s\n", ctx->is_esp ? "yes" : "no");
+	flow_log("  is_esp: %s\n", str_yes_no(ctx->is_esp));
 
 	if (ctx->max_payload == SPU_MAX_PAYLOAD_INF)
 		flow_log("  max_payload infinite");
diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
index 3fdc64b5a65e..ce322cf1baa5 100644
--- a/drivers/crypto/bcm/spu2.c
+++ b/drivers/crypto/bcm/spu2.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 
 #include "util.h"
 #include "spu.h"
@@ -999,7 +1000,7 @@ u32 spu2_create_request(u8 *spu_hdr,
 		 req_opts->is_inbound, req_opts->auth_first);
 	flow_log("  cipher alg:%u mode:%u type %u\n", cipher_parms->alg,
 		 cipher_parms->mode, cipher_parms->type);
-	flow_log("  is_esp: %s\n", req_opts->is_esp ? "yes" : "no");
+	flow_log("  is_esp: %s\n", str_yes_no(req_opts->is_esp));
 	flow_log("    key: %d\n", cipher_parms->key_len);
 	flow_dump("    key: ", cipher_parms->key_buf, cipher_parms->key_len);
 	flow_log("    iv: %d\n", cipher_parms->iv_len);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 4fcd61ff70d1..84450bffacb6 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -3,6 +3,7 @@
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/pci.h>
+#include <linux/string_choices.h>
 #include "adf_accel_devices.h"
 #include "adf_cfg.h"
 #include "adf_cfg_services.h"
@@ -19,14 +20,12 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
 	struct adf_accel_dev *accel_dev;
-	char *state;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
 		return -EINVAL;
 
-	state = adf_dev_started(accel_dev) ? "up" : "down";
-	return sysfs_emit(buf, "%s\n", state);
+	return sysfs_emit(buf, "%s\n", str_up_down(adf_dev_started(accel_dev)));
 }
 
 static ssize_t state_store(struct device *dev, struct device_attribute *attr,
@@ -207,16 +206,13 @@ static DEVICE_ATTR_RW(pm_idle_enabled);
 static ssize_t auto_reset_show(struct device *dev, struct device_attribute *attr,
 			       char *buf)
 {
-	char *auto_reset;
 	struct adf_accel_dev *accel_dev;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
 		return -EINVAL;
 
-	auto_reset = accel_dev->autoreset_on_error ? "on" : "off";
-
-	return sysfs_emit(buf, "%s\n", auto_reset);
+	return sysfs_emit(buf, "%s\n", str_on_off(accel_dev->autoreset_on_error));
 }
 
 static ssize_t auto_reset_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index c4250e5fcf8f..2c08e928e44e 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -10,6 +10,7 @@
 
 #include <linux/ctype.h>
 #include <linux/firmware.h>
+#include <linux/string_choices.h>
 #include "otx_cpt_common.h"
 #include "otx_cptpf_ucode.h"
 #include "otx_cptpf.h"
@@ -614,8 +615,8 @@ static void print_dbg_info(struct device *dev,
 
 	for (i = 0; i < OTX_CPT_MAX_ENGINE_GROUPS; i++) {
 		grp = &eng_grps->grp[i];
-		pr_debug("engine_group%d, state %s\n", i, grp->is_enabled ?
-			 "enabled" : "disabled");
+		pr_debug("engine_group%d, state %s\n", i,
+			 str_enabled_disabled(grp->is_enabled));
 		if (grp->is_enabled) {
 			mirrored_grp = &eng_grps->grp[grp->mirror.idx];
 			pr_debug("Ucode0 filename %s, version %s\n",
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 5c9484646172..881fce53e369 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -3,6 +3,7 @@
 
 #include <linux/ctype.h>
 #include <linux/firmware.h>
+#include <linux/string_choices.h>
 #include "otx2_cptpf_ucode.h"
 #include "otx2_cpt_common.h"
 #include "otx2_cptpf.h"
@@ -1835,7 +1836,7 @@ void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf)
 	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
 		grp = &eng_grps->grp[i];
 		pr_debug("engine_group%d, state %s", i,
-			 grp->is_enabled ? "enabled" : "disabled");
+			 str_enabled_disabled(grp->is_enabled));
 		if (grp->is_enabled) {
 			mirrored_grp = &eng_grps->grp[grp->mirror.idx];
 			pr_debug("Ucode0 filename %s, version %s",
-- 
2.43.0


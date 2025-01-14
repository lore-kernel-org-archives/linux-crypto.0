Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FCA1917ED
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jan 2025 19:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736881510; cv=none; b=ILnc4s7gePqI8mGOrAa2wLRYnhBB1RSDp0B2qbk4/46VEA9C7KnHvMP6xcuDKhM30eqrrKgXzTNPWBpdnJbou9we6prTdawKYa2wROkWFKs+TE6hj/f8srMwvbai0sGr7z/qyFkyPymZsoXqadfL1vYN+w1igPhXxILxJOqVlAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736881510; c=relaxed/simple;
	bh=HeRl+Mw7tceb/euVai+aqjx7K4xy6ikDU/7JeNoHNMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pioGnxfl80sxz2nJjxqMQGtEbHsCHHLWE1Kb9ol25YU250UX24ASivT6PiCmq7xDb/NRou1/89oOX5+Fqu4SnGIv48CKJ+XI3zX2bDQ/xDor+AsNckE0B6Sol03Cy59iRn1uN1IuRjwaOfh6gbw4Msg0x79c+JhAGBjCyquWkVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KXqLOjhX; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KXqLOjhX"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43658c452f5so5222785e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jan 2025 11:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736881506; x=1737486306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sMBMmWVpF9fptO6Lirx4P3O6/KKexb57HvZcegkfEso=;
        b=KXqLOjhXLjrze2xjRDIf0jW0olm1sIzvXjYNTkTvcyEE2R+Kcr1BiKty4gHKAYZLzb
         iV1twXmp4wwQsusxov9Xdttp8WZ5cKi4srGTm+kOS02r94KEGzh56PmeoG01kiW8TrWI
         ybB5cN7520oyOdL8ji0ZdNaqBipll0wgydQogESJP8uRpZemy2QdLLd9VDmZmmanpVSj
         zw72i7Nf3c3gFZODqmbfj5ZFe0TXuu5MYvXVjAuSPPXbNMFeZ7t4CFgS5g4tF5cYCti3
         2AoCIXN2T/jBFu/EpxwbmSXJoPl7PcZiAJ9ziRJ5KwdEK2FL89sQ1mjshNGoI++BB3J2
         0IPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736881506; x=1737486306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sMBMmWVpF9fptO6Lirx4P3O6/KKexb57HvZcegkfEso=;
        b=j9+Eh8vqrRcjPWn7IFDHWBllPx34mjB6Wuk9Fg68nDu4c+L7vidfJYskyLWl/g8a01
         Ck26pUf8VgeMwpm/fFfsi0jA/kUcN6oeEG8TJUazFIagKDLY/qOHrzN7ci76Z4TaRUJo
         27vIkiHx8EjaPX+xAsnZKsmnLGm+hq9MmKdGo7+kppuPb+OR/O7Kd1MVXkDXn7dsc7dW
         Rx1RA5l78Mx/9iKAeerwpusWt0y0QjXnQEfYfmRlfgsWXEP7uq9fW2upkXi+zT5xROlI
         ZrodcYLJhQUKEEbdheFz/uuV139RCqpK+uym9mFqTFOOogwEGFTtbvjOb6I0lsOzMaSj
         tELA==
X-Forwarded-Encrypted: i=1; AJvYcCWcxvZgwvsXgzMqDkVhBakp/HWhLhxarJtl/v2gM50Rgy6L4C4RL+8+AjBJTytWel6e0AuETJY7mZoMg5g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4mMhi7NnO8f7xrwyKfO6ExkAayLKYqjt9zoHwvBcJSnIKeRhC
	gRaCOCB/hOtdoLD3PUwkfmQuX6ExasXNn/hC69A9S+jqXhMPm/3mAo2ly7r9WwU=
X-Gm-Gg: ASbGnctCmVNa+hL297VEFOedh4Kd4GjpDjsMuPYnSypyRTN6pfDEbKBzQ6kNCsqZ9QM
	NUxwmZLQ1YLeuRTCV8J4NWyLO6rKOmJFm8lCGsqlUTPzWast8B1qLxPqC518hdTRzDESnu3WW68
	sCdgxDngr0hmt+Hq/tdIiss4GgLiQhJwI86VQ3bFYA30v0FZ8/B8nTeDhlFsKM4e2X8vIgLkHVN
	uihpz4JQTZdwp1oqrIFXzaKlmUjBjkaQODnv6/dOH3IFNQJUaGaNKEPcuqEVWLFkxI+z8w=
X-Google-Smtp-Source: AGHT+IEzglACF4jdJRf0Vrfj22Sc58iI9Kip2UcDkOjqNM6+1R7TxSojD0BIZMpfvSAoDc8OhCwyzA==
X-Received: by 2002:a05:600c:35c2:b0:434:941c:9df2 with SMTP id 5b1f17b1804b1-436e272c89cmr93763995e9.8.1736881506465;
        Tue, 14 Jan 2025 11:05:06 -0800 (PST)
Received: from krzk-bin.. ([178.197.223.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2e89dfesm221252045e9.32.2025.01.14.11.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 11:05:05 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2] crypto: Use str_enable_disable-like helpers
Date: Tue, 14 Jan 2025 20:05:01 +0100
Message-ID: <20250114190501.846315-1-krzysztof.kozlowski@linaro.org>
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

Changes in v2:
1. Also: drivers/crypto/caam/caamalg_qi2.c
---
 drivers/crypto/bcm/cipher.c                         |  3 ++-
 drivers/crypto/bcm/spu2.c                           |  3 ++-
 drivers/crypto/caam/caamalg_qi2.c                   |  3 ++-
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c     | 10 +++-------
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c   |  5 +++--
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c |  3 ++-
 6 files changed, 14 insertions(+), 13 deletions(-)

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
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index e809d030ab11..107ccb2ade42 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/fsl/mc.h>
 #include <linux/kernel.h>
+#include <linux/string_choices.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
 #include <crypto/xts.h>
@@ -5175,7 +5176,7 @@ static int __cold dpaa2_dpseci_disable(struct dpaa2_caam_priv *priv)
 		return err;
 	}
 
-	dev_dbg(dev, "disable: %s\n", enabled ? "false" : "true");
+	dev_dbg(dev, "disable: %s\n", str_false_true(enabled));
 
 	for (i = 0; i < priv->num_pairs; i++) {
 		ppriv = per_cpu_ptr(priv->ppriv, i);
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


From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: cavium - add release_firmware to all return case
Date: Mon, 14 Aug 2017 13:58:54 +0200
Message-ID: <20170814115854.19495-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: george.cherian@cavium.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33017 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752943AbdHNMBH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 08:01:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Two return case misses to call release_firmware() and so leak some
memory.

This patch create a fw_release label (and so a common error path)
and use it on all return case.

Detected by CoverityScan, CID#1416422 ("Resource Leak")

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 4119c40e7c4b..34a6d8bf229e 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -268,8 +268,10 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	mcode = &cpt->mcode[cpt->next_mc_idx];
 	memcpy(mcode->version, (u8 *)fw_entry->data, CPT_UCODE_VERSION_SZ);
 	mcode->code_size = ntohl(ucode->code_length) * 2;
-	if (!mcode->code_size)
-		return -EINVAL;
+	if (!mcode->code_size) {
+		ret = -EINVAL;
+		goto fw_release;
+	}
 
 	mcode->is_ae = is_ae;
 	mcode->core_mask = 0ULL;
@@ -280,7 +282,8 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 					  &mcode->phys_base, GFP_KERNEL);
 	if (!mcode->code) {
 		dev_err(dev, "Unable to allocate space for microcode");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto fw_release;
 	}
 
 	memcpy((void *)mcode->code, (void *)(fw_entry->data + sizeof(*ucode)),
@@ -302,12 +305,14 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	ret = do_cpt_init(cpt, mcode);
 	if (ret) {
 		dev_err(dev, "do_cpt_init failed with ret: %d\n", ret);
-		return ret;
+		goto fw_release;
 	}
 
 	dev_info(dev, "Microcode Loaded %s\n", mcode->version);
 	mcode->is_mc_valid = 1;
 	cpt->next_mc_idx++;
+
+fw_release:
 	release_firmware(fw_entry);
 
 	return ret;
-- 
2.13.0

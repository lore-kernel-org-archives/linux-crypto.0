Return-Path: <SRS0=9uPW=NC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49626 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbeJVPyf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Oct 2018 11:54:35 -0400
Message-ID: <1540193831.3202.11.camel@HansenPartnership.com>
Subject: [PATCH v4 3/7] tpm2: add hmac checks to tpm2_pcr_extend()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-integrity@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 22 Oct 2018 08:37:11 +0100
In-Reply-To: <1540193596.3202.7.camel@HansenPartnership.com>
References: <1540193596.3202.7.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We use tpm2_pcr_extend() in trusted keys to extend a PCR to prevent a
key from being re-loaded until the next reboot.  To use this
functionality securely, that extend must be protected by a session
hmac.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

v3: add error handling to sessions
---
 drivers/char/tpm/tpm2-cmd.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index a17e5c573c4e..332b34b347f1 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -209,13 +209,6 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 	return rc;
 }
 
-struct tpm2_null_auth_area {
-	__be32  handle;
-	__be16  nonce_size;
-	u8  attributes;
-	__be16  auth_size;
-} __packed;
-
 /**
  * tpm2_pcr_extend() - extend a PCR value
  *
@@ -230,7 +223,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
 		    struct tpm2_digest *digests)
 {
 	struct tpm_buf buf;
-	struct tpm2_null_auth_area auth_area;
+	struct tpm2_auth *auth;
 	int rc;
 	int i;
 	int j;
@@ -238,20 +231,19 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
 	if (count > ARRAY_SIZE(chip->active_banks))
 		return -EINVAL;
 
-	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_PCR_EXTEND);
+	rc = tpm2_start_auth_session(chip, &auth);
 	if (rc)
 		return rc;
 
-	tpm_buf_append_u32(&buf, pcr_idx);
+	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_PCR_EXTEND);
+	if (rc) {
+		tpm2_end_auth_session(auth);
+		return rc;
+	}
 
-	auth_area.handle = cpu_to_be32(TPM2_RS_PW);
-	auth_area.nonce_size = 0;
-	auth_area.attributes = 0;
-	auth_area.auth_size = 0;
+	tpm_buf_append_name(&buf, auth, pcr_idx, NULL);
+	tpm_buf_append_hmac_session(&buf, auth, 0, NULL, 0);
 
-	tpm_buf_append_u32(&buf, sizeof(struct tpm2_null_auth_area));
-	tpm_buf_append(&buf, (const unsigned char *)&auth_area,
-		       sizeof(auth_area));
 	tpm_buf_append_u32(&buf, count);
 
 	for (i = 0; i < count; i++) {
@@ -264,9 +256,10 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
 			       hash_digest_size[tpm2_hash_map[j].crypto_id]);
 		}
 	}
-
-	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, 0,
-			      "attempting extend a PCR value");
+	tpm_buf_fill_hmac_session(&buf, auth);
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
+			      0, 0, "attempting extend a PCR value");
+	rc = tpm_buf_check_hmac_response(&buf, auth, rc);
 
 	tpm_buf_destroy(&buf);
 
-- 
2.16.4

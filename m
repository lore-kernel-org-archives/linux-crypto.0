Return-Path: <SRS0=9uPW=NC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49652 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbeJVPzU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Oct 2018 11:55:20 -0400
Message-ID: <1540193875.3202.12.camel@HansenPartnership.com>
Subject: [PATCH v4 4/7] tpm2: add session encryption protection to
 tpm2_get_random()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-integrity@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 22 Oct 2018 08:37:55 +0100
In-Reply-To: <1540193596.3202.7.camel@HansenPartnership.com>
References: <1540193596.3202.7.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If some entity is snooping the TPM bus, they can see the random
numbers we're extracting from the TPM and do prediction attacks
against their consumers.  Foil this attack by using response
encryption to prevent the attacker from seeing the random sequence.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

v3: add error handling to sessions and redo to be outside loop
---
 drivers/char/tpm/tpm2-cmd.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 332b34b347f1..22f1c7bee173 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -266,7 +266,6 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
 	return rc;
 }
 
-
 struct tpm2_get_random_out {
 	__be16 size;
 	u8 buffer[TPM_MAX_RNG_DATA];
@@ -293,21 +292,32 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *dest, size_t max)
 	int total = 0;
 	int retries = 5;
 	u8 *dest_ptr = dest;
+	struct tpm2_auth *auth;
 
 	if (!num_bytes || max > TPM_MAX_RNG_DATA)
 		return -EINVAL;
 
-	err = tpm_buf_init(&buf, 0, 0);
+	err = tpm2_start_auth_session(chip, &auth);
 	if (err)
 		return err;
 
+	err = tpm_buf_init(&buf, 0, 0);
+	if (err) {
+		tpm2_end_auth_session(auth);
+		return err;
+	}
+
 	do {
-		tpm_buf_reset(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_RANDOM);
+		tpm_buf_reset(&buf, TPM2_ST_SESSIONS, TPM2_CC_GET_RANDOM);
+		tpm_buf_append_hmac_session(&buf, auth, TPM2_SA_ENCRYPT
+					    | TPM2_SA_CONTINUE_SESSION,
+					    NULL, 0);
 		tpm_buf_append_u16(&buf, num_bytes);
-		err = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
-				       offsetof(struct tpm2_get_random_out,
-						buffer),
+		tpm_buf_fill_hmac_session(&buf, auth);
+		err = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data,
+				       PAGE_SIZE, TPM_HEADER_SIZE + 2,
 				       0, "attempting get random");
+		err = tpm_buf_check_hmac_response(&buf, auth, err);
 		if (err)
 			goto out;
 
@@ -327,6 +337,8 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *dest, size_t max)
 	} while (retries-- && total < max);
 
 	tpm_buf_destroy(&buf);
+	tpm2_end_auth_session(auth);
+
 	return total ? total : -EIO;
 out:
 	tpm_buf_destroy(&buf);
-- 
2.16.4

Return-Path: <SRS0=9uPW=NC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49744 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727689AbeJVP6H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Oct 2018 11:58:07 -0400
Message-ID: <1540194042.3202.16.camel@HansenPartnership.com>
Subject: [PATCH v4 7/7] tpm2-sessions: NOT FOR COMMITTING add sessions
 testing
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-integrity@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 22 Oct 2018 08:40:42 +0100
In-Reply-To: <1540193596.3202.7.camel@HansenPartnership.com>
References: <1540193596.3202.7.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This runs through a preset sequence using sessions to demonstrate that
the session handling code functions.  It does both HMAC, encryption
and decryption by testing an encrypted sealing operation with
authority and proving that the same sealed data comes back again via
an HMAC and response encryption.  It also does policy unsealing which
mimics the more complex of the trusted key scenarios.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---
v3: add policy unseal testing with two sessions
---
 drivers/char/tpm/Makefile             |   1 +
 drivers/char/tpm/tpm-chip.c           |   1 +
 drivers/char/tpm/tpm.h                |   1 +
 drivers/char/tpm/tpm2-cmd.c           |   2 +
 drivers/char/tpm/tpm2-sessions-test.c | 360 ++++++++++++++++++++++++++++++++++
 5 files changed, 365 insertions(+)
 create mode 100644 drivers/char/tpm/tpm2-sessions-test.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 1b5f6ccbb86d..b3f5e95679f9 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
 	 tpm-dev-common.o tpmrm-dev.o eventlog/common.o eventlog/tpm1.o \
 	 eventlog/tpm2.o tpm2-space.o tpm-buf.o tpm2-sessions.o
+obj-m +=  tpm2-sessions-test.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o eventlog/acpi.o
 tpm-$(CONFIG_EFI) += eventlog/efi.o
 tpm-$(CONFIG_OF) += eventlog/of.o
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 46caadca916a..ef7ff32bf827 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -142,6 +142,7 @@ struct tpm_chip *tpm_find_get_ops(struct tpm_chip *chip)
 		return NULL;
 	return chip;
 }
+EXPORT_SYMBOL(tpm_find_get_ops);
 
 /**
  * tpm_dev_release() - free chip memory and the device number
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index d39065d9995d..8cb8b32a8418 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -163,6 +163,7 @@ enum tpm2_command_codes {
 	TPM2_CC_CONTEXT_LOAD	= 0x0161,
 	TPM2_CC_CONTEXT_SAVE	= 0x0162,
 	TPM2_CC_FLUSH_CONTEXT	= 0x0165,
+	TPM2_CC_POLICY_COMMAND_CODE = 0x16c,
 	TPM2_CC_READ_PUBLIC	= 0x0173,
 	TPM2_CC_START_AUTH_SESS	= 0x0176,
 	TPM2_CC_GET_CAPABILITY	= 0x017A,
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index a8655cd535d1..7afe0f50dcce 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -379,6 +379,7 @@ void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
 
 	tpm_buf_destroy(&buf);
 }
+EXPORT_SYMBOL_GPL(tpm2_flush_context_cmd);
 
 /**
  * tpm_buf_append_auth() - append TPMS_AUTH_COMMAND to the buffer.
@@ -409,6 +410,7 @@ void tpm2_buf_append_auth(struct tpm_buf *buf, u32 session_handle,
 	if (hmac && hmac_len)
 		tpm_buf_append(buf, hmac, hmac_len);
 }
+EXPORT_SYMBOL_GPL(tpm2_buf_append_auth);
 
 /**
  * tpm2_seal_trusted() - seal the payload of a trusted key
diff --git a/drivers/char/tpm/tpm2-sessions-test.c b/drivers/char/tpm/tpm2-sessions-test.c
new file mode 100644
index 000000000000..7b4a01ad3745
--- /dev/null
+++ b/drivers/char/tpm/tpm2-sessions-test.c
@@ -0,0 +1,360 @@
+/* run a set of tests of the sessions code */
+#include "tpm.h"
+#include "tpm2-sessions.h"
+
+#include <linux/random.h>
+
+#include <asm/unaligned.h>
+
+/* simple policy: command code must be TPM2_CC_UNSEAL */
+static u8 policy[] = {
+	0xe6, 0x13, 0x13, 0x70, 0x76, 0x52, 0x4b, 0xde,
+	0x48, 0x75, 0x33, 0x86, 0x58, 0x84, 0xe9, 0x73,
+	0x2e, 0xbe, 0xe3, 0xaa, 0xcb, 0x09, 0x5d, 0x94,
+	0xa6, 0xde, 0x49, 0x2e, 0xc0, 0x6c, 0x46, 0xfa,
+};
+
+static u32 get_policy(struct tpm_chip *chip)
+{
+	struct tpm_buf buf;
+	u8 nonce[SHA256_DIGEST_SIZE];
+	u32 h;
+	int rc;
+
+	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_START_AUTH_SESS);
+	if (rc)
+		return 0;
+
+	/* salt key */
+	tpm_buf_append_u32(&buf, TPM2_RH_NULL);
+	/* bind key */
+	tpm_buf_append_u32(&buf, TPM2_RH_NULL);
+	/* zero nonce */
+	memset(nonce, 0, sizeof(nonce));
+	tpm_buf_append_u16(&buf, sizeof(nonce));
+	tpm_buf_append(&buf, nonce, sizeof(nonce));
+	/* encrypted salt (empty) */
+	tpm_buf_append_u16(&buf, 0);
+	/* session type (HMAC, audit or policy) */
+	tpm_buf_append_u8(&buf, TPM2_SE_POLICY);
+	/* symmetric encryption parameters */
+	/* symmetric algorithm */
+	tpm_buf_append_u16(&buf, TPM2_ALG_NULL);
+
+	/* hash algorithm for session */
+	tpm_buf_append_u16(&buf, TPM2_ALG_SHA256);
+
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
+			      0, 0, "start policy session");
+
+	h = get_unaligned_be32(&buf.data[TPM_HEADER_SIZE]);
+
+	tpm_buf_reset(&buf, TPM2_ST_NO_SESSIONS,
+		      TPM2_CC_POLICY_COMMAND_CODE);
+	tpm_buf_append_u32(&buf, h);
+	tpm_buf_append_u32(&buf, TPM2_CC_UNSEAL);
+
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
+			      0, 0, "start policy session");
+
+	return h;
+}
+
+int tpm2_sessions_test(void)
+{
+	struct tpm2_auth *auth;
+	struct tpm_buf buf, b1;
+	struct tpm_buf t2b;
+	struct tpm_chip *chip;
+	int rc;
+	char payload[29];
+	char *password = "Passw0Rd";
+	const u8 *p;
+	u32 h, ps;
+	u8 name[34];
+	u16 len;
+	int ret = -EINVAL;
+
+	chip = tpm_find_get_ops(NULL);
+	if (!chip)
+		return -ENODEV;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+		return -ENODEV;
+
+	get_random_bytes(payload, sizeof(payload));
+
+	/* precursor: get a session */
+	rc = tpm2_start_auth_session(chip, &auth);
+	dev_info(&chip->dev, "TPM: start auth session returned %d\n", rc);
+	if (rc)
+		goto out;
+
+	/* first test: get random bytes from TPM */
+	tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_GET_RANDOM);
+	tpm_buf_append_hmac_session(&buf, auth, TPM2_SA_ENCRYPT
+				    | TPM2_SA_CONTINUE_SESSION, NULL, 0);
+	tpm_buf_append_u16(&buf, 29);
+	tpm_buf_fill_hmac_session(&buf, auth);
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
+			      0, 0, "get random");
+	rc = tpm_buf_check_hmac_response(&buf, auth, rc);
+	dev_info(&chip->dev, "TPM: check hmac response returned %d\n", rc);
+	tpm_buf_destroy(&buf);
+
+	/*
+	 * second test, seal random data protecting sensitive by
+	 * encryption and also doing response encryption (not
+	 * necessary) The encrypted payload has two components: an
+	 * authorization password which must be presented on useal and
+	 * the actual data (the random payload)
+	 */
+	tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
+	tpm_buf_append_name(&buf, auth, chip->tpmkey, chip->tpmkeyname);
+	tpm_buf_append_hmac_session(&buf, auth, TPM2_SA_DECRYPT
+				    | TPM2_SA_ENCRYPT
+				    | TPM2_SA_CONTINUE_SESSION, NULL, 0);
+	/* sensitive */
+	tpm_buf_init_2b(&t2b);
+	/* the authorization */
+	tpm_buf_append_u16(&t2b, strlen(password));
+	tpm_buf_append(&t2b, password, strlen(password));
+	/* the payload */
+	tpm_buf_append_u16(&t2b, sizeof(payload));
+	tpm_buf_append(&t2b, payload, sizeof(payload));
+	tpm_buf_append_2b(&buf, &t2b);
+	/* the public */
+	/* type */
+	tpm_buf_append_u16(&t2b, TPM2_ALG_KEYEDHASH);
+	/* name hash */
+	tpm_buf_append_u16(&t2b, TPM2_ALG_SHA256);
+	/* object properties */
+	tpm_buf_append_u32(&t2b, TPM2_OA_USER_WITH_AUTH | TPM2_OA_NO_DA);
+	/* auth policy (empty) */
+	tpm_buf_append_u16(&t2b, 0);
+	/* keyed hash parameters (we're null for a non-HMAC data blob) */
+	tpm_buf_append_u16(&t2b, TPM2_ALG_NULL);
+	/* unique */
+	tpm_buf_append_u16(&t2b, 0);
+	tpm_buf_append_2b(&buf, &t2b);
+	/* outside info (also empty) */
+	tpm_buf_append_u16(&buf, 0);
+	/* creation PCR (empty) */
+	tpm_buf_append_u32(&buf, 0);
+	tpm_buf_fill_hmac_session(&buf, auth);
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
+			      4, 0, "sealing data");
+	rc = tpm_buf_check_hmac_response(&buf, auth, rc);
+	dev_info(&chip->dev, "TPM: sealing response returned %d\n", rc);
+	if (rc)
+		goto out;
+
+	/*
+	 * now load the sealed object (we need the pub and priv parts
+	 * returned from prior command
+	 */
+	tpm_buf_init(&b1, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
+	/* parent */
+	tpm_buf_append_name(&b1, auth, chip->tpmkey, chip->tpmkeyname);
+	tpm_buf_append_hmac_session(&b1, auth, TPM2_SA_CONTINUE_SESSION,
+				    NULL, 0);
+	p = &buf.data[TPM_HEADER_SIZE+4];
+	/* private */
+	len = tpm_get_inc_u16(&p);
+	tpm_buf_append_u16(&b1, len);
+	tpm_buf_append(&b1, p, len);
+	p += len;
+	/* public */
+	len = tpm_get_inc_u16(&p);
+	tpm_buf_append_u16(&b1, len);
+	tpm_buf_append(&b1, p, len);
+	tpm_buf_fill_hmac_session(&b1, auth);
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, b1.data, PAGE_SIZE,
+			      4, 0, "loading seal");
+	rc = tpm_buf_check_hmac_response(&b1, auth, rc);
+	dev_info(&chip->dev, "TPM: load response returned %d\n", rc);
+	if (rc)
+		goto out;
+	p = &b1.data[TPM_HEADER_SIZE];
+	h = tpm_get_inc_u32(&p);
+	dev_info(&chip->dev, "sealed data loaded at %08x\n", h);
+	/* skip over parameter size */
+	p += 4;
+	len = tpm_get_inc_u16(&p);
+	if (len != sizeof(name)) {
+		dev_err(&chip->dev, "Wrong name size %d\n", len);
+		goto out;
+	}
+	memcpy(name, p, len);
+	tpm_buf_destroy(&b1);
+	tpm_buf_destroy(&buf);
+
+	/*
+	 * now unseal the data using the authority in a HMAC and
+	 * protecting the returned unseal by encryption
+	 */
+	tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
+	tpm_buf_append_name(&buf, auth, h, name);
+	tpm_buf_append_hmac_session(&buf, auth, TPM2_SA_ENCRYPT,
+				    password, strlen(password));
+	tpm_buf_fill_hmac_session(&buf, auth);
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
+			      4, 0, "unseal");
+	rc = tpm_buf_check_hmac_response(&buf, auth, rc);
+	tpm2_flush_context_cmd(chip, h, 0);
+	dev_info(&chip->dev, "unseal returns %d\n", rc);
+	if (rc)
+		goto out;
+	p = &buf.data[TPM_HEADER_SIZE + 4];
+	len = tpm_get_inc_u16(&p);
+	if (len != sizeof(payload)) {
+		dev_err(&chip->dev, "wrong unseal payload size %d != %ld",
+			len, sizeof(payload));
+		goto out;
+	}
+	if (memcmp(payload, p, len) != 0) {
+		dev_err(&chip->dev, "Payload DID NOT compare correctly\n");
+		goto out;
+	}
+
+	/*
+	 * third test, seal random data protecting sensitive by
+	 * encryption and also doing response encryption (not
+	 * necessary) The encrypted payload has two components: an
+	 * authorization password which must be presented on useal and
+	 * the actual data (the random payload)
+	 *
+	 * For this test use a policy to release the data testing that
+	 * we can have two sessions
+	 */
+	get_random_bytes(payload, sizeof(payload));
+	/* auth session should be closed, so get a new one */
+	rc = tpm2_start_auth_session(chip, &auth);
+	if (rc) {
+		dev_err(&chip->dev, "new auth session failed: %d\n", rc);
+		goto out;
+	}
+
+	tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
+	tpm_buf_append_name(&buf, auth, chip->tpmkey, chip->tpmkeyname);
+	tpm_buf_append_hmac_session(&buf, auth, TPM2_SA_DECRYPT
+				    | TPM2_SA_ENCRYPT
+				    | TPM2_SA_CONTINUE_SESSION, NULL, 0);
+	/* sensitive */
+	tpm_buf_init_2b(&t2b);
+	/* the authorization */
+	tpm_buf_append_u16(&t2b, 0);
+	/* the payload */
+	tpm_buf_append_u16(&t2b, sizeof(payload));
+	tpm_buf_append(&t2b, payload, sizeof(payload));
+	tpm_buf_append_2b(&buf, &t2b);
+	/* the public */
+	/* type */
+	tpm_buf_append_u16(&t2b, TPM2_ALG_KEYEDHASH);
+	/* name hash */
+	tpm_buf_append_u16(&t2b, TPM2_ALG_SHA256);
+	/* object properties */
+	tpm_buf_append_u32(&t2b, TPM2_OA_USER_WITH_AUTH | TPM2_OA_NO_DA);
+	/* auth policy (specific to command code) */
+	tpm_buf_append_u16(&t2b, sizeof(policy));
+	tpm_buf_append(&t2b, policy, sizeof(policy));
+	/* keyed hash parameters (we're null for a non-HMAC data blob) */
+	tpm_buf_append_u16(&t2b, TPM2_ALG_NULL);
+	/* unique */
+	tpm_buf_append_u16(&t2b, 0);
+	tpm_buf_append_2b(&buf, &t2b);
+	/* outside info (also empty) */
+	tpm_buf_append_u16(&buf, 0);
+	/* creation PCR (empty) */
+	tpm_buf_append_u32(&buf, 0);
+	tpm_buf_fill_hmac_session(&buf, auth);
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
+			      4, 0, "sealing data");
+	rc = tpm_buf_check_hmac_response(&buf, auth, rc);
+	dev_info(&chip->dev, "policy sealing response returned %d\n", rc);
+	if (rc)
+		goto out;
+
+	/*
+	 * now load the sealed object (we need the pub and priv parts
+	 * returned from prior command
+	 */
+	tpm_buf_init(&b1, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
+	/* parent */
+	tpm_buf_append_name(&b1, auth, chip->tpmkey, chip->tpmkeyname);
+	tpm_buf_append_hmac_session(&b1, auth, TPM2_SA_CONTINUE_SESSION,
+				    NULL, 0);
+	p = &buf.data[TPM_HEADER_SIZE+4];
+	/* private */
+	len = tpm_get_inc_u16(&p);
+	tpm_buf_append_u16(&b1, len);
+	tpm_buf_append(&b1, p, len);
+	p += len;
+	/* public */
+	len = tpm_get_inc_u16(&p);
+	tpm_buf_append_u16(&b1, len);
+	tpm_buf_append(&b1, p, len);
+	tpm_buf_fill_hmac_session(&b1, auth);
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, b1.data, PAGE_SIZE,
+			      4, 0, "loading seal");
+	rc = tpm_buf_check_hmac_response(&b1, auth, rc);
+	dev_info(&chip->dev, "TPM: load response returned %d\n", rc);
+	if (rc)
+		goto out;
+	p = &b1.data[TPM_HEADER_SIZE];
+	h = tpm_get_inc_u32(&p);
+	dev_info(&chip->dev, "sealed data loaded at %08x\n", h);
+	/* skip over parameter size */
+	p += 4;
+	len = tpm_get_inc_u16(&p);
+	if (len != sizeof(name)) {
+		dev_err(&chip->dev, "Wrong name size %d\n", len);
+		goto out;
+	}
+	memcpy(name, p, len);
+	tpm_buf_destroy(&b1);
+	tpm_buf_destroy(&buf);
+
+	/* now get a policy session */
+	ps = get_policy(chip);
+	/*
+	 * now unseal the data using the authority in a HMAC and
+	 * protecting the returned unseal by encryption
+	 */
+	tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
+	tpm_buf_append_name(&buf, auth, h, name);
+	tpm2_buf_append_auth(&buf, ps, NULL, 0, 0, NULL, 0);
+	tpm_buf_append_hmac_session(&buf, auth, TPM2_SA_ENCRYPT,
+				    NULL, 0);
+	tpm_buf_fill_hmac_session(&buf, auth);
+	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
+			      4, 0, "unseal");
+	rc = tpm_buf_check_hmac_response(&buf, auth, rc);
+	tpm2_flush_context_cmd(chip, h, 0);
+	dev_info(&chip->dev, "unseal returns %d\n", rc);
+	if (rc)
+		goto out;
+	p = &buf.data[TPM_HEADER_SIZE + 4];
+	len = tpm_get_inc_u16(&p);
+	if (len != sizeof(payload)) {
+		dev_err(&chip->dev, "wrong unseal payload size %d != %ld",
+			len, sizeof(payload));
+		goto out;
+	}
+	if (memcmp(payload, p, len) != 0) {
+		dev_err(&chip->dev, "Payload DID NOT compare correctly\n");
+		goto out;
+	}
+
+	dev_info(&chip->dev, "All tests passed\n");
+	ret = 0;
+
+ out:
+	tpm_put_ops(chip);
+
+	return ret;
+}
+
+module_init(tpm2_sessions_test);
+
+MODULE_LICENSE("GPL");
-- 
2.16.4

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C198390CB4;
	Wed, 22 Jul 2026 02:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784689027; cv=none; b=Q4MQNSEBTVlrJnQOaoBP98FMKslCyuIEuC31bHB4mPDUdwt218n7iEOv07mAaRsFLUpM9mLxWit921fmz+3z+ykLW+kksA/ATEoNoH7L2kz4KZfwFfl3uR76/VLkacCYCMG8kk9rtixztU+bXDtqhL5BbO5zgChc4VD1SFYqaGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784689027; c=relaxed/simple;
	bh=nw3PNTZb8rnHIr0XISNOXeDv6VrWEGaBfb3Jh3ija/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ig4OzCR2XA1WJ3QTlEVw4jc9iTBKiaIZuYZtpqebegP1g+gCoasQZwYTyamM4B4odXYIYTY2lzchdrfNACmP/riuFWYiZRbUZFJpLHCFaMpSnMKE8aIFzS0s2hU6Y4oVo38puoLvkRg2CmDvFBzttulOf0xJVnqnpqtvQPaI9Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cqdn1Ebc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cqdn1Ebc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A396E1F00A3F;
	Wed, 22 Jul 2026 02:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784689022;
	bh=V7Zz8lZwY5+rBnEhWkryJEK8K0B50zdX+HKnB8vh+KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cqdn1EbcmqVbKbNGBqjpTXWENZOCJwS1z+t4Nklm1N13FqEeJMQrt8e+JOx/jiUui
	 uo3A3h+blrCB2P4atSU9GIsxybfxMK8u+HDd5wWl5NU0mev5r54S8a1rrEAuKUkIui
	 6+ZyefBLsYG0Zk18W9Mh1BMKyACskSLOcU2TqbBE3J1TZncKITrCfDNFa5uhwdhZIO
	 iJvSzbjAof6RxVh52lu9JgE3gYLs4W4p17eg8kJ4qr01xlVcy90gXlk+n4whFfHoBT
	 fy0bCB3bZIliyqxJIij/Z+6xIO4X1OfMe5ryZT4bOi7+MNOg/PmzDHg/PTFraXnCtO
	 eTA5UupGDggyA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Alexey Kardashevskiy <aik@amd.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] x86/sev: Use new AES-GCM library
Date: Tue, 21 Jul 2026 19:53:36 -0700
Message-ID: <20260722025338.33354-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722025338.33354-1-ebiggers@kernel.org>
References: <20260722025338.33354-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old AES-GCM library code is being replaced as part of an overhaul
that is adding support for all the common AES encryption modes with
consistent conventions.  The SEV code is the only user of the old
AES-GCM library.  Update it to use the new API instead.

Besides adjustments to the key struct name, function names, return
value, and parameter order, the only notable changes are:

- Replace the direct accesses to the auth tag length field (which should
  be considered private until someone truly needs it) with the
  AUTHTAG_LEN constant which is already defined in <asm/sev.h>.

- Replace kfree() with kfree_sensitive() on lines being changed anyway.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/Kconfig                        |  2 +-
 arch/x86/coco/sev/core.c                | 44 ++++++++++++-------------
 arch/x86/include/asm/sev.h              |  2 +-
 drivers/virt/coco/sev-guest/sev-guest.c |  7 ++--
 4 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdad90f210e4b..0b89641cac160 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1495,7 +1495,7 @@ config AMD_MEM_ENCRYPT
 	select ARCH_HAS_CC_PLATFORM
 	select X86_MEM_ENCRYPT
 	select UNACCEPTED_MEMORY
-	select CRYPTO_LIB_AESGCM
+	select CRYPTO_LIB_AES_GCM
 	help
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index ecd77d3217f3c..54b122f6ef96a 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -25,7 +25,7 @@
 #include <linux/psp-sev.h>
 #include <linux/dmi.h>
 #include <uapi/linux/sev-guest.h>
-#include <crypto/gcm.h>
+#include <crypto/aes-gcm.h>
 
 #include <asm/init.h>
 #include <asm/cpu_entry_area.h>
@@ -1535,21 +1535,21 @@ static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
 	return key;
 }
 
-static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
+static struct aes_gcm_key *snp_init_crypto(const u8 *key, size_t keylen)
 {
-	struct aesgcm_ctx *ctx;
+	struct aes_gcm_key *gcm_key;
 
-	ctx = kzalloc_obj(*ctx);
-	if (!ctx)
+	gcm_key = kzalloc_obj(*gcm_key);
+	if (!gcm_key)
 		return NULL;
 
-	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
-		pr_err("Crypto context initialization failed\n");
-		kfree(ctx);
+	if (aes_gcm_preparekey(gcm_key, key, keylen, AUTHTAG_LEN)) {
+		pr_err("AES-GCM key preparation failed\n");
+		kfree_sensitive(gcm_key);
 		return NULL;
 	}
 
-	return ctx;
+	return gcm_key;
 }
 
 int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id)
@@ -1572,8 +1572,8 @@ int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id)
 
 	mdesc->vmpck_id = vmpck_id;
 
-	mdesc->ctx = snp_init_crypto(mdesc->vmpck, VMPCK_KEY_LEN);
-	if (!mdesc->ctx)
+	mdesc->gcm_key = snp_init_crypto(mdesc->vmpck, VMPCK_KEY_LEN);
+	if (!mdesc->gcm_key)
 		return -ENOMEM;
 
 	return 0;
@@ -1624,7 +1624,7 @@ void snp_msg_free(struct snp_msg_desc *mdesc)
 	if (!mdesc)
 		return;
 
-	kfree(mdesc->ctx);
+	kfree_sensitive(mdesc->gcm_key);
 	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
 	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
 	iounmap((__force void __iomem *)mdesc->secrets);
@@ -1709,7 +1709,7 @@ static int verify_and_dec_payload(struct snp_msg_desc *mdesc, struct snp_guest_r
 	struct snp_guest_msg *req_msg = &mdesc->secret_request;
 	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
 	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
-	struct aesgcm_ctx *ctx = mdesc->ctx;
+	struct aes_gcm_key *gcm_key = mdesc->gcm_key;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
@@ -1732,23 +1732,21 @@ static int verify_and_dec_payload(struct snp_msg_desc *mdesc, struct snp_guest_r
 	 * If the message size is greater than our buffer length then return
 	 * an error.
 	 */
-	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > req->resp_sz))
+	if (unlikely(resp_msg_hdr->msg_sz + AUTHTAG_LEN > req->resp_sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
 	memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
-	if (!aesgcm_decrypt(ctx, req->resp_buf, resp_msg->payload, resp_msg_hdr->msg_sz,
-			    &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
-		return -EBADMSG;
-
-	return 0;
+	return aes_gcm_decrypt(req->resp_buf, resp_msg->payload,
+			       resp_msg_hdr->msg_sz, resp_msg_hdr->authtag,
+			       &resp_msg_hdr->algo, AAD_LEN, iv, gcm_key);
 }
 
 static int enc_payload(struct snp_msg_desc *mdesc, u64 seqno, struct snp_guest_req *req)
 {
 	struct snp_guest_msg *msg = &mdesc->secret_request;
 	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-	struct aesgcm_ctx *ctx = mdesc->ctx;
+	struct aes_gcm_key *gcm_key = mdesc->gcm_key;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	memset(msg, 0, sizeof(*msg));
@@ -1769,12 +1767,12 @@ static int enc_payload(struct snp_msg_desc *mdesc, u64 seqno, struct snp_guest_r
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload)))
+	if (WARN_ON(req->req_sz + AUTHTAG_LEN > sizeof(msg->payload)))
 		return -EBADMSG;
 
 	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
-	aesgcm_encrypt(ctx, msg->payload, req->req_buf, req->req_sz, &hdr->algo,
-		       AAD_LEN, iv, hdr->authtag);
+	aes_gcm_encrypt(msg->payload, req->req_buf, req->req_sz, hdr->authtag,
+			&hdr->algo, AAD_LEN, iv, gcm_key);
 
 	return 0;
 }
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 594cfa19cbd4b..9e7a077c445dc 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -314,7 +314,7 @@ struct snp_msg_desc {
 
 	struct snp_secrets_page *secrets;
 
-	struct aesgcm_ctx *ctx;
+	struct aes_gcm_key *gcm_key;
 
 	u32 *os_area_msg_seqno;
 	u8 *vmpck;
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index d186ae55cf63b..935537a41469b 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -17,7 +17,6 @@
 #include <linux/set_memory.h>
 #include <linux/fs.h>
 #include <linux/tsm.h>
-#include <crypto/gcm.h>
 #include <linux/psp-sev.h>
 #include <linux/sockptr.h>
 #include <linux/cleanup.h>
@@ -87,7 +86,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
+	resp_len = sizeof(report_resp->data) + AUTHTAG_LEN;
 	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!report_resp)
 		return -ENOMEM;
@@ -130,7 +129,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(derived_key_resp->data) + mdesc->ctx->authsize;
+	resp_len = sizeof(derived_key_resp->data) + AUTHTAG_LEN;
 	derived_key_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!derived_key_resp)
 		return -ENOMEM;
@@ -230,7 +229,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
+	resp_len = sizeof(report_resp->data) + AUTHTAG_LEN;
 	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!report_resp) {
 		ret = -ENOMEM;
-- 
2.55.0


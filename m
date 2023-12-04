Received: from mail.nsr.re.kr (unknown [210.104.33.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61084101
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 00:05:14 -0800 (PST)
Received: from 210.104.33.70 (nsr.re.kr)
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
	by mail.nsr.re.kr with SMTP; Mon, 04 Dec 2023 17:02:52 +0900
X-Sender: letrehee@nsr.re.kr
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 319;
          Mon, 4 Dec 2023 17:02:47 +0900 (KST)
From: Dongsoo Lee <letrehee@nsr.re.kr>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongsoo Lee <letrhee@nsr.re.kr>
Subject: [PATCH 4/5] fscrypt: Add LEA-256-XTS, LEA-256-CTS support
Date: Mon,  4 Dec 2023 08:02:16 +0000
Message-Id: <20231204080217.9407-5-letrehee@nsr.re.kr>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231204080217.9407-1-letrehee@nsr.re.kr>
References: <20231204080217.9407-1-letrehee@nsr.re.kr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dongsoo Lee <letrhee@nsr.re.kr>

It uses LEA-256-XTS for file encryption and LEA-256-CTS-CBC for
filename encryption. Includes constant changes as the number of
supported ciphers increases.

Signed-off-by: Dongsoo Lee <letrhee@nsr.re.kr>
---
 fs/crypto/fscrypt_private.h        |  2 +-
 fs/crypto/keysetup.c               | 15 +++++++++++++++
 fs/crypto/policy.c                 |  4 ++++
 include/uapi/linux/fscrypt.h       |  4 +++-
 tools/include/uapi/linux/fscrypt.h |  4 +++-
 5 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 1892356cf924..1f0502999804 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -31,7 +31,7 @@
 #define FSCRYPT_CONTEXT_V2	2
 
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
-#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
+#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_LEA_256_CTS
 
 struct fscrypt_context_v1 {
 	u8 version; /* FSCRYPT_CONTEXT_V1 */
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index d71f7c799e79..f8b0116e43a3 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -74,6 +74,21 @@ struct fscrypt_mode fscrypt_modes[] = {
 		.security_strength = 32,
 		.ivsize = 32,
 	},
+	[FSCRYPT_MODE_LEA_256_XTS] = {
+		.friendly_name = "LEA-256-XTS",
+		.cipher_str = "xts(lea)",
+		.keysize = 64,
+		.security_strength = 32,
+		.ivsize = 16,
+		.blk_crypto_mode = BLK_ENCRYPTION_MODE_LEA_256_XTS,
+	},
+	[FSCRYPT_MODE_LEA_256_CTS] = {
+		.friendly_name = "LEA-256-CTS-CBC",
+		.cipher_str = "cts(cbc(lea))",
+		.keysize = 32,
+		.security_strength = 32,
+		.ivsize = 16,
+	},
 };
 
 static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 701259991277..b9bb175a11c7 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -94,6 +94,10 @@ static bool fscrypt_valid_enc_modes_v2(u32 contents_mode, u32 filenames_mode)
 	    filenames_mode == FSCRYPT_MODE_SM4_CTS)
 		return true;
 
+	if (contents_mode == FSCRYPT_MODE_LEA_256_XTS &&
+	    filenames_mode == FSCRYPT_MODE_LEA_256_CTS)
+		return true;
+
 	return fscrypt_valid_enc_modes_v1(contents_mode, filenames_mode);
 }
 
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 7a8f4c290187..c3c5a04f85c8 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -30,7 +30,9 @@
 #define FSCRYPT_MODE_SM4_CTS			8
 #define FSCRYPT_MODE_ADIANTUM			9
 #define FSCRYPT_MODE_AES_256_HCTR2		10
-/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
+#define FSCRYPT_MODE_LEA_256_XTS		11
+#define FSCRYPT_MODE_LEA_256_CTS		12
+/* If adding a mode number > 12, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
index fd1fb0d5389d..df3c8af98210 100644
--- a/tools/include/uapi/linux/fscrypt.h
+++ b/tools/include/uapi/linux/fscrypt.h
@@ -30,7 +30,9 @@
 #define FSCRYPT_MODE_SM4_CTS			8
 #define FSCRYPT_MODE_ADIANTUM			9
 #define FSCRYPT_MODE_AES_256_HCTR2		10
-/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
+#define FSCRYPT_MODE_LEA_256_XTS		11
+#define FSCRYPT_MODE_LEA_256_CTS		12
+/* If adding a mode number > 12, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
-- 
2.40.1

Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E43ED128
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879668; cv=none; b=P6fNjS6EKgET3T8uVcJ6yMo4hovvCYAaEdevjV+j24ie97KSGJmC8zkP2UaUHEeDJ7JoTEl51ExsylbeqpXGagipLvXc3roYTx33kyt5kFJbCrKz32foczshMSM2RRgId6ZbiR+aERIWeIRRlyK2jGKh2O+VLmRxV6SPgf+STUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879668; c=relaxed/simple;
	bh=msNEhWQcSwNE6T7QnFoUfFfSSSD/YmuJUa2h6PeyfBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUZQs3SjJ0lk5LvzJHJmR3KSHtHNcEk/Yh9iOqeSqDSvtUCjUpBuvHEQE0x6ozI7Mw2TBfrx1vZgve1qK/HkBx9AOlmK4yx+s9AeR8ezbimVRx3cwWeteIP9wCrMP5tlvgo8rQrzSp7C6j3qa70hkspSUftDxJtq7AKUOzLYtGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sfgckZEp; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sfgckZEp"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-133466cf955so983152c88.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879664; x=1779484464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFmz/IKFkr+yHkTTECqlvzt5xXCg9R4f8VRlkTmPQhI=;
        b=sfgckZEp9aJp4JjltgjE93ZFVO+j1jS7bj/eaC1RBry7Gd1fqUmOyXDwPUoXx8R3CV
         jxm0Og4GpEZpu1+EMu2wx20HE+JJVSUoqQu4gQTuuR6/0yuZlv26OEsBZQZYUejXpW0Q
         PC1Zhci8mDGxF04u+hDdynx/cwtfYbJEP3pSpnRSIgJ4yn+t/84TWWaapxJKhKfG+dAH
         8Z1m97XKRayC+iXJabSBQtZpEWZzD/cVT6Y1A2T4zt4z+VQ3QqnEmsmzLRt1PTszwr1i
         4A8sc133sozwg2rNHyNmDaH1ORUjkbSa9eXzcgS5fQJYj9kPY1Cy+K1DWYCoWra/Adqj
         JFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879664; x=1779484464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kFmz/IKFkr+yHkTTECqlvzt5xXCg9R4f8VRlkTmPQhI=;
        b=kHbZHUIUOQSKzLKtsfxurutHOQs/pWkzfwjIaJwshZ3IZ8leZN2jiwR7aVe35uGXXp
         xtqGol5a/E5EcUZjJD7mf6EJC0BWEHuFZwvlVJ9rFYMoSY/mdF+wUui3UBNFnAYWrdMo
         9Kr9byqlk8ZQibrIYxDLRInxHYIj9HOMylVMt8Xa0VDz3PpL/VGWkI2VCVn4jFD/sL63
         SXfZTN76cEDZxOxaNQUcz7fJGqGQfGE6HmND67eBthIjtiWq8WVCUmXOjFeQgNbcZ6q2
         k77Qw5I63i8NX3QQotIT+2mzjQijnRXt4gYoHNs5C31C/t/YrkID2yUYdKyTJhC3sJIE
         xMYw==
X-Forwarded-Encrypted: i=1; AFNElJ+zl+pbfnrRMaXw42i8fNnb2PIdLZ8J3WgRZ6Al2m6eyA+xW9NU28RDPlGk6Nk4CWWTZV2Sov9y2aDLvvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUYr/6wUOcQKcyVvX3/p1TjadwKRopb0zwtNKYq5nyYrvKRkTE
	+6oGGUpZQniD71gh1DQ8L/G4v97IOPpo3mxtFCt5cM3hdJDYJah7hz7d
X-Gm-Gg: Acq92OFeBiNBecAIungT98bL/fxSbV7owi1g4bb/IsZe0DQCQwMql/+mRaiOzg/Lsn+
	pzK242l9ZoHF+wnI9xnnQbb6szL3ScPYqPmxNaKlz06aZ5A05AwsjwXAIGZB9xXpmzc/6plz6tu
	ZeNkH0LU5x1VI5XS3YweSHXqpAJzuk7PB2XdRALfUoyBrdwcTlZmCoCQQMnI/MVH924LeuPk/6M
	nzQuoucLES5f/kv2OIzaLKHAjoAlxA7Y6mdswaZ56lW49Vkjkifi+s1g4fhFUXFmNrb65dEWrmz
	mIImw6IcZ/3kuD0Ie8rRkEbssFxR95TRKKfpuCEaoLe71lxo+Kytcii4y2UKL59PTvqzw3u+Dm9
	/Lsa2h5v1Y1nFvctCEgQE8fFsPXfYeYSJOWu96t4A26blgh4j8I3R7AcRQPDtMXf9Z03uBIDkdF
	ouoIcCmeFFwxS/PaFKrnMeF/hx1sBeBpQ=
X-Received: by 2002:a05:7022:4582:b0:132:5db9:27af with SMTP id a92af1059eb24-13504a49ademr2695477c88.35.1778879663897;
        Fri, 15 May 2026 14:14:23 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbcb93f3sm11145075c88.3.2026.05.15.14.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:23 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 04/38] tpm: Move TPM common base definitions to the command header
Date: Fri, 15 May 2026 14:13:36 -0700
Message-ID: <20260515211410.31440-5-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are top level definitions shared by both TPM 1 and 2
family chips. This includes core definitions like TPM localities,
common crypto algorithm IDs, and the base TPM command header.

Co-developed-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Co-developed-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 include/linux/tpm.h         | 50 +--------------------
 include/linux/tpm_command.h | 89 +++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 49 deletions(-)

diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 8551b24c2bff..3630b2ea6aef 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -27,49 +27,12 @@
 
 #include <linux/tpm_command.h>
 
-#define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
-
-#define TPM2_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
-#define TPM2_MAX_PCR_BANKS	8
-
 struct tpm_chip;
 struct trusted_key_payload;
 struct trusted_key_options;
 /* opaque structure, holds auth session parameters like the session key */
 struct tpm2_auth;
 
-/* if you add a new hash to this, increment TPM_MAX_HASHES below */
-enum tpm_algorithms {
-	TPM_ALG_ERROR		= 0x0000,
-	TPM_ALG_SHA1		= 0x0004,
-	TPM_ALG_AES		= 0x0006,
-	TPM_ALG_KEYEDHASH	= 0x0008,
-	TPM_ALG_SHA256		= 0x000B,
-	TPM_ALG_SHA384		= 0x000C,
-	TPM_ALG_SHA512		= 0x000D,
-	TPM_ALG_NULL		= 0x0010,
-	TPM_ALG_SM3_256		= 0x0012,
-	TPM_ALG_ECC		= 0x0023,
-	TPM_ALG_CFB		= 0x0043,
-};
-
-/*
- * maximum number of hashing algorithms a TPM can have.  This is
- * basically a count of every hash in tpm_algorithms above
- */
-#define TPM_MAX_HASHES	5
-
-struct tpm_digest {
-	u16 alg_id;
-	u8 digest[TPM2_MAX_DIGEST_SIZE];
-} __packed;
-
-struct tpm_bank_info {
-	u16 alg_id;
-	u16 digest_size;
-	u16 crypto_id;
-};
-
 enum TPM_OPS_FLAGS {
 	TPM_OPS_AUTO_STARTUP = BIT(0),
 };
@@ -127,7 +90,7 @@ struct tpm_chip_seqops {
 	const struct seq_operations *seqops;
 };
 
-/* fixed define for the curve we use which is NIST_P256 */
+/* Fixed define for the curve we use which is NIST_P256 */
 #define EC_PT_SZ	32
 
 /*
@@ -209,8 +172,6 @@ struct tpm_chip {
 #endif
 };
 
-#define TPM_HEADER_SIZE		10
-
 static inline enum tpm2_mso_type tpm2_handle_mso(u32 handle)
 {
 	return handle >> 24;
@@ -239,15 +200,6 @@ enum tpm_chip_flags {
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
 
-struct tpm_header {
-	__be16 tag;
-	__be32 length;
-	union {
-		__be32 ordinal;
-		__be32 return_code;
-	};
-} __packed;
-
 enum tpm_buf_flags {
 	/* the capacity exceeded: */
 	TPM_BUF_OVERFLOW	= BIT(0),
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index 9dd903dd6b5c..96edebd9610f 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -427,4 +427,93 @@ struct tpm2_context {
 	__be16 blob_size;
 } __packed;
 
+/*
+ * == TPM Common Defs ==
+ */
+
+#define TPM_DIGEST_SIZE		20	/* Max TPM v1.2 PCR size */
+#define TPM_BUFSIZE		4096
+
+/*
+ * SHA-512 is, as of today, the largest digest in the TCG algorithm repository.
+ */
+#define TPM2_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
+
+/*
+ * A TPM name digest i.e., TPMT_HA, is a concatenation of TPM_ALG_ID of the
+ * name algorithm and hash of TPMT_PUBLIC.
+ */
+#define TPM2_MAX_NAME_SIZE	(TPM2_MAX_DIGEST_SIZE + 2)
+
+/*
+ * Fixed define for the size of a name.  This is actually HASHALG size
+ * plus 2, so 32 for SHA256
+ */
+#define TPM2_NULL_NAME_SIZE	34
+
+/*
+ * The maximum number of PCR banks.
+ */
+#define TPM2_MAX_PCR_BANKS	8
+
+/* If you add a new hash to this, increment TPM_MAX_HASHES below */
+enum tpm_algorithms {
+	TPM_ALG_ERROR		= 0x0000,
+	TPM_ALG_SHA1		= 0x0004,
+	TPM_ALG_AES		= 0x0006,
+	TPM_ALG_KEYEDHASH	= 0x0008,
+	TPM_ALG_SHA256		= 0x000B,
+	TPM_ALG_SHA384		= 0x000C,
+	TPM_ALG_SHA512		= 0x000D,
+	TPM_ALG_NULL		= 0x0010,
+	TPM_ALG_SM3_256		= 0x0012,
+	TPM_ALG_ECC		= 0x0023,
+	TPM_ALG_CFB		= 0x0043,
+};
+
+/*
+ * The locality (0 - 4) for a TPM, as defined in section 3.2 of the
+ * Client Platform Profile Specification.
+ */
+enum tpm_localities {
+	TPM_LOCALITY_0		= 0, /* Static RTM */
+	TPM_LOCALITY_1		= 1, /* Dynamic OS */
+	TPM_LOCALITY_2		= 2, /* DRTM Environment */
+	TPM_LOCALITY_3		= 3, /* Aux Components */
+	TPM_LOCALITY_4		= 4, /* CPU DRTM Establishment */
+	TPM_MAX_LOCALITY	= TPM_LOCALITY_4
+};
+
+/*
+ * Structure to represent active PCR algorithm banks usable by the
+ * TPM chip.
+ */
+struct tpm_bank_info {
+	u16 alg_id;
+	u16 digest_size;
+	u16 crypto_id;
+};
+
+/*
+ * Maximum number of hashing algorithms a TPM can have.  This is
+ * basically a count of every hash in tpm_algorithms above
+ */
+#define TPM_MAX_HASHES		5
+
+struct tpm_digest {
+	u16 alg_id;
+	u8 digest[TPM2_MAX_DIGEST_SIZE];
+} __packed;
+
+#define TPM_HEADER_SIZE		10
+
+struct tpm_header {
+	__be16 tag;
+	__be32 length;
+	union {
+		__be32 ordinal;
+		__be32 return_code;
+	};
+} __packed;
+
 #endif
-- 
2.47.3


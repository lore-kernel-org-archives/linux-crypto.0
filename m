Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77354A0F09;
	Tue,  1 Sep 2026 18:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788288890; cv=none; b=lFOemFPZkHRfMd+D11Uu9i42OX4ItFwkh8Vu8+FKqMkGvMVH/AIjztHLiAlWGryqbwbCEK3DC/XKuYQpn/64f6TnPcHrjKTaxStgn1A4kqwXikuAcsig1eoIRKk88CYUNKu+RfnH7Cje9Gnxo8aaW4wd4XS7M1f0z0WwF/CGor4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788288890; c=relaxed/simple;
	bh=vtFfG+JMUv9XOKazKyZsQccPhs2fG2Xk/8Vhzv1ift4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kuwM/HHZHq6vTnM/z2eNEydCpq6gUaf5p6IXXmSb8l15cpmgA5p7wl04wCJoIvs1pVbu2jJLappi6oxAAY2Nj2jEmavJzlokFlEehCyc5Z4RUKjx6bZD0yCQVnGSw2Wsw7SdEEmkjflVt/nHbg34JndnmQdvlyW+YCUI8SyEBsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vsrrADMA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vsrrADMA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=B2YTmETQ3V6ePI5Q0Gy5QnG7ZGu8CldDtrSct0RkzFU=; b=vsrrADMA8PEr+Mc4uWKsMHH9BR
	NWRBQqmtUSoKBvc08KZwbkuPKzGGwwEChldIP/108AUMdDhRNEbZtHmqOn+NmWyMo3LXwJL/mpAEn
	1FIoUSNn6yuWzSVPTWmYkalXYcHftzfDXJuLNPIpG0BIdmC9JXs42bC1NEJA7soqinOu0Nk7y3Zd+
	1R4/USFdYeGUGtP3pfl+tlYQdsdGipU3+f+BT9nhPy64x+VBSdC/3wTw/UHbKciM73RxYHCLyXdCq
	9ZcXlk7PpReE9c7KNuEZAjXSzuedjCUnm7mMQSNDXmuKIBF33AZS9xRHJyieo3M/ogMktdnnakx3u
	ChJaEf2g==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1Td3-0000000D8O2-1CuZ;
	Tue, 01 Sep 2026 18:54:42 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: ccp.h - repair all kernel-doc comments
Date: Tue,  1 Sep 2026 11:54:38 -0700
Message-ID: <20260901185438.31038-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eliminate all kernel-doc warnings in <linux/ccp.h>:
- add Returns: for function return values
- use the enum keyword when describing an enum in kernel-doc
- add missing enum value descriptions
- add or repair missing struct member descriptions
- use nested struct notation as needed

Warning: include/linux/ccp.h:30 No description found for return value
 of 'ccp_present'
Warning: include/linux/ccp.h:42 No description found for return value
 of 'ccp_version'
Warning: include/linux/ccp.h:67 No description found for return value
 of 'ccp_enqueue_cmd'
Warning: include/linux/ccp.h:97 cannot understand function prototype:
 'enum ccp_aes_type'
Warning: include/linux/ccp.h:114 cannot understand function prototype:
 'enum ccp_aes_mode'
Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GHASH' not
 described in enum 'ccp_aes_mode'
Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GCTR' not
 described in enum 'ccp_aes_mode'
Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GCM' not
 described in enum 'ccp_aes_mode'
Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GMAC' not
 described in enum 'ccp_aes_mode'
Warning: include/linux/ccp.h:134 cannot understand function prototype:
 'enum ccp_aes_action'
Warning: include/linux/ccp.h:190 struct member 'authsize' not described
 in 'ccp_aes_engine'
Warning: include/linux/ccp.h:190 struct member 'aad_len' not described
 in 'ccp_aes_engine'
Warning: include/linux/ccp.h:202 cannot understand function prototype:
 'enum ccp_xts_aes_unit_size'
Warning: include/linux/ccp.h:245 struct member 'type' not described in
 'ccp_xts_aes_engine'
Warning: include/linux/ccp.h:255 cannot understand function prototype:
 'enum ccp_sha_type'
Warning: include/linux/ccp.h:394 cannot understand function prototype:
 'enum ccp_passthru_bitwise'
Warning: include/linux/ccp.h:410 cannot understand function prototype:
 'enum ccp_passthru_byteswap'
Warning: include/linux/ccp.h:472 struct member 'src_dma' not described
 in 'ccp_passthru_nomap_engine'
Warning: include/linux/ccp.h:472 struct member 'dst_dma' not described
 in 'ccp_passthru_nomap_engine'
Warning: include/linux/ccp.h:472 Excess struct member 'src' description in
 'ccp_passthru_nomap_engine' (did you mean one of: 'src_len', 'src_dma')
Warning: include/linux/ccp.h:472 Excess struct member 'dst' description in
 'ccp_passthru_nomap_engine' (did you mean one of: 'dst_dma')
Warning: include/linux/ccp.h:489 cannot understand function prototype:
 'enum ccp_ecc_function'
Warning: include/linux/ccp.h:587 struct member 'u' not described in
 'ccp_ecc_engine'
Warning: include/linux/ccp.h:587 Excess struct member 'mm' description in
 'ccp_ecc_engine' (did you mean one of: 'u.mm')
Warning: include/linux/ccp.h:587 Excess struct member 'pm' description in
 'ccp_ecc_engine' (did you mean one of: 'u.pm')
Warning: include/linux/ccp.h:602 cannot understand function prototype:
 'enum ccp_engine'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: John Allen <john.allen@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org

 include/linux/ccp.h |   58 +++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 20 deletions(-)

--- linux-next-20260831.orig/include/linux/ccp.h
+++ linux-next-20260831/include/linux/ccp.h
@@ -26,7 +26,7 @@ struct ccp_cmd;
 /**
  * ccp_present - check if a CCP device is present
  *
- * Returns zero if a CCP device is present, -ENODEV otherwise.
+ * Returns: zero if a CCP device is present, -ENODEV otherwise.
  */
 int ccp_present(void);
 
@@ -38,7 +38,7 @@ int ccp_present(void);
 /**
  * ccp_version - get the version of the CCP
  *
- * Returns a positive version number, or zero if no CCP
+ * Returns: a positive version number, or zero if no CCP
  */
 unsigned int ccp_version(void);
 
@@ -61,9 +61,9 @@ unsigned int ccp_version(void);
  * will be -EINPROGRESS. Any other "err" value during callback is
  * the result of the operation.
  *
- * The cmd has been successfully queued if:
- *   the return code is -EINPROGRESS or
- *   the return code is -EBUSY and CCP_CMD_MAY_BACKLOG flag is set
+ * Returns: The cmd has been successfully queued if:
+ * * the return code is -EINPROGRESS or
+ * * the return code is -EBUSY and CCP_CMD_MAY_BACKLOG flag is set
  */
 int ccp_enqueue_cmd(struct ccp_cmd *cmd);
 
@@ -89,7 +89,7 @@ static inline int ccp_enqueue_cmd(struct
 
 /***** AES engine *****/
 /**
- * ccp_aes_type - AES key size
+ * enum ccp_aes_type - AES key size
  *
  * @CCP_AES_TYPE_128: 128-bit key
  * @CCP_AES_TYPE_192: 192-bit key
@@ -99,11 +99,12 @@ enum ccp_aes_type {
 	CCP_AES_TYPE_128 = 0,
 	CCP_AES_TYPE_192,
 	CCP_AES_TYPE_256,
+	/* private: */
 	CCP_AES_TYPE__LAST,
 };
 
 /**
- * ccp_aes_mode - AES operation mode
+ * enum ccp_aes_mode - AES operation mode
  *
  * @CCP_AES_MODE_ECB: ECB mode
  * @CCP_AES_MODE_CBC: CBC mode
@@ -111,6 +112,10 @@ enum ccp_aes_type {
  * @CCP_AES_MODE_CFB: CFB mode
  * @CCP_AES_MODE_CTR: CTR mode
  * @CCP_AES_MODE_CMAC: CMAC mode
+ * @CCP_AES_MODE_GHASH: GHASH mode
+ * @CCP_AES_MODE_GCTR: GCTR mode
+ * @CCP_AES_MODE_GCM: GCM mode
+ * @CCP_AES_MODE_GMAC: GMAC mode
  */
 enum ccp_aes_mode {
 	CCP_AES_MODE_ECB = 0,
@@ -123,11 +128,12 @@ enum ccp_aes_mode {
 	CCP_AES_MODE_GCTR,
 	CCP_AES_MODE_GCM,
 	CCP_AES_MODE_GMAC,
+	/* private: */
 	CCP_AES_MODE__LAST,
 };
 
 /**
- * ccp_aes_mode - AES operation mode
+ * enum ccp_aes_action - AES operation mode
  *
  * @CCP_AES_ACTION_DECRYPT: AES decrypt operation
  * @CCP_AES_ACTION_ENCRYPT: AES encrypt operation
@@ -135,6 +141,7 @@ enum ccp_aes_mode {
 enum ccp_aes_action {
 	CCP_AES_ACTION_DECRYPT = 0,
 	CCP_AES_ACTION_ENCRYPT,
+	/* private: */
 	CCP_AES_ACTION__LAST,
 };
 /* Overloaded field */
@@ -146,6 +153,7 @@ enum ccp_aes_action {
  * @type: AES operation key size
  * @mode: AES operation mode
  * @action: AES operation (decrypt/encrypt)
+ * @authsize: AES block request size
  * @key: key to be used for this AES operation
  * @key_len: length in bytes of key
  * @iv: IV to be used for this AES operation
@@ -156,6 +164,7 @@ enum ccp_aes_action {
  * @cmac_final: indicates final operation when running in CMAC mode
  * @cmac_key: K1/K2 key used in final CMAC operation
  * @cmac_key_len: length in bytes of cmac_key
+ * @aad_len: length in bytes of Additional Authenticated Data
  *
  * Variables required to be set when calling ccp_enqueue_cmd():
  *   - type, mode, action, key, key_len, src, dst, src_len
@@ -192,7 +201,7 @@ struct ccp_aes_engine {
 
 /***** XTS-AES engine *****/
 /**
- * ccp_xts_aes_unit_size - XTS unit size
+ * enum ccp_xts_aes_unit_size - XTS unit size
  *
  * @CCP_XTS_AES_UNIT_SIZE_16: Unit size of 16 bytes
  * @CCP_XTS_AES_UNIT_SIZE_512: Unit size of 512 bytes
@@ -206,11 +215,13 @@ enum ccp_xts_aes_unit_size {
 	CCP_XTS_AES_UNIT_SIZE_1024,
 	CCP_XTS_AES_UNIT_SIZE_2048,
 	CCP_XTS_AES_UNIT_SIZE_4096,
+	/* private: */
 	CCP_XTS_AES_UNIT_SIZE__LAST,
 };
 
 /**
  * struct ccp_xts_aes_engine - CCP XTS AES operation
+ * @type: ccp_aes_type - AES key size
  * @action: AES operation (decrypt/encrypt)
  * @unit_size: unit size of the XTS operation
  * @key: key to be used for this XTS AES operation
@@ -247,11 +258,13 @@ struct ccp_xts_aes_engine {
 
 /***** SHA engine *****/
 /**
- * ccp_sha_type - type of SHA operation
+ * enum ccp_sha_type - type of SHA operation
  *
  * @CCP_SHA_TYPE_1: SHA-1 operation
  * @CCP_SHA_TYPE_224: SHA-224 operation
  * @CCP_SHA_TYPE_256: SHA-256 operation
+ * @CCP_SHA_TYPE_384: SHA-384 operation
+ * @CCP_SHA_TYPE_512: SHA-512 operation
  */
 enum ccp_sha_type {
 	CCP_SHA_TYPE_1 = 1,
@@ -259,6 +272,7 @@ enum ccp_sha_type {
 	CCP_SHA_TYPE_256,
 	CCP_SHA_TYPE_384,
 	CCP_SHA_TYPE_512,
+	/* private: */
 	CCP_SHA_TYPE__LAST,
 };
 
@@ -384,7 +398,7 @@ struct ccp_rsa_engine {
 
 /***** Passthru engine *****/
 /**
- * ccp_passthru_bitwise - type of bitwise passthru operation
+ * enum ccp_passthru_bitwise - type of bitwise passthru operation
  *
  * @CCP_PASSTHRU_BITWISE_NOOP: no bitwise operation performed
  * @CCP_PASSTHRU_BITWISE_AND: perform bitwise AND of src with mask
@@ -398,11 +412,12 @@ enum ccp_passthru_bitwise {
 	CCP_PASSTHRU_BITWISE_OR,
 	CCP_PASSTHRU_BITWISE_XOR,
 	CCP_PASSTHRU_BITWISE_MASK,
+	/* private: */
 	CCP_PASSTHRU_BITWISE__LAST,
 };
 
 /**
- * ccp_passthru_byteswap - type of byteswap passthru operation
+ * enum ccp_passthru_byteswap - type of byteswap passthru operation
  *
  * @CCP_PASSTHRU_BYTESWAP_NOOP: no byte swapping performed
  * @CCP_PASSTHRU_BYTESWAP_32BIT: swap bytes within 32-bit words
@@ -412,6 +427,7 @@ enum ccp_passthru_byteswap {
 	CCP_PASSTHRU_BYTESWAP_NOOP = 0,
 	CCP_PASSTHRU_BYTESWAP_32BIT,
 	CCP_PASSTHRU_BYTESWAP_256BIT,
+	/* private: */
 	CCP_PASSTHRU_BYTESWAP__LAST,
 };
 
@@ -450,8 +466,8 @@ struct ccp_passthru_engine {
  * @byte_swap: byteswap operation to perform
  * @mask: mask to be applied to data
  * @mask_len: length in bytes of mask
- * @src: data to be used for this operation
- * @dst: data produced by this operation
+ * @src_dma: data to be used for this operation
+ * @dst_dma: data produced by this operation
  * @src_len: length in bytes of data used for this operation
  * @final: indicate final pass-through operation
  *
@@ -478,7 +494,7 @@ struct ccp_passthru_nomap_engine {
 #define CCP_ECC_MAX_OUTPUTS	3
 
 /**
- * ccp_ecc_function - type of ECC function
+ * enum ccp_ecc_function - type of ECC function
  *
  * @CCP_ECC_FUNCTION_MMUL_384BIT: 384-bit modular multiplication
  * @CCP_ECC_FUNCTION_MADD_384BIT: 384-bit modular addition
@@ -564,8 +580,9 @@ struct ccp_ecc_point_math {
  * @function: ECC function to perform
  * @mod: ECC modulus
  * @mod_len: length in bytes of modulus
- * @mm: module math parameters
- * @pm: point math parameters
+ * @u: union for math parameters
+ * @u.mm: module math parameters
+ * @u.pm: point math parameters
  * @ecc_result: result of the ECC operation
  *
  * Variables required to be set when calling ccp_enqueue_cmd():
@@ -589,11 +606,11 @@ struct ccp_ecc_engine {
 
 
 /**
- * ccp_engine - CCP operation identifiers
+ * enum ccp_engine - CCP operation identifiers
  *
  * @CCP_ENGINE_AES: AES operation
- * @CCP_ENGINE_XTS_AES: 128-bit XTS AES operation
- * @CCP_ENGINE_RSVD1: unused
+ * @CCP_ENGINE_XTS_AES_128: 128-bit XTS AES operation
+ * @CCP_ENGINE_DES3: 3DES operation
  * @CCP_ENGINE_SHA: SHA operation
  * @CCP_ENGINE_RSA: RSA operation
  * @CCP_ENGINE_PASSTHRU: pass-through operation
@@ -609,6 +626,7 @@ enum ccp_engine {
 	CCP_ENGINE_PASSTHRU,
 	CCP_ENGINE_ZLIB_DECOMPRESS,
 	CCP_ENGINE_ECC,
+	/* private: */
 	CCP_ENGINE__LAST,
 };
 

Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F692030A;
	Wed, 24 Sep 2025 21:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758747630; cv=none; b=XvNeCo4Zf2jqVBIQU7FwAbtad1OeDBnmIaVQ6aJonJkdNjm7OH8fDCsP5H7QR5oOiJDj0L2jDqvlqAdyvTIU4oBxaCUfj2zej6mFI2c6DVD7BXLJ6ys1LoOd336q9PtEqcEYbSPMLUnosACFTYbdaqCjFAXDzuMIQZcdI1ZMbXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758747630; c=relaxed/simple;
	bh=RGaamjF2IpwNIjXgC1t3FdjIIIk21TfElKBMJOvZv8Q=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=P9zz68xVuKWXpN7Df937vDxgh/6568g7LoWHjpptXyxcZSmezin8xcfDO9KfK6XPnC+kSc65XARCojbqVWjHPcAFXg84S1DPeHxSV2bcFwD/QUndcD1tDvvrRPqOuV4+64uIq9pNGWCltkTqRQeXbdQtMV1u8F4ZIsJQfzbDhtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.103] (213.87.129.165) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Thu, 25 Sep
 2025 00:00:13 +0300
Message-ID: <1bb8aa58-7f40-4ba7-959a-e44655aa4a83@omp.ru>
Date: Thu, 25 Sep 2025 00:00:10 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Karina Yankevich <k.yankevich@omp.ru>
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v2] crypto: drbg - make drbg_{ctr_bcc,kcapi_sym}() return
 *void*
Organization: Open Mobile Platform
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 09/24/2025 20:43:03
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 196576 [Sep 24 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 67 0.3.67
 f6b3a124585516de4e61e2bf9df040d8947a2fd5
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info:
	omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.129.165
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/24/2025 20:44:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 9/24/2025 5:12:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

From: Karina Yankevich <k.yankevich@omp.ru>

drgb_kcapi_sym() always returns 0, so make it return void instead.
Consequently, make drbg_ctr_bcc() return void too.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

[Sergey: fixed the subject, refreshed the patch]

Signed-off-by: Karina Yankevich <k.yankevich@omp.ru>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
The patch is against the master branch of Linus Torvalds' linux.git repo
(I'm unable to use the other repos on git.kernel.org and I have to update
Linus' repo from GitHub).

 crypto/drbg.c |   38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

Index: linux/crypto/drbg.c
===================================================================
--- linux.orig/crypto/drbg.c
+++ linux/crypto/drbg.c
@@ -296,8 +296,8 @@ MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes12
 
 static void drbg_kcapi_symsetkey(struct drbg_state *drbg,
 				 const unsigned char *key);
-static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
-			  const struct drbg_string *in);
+static void drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
+			   const struct drbg_string *in);
 static int drbg_init_sym_kernel(struct drbg_state *drbg);
 static int drbg_fini_sym_kernel(struct drbg_state *drbg);
 static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
@@ -306,11 +306,10 @@ static int drbg_kcapi_sym_ctr(struct drb
 #define DRBG_OUTSCRATCHLEN 256
 
 /* BCC function for CTR DRBG as defined in 10.4.3 */
-static int drbg_ctr_bcc(struct drbg_state *drbg,
-			unsigned char *out, const unsigned char *key,
-			struct list_head *in)
+static void drbg_ctr_bcc(struct drbg_state *drbg,
+			 unsigned char *out, const unsigned char *key,
+			 struct list_head *in)
 {
-	int ret = 0;
 	struct drbg_string *curr = NULL;
 	struct drbg_string data;
 	short cnt = 0;
@@ -327,9 +326,7 @@ static int drbg_ctr_bcc(struct drbg_stat
 			/* 10.4.3 step 4.2 */
 			if (drbg_blocklen(drbg) == cnt) {
 				cnt = 0;
-				ret = drbg_kcapi_sym(drbg, out, &data);
-				if (ret)
-					return ret;
+				drbg_kcapi_sym(drbg, out, &data);
 			}
 			out[cnt] ^= *pos;
 			pos++;
@@ -339,9 +336,7 @@ static int drbg_ctr_bcc(struct drbg_stat
 	}
 	/* 10.4.3 step 4.2 for last block */
 	if (cnt)
-		ret = drbg_kcapi_sym(drbg, out, &data);
-
-	return ret;
+		drbg_kcapi_sym(drbg, out, &data);
 }
 
 /*
@@ -388,7 +383,6 @@ static int drbg_ctr_df(struct drbg_state
 		       unsigned char *df_data, size_t bytes_to_return,
 		       struct list_head *seedlist)
 {
-	int ret = -EFAULT;
 	unsigned char L_N[8];
 	/* S3 is input */
 	struct drbg_string S1, S2, S4, cipherin;
@@ -459,9 +453,7 @@ static int drbg_ctr_df(struct drbg_state
 		 */
 		drbg_cpu_to_be32(i, iv);
 		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
-		ret = drbg_ctr_bcc(drbg, temp + templen, K, &bcc_list);
-		if (ret)
-			goto out;
+		drbg_ctr_bcc(drbg, temp + templen, K, &bcc_list);
 		/* 10.4.2 step 9.3 */
 		i++;
 		templen += drbg_blocklen(drbg);
@@ -482,9 +474,7 @@ static int drbg_ctr_df(struct drbg_state
 		 * implicit as the key is only drbg_blocklen in size based on
 		 * the implementation of the cipher function callback
 		 */
-		ret = drbg_kcapi_sym(drbg, X, &cipherin);
-		if (ret)
-			goto out;
+		drbg_kcapi_sym(drbg, X, &cipherin);
 		blocklen = (drbg_blocklen(drbg) <
 				(bytes_to_return - generated_len)) ?
 			    drbg_blocklen(drbg) :
@@ -494,13 +484,10 @@ static int drbg_ctr_df(struct drbg_state
 		generated_len += blocklen;
 	}
 
-	ret = 0;
-
-out:
 	memset(iv, 0, drbg_blocklen(drbg));
 	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
 	memset(pad, 0, drbg_blocklen(drbg));
-	return ret;
+	return 0;
 }
 
 /*
@@ -1806,15 +1793,14 @@ static void drbg_kcapi_symsetkey(struct
 	crypto_cipher_setkey(tfm, key, (drbg_keylen(drbg)));
 }
 
-static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
-			  const struct drbg_string *in)
+static void drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
+			   const struct drbg_string *in)
 {
 	struct crypto_cipher *tfm = drbg->priv_data;
 
 	/* there is only component in *in */
 	BUG_ON(in->len < drbg_blocklen(drbg));
 	crypto_cipher_encrypt_one(tfm, outval, in->buf);
-	return 0;
 }
 
 static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,

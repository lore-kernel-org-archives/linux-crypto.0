Received: from sonic303-21.consmr.mail.ne1.yahoo.com (sonic303-21.consmr.mail.ne1.yahoo.com [66.163.188.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF5723A9BD
	for <linux-crypto@vger.kernel.org>; Sat, 21 Mar 2026 10:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.188.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774089203; cv=none; b=s9FtDn++aIeggcCLJepMY+XwGGcc5JRGqlNWq6JTMi65wgwuvv/xMfk/OYlvF5jZYmDwuWJzPHYhPqWldqXjzfggb6rkOuByS+Ty5zBBklaS8N1eD+g8vnjVF5NatkH2nsGKWMFWI2DMKkHoPHmsgxl3kni9tG2cZDHiEfVMtkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774089203; c=relaxed/simple;
	bh=QxRZ0DTQPVXAQ3BNzMunAYutI4LSpaiYDcE5CzlhsiE=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type:
	 References; b=ciaBTdoELddqVoYUPlEPI/cN0VnXhr+5M7PbaKZh0D2JgiNlc8Udzajlus1yRvIm/zdp8JCtxhXmvtGN8EilwWerdCpm7CZs/Lxv3QLado0Wr4jOtwQgOQyhRVdbQDligWushBiBi9sW+T7pjEHL6o3zdGsfDUS4c4+QW9t0I9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=fNt3DJQT; arc=none smtp.client-ip=66.163.188.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="fNt3DJQT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1774089201; bh=gDFIVQgXXOFsYAbtaFi8+ZKjkQg6wNglJfPN8k5uJGQ=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=fNt3DJQTv9hYc8pCw8GM/Z2SqKl8dpKViQA+MvPvNOU+qFplq0m+2ma9djGivnPwQe5sbhiD0IBqXRsUBNHhcZx4/meJw3ev57cDfWGj5SdQz1c5WfKo5JNj60ndkFOSTP2ebBqTK1EJD0j+lh7XZyJsQvU21X/+VgWy26xT0hrt0vdAHyRNBVeiq48cCmZbfenfPLUNgNtmJXXPyd+xTHpRxwXQHGsZJaC8HW9gBjFdZBNzArDi1aU5lcmADaAA4oG6bKYJFP7Pxnp/vWX5FuMY1F1WSHezV0FLZYIVwW5kdwSdIyYeQauYAFd4hVE+fekKDcQxi0SvIk0VE4CcxQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1774089201; bh=Ki0YbEZo0cMOsfopskPWUoXOvM0Zewz5S4wVt1fLzRY=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=swAjAVoPAnlMM82Jto+fFd+eXhk9XPtRYHtqg2iKNhDwNsrmhuTxIDTFjRxDVYs0VRn1jWo9yrq0h9ULLJtPaRf4L1ueYe3ufHWAPWtH935btixkyq9gEd6Kry+9qAuvRcLhB2uai0NccROgfoohxgotGt/VApvFE0SCgDlpxI8NxAMqdRNfD80y6xLwIFvTla1Pjz8YHbWE+Cnk1bEg02I5OcsPxVdGRkNRRUn4SNZtrKyJxbaP1BnzPgfzPv3ZI77YI0JH4X1DNedCCP061mL82YkjbY/NJkfb2szkRrOsdsHtY9mQsyETVbM0+S9DGh0w+r+Ehopyl/KSau77fQ==
X-YMail-OSG: n53qOqgVM1kJyF5DjN5ujZxmL3qQ7NY08jxA4pSz7jSnxfdGBCn1YIX_lbANyWd
 hEk3d3h34b1CN8G3eo9Z4QsiHNLdZXYJ0e0loS_7J5qkEQ_4JZiF2Aw341pBw_gl.V5j0KFPZz6_
 UAxrYFbfN_GZe6aae4D90ZpRUBvpFRuG__4XFtA88Nx.8bU.4dz36ZN9c9Mor1uOvqQEiRM.x2nV
 WnRk7LnXgJP93tTAP9K.MP8vnT7NiJE0DfKjRWkxebX_VXdlPSrVF0tjKO168nu.PfiO8068QeaU
 yrC9wZWrbBEFc3au9EXhe4mGyqxYJhwbAxGdPV__f_TooYEZjOVaQ3ITTie4ooEOlW_ur0Xevxjj
 HFqSGxFoPMu1Spmj45u_FqtICoGOxsfWaB5XfQ6.V7xLzwkDnHf_Pn5MtFYEUU37.hsJ3os_46Lk
 _HkUC.XwGUDBOn_MoZ8EKYY7dYXB8eUBIuPk97.gINhp7JgxyZokslSBkBmG3n7xeKtXQFGhqZK3
 qsDq5baqDPg40nLcAWNWYFJnR71wLQo0Dczw4F_wVFFfP5BOtDYV6I_s51bp_B3nPj_8QqHLvmka
 4k2yb12a9wKk_yRCj2kmxAKVpbXn2KGs1nVX7jm6vp9I51yel.d40xvFm4Rm3LSIRqw_rLdCBuEf
 cAml0JZxVCZVs.qjTP9svSgzJp6vAN80skCQ8rkHTDSlMPO7qrs0OPIydWJHJ5vruZqH3pcGGAxQ
 8hVaLpgQVkmGyyjMtAmhJ3qgohh5bYTSxvnTpNlwUktde..hkMQ5xxBChkc_HfvHNdpi9gYTP8D5
 LwxUZyI1bLQmOgg5PgJDeKEIuwWUBG4L7GZ3N.gfGmQLYaccnBrqvkwCRKWZ_GtTWZUG7Nc9CMQX
 CS8HNcfbF9AFJmRwu9Ltvma3KKAUWsO3y.NOxejBDvgxu1XfNVsvCVcHf_..12dpuKoX0n0owgVz
 8WHKgiRPlS9HOsGOYxj5DM9s4Ox5qEiYK746kvHQ9SzE8XMjZBiO0TVyfOUTKlvf7iH_gEUm484Q
 cDw.ep4FXppH0huhKLVssYbpNOQObrGAe45EWL8oigj0ri.6M2fjvk8fUochL3dZBt6DHCQ5CSrT
 B0esAaHBtd23wJ0rtQtOkWfioEtrqu0yAjlNJzgtVvoE6LfORhmejKg1m3j4VZ9fbXRjG8zCsEDb
 XPqlL79nYxwLMrKz2AqAnu3DJf4iYgoF_7x4w2DxxEDXlRqcuxMwPKl4urRGcc5PYtxb4pT5AHr0
 fOybBWr6ShefG04.yNRR3QcXkyl4aGv7s5GdkptBD_XZFzEWiT68npShU78ZxT5WmOq3tA36F0fJ
 h.cAuACFn0xe.F1Pz4Hk8Tha_YnsIoS1WGdN1_utJ7pcYemW9rHYxgqB8kSxSeW5T9AzgG.LMK_m
 p110D1EU7_PSRMn_NL89q_6rWCKmwGP77uhjgItLYRd0Z4j.h0mYqK2HN4rrSUizKthxOfQb1SXk
 j8halnxTOPTAp6F4kEfiNKGSm4kSvgm81d.Nh6_FJ_4ZT1a_UNU3T7_QEj_NbK7FdQC8McTc8.bk
 DkrjUGvf72kRZDqDwjl_aRq7_KkBv_DX6908CXK3PLok00pc1F5gc6qR1ACXQmUJ.rAtljtPtAi8
 pOUrDGWnKStbsZw3EwY4EFx0mpl5PDo5o_2jmAgYq80pFF.W0SpUXbrRiu6AXfndEcmlPKF7ETq6
 hcjtx3UEvkkFbiOFrUY7V66N3hBceRL2B35wQCixkm8jkXWV1hswiyXgJeAUTayectyveGv8UNoC
 MS0UA5PKjXq_qORvxzLx41GkQpfGGT4CaYbyupbA7PP1rv1VPrOVbSR69TnLf1.wKNet.G.ugffM
 fgArUJ5gpEzSfsUZ6YEayLqxjSpcAfCqB3EalKJNuD9qKpjpGKcGsrkx_pGfaWCmIcRSfGu1Gncy
 _ZeG80ku8lYMCBiV4A44S_DKsqgErbcQKr83TcnbLA_ZFAWslvVhjhxPMzV.LnKheyf7VcoDk1n1
 zC9yUN.Qx_NrtC_8rMII_CpI_T5pdDzkH9JH38_P9V2iv49hyNZj0VyDdBiNYHeapaFbbdcexJQP
 coA9fou88oPeFdpKZNzmMYHgM3fU8P7S3TnLf4fGqlc03xX9k9fHQYpEh32xQGeKkM0jw0MFWXj_
 tOLoX5plbR5kP9TPGbI1cu2Z_mr4vuCgPS.WDWa61wcau_Lqat0CVlAe5b2Dw13MG74hh71HKWQA
 6lbNEE2BeHwYgnrZjZhT04GB3YUUqsbnNceClS_aVW4efnXQAJ8AdGuIF8Plg9L1kw3jer9Iy7E2
 51fg-
X-Sonic-MF: <namiltd@yahoo.com>
X-Sonic-ID: 3693f09b-a0eb-4367-9280-8b1cd6f6dedc
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Sat, 21 Mar 2026 10:33:21 +0000
Received: by hermes--production-ir2-bbcfb4457-pgdzr (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 6c2aff7931b32b6fdc01e31a35eab56e;
          Sat, 21 Mar 2026 10:23:08 +0000 (UTC)
Message-ID: <3a50ac0c-11bc-47c0-9e4c-c098c80ccde7@yahoo.com>
Date: Sat, 21 Mar 2026 11:23:06 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: pl
From: Mieczyslaw Nalewaj <namiltd@yahoo.com>
To: linux-crypto@vger.kernel.org
Subject: [PATCH v2] crypto: inside-secure/eip93 - add missing address
 terminator character
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <3a50ac0c-11bc-47c0-9e4c-c098c80ccde7.ref@yahoo.com>
X-Mailer: WebService/1.1.25380 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Add the missing > characters to the end of the email address

Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
---
drivers/crypto/inside-secure/eip93/eip93-aead.c | 2 +-
drivers/crypto/inside-secure/eip93/eip93-aead.h | 2 +-
drivers/crypto/inside-secure/eip93/eip93-aes.h | 2 +-
drivers/crypto/inside-secure/eip93/eip93-cipher.c | 2 +-
drivers/crypto/inside-secure/eip93/eip93-cipher.h | 2 +-
drivers/crypto/inside-secure/eip93/eip93-common.c | 2 +-
drivers/crypto/inside-secure/eip93/eip93-common.h | 2 +-
drivers/crypto/inside-secure/eip93/eip93-des.h | 2 +-
drivers/crypto/inside-secure/eip93/eip93-hash.c | 2 +-
drivers/crypto/inside-secure/eip93/eip93-hash.h | 2 +-
drivers/crypto/inside-secure/eip93/eip93-main.c | 2 +-
drivers/crypto/inside-secure/eip93/eip93-main.h | 2 +-
drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.c b/drivers/crypto/inside-secure/eip93/eip93-aead.c
index 1a08aed..2bbd0af 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-aead.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-aead.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 
 #include <crypto/aead.h>
diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.h b/drivers/crypto/inside-secure/eip93/eip93-aead.h
index e2fa8fd..d933a8f 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-aead.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-aead.h
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 #ifndef _EIP93_AEAD_H_
 #define _EIP93_AEAD_H_
diff --git a/drivers/crypto/inside-secure/eip93/eip93-aes.h b/drivers/crypto/inside-secure/eip93/eip93-aes.h
index 1d83d39..82064cc 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-aes.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-aes.h
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 #ifndef _EIP93_AES_H_
 #define _EIP93_AES_H_
diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.c b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
index 0713c71..7893c15 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 
 #include <crypto/aes.h>
diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.h b/drivers/crypto/inside-secure/eip93/eip93-cipher.h
index 6e2545e..47e4e84 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.h
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 #ifndef _EIP93_CIPHER_H_
 #define _EIP93_CIPHER_H_
diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index f4ad6be..6f14701 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 
 #include <crypto/aes.h>
diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.h b/drivers/crypto/inside-secure/eip93/eip93-common.h
index 80964cf..41c4378 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.h
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 
 #ifndef _EIP93_COMMON_H_
diff --git a/drivers/crypto/inside-secure/eip93/eip93-des.h b/drivers/crypto/inside-secure/eip93/eip93-des.h
index 74748df..53ffe0f 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-des.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-des.h
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 #ifndef _EIP93_DES_H_
 #define _EIP93_DES_H_
diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
index 2705855..84d3ff2 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2024
  *
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 
 #include <crypto/sha1.h>
diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.h b/drivers/crypto/inside-secure/eip93/eip93-hash.h
index 556f22f..29da18d 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.h
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 #ifndef _EIP93_HASH_H_
 #define _EIP93_HASH_H_
diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index b7fd979..743861d 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 
 #include <linux/atomic.h>
diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.h b/drivers/crypto/inside-secure/eip93/eip93-main.h
index 79b078f..990c240 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.h
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 #ifndef _EIP93_MAIN_H_
 #define _EIP93_MAIN_H_
diff --git a/drivers/crypto/inside-secure/eip93/eip93-regs.h b/drivers/crypto/inside-secure/eip93/eip93-regs.h
index 0490b8d..21556df 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-regs.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-regs.h
@@ -3,7 +3,7 @@
  * Copyright (C) 2019 - 2021
  *
  * Richard van Schagen <vschagen@icloud.com>
- * Christian Marangi <ansuelsmth@gmail.com
+ * Christian Marangi <ansuelsmth@gmail.com>
  */
 #ifndef REG_EIP93_H
 #define REG_EIP93_H
-- 
2.47.3

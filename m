Received: from sonic315-20.consmr.mail.ne1.yahoo.com (sonic315-20.consmr.mail.ne1.yahoo.com [66.163.190.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF75226AF4
	for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2026 11:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773573030; cv=none; b=WaIFfJDjWAkjOonJDAMWqFUs0q8jKKAHIgNwffZUfBiGw0OqFa920RkMD/B+Pl5Pyp0gwtvSk3d663905wBbiIhh/VczXUaSF8AVfO2chyOtMk8xrm0+ixBX8isvpDoEFJjKCpN0en+L6FJS0cUUVDrH9F+GkEpj1fuQPyB9H/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773573030; c=relaxed/simple;
	bh=aS5GbBubfBbaLNAGmU1VoEPSoZlYPwm+SYGygT6aMf8=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type:
	 References; b=QU9ygFltsNGbpVTlNianqZ+fChHFiDjGRW5KEwGUc5Da173MbF2K6jt8eiaPz8L1BE0RvnoEdKwClzGq11Dz8BtWyLngds3j6STPbQ3Yc26dTNKCpsiCHDWg9CVJ3r0sToytrL8W1CAivXQXA5i8hOVqn8GijNaE9sZozo/CgNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=XWE0hjwv; arc=none smtp.client-ip=66.163.190.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="XWE0hjwv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1773573022; bh=LTSXTfrERU3WJVqfFtHSwcgMwzHuTkBQ/QAiTrx3kPI=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=XWE0hjwv7eSFxjLEzq4lRaHy868Io0jW/66cNtX6C6pSAScgB2SBlODmZ3B3ZVyMoqE2CEQX8nHnjORogRQeuBSIR0neAlz7gCh6JnopbdFqVuzlgu8E1QxIk1h+FWLQN1DsUPw5JQQCoB6Fn5iVfp4/FKmf0jGAXl9kKif8CYwAKteVoBHmTuUowbIgflIikl58q90ZT+v5HMnSm2jNoWLajP1UrlbKqHFWwZF4jGPDkVZ4nJL8lysNix31th8DmV+okeM9j9ADx8+JoM0Q3qf60cectEjRJQImX8TOTl2XmQ8ENICFf+ZXgZnK1k3eL7OLJc2JwNUD6Q+ANaGAtg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1773573022; bh=N0oBY2STmz6zXQIdi/gk9j2LnhXZs5FeDU4vahdPxRF=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=sb4E+r7APN/l/uZweBipgRQIobNbJGbvc0MrWnW/Nrmj4Sgitn6ro9a+w1bp5zEDqv7dowSupTynEGqqzXg04KwrJiBr0ScYY/7UvqcAOJXYOlQtnp3n1PqGskIwTqNxgIRo6nlQh3CUdxP4y0mzuUljVvhiH5fMtsrEER/1w0jLlyw+or2uci473ZZm5qYERDqSqeHCmAhfmb313esb3/aAZqcSgS8ptx43zVJQQ012x4OTpR4xNQFOWCFG6wbv/OjOfbQFMETtiSD1eaLkTWSBCEEhbw9a0sCwq+JGcu57JNtS47y508sKrlP3Vw9aBzZc87Ci44Xn8OXJPUUihA==
X-YMail-OSG: 6hgG0QEVM1lJ2t04QPGWaxZ_vKYgITmm3PN8HusEfCi.1JMYGZbE8ew78._USTn
 bNgs1rK8CE0HEPriy_OWI0FEW_d21R5zANGn4lgOb1FuijqgmrUraK2zdPVGewFYho0IQhTExyL.
 f81AFwpYZMhE6ZhQbjUA5XVdTFlZr11bnnknQTN1xEWxjZEdLU0RPYdcIaqVRu7Fdy6FzqtZnFPU
 xDFrudPTt66XhR05mx3klmHo_6.CdGDqeWeYlcrIdth5iYHIqPLm8.MRhOiDo8C93TrApl3PVbKb
 s5uJezYUW4m3Eu3_QpSsbPZrbPUmG9v3wwjE_G84r2k35B5syuadPiSu99S1wGwEQt1OprfzHw.J
 GYQzWyJHykeiH5RZDbh_INh1dmFnUAv4pLTp0W9IZMS4PMmAizFDUA63xNhZGnRvaGNTqcfLaNGW
 vqIN7ntQ082gKRgyFLHxkim7ZO6ccchoFdxtjmobuxSjQRZIiNjgGEojeuxq5OMneqsN3YYXEU3i
 xZSFBPJZcZFd7XTd_cuVzq_ZEwYsTePRC3IXPAmsFsS_aVJc4VI1mmp25n7CxX_1wrUObM.AdAxD
 8v_qqvlqlOSZKWhMd1YCMnP6uimLHkf.kvyyauftKga72fSpdpg72kTZGIfb95tKs1Ho_1AfN3i6
 vcvRavtv_6yE42soDNG_ICn0q4r87P0UahM6AQPe24t5Snhl1rLUpaRg01.2MFBjmNeNtkPzLpD1
 KbsdPoKyghxXkPOkiIkTGjNXt_7TBIfFE3ASDIIuc5T8Tlw4KAiSkSF3SK5A70.5DF8Na2Ud_L.P
 kPvEb9KtBDEIp0wTGvn0yURpbQYxm0wyaDsoJ3vQK53OihniBKGC2Jwy2KaZIVPlmxCIAy16kOL1
 yiu3C3v7hmT4yUFjK6IGwVbQtWbuiWFlUg1GjKqNVEtENhq35W769wQ5jMOLi7BhEuzpc51STGDf
 1JzNnCoW_0U6d9KWoNsYB6rlv8cf529PGv_EWexao45LDR0iUdRZ6dTZm.K1MU04qGt2w7SxAl67
 JiAiHhTGsbIpoIsaW0zvMhq5Zuq7uw5sNKo20VFWFi5qX.BJkwQ0n9d9jYa1_NOe2DXPlU0_ipuQ
 VCQIXeDnExkncLYqnKsZeE7Ou47nTo5Hctwt3Fuc8uIXlZ.xkO_tzdN.41iCTyzDmuh1I.YALiG2
 kqljrYW8tysas2k41vUFmRdu05.UkbQhqsldcl8pUzQQHH1VIexQmR9LrUs02YJVE9Vf9a6Ur1q0
 L7_NZPuiHB97IjRVhugbCfAJYk8y5ixi6gYFRG45opQJHypGjI4RtaVlqNRfAYaOhwdYPoCM_jNu
 GK_eeyqHL_UgxrMOyGIOjWTRlvNCMq7IsMWuXRS.rlSreqe9Tt1U5OzwcdnEg2JLfge9xluPP8fs
 N8r83bqRp7NHiTtgAgwGYDALu_Do2owcY2Fyp6TTkTXl8wXapnkrysZogxGJMwOp758ruF5hm.lG
 E6NDxL4Quzl6vklsJ1wy59EzVPpCUm3V6mZKsxDCu_RoVuZUNeHS6ew9w.Lx9lp5DtxOri4LCA7E
 XDLA0NcpufEtETWZw.2uyoPXoAAvv0v3clDdgiFu4kqHjP7i.xU1PrW_wyGHkjZdFXojQmZMsE3R
 CH8M0r6mD5YdO0OBMnpDPTh5FrI6rhdLDhNK_j73aAvSMRB65fqB_FroMpEDJ8NPCaZ9SHdUJ.mf
 6N_pmZ3XRgaAd4krvDSvlaH00HYRXT_3oA0ixhhXMOdRg2IZp_ZDacKwlTTO0D7CVVMD56PIwFtp
 1Wo.rfCY8OgJJb_u.z9q4xaUFyI8Uosn.Eop7IjDUYItb57IsEnqThFAS4aR0LCb6cJKO4C9c0q3
 _HIpZte8qnILVchjraNBpEoHT_H9t_fczFu1Ij_1THe9_.7FL_SiC8g0S6RlbJGnINeZmJ74WrcI
 y.zdIW0Z3kAfpoFC2qAbI7WzkU4QT5DTkYqtDWk8Y6To6dkdXJJgP9xwxBNm8Irzeb0V4RxJAVKj
 LvrEUOCw3.OIAYflALQTsXXCjGc1ZiLulKI24CunmRwBi.gsdcQ93ETSFQWAOhNJCWIAPDC.Yeqc
 2kcafaWF6t5eyX0oHJsri2s8ZNvJjEnErkOzTOpXLm7tF6pJAfCfQTuKDplbUV29GVmw1Q4dbca3
 WH67T41HVoKdmZEefp24vzecCl1WPpfqgFnFcV6.ZH05GEpslQiBd0YaoTdTAMbypW9te_PhW2db
 ndgaa5oobBXp4VY9EvfEQIzeIu2tGI1_V6Pwn
X-Sonic-MF: <namiltd@yahoo.com>
X-Sonic-ID: bf211b43-56e0-4624-afec-9a53e36fbfd4
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Sun, 15 Mar 2026 11:10:22 +0000
Date: Sun, 15 Mar 2026 11:00:14 +0000 (UTC)
From: Mieczyslaw Nalewaj <namiltd@yahoo.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Message-ID: <952138005.1301417.1773572414707@mail.yahoo.com>
Subject: [PATCH] crypto: inside-secure/eip93 - add missing address
 terminator character
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <952138005.1301417.1773572414707.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.25297 YMailNovation

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

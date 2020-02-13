Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88413C2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 07:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6083B21734
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 07:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgBMHkN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 02:40:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729803AbgBMHkN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 02:40:13 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01D7bJBi114699
        for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2020 02:40:12 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y4qyak2ce-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2020 02:40:11 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Thu, 13 Feb 2020 07:40:10 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 13 Feb 2020 07:40:08 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01D7e7hc47054972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 07:40:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1524A42047;
        Thu, 13 Feb 2020 07:40:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE5B442042;
        Thu, 13 Feb 2020 07:40:06 +0000 (GMT)
Received: from funtu.home (unknown [9.152.224.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Feb 2020 07:40:06 +0000 (GMT)
Subject: [PATCH] crypto/testmgr: add selftests for paes-s390
References: <20191113105523.8007-4-freude@linux.ibm.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
X-Forwarded-Message-Id: <20191113105523.8007-4-freude@linux.ibm.com>
Date:   Thu, 13 Feb 2020 08:40:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20191113105523.8007-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 20021307-0012-0000-0000-0000038664AC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021307-0013-0000-0000-000021C2E6E2
Message-Id: <2391ff22-97be-bc6a-3650-3cade8a78393@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_01:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=901 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130059
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch enables the selftests for the s390 specific protected key
AES (PAES) cipher implementations:
  * cbc-paes-s390
  * ctr-paes-s390
  * ecb-paes-s390
  * xts-paes-s390
PAES is an AES cipher but with encrypted ('protected') key
material. However, the paes ciphers are able to derive an protected
key from clear key material with the help of the pkey kernel module.

So this patch now enables the generic AES tests for the paes
ciphers. Under the hood the setkey() functions rearrange the clear key
values as clear key token and so the pkey kernel module is able to
provide protected key blobs from the given clear key values. The
derived protected key blobs are then used within the paes cipers and
should produce the very same results as the generic AES implementation
with the clear key values.

The s390-paes cipher testlist entries are surrounded
by #if IS_ENABLED(CONFIG_CRYPTO_PAES_S390) because they don't
make any sense on non s390 platforms or without the PAES
cipher implementation.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
 crypto/testmgr.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 82513b6b0abd..6c4a98102825 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4156,6 +4156,15 @@ static const struct alg_test_desc alg_test_descs[] = {
             .cipher = __VECS(tf_cbc_tv_template)
         },
     }, {
+#if IS_ENABLED(CONFIG_CRYPTO_PAES_S390)
+        .alg = "cbc-paes-s390",
+        .fips_allowed = 1,
+        .test = alg_test_skcipher,
+        .suite = {
+            .cipher = __VECS(aes_cbc_tv_template)
+        }
+    }, {
+#endif
         .alg = "cbcmac(aes)",
         .fips_allowed = 1,
         .test = alg_test_hash,
@@ -4304,6 +4313,15 @@ static const struct alg_test_desc alg_test_descs[] = {
             .cipher = __VECS(tf_ctr_tv_template)
         }
     }, {
+#if IS_ENABLED(CONFIG_CRYPTO_PAES_S390)
+        .alg = "ctr-paes-s390",
+        .fips_allowed = 1,
+        .test = alg_test_skcipher,
+        .suite = {
+            .cipher = __VECS(aes_ctr_tv_template)
+        }
+    }, {
+#endif
         .alg = "cts(cbc(aes))",
         .test = alg_test_skcipher,
         .fips_allowed = 1,
@@ -4596,6 +4614,15 @@ static const struct alg_test_desc alg_test_descs[] = {
             .cipher = __VECS(xtea_tv_template)
         }
     }, {
+#if IS_ENABLED(CONFIG_CRYPTO_PAES_S390)
+        .alg = "ecb-paes-s390",
+        .fips_allowed = 1,
+        .test = alg_test_skcipher,
+        .suite = {
+            .cipher = __VECS(aes_tv_template)
+        }
+    }, {
+#endif
         .alg = "ecdh",
         .test = alg_test_kpp,
         .fips_allowed = 1,
@@ -5167,6 +5194,15 @@ static const struct alg_test_desc alg_test_descs[] = {
             .cipher = __VECS(tf_xts_tv_template)
         }
     }, {
+#if IS_ENABLED(CONFIG_CRYPTO_PAES_S390)
+        .alg = "xts-paes-s390",
+        .fips_allowed = 1,
+        .test = alg_test_skcipher,
+        .suite = {
+            .cipher = __VECS(aes_xts_tv_template)
+        }
+    }, {
+#endif
         .alg = "xts4096(paes)",
         .test = alg_test_null,
         .fips_allowed = 1,
-- 
2.17.1


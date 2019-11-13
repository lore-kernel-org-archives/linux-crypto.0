Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B125C17447
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 10:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E82B3222C2
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 10:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfKMKzm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 05:55:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26818 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726165AbfKMKzm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 05:55:42 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADAn2vB061537
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2019 05:55:41 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8et3v3yg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2019 05:55:40 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Wed, 13 Nov 2019 10:55:38 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 10:55:37 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADAtZBu45678618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 10:55:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 973834204F;
        Wed, 13 Nov 2019 10:55:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 593C242042;
        Wed, 13 Nov 2019 10:55:35 +0000 (GMT)
Received: from funtu.com (unknown [9.152.224.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 10:55:35 +0000 (GMT)
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     ebiggers@kernel.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: [PATCH 1/3] s390/pkey: Add support for key blob with clear key value
Date:   Wed, 13 Nov 2019 11:55:21 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113105523.8007-1-freude@linux.ibm.com>
References: <20191113105523.8007-1-freude@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111310-0028-0000-0000-000003B68195
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111310-0029-0000-0000-0000247988C6
Message-Id: <20191113105523.8007-2-freude@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130102
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for a new key blob format to the
pkey kernel module. The new key blob comprises a clear
key value together with key type information.

The implementation tries to derive an protected key
from the blob with the clear key value inside with
1) the PCKMO instruction. This may fail as the LPAR
   profile may disable this way.
2) Generate an CCA AES secure data key with exact the
   clear key value. This requires to have a working
   crypto card in CCA Coprocessor mode. Then derive
   an protected key from the CCA AES secure key again
   with the help of a working crypto card in CCA mode.
If both way fail, the transformation of the clear key
blob into a protected key will fail. For the PAES cipher
this would result in a failure at setkey() invocation.

A clear key value exposed in main memory is a security
risk. The intention of this new 'clear key blob' support
for pkey is to provide self-tests for the PAES cipher key
implementation. These known answer tests obviously need
to be run with well known key values. So with the clear
key blob format there is a way to provide knwon answer
tests together with an pkey clear key blob for the
in-kernel self tests done at cipher registration.

Reference-ID: SEC1918
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/s390/crypto/pkey_api.c       | 60 +++++++++++++++++++++++++---
 drivers/s390/crypto/zcrypt_ccamisc.h |  1 +
 2 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 9de3d46b3253..1f3dfcc837bf 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -71,6 +71,17 @@ struct protaeskeytoken {
 	u8  protkey[MAXPROTKEYSIZE]; /* the protected key blob */
 } __packed;
 
+/* inside view of a clear key token (type 0x00 version 0x02) */
+struct clearaeskeytoken {
+	u8  type;	 /* 0x00 for PAES specific key tokens */
+	u8  res0[3];
+	u8  version;	 /* 0x02 for clear AES key token */
+	u8  res1[3];
+	u32 keytype;	 /* key type, one of the PKEY_KEYTYPE values */
+	u32 len;	 /* bytes actually stored in clearkey[] */
+	u8  clearkey[0]; /* clear key value */
+} __packed;
+
 /*
  * Create a protected key from a clear key value.
  */
@@ -305,26 +316,63 @@ static int pkey_verifyprotkey(const struct pkey_protkey *protkey)
 static int pkey_nonccatok2pkey(const u8 *key, u32 keylen,
 			       struct pkey_protkey *protkey)
 {
+	int rc = -EINVAL;
 	struct keytoken_header *hdr = (struct keytoken_header *)key;
-	struct protaeskeytoken *t;
 
 	switch (hdr->version) {
-	case TOKVER_PROTECTED_KEY:
-		if (keylen != sizeof(struct protaeskeytoken))
-			return -EINVAL;
+	case TOKVER_PROTECTED_KEY: {
+		struct protaeskeytoken *t;
 
+		if (keylen != sizeof(struct protaeskeytoken))
+			goto out;
 		t = (struct protaeskeytoken *)key;
 		protkey->len = t->len;
 		protkey->type = t->keytype;
 		memcpy(protkey->protkey, t->protkey,
 		       sizeof(protkey->protkey));
+		rc = pkey_verifyprotkey(protkey);
+		break;
+	}
+	case TOKVER_CLEAR_KEY: {
+		struct clearaeskeytoken *t;
+		struct pkey_clrkey ckey;
+		struct pkey_seckey skey;
 
-		return pkey_verifyprotkey(protkey);
+		if (keylen < sizeof(struct clearaeskeytoken))
+			goto out;
+		t = (struct clearaeskeytoken *)key;
+		if (keylen != sizeof(*t) + t->len)
+			goto out;
+		if ((t->keytype == PKEY_KEYTYPE_AES_128 && t->len == 16)
+		    || (t->keytype == PKEY_KEYTYPE_AES_192 && t->len == 24)
+		    || (t->keytype == PKEY_KEYTYPE_AES_256 && t->len == 32))
+			memcpy(ckey.clrkey, t->clearkey, t->len);
+		else
+			goto out;
+		/* try direct way with the PCKMO instruction */
+		rc = pkey_clr2protkey(t->keytype, &ckey, protkey);
+		if (rc == 0)
+			break;
+		/* PCKMO failed, so try the CCA secure key way */
+		rc = cca_clr2seckey(0xFFFF, 0xFFFF, t->keytype,
+				    ckey.clrkey, skey.seckey);
+		if (rc == 0)
+			rc = pkey_skey2pkey(skey.seckey, protkey);
+		/* now we should really have an protected key */
+		if (rc == 0)
+			break;
+		DEBUG_ERR("%s unable to build protected key from clear",
+			  __func__);
+		break;
+	}
 	default:
 		DEBUG_ERR("%s unknown/unsupported non-CCA token version %d\n",
 			  __func__, hdr->version);
-		return -EINVAL;
+		rc = -EINVAL;
 	}
+
+out:
+	return rc;
 }
 
 /*
diff --git a/drivers/s390/crypto/zcrypt_ccamisc.h b/drivers/s390/crypto/zcrypt_ccamisc.h
index 77b6cc7b8f82..3a9876d5ab0e 100644
--- a/drivers/s390/crypto/zcrypt_ccamisc.h
+++ b/drivers/s390/crypto/zcrypt_ccamisc.h
@@ -19,6 +19,7 @@
 
 /* For TOKTYPE_NON_CCA: */
 #define TOKVER_PROTECTED_KEY	0x01 /* Protected key token */
+#define TOKVER_CLEAR_KEY	0x02 /* Clear key token */
 
 /* For TOKTYPE_CCA_INTERNAL: */
 #define TOKVER_CCA_AES		0x04 /* CCA AES key token */
-- 
2.17.1


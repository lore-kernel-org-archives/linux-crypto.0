Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82675C433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Sep 2021 08:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B5B6127B
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Sep 2021 08:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243875AbhIRIJQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Sep 2021 04:09:16 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:38468 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243903AbhIRIJP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Sep 2021 04:09:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0Uom.fo5_1631952458;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Uom.fo5_1631952458)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 16:07:39 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Elvira Khabirova <e.khabirova@omp.ru>,
        Vitaly Chikunov <vt@altlinux.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Gilad Ben-Yossef" <gilad@benyossef.com>,
        Pascal van Leeuwen <pvanleeuwen@rambus.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v4 1/2] pkcs7: parser support SM2 and SM3 algorithms combination
Date:   Sat, 18 Sep 2021 16:07:36 +0800
Message-Id: <20210918080737.17252-2-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20210918080737.17252-1-tianjia.zhang@linux.alibaba.com>
References: <20210918080737.17252-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Support parsing the message signature of the SM2 and SM3 algorithm
combination. This group of algorithms has been well supported. One
of the main users is module signature verification.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 6592279d839a..24e2e4a6d842 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -248,6 +248,9 @@ int pkcs7_sig_note_digest_algo(void *context, size_t hdrlen,
 	case OID_sha224:
 		ctx->sinfo->sig->hash_algo = "sha224";
 		break;
+	case OID_sm3:
+		ctx->sinfo->sig->hash_algo = "sm3";
+		break;
 	default:
 		printk("Unsupported digest algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
@@ -277,6 +280,10 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 		ctx->sinfo->sig->pkey_algo = "ecdsa";
 		ctx->sinfo->sig->encoding = "x962";
 		break;
+	case OID_SM2_with_SM3:
+		ctx->sinfo->sig->pkey_algo = "sm2";
+		ctx->sinfo->sig->encoding = "raw";
+		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
-- 
2.19.1.3.ge56e4f7


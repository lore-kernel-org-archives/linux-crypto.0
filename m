Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7C0CCA47E
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 09:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiF0JV4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 05:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiF0JVu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 05:21:50 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD79E63C9;
        Mon, 27 Jun 2022 02:21:48 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VHX6j2d_1656321705;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VHX6j2d_1656321705)
          by smtp.aliyun-inc.com;
          Mon, 27 Jun 2022 17:21:46 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Elvira Khabirova <e.khabirova@omp.ru>,
        Vitaly Chikunov <vt@altlinux.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v4 2/2 RESEND] pkcs7: support EC-RDSA/streebog in SignerInfo
Date:   Mon, 27 Jun 2022 17:21:42 +0800
Message-Id: <20220627092142.21095-3-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220627092142.21095-1-tianjia.zhang@linux.alibaba.com>
References: <20220627092142.21095-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Elvira Khabirova <e.khabirova@omp.ru>

Allow using EC-RDSA/streebog in pkcs7 certificates in a similar way
to how it's done in the x509 parser.

This is needed e.g. for loading kernel modules signed with EC-RDSA.

Signed-off-by: Elvira Khabirova <e.khabirova@omp.ru>
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 24e2e4a6d842..277482bb1777 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -251,6 +251,12 @@ int pkcs7_sig_note_digest_algo(void *context, size_t hdrlen,
 	case OID_sm3:
 		ctx->sinfo->sig->hash_algo = "sm3";
 		break;
+	case OID_gost2012Digest256:
+		ctx->sinfo->sig->hash_algo = "streebog256";
+		break;
+	case OID_gost2012Digest512:
+		ctx->sinfo->sig->hash_algo = "streebog512";
+		break;
 	default:
 		printk("Unsupported digest algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
@@ -284,6 +290,11 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 		ctx->sinfo->sig->pkey_algo = "sm2";
 		ctx->sinfo->sig->encoding = "raw";
 		break;
+	case OID_gost2012PKey256:
+	case OID_gost2012PKey512:
+		ctx->sinfo->sig->pkey_algo = "ecrdsa";
+		ctx->sinfo->sig->encoding = "raw";
+		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
-- 
2.24.3 (Apple Git-128)


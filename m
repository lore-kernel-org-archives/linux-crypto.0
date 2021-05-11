Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFEAC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 14:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8AF613CD
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 14:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhEKO5D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 10:57:03 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:37372 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbhEKO5D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 10:57:03 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2021 10:57:02 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 5209420C1E1A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Date:   Tue, 11 May 2021 17:47:44 +0300
From:   Elvira Khabirova <e.khabirova@omp.ru>
To:     <keyrings@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <dhowells@redhat.com>, <vt@altlinux.org>
Subject: [PATCH] pkcs7: support EC-RDSA/streebog in SignerInfo
Message-ID: <20210511174744.4f3c6c59@msk1wst204>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1903.lancloud.ru (fd00:f066::73)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow using EC-RDSA/streebog in pkcs7 certificates in a similar way
to how it's done in the x509 parser.

This is needed e.g. for loading kernel modules signed with EC-RDSA.

Signed-off-by: Elvira Khabirova <e.khabirova@omp.ru>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 967329e0a07b..39c260a04167 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -248,6 +248,12 @@ int pkcs7_sig_note_digest_algo(void *context, size_t hdrlen,
 	case OID_sha224:
 		ctx->sinfo->sig->hash_algo = "sha224";
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
@@ -269,6 +275,11 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 		ctx->sinfo->sig->pkey_algo = "rsa";
 		ctx->sinfo->sig->encoding = "pkcs1";
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
2.25.1


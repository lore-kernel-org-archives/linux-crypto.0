Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B454C001DF
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 18:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjJVSXK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 14:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjJVSW4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 14:22:56 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB8210D0
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 11:22:52 -0700 (PDT)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AAC693FFE9
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 18:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1697998963;
        bh=eYf+t+El9qBlaiw5wPUd9OUTW1C9eNGz0+xZv0WFeT0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=eoBwSQAV2jc9lvUuO6XuUtM11av8szafNo8pPQIx/9niJJ06BJvUx67ZWWIHUdN5b
         KReGpTAMppQ0Jymn8IIrI12jPjitKciaaJmEHWPki5FXbTImei0RvZm0RnccooW4zf
         A7bPrhqSC236gg6E23fi4YiUBnzyreLJ5zKXHlWNkIANrrXGx5nzuYll27oDgk5X96
         2N2PZZa/Z7Y9lFW5k+LktnsFZQZIgx4eWHml114KLQKjQ7iN9HB9zEA2KEsBJUzc3n
         7AzmdBaIzHYw+UxrrUgWJqOO+pxlDFh0W7SbKrcYpb9PGeTrsBR4UrZdBXusOIxr8L
         XNH8XgUO6DulQ==
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32dd782e2d1so1255034f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 11:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697998963; x=1698603763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eYf+t+El9qBlaiw5wPUd9OUTW1C9eNGz0+xZv0WFeT0=;
        b=xASV3WaSy/NVFzeaHxXMmbWHbeBR0pNYEz3cSWWSjXz26dv7OZrFLqNfLOeCRNNU6O
         CDjuzop8qyim3R3Byl+m9GTvaFx+JZuJao2mFjm8sLRcwrVmATNTgU+2DSuE3ot/agz8
         xtCan/bqr/1bbLgpS4pzLCe3mWq+XBY3PyuP3X1VUCD9SEb6evmlqfBShcBX3LzxCgR4
         qYIxfZLEChOx2QE+us0laTojwWLIllfUGIvkFmcyK0aibKHnpYWNNXtnkpw3UpBt2e3i
         Hm/9P2PZZh1Ixfv9+Opfl9sIQ/AJVI4gtrr95HnRoXVdsPyp0LUa9BuTHDkC2weHiXje
         Y27A==
X-Gm-Message-State: AOJu0YxskklKe/57gvMJc5fQj56l0IGNQRA9y2I1Pv141k1wQNyA8/Bn
        frk1NW8YJYday1o4aN8MNtHmrV0ATsXvlQS2HgmxuLUpUW6z0bdbqhVkPhFvXr/4Vk0JyHHc59n
        jv6TWAlx53+N/FJoRNPRe9ncwjeRujfv9Nq+dBbgJRQ==
X-Received: by 2002:a05:6000:1183:b0:313:f463:9d40 with SMTP id g3-20020a056000118300b00313f4639d40mr3828257wrx.65.1697998962877;
        Sun, 22 Oct 2023 11:22:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7qAP+4YfSJntn9JV5vYJgPooPDtZyiLr3U9fc40TZZa0J1KRatDzDmqR1M8L1F9Pg36Jk5w==
X-Received: by 2002:a05:6000:1183:b0:313:f463:9d40 with SMTP id g3-20020a056000118300b00313f4639d40mr3828248wrx.65.1697998962650;
        Sun, 22 Oct 2023 11:22:42 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id y5-20020adff145000000b0031fd849e797sm6100729wro.105.2023.10.22.11.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Oct 2023 11:22:42 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     herbert@gondor.apana.org.au, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: [PATCH 4/6] crypto: x509 pkcs7 - allow FIPS 202 SHA-3 signatures
Date:   Sun, 22 Oct 2023 19:22:06 +0100
Message-Id: <20231022182208.188714-5-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231022182208.188714-1-dimitri.ledkov@canonical.com>
References: <20231022182208.188714-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add FIPS 202 SHA-3 hash signature support in x509 certificates, pkcs7
signatures, and authenticode signatures. Supports hashes of size 256
and up, as 224 is too weak for any practical purposes.

Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 crypto/asymmetric_keys/mscode_parser.c    |  9 +++++++++
 crypto/asymmetric_keys/pkcs7_parser.c     | 12 ++++++++++++
 crypto/asymmetric_keys/public_key.c       |  5 ++++-
 crypto/asymmetric_keys/x509_cert_parser.c | 24 +++++++++++++++++++++++
 4 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
index 855cbc46a9..05402ef896 100644
--- a/crypto/asymmetric_keys/mscode_parser.c
+++ b/crypto/asymmetric_keys/mscode_parser.c
@@ -84,6 +84,15 @@ int mscode_note_digest_algo(void *context, size_t hdrlen,
 	case OID_sha512:
 		ctx->digest_algo = "sha512";
 		break;
+	case OID_sha3_256:
+		ctx->digest_algo = "sha3-256";
+		break;
+	case OID_sha3_384:
+		ctx->digest_algo = "sha3-384";
+		break;
+	case OID_sha3_512:
+		ctx->digest_algo = "sha3-512";
+		break;
 
 	case OID__NR:
 		sprint_oid(value, vlen, buffer, sizeof(buffer));
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index ab647cb4d7..5b08c50722 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -248,6 +248,15 @@ int pkcs7_sig_note_digest_algo(void *context, size_t hdrlen,
 	case OID_gost2012Digest512:
 		ctx->sinfo->sig->hash_algo = "streebog512";
 		break;
+	case OID_sha3_256:
+		ctx->sinfo->sig->hash_algo = "sha3-256";
+		break;
+	case OID_sha3_384:
+		ctx->sinfo->sig->hash_algo = "sha3-384";
+		break;
+	case OID_sha3_512:
+		ctx->sinfo->sig->hash_algo = "sha3-512";
+		break;
 	default:
 		printk("Unsupported digest algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
@@ -273,6 +282,9 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 	case OID_id_ecdsa_with_sha256:
 	case OID_id_ecdsa_with_sha384:
 	case OID_id_ecdsa_with_sha512:
+	case OID_id_ecdsa_with_sha3_256:
+	case OID_id_ecdsa_with_sha3_384:
+	case OID_id_ecdsa_with_sha3_512:
 		ctx->sinfo->sig->pkey_algo = "ecdsa";
 		ctx->sinfo->sig->encoding = "x962";
 		break;
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 5bf0452c17..8eeab38a3d 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -119,7 +119,10 @@ software_key_determine_akcipher(const struct public_key *pkey,
 		if (strcmp(hash_algo, "sha224") != 0 &&
 		    strcmp(hash_algo, "sha256") != 0 &&
 		    strcmp(hash_algo, "sha384") != 0 &&
-		    strcmp(hash_algo, "sha512") != 0)
+		    strcmp(hash_algo, "sha512") != 0 &&
+		    strcmp(hash_algo, "sha3-256") != 0 &&
+		    strcmp(hash_algo, "sha3-384") != 0 &&
+		    strcmp(hash_algo, "sha3-512") != 0)
 			return -EINVAL;
 	} else if (strcmp(pkey->pkey_algo, "sm2") == 0) {
 		if (strcmp(encoding, "raw") != 0)
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 68ef1ffbbe..487204d394 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -214,6 +214,18 @@ int x509_note_sig_algo(void *context, size_t hdrlen, unsigned char tag,
 		ctx->cert->sig->hash_algo = "sha224";
 		goto rsa_pkcs1;
 
+	case OID_id_rsassa_pkcs1_v1_5_with_sha3_256:
+		ctx->cert->sig->hash_algo = "sha3-256";
+		goto rsa_pkcs1;
+
+	case OID_id_rsassa_pkcs1_v1_5_with_sha3_384:
+		ctx->cert->sig->hash_algo = "sha3-384";
+		goto rsa_pkcs1;
+
+	case OID_id_rsassa_pkcs1_v1_5_with_sha3_512:
+		ctx->cert->sig->hash_algo = "sha3-512";
+		goto rsa_pkcs1;
+
 	case OID_id_ecdsa_with_sha224:
 		ctx->cert->sig->hash_algo = "sha224";
 		goto ecdsa;
@@ -230,6 +242,18 @@ int x509_note_sig_algo(void *context, size_t hdrlen, unsigned char tag,
 		ctx->cert->sig->hash_algo = "sha512";
 		goto ecdsa;
 
+	case OID_id_ecdsa_with_sha3_256:
+		ctx->cert->sig->hash_algo = "sha3-256";
+		goto ecdsa;
+
+	case OID_id_ecdsa_with_sha3_384:
+		ctx->cert->sig->hash_algo = "sha3-384";
+		goto ecdsa;
+
+	case OID_id_ecdsa_with_sha3_512:
+		ctx->cert->sig->hash_algo = "sha3-512";
+		goto ecdsa;
+
 	case OID_gost2012Signature256:
 		ctx->cert->sig->hash_algo = "streebog256";
 		goto ecrdsa;
-- 
2.34.1


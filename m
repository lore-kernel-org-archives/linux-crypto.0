Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A5FC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Apr 2022 10:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiDKKtb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Apr 2022 06:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345742AbiDKKt2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Apr 2022 06:49:28 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C15943EE3
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 03:47:15 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r66so13850191pgr.3
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 03:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T2tpQeswcKujfVdwIoHw1RfrV9uib5LWkvVd7zn6J2E=;
        b=CVqR85YK0kV1ew5YUb3MKn+PwqC2RZOKHCbao+qgSvMsIETamGFD9jCgpWNEtN4C6k
         H+RQP9uMXjyo2wdqC6/aN2iyj28Ans+K9/6FrjtHKaua2079TiC1j024zPO37h0HS/Cy
         q3DtobvPoZzMU2wUk6X8HfMYTDfPJgEcTzKA6QZHRNOzU0YUiYrXVH+EydNk/MdWRYom
         Gi0/CD5X0ZI3Q6qVX88MHAJr9DDgUWy9xZNM6bmkR0aZfZgF688948+SR42xez+1w5yw
         L1ydr7fmLrGBuSkaUMgO6fpcyqj0qQD7qCjxathDC782+hCBUb+FOBT2a8RXM54zLNid
         t24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T2tpQeswcKujfVdwIoHw1RfrV9uib5LWkvVd7zn6J2E=;
        b=NlzH5H+WYk8tReoK4Xu5HnLpSFV6PZBpLaDDGwmRBeD1z3/YQNwB3/CZfIEGCEL8Yk
         hNDBMawDSXIYEXn5FR8jxtzKx61jouRaDtSsirV+4Jd5+v8DS3NNGZziM3sFqJabTheD
         kkc48HMbacbFxJf56ryy22dHljKuaODBMqKjGwwZcx3h0O4AG2zQyB5x1hDJ5SzqPBG1
         eNimWKxbGjZyJZPH6c4a1aRJNAkiA0JrCZm0a+4nxMvWpBE8VLI4xW8PvHxmDAORV+54
         CCj7o5PrtrbxWDoFceGO05GU8k49JKVXYu0Kreo1X5vwEctQ5h+p1rC7BMKYt8B23Tv8
         GrRg==
X-Gm-Message-State: AOAM531+B8iD0H9T+HcCCxoxyGpPKzFFUrCGA4MWoDtb8cfN2k2KRk5M
        AEBtD1Qbs7RrdmcOTJ8y4XJC8g==
X-Google-Smtp-Source: ABdhPJywzB2A8MdeFTx2U2wbcJIYP/g1Ica6qEgtJFifufvGAHLRLpTSa7YMRA+izmFa0y09OLt/eQ==
X-Received: by 2002:a63:1141:0:b0:39c:b664:c508 with SMTP id 1-20020a631141000000b0039cb664c508mr20204916pgr.49.1649674034556;
        Mon, 11 Apr 2022 03:47:14 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id d8-20020a636808000000b00398e9c7049bsm27541649pgc.31.2022.04.11.03.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:47:14 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     mst@redhat.com, berrange@redhat.com, arei.gonglei@huawei.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        cohuck@redhat.com, jasowang@redhat.com,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v4 2/8] crypto-akcipher: Introduce akcipher types to qapi
Date:   Mon, 11 Apr 2022 18:43:21 +0800
Message-Id: <20220411104327.197048-3-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411104327.197048-1-pizhenwei@bytedance.com>
References: <20220411104327.197048-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Lei He <helei.sig11@bytedance.com>

Introduce akcipher types, also include RSA related types.

Signed-off-by: Lei He <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 qapi/crypto.json | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/qapi/crypto.json b/qapi/crypto.json
index 1ec54c15ca..9e2b41fc82 100644
--- a/qapi/crypto.json
+++ b/qapi/crypto.json
@@ -540,3 +540,67 @@
   'data': { '*loaded': { 'type': 'bool', 'features': ['deprecated'] },
             '*sanity-check': 'bool',
             '*passwordid': 'str' } }
+##
+# @QCryptoAkCipherAlgorithm:
+#
+# The supported algorithms for asymmetric encryption ciphers
+#
+# @rsa: RSA algorithm
+#
+# Since: 7.1
+##
+{ 'enum': 'QCryptoAkCipherAlgorithm',
+  'prefix': 'QCRYPTO_AKCIPHER_ALG',
+  'data': ['rsa']}
+
+##
+# @QCryptoAkCipherKeyType:
+#
+# The type of asymmetric keys.
+#
+# Since: 7.1
+##
+{ 'enum': 'QCryptoAkCipherKeyType',
+  'prefix': 'QCRYPTO_AKCIPHER_KEY_TYPE',
+  'data': ['public', 'private']}
+
+##
+# @QCryptoRSAPaddingAlgorithm:
+#
+# The padding algorithm for RSA.
+#
+# @raw: no padding used
+# @pkcs1: pkcs1#v1.5
+#
+# Since: 7.1
+##
+{ 'enum': 'QCryptoRSAPaddingAlgorithm',
+  'prefix': 'QCRYPTO_RSA_PADDING_ALG',
+  'data': ['raw', 'pkcs1']}
+
+##
+# @QCryptoAkCipherOptionsRSA:
+#
+# Specific parameters for RSA algorithm.
+#
+# @hash-alg: QCryptoHashAlgorithm
+# @padding-alg: QCryptoRSAPaddingAlgorithm
+#
+# Since: 7.1
+##
+{ 'struct': 'QCryptoAkCipherOptionsRSA',
+  'data': { 'hash-alg':'QCryptoHashAlgorithm',
+            'padding-alg': 'QCryptoRSAPaddingAlgorithm'}}
+
+##
+# @QCryptoAkCipherOptions:
+#
+# The options that are available for all asymmetric key algorithms
+# when creating a new QCryptoAkCipher.
+#
+# Since: 7.1
+##
+{ 'union': 'QCryptoAkCipherOptions',
+  'base': { 'algorithm': 'QCryptoAkCipherAlgorithm' },
+  'discriminator': 'algorithm',
+  'data': { 'rsa': 'QCryptoAkCipherOptionsRSA' }}
-- 
2.20.1


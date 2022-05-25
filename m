Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF47C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 25 May 2022 09:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241165AbiEYJDg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 May 2022 05:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241136AbiEYJD2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 May 2022 05:03:28 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690C89159C
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 02:02:25 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-f2a4c51c45so4256809fac.9
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 02:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uCoch/x6X6GaFx847RkiWvXsBs1288biCvAs5otO4gM=;
        b=aobJVulBOZzcbpVKDzF2ZVCsT4tWetifPDFEjXyUcOdrdlqY6JaT3Kw5A4SNzdypem
         aH/r9nAlH9P1+2l48EUJ7RDvT0eCvPHRfl3qHFrJsk81/OSXQk8QMXpMTm6NEvsh5hiQ
         xTZI+k+LWFjzliO6m91SJyORyMA1RW7sBnENCuoILlnes+GZ9h//ZcThuN17Su31M1//
         kazkc8RHdpsWsZmQ6Q++tBXjziTNtxWAeviOq7sdb6kPBrTaGwbVqAOE32u646fLyhmW
         RHXo5JAqAmPBHcvxaae7q96PtVrnQ08hIMdytg7ka9eyHjfLuotje8Y73QeIUZPZSvUu
         ybyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uCoch/x6X6GaFx847RkiWvXsBs1288biCvAs5otO4gM=;
        b=tzag3J5alFuOgoWnvIsdBSsDSwzthki0N6ehwKkMGLrb8mb/Vh0zI+48Uq6XZO2E2q
         BA0FppWoGEM7MEtLqNlqBxbarb2yEwAiuQaUn/gVxbGQyWl2Q/UFVVSQsOmKsD+diPTM
         0TqTTnMbUx8HKNv6qRrWz0neKOqlEkCSQh7QdEbZWMTXPQPFxsjB7W4AqJEVcDHXl4ee
         nMPDtIdT/fL+73xwfALS9rnuMxuaW19lPeu+jqrxOM+w70UXeLiBMfCyz8AqQ3OnFrBm
         XZx0xMP8tgi/HVqIEXZz5BUkw3xbbg7c9OH3vfxUhsBDjh2gVRo5/d99va0EJR7u+kGZ
         5BUg==
X-Gm-Message-State: AOAM532xn/5TIF0McTaMpa1LKCl9vpaGfpZkuufZnpxvYwyc2wIx2ZrX
        YYnzYBCEhVNYljHYv4+c7QsMZqAyc0rNxw==
X-Google-Smtp-Source: ABdhPJylbk+hiyTklGYugfK4QYfrfcIF+SMgCYz05NGrspNl/V/D+6Z+mnfQxgzC8Br2LHsgpnfOnQ==
X-Received: by 2002:a17:90b:4b4b:b0:1dc:8724:3f75 with SMTP id mi11-20020a17090b4b4b00b001dc87243f75mr9161069pjb.178.1653469327588;
        Wed, 25 May 2022 02:02:07 -0700 (PDT)
Received: from FVFDK26JP3YV.usts.net ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090a6aca00b001deb92de665sm1015424pjm.46.2022.05.25.02.02.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 May 2022 02:02:07 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com, berrange@redhat.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, jasowang@redhat.com,
        cohuck@redhat.com, pizhenwei@bytedance.com,
        helei.sig11@bytedance.com
Subject: [PATCH 2/9] qapi: crypto-akcipher: Introduce akcipher types to qapi
Date:   Wed, 25 May 2022 17:01:11 +0800
Message-Id: <20220525090118.43403-3-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220525090118.43403-1-helei.sig11@bytedance.com>
References: <20220525090118.43403-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce akcipher types, also include RSA related types.

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Signed-off-by: Lei He <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 qapi/crypto.json | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/qapi/crypto.json b/qapi/crypto.json
index 1ec54c15ca..f7bb9a42d0 100644
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
+  'base': { 'alg': 'QCryptoAkCipherAlgorithm' },
+  'discriminator': 'alg',
+  'data': { 'rsa': 'QCryptoAkCipherOptionsRSA' }}
-- 
2.11.0


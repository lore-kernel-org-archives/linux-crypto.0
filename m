Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92638C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Apr 2022 14:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbiD1OIJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Apr 2022 10:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347911AbiD1OIC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Apr 2022 10:08:02 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE241B82D7
        for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2022 07:04:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n18so4445440plg.5
        for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2022 07:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ebyq3t0cku0JBJko0+i5+pZ5xMWPYwbiZj5xlzmmt5U=;
        b=Ewaj6GD+7ylmnl7Nek9NISo81xfEOut07vgy8s3rYiTDvsgLhHLZYC0i3FM+bIkrF9
         egJxdmCLlgMgh3msobyc33KZ+40c0Kr0X72uKjHSvmPApdqXjErVzyoJuP/t7Usddyxs
         V37gmYW40Qs3Pyb3fZqkT70FmE9grSf1HUSiF9gZ95EoAexvJ3y9q4s3gkm/HxzshGuf
         84FHRdEQ7c66VTWyITIZGlJL0u8a8joS8OsOdko7GDzvmQC2mKnZGM4XMAzFyc+aHGdh
         etU1YoD1+CfaiJjDubhco9bEvaUfILSIrCrRf5Yk7xbZLVD5aLbE6xrgDMc6g1LCyVEo
         F14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebyq3t0cku0JBJko0+i5+pZ5xMWPYwbiZj5xlzmmt5U=;
        b=LJ652XYDEocyxg4VGMa8d1C2KvDzxU5j+MUchOB/1+SgsxGXyetifX8Re9xMh17nAF
         K2EotdVwbk0F/TtY2G1k006xA6X+IIuGUIq1P65mKsFacuDV69wzWAf+AIqrSdNsehDC
         pC36Uezl/C36E1s98l/eP3E/OR5kWWZKwQZYGit2e6ApS1Z1X/9R5WYskzBRWBMKhxtU
         vEHGo8E1juRCCwNg3jy2gCbM6GMAjE3u7Xl/J0/Or0pF1XuVKEwuV2K2WDp8jFETt83L
         lHox9jCeJydqQNCXRInG40ns4PdfaH0rxNJjAMchwjBJXESwW1Mie1ILnLWl3b5jDfLo
         rn/g==
X-Gm-Message-State: AOAM530lck6qSVmFdrWiSaID+gBDLzWT/pi1XAYZS7JQ10p+KNRyTiv8
        8byDyhu87wSviJyzK/7tXthZUg==
X-Google-Smtp-Source: ABdhPJzFXOB4Yvy392O4Xx60+klDrMds8MRiFy7ceV16DQ5b0HI6aGVA1VUPZtKkkrvCgYvI8wN7vQ==
X-Received: by 2002:a17:90b:1b03:b0:1d2:a338:c568 with SMTP id nu3-20020a17090b1b0300b001d2a338c568mr50432960pjb.129.1651154669248;
        Thu, 28 Apr 2022 07:04:29 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id x129-20020a623187000000b0050835f6d6a1sm38975pfx.9.2022.04.28.07.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:04:28 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com, berrange@redhat.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v5 2/9] qapi: crypto-akcipher: Introduce akcipher types to qapi
Date:   Thu, 28 Apr 2022 21:59:36 +0800
Message-Id: <20220428135943.178254-3-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428135943.178254-1-pizhenwei@bytedance.com>
References: <20220428135943.178254-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Lei He <helei.sig11@bytedance.com>

Introduce akcipher types, also include RSA related types.

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Signed-off-by: Lei He <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 qapi/crypto.json | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
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
2.20.1


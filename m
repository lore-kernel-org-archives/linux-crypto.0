Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99037C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 14 May 2022 02:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiENCxo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 22:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiENCxi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 22:53:38 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A76335E4E1
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 17:59:26 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so12231233pjv.4
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 17:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ebyq3t0cku0JBJko0+i5+pZ5xMWPYwbiZj5xlzmmt5U=;
        b=MBM+xEUOV19dRN+3DfVQA7Wlr9RpJkVWY8j/eTWiojTA5dkgFe6+3neEqo7JubjKtV
         XvfkYqNg+NUWejB12xLuq45dBG/PbfdWWZQEf2YAOR0Pbekpj6/4D+RYIBkPT9FzuvA+
         gioijVsC0q1qEHfBkG5Tm2YnZXs26WH8kaZ4FlR0Yx2UnlQKH5o2kGS4J5jEzkDXDIXw
         xGCs+y+KcEdCFBkPdwpi4jPB7bmAFvrddCAvr6c3E5lxWG7Tj9FzCigYamlC2kK9xFpx
         6bWy/h0SVYsROsoEw+LtVwJ1//xKFkQM4l0cQhmpvPGCZMf+5EUVBhuKoqD3Tce/zpLb
         Kqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebyq3t0cku0JBJko0+i5+pZ5xMWPYwbiZj5xlzmmt5U=;
        b=irTF+tirUaBFmq0riOPif7KSwAaucZguYt2V7rEBgHnXrcYh+/D+we800oBA64Pfr/
         PmlZP1YDDDCxdOOcwHhXQ09bnzQJirW9a7yk7Zdul/6c55P/3ZvfxFQEvcNLMEoOFzeR
         VfAMj2Y/Yp3B5w1uNKJz1XEDiBle1ZkW+mKmmuGTi7KYrySSBOZT12AMKkQITyPf5+aP
         gY1F7D1Gp10dSSG7nrgxFgbyAqb66iWtsP+ymR8g6SdtZTzLhq+MHx/Lidyi4ZDMuGXv
         8Y+KZpsEwn3WqiS+6ZYiaeqAJtRFdgy/W/hxGroyaPW4+zjftkKmuwcvk9+p6UC5KYMr
         JmUQ==
X-Gm-Message-State: AOAM531+FyIRFbReDq6AzV88A7OzMrdQRPnZZ8sUeAFk2B4BpW+S34pv
        gCDNnSI8RUeNy9RbS/4AFqxdRA==
X-Google-Smtp-Source: ABdhPJzdAV0iF8UJoVcS0p3PX/NAJVEJigVxH/GqJRP+2QqddMhi0uaS33V2DwRh1MiMUMiE9fnl8A==
X-Received: by 2002:a17:90a:ee96:b0:1dc:6680:6f2d with SMTP id i22-20020a17090aee9600b001dc66806f2dmr7516683pjz.174.1652489966136;
        Fri, 13 May 2022 17:59:26 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id t24-20020a170902b21800b0015e8d4eb1dbsm2466125plr.37.2022.05.13.17.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 17:59:25 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com, berrange@redhat.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, pizhenwei@bytedance.com, cohuck@redhat.com
Subject: [PATCH v6 2/9] qapi: crypto-akcipher: Introduce akcipher types to qapi
Date:   Sat, 14 May 2022 08:54:57 +0800
Message-Id: <20220514005504.1042884-3-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220514005504.1042884-1-pizhenwei@bytedance.com>
References: <20220514005504.1042884-1-pizhenwei@bytedance.com>
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


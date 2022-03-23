Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7860C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 02:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiCWCyd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 22:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiCWCyc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 22:54:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D67B87A
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 19:53:03 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mm17-20020a17090b359100b001c6da62a559so5105279pjb.3
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 19:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sg3To/7UT7Td+uZYPu+oDeRZF15OaGdKfSNym1I4/hE=;
        b=4UFMN77XWGnYrRYUy3LKDWngeQjcECwfMkSuMWtxxC01Akzeu9rHwKC/nGRbsx3p+2
         VCxF52uasYyYrHRkyOh+UL7ZleClsNHlJIG/BgTX+n29BknYqaJXgHYex7zkFcJEnxWM
         s9dy6tEJouexU56Y7ZW51UabbJhg1PQIHTEBlWZ6yB2YbPwFblRZPeN9zCxo6ABbHmWD
         J4dYAVyp/ryWLppvP0GCLaSmmX8MhocgX0iU3QNHiSKEwHw8j+2vVXS5nXaelIXbmubL
         sJLeCDJMldX4Af4DaoOeTzzuNfhczd498hcReSq2TmrFmzcMq1F6xIgMagR9Fjp2CQe+
         PsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sg3To/7UT7Td+uZYPu+oDeRZF15OaGdKfSNym1I4/hE=;
        b=grT5cPV5rms86Hn0iaM9o0AflTmPOeoEFDC4gp5/VpCQsi6dognqi29+CqZoDW9XOV
         pmVkr8zvTaVKvD5DSeNW7R+tMmAn40H2qbKtrSQxqDiFxUnWj/ni0fOvDwvT2LgQenTX
         VopH87+gWGXSppGexrOaooLaXR9b9Dy+ZtMzZha+hjBqNY6fJlxJGeLIUE5K3S1jdGH0
         SKfu7QNPC/GusxLUVaj69lbTWVtwIyJ/7VSkJqSIxMpNKi64XuzGzNhFR+z3xMv1jVuH
         7uEZJ1oRc5biZ0RsYWfO2I+FKbhOCrYCscoUtOEexFlW+2c4Qzjoq5jYfuIq1UhAPak6
         Vaaw==
X-Gm-Message-State: AOAM533t0mXnNzjEHHV2LIWYensYLgSwi4HWc5pgoDVRbReUSGlnayI6
        OpNbJ3e7I1HlAhJmmOO7a45Rtg==
X-Google-Smtp-Source: ABdhPJzz4RA92uPgrSrtlvMjFp57uCew5sRe8hpZlNEi889wNBDUneICR+l2GiXixacITs4a6375sw==
X-Received: by 2002:a17:902:7049:b0:151:e52e:ae42 with SMTP id h9-20020a170902704900b00151e52eae42mr22231853plt.118.1648003982647;
        Tue, 22 Mar 2022 19:53:02 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id t2-20020a63a602000000b0038062a0bc6fsm18104869pge.67.2022.03.22.19.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 19:53:01 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        qemu-devel@nongnu.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, Lei He <helei.sig11@bytedance.com>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v3 2/6] crypto-akcipher: Introduce akcipher types to qapi
Date:   Wed, 23 Mar 2022 10:49:08 +0800
Message-Id: <20220323024912.249789-3-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323024912.249789-1-pizhenwei@bytedance.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Lei He <helei.sig11@bytedance.com>

Introduce akcipher types, also include RSA & ECDSA related types.

Signed-off-by: Lei He <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 qapi/crypto.json | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/qapi/crypto.json b/qapi/crypto.json
index 1ec54c15ca..d44c38e3b1 100644
--- a/qapi/crypto.json
+++ b/qapi/crypto.json
@@ -540,3 +540,89 @@
   'data': { '*loaded': { 'type': 'bool', 'features': ['deprecated'] },
             '*sanity-check': 'bool',
             '*passwordid': 'str' } }
+##
+# @QCryptoAkcipherAlgorithm:
+#
+# The supported algorithms for asymmetric encryption ciphers
+#
+# @rsa: RSA algorithm
+# @ecdsa: ECDSA algorithm
+#
+# Since: 7.0
+##
+{ 'enum': 'QCryptoAkcipherAlgorithm',
+  'prefix': 'QCRYPTO_AKCIPHER_ALG',
+  'data': ['rsa', 'ecdsa']}
+
+##
+# @QCryptoAkcipherKeyType:
+#
+# The type of asymmetric keys.
+#
+# Since: 7.0
+##
+{ 'enum': 'QCryptoAkcipherKeyType',
+  'prefix': 'QCRYPTO_AKCIPHER_KEY_TYPE',
+  'data': ['public', 'private']}
+
+##
+# @QCryptoRsaHashAlgorithm:
+#
+# The hash algorithm for RSA pkcs1 padding algothrim
+#
+# Since: 7.0
+##
+{ 'enum': 'QCryptoRsaHashAlgorithm',
+  'prefix': 'QCRYPTO_RSA_HASH_ALG',
+  'data': [ 'md2', 'md3', 'md4', 'md5', 'sha1', 'sha256', 'sha384', 'sha512', 'sha224' ]}
+
+##
+# @QCryptoRsaPaddingAlgorithm:
+#
+# The padding algorithm for RSA.
+#
+# @raw: no padding used
+# @pkcs1: pkcs1#v1.5
+#
+# Since: 7.0
+##
+{ 'enum': 'QCryptoRsaPaddingAlgorithm',
+  'prefix': 'QCRYPTO_RSA_PADDING_ALG',
+  'data': ['raw', 'pkcs1']}
+
+##
+# @QCryptoCurveId:
+#
+# The well-known curves, referenced from https://csrc.nist.gov/csrc/media/publications/fips/186/3/archive/2009-06-25/documents/fips_186-3.pdf
+#
+# Since: 7.0
+##
+{ 'enum': 'QCryptoCurveId',
+  'prefix': 'QCRYPTO_CURVE_ID',
+  'data': ['nist-p192', 'nist-p224', 'nist-p256', 'nist-p384', 'nist-p521']}
+
+##
+# @QCryptoRsaOptions:
+#
+# Specific parameters for RSA algorithm.
+#
+# @hash-algo: QCryptoRsaHashAlgorithm
+# @padding-algo: QCryptoRsaPaddingAlgorithm
+#
+# Since: 7.0
+##
+{ 'struct': 'QCryptoRsaOptions',
+  'data': { 'hash-algo':'QCryptoRsaHashAlgorithm',
+            'padding-algo': 'QCryptoRsaPaddingAlgorithm'}}
+
+##
+# @QCryptoEcdsaOptions:
+#
+# Specific parameter for ECDSA algorithm.
+#
+# @curve-id: QCryptoCurveId
+#
+# Since: 7.0
+##
+{ 'struct': 'QCryptoEcdsaOptions',
+  'data': { 'curve-id': 'QCryptoCurveId' }}
-- 
2.25.1


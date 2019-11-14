Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2956BC432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED88A2070E
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QzTOvJsU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKNOsf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 09:48:35 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55339 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfKNOse (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 09:48:34 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so5954666wmb.5;
        Thu, 14 Nov 2019 06:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2B2LpipVnpcikIQT0x1upjHHHGv7Y9LmS9XCwDXMgAk=;
        b=QzTOvJsUoxtW+SPuB8afNzO6eZZrc2SOdfCV0ACcBTuBEAcMOXqLF/nskjVebVDkyS
         BX3at3Hcvn7tTSNiAiodto6NtTirEPfXAcqEzetWCGqFahNxJNxJlV+84fzykRP6BeZF
         lh/gYiDte4hbIC6KK94Twg9ue+ejEsjUPBnTRRHlz98c/1MfkWcQcfMYf8IoioHMFwR7
         iSzpKj7p7VaPlkAgRhxVRedPzdDQWI3twMr320zX6QUgqWqiRstvHzYK/0VLuFZj7O8G
         8eJvGTjMoggxwYiwqhFotNXMqwRDn817oyWRxhb2GnBKuUSW+e6f022GCX9tC0fkQ/5l
         kLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2B2LpipVnpcikIQT0x1upjHHHGv7Y9LmS9XCwDXMgAk=;
        b=WLMBMgqMAJ6bMYy//6+/lzPBnOqn5reeLBf8nvLKXmtekF4Qsvp1zrNIFoqqXvXqBr
         3jhY+P/1Mv6S+MKXjOKO0BgZH3yuAYGrB3neJSoI37JwiVZnkLW8Nmh5VXIKDl/Rj/B3
         jTaIuqOyNhvVbzSFZbwQoKhf/Xf+1/VMcHLJW4eFk9ZYO6c/qvQRxBP+HQAyz5+ySFwA
         El7FcJG9EZIMlePMWCLOWvtHAfA32+C2acaQSANab68Wf6/1PW1GquqPvUTODCUexwRA
         CfpdAri/FXMfGkCHSbF9Msl9OrZ6O73KFJUNELscByKfe972Laohc6k4FdaTySu9D4rt
         U2zA==
X-Gm-Message-State: APjAAAXjMNoXopg/1U3bW2K4tfXK5U2L+Wfog1lFx1yTGvJxxk1Izo1B
        oS/l+DZyjsQtap1pJA3CiXk=
X-Google-Smtp-Source: APXvYqwVWKJ+CPBpdBrfIygTU0IjG98m6xBqS5XBMsByPkTK63A8CefzDxud1WiLu/6YFlckiteNRA==
X-Received: by 2002:a1c:650b:: with SMTP id z11mr8196107wmb.149.1573742912178;
        Thu, 14 Nov 2019 06:48:32 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id v9sm7153223wrs.95.2019.11.14.06.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 06:48:31 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/3] dt-bindings: crypto: add new compatible for A33 SecuritySystem
Date:   Thu, 14 Nov 2019 15:48:10 +0100
Message-Id: <20191114144812.22747-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114144812.22747-1-clabbe.montjoie@gmail.com>
References: <20191114144812.22747-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The A33 SecuritySystem has a difference with all other SS, it give SHA1 digest
directly in BE.
This difference need to be handlded by the driver and so need a new
compatible.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
index 80b3e7350a73..ae6dcfa795d1 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
@@ -23,6 +23,9 @@ properties:
       - items:
         - const: allwinner,sun7i-a20-crypto
         - const: allwinner,sun4i-a10-crypto
+      - items:
+        - const: allwinner,sun8i-a33-crypto
+        - const: allwinner,sun4i-a10-crypto
 
   reg:
     maxItems: 1
-- 
2.23.0


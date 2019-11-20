Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF86C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 15:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5397220679
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 15:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QnBKM8lF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbfKTP2l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 10:28:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45355 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728933AbfKTP2k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 10:28:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id z10so224442wrs.12;
        Wed, 20 Nov 2019 07:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mQbJHJ0ZZ045TuFFH0OpDkzJ7tdcb7RCVuOKVisaGsk=;
        b=QnBKM8lFYAgiDp8LfIkxVzinvXpIuyW56oFqGpbPPZxnkZU6XH+vxyVCg4qx0klXcJ
         CYSM3C86zWGfP4zpnLTSfEEKpOJq5/aJG9FThkC1/W3Zd4ehndtC/i/Jq567GL1owuFb
         6vucVz9yPAmXMzHNkZjRm0smO3K0bqeB2Y2ezetgaHphWqV969ZVtaf9L4SvENjkFfDz
         GLV7NMZSBi9CCjHgp0sz9NVftykvrK176B40j3lMgu22suhpXX1cjyGfVNw3Pb4xwgre
         UxM3g3jlZw7YWWFIF9AwhQEugdOL8xdWy+no+wLv4X2T6uXx5Nw5L1WUstUN9iBZ5Au+
         LLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mQbJHJ0ZZ045TuFFH0OpDkzJ7tdcb7RCVuOKVisaGsk=;
        b=JnHEPZkVhS0xFKrmxIzYh/KBtVi/v3RtGl/GwG4w19J2+LmY0zpqljVhlr6k13oTYm
         BuH4+6HUhCnDjY5o9mpo5fwdFhcl/MZq5r0svKX18w5j5cjY9Hu/GhwSvwimoEGXASnv
         K7BevgNSkFief3OMZxCeo1ObjcUSpGQwx3tlyiOg7gAnDrxS05YYjH9zY0PHQyREzbks
         zwqmDoIszwVgbh5D0NAJzS2zrT+bhjQvLfUf+JOsUIThTnCg2S+lXC/m4CB5AAJOMF01
         8ZkJlpSqxPx7Nsmz5+OhV2ovmT5PiQXcli+FMgqQx1VdDHzRtl/BVExxyM/U7m4DLJUr
         jftQ==
X-Gm-Message-State: APjAAAU/rx1qAiaBbnmb5e4tSV7I6LcROjeBxwoU37I0xfMcMZoCwh8p
        sJo9+vzi7cJMeoxebyz3aJY=
X-Google-Smtp-Source: APXvYqxh3eO87gK5Jlc/kSuzcfY8YgxD33Qo+k4FW0XQA3xxsWgsLM/AlJuIgFsEP2rpMDutlyvygw==
X-Received: by 2002:a5d:6706:: with SMTP id o6mr4098747wru.54.1574263718682;
        Wed, 20 Nov 2019 07:28:38 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id w4sm31797881wrs.1.2019.11.20.07.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 07:28:38 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 1/3] dt-bindings: crypto: add new compatible for A33 SS
Date:   Wed, 20 Nov 2019 16:28:31 +0100
Message-Id: <20191120152833.20443-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191120152833.20443-1-clabbe.montjoie@gmail.com>
References: <20191120152833.20443-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The A33 SS has a difference with all other SS, it give SHA1 digest
directly in BE.
This difference need to be handlded by the driver and so need a new
compatible.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml  | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
index 80b3e7350a73..5fc88fb3a91b 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
@@ -23,6 +23,8 @@ properties:
       - items:
         - const: allwinner,sun7i-a20-crypto
         - const: allwinner,sun4i-a10-crypto
+      - items:
+        - const: allwinner,sun8i-a33-crypto
 
   reg:
     maxItems: 1
-- 
2.23.0


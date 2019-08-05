Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B373C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 13:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E04D206C1
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 13:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="mjk8vH9M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfHENCW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 09:02:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39985 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfHENCW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 09:02:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so72948508wmj.5
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 06:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VD+kO2freT4druqcnh49hR6u8OkuGawcql9pBt221gM=;
        b=mjk8vH9McUPXmutExi9LK5ex7zl16u6Y1A29MLJPWpdqRchOSAGR8yhmK2fOTAo0rR
         0sDiFCY/K4jh+admqvlB/o99ab6xeNCWhc+kpHUH51vRLHk1iEDDajMTVrPVdzhGXOez
         b+MOpvwyHe3E8z4ck7Lc0JsxTJblE1HTqoVBH2bnCZr3MsUkmySVvX+rpBLWbpbktUmu
         hP/XHt8UiQrWbTdDNDhsijdtesI8b0m8A9EZshbEb+4cGVeTBIWdn2VjubV1sCDeTZXR
         sMr8q3TOfj4wjtw/b/DQ2XLzpqs0aaxo9LDtJ1wfglDOLg/WFdPVPnB9ccDGeJ8Az1yz
         MGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VD+kO2freT4druqcnh49hR6u8OkuGawcql9pBt221gM=;
        b=MTewIIP0KhT2OoW72fOfSRkKRXPnbu4gG4y+5cROrTBQJcbRoggXBH5t4je8n0AbXS
         MV1mh6sisCm6f8njnvl0wOCdh2i8qim9CyXrcbBiHUnYR+1cWeLa+ceuCWOd3k/z1plW
         u9Bu5wbQYy3wdOkFHnVeU2/v9hVGGDqficw5CjqFJC3agAZqixcipZXhjxMsG9hM7syz
         E0mgkGbeOPgWesVW6rTI7BzgZxxgFjqfD9aihWIL9WKAj5oHUaNxHwAxVIxSyyO2dpNW
         Eboj9fwMz8y9uxIOBQWuTl6RMDwdS1CsP0Pb1gOiVaaW5HxYpqN0ho1DX5eM2abeAPNJ
         Nndw==
X-Gm-Message-State: APjAAAUvHhvJDWphXmp/UdM6jl4cPL7WlP7yBo+tKIeIPoIboy+5BC5r
        EU+8jFKM8RrJtrRiYlgSF26D3g==
X-Google-Smtp-Source: APXvYqwxgFax/fM7iqjP2wFpKMs36pqx4aCRyV/P5qvPCozjg2IOFjiFHWnYt60j8Qx7Ktjguvx6VQ==
X-Received: by 2002:a1c:4e14:: with SMTP id g20mr18419431wmh.3.1565010140443;
        Mon, 05 Aug 2019 06:02:20 -0700 (PDT)
Received: from radium.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id v23sm74950359wmj.32.2019.08.05.06.02.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 06:02:19 -0700 (PDT)
From:   Fabien Parent <fparent@baylibre.com>
To:     robh+dt@kernel.org, matthias.bgg@gmail.com
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>
Subject: [PATCH] dt-bindings: rng: mtk-rng: Add documentation for MT8516
Date:   Mon,  5 Aug 2019 15:02:15 +0200
Message-Id: <20190805130215.20499-1-fparent@baylibre.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This commit adds the device-tree documentation for the RNG IP on the
MediaTek MT8516 SoC.

Signed-off-by: Fabien Parent <fparent@baylibre.com>
---
 Documentation/devicetree/bindings/rng/mtk-rng.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
index 2bc89f133701..dfdcb5cd2ea8 100644
--- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
+++ b/Documentation/devicetree/bindings/rng/mtk-rng.txt
@@ -6,6 +6,7 @@ Required properties:
 			"mediatek,mt7622-rng", 	"mediatek,mt7623-rng" : for MT7622
 			"mediatek,mt7629-rng",  "mediatek,mt7623-rng" : for MT7629
 			"mediatek,mt7623-rng" : for MT7623
+			"mediatek,mt8516-rng", "mediatek,mt7623-rng" : for MT8516
 - clocks	    : list of clock specifiers, corresponding to
 		      entries in clock-names property;
 - clock-names	    : Should contain "rng" entries;
-- 
2.23.0.rc1


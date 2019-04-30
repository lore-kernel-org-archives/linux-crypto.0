Return-Path: <SRS0=YET+=TA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83104C04AA8
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 16:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5398F20644
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 16:29:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x32olgjI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfD3Q3w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Apr 2019 12:29:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43411 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfD3Q3w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Apr 2019 12:29:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id a12so21734804wrq.10
        for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2019 09:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OZdMMD/d049PgXvrPSeOT8GlS+Kf7F/BVLM3iDmEjB8=;
        b=x32olgjIsDKXQnqTef0bHOIbkN+qEu+CC1h3ZDHczaZ96TaV8ivC5H1+nU6friSHZR
         wvWou7IHHUYvYPgeSYtMofzMQQeH2lxl/8AJ3iA94pZrovItQazLuZ82zMyR7JqCjOc/
         ulrgiyFNbu7uMkBSwNGBG7fDhaCIhoQ5gLtIzbb45epmrY6iDxAjYQJnXfMmcALo+HmV
         3yozRVBYQHAaI9LbtC2/ctgCLyKsAUzUJPm+psF4gR/4rIYBalStPMNzQr1h1aYlbnP5
         16enTDW5eA/jlVqVTTNKetDNNrYfoWYOssu7Hciu0sJd7QWFDFdoF9dYbHpCLsGKnYYq
         1WSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OZdMMD/d049PgXvrPSeOT8GlS+Kf7F/BVLM3iDmEjB8=;
        b=dTN1hhfK1GcL4l8a3YO5GtnOZZhGY+kEF34NHqHWa1jCPO+EJGJXoIChnYMvTzWt2z
         FCPn3+54zkQrR1WHhi6Fg5pxZhZCC3PHxVNv0DJEaemPj61+0IogGHCANpu9EMllILpW
         cXe8Zhdg5Bmx86Ap0GkhZhhxHmpgysnPr48fKXK4m35dsakVBXUREX/H3S1QF7Rb+a1s
         OyLJ3HOTBO2hzopQlrIDG0MF8fqr6nmjaGLyEhkfyztftCbsmlWEaJp8bbw/oHEDkFa0
         sRphWcAjO0/sEliw5P0F1YAXuFFJPjSzTf7mTXSYr1A8ul2h/DGDmYiNtpFzSKUlbdwL
         x/Mw==
X-Gm-Message-State: APjAAAXKDztCOK5L8E4tciKrxkt7UfQmS6KTJ3ofIzh3W4zzHehbP6dV
        MHaUoJG2iv+ecnKhOZWFUr85jIXqw45kdw==
X-Google-Smtp-Source: APXvYqw3NRFWUcmKzt4tqocuhkSBoEawVFKii/IxnIPTo2/dCKgJdIaHgwPYMyDFehYGMUXKEN/4uw==
X-Received: by 2002:adf:e486:: with SMTP id i6mr7676077wrm.42.1556641790585;
        Tue, 30 Apr 2019 09:29:50 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:1ca3:6afc:30c:1068])
        by smtp.gmail.com with ESMTPSA id t67sm5848890wmg.0.2019.04.30.09.29.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 09:29:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        joakim.bech@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5/5] dt-bindings: add Atmel SHA204A I2C crypto processor
Date:   Tue, 30 Apr 2019 18:29:09 +0200
Message-Id: <20190430162910.16771-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a compatible string for the Atmel SHA204A I2C crypto processor.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/devicetree/bindings/crypto/atmel-crypto.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
index 6b458bb2440d..a93d4b024d0e 100644
--- a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
+++ b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
@@ -79,3 +79,16 @@ atecc508a@c0 {
 	compatible = "atmel,atecc508a";
 	reg = <0xC0>;
 };
+
+* Symmetric Cryptography (I2C)
+
+Required properties:
+- compatible : must be "atmel,atsha204a".
+- reg: I2C bus address of the device.
+- clock-frequency: must be present in the i2c controller node.
+
+Example:
+atsha204a@c0 {
+	compatible = "atmel,atsha204a";
+	reg = <0xC0>;
+};
-- 
2.20.1


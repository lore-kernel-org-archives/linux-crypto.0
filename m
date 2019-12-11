Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54037C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 08:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 246242077B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 08:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JVeIF5c0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfLKIlV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:41:21 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37283 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfLKIlV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 03:41:21 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep17so8658915pjb.4;
        Wed, 11 Dec 2019 00:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s5qKVi0ow9j/+PgSK4g7oFXUi7s8J1QUH2gPB5uRhng=;
        b=JVeIF5c0x4qPWCcRQP89soeeVAzZ+l7bIv8ArdHIFudN0Hmn6FnS3jwrXH8LqY1GUZ
         o/amn2pnA2gMC9sf4y2ZK3GJRo8vvpAS9I3soADsyhkeqWeP5IgYcq+tKLlygr6dBAX9
         dvJnhKdBZy11kJmY8BpIwOpGm9CU7HgzZLyzt2u5d4bXEz+6pKq/0MxAfiLG5gZfNS5A
         WNVP4/9bZCspt9mlzv273V/drsUYEnATBzarGAk0HBVv/pqpmwiJpILtkBK16uwnzfbw
         IXEb9fameNjYyZTl2vd4vIGY0uXi5Xgny2ofeE3HuFxA/brdfHJP0BwWnw+agIFavjJp
         /xTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s5qKVi0ow9j/+PgSK4g7oFXUi7s8J1QUH2gPB5uRhng=;
        b=c0ZGFoaiMOEZyPZpETiS+PyRfUidwkIE7Tz6nRJq4oGsHsmMVtyf9nx5sn6DhiKIym
         i1aZfy1GGbEhal0OE6S9X4y+WeF/I4pPMfVPRW+feY+I/in7wA//n3gsMdWj/77M2RTn
         5wZRMli277/l6zLg/WQHUnxLVZ0Ukrmxquwni1le/wA3qaLHg/1iCouQiNgDYFScaRvf
         WJhNOZUFNS8nQisjWCarS/htZUkVGflPeLEuSLPHEtOMLD9uJQp9QdnboSbDJ5XayW0H
         MARv/x2dBXtpsK3I+aErIdG5LoXVcnkcMTkd8VIaXDDhJonO00dxSOTIFQWV0BBIXPx2
         ps4Q==
X-Gm-Message-State: APjAAAXnfVfWqqg6sJR4BU4PjlW0BmsD6Byz+EHYrvNcIjXWiuraMzV/
        GtVYtAvQrI89hchM4l/tHtU=
X-Google-Smtp-Source: APXvYqyyMQ+AucG9e2uc2shvqk0QaTaNbnFgmIxAXSBua1SEP5Al4wKFWdYvh7CtBxgLX2DYFTKOHw==
X-Received: by 2002:a17:902:7c83:: with SMTP id y3mr2037257pll.34.1576053680345;
        Wed, 11 Dec 2019 00:41:20 -0800 (PST)
Received: from localhost.localdomain ([103.51.73.137])
        by smtp.gmail.com with ESMTPSA id e16sm1806233pgk.77.2019.12.11.00.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 00:41:19 -0800 (PST)
From:   Anand Moon <linux.amoon@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCHv1 0/3] Enable crypto module on Amlogic GXBB SoC platform
Date:   Wed, 11 Dec 2019 08:41:09 +0000
Message-Id: <20191211084112.971-1-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Below changes enable cryto module on Amlogic GXBB SoC.

I was realy happy to get this feature working on Odroid C2 SBC.
I will try on other SBC in the future.

Tested with loading tcrypt module.
# sudo modprobe tcrypt sec=1 mode=200
[sudo] password for alarm:
[  903.867059] tcrypt:
[  903.867059] testing speed of async ecb(aes) (ecb(aes-arm64)) encryption
[  903.870265] tcrypt: test 0 (128 bit key, 16 byte blocks): 1922107 operations in 1 seconds (30753712 bytes)
[  904.872802] tcrypt: test 1 (128 bit key, 64 byte blocks): 679032 operations in 1 seconds (43458048 bytes)
[  905.872717] tcrypt: test 2 (128 bit key, 256 byte blocks): 190190 operations in 1 seconds (48688640 bytes)
[  906.872793] tcrypt: test 3 (128 bit key, 1024 byte blocks): 49014 operations in 1 seconds (50190336 bytes)
[  907.872808] tcrypt: test 4 (128 bit key, 1472 byte blocks): 34342 operations in 1 seconds (50551424 bytes)
[  908.876828] tcrypt: test 5 (128 bit key, 8192 byte blocks): 6199 operations in 1 seconds (50782208 bytes)

-Anand

Anand Moon (3):
  arm64: dts: amlogic: adds crypto hardware node for GXBB SoCs
  dt-bindings: crypto: Add compatible string for amlogic GXBB SoC
  crypto: amlogic: Add new compatible string for amlogic GXBB SoC

 .../devicetree/bindings/crypto/amlogic,gxl-crypto.yaml |  1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi            | 10 ++++++++++
 drivers/crypto/amlogic/amlogic-gxl-core.c              |  1 +
 3 files changed, 12 insertions(+)

-- 
2.24.0


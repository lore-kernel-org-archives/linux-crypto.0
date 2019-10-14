Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB8CC4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B85E520663
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxW7qDEf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfJNFSt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 01:18:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36229 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfJNFSs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 01:18:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id m18so15318429wmc.1;
        Sun, 13 Oct 2019 22:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r27WGXUs+Wuhk1pzsYshNkJtTiZw35ZkKYZGAVQI7mQ=;
        b=ZxW7qDEfgKxLpLZQCQX6vWykm+r7cYH88LGy7TAuV6zMHBGE8rm/Lt25gNvc93Cxyj
         OQ7R1pmBFKqrjpOXlRkqgRMkB/KgBa3fm7bRqz0xyLeET4uYqtzxJp29dtNBjxSB5/V7
         kPqKrycbvQI3nd0E3rd+5OpQTVp1AZx17u0+NwOJ5ctEvClATX8lSF9sIQrhI0w43+5O
         ujAwS4nWWQJzR1MxNtnX89x/aWs9R4OJ+o383l12cX7GBbZVxTGVETBUH9BM5cKZArgT
         E3BqB8b1D17Zpkh7rQPwM+8vVn8uv57UOQl9bNy0pcOntwiHs4Z0K/okXHQITln4NRY8
         8BQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r27WGXUs+Wuhk1pzsYshNkJtTiZw35ZkKYZGAVQI7mQ=;
        b=DLdKNFzKEFOkG3DSGd7MC1eMKGzEYQd++8jl6XZjEVPDcFaToHJ487++cqu311rEIn
         1MefNRyOLurQ4STE9BPO7egf4iniVU7OjtM0AzfotgjEqrmp9S30JW38XV4/jZD6Q4mt
         aXviJvy5igSZuAYDUkEHhr+Md8vsmORWvOp5xaVirT8jHi3dsrAami6eWIEMkzOMbKeQ
         B/FZjL2mDD+7nklTfHOPl7xaRBGBmjfwD0JSxeyN+taOz8mhBt3xvO9xKd0r3OxxcdAQ
         tyy68e109sG3Ageu4A47DUuZ/EqNJkJLNtop/jWQkcp0Hb6RkvNlIBCSpRG5bgPAqu4O
         rIgw==
X-Gm-Message-State: APjAAAW96dgLfj2nwxYTCFLIExVd3M4OXkXt36XzrVVgOzx+61X0JOcR
        zTxtfpDzlfsTwRX0YhJEj4M=
X-Google-Smtp-Source: APXvYqzTsLHoZpuvisvBX8HutF5saEpyzHk2Up8rAkU+EmCCb/EqrEqbZTDKe8KERdgRDuazda+ssg==
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr5811046wmj.119.1571030326771;
        Sun, 13 Oct 2019 22:18:46 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 5sm14660340wrk.86.2019.10.13.22.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 22:18:46 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org,
        martin.blumenstingl@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 2/4] MAINTAINERS: Add myself as maintainer of amlogic crypto
Date:   Mon, 14 Oct 2019 07:18:37 +0200
Message-Id: <20191014051839.32274-3-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191014051839.32274-1-clabbe.montjoie@gmail.com>
References: <20191014051839.32274-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I will maintain the amlogic crypto driver.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 36c5d6ee01f9..a8487a0999ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1477,6 +1477,13 @@ F:	drivers/soc/amlogic/
 F:	drivers/rtc/rtc-meson*
 N:	meson
 
+ARM/Amlogic Meson SoC Crypto Drivers
+M:	Corentin Labbe <clabbe@baylibre.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/amlogic/
+F:	Documentation/devicetree/bindings/crypto/amlogic*
+
 ARM/Amlogic Meson SoC Sound Drivers
 M:	Jerome Brunet <jbrunet@baylibre.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
2.21.0


Return-Path: <SRS0=21Gj=5M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7B8C2D0F0
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 06:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E22120714
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 06:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgC0GLG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Mar 2020 02:11:06 -0400
Received: from foss.arm.com ([217.140.110.172]:40856 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgC0GLG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Mar 2020 02:11:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D024B1045;
        Thu, 26 Mar 2020 23:11:05 -0700 (PDT)
Received: from ssg-dev-vb.arm.com (unknown [10.57.25.3])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 582873F71F;
        Thu, 26 Mar 2020 23:15:07 -0700 (PDT)
From:   Hadar Gat <hadar.gat@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>
Subject: [PATCH v7 3/3] MAINTAINERS: add HG as cctrng maintainer
Date:   Fri, 27 Mar 2020 09:10:23 +0300
Message-Id: <1585289423-18440-4-git-send-email-hadar.gat@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I work for Arm on maintaining the TrustZone CryptoCell TRNG driver.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c312b65..3f27716 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3847,6 +3847,15 @@ S:	Supported
 F:	drivers/crypto/ccree/
 W:	https://developer.arm.com/products/system-ip/trustzone-cryptocell/cryptocell-700-family
 
+CCTRNG ARM TRUSTZONE CRYPTOCELL TRUE RANDOM NUMBER GENERATOR (TRNG) DRIVER
+M:	Hadar Gat <hadar.gat@arm.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/char/hw_random/cctrng.c
+F:	drivers/char/hw_random/cctrng.h
+F:	Documentation/devicetree/bindings/rng/arm-cctrng.txt
+W:	https://developer.arm.com/products/system-ip/trustzone-cryptocell/cryptocell-700-family
+
 CEC FRAMEWORK
 M:	Hans Verkuil <hverkuil-cisco@xs4all.nl>
 L:	linux-media@vger.kernel.org
-- 
2.7.4


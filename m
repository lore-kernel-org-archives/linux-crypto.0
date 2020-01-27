Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F0DC35248
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 09:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D9DC2071E
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 09:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbgA0Jar (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 04:30:47 -0500
Received: from foss.arm.com ([217.140.110.172]:41562 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbgA0Jar (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 04:30:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A967F106F;
        Mon, 27 Jan 2020 01:30:46 -0800 (PST)
Received: from ssg-dev-vb.kfn.arm.com (E111385.Arm.com [10.50.4.77])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC58F3F67D;
        Mon, 27 Jan 2020 01:30:42 -0800 (PST)
From:   Hadar Gat <hadar.gat@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>
Subject: [PATCH 3/3] MAINTAINERS: add HG as cctrng maintainer
Date:   Mon, 27 Jan 2020 11:28:24 +0200
Message-Id: <1580117304-12682-4-git-send-email-hadar.gat@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580117304-12682-1-git-send-email-hadar.gat@arm.com>
References: <1580117304-12682-1-git-send-email-hadar.gat@arm.com>
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
index a0c1618..654585a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3790,6 +3790,15 @@ S:	Supported
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


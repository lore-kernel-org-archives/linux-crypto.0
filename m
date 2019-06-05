Return-Path: <SRS0=VkFO=UE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD42C28CC5
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jun 2019 13:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD9B20866
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jun 2019 13:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vAcs7pC2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfFENWC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jun 2019 09:22:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33424 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfFENWB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jun 2019 09:22:01 -0400
Received: by mail-pl1-f196.google.com with SMTP id g21so9695475plq.0;
        Wed, 05 Jun 2019 06:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=hXsQr/OkSzH/u4JLYwMI74MVQvCM/DsvMDlyfR8YPSs=;
        b=vAcs7pC2kqhFsFdLMdboV71PC8Al8p5Fqgrp92x24xcLKrspdV3OUmr94JSM7zHNWH
         UJpI+hKMpr1bC7hxlNuwVIn3NFxeqATaHm3lbTVOYLA3KMw4fZol2lRcwDxqSi07FKOJ
         jsn4zOPQ/EbGXeqm9Ze1nw49PjZAyG6azwChEvZ09uXbvyAGipkJioxdlPyENZ2WdlMG
         Mw7JB+4kDzjCo4VdSGO3Qj6l2ODva8Dh2YwWpK7WkIlgX/Ufd4Wek6h9PRUuFO5LlSqo
         +CvOsEHO4LCeLTIOsDmZlUVOeIwcUJEqfvJ9RzaX0QaGmggeWQe4KxWOSo0Zm/ZPsVn3
         XpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=hXsQr/OkSzH/u4JLYwMI74MVQvCM/DsvMDlyfR8YPSs=;
        b=KqfT+a+n1jGa9S+D19z7LKdrgu+Bwff+VJPZsG+1utfegFvGkHZdsNY9/d76C6Xh44
         QybgSugm3ThM5VL5HoPjHxEaKq/Mp1XRKZmdo3+up8GfPNR2jEkF0xZU+iXlhFiWBhYl
         bj4pxHAHKmmzCZnTdxH5lmY8qRNSHBzWw9gl8k7Tf+y6lzSthpd1eG5NVwwRKN4A9BeA
         s9egZakqlvXDw7OX9qPTQRRJx43S4e072QvLUm8mc6bkIY9xGIt2LzvrEkmE8qDSQbRc
         hECD80WcWqefxBaxGEQJL9g+rnScJ0QsdgdGxM75aUu5lhR3g5hF9EwTJ/1WXTVNC1j5
         p5qw==
X-Gm-Message-State: APjAAAWGXxz2SGrISB/pgFCVnCX5e+8anmUqLSR6yTuu+ZaBg8pRWoqm
        trOtaT6E8l2+maOHPNJwACk=
X-Google-Smtp-Source: APXvYqy3yOZ8VjiWRMUeMtJatt8B5MqTPmZEf84WUyyqZ00JqPIqt8WpUbID9fsep+oJRJqxX4KoJA==
X-Received: by 2002:a17:902:28c9:: with SMTP id f67mr43935186plb.19.1559740921154;
        Wed, 05 Jun 2019 06:22:01 -0700 (PDT)
Received: from nishad (p3261240-ipngn21201hodogaya.kanagawa.ocn.ne.jp. [153.202.122.240])
        by smtp.gmail.com with ESMTPSA id i3sm22254201pfa.175.2019.06.05.06.21.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 06:22:00 -0700 (PDT)
Date:   Wed, 5 Jun 2019 18:51:53 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: cavium/nitrox - Use the correct style for SPDX
 License Identifier
Message-ID: <20190605132149.GA5589@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch corrects the SPDX License Identifier style
in header files related to Crypto Drivers for Cavium Nitrox
family CNN55XX devices.
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/crypto/cavium/nitrox/nitrox_debugfs.h | 2 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.h     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.h b/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
index f177b79bbab0..09c4cf2513fb 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __NITROX_DEBUGFS_H
 #define __NITROX_DEBUGFS_H
 
diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.h b/drivers/crypto/cavium/nitrox/nitrox_mbx.h
index 5008399775a9..7c93d0282174 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __NITROX_MBX_H
 #define __NITROX_MBX_H
 
-- 
2.17.1


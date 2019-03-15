Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC979C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 02:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 771742186A
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 02:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="MYzwGELu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfCOCJG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Mar 2019 22:09:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37326 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfCOCJG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Mar 2019 22:09:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id 8so1739573pfr.4
        for <linux-crypto@vger.kernel.org>; Thu, 14 Mar 2019 19:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y3kqJQ5xsOjs4aV1pFM0MeGV8X4Abqf24LZEIyvcPnE=;
        b=MYzwGELu/d1daXHH5m38Tz2y+m+vS0t/i7J7G1Tba0K6lEAE1PBJZrOKdMR1yR4H/y
         mdkh1NivJ7Ank2bMvpzjQrDN/Mhv0A2QHmxk6EdoM02KQIh6Wr44rBzDsevU2xTExpnb
         2uaERrNyy/xu+lragW9+cvIOaTuD2/XDPYSCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y3kqJQ5xsOjs4aV1pFM0MeGV8X4Abqf24LZEIyvcPnE=;
        b=M1Z3Qca5ZixIRH/Ce+pxWy3NmsR9md0bqEUxjAjmFNQMqUwdx+W2pYdSkA2R83kUXo
         vdIsD9eM/FUBOZG2RzWemqPcomTr73vKQ5U6EkV1xIGT3bym2flxbSp03rSaXL7eZmB0
         Vb1x3IRM5qNaYroOTcNMV+8ULxS46TZwmuKtyaDC7FY+MSAbo+bMxQjW7MVSi2DKYY6P
         xV4nsjvkUGoDmHh+iFBTG+KwWCN54HEIBglF+rEroLN4sxQJPmnXXwhSZ/A7rpI9XsCP
         Z3QPV+i4v6hZXjtBx3M1WkQlMBOc0/SpcWbgXI1oVfxuAsvXPrAS2ew3+Ll2PigOPi3j
         Yjzg==
X-Gm-Message-State: APjAAAVE7BtPI5gNUHfMQPL6N6IVP55VGa3QTnAzjpTOOLRmzeP7YKes
        8bELYa1zvVWyf4lhk03t14ojEw==
X-Google-Smtp-Source: APXvYqz4OAteB7F0UWElJ5HD5WmtiImAfV0WL0obe2SGPZSKJk4sI0S2qI7wlcwxjHcOlARBq8cw2w==
X-Received: by 2002:a65:534d:: with SMTP id w13mr1025397pgr.186.1552615745775;
        Thu, 14 Mar 2019 19:09:05 -0700 (PDT)
Received: from localhost (124-171-209-25.dyn.iinet.net.au. [124.171.209.25])
        by smtp.gmail.com with ESMTPSA id j20sm472815pfh.141.2019.03.14.19.09.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 19:09:04 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     omosnacek@gmail.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org
Subject: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
Date:   Fri, 15 Mar 2019 13:09:01 +1100
Message-Id: <20190315020901.16509-1-dja@axtens.net>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The original assembly imported from OpenSSL has two copy-paste
errors in handling CTR mode. When dealing with a 2 or 3 block tail,
the code branches to the CBC decryption exit path, rather than to
the CTR exit path.

This leads to corruption of the IV, which leads to subsequent blocks
being corrupted.

This can be detected with libkcapi test suite, which is available at
https://github.com/smuellerDD/libkcapi

Reported-by: Ondrej Mosnáček <omosnacek@gmail.com>
Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/crypto/vmx/aesp8-ppc.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
index d6a9f63d65ba..de78282b8f44 100644
--- a/drivers/crypto/vmx/aesp8-ppc.pl
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -1854,7 +1854,7 @@ Lctr32_enc8x_three:
 	stvx_u		$out1,$x10,$out
 	stvx_u		$out2,$x20,$out
 	addi		$out,$out,0x30
-	b		Lcbc_dec8x_done
+	b		Lctr32_enc8x_done
 
 .align	5
 Lctr32_enc8x_two:
@@ -1866,7 +1866,7 @@ Lctr32_enc8x_two:
 	stvx_u		$out0,$x00,$out
 	stvx_u		$out1,$x10,$out
 	addi		$out,$out,0x20
-	b		Lcbc_dec8x_done
+	b		Lctr32_enc8x_done
 
 .align	5
 Lctr32_enc8x_one:
-- 
2.19.1


Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2F4C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 06:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86FB8218D2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 06:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="kdzOFXN5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfAYGIh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 01:08:37 -0500
Received: from conuserg-12.nifty.com ([210.131.2.79]:31719 "EHLO
        conuserg-12.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfAYGIg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 01:08:36 -0500
X-Greylist: delayed 8276 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2019 01:08:35 EST
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id x0P67sVU012319;
        Fri, 25 Jan 2019 15:07:54 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com x0P67sVU012319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1548396474;
        bh=gv+6Ws9f6VGzifMs3BOTay8m5/soowYJG26BjthdvwU=;
        h=From:To:Cc:Subject:Date:From;
        b=kdzOFXN5I2JQ8HD/qMU6QzH0przQefrFUd97ofzZm0nGpzufXiBv4Hf2ZcYOm86r0
         n6gLc3AqkAkf+vvn0GZREEBg7W3Kp2Pg7PB9VezogbwxnQ27h+Xa1L1dgpkqwNTr7G
         DSzabC1Q9jxNS2BB3E3RhcFZ92bAlIEG+M1TAhK2WwGkZz65o/oIEtE55BST3KkCIe
         xayw5sbilUDRH/9vU1hV2t3Ol7MGQ3RqJxWaOLumRr4AtB85LiaUolcls8QXWWeXYL
         sidRquS7e8DbqD9DQzT2TKIDix3mzIt0LedJ8sgHoS/EkjIJioBxmy7yshttDpQCSb
         HMSCqi4S3TFiQ==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: bcm: remove -I. header search path and unused macro define
Date:   Fri, 25 Jan 2019 15:07:48 +0900
Message-Id: <1548396469-13395-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The header search path -I. in kernel Makefiles is very suspicious;
it allows the compiler to search for headers in the top of $(srctree),
where obviously no header file exists.

'git grep BCMDRIVER' has no hit. So, this macro is not referenced.

I was able to build this driver without the extra compiler options.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/crypto/bcm/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/bcm/Makefile b/drivers/crypto/bcm/Makefile
index 13cb80e..7469e19 100644
--- a/drivers/crypto/bcm/Makefile
+++ b/drivers/crypto/bcm/Makefile
@@ -11,5 +11,3 @@
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) := bcm_crypto_spu.o
 
 bcm_crypto_spu-objs :=  util.o spu.o spu2.o cipher.o
-
-ccflags-y += -I. -DBCMDRIVER
-- 
2.7.4


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91929C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 18:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4528A61A13
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 18:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhCZSgC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 14:36:02 -0400
Received: from sender4-pp-o95.zoho.com ([136.143.188.95]:25562 "EHLO
        sender4-pp-o95.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhCZSfb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 14:35:31 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1616783721; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=FKyBdPo4I297k88M6xDgEp/wNCEYjwryYTT00JANWo7JyqVaqvNh+o9ijkRsAMDVFm5irDewUIN799ugcW8AoX3z4LsnhhJi3AU75wr26u76tbr2zShF3SnssvsVOyz8hBal5Hv9lxaAS6ohKwZhnbvsE46vkxrGOTN12DDonKY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1616783721; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=algqbTMvGFjSqMaTMsnXody+vG+FkN8pyNakvt3N7WE=; 
        b=bNeTninYB+wPz7YU6ymTtxdXvDoVRgABslS0T76Fyjj3Yk81MBCUrcHyd/BZ/fYc5kn4QqJVINRplo9AqOrzKkjiRzd55sDDX9sQ29M2/xDQvHGtBtY5BU0hc83wS74nvUQS73jKbmY7iuvr0drDnr2dTCzkKyDoPhoTc45e7js=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=zohomail.com;
        spf=pass  smtp.mailfrom=mdjurovic@zohomail.com;
        dmarc=pass header.from=<mdjurovic@zohomail.com> header.from=<mdjurovic@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1616783721;
        s=zm2020; d=zohomail.com; i=mdjurovic@zohomail.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=algqbTMvGFjSqMaTMsnXody+vG+FkN8pyNakvt3N7WE=;
        b=PkPHreSkE3S4sGsVXhsy9uXm9I3xGMH+MCXWHsr5P2ztZGQEK559XrBrTWf5FztJ
        d6Ff/cV30/xHQRmUNziCL2DLbHw6qtE5uWFZUxbKOWcgDhEa/ihRqRvoqFq0Lz7Mbd5
        RzAynNZeQJixvXZV+KfBeTb8B8jqLDx/RnH6rxes=
Received: from milan-pc.attlocal.net (107-220-151-69.lightspeed.sntcca.sbcglobal.net [107.220.151.69]) by mx.zohomail.com
        with SMTPS id 1616783719296107.03911552551187; Fri, 26 Mar 2021 11:35:19 -0700 (PDT)
From:   Milan Djurovic <mdjurovic@zohomail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org,
        Milan Djurovic <mdjurovic@zohomail.com>
Subject: [PATCH] crypto: fcrypt: Remove 'do while(0)' loop for single statement macro
Date:   Fri, 26 Mar 2021 11:35:11 -0700
Message-Id: <20210326183511.98451-1-mdjurovic@zohomail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the 'do while(0)' loop in the macro, as it is not needed for single
statement macros. Condense into one line.

Signed-off-by: Milan Djurovic <mdjurovic@zohomail.com>
---
 crypto/fcrypt.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index c36ea0c8be98..76a04d000c0d 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -63,10 +63,7 @@ do {								\
 } while (0)
 
 /* Rotate right one 64 bit number as a 56 bit number */
-#define ror56_64(k, n)						\
-do {								\
-	k = (k >> n) | ((k & ((1 << n) - 1)) << (56 - n));	\
-} while (0)
+#define ror56_64(k, n) (k = (k >> n) | ((k & ((1 << n) - 1)) << (56 - n)))
 
 /*
  * Sboxes for Feistel network derived from
-- 
2.31.0


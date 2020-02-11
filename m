Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157E1C35242
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED38A206D6
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgBKSVk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:21:40 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:45378 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729405AbgBKSTc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 13:19:32 -0500
Received: from ramsan ([84.195.182.253])
        by xavier.telenet-ops.be with bizsmtp
        id 1WKW220055USYZQ01WKWw0; Tue, 11 Feb 2020 19:19:30 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1a8A-0002ol-5L; Tue, 11 Feb 2020 19:19:30 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1a8A-0003zB-3z; Tue, 11 Feb 2020 19:19:30 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 23/34] crypto: ccree - remove bogus kerneldoc markers
Date:   Tue, 11 Feb 2020 19:19:17 +0100
Message-Id: <20200211181928.15178-24-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211181928.15178-1-geert+renesas@glider.be>
References: <20200211181928.15178-1-geert+renesas@glider.be>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Normal comments should start with "/*".
"/**" is reserver for kerneldoc.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New.

 drivers/crypto/ccree/cc_aead.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 78afa753b44f2dba..be26aaf75e1fe9ea 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -1223,7 +1223,7 @@ static void cc_hmac_authenc(struct aead_request *req, struct cc_hw_desc desc[],
 				 req_ctx->is_single_pass);
 
 	if (req_ctx->is_single_pass) {
-		/**
+		/*
 		 * Single-pass flow
 		 */
 		cc_set_hmac_desc(req, desc, seq_size);
@@ -1235,7 +1235,7 @@ static void cc_hmac_authenc(struct aead_request *req, struct cc_hw_desc desc[],
 		return;
 	}
 
-	/**
+	/*
 	 * Double-pass flow
 	 * Fallback for unsupported single-pass modes,
 	 * i.e. using assoc. data of non-word-multiple
@@ -1276,7 +1276,7 @@ cc_xcbc_authenc(struct aead_request *req, struct cc_hw_desc desc[],
 				 req_ctx->is_single_pass);
 
 	if (req_ctx->is_single_pass) {
-		/**
+		/*
 		 * Single-pass flow
 		 */
 		cc_set_xcbc_desc(req, desc, seq_size);
@@ -1287,7 +1287,7 @@ cc_xcbc_authenc(struct aead_request *req, struct cc_hw_desc desc[],
 		return;
 	}
 
-	/**
+	/*
 	 * Double-pass flow
 	 * Fallback for unsupported single-pass modes,
 	 * i.e. using assoc. data of non-word-multiple
-- 
2.17.1


Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FD3C2D0CE
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7037621744
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588285;
	bh=Xh56S2p/u7dijE7JzTBgalq9BKRLTICE05G86pxpQcw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p6UB+ivcmO3oCZgnq4FQiRLocxHab84CFD3XUGTd3NBWC5S3Arb99aZdk4nRf+2DU
	 UekS5V4GSJcDgmSDuqVAExLjgq4nmnRMmgyWQmnIJGnt4+Xu1awkp8oFbHc1hwYote
	 VwdaPLw48h8eRn+IoLknLm5yqvok7PMJylKiMvZk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfL2C6D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfL2C6D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:03 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06F542176D
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588283;
        bh=Xh56S2p/u7dijE7JzTBgalq9BKRLTICE05G86pxpQcw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fHAcXXc2glJ3R4qSWb8mq3ev0Ukc7O6hpCCRHRThdyJRvVFJtDL3AzURNqhhQL5CU
         IsScmqmoteFOy4XaypqY3NjdmD2y3dQhx4YXvQGQyWcXH0y5iWiAhTRgQKx8S4c05S
         WJQA9O4KCkq+sVZ3pzs7eNK8XSMl8U9JMbACk9lY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 02/28] crypto: algapi - make crypto_grab_spawn() handle an ERR_PTR() name
Date:   Sat, 28 Dec 2019 20:56:48 -0600
Message-Id: <20191229025714.544159-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229025714.544159-1-ebiggers@kernel.org>
References: <20191229025714.544159-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

To allow further simplifying template ->create() functions, make
crypto_grab_spawn() handle an ERR_PTR() name by passing back the error.

For most templates, this will allow the result of crypto_attr_alg_name()
to be passed directly to crypto_grab_*(), rather than first having to
assign it to a variable [where it can then potentially be misused, as it
was in the rfc7539 template prior to commit 5e27f38f1f3f ("crypto:
chacha20poly1305 - set cra_name correctly")] and check it for error.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 4c761f48110d..a5223c5f2275 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -720,6 +720,10 @@ int crypto_grab_spawn(struct crypto_spawn *spawn, const char *name,
 	struct crypto_alg *alg;
 	int err;
 
+	/* Allow the result of crypto_attr_alg_name() to be passed directly */
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
 	alg = crypto_find_alg(name, spawn->frontend, type, mask);
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
-- 
2.24.1


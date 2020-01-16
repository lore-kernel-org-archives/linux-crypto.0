Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD399C33CAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 18:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B3532053B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579200772;
	bh=ridvvlhYMarzX4Et6KFdpTMbKJK5zKvEPEiZb+9e3Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qu602tX4gOMShhkQhsCxiHwwIo52xdqdzUf7dKpKZpk+UWQ/87UBZ4ZUevAl6sxr4
	 8v6KolBDM/2X5zi/sTZ7+fQ9+MRxIRAxW2fW9MU1lV29vU74sEaloVghDkA8IotbdQ
	 gAdGwG4nHf6kcWjcwt5TtDMq2KaIlkZW2zprLBk0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389398AbgAPRIY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388134AbgAPRIY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94848206D9;
        Thu, 16 Jan 2020 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194503;
        bh=ridvvlhYMarzX4Et6KFdpTMbKJK5zKvEPEiZb+9e3Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXQ7Hfu7vxs4AEyG2K3sXo0cyxZ5L0vD2Noi5KwfR8gv8aHW+d2twQfcxNZimg/2y
         QkPAfGpkv1yeHFx090A4i60Ai97YSNJiqD64tWZqGjgwhs2XNsA8DnWXBzDksyGjC6
         ENR5QMuPQe9tdOmxNTU9aumtQN4UJQRXmjisP5Ao=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 399/671] crypto: inside-secure - fix queued len computation
Date:   Thu, 16 Jan 2020 12:00:37 -0500
Message-Id: <20200116170509.12787-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit ccd65a206a5025cf953a2e4f37e894921b131a5c ]

This patch fixes the queued len computation, which could theoretically
be wrong if req->len[1] - req->processed[1] > 1. Be future-proof here,
and fix it.

Fixes: b460edb6230a ("crypto: inside-secure - sha512 support")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 9a02f64a45b9..f3b02c00b784 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -50,10 +50,12 @@ struct safexcel_ahash_req {
 
 static inline u64 safexcel_queued_len(struct safexcel_ahash_req *req)
 {
-	if (req->len[1] > req->processed[1])
-		return 0xffffffff - (req->len[0] - req->processed[0]);
+	u64 len, processed;
 
-	return req->len[0] - req->processed[0];
+	len = (0xffffffff * req->len[1]) + req->len[0];
+	processed = (0xffffffff * req->processed[1]) + req->processed[0];
+
+	return len - processed;
 }
 
 static void safexcel_hash_token(struct safexcel_command_desc *cdesc,
-- 
2.20.1


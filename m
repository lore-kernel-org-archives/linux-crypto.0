Return-Path: <SRS0=qmX+=53=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C673C2BA19
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 23:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF798206E9
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 23:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648276;
	bh=xQAW1GitvLQh6XJsKowD5jHl7RZkVULVUj2zrP3ZgkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SNTcWkIwJQ+m12DQAEtoFBvRAfBzMjkpQimDizg4/DbV78ppoNmW5eDH1miUTIYo5
	 wF2ZPRhT00UmilBnVm80zVlT2IxwWaNo8iAby8LCTozY5I1LNzmR04tOmiwWtu5w8V
	 c6tn5qnVhmCVNLg0PeM8BHdJ33YwD4KWaPeF7h+c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgDKXIK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbgDKXIJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6B27216FD;
        Sat, 11 Apr 2020 23:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646489;
        bh=xQAW1GitvLQh6XJsKowD5jHl7RZkVULVUj2zrP3ZgkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6qZeSzE5lAGR6+GP1oIpsgcd0xVoIkU427iQbSYRHp5y3+z1ZQ2hCCRmUAWmcma+
         7nTA3jdHl6I6pWHTsijwyeheCOosXdUXwVAc+XXZhLPDTeDS8x3jdQNmqmdZ6I40uY
         Wltn3j/Zv9FbBuVEP1Loqsd0lYR3Z5ResHzD2KC0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 053/121] crypto: tcrypt - fix printed skcipher [a]sync mode
Date:   Sat, 11 Apr 2020 19:05:58 -0400
Message-Id: <20200411230706.23855-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit 8e3b7fd7ea554ccb1bdc596bfbcdaf56f7ab017c ]

When running tcrypt skcipher speed tests, logs contain things like:
testing speed of async ecb(des3_ede) (ecb(des3_ede-generic)) encryption
or:
testing speed of async ecb(aes) (ecb(aes-ce)) encryption

The algorithm implementations are sync, not async.
Fix this inaccuracy.

Fixes: 7166e589da5b6 ("crypto: tcrypt - Use skcipher")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index f42f486e90e8a..ba0b7702f2e91 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1514,8 +1514,8 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of async %s (%s) %s\n", algo,
-			get_driver_name(crypto_skcipher, tfm), e);
+	pr_info("\ntesting speed of %s %s (%s) %s\n", async ? "async" : "sync",
+		algo, get_driver_name(crypto_skcipher, tfm), e);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-- 
2.20.1


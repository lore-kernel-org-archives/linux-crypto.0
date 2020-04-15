Return-Path: <SRS0=7EYG=57=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69E8C2BB55
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 23:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD38A20768
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 23:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbgDOXEE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Apr 2020 19:04:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53326 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgDOXED (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Apr 2020 19:04:03 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jOr4Z-0004WB-2w; Wed, 15 Apr 2020 23:03:59 +0000
From:   Colin King <colin.king@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: algif_rng: remove redundant assignment to variable err
Date:   Thu, 16 Apr 2020 00:03:58 +0100
Message-Id: <20200415230358.1566912-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 crypto/algif_rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 22df3799a17b..087c0ad09d38 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -61,7 +61,7 @@ static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct rng_ctx *ctx = ask->private;
-	int err = -EFAULT;
+	int err;
 	int genlen = 0;
 	u8 result[MAXSIZE];
 
-- 
2.25.1


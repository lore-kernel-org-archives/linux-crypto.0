Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F20C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 06:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DA642070E
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 06:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403551;
	bh=IbldVPHNz9zzb+JEgV4LyfJbvojGwsw+3a21bXkCHwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=N0sXWStr4U/fLbQJ8exrhdc8w2NgI01CCysU6sFrj3sJaj6qHkUmzbzz/fDZUogXw
	 +EqqTZWCM1SHR8bd7jUQFBqvsEBDWf9dlsBGwlormXOO/hnRo6Op31TBxoF+W7pJ2D
	 FMMuWg8JT6RfzpqX4pG+22PxaGtc6CXm2NCJj4cM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfKVGS5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:18:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfKVF4D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A2642072D;
        Fri, 22 Nov 2019 05:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402162;
        bh=IbldVPHNz9zzb+JEgV4LyfJbvojGwsw+3a21bXkCHwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/1l4U7C5M9Qd+5bcCImvV+5LQGFNFVgtr1uL9WpbIpBe8Hra0Sf8doCPU082laU3
         KNcj2NVwxvRp7kxaDCyOnhWFsGTukR1Hx6vSCHHoay/BitomlssDb4k4Wk9J4IBrRY
         U06DTYB16tDBskKuo/XxjoKfFp+XOXHRXLq1Wyno=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 016/127] crypto: user - support incremental algorithm dumps
Date:   Fri, 22 Nov 2019 00:53:54 -0500
Message-Id: <20191122055544.3299-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 0ac6b8fb23c724b015d9ca70a89126e8d1563166 ]

CRYPTO_MSG_GETALG in NLM_F_DUMP mode sometimes doesn't return all
registered crypto algorithms, because it doesn't support incremental
dumps.  crypto_dump_report() only permits itself to be called once, yet
the netlink subsystem allocates at most ~64 KiB for the skb being dumped
to.  Thus only the first recvmsg() returns data, and it may only include
a subset of the crypto algorithms even if the user buffer passed to
recvmsg() is large enough to hold all of them.

Fix this by using one of the arguments in the netlink_callback structure
to keep track of the current position in the algorithm list.  Then
userspace can do multiple recvmsg() on the socket after sending the dump
request.  This is the way netlink dumps work elsewhere in the kernel;
it's unclear why this was different (probably just an oversight).

Also fix an integer overflow when calculating the dump buffer size hint.

Fixes: a38f7907b926 ("crypto: Add userspace configuration API")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/crypto_user.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 2b8fb8f1391e0..5e457a7dd1c92 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -296,30 +296,33 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 
 static int crypto_dump_report(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct crypto_alg *alg;
+	const size_t start_pos = cb->args[0];
+	size_t pos = 0;
 	struct crypto_dump_info info;
-	int err;
-
-	if (cb->args[0])
-		goto out;
-
-	cb->args[0] = 1;
+	struct crypto_alg *alg;
+	int res;
 
 	info.in_skb = cb->skb;
 	info.out_skb = skb;
 	info.nlmsg_seq = cb->nlh->nlmsg_seq;
 	info.nlmsg_flags = NLM_F_MULTI;
 
+	down_read(&crypto_alg_sem);
 	list_for_each_entry(alg, &crypto_alg_list, cra_list) {
-		err = crypto_report_alg(alg, &info);
-		if (err)
-			goto out_err;
+		if (pos >= start_pos) {
+			res = crypto_report_alg(alg, &info);
+			if (res == -EMSGSIZE)
+				break;
+			if (res)
+				goto out;
+		}
+		pos++;
 	}
-
+	cb->args[0] = pos;
+	res = skb->len;
 out:
-	return skb->len;
-out_err:
-	return err;
+	up_read(&crypto_alg_sem);
+	return res;
 }
 
 static int crypto_dump_report_done(struct netlink_callback *cb)
@@ -503,7 +506,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if ((type == (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE) &&
 	    (nlh->nlmsg_flags & NLM_F_DUMP))) {
 		struct crypto_alg *alg;
-		u16 dump_alloc = 0;
+		unsigned long dump_alloc = 0;
 
 		if (link->dump == NULL)
 			return -EINVAL;
@@ -511,16 +514,16 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		down_read(&crypto_alg_sem);
 		list_for_each_entry(alg, &crypto_alg_list, cra_list)
 			dump_alloc += CRYPTO_REPORT_MAXSIZE;
+		up_read(&crypto_alg_sem);
 
 		{
 			struct netlink_dump_control c = {
 				.dump = link->dump,
 				.done = link->done,
-				.min_dump_alloc = dump_alloc,
+				.min_dump_alloc = min(dump_alloc, 65535UL),
 			};
 			err = netlink_dump_start(crypto_nlsk, skb, nlh, &c);
 		}
-		up_read(&crypto_alg_sem);
 
 		return err;
 	}
-- 
2.20.1


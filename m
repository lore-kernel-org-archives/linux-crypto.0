Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B09C2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 12:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 318A520702
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 12:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgA0MdP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 07:33:15 -0500
Received: from foss.arm.com ([217.140.110.172]:43906 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbgA0MdP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 07:33:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0850830E;
        Mon, 27 Jan 2020 04:33:15 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2C023F52E;
        Mon, 27 Jan 2020 04:33:13 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: testmgr - properly mark the end of scatterlist
Date:   Mon, 27 Jan 2020 14:33:11 +0200
Message-Id: <20200127123311.7137-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The inauthentic AEAD test were using a scatterlist which
could have a mismarked end node.

Fixes: 49763fc6b1 ("crypto: testmgr - generate inauthentic AEAD test vectors")
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

---
 crypto/testmgr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 88f33c0efb23..6c432aecff97 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2225,6 +2225,8 @@ static void generate_aead_message(struct aead_request *req,
 			generate_random_bytes((u8 *)vec->ptext, vec->plen);
 			sg_set_buf(&src[i++], vec->ptext, vec->plen);
 		}
+		if (i)
+			sg_mark_end(&src[(i-1)]);
 		sg_init_one(&dst, vec->ctext, vec->alen + vec->clen);
 		memcpy(iv, vec->iv, ivsize);
 		aead_request_set_callback(req, 0, crypto_req_done, &wait);
-- 
2.23.0


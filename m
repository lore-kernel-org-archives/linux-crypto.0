Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B63C3A5A9
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8AC5208DB
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397630;
	bh=aRnhsnypAWsWXKVWbib/6Chk6PgcC0D+Q1jEbEW+EEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=b2c3VTJlijeJq9rHS9pssAcosoClZ3dRjrEopZ7iIpsx2BOmybeHPmrspWkencH6+
	 ON5FrDgz0SMEujHbed8nVe0DdNJFYEpl5JtjtS+zLcHFA4KNsXLYwnOB94szp/48/9
	 RreEJJ+AfvhqFgVbD+MsciEq6rIu+e5SBLF445hk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgEBFdu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgEBFdq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:46 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C6924956;
        Sat,  2 May 2020 05:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397625;
        bh=aRnhsnypAWsWXKVWbib/6Chk6PgcC0D+Q1jEbEW+EEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTGKbB6CEORZGYYUIt9JxkJSWjc4AMdJy/Ebcqg1ZEvcjNV7zjU8yAoCxLfvgP6p/
         GpQs4ja/Otvda6MMGOV78JogJg2t6gr+50RB3vkM0+xAL3oIxIeqJdhj0Hb1ot5mo0
         /x72PV9ExK8jtq2rF5WYPlnNqYV+DnwY/s5p22iA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-bluetooth@vger.kernel.org
Subject: [PATCH 17/20] Bluetooth: use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:19 -0700
Message-Id: <20200502053122.995648-18-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502053122.995648-1-ebiggers@kernel.org>
References: <20200502053122.995648-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of manually allocating a 'struct shash_desc' on the stack and
calling crypto_shash_digest(), switch to using the new helper function
crypto_shash_tfm_digest() which does this for us.

Cc: linux-bluetooth@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/bluetooth/smp.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 1476a91ce93572..d022f126eb026b 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -170,7 +170,6 @@ static int aes_cmac(struct crypto_shash *tfm, const u8 k[16], const u8 *m,
 		    size_t len, u8 mac[16])
 {
 	uint8_t tmp[16], mac_msb[16], msg_msb[CMAC_MSG_MAX];
-	SHASH_DESC_ON_STACK(desc, tfm);
 	int err;
 
 	if (len > CMAC_MSG_MAX)
@@ -181,8 +180,6 @@ static int aes_cmac(struct crypto_shash *tfm, const u8 k[16], const u8 *m,
 		return -EINVAL;
 	}
 
-	desc->tfm = tfm;
-
 	/* Swap key and message from LSB to MSB */
 	swap_buf(k, tmp, 16);
 	swap_buf(m, msg_msb, len);
@@ -196,8 +193,7 @@ static int aes_cmac(struct crypto_shash *tfm, const u8 k[16], const u8 *m,
 		return err;
 	}
 
-	err = crypto_shash_digest(desc, msg_msb, len, mac_msb);
-	shash_desc_zero(desc);
+	err = crypto_shash_tfm_digest(tfm, msg_msb, len, mac_msb);
 	if (err) {
 		BT_ERR("Hash computation error %d", err);
 		return err;
-- 
2.26.2


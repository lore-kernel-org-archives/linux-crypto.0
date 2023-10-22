Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1C6CDB474
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjJVITL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjJVISw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2AFD46
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EADC433C9
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962729;
        bh=hxgXz4/fEI7XnX3NFAUSs9aMdV4IPK6z/hrrnU2Nvfo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GmWDDBr9e8TP8QUybW5LK1J7jObsVWYTFRwx3Hz+oJ/nvRD6k1A7ahZD+lH9EjoRz
         5w73kqm5DcJID/I+NV/2wStfjMMkAZhUMOSfGVxOeXj/WlTsSEA5LzF5rz4TXbhymE
         1/egnMlpFvL/8ZEZ7MRkKx2ySaT/2yX+aiuSuCgLqQ6fuBepxMdIN68a/oIzKFcN5E
         t3l8nLg5+Tx14vIbj6cvpGadJOwJvYXutCnL4d4YjNTMLntQHxRWrgAzjXQFhob1wn
         3aCRHxj6k78wHpN7p2Bqb5i+kRoIKMkQLkB+ndyUq7lrOVtUBEP5tAaQzAZeO2vv9a
         yrXlM8ksYJbNg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 25/30] crypto: ahash - improve file comment
Date:   Sun, 22 Oct 2023 01:10:55 -0700
Message-ID: <20231022081100.123613-26-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Improve the file comment for crypto/ahash.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 556c950100936..1ad402f4dac6c 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -1,16 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Asynchronous Cryptographic Hash operations.
  *
- * This is the asynchronous version of hash.c with notification of
- * completion via a callback.
+ * This is the implementation of the ahash (asynchronous hash) API.  It differs
+ * from shash (synchronous hash) in that ahash supports asynchronous operations,
+ * and it hashes data from scatterlists instead of virtually addressed buffers.
+ *
+ * The ahash API provides access to both ahash and shash algorithms.  The shash
+ * API only provides access to shash algorithms.
  *
  * Copyright (c) 2008 Loc Ho <lho@amcc.com>
  */
 
 #include <crypto/scatterwalk.h>
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-- 
2.42.0


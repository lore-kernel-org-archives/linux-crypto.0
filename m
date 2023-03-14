Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9787FC6FD19
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Mar 2023 02:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjCNCrj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Mar 2023 22:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCNCri (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Mar 2023 22:47:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8958E3C5;
        Mon, 13 Mar 2023 19:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=7XPPL7nwlO9qfQsOrR7OZiZJkx7m8TBAeAeafc1B5Is=; b=Twv/ZWYHldNJldvrOpN5Nmz6Ov
        0yJ9tqJ1KPkgHHS1pb+xmqd08SWiHgPZFkitvPCzx9kF9GTtVgMeRNQklSdMaZIELRQYDihcG3yXC
        ua8GxZ9+yWlcNlauCKZp58UbIb4svY8dTrAtPHGgntITPXItcaMbTLGm8/bvD2mJ2605I2LEGuw6r
        kn3x/7GvC0l10L02XzicXcDXGBEgT0P7O/l3pPOwraVPd7rAP+M1jsId34i+886gHlmPUe0WEH3E4
        mNKnEYGqTmYamvU0DnU1Bbi3qw5eI1T54ALHo1JdSOQ1t+787OL6Z1F1QtFW25nW4/turgOkBm7pZ
        oJmb9vDw==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pbuhL-008ke9-0R; Tue, 14 Mar 2023 02:47:35 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2] async_tx: fix kernel-doc notation warnings
Date:   Mon, 13 Mar 2023 19:47:34 -0700
Message-Id: <20230314024734.9066-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix kernel-doc warnings by adding "struct" keyword or "enum" keyword.
Also fix 2 function parameter descriptions.
Change some functions and structs from kernel-doc /** notation
to regular /* comment notation.

async_pq.c:18: warning: cannot understand function prototype: 'struct page *pq_scribble_page; '
async_pq.c:18: error: Cannot parse struct or union!
async_pq.c:40: warning: No description found for return value of 'do_async_gen_syndrome'
async_pq.c:109: warning: Function parameter or member 'blocks' not described in 'do_sync_gen_syndrome'
async_pq.c:109: warning: Function parameter or member 'offsets' not described in 'do_sync_gen_syndrome'
async_pq.c:109: warning: Function parameter or member 'disks' not described in 'do_sync_gen_syndrome'
async_pq.c:109: warning: Function parameter or member 'len' not described in 'do_sync_gen_syndrome'
async_pq.c:109: warning: Function parameter or member 'submit' not described in 'do_sync_gen_syndrome'

async_tx.c:136: warning: cannot understand function prototype: 'enum submit_disposition '
async_tx.c:264: warning: Function parameter or member 'tx' not described in 'async_tx_quiesce'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
v2: fix more warnings

 crypto/async_tx/async_pq.c |   10 +++++-----
 crypto/async_tx/async_tx.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -- a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -11,8 +11,8 @@
 #include <linux/async_tx.h>
 #include <linux/gfp.h>
 
-/**
- * pq_scribble_page - space to hold throwaway P or Q buffer for
+/*
+ * struct pq_scribble_page - space to hold throwaway P or Q buffer for
  * synchronous gen_syndrome
  */
 static struct page *pq_scribble_page;
@@ -28,7 +28,7 @@ static struct page *pq_scribble_page;
 
 #define MAX_DISKS 255
 
-/**
+/*
  * do_async_gen_syndrome - asynchronously calculate P and/or Q
  */
 static __async_inline struct dma_async_tx_descriptor *
@@ -100,7 +100,7 @@ do_async_gen_syndrome(struct dma_chan *c
 	return tx;
 }
 
-/**
+/*
  * do_sync_gen_syndrome - synchronously calculate a raid6 syndrome
  */
 static void
@@ -281,7 +281,7 @@ pq_val_chan(struct async_submit_ctl *sub
 /**
  * async_syndrome_val - asynchronously validate a raid6 syndrome
  * @blocks: source blocks from idx 0..disks-3, P @ disks-2 and Q @ disks-1
- * @offset: common offset into each block (src and dest) to start transaction
+ * @offsets: common offset into each block (src and dest) to start transaction
  * @disks: number of blocks (including missing P or Q, see below)
  * @len: length of operation in bytes
  * @pqres: on val failure SUM_CHECK_P_RESULT and/or SUM_CHECK_Q_RESULT are set
diff -- a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -124,7 +124,7 @@ async_tx_channel_switch(struct dma_async
 
 
 /**
- * submit_disposition - flags for routing an incoming operation
+ * enum submit_disposition - flags for routing an incoming operation
  * @ASYNC_TX_SUBMITTED: we were able to append the new operation under the lock
  * @ASYNC_TX_CHANNEL_SWITCH: when the lock is dropped schedule a channel switch
  * @ASYNC_TX_DIRECT_SUBMIT: when the lock is dropped submit directly
@@ -258,7 +258,7 @@ EXPORT_SYMBOL_GPL(async_trigger_callback
 
 /**
  * async_tx_quiesce - ensure tx is complete and freeable upon return
- * @tx - transaction to quiesce
+ * @tx: transaction to quiesce
  */
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx)
 {

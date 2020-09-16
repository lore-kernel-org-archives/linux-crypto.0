Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED32DC433E2
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 04:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ADA121D1B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 04:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600231117;
	bh=ef0jmdePJqpF6qYmBxPABOU4mYpFVLCATDzgvbF9ElQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=vqvtJQaOpRCnnfnAmB50VATyJ5seQaqWDAPCcUMyRauokK/Yuc9gw6vABQC86cR6v
	 0mbuE8q58yEdI99ZQiljexY6CJtqP1O1Lk4NJQElStEsXUkTwb0H227biHJxfaSZFb
	 0WSlHqBxW4qpNwts7yc81UePrXrnEvoq6VsWP0ZA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgIPEig (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 00:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgIPEig (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 00:38:36 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8345120936;
        Wed, 16 Sep 2020 04:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600231115;
        bh=ef0jmdePJqpF6qYmBxPABOU4mYpFVLCATDzgvbF9ElQ=;
        h=From:To:Cc:Subject:Date:From;
        b=1lqiR9v+e+b2HVo8Sqcb1nidQxD7Bm1ZJzttncJwM0n3Nwm90f67S38fjcycV4kWA
         6PJaIguZu+Djo36Hvamg47Qhf6b8tUM0GjoWPgHjCtF60oHExY1LFcCPiLEndNuu/c
         mliSELkQ9ZLDg7stG8uwxzZMKhX1py+dRBl8yh70=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH] random: remove dead code left over from blocking pool
Date:   Tue, 15 Sep 2020 21:36:52 -0700
Message-Id: <20200916043652.96640-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Remove some dead code that was left over following commit 90ea1c6436d2
("random: remove the blocking pool").

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/char/random.c         | 17 ++-----
 include/trace/events/random.h | 83 -----------------------------------
 2 files changed, 3 insertions(+), 97 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a8b9e66f41435..26f0a23a6f021 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -500,7 +500,6 @@ struct entropy_store {
 	unsigned short add_ptr;
 	unsigned short input_rotate;
 	int entropy_count;
-	unsigned int initialized:1;
 	unsigned int last_data_init:1;
 	__u8 last_data[EXTRACT_SIZE];
 };
@@ -660,7 +659,7 @@ static void process_random_ready_list(void)
  */
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
-	int entropy_count, orig, has_initialized = 0;
+	int entropy_count, orig;
 	const int pool_size = r->poolinfo->poolfracbits;
 	int nfrac = nbits << ENTROPY_SHIFT;
 
@@ -717,23 +716,14 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-	if (has_initialized) {
-		r->initialized = 1;
-		kill_fasync(&fasync, SIGIO, POLL_IN);
-	}
-
 	trace_credit_entropy_bits(r->name, nbits,
 				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
 
 	if (r == &input_pool) {
 		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
 
-		if (crng_init < 2) {
-			if (entropy_bits < 128)
-				return;
+		if (crng_init < 2 && entropy_bits >= 128)
 			crng_reseed(&primary_crng, r);
-			entropy_bits = ENTROPY_BITS(r);
-		}
 	}
 }
 
@@ -1386,8 +1376,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 }
 
 /*
- * This function does the actual extraction for extract_entropy and
- * extract_entropy_user.
+ * This function does the actual extraction for extract_entropy.
  *
  * Note: we assume that .poolwords is a multiple of 16 words.
  */
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
index 9570a10cb949b..3d7b432ca5f31 100644
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -85,28 +85,6 @@ TRACE_EVENT(credit_entropy_bits,
 		  __entry->entropy_count, (void *)__entry->IP)
 );
 
-TRACE_EVENT(push_to_pool,
-	TP_PROTO(const char *pool_name, int pool_bits, int input_bits),
-
-	TP_ARGS(pool_name, pool_bits, input_bits),
-
-	TP_STRUCT__entry(
-		__field( const char *,	pool_name		)
-		__field(	  int,	pool_bits		)
-		__field(	  int,	input_bits		)
-	),
-
-	TP_fast_assign(
-		__entry->pool_name	= pool_name;
-		__entry->pool_bits	= pool_bits;
-		__entry->input_bits	= input_bits;
-	),
-
-	TP_printk("%s: pool_bits %d input_pool_bits %d",
-		  __entry->pool_name, __entry->pool_bits,
-		  __entry->input_bits)
-);
-
 TRACE_EVENT(debit_entropy,
 	TP_PROTO(const char *pool_name, int debit_bits),
 
@@ -161,35 +139,6 @@ TRACE_EVENT(add_disk_randomness,
 		  MINOR(__entry->dev), __entry->input_bits)
 );
 
-TRACE_EVENT(xfer_secondary_pool,
-	TP_PROTO(const char *pool_name, int xfer_bits, int request_bits,
-		 int pool_entropy, int input_entropy),
-
-	TP_ARGS(pool_name, xfer_bits, request_bits, pool_entropy,
-		input_entropy),
-
-	TP_STRUCT__entry(
-		__field( const char *,	pool_name		)
-		__field(	  int,	xfer_bits		)
-		__field(	  int,	request_bits		)
-		__field(	  int,	pool_entropy		)
-		__field(	  int,	input_entropy		)
-	),
-
-	TP_fast_assign(
-		__entry->pool_name	= pool_name;
-		__entry->xfer_bits	= xfer_bits;
-		__entry->request_bits	= request_bits;
-		__entry->pool_entropy	= pool_entropy;
-		__entry->input_entropy	= input_entropy;
-	),
-
-	TP_printk("pool %s xfer_bits %d request_bits %d pool_entropy %d "
-		  "input_entropy %d", __entry->pool_name, __entry->xfer_bits,
-		  __entry->request_bits, __entry->pool_entropy,
-		  __entry->input_entropy)
-);
-
 DECLARE_EVENT_CLASS(random__get_random_bytes,
 	TP_PROTO(int nbytes, unsigned long IP),
 
@@ -253,38 +202,6 @@ DEFINE_EVENT(random__extract_entropy, extract_entropy,
 	TP_ARGS(pool_name, nbytes, entropy_count, IP)
 );
 
-DEFINE_EVENT(random__extract_entropy, extract_entropy_user,
-	TP_PROTO(const char *pool_name, int nbytes, int entropy_count,
-		 unsigned long IP),
-
-	TP_ARGS(pool_name, nbytes, entropy_count, IP)
-);
-
-TRACE_EVENT(random_read,
-	TP_PROTO(int got_bits, int need_bits, int pool_left, int input_left),
-
-	TP_ARGS(got_bits, need_bits, pool_left, input_left),
-
-	TP_STRUCT__entry(
-		__field(	  int,	got_bits		)
-		__field(	  int,	need_bits		)
-		__field(	  int,	pool_left		)
-		__field(	  int,	input_left		)
-	),
-
-	TP_fast_assign(
-		__entry->got_bits	= got_bits;
-		__entry->need_bits	= need_bits;
-		__entry->pool_left	= pool_left;
-		__entry->input_left	= input_left;
-	),
-
-	TP_printk("got_bits %d still_needed_bits %d "
-		  "blocking_pool_entropy_left %d input_entropy_left %d",
-		  __entry->got_bits, __entry->got_bits, __entry->pool_left,
-		  __entry->input_left)
-);
-
 TRACE_EVENT(urandom_read,
 	TP_PROTO(int got_bits, int pool_left, int input_left),
 
-- 
2.28.0


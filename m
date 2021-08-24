Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1DDC4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Aug 2021 21:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22F5A61220
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Aug 2021 21:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhHXVGC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Aug 2021 17:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhHXVGC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Aug 2021 17:06:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF11C061757;
        Tue, 24 Aug 2021 14:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=47sgnIoZKep1DRbln9+NTL1J6N65R7OgQCZZ3ODQ1JU=; b=XdIxM4Rp2nAdP6b3OPoUPX1wcl
        CGgh1FBE2vcOUw38/OhpKrOwanD6szssU48tKUas2UKyOJSUH4peFM3/nAVwRHLQEFrtw+72JyBMo
        LwHu2cNxj/J8Y2LjRlkSPy/fkZbTOX2j+Sw2DUdKNNBtep/PCyTMzLHe6Q4xzM3yZXnOICbBO4n+d
        /ELvDWYz2KtyKUfRiyd2i9TR2x+ntfhMrtwq/DHGFstxbYYuylORFsM9ZURkHne/bxERKzG5M7kaQ
        ukmXkSM+InShYPHlPNTKdTLDoTM2UZCqO7dszR/6WLQIm2oxhvo7Aglv2CV/8eDi2iGqS3FmxgmwP
        GK6ZwvoQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIdbf-004hpu-F7; Tue, 24 Aug 2021 21:05:15 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: jitterentopy: drop kernel-doc notation
Date:   Tue, 24 Aug 2021 14:05:13 -0700
Message-Id: <20210824210513.25503-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Drop "begin kernel-doc (/**)" entries in jitterentropy.c
since they are not in kernel-doc format and they cause
many complaints (warnings) from scripts/kernel-doc.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 crypto/jitterentropy.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- linux-next-20210824.orig/crypto/jitterentropy.c
+++ linux-next-20210824/crypto/jitterentropy.c
@@ -125,7 +125,7 @@ struct rand_data {
  * This test complies with SP800-90B section 4.4.2.
  ***************************************************************************/
 
-/**
+/*
  * Reset the APT counter
  *
  * @ec [in] Reference to entropy collector
@@ -138,7 +138,7 @@ static void jent_apt_reset(struct rand_d
 	ec->apt_observations = 0;
 }
 
-/**
+/*
  * Insert a new entropy event into APT
  *
  * @ec [in] Reference to entropy collector
@@ -182,7 +182,7 @@ static void jent_apt_insert(struct rand_
  * the end. The caller of the Jitter RNG is informed with an error code.
  ***************************************************************************/
 
-/**
+/*
  * Repetition Count Test as defined in SP800-90B section 4.4.1
  *
  * @ec [in] Reference to entropy collector
@@ -223,7 +223,7 @@ static void jent_rct_insert(struct rand_
 	}
 }
 
-/**
+/*
  * Is there an RCT health test failure?
  *
  * @ec [in] Reference to entropy collector
@@ -246,7 +246,7 @@ static inline __u64 jent_delta(__u64 pre
 			       (JENT_UINT64_MAX - prev + 1 + next);
 }
 
-/**
+/*
  * Stuck test by checking the:
  * 	1st derivative of the jitter measurement (time delta)
  * 	2nd derivative of the jitter measurement (delta of time deltas)
@@ -288,7 +288,7 @@ static int jent_stuck(struct rand_data *
 	return 0;
 }
 
-/**
+/*
  * Report any health test failures
  *
  * @ec [in] Reference to entropy collector
@@ -310,7 +310,7 @@ static int jent_health_failure(struct ra
  * Noise sources
  ***************************************************************************/
 
-/**
+/*
  * Update of the loop count used for the next round of
  * an entropy collection.
  *
@@ -353,7 +353,7 @@ static __u64 jent_loop_shuffle(struct ra
 	return (shuffle + (1<<min));
 }
 
-/**
+/*
  * CPU Jitter noise source -- this is the noise source based on the CPU
  *			      execution time jitter
  *
@@ -435,7 +435,7 @@ static void jent_lfsr_time(struct rand_d
 		ec->data = new;
 }
 
-/**
+/*
  * Memory Access noise source -- this is a noise source based on variations in
  *				 memory access times
  *
@@ -500,7 +500,7 @@ static void jent_memaccess(struct rand_d
 /***************************************************************************
  * Start of entropy processing logic
  ***************************************************************************/
-/**
+/*
  * This is the heart of the entropy generation: calculate time deltas and
  * use the CPU jitter in the time deltas. The jitter is injected into the
  * entropy pool.
@@ -539,7 +539,7 @@ static int jent_measure_jitter(struct ra
 	return stuck;
 }
 
-/**
+/*
  * Generator of one 64 bit random number
  * Function fills rand_data->data
  *
@@ -566,7 +566,7 @@ static void jent_gen_entropy(struct rand
 	}
 }
 
-/**
+/*
  * Entry function: Obtain entropy for the caller.
  *
  * This function invokes the entropy gathering logic as often to generate

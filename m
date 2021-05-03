Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EA5C43603
	for <linux-crypto@archiver.kernel.org>; Mon,  3 May 2021 16:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0716061165
	for <linux-crypto@archiver.kernel.org>; Mon,  3 May 2021 16:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhECQwL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 May 2021 12:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234625AbhECQuh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 May 2021 12:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BEFE61933;
        Mon,  3 May 2021 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060068;
        bh=zdyythD21HvJgoFCj/9ADYkiuDf0zulSgc++zqebsM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKuThHXxp2hCsd3CNaCss2V08JFRvOoGYqLXpfpfvTDC8yj0pNIxGA2C72NFI3CWg
         h58s1yFOld4dSo+l5bhK9Qgfs7lyU/kL2EGiIcuknEuHiehL1EsljDP3Fm+F2G9Rya
         Qw/lCuuZBq7xOEfsbKvxdLlrqkB60KSABW6bKZbovPw/yHGNILhZC8S6DMRgHEy4A6
         XZx20hC2PM7GCTMFxZ3KnfOpsfOMuBwxuUOKWDaDqSFcefFFGtC0W9IsZ3324WoQmr
         P8Pd2vaaPnGGnMM9/70WOxXSi7gHtOotcHfFm4zr94cxnWwsxM/7uRwoKUZCim8W9w
         hv8RRDBMzVupA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 57/57] s390/archrandom: add parameter check for s390_arch_random_generate
Date:   Mon,  3 May 2021 12:39:41 -0400
Message-Id: <20210503163941.2853291-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 28096067686c5a5cbd4c35b079749bd805df5010 ]

A review of the code showed, that this function which is exposed
within the whole kernel should do a parameter check for the
amount of bytes requested. If this requested bytes is too high
an unsigned int overflow could happen causing this function to
try to memcpy a really big memory chunk.

This is not a security issue as there are only two invocations
of this function from arch/s390/include/asm/archrandom.h and both
are not exposed to userland.

Reported-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/arch_random.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/crypto/arch_random.c b/arch/s390/crypto/arch_random.c
index dd95cdbd22ce..4cbb4b6d85a8 100644
--- a/arch/s390/crypto/arch_random.c
+++ b/arch/s390/crypto/arch_random.c
@@ -53,6 +53,10 @@ static DECLARE_DELAYED_WORK(arch_rng_work, arch_rng_refill_buffer);
 
 bool s390_arch_random_generate(u8 *buf, unsigned int nbytes)
 {
+	/* max hunk is ARCH_RNG_BUF_SIZE */
+	if (nbytes > ARCH_RNG_BUF_SIZE)
+		return false;
+
 	/* lock rng buffer */
 	if (!spin_trylock(&arch_rng_lock))
 		return false;
-- 
2.30.2


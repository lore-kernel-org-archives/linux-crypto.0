Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30F1C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A756611CA
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240399AbhI1Lzn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:55:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35108 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240333AbhI1Lzn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:55:43 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632830043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=q6ZiZEt9zXvOc1x4dbKXEQBGqtl6yr9WUFCAW1JLw4g=;
        b=o+n5D+Vs3cNItZJ3h8KbAGhdjcfcNZH6JGf7PnJeVht/ultV51ejkumGGWMp9urPMYoC94
        yCtS9QlCOUwBuroNIcXV9U223GSU3wUmVood+zWCvnwDqSJEkGu7Pvm9itdg48PM5vgbqn
        TGaVxx9TSZdrhMMC4T2StO53/jrNmgNqOxK0lKau7Haf3FSjc6unmyx+LMiIotgRTjHlVx
        GiAKxO9V7nasWOXYfGfHU+c1AZt6Pa55cOZwmB1hrDP6aHZj030SgulNkZDtj9kJSAAEom
        DAFfooxB1S35HjjlMnlLzIXyD13HLn7NO8YuVJwP5llkFBY3UPldwuz2L94pxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632830043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=q6ZiZEt9zXvOc1x4dbKXEQBGqtl6yr9WUFCAW1JLw4g=;
        b=mMVzltQSxnPw9DDjvSin1tjgbBcUqe980QR2bxsHQOOveNHC1C3llr+LfGTp53qcCSFEqQ
        3fc+M/90l6v8nIBQ==
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] crypto: testmgr - Only disable migration in crypto_disable_simd_for_test()
Date:   Tue, 28 Sep 2021 13:54:01 +0200
Message-Id: <20210928115401.441339-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto_disable_simd_for_test() disables preemption in order to receive a
stable per-CPU variable which it needs to modify in order to alter
crypto_simd_usable() results.

This can also be achived by migrate_disable() which forbidds CPU
migrations but allows the task to be preempted. The latter is important
for PREEMPT_RT since operation like skcipher_walk_first() may allocate
memory which must not happen with disabled preemption on PREEMPT_RT.

Use migrate_disable() in crypto_disable_simd_for_test() to achieve a
stable per-CPU pointer.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 crypto/testmgr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1061,14 +1061,14 @@ static void generate_random_testvec_conf
=20
 static void crypto_disable_simd_for_test(void)
 {
-	preempt_disable();
+	migrate_disable();
 	__this_cpu_write(crypto_simd_disabled_for_test, true);
 }
=20
 static void crypto_reenable_simd_for_test(void)
 {
 	__this_cpu_write(crypto_simd_disabled_for_test, false);
-	preempt_enable();
+	migrate_enable();
 }
=20
 /*

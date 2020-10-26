Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC1EC4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7D5C223B0
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603729883;
	bh=MTPHc+S08fiqQAVPAwWlhdCsTMBQ3H9N6V5zlLtpfsY=;
	h=From:To:Subject:Date:List-ID:From;
	b=GYsrn1pOAN86Ijyxnev76fURQMdiDb3GcSZNsIMe4OIzlqMUAXRynX6yOBUIixmD/
	 FfEo+FAGWM4X3D1NIW5oMO50Ufail3vm2+Y0hQ3e4You0Hxwvj1bo4OeUap+Kntkjn
	 vd4Y/u3lipW/UifEKeXFhVyU+l/kSpj4CX583L/0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786005AbgJZQbX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1786003AbgJZQbW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 12:31:22 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AD8C2224A
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603729882;
        bh=MTPHc+S08fiqQAVPAwWlhdCsTMBQ3H9N6V5zlLtpfsY=;
        h=From:To:Subject:Date:From;
        b=p0jmVsOHLsS9GruV5Wl2rjCTF9OT2WYa3wCIXeRpBDLFTwY4Zt5vwow3enT1goBrI
         2Q7ZYXtyVzVMdFVbctmK7D5QsA1hV3xuqCsO57cKKeOCaCnIpg2x6FrT1SmQJMAV5P
         VTV+HWpn7UMQyNRXBwEbB1VKo/Gke8JWLMfa4xd4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: testmgr - WARN on test failure
Date:   Mon, 26 Oct 2020 09:31:12 -0700
Message-Id: <20201026163112.45163-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, by default crypto self-test failures only result in a
pr_warn() message and an "unknown" status in /proc/crypto.  Both of
these are easy to miss.  There is also an option to panic the kernel
when a test fails, but that can't be the default behavior.

A crypto self-test failure always indicates a kernel bug, however, and
there's already a standard way to report (recoverable) kernel bugs --
the WARN() family of macros.  WARNs are noisier and harder to miss, and
existing test systems already know to look for them in dmesg or via
/proc/sys/kernel/tainted.

Therefore, call WARN() when an algorithm fails its self-tests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a64a639eddfa4..403d27c3e5165 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5677,15 +5677,21 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 					     type, mask);
 
 test_done:
-	if (rc && (fips_enabled || panic_on_fail)) {
-		fips_fail_notify();
-		panic("alg: self-tests for %s (%s) failed in %s mode!\n",
-		      driver, alg, fips_enabled ? "fips" : "panic_on_fail");
+	if (rc) {
+		if (fips_enabled || panic_on_fail) {
+			fips_fail_notify();
+			panic("alg: self-tests for %s (%s) failed in %s mode!\n",
+			      driver, alg,
+			      fips_enabled ? "fips" : "panic_on_fail");
+		}
+		WARN(1, "alg: self-tests for %s (%s) failed (rc=%d)",
+		     driver, alg, rc);
+	} else {
+		if (fips_enabled)
+			pr_info("alg: self-tests for %s (%s) passed\n",
+				driver, alg);
 	}
 
-	if (fips_enabled && !rc)
-		pr_info("alg: self-tests for %s (%s) passed\n", driver, alg);
-
 	return rc;
 
 notest:

base-commit: 3650b228f83adda7e5ee532e2b90429c03f7b9ec
-- 
2.29.1


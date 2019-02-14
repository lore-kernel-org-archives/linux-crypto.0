Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868B4C10F04
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E588222D8
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550131458;
	bh=Odq0J8BRaUnBcoUJ34F+4vLXd2arfKXwyu29h/51n4M=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HTR15pXZtZ4deGpgs+qoO0pJm4M0ZToOuGY4v6bejg4C0DIIpLmFAmIelzyec9AX5
	 ls5L5qugCsAtkuUdI5uPJ5QoFfot42907htIXy7L2kCk0S73XuQAw0aHU7tiTAtJLM
	 pM9d9xrxEyhDwT0qbvDsnN7PnPRjoLrI9nGYI2Qc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388779AbfBNIER (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391867AbfBNIER (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:04:17 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA44222D2;
        Thu, 14 Feb 2019 08:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550131457;
        bh=Odq0J8BRaUnBcoUJ34F+4vLXd2arfKXwyu29h/51n4M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=u/lSg3A0GBnRgkyBi4Z1BMvbYoX+6COTUfaOZ/fIhzbWbc8Ootb8BhsF722CwIwOE
         wByLmtAX7zaCD95X2Bg2iKhG3MVLd/8KuN2K+L3CXnNBOZMUiy+3cDQ9C7koZ1iWM6
         iL+utyWlsMwbYK8JiDuLd1mnaXHwt71XdB2MXzEc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/6] crypto: testmgr - remove extra bytes from 3DES-CTR IVs
Date:   Thu, 14 Feb 2019 00:03:50 -0800
Message-Id: <20190214080355.8112-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214080355.8112-1-ebiggers@kernel.org>
References: <20190214080355.8112-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

3DES only has an 8-byte block size, but the 3DES-CTR test vectors use
16-byte IVs.  Remove the unused 8 bytes from the ends of the IVs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 8f1d30b54a76..e01c77eeded3 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -7580,8 +7580,7 @@ static const struct cipher_testvec des3_ede_ctr_tv_template[] = {
 			  "\x5A\x67\x00\x2D\xCE\xEB\x2D\xCE"
 			  "\xEB\xB4\x51\x72\xB4\x51\x72\x1F",
 		.klen	= 24,
-		.iv	= "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
-			  "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD",
+		.iv	= "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF",
 		.ptext	= "\x05\xEC\x77\xFB\x42\xD5\x59\x20"
 			  "\x8B\x12\x86\x69\xF0\x5B\xCF\x56"
 			  "\x39\xAD\x34\x9F\x66\xEA\x7D\xC4"
@@ -7712,8 +7711,7 @@ static const struct cipher_testvec des3_ede_ctr_tv_template[] = {
 			  "\x5A\x67\x00\x2D\xCE\xEB\x2D\xCE"
 			  "\xEB\xB4\x51\x72\xB4\x51\x72\x1F",
 		.klen	= 24,
-		.iv	= "\xB2\xD7\x48\xED\x06\x44\xF9\x12"
-			  "\xB7\x28\x4D\x83\x24\x59\xF2\x17",
+		.iv	= "\xB2\xD7\x48\xED\x06\x44\xF9\x12",
 		.ptext	= "\x05\xEC\x77\xFB\x42\xD5\x59\x20"
 			  "\x8B\x12\x86\x69\xF0\x5B\xCF\x56"
 			  "\x39\xAD\x34\x9F\x66\xEA\x7D\xC4"
-- 
2.20.1


Return-Path: <SRS0=phSf=Q6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D92C10F07
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 06:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DF7120854
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 06:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550904898;
	bh=2XrlCUT7qEpiaH1OBGcETHEtJDXAxNreBpz708hMj6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ppZUT3dFs3Tup/wjAS850ZRirevq9Ovlkb1cc5pkrflESsjUa5JFvLudwMDsBdTJ1
	 CVx3NwrG+iEWu5ipD1SMKY2OhpXNfcyWAuiKdkog21qopkhIZuyzjWs1Fd3dDL9hCL
	 3Hzq/SHC0FgbzlUpQhHJtCRKEnuWbpRd2BmOpoSQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfBWGy5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Feb 2019 01:54:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfBWGy5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Feb 2019 01:54:57 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE87B20850;
        Sat, 23 Feb 2019 06:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550904896;
        bh=2XrlCUT7qEpiaH1OBGcETHEtJDXAxNreBpz708hMj6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dH8pG9IsMdbMk6KKeeKvBeeScV/LFII8AuBpV861tCOE5IirCGhlcS1kXSxCk+n/c
         yTbJJDb+KAME+nUkHH4DqyQNWn2exSmBnZPN6kpQ+Oh9aekLD/qrwYd6JaM+e7uen5
         XD5UQLIYhmLiPoshNn2Y3+tS8XuyD2fndgaPBu0I=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] crypto: arm64/chacha - fix hchacha_block_neon() for big endian
Date:   Fri, 22 Feb 2019 22:54:08 -0800
Message-Id: <20190223065408.6279-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190223065408.6279-1-ebiggers@kernel.org>
References: <20190223065408.6279-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

On big endian arm64 kernels, the xchacha20-neon and xchacha12-neon
self-tests fail because hchacha_block_neon() outputs little endian words
but the C code expects native endianness.  Fix it to output the words in
native endianness (which also makes it match the arm32 version).

Fixes: cc7cf991e9eb ("crypto: arm64/chacha20 - add XChaCha20 support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/chacha-neon-core.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/chacha-neon-core.S b/arch/arm64/crypto/chacha-neon-core.S
index bfb80e10ff7b0..706c4e10e9e29 100644
--- a/arch/arm64/crypto/chacha-neon-core.S
+++ b/arch/arm64/crypto/chacha-neon-core.S
@@ -158,8 +158,8 @@ ENTRY(hchacha_block_neon)
 	mov		w3, w2
 	bl		chacha_permute
 
-	st1		{v0.16b}, [x1], #16
-	st1		{v3.16b}, [x1]
+	st1		{v0.4s}, [x1], #16
+	st1		{v3.4s}, [x1]
 
 	ldp		x29, x30, [sp], #16
 	ret
-- 
2.20.1


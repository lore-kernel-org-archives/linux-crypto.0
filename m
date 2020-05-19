Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365DEC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 19:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A492206C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 19:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589914941;
	bh=Zs8ZcaZn3yzoZ78qRvdow83AlNV03guZups6sihCi3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wpw7WV/4imk0YupqrHfgO+15ttE4azjL2yZ3ExpRetlGbJ6OV7QBkJiEQ51WPd8nP
	 rKmGOjIlNk7NJxLIIjx4sSwucLoCJP7O0yC15ycRDLYsj6+YiSA6s+Dt42pyPK/Mxr
	 yqv+oYduJ/RVY3M4mcpRZ5PhlxewFlDa+t3a4bXY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgESTCU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 15:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726732AbgESTCS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 15:02:18 -0400
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82FB320826;
        Tue, 19 May 2020 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589914938;
        bh=Zs8ZcaZn3yzoZ78qRvdow83AlNV03guZups6sihCi3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVHmE2yDqsvYOHDU76sZE25eHDVSFCMl88lzPtimcEnNUhiJ9jvSVrod01iqVG6FJ
         VU9EMswJEBBpOEzub82Z0lkKpIf4pnXOV8FM3re2nCzv07gtW9YfYQqFLmVQ2uG+zB
         yh/fcrxjokDmmYvqzOp9SpoiJTfkl6Udt4IUoZYk=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [RFC/RFT PATCH 1/2] crypto: arm64/aes - align output IV with generic CBC-CTS driver
Date:   Tue, 19 May 2020 21:02:10 +0200
Message-Id: <20200519190211.76855-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519190211.76855-1-ardb@kernel.org>
References: <20200519190211.76855-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The generic CTS chaining mode wraps the CBC mode driver in a way that
results in the IV buffer referenced by the skcipher request to be
updated with the last block of ciphertext. The arm64 implementation
deviates from this, given that CTS itself does not specify the concept
of an output IV, or how it should be generated, and so it was assumed
that the output IV does not matter.

However, Stephan reports that code exists that relies on this behavior,
and that there is even a NIST validation tool that flags it as
non-compliant [citation needed. Stephan?]

So let's align with the generic implementation here, and return the
penultimate block of ciphertext as the output IV.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-modes.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index cf618d8f6cec..80832464df50 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -275,6 +275,7 @@ AES_FUNC_START(aes_cbc_cts_encrypt)
 	add		x4, x0, x4
 	st1		{v0.16b}, [x4]			/* overlapping stores */
 	st1		{v1.16b}, [x0]
+	st1		{v1.16b}, [x5]
 	ret
 AES_FUNC_END(aes_cbc_cts_encrypt)
 
@@ -291,6 +292,7 @@ AES_FUNC_START(aes_cbc_cts_decrypt)
 	ld1		{v1.16b}, [x1]
 
 	ld1		{v5.16b}, [x5]			/* get iv */
+	st1		{v0.16b}, [x5]
 	dec_prepare	w3, x2, x6
 
 	decrypt_block	v0, w3, x2, x6, w7
-- 
2.20.1


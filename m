Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427D9C04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 10:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 151C42084F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 10:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="LNFk3SYq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfEOKY5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 06:24:57 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40172 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfEOKY5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 06:24:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id g69so1123898plb.7
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2019 03:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sb4pV1d5lxWRP204NVfZBomUvfE6MxP49E2mX7dS5Bc=;
        b=LNFk3SYqazir1mtooOos9X27csivCVSHkilxBtbcBBTJ57MuXcN0CJAkFjXJKhnyzh
         0+HbVTAkpr6A5iI97f9dQH1bAk6JEdmmVWs6tLeIhjuNw7t0FG1iR8HKNUTvK89fS+wr
         18lIAFxVcfHTtTnfVth8z84az/irEcPIUU+zI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sb4pV1d5lxWRP204NVfZBomUvfE6MxP49E2mX7dS5Bc=;
        b=PhFCaFgezShdmVYVhkebh/DDmGaI/F8TY07GZHzHV4OPAQOlueQgpAR/8Dn3+Gizrt
         uTfebFegn8M+2hI5Qf5CGX90P+karbuoiZzPnHyTqoTqAjOxRgD24xRpeP9CCAvbqJ8G
         oDPrudlf4bk+HXfkA/Jr02u0BidGkf6D/g9cmqsGBcz2i/D3L07/kyggTTb1nJ9cvwUb
         g5chYDo3kqavumoao8OGTRV2inT0AYTELg5I1CYlJjL5in+QfN2V22V95Gl6ERORlhKs
         kaoTa4K7wFQHjhL0NxlN0WK8YtGQzNhKoAWL4GguRuFLc0xyhQfAhB8NvHAjI0z54YEI
         pXzw==
X-Gm-Message-State: APjAAAU73UpTw2UzmsvNpVbgQz2B0UWRAH9Rt7dibT2T+Ov5+MGgAkGM
        bf4dGNyncBRPV10r2Jz2K3eKMQ==
X-Google-Smtp-Source: APXvYqyjLExp8dImFftLMhrdYyBWBoJDEuAc+MBp5wYkorCb8rPwgnHl5nUDBpqX3DRe2bDSKOSMwQ==
X-Received: by 2002:a17:902:868c:: with SMTP id g12mr25668785plo.323.1557915897147;
        Wed, 15 May 2019 03:24:57 -0700 (PDT)
Received: from localhost (dip-220-235-49-186.wa.westnet.com.au. [220.235.49.186])
        by smtp.gmail.com with ESMTPSA id 194sm4367930pfb.125.2019.05.15.03.24.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 03:24:56 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     mpe@ellerman.id.au, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org,
        gcwilson@linux.ibm.com, omosnacek@gmail.com
Subject: [PATCH] crypto: vmx - CTR: always increment IV as quadword
Date:   Wed, 15 May 2019 20:24:50 +1000
Message-Id: <20190515102450.30557-1-dja@axtens.net>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The kernel self-tests picked up an issue with CTR mode:
alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"

Test vector 3 has an IV of FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD, so
after 3 increments it should wrap around to 0.

In the aesp8-ppc code from OpenSSL, there are two paths that
increment IVs: the bulk (8 at a time) path, and the individual
path which is used when there are fewer than 8 AES blocks to
process.

In the bulk path, the IV is incremented with vadduqm: "Vector
Add Unsigned Quadword Modulo", which does 128-bit addition.

In the individual path, however, the IV is incremented with
vadduwm: "Vector Add Unsigned Word Modulo", which instead
does 4 32-bit additions. Thus the IV would instead become
FFFFFFFFFFFFFFFFFFFFFFFF00000000, throwing off the result.

Use vadduqm.

This was probably a typo originally, what with q and w being
adjacent. It is a pretty narrow edge case: I am really
impressed by the quality of the kernel self-tests!

Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Axtens <dja@axtens.net>

---

I'll pass this along internally to get it into OpenSSL as well.
---
 drivers/crypto/vmx/aesp8-ppc.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
index de78282b8f44..9c6b5c1d6a1a 100644
--- a/drivers/crypto/vmx/aesp8-ppc.pl
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -1357,7 +1357,7 @@ Loop_ctr32_enc:
 	addi		$idx,$idx,16
 	bdnz		Loop_ctr32_enc
 
-	vadduwm		$ivec,$ivec,$one
+	vadduqm		$ivec,$ivec,$one
 	 vmr		$dat,$inptail
 	 lvx		$inptail,0,$inp
 	 addi		$inp,$inp,16
-- 
2.19.1


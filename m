Return-Path: <SRS0=zerQ=ZI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9119C43141
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 16:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0FF12184B
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921511;
	bh=OKqeG2P+tPeyHFAyZKVWcBe8xkMu2lCZ2qbbeu6ZUeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KVw276scldHQ2epQ/bSV9NMXNBQhONZAM2fddKfKF0zbKI9P4N4nvtNZ56YKnMaqW
	 zu67h+aR9lsYdfqSUTNTPbAwdIMnqB083AovVD4eNhmxPFAnp1WGeoERwKofKk4KrG
	 D/KhFC7ayoVoBYmY4EqLDw6ThFvnXjJqopG1pPnU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfKPPmL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbfKPPmJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:09 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13F362075B;
        Sat, 16 Nov 2019 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918928;
        bh=OKqeG2P+tPeyHFAyZKVWcBe8xkMu2lCZ2qbbeu6ZUeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qt/cUn+ClZmPMPrzTlTuQcXjh847Zqv5VWk+meyQ82KW9GgAwzr7v/cQlLIE1V2Cn
         kN8kOKEuz+qZ270ZGqeEY0T8Pl/35filyFx/BDjxSWtU0lLEYf8zxmq1I/SxvJ9CfV
         JZfA58Z/TMCDUizFFH0xSfhDUFTNoji+GQy+6lIw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 055/237] crypto: ccree - avoid implicit enum conversion
Date:   Sat, 16 Nov 2019 10:38:10 -0500
Message-Id: <20191116154113.7417-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 18e732b8035d175181aae2ded127994cb01694f7 ]

Clang warns when one enumerated type is implicitly converted to another
and this happens in several locations in this driver, ultimately related
to the set_cipher_{mode,config0} functions. set_cipher_mode expects a mode
of type drv_cipher_mode and set_cipher_config0 expects a mode of type
drv_crypto_direction.

drivers/crypto/ccree/cc_ivgen.c:58:35: warning: implicit conversion from
enumeration type 'enum cc_desc_direction' to different enumeration type
'enum drv_crypto_direction' [-Wenum-conversion]
        set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);

drivers/crypto/ccree/cc_hash.c:99:28: warning: implicit conversion from
enumeration type 'enum cc_hash_conf_pad' to different enumeration type
'enum drv_crypto_direction' [-Wenum-conversion]
                set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);

drivers/crypto/ccree/cc_aead.c:1643:30: warning: implicit conversion
from enumeration type 'enum drv_hash_hw_mode' to different enumeration
type 'enum drv_cipher_mode' [-Wenum-conversion]
        set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);

Since this fundamentally isn't a problem because these values just
represent simple integers for a shift operation, make it clear to Clang
that this is okay by making the mode parameter in both functions an int.

Link: https://github.com/ClangBuiltLinux/linux/issues/46
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_hw_queue_defs.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index a091ae57f9024..45985b955d2c8 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -449,8 +449,7 @@ static inline void set_flow_mode(struct cc_hw_desc *pdesc,
  * @pdesc: pointer HW descriptor struct
  * @mode:  Any one of the modes defined in [CC7x-DESC]
  */
-static inline void set_cipher_mode(struct cc_hw_desc *pdesc,
-				   enum drv_cipher_mode mode)
+static inline void set_cipher_mode(struct cc_hw_desc *pdesc, int mode)
 {
 	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_MODE, mode);
 }
@@ -461,8 +460,7 @@ static inline void set_cipher_mode(struct cc_hw_desc *pdesc,
  * @pdesc: pointer HW descriptor struct
  * @mode: Any one of the modes defined in [CC7x-DESC]
  */
-static inline void set_cipher_config0(struct cc_hw_desc *pdesc,
-				      enum drv_crypto_direction mode)
+static inline void set_cipher_config0(struct cc_hw_desc *pdesc, int mode)
 {
 	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF0, mode);
 }
-- 
2.20.1


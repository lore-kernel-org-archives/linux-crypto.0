Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3B9C55178
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 933452084C
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603729046;
	bh=i4wAiUrw27vZtHwYcdMAVY1jqcS3D91oVEEVv09YEJA=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rW2xoHPvWgJ+vOMDDbKGiu9QpsLm+KCDThi32JzFdtRiHo0w1t2CyCN3bwhEpCeJf
	 C1nnIm3eExiW94497/pInBAxW6R2rb2Iqlaj1vsALwnI4QEPijRLmSQZ5ESqwSiBHR
	 6SyedrV1htiVk4iFoVnBger0U8UKKe53f11rj6wY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775355AbgJZQRZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1747247AbgJZQRZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 12:17:25 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601C42084C
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603729045;
        bh=i4wAiUrw27vZtHwYcdMAVY1jqcS3D91oVEEVv09YEJA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hD4DnVND4v4IggCo4FC+wBK185pGrRfIa0HImh76dKVnRUxghSi+uMi8QJPGRXIsk
         tcg08tfzseaTjgaVsSP8M5nYiLHw3lQZC6EYxVlruJxEMq5owsDSn+wlFQV/NqpE4G
         VkVmBcFDWX4ObazMzh30bss7UKyU3ObZi52LgGFk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/4] crypto: aead - add crypto_aead_driver_name()
Date:   Mon, 26 Oct 2020 09:16:59 -0700
Message-Id: <20201026161702.39201-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201026161702.39201-1-ebiggers@kernel.org>
References: <20201026161702.39201-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add crypto_aead_driver_name(), which is analogous to
crypto_skcipher_driver_name().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/aead.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index c32a6f5664e9a..fcc12c593ef8b 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -191,6 +191,11 @@ static inline void crypto_free_aead(struct crypto_aead *tfm)
 	crypto_destroy_tfm(tfm, crypto_aead_tfm(tfm));
 }
 
+static inline const char *crypto_aead_driver_name(struct crypto_aead *tfm)
+{
+	return crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
+}
+
 static inline struct aead_alg *crypto_aead_alg(struct crypto_aead *tfm)
 {
 	return container_of(crypto_aead_tfm(tfm)->__crt_alg,
-- 
2.29.1


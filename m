Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19181C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E977B2070C
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593579153;
	bh=VI6uJQBa6eektL16u/ntq8Xz+Gcp+ieYlg+lAaKUpo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uGysNu4gctDDoRajghZD77Io689PywKyrGjHe9AZR+fRGLMwuG0ogsfSs/XTfmp5d
	 0d4vP39vze2/BN2rjw/e8nQ2tRlIfYmByjbKTtDgqjGZ/V64oRm2PKP/tqq16XSqsx
	 W7IuoWiwaNJzYUeZdsCmDE108JxlOs0WaP7l31Ck=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgGAEwb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 00:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgGAEwa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 00:52:30 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A1542078A;
        Wed,  1 Jul 2020 04:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593579149;
        bh=VI6uJQBa6eektL16u/ntq8Xz+Gcp+ieYlg+lAaKUpo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrcOuIVJWgosLSbNgqFYKed1MIYb2Yzmq2eJ14ns2N/NWQX99bMpdjpVwWisBQDCZ
         GvkLyVacY9GUG2fw1srvt12rtT1PGALB+utcsW/AvoonlZAipa/Icb3FA4jcbJpncp
         CH7J7QpAA6KyW2NWTGcDqJvKiszoi7DFW73d/DK4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH 4/6] crypto: algapi - remove crypto_check_attr_type()
Date:   Tue, 30 Jun 2020 21:52:15 -0700
Message-Id: <20200701045217.121126-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701045217.121126-1-ebiggers@kernel.org>
References: <20200701045217.121126-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Remove crypto_check_attr_type(), since it's no longer used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c         | 15 ---------------
 include/crypto/algapi.h |  1 -
 2 files changed, 16 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 24a56279ca80..58558fae12bd 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -818,21 +818,6 @@ struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb)
 }
 EXPORT_SYMBOL_GPL(crypto_get_attr_type);
 
-int crypto_check_attr_type(struct rtattr **tb, u32 type)
-{
-	struct crypto_attr_type *algt;
-
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ type) & algt->mask)
-		return -EINVAL;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_check_attr_type);
-
 const char *crypto_attr_alg_name(struct rtattr *rta)
 {
 	struct crypto_attr_alg *alga;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index dce57c89cf98..78902563512b 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -116,7 +116,6 @@ struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
 
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
-int crypto_check_attr_type(struct rtattr **tb, u32 type);
 const char *crypto_attr_alg_name(struct rtattr *rta);
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
 int crypto_inst_setname(struct crypto_instance *inst, const char *name,
-- 
2.27.0


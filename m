Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B7DC4332F
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEDA261A54
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhJCSQ6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 14:16:58 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50816 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbhJCSQ6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 14:16:58 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7BE7322188;
        Sun,  3 Oct 2021 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633284909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HL6CTQHPtji59S+giSYYALkCAHuGrPm7hT4YVgG6v2A=;
        b=n8o5IDYzrUVyIGYNeozSfikcGlX/dyE+WNeB85ekxbDcJEBlJvFlXKGLBZXeOtNurZe3QK
        496OB2aCqUXA3svSGtbQlysWB7NW9LpiN2wmaMy4kd57xeCF8TpVVGYV12BWgX1WEbalCp
        ADwm+D6NooWxn7bjkkb2slDkKTau89g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633284909;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HL6CTQHPtji59S+giSYYALkCAHuGrPm7hT4YVgG6v2A=;
        b=agGXak8dAMyk02ULqxajW8UGsKuuOCj5E90Ifaq8uV1trBVxbdLDa3CbMPEk2/zkGSSBNB
        25Rbmfz+wwY4ByDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 682CB13A09;
        Sun,  3 Oct 2021 18:15:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K5/2Fy3zWWGpEwAAMHmgww
        (envelope-from <nstange@suse.de>); Sun, 03 Oct 2021 18:15:09 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 2/8] crypto: user - reject requests for untested algorithms
Date:   Sun,  3 Oct 2021 20:14:07 +0200
Message-Id: <20211003181413.12465-3-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211003181413.12465-1-nstange@suse.de>
References: <20211003181413.12465-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently it's possible for userspace to specify any combination of
->cru_type and ->cru_mask with respect to CRYTPO_ALG_TESTED via the
CRYPTO_MSG_NEWALG crypto_user interface.

As these are passed onwards to crypto_larval_lookup() unmodified as
'mask' and 'type' parameters eventually, this can lead to the creation of
obscure lookup larvals like e.g. (mask & CRYTPO_ALG_TESTED) but not
(type & CRYTPO_ALG_TESTED) or the other way around.

Userspace should have no business in asking for untested algorithms. Make
crypto_user's crypto_add_alg() reject nonsensical combinations of
->cru_type and ->cru_mask with respect to CRYTPO_ALG_TESTED with -EINVAL.

Note that CRYTPO_ALG_TESTED not being set in either of mask and type is
considered equivalent to that flag being set in both and these two
combinations are the only ones supported as of now.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 crypto/crypto_user_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user_base.c
index 3fa20f12989f..a9c06cd98a8c 100644
--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -352,6 +352,9 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (priority && !exact)
 		return -EINVAL;
 
+	if ((p->cru_type ^ p->cru_mask) & CRYPTO_ALG_TESTED)
+		return -EINVAL;
+
 	alg = crypto_alg_match(p, exact);
 	if (alg) {
 		crypto_mod_put(alg);
-- 
2.26.2


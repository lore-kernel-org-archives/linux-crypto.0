Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557B6C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DEC061A0A
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhJCSQ4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 14:16:56 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50796 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhJCSQ4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 14:16:56 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8694E22188;
        Sun,  3 Oct 2021 18:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633284907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y0NsFhX+iG9v6yqRJSdn1Z2f2KeEAmY9udesNCSPze4=;
        b=v4dQuBfoqmSTqpkMZUOhOsV4qIDJ3Y5ljpmBoms1igjAWc1soBgofdAJen/7vq+uAcTssM
        a/OR5FZUSFQVYduv0AOErdiSJNGoFggdfI7lMLiO0Mr7FMf1kSRgI6DmSYoxjVl+EBFGi1
        fIViuoYNy9U0ga5mjbIwMsC0tp9YeRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633284907;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y0NsFhX+iG9v6yqRJSdn1Z2f2KeEAmY9udesNCSPze4=;
        b=kam+WftdXtX/I9KJz0HzyoTx8LALywNtb2Nqqlz9bqthdBbCzAk9704pMuFBQ1IUjE/+sY
        AoPqhu8CytwWjvAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 73EDA13A09;
        Sun,  3 Oct 2021 18:15:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id L+UJGyvzWWGlEwAAMHmgww
        (envelope-from <nstange@suse.de>); Sun, 03 Oct 2021 18:15:07 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 1/8] crypto: af_alg - reject requests for untested algorithms
Date:   Sun,  3 Oct 2021 20:14:06 +0200
Message-Id: <20211003181413.12465-2-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211003181413.12465-1-nstange@suse.de>
References: <20211003181413.12465-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently it's possible for userspace to specify any combination of
->salg_feat and ->salg_mask with respect to CRYTPO_ALG_TESTED via the
af_alg interface.

As these are passed onwards to crypto_larval_lookup() unmodified as
'mask' and 'type' parameters eventually, this can lead to the creation of
obscure lookup larvals like e.g. (mask & CRYTPO_ALG_TESTED) but not
(type & CRYTPO_ALG_TESTED) or the other way around.

Userspace should have no business in asking for untested algorithms. Make
af_alg's alg_bind() reject nonsensical combinations of ->salg_feat and
->salg_mask with respect to CRYTPO_ALG_TESTED with -EINVAL.

Note that CRYTPO_ALG_TESTED not being set in either of mask and type is
considered equivalent to that flag being set in both and these two
combinations are the only ones supported as of now.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 crypto/af_alg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 8bd288d2b089..83e68f3f71db 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -166,6 +166,15 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if ((sa->salg_feat & ~allowed) || (sa->salg_mask & ~allowed))
 		return -EINVAL;
 
+	/*
+	 * Don't allow requests for untested algorithms, i.e. those
+	 * where the selftests are still in progress or have failed.
+	 * CRYPTO_ALG_TESTED must be set either in none or both of
+	 * type and mask (which is equivalent).
+	 */
+	if ((sa->salg_feat ^ sa->salg_mask) & CRYPTO_ALG_TESTED)
+		return -EINVAL;
+
 	sa->salg_type[sizeof(sa->salg_type) - 1] = 0;
 	sa->salg_name[addr_len - sizeof(*sa) - 1] = 0;
 
-- 
2.26.2


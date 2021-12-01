Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A57EC43219
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Dec 2021 00:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346042AbhLAAxd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Nov 2021 19:53:33 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:58140 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345914AbhLAAww (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Nov 2021 19:52:52 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1F2C61FD5D;
        Wed,  1 Dec 2021 00:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638319771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srA8bsnlFmW4wisDufAdp5C+fl/L05W6nTkDzGSivQg=;
        b=dNyWg8juMIHnfiGl7jiV/FCTuNIDy1L4jkq0J4teM6BJF5ZzLe99vxwmYIm3TdSFyTkQ7u
        Hs2XZIcWACjfjTNE650ST36p9eHjUZ6vV1214wkWXcrEnxnnSbPxHi/wtx2Uz6IfP5jsfc
        f21RXyyiyX9v2FpkYju5MLf6AW2N/rg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638319771;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srA8bsnlFmW4wisDufAdp5C+fl/L05W6nTkDzGSivQg=;
        b=dXvL5Jjn3oOWosrbYftrIJmwhx+t16+tsN7mixn287nPXJ/oCAB5kpiDnhUtWm6PpZzmeZ
        LYojkTuNK7YagzBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 09E1313C10;
        Wed,  1 Dec 2021 00:49:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ph3mAJvGpmH4KAAAMHmgww
        (envelope-from <nstange@suse.de>); Wed, 01 Dec 2021 00:49:31 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Hannes Reinecke <hare@suse.de>, Torsten Duwe <duwe@suse.de>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        qat-linux@intel.com, keyrings@vger.kernel.org,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 10/18] crypto: dh - introduce support for ephemeral key generation to dh-generic
Date:   Wed,  1 Dec 2021 01:48:50 +0100
Message-Id: <20211201004858.19831-11-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211201004858.19831-1-nstange@suse.de>
References: <20211201004858.19831-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The support for NVME in-band authentication currently in the works ([1])
needs to generate ephemeral DH keys. Make dh-generic's ->set_secret()
to generate an ephemeral key via the recently added crypto_dh_gen_privkey()
in case the input ->key_size is zero. Note that this behaviour is in
analogy to ecdh's ->set_secret().

[1] https://lkml.kernel.org/r/20211122074727.25988-4-hare@suse.de

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 crypto/dh.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 131b80064cb1..2e49b114e038 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -71,25 +71,41 @@ static int dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 {
 	struct dh_ctx *ctx = dh_get_ctx(tfm);
 	struct dh params;
+	char key[CRYPTO_DH_MAX_PRIVKEY_SIZE];
+	int err;
 
 	/* Free the old MPI key if any */
 	dh_clear_ctx(ctx);
 
-	if (crypto_dh_decode_key(buf, len, &params) < 0)
+	err = crypto_dh_decode_key(buf, len, &params);
+	if (err)
 		goto err_clear_ctx;
 
-	if (dh_set_params(ctx, &params) < 0)
+	if (!params.key_size) {
+		err = crypto_dh_gen_privkey(params.group_id, key,
+					    &params.key_size);
+		if (err)
+			goto err_clear_ctx;
+		params.key = key;
+	}
+
+	err = dh_set_params(ctx, &params);
+	if (err)
 		goto err_clear_ctx;
 
 	ctx->xa = mpi_read_raw_data(params.key, params.key_size);
-	if (!ctx->xa)
+	if (!ctx->xa) {
+		err = -EINVAL;
 		goto err_clear_ctx;
+	}
+
+	memzero_explicit(key, sizeof(key));
 
 	return 0;
 
 err_clear_ctx:
 	dh_clear_ctx(ctx);
-	return -EINVAL;
+	return err;
 }
 
 /*
-- 
2.26.2


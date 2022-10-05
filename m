Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D93C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Oct 2022 15:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiJEPdF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Oct 2022 11:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJEPdC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Oct 2022 11:33:02 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2B1B87F;
        Wed,  5 Oct 2022 08:32:55 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bk15so26488016wrb.13;
        Wed, 05 Oct 2022 08:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dDHhYCYYkB8ixYt9OP6aR+A7o5TGzEzJpkwdBHtaGmo=;
        b=oBlaoRZfnVTH4aQBTrO46nFHI6rppTqyrLs578eWa8+WMWUx6E+Hi+it5cRKYVY00L
         1xM3ray8k0MDmb7iUKIGqsLK6xTiYx1LDbuAADsJ8l+O+YisbthccIRNU3TeQJWHg31y
         uGIGahAnem3P2qcuMDx6oq4pt1wvNCBKnIwfqLv8JTjh8UTIGYHMSZiW7VLCwDgpfCIy
         6vTu+3E3/x60cFfP9llPVamhq0+3IDSBVYzVGjjKNJ3CWiXinofH9OOM/GnwOWO8VUNH
         OU3Fye1yYkyd2FSNfQAfN2rw5ns/ksbHrhCW87fzGrZZQvDTc68fNficPU1xcN1u5rnB
         q+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dDHhYCYYkB8ixYt9OP6aR+A7o5TGzEzJpkwdBHtaGmo=;
        b=ntQdwLTOHVEjTPWC7Q9Q2enVaT3evLatFOVr9gXGIvOMgJq71Pf495FQbyG0YEv5Bp
         e73GeLcHbo2vE4eRVqugJNtaWaV6ZzBcVDUrqDvBHWgjUfhiMPM77j9ITJhe0G1xlyUC
         +dQ6RbE7BdiNzzQuHt3bpWHKLfRED8A3EWgBnsHBbTnfIT97zjYCBR3jMbjsLoZN52pn
         4d6Z2gL+pkpzi1FwbY31REdUfpGO+r6hD5OWkI370kbZSH8Njez6ohLlp2nA5FkSlRJJ
         YVEBkNxB8I463dFMKRU7jXOxR+T7BV+htIfmv/91pYpU+vcHg11NdEbwy+fueCZpD55D
         9TYQ==
X-Gm-Message-State: ACrzQf0m6zGBjUIybvxW24oGhk7V/8mbwZZ9HcRE6Xg1QoeuQBX+42gg
        /KhlWX7Ievp+vCu3QmJK6CY=
X-Google-Smtp-Source: AMsMyM4S/KD7ANS7n50IHt6Tez/CTXwQRUbjewtDGdd7srEwfevSwWMHX9Aja/4pf2y2mHID6jiWhA==
X-Received: by 2002:a5d:648c:0:b0:22e:63be:be09 with SMTP id o12-20020a5d648c000000b0022e63bebe09mr199831wri.159.1664983973906;
        Wed, 05 Oct 2022 08:32:53 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id k9-20020a7bc309000000b003b47a99d928sm2229176wmj.18.2022.10.05.08.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 08:32:53 -0700 (PDT)
Date:   Wed, 5 Oct 2022 17:32:49 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     sparclinux@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: Issues with hw crypto and random support on Niagara2
Message-ID: <Yz2joer9WwQo5aiZ@Red>
References: <3804667.3oa1dkRz9v@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3804667.3oa1dkRz9v@eto.sf-tec.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Wed, Oct 05, 2022 at 04:17:45PM +0200, Rolf Eike Beer a écrit :
> [Resend with CC linux-crypto]
> 
> I recently upgraded my Sun T5120 the kernel to 5.19.12. The first thing I 
> noticed afterwards was that the boot took nearly one hour and spewed lots of 
> warnings about crng_init=0. As a workaround I did that:
> 
> # grep -n quality /usr/src/linux/drivers/char/hw_random/n2-drv.c 
> 770:    np->hwrng.quality = 5;
> 
> This has solved the issue for me, boot is now down to ~2min again. I wonder if 
> I'm missing something obvious like another driver that I should activate?
> 
> Then I noticed that the hw crypto support from drivers/crypto/n2_core.c fails 
> to load with -EINVAL. From looking at the code I think this is because 
> statesize is not set for the hash algorithms, so registering the first one 
> (md5) fails and nothing else is tried. I then set NUM_HASH_TMPLS to 0 so they 
> were never attempted, which resulted in the second loop succeeding:
> 
> [   40.561230] n2_crypto: n2_crypto.c:v0.2 (July 28, 2011)
> [   40.561361] n2_crypto: Found N2CP at /virtual-devices@100/n2cp@7
> [   40.561506] n2_crypto: Registered NCS HVAPI version 2.0
> [   40.562493] n2_crypto: ecb(des) alg registered
> [   40.562567] n2_crypto: cbc(des) alg registered
> [   40.562687] n2_crypto: cfb(des) alg registered
> [   40.562760] n2_crypto: ecb(des3_ede) alg registered
> [   40.562833] n2_crypto: cbc(des3_ede) alg registered
> [   40.562906] n2_crypto: cfb(des3_ede) alg registered
> [   40.563007] n2_crypto: ecb(aes) alg registered
> [   40.563084] n2_crypto: cbc(aes) alg registered
> [   40.563156] n2_crypto: ctr(aes) alg registered
> [   40.563890] n2_crypto: Found NCP at /virtual-devices@100/ncp@6
> 
> Maybe someone with the knowledge about the right statesize could send a patch? 
> I'm open for testing. This is probably broken for a very long time, i.e. 
> 8996eafdcbad149ac0f772fb1649fbb75c482a6a (kernel v4.3).
> 
> Greetings,
> 
> Eike

Could you try the following ?
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 31e24df18877..20d0dcd50344 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1229,6 +1229,7 @@ struct n2_hash_tmpl {
 	const u8	*hash_init;
 	u8		hw_op_hashsz;
 	u8		digest_size;
+	u8		statesize;
 	u8		block_size;
 	u8		auth_type;
 	u8		hmac_type;
@@ -1260,6 +1261,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
 	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
 	  .digest_size	= MD5_DIGEST_SIZE,
+	  .statesize	= sizeof(struct md5_state),
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
 	  .hash_zero	= sha1_zero_message_hash,
@@ -1268,6 +1270,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
 	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
 	  .digest_size	= SHA1_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha1_state),
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
 	  .hash_zero	= sha256_zero_message_hash,
@@ -1276,6 +1279,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA256_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
 	  .hash_zero	= sha224_zero_message_hash,
@@ -1284,6 +1288,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_RESERVED,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA224_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA224_BLOCK_SIZE },
 };
 #define NUM_HASH_TMPLS ARRAY_SIZE(hash_tmpls)
@@ -1424,6 +1429,7 @@ static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 
 	halg = &ahash->halg;
 	halg->digestsize = tmpl->digest_size;
+	halg->statesize = tmpl->statesize;
 
 	base = &halg->base;
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);


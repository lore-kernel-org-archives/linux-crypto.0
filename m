Return-Path: <SRS0=Odag=Z5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBB7C43603
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 03:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C850D21835
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 03:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLGDbD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 22:31:03 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:43934 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfLGDbC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 22:31:02 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1idQo9-0002JE-GY; Sat, 07 Dec 2019 11:31:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1idQo7-00076w-TE; Sat, 07 Dec 2019 11:31:00 +0800
Date:   Sat, 7 Dec 2019 11:30:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/4] crypto: aead - Retain alg refcount in
 crypto_grab_aead
Message-ID: <20191207033059.h6kgx7j7jtnqotuy@gondor.apana.org.au>
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
 <E1id7G9-00051G-5w@gondobar>
 <20191206224155.GE246840@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206224155.GE246840@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 06, 2019 at 02:41:55PM -0800, Eric Biggers wrote:
>
> This approach seems too error-prone, since the prototype of crypto_grab_aead()
> doesn't give any indication that it takes a reference to the algorithm which the
> caller *must* drop.

Fair point.

> How about returning the alg pointer in the last argument, similar to
> skcipher_alloc_instance_simple()?  I know you sent a patch to remove that
> argument, but I think it's better to have it...

You probably guessed that I don't really like returning two objects
from the same function :)

So how about this: we let the Crypto API manage the refcount and
hide it from all the users.  Something like this patch:

diff --git a/crypto/algapi.c b/crypto/algapi.c
index adb516380be9..34473ab992f2 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -563,6 +563,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst)
 {
 	struct crypto_larval *larval;
+	struct crypto_spawn *spawn;
 	int err;
 
 	err = crypto_check_alg(&inst->alg);
@@ -588,6 +589,9 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	if (IS_ERR(larval))
 		goto err;
 
+	hlist_for_each_entry(spawn, &inst->spawn_list, spawn_list)
+		crypto_mod_put(spawn->alg);
+
 	crypto_wait_for_test(larval);
 	err = 0;
 
@@ -623,6 +627,7 @@ int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 
 	spawn->inst = inst;
 	spawn->mask = mask;
+	hlist_add_head(&spawn->spawn_list, &inst->spawn_list);
 
 	down_write(&crypto_alg_sem);
 	if (!crypto_is_moribund(alg)) {
@@ -674,6 +679,9 @@ void crypto_drop_spawn(struct crypto_spawn *spawn)
 	if (!spawn->dead)
 		list_del(&spawn->list);
 	up_write(&crypto_alg_sem);
+
+	if (hlist_unhashed(&spawn->inst->list))
+		crypto_mod_put(spawn->alg);
 }
 EXPORT_SYMBOL_GPL(crypto_drop_spawn);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 771a295ac755..284e96f2eda2 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -48,6 +48,7 @@ struct crypto_instance {
 
 	struct crypto_template *tmpl;
 	struct hlist_node list;
+	struct hlist_head spawn_list;
 
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
@@ -66,6 +67,7 @@ struct crypto_template {
 
 struct crypto_spawn {
 	struct list_head list;
+	struct hlist_node spawn_list;
 	struct crypto_alg *alg;
 	struct crypto_instance *inst;
 	const struct crypto_type *frontend;

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792F5C2D0C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 22:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4522C2464E
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 22:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575672625;
	bh=q9nHz7Ayvan92Hcmx/2syI+/uMfuznlw/40GMBxYvCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=nr25w1u5J3tW4ep2aTkzHmuFuVMY9FLpjvgM1cGYjxl6Yr4x+Fr7t2c/gkcmY0Vv/
	 7H+Va7k9FopW+joCS2WfCGDMz/JyT7H+UoEcjZc0zZwBAmr8Os4RxUNaGwKl5k1KXm
	 pHQydJgECWCvy2lYZWdHZcDgDfofdmwvSzFx5CRg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfLFWuY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 17:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfLFWuY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 17:50:24 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F99121835;
        Fri,  6 Dec 2019 22:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575672623;
        bh=q9nHz7Ayvan92Hcmx/2syI+/uMfuznlw/40GMBxYvCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GVIYFQIGps+2oQi5QnxaMWJKM3vd14n2ehg7DDKlQ8XQrOJK/UkeVghKYiwHUTiVX
         y6G4xFf6f33TjP3A8Uee0eYxiu+f1VJqj8llisyRRu1kgnZnOiluQJl569RGGLdRKU
         0ECE1DWaHQOzkv7x1X/B1TCQNHXTbjVQDmj2nBpU=
Date:   Fri, 6 Dec 2019 14:50:21 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/2] crypto: api - Do not zap spawn->alg
Message-ID: <20191206225021.GF246840@gmail.com>
References: <20191206143914.hfggirmmnjk27kx4@gondor.apana.org.au>
 <E1idElt-0001VY-O3@gondobar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1idElt-0001VY-O3@gondobar>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 06, 2019 at 10:39:53PM +0800, Herbert Xu wrote:
> Currently when a spawn is removed we will zap its alg field.
> This is racy because the spawn could belong to an unregistered
> instance which may dereference the spawn->alg field.
> 
> This patch fixes this by keeping spawn->alg constant and instead
> adding a new spawn->dead field to indicate that a spawn is going
> away.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  crypto/algapi.c         |   21 +++++++++++----------
>  include/crypto/algapi.h |    1 +
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index cc55301beef4..2d0697c4f69c 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -93,15 +93,16 @@ static struct list_head *crypto_more_spawns(struct crypto_alg *alg,
>  	if (!spawn)
>  		return NULL;
>  
> -	n = list_next_entry(spawn, list);
> +	list_move(&spawn->list, secondary_spawns);
>  
> -	if (spawn->alg && &n->list != stack && !n->alg)
> -		n->alg = (n->list.next == stack) ? alg :
> -			 &list_next_entry(n, list)->inst->alg;
> +	if (list_is_last(&spawn->list, stack))
> +		return top;
>  
> -	list_move(&spawn->list, secondary_spawns);
> +	n = list_next_entry(spawn, list);
> +	if (!spawn->dead)
> +		n->dead = false;
>  
> -	return &n->list == stack ? top : &n->inst->alg.cra_users;
> +	return &n->inst->alg.cra_users;
>  }
>  
>  static void crypto_remove_instance(struct crypto_instance *inst,
> @@ -160,7 +161,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
>  			if (&inst->alg == nalg)
>  				break;
>  
> -			spawn->alg = NULL;
> +			spawn->dead = true;
>  			spawns = &inst->alg.cra_users;
>  
>  			/*
> @@ -179,7 +180,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
>  					      &secondary_spawns)));
>  
>  	list_for_each_entry_safe(spawn, n, &secondary_spawns, list) {
> -		if (spawn->alg)
> +		if (!spawn->dead)
>  			list_move(&spawn->list, &spawn->alg->cra_users);
>  		else
>  			crypto_remove_instance(spawn->inst, list);
> @@ -669,7 +670,7 @@ EXPORT_SYMBOL_GPL(crypto_grab_spawn);
>  void crypto_drop_spawn(struct crypto_spawn *spawn)
>  {
>  	down_write(&crypto_alg_sem);
> -	if (spawn->alg)
> +	if (!spawn->dead)
>  		list_del(&spawn->list);
>  	up_write(&crypto_alg_sem);
>  }
> @@ -681,7 +682,7 @@ static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
>  
>  	down_read(&crypto_alg_sem);
>  	alg = spawn->alg;
> -	if (alg && !crypto_mod_get(alg)) {
> +	if (!spawn->dead && !crypto_mod_get(alg)) {
>  		alg->cra_flags |= CRYPTO_ALG_DYING;
>  		alg = NULL;
>  	}
> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
> index 5cd846defdd6..771a295ac755 100644
> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -70,6 +70,7 @@ struct crypto_spawn {
>  	struct crypto_instance *inst;
>  	const struct crypto_type *frontend;
>  	u32 mask;
> +	bool dead;
>  };
>  

This patch causes the below crash.

Also, some comments (e.g. for struct crypto_spawn and crypto_remove_spawns())
would be really helpful to understand what's going on here.

==================================================================
BUG: KASAN: stack-out-of-bounds in crypto_more_spawns crypto/algapi.c:105 [inline]
BUG: KASAN: stack-out-of-bounds in crypto_remove_spawns+0x9cd/0xc30 crypto/algapi.c:179
Read of size 8 at addr ffff88806a1f7d58 by task cryptomgr_test/430

CPU: 2 PID: 430 Comm: cryptomgr_test Not tainted 5.4.0-07583-g2c69d0491b7e2 #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xa0/0xea lib/dump_stack.c:118
 print_address_description.constprop.4+0x21/0x2c0 mm/kasan/report.c:374
 __kasan_report.cold.8+0x7a/0xb5 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:638
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 crypto_more_spawns crypto/algapi.c:105 [inline]
 crypto_remove_spawns+0x9cd/0xc30 crypto/algapi.c:179
 crypto_alg_tested+0x493/0x5b0 crypto/algapi.c:357
 cryptomgr_test+0x60/0x80 crypto/algboss.c:225
 kthread+0x331/0x3f0 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the page:
page:ffffea0001736e08 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
raw: 0100000000000000 ffffea0001736e10 ffffea0001736e10 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff
page dumped because: kasan: bad access detected

addr ffff88806a1f7d58 is located in stack of task cryptomgr_test/430 at offset 56 in frame:
 crypto_remove_spawns+0x0/0xc30 crypto/algapi.c:956

this frame has 3 objects:
 [32, 48) 'secondary_spawns'
 [96, 112) 'stack'
 [160, 176) 'top'

Memory state around the buggy address:
 ffff88806a1f7c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88806a1f7c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88806a1f7d00: 00 00 00 00 f1 f1 f1 f1 00 00 f2 f2 f2 f2 f2 f2
                                                    ^
 ffff88806a1f7d80: 00 00 f2 f2 f2 f2 f2 f2 00 00 f2 f2 00 00 00 00
 ffff88806a1f7e00: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
==================================================================
Disabling lock debugging due to kernel taint
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN
CPU: 2 PID: 430 Comm: cryptomgr_test Tainted: G    B             5.4.0-07583-g2c69d0491b7e2 #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
RIP: 0010:crypto_remove_spawns+0x359/0xc30 crypto/algapi.c:155
Code: 39 c4 0f 84 71 01 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 38 00 0f 85 a7 05 00 00 4d 8b 24 24 49 8d 7c 24 18 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 0f 85 6b 05 00 0f
RSP: 0000:ffff88806a1f7cc8 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffff88806a1f7e00 RCX: ffffffff81339704
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000018
RBP: ffff88806a1f7e28 R08: fffffbfff06973a5 R09: fffffbfff06973a5
R10: fffffbfff06973a4 R11: ffffffff834b9d23 R12: 0000000000000000
R13: ffff88806a1f7d80 R14: ffff88806a1f7d40 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88806d900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 0000000003213001 CR4: 0000000000760ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 crypto_alg_tested+0x493/0x5b0 crypto/algapi.c:357
 cryptomgr_test+0x60/0x80 crypto/algboss.c:225
 kthread+0x331/0x3f0 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace e42d20303e3e7399 ]---
RIP: 0010:crypto_remove_spawns+0x359/0xc30 crypto/algapi.c:155
Code: 39 c4 0f 84 71 01 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 38 00 0f 85 a7 05 00 00 4d 8b 24 24 49 8d 7c 24 18 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 0f 85 6b 05 00 0f
RSP: 0000:ffff88806a1f7cc8 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffff88806a1f7e00 RCX: ffffffff81339704
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000018
RBP: ffff88806a1f7e28 R08: fffffbfff06973a5 R09: fffffbfff06973a5
R10: fffffbfff06973a4 R11: ffffffff834b9d23 R12: 0000000000000000
R13: ffff88806a1f7d80 R14: ffff88806a1f7d40 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88806d900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 0000000003213001 CR4: 0000000000760ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554


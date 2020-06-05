Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709AEC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 12:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5588A2065C
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 12:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgFEMid (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 08:38:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42256 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgFEMid (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 08:38:33 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jhBc2-0006N7-UN; Fri, 05 Jun 2020 22:38:20 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2020 22:38:18 +1000
Date:   Fri, 5 Jun 2020 22:38:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+afb77bdbaca0cda9e991@syzkaller.appspotmail.com>
Cc:     ardb@kernel.org, davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        t-kristo@ti.com
Subject: Re: WARNING: refcount bug in crypto_mod_get
Message-ID: <20200605123818.GA3984@gondor.apana.org.au>
References: <00000000000004f67705a4992160@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000004f67705a4992160@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 01, 2020 at 10:01:14AM -0700, syzbot wrote:
>
> ------------[ cut here ]------------
> refcount_t: addition on 0; use-after-free.
...
>  refcount_add include/linux/refcount.h:204 [inline]
>  refcount_inc include/linux/refcount.h:241 [inline]
>  crypto_alg_get crypto/internal.h:87 [inline]
>  crypto_mod_get+0xc6/0xf0 crypto/api.c:37
>  crypto_spawn_alg.isra.0+0xa8/0x110 crypto/algapi.c:723
>  crypto_spawn_tfm2+0x19/0xb0 crypto/algapi.c:763
>  crypto_spawn_aead include/crypto/internal/aead.h:102 [inline]
>  pcrypt_aead_init_tfm+0x144/0x273 crypto/pcrypt.c:182
>  crypto_aead_init_tfm+0x138/0x1a0 crypto/aead.c:140
>  crypto_create_tfm+0xd5/0x2f0 crypto/api.c:454
>  crypto_alloc_tfm+0x100/0x340 crypto/api.c:526
>  aead_bind+0x69/0x170 crypto/algif_aead.c:483
>  alg_bind+0x260/0x530 crypto/af_alg.c:182
>  __sys_bind+0x20e/0x250 net/socket.c:1662
>  __do_sys_bind net/socket.c:1673 [inline]
>  __se_sys_bind net/socket.c:1671 [inline]
>  __x64_sys_bind+0x6f/0xb0 net/socket.c:1671
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3

This should be fixed already:

#syz fix: crypto: api - Fix use-after-free and race in crypto_spawn_alg

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

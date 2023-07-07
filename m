Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FD9EB64D9
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jul 2023 08:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjGGINP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jul 2023 04:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbjGGINO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2023 04:13:14 -0400
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6C61FD8
        for <linux-crypto@vger.kernel.org>; Fri,  7 Jul 2023 01:13:13 -0700 (PDT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5428d1915acso2231620a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Jul 2023 01:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688717593; x=1691309593;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bo4MAJ4BG1isgQnCAcKhexSWW5SZFcBYqjHiQhX1gxE=;
        b=aUTIejy1HXRArNem+0iRxEVHdAMOT8TV66ktY/IO8cWUczq9MhgTdUavLCVmejRdxc
         ihrGFRdXVVc2IZCakulrkQT5sVsQ51L81sRL9iqE48UOy1h5t/ZeM0YhC0UfI9k4GYut
         JfN6dGp4WABNnwJl1UcElKbbk5p7PNVDR+pwz1HEy3iigcfo3gswuwunwiawu8LYtLDE
         Ow/tlOd/czIucSFX7VUfNgNxVeU1WoNNVlsm9dWFBtDpqC7H3tWQaeqa+mMb0w8mvtjN
         hVPsIjJKCZe3hWJx/sZ/6pWnm4fcnKaOvxdw2Gi6YE4WCeCyjs5GhTxE1hRLq2LAXQPE
         LzzQ==
X-Gm-Message-State: ABy/qLakyH/mG5atXq+rt0VFMB93fCejQGjNU59qfuZjdJucI7c6dxO4
        CHuYofAQHVwxNvx75LQ9G93elXVSvU9qQKOZNT0TVGHq8suB
X-Google-Smtp-Source: APBJJlE8hdToDJUDSlXhxZYGiozwGB/sggmA9Bou6VF3XK3kUJgxxs4q8gGavIF8Kn9djr+rnYwWBB6vWfCEmjnY26ERZZsdnAjy
MIME-Version: 1.0
X-Received: by 2002:a63:b253:0:b0:553:9efa:1159 with SMTP id
 t19-20020a63b253000000b005539efa1159mr3380049pgo.0.1688717593343; Fri, 07 Jul
 2023 01:13:13 -0700 (PDT)
Date:   Fri, 07 Jul 2023 01:13:13 -0700
In-Reply-To: <2225020.1688717586@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004700d505ffe1348d@google.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-out-of-bounds Write in
 crypto_sha3_final (2)
From:   syzbot <syzbot+e436ef6c393283630f64@syzkaller.appspotmail.com>
To:     dhowells@redhat.com
Cc:     davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> I'm pretty certain this is the same as:
>
> 	https://syzkaller.appspot.com/bug?extid=689ec3afb1ef07b766b2
>
> as I sometimes see the same trace when running the reproducer from there.
> ---
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

This crash does not have a reproducer. I cannot test it.

>
>     crypto: algif/hash: Fix race between MORE and non-MORE sends
>     
>     The 'MSG_MORE' state of the previous sendmsg() is fetched without the
>     socket lock held, so two sendmsg calls can race.  This can be seen with a
>     large sendfile() as that now does a series of sendmsg() calls, and if a
>     write() comes in on the same socket at an inopportune time, it can flip the
>     state.
>     
>     Fix this by moving the fetch of ctx->more inside the socket lock.
>     
>     Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
>     Reported-by: syzbot+689ec3afb1ef07b766b2@syzkaller.appspotmail.com
>     Link: https://lore.kernel.org/r/000000000000554b8205ffdea64e@google.com/
>     Signed-off-by: David Howells <dhowells@redhat.com>
>     cc: Herbert Xu <herbert@gondor.apana.org.au>
>     cc: Paolo Abeni <pabeni@redhat.com>
>     cc: "David S. Miller" <davem@davemloft.net>
>     cc: Eric Dumazet <edumazet@google.com>
>     cc: Jakub Kicinski <kuba@kernel.org>
>     cc: linux-crypto@vger.kernel.org
>     cc: netdev@vger.kernel.org
>
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 0ab43e149f0e..82c44d4899b9 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -68,13 +68,15 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
>  	struct hash_ctx *ctx = ask->private;
>  	ssize_t copied = 0;
>  	size_t len, max_pages, npages;
> -	bool continuing = ctx->more, need_init = false;
> +	bool continuing, need_init = false;
>  	int err;
>  
>  	max_pages = min_t(size_t, ALG_MAX_PAGES,
>  			  DIV_ROUND_UP(sk->sk_sndbuf, PAGE_SIZE));
>  
>  	lock_sock(sk);
> +	continuing = ctx->more;
> +
>  	if (!continuing) {
>  		/* Discard a previous request that wasn't marked MSG_MORE. */
>  		hash_free_result(sk, ctx);
>

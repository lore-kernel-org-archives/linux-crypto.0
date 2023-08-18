Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843D1C7113C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 13:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358475AbjHRNW0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 09:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377089AbjHRNWF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 09:22:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502FB421C
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 06:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692364867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=na/HqEvBUIWFrt2ZYVArJGd9pgLGqwvBv1dWk5WmYf8=;
        b=gDlYD0bHjX/2JQrphyS9XPHfhXG+t36PNokBWWeGjYHl3ddmH8S6aJJ60wO9lwLw8vABWz
        IztpYrXWcXAK9N34x+JXK2orZGhcKAYDZRW9Tr+qAZLKB6zVtFXHCIUhSzeY1QXHwhs4hH
        07QylnRE8m10pfVAdN6ks0u+UgiMpIs=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-8pUc8EUINfeKrkURKuuygg-1; Fri, 18 Aug 2023 09:21:04 -0400
X-MC-Unique: 8pUc8EUINfeKrkURKuuygg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98BB11C07562;
        Fri, 18 Aug 2023 13:21:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EEE2C15BAD;
        Fri, 18 Aug 2023 13:21:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230814180341.8621-1-paskripkin@gmail.com>
References: <20230814180341.8621-1-paskripkin@gmail.com> <20230813122344.14142-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, pabeni@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+cba21d50095623218389@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] crypto: fix uninit-value in af_alg_free_resources
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1890298.1692364860.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 18 Aug 2023 14:21:01 +0100
Message-ID: <1890301.1692364861@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> wrote:

> Syzbot was able to trigger use of uninitialized memory in
> af_alg_free_resources.
> =

> Bug is caused by missing initialization of rsgl->sgl.need_unpin before
> adding to rsgl_list. Then in case of extract_iter_to_sg() failure, rsgl
> is left with uninitialized need_unpin which is read during clean up
> =

> BUG: KMSAN: uninit-value in af_alg_free_sg crypto/af_alg.c:545 [inline]
> BUG: KMSAN: uninit-value in af_alg_free_areq_sgls crypto/af_alg.c:778 [i=
nline]
> BUG: KMSAN: uninit-value in af_alg_free_resources+0x3d1/0xf60 crypto/af_=
alg.c:1117
>  af_alg_free_sg crypto/af_alg.c:545 [inline]
>  af_alg_free_areq_sgls crypto/af_alg.c:778 [inline]
>  af_alg_free_resources+0x3d1/0xf60 crypto/af_alg.c:1117
>  _skcipher_recvmsg crypto/algif_skcipher.c:144 [inline]
> ...
> =

> Uninit was created at:
>  slab_post_alloc_hook+0x12f/0xb70 mm/slab.h:767
>  slab_alloc_node mm/slub.c:3470 [inline]
>  __kmem_cache_alloc_node+0x536/0x8d0 mm/slub.c:3509
>  __do_kmalloc_node mm/slab_common.c:984 [inline]
>  __kmalloc+0x121/0x3c0 mm/slab_common.c:998
>  kmalloc include/linux/slab.h:586 [inline]
>  sock_kmalloc+0x128/0x1c0 net/core/sock.c:2683
>  af_alg_alloc_areq+0x41/0x2a0 crypto/af_alg.c:1188
>  _skcipher_recvmsg crypto/algif_skcipher.c:71 [inline]
> =

> Fixes: c1abe6f570af ("crypto: af_alg: Use extract_iter_to_sg() to create=
 scatterlists")
> Reported-and-tested-by: syzbot+cba21d50095623218389@syzkaller.appspotmai=
l.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dcba21d50095623218389
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Reviewed-by: David Howells <dhowells@redhat.com>


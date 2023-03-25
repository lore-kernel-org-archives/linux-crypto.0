Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B35C6FD1C
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Mar 2023 07:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCYHpI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Mar 2023 03:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCYHpH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2023 03:45:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC0214236
        for <linux-crypto@vger.kernel.org>; Sat, 25 Mar 2023 00:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679730263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1fqtu9LBWrWaCQxQTVjr0cxRai+bTqOnRnWXMB8NKA=;
        b=RBj93ahiQvySV/Giryvnn/YxeXXqs4HrSOh55UQ7fQOHue8Fv7KBOQlPP73t44RXdRiFSk
        +RBVO7+Z0yIQfYzLQBXaBM7yVSaxosUURiymA9dWYB6ZHrGu4DXAipll//qhPBICFVkm23
        UcNwZcsz63GBkVi3y7DcGdNl36y+uNo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-H1kqNBBlOki1ozjiPf4r0w-1; Sat, 25 Mar 2023 03:44:18 -0400
X-MC-Unique: H1kqNBBlOki1ozjiPf4r0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 698D385C06B;
        Sat, 25 Mar 2023 07:44:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55749175AD;
        Sat, 25 Mar 2023 07:44:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZB6N/H27oeWqouyb@gondor.apana.org.au>
References: <ZB6N/H27oeWqouyb@gondor.apana.org.au> <ZBPTC9WPYQGhFI30@gondor.apana.org.au> <3763055.1679676470@warthog.procyon.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, willy@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        viro@zeniv.linux.org.uk, hch@infradead.org, axboe@kernel.dk,
        jlayton@kernel.org, brauner@kernel.org,
        torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH 23/28] algif: Remove hash_sendpage*()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3792016.1679730254.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Sat, 25 Mar 2023 07:44:14 +0000
Message-ID: <3792017.1679730254@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > I must be missing something, I think.  What's particularly optimal abo=
ut the
> > code in hash_sendpage() but not hash_sendmsg()?  Is it that the former=
 uses
> > finup/digest, but the latter ony does update+final?
> =

> A lot of hardware hashes can't perform partial updates, so they
> will always fall back to software unless you use finup/digest.

Okay.  Btw, how much of a hard limit is ALG_MAX_PAGES?  Multipage folios c=
an
exceed the current limit (16 pages, 64K) in size.  Is it just to prevent t=
oo
much memory being pinned at once?

David


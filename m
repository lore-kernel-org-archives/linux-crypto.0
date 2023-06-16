Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26086EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jun 2023 10:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345204AbjFPKr3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jun 2023 06:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbjFPKrP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2023 06:47:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4A322BAE
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jun 2023 03:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686911885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eIOLShY/ZmsNAmLuX2YSma08DfvRfpLXlZqs26cgyEs=;
        b=HYgwas27J9l9or546gHwnMc86cu2QV75slT0td4G/5ZBZPGrXJTQN4uezj84941avwGfvi
        RR+ZA+mHLhGHHyHxWQfND+p/BwZ8GZJ1s/6LzJ68lmI9RGWe0RqZrffczW3bziT1tdUgt+
        QcRaPTCZhq616CEqJCklIji46rzejDc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-CGjzTS8uMVWdy5Eg3ByHXw-1; Fri, 16 Jun 2023 06:38:01 -0400
X-MC-Unique: CGjzTS8uMVWdy5Eg3ByHXw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D5978028B2;
        Fri, 16 Jun 2023 10:38:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5E20492C38;
        Fri, 16 Jun 2023 10:37:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZIw4+Go7ZIth+CsY@gondor.apana.org.au>
References: <ZIw4+Go7ZIth+CsY@gondor.apana.org.au> <1679829.1686785273@warthog.procyon.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com,
        syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com,
        syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com,
        syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] crypto: af_alg/hash: Fix recvmsg() after sendmsg(MSG_MORE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <426352.1686911878.1@warthog.procyon.org.uk>
Date:   Fri, 16 Jun 2023 11:37:58 +0100
Message-ID: <426353.1686911878@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Can you have a look at:

	https://lore.kernel.org/r/415439.1686877276@warthog.procyon.org.uk/

I'm proposing that as an alternative to this patch.

David


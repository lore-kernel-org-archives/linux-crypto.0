Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B2CC77B7A
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 11:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjFALgI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 07:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjFALgI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 07:36:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E72128
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 04:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685619320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g2HrdO1luTCQTFelo54c1HAUWB7J3N54nooptJdm2oE=;
        b=g9999PChwm6UiyIi5Bzd8wFXGWC9pul4cXVajMI3otlXQ42wPOokdHVX757Wy9ywHuUEBw
        KGYGnAwGtPkBMVFNdElnx9YGQocx03WxHhs148HZtoZFUQH9nmrb+4D4gLVM48fDnWzG8Z
        mZq8w1EErSGcqKd+TBwGcdV/eg6o3X0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-b71uj-mYOMqSwieJCWkpYw-1; Thu, 01 Jun 2023 07:35:16 -0400
X-MC-Unique: b71uj-mYOMqSwieJCWkpYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 261D13C14111;
        Thu,  1 Jun 2023 11:35:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC97C8162;
        Thu,  1 Jun 2023 11:35:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <bd2750e52b47af1782233e254114eb8d627f1073.camel@redhat.com>
References: <bd2750e52b47af1782233e254114eb8d627f1073.camel@redhat.com> <20230530141635.136968-1-dhowells@redhat.com> <20230530141635.136968-9-dhowells@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/10] crypto: af_alg: Support MSG_SPLICE_PAGES
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <822307.1685619312.1@warthog.procyon.org.uk>
Date:   Thu, 01 Jun 2023 12:35:12 +0100
Message-ID: <822308.1685619312@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> wrote:

> > +	if ((msg->msg_flags & MSG_SPLICE_PAGES) &&
> > +	    !iov_iter_is_bvec(&msg->msg_iter))
> > +		return -EINVAL;
> > +
> ...
> It looks like the above expect/supports only ITER_BVEC iterators, what
> about adding a WARN_ON_ONCE(<other iov type>)?

Meh.  I relaxed that requirement as I'm now using tools to extract stuff from
any iterator (extract_iter_to_sg() in this case) rather than walking the
bvec[] directly.  I forgot to remove the check from af_alg.  I can add an
extra patch to remove it.  Also, it probably doesn't matter for AF_ALG since
that's only likely to be called from userspace, either directly (which will
not set MSG_SPLICE_PAGES) or via splice (which will pass a BVEC).  Internal
kernel code will use crypto API directly.

> Also, I'm keeping this series a bit more in pw to allow Herbert or
> others to have a look.

Thanks.

David


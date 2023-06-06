Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7BCC7EE2C
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 10:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbjFFKKK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 06:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjFFKJu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 06:09:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC621B8
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 03:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686046142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F4JNHdmIU+J3kVcs1IYBZBUWzvI5VjVlXL+hGRsI0N4=;
        b=ipHDj+nD7AQbJzz1Y9dpyFOINhERcBU5GG5uNWe2sbzIdS76VFfsp6IUrKZe0wHhArtY8T
        y8gnSjoy6HH+HSb2jBheWK1jUg2F4qwIyQ5YZ7eNMK44vPh1e5m/92+RAwzLYiA+fylEJ0
        B3g2xY3vpA+p/d49eA2aX0G9azpkdAc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-ltKQLOWwOcewKDM18omRjA-1; Tue, 06 Jun 2023 06:08:58 -0400
X-MC-Unique: ltKQLOWwOcewKDM18omRjA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 816E4101A53A;
        Tue,  6 Jun 2023 10:08:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A3571121314;
        Tue,  6 Jun 2023 10:08:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZH78uQsrUz4fxZmm@gondor.apana.org.au>
References: <ZH78uQsrUz4fxZmm@gondor.apana.org.au> <ZH7xzYfwQoWZLUYa@gondor.apana.org.au> <20230530141635.136968-1-dhowells@redhat.com> <20230530141635.136968-11-dhowells@redhat.com> <1845449.1686043495@warthog.procyon.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 10/10] crypto: af_alg/hash: Support MSG_SPLICE_PAGES
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1846126.1686046133.1@warthog.procyon.org.uk>
Date:   Tue, 06 Jun 2023 11:08:53 +0100
Message-ID: <1846127.1686046133@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> So I think we should keep the limit as is.

Okay.

David


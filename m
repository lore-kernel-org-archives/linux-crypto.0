Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A54EB64D9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jun 2023 16:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjFSQs0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jun 2023 12:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjFSQsZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2023 12:48:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608DFFE
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jun 2023 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687193256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i+a8DGHRj3jW50Valrkn+7VRWxzc0jyAL0po+eTjD1I=;
        b=BxDjNUx51vK8CEsffq6+XEZuXA1E9eqWgnVX4x+/Whyi7z94vyZdHLvRinv1R+x8WWwTa9
        9tayqfDSoO45F3P3ApVFUFbUwo2Qc0f9vd2EOq+cfHSK3oxRvSqdcaCNGmGkH7Db0ljtEu
        qSjhLINTPDlmv5HmpBWY4XYD21POui0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-ojfv7mcJNBW2RxY_gMc9Ug-1; Mon, 19 Jun 2023 12:47:30 -0400
X-MC-Unique: ojfv7mcJNBW2RxY_gMc9Ug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4C1B858287;
        Mon, 19 Jun 2023 16:47:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B601112132D;
        Mon, 19 Jun 2023 16:47:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZIw8y2w+A+t5u+IJ@gondor.apana.org.au>
References: <ZIw8y2w+A+t5u+IJ@gondor.apana.org.au> <ZIw4+Go7ZIth+CsY@gondor.apana.org.au> <1679829.1686785273@warthog.procyon.org.uk> <426353.1686911878@warthog.procyon.org.uk>
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
Content-ID: <1132300.1687193246.1@warthog.procyon.org.uk>
Date:   Mon, 19 Jun 2023 17:47:26 +0100
Message-ID: <1132301.1687193246@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Anyway, why did you remove the condition on hash_free_result?
> We free the result if it's not needed, not to clear the previous
> hash.  So by doing it uncondtionally you will simply end up
> freeing and reallocating the result for no good reason.

The free here:

	if (!continuing) {
		if ((msg->msg_flags & MSG_MORE))
			hash_free_result(sk, ctx);

only happens in the following case:

	send(hashfd, "", 0, 0);
	send(hashfd, "", 0, MSG_MORE);  <--- by this

and the patch changes how this case works if no data is given.  In Linus's
tree, it will create a result, init the crypto and finalise it in
hash_sendmsg(); with this patch that case is then handled by hash_recvmsg().
If you consider the following sequence:

	send(hashfd, "", 0, 0);
	send(hashfd, "", 0, 0);
	send(hashfd, "", 0, 0);
	send(hashfd, "", 0, 0);

Upstream, the first one will create a result and then each of them will init
and finalise a hash, whereas with my patch, the first one will release any
outstanding result and then none of them will do any crypto ops.

However, as, with my patch hash_sendmsg() no longer calculated a result, it
has to clear the result pointer because the logic inside hash_recvmsg() relies
on the result pointer to indicate that there is a result.

Instead, hash_recvmsg() concocts the result - something it has to be able to
do anyway in case someone calls recvmsg() without first supplying data.

David


Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411A0EB64DA
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 12:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbjFNMFh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 08:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244406AbjFNMFg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 08:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AC31FD4
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 05:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686744293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wOPn16B3XWpxkytpYHR3Z5EM60rOR3dmARKpzGwWozo=;
        b=XC8Q+ti2forU1f10uFgkqXEtrt61fZAePN3twdV97TX39TC++2n2pz+7GNdXBuQi4eIs0l
        L+thjKYIa2waSVqCkq4fL3/Vl7ncFyElrDpWFGAUdsxtOR5QJ18Y18uFy9X/JaPfb64lrv
        I7Ocgi7uL2tf7zoBuGb2YzGaGXVpCdA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-oSw5vEMcNhWtY8PAEacv1A-1; Wed, 14 Jun 2023 08:04:47 -0400
X-MC-Unique: oSw5vEMcNhWtY8PAEacv1A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 710041C0E3D4;
        Wed, 14 Jun 2023 12:04:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B3BF492CA6;
        Wed, 14 Jun 2023 12:04:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZIhD53a/6Svmn1aS@gondor.apana.org.au>
References: <ZIhD53a/6Svmn1aS@gondor.apana.org.au> <0000000000000cb2c305fdeb8e30@google.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] general protection fault in cryptd_hash_export
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1521346.1686744278.1@warthog.procyon.org.uk>
Date:   Wed, 14 Jun 2023 13:04:38 +0100
Message-ID: <1521347.1686744278@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> David, the logic for calling hash_alloc_result looks quite different
> from that on whether you do the hash finalisation.  I'd suggest that
> you change them to use the same check, and also set use NULL instead
> of ctx->result if you didn't call hash_alloc_result.

I don't fully understand what the upstream hash_sendmsg() is doing.  Take this
bit for example:

	if (!ctx->more) {
		if ((msg->msg_flags & MSG_MORE))
			hash_free_result(sk, ctx);

Why is it freeing the old result only if MSG_MORE is now set, but wasn't set
on the last sendmsg()?

David


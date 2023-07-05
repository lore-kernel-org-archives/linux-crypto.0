Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C411EB64DA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jul 2023 23:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjGEXG6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jul 2023 19:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjGEXGz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2023 19:06:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD55102
        for <linux-crypto@vger.kernel.org>; Wed,  5 Jul 2023 16:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688598369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lwuQxAK6zqLGBR5M40mwPHJnWPOJGuE2YbKWU1Q6hD4=;
        b=PEDAtDJihGQp4TlCYvsWBzgyIYPj4boMitZr6aqIA/WVVZGYhztXEcaOBxf+a081nZiYSj
        bM6X8w23n43Ffr0q5+t8iuNoWsbkwtel4Tlr7qcS5/nRQ0HwXJKvinGy8siycap7OBAYFT
        qEmgwKNtICU8XTxyajsgnhIZdgFhiEc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-0pGMGBMBMHiYAe5PpGyDbA-1; Wed, 05 Jul 2023 19:06:04 -0400
X-MC-Unique: 0pGMGBMBMHiYAe5PpGyDbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09F6B101A528;
        Wed,  5 Jul 2023 23:06:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 246594087C6A;
        Wed,  5 Jul 2023 23:06:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZKXoBM7EQfbKKVjG@gondor.apana.org.au>
References: <ZKXoBM7EQfbKKVjG@gondor.apana.org.au> <0000000000003f2db705ffc133d2@google.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+f2c120b449b209d89efa@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] WARNING in extract_iter_to_sg
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1869451.1688598362.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 06 Jul 2023 00:06:02 +0100
Message-ID: <1869452.1688598362@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> CPU: 0 PID: 26699 Comm: syz-executor.2 Not tainted 6.4.0-rc7-syzkaller-0=
1944-g3674fbf0451d #0

Looking at the version string, this is from net-next before the merger wit=
h
Linus's tree after the point where Linus had merged:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/=
?h=3Dfor-6.5/splice

> extract_iter_to_sg(3) unsupported

This is ITER_PIPE (type 3) before is removed by:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D3fc40265ae2b48a7475c41c5c0b256374c419f4b

=46rom that point on ITER_XARRAY is type 3 and there's a case for that in
extract_iter_to_sg().

So the fix for this is to merge it with the splice tree - which Linus has
already done, so this should be fixed upstream.

With hindsight, I should've used iov_iter_get_pages*() rather than
iov_iter_extract_pages() and extract_iter_to_sg() in the networking code
recvmsg() path until after the merge.

David


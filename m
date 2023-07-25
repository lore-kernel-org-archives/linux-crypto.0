Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41212C0015E
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jul 2023 15:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjGYPTf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jul 2023 11:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjGYPTe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2023 11:19:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BA3E5A
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 08:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690298327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lvJT1Nrqg3NuKZyozBDgNxTT7my/YGr0ImgVXCIWT+Q=;
        b=CCd1TSTmM/2RMJLvxhpY1F9xt3uZEyA8LVTY1lBpspueWBz2VSgtQF0+c3YUgWZKIdXytw
        /g7tI+0V3pk30PdzHeU3JcWCeVa7kBMgwWqzOEfjfUNep6ixpwhgMndw37jPUel/+eOj57
        zj3bqis+baNssjH3xLvCBycT+lL0pdI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-ydjjzhLKN3mWGOToHbmD_Q-1; Tue, 25 Jul 2023 11:18:44 -0400
X-MC-Unique: ydjjzhLKN3mWGOToHbmD_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74DD9868021;
        Tue, 25 Jul 2023 15:18:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 241F74094DC0;
        Tue, 25 Jul 2023 15:18:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000c6527105fe7fdab8@google.com>
References: <000000000000c6527105fe7fdab8@google.com>
To:     syzbot <syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] general protection fault in shash_ahash_update
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <103845.1690298320.1@warthog.procyon.org.uk>
Date:   Tue, 25 Jul 2023 16:18:40 +0100
Message-ID: <103846.1690298320@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

#syz fix: crypto: af_alg/hash: Fix recvmsg() after sendmsg(MSG_MORE)


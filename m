Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44253EB64D9
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jul 2023 15:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjGDP5X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jul 2023 11:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjGDP5S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2023 11:57:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C07510C1
        for <linux-crypto@vger.kernel.org>; Tue,  4 Jul 2023 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688486190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6+ZHn5E4Ey2ZPvoR0JBGrpwDUf/hUgRLwKW3bRltrnM=;
        b=TDgGFH/XPxAD+XORj7hgzFQ+6Y2g0VwRqkg0WNpwc/3wvjoWHW2/LXuPiESpJIm3PcRWe7
        9oIxiw7XT34BfE3sHOBJzXXU2hF06h6pI/nXwnKbDYtuGPuHpshIgIJhnWv7DVJ3pEwpR+
        ZoInx6TZg6yxT8lChJ6sw4nIQeGbA5E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-iMiKNks1MWGc2_Z9ocmsWQ-1; Tue, 04 Jul 2023 11:56:27 -0400
X-MC-Unique: iMiKNks1MWGc2_Z9ocmsWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D53AF805C3F;
        Tue,  4 Jul 2023 15:56:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 777A81121318;
        Tue,  4 Jul 2023 15:56:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>
cc:     dhowells@redhat.com, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] crypto: af_alg: Fix merging of written data into spliced pages
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 04 Jul 2023 16:56:24 +0100
Message-ID: <1585899.1688486184@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

=20=20=20=20
af_alg_sendmsg() takes data-to-be-copied that's provided by write(),
send(), sendmsg() and similar into pages that it allocates and will merge
new data into the last page in the list, based on the value of ctx->merge.

Now that af_alg_sendmsg() accepts MSG_SPLICE_PAGES, it adds spliced pages
directly into the list and then incorrectly appends data to them if there's
space left because ctx->merge says that it can.  This was cleared by
af_alg_sendpage(), but that got lost.

Fix this by skipping the merge if MSG_SPLICE_PAGES is specified and
clearing ctx->merge after MSG_SPLICE_PAGES has added stuff to the list.

Fixes: bf63e250c4b1 ("crypto: af_alg: Support MSG_SPLICE_PAGES")
Reported-by: Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.com>
Link: https://lore.kernel.org/r/CAAUqJDvFuvms55Td1c=3DXKv6epfRnnP78438nZQ-J=
KyuCptGBiQ@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Paolo Abeni <pabeni@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: linux-crypto@vger.kernel.org
cc: netdev@vger.kernel.org
---
 crypto/af_alg.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6218c773d71c..06b15b9f661c 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -992,7 +992,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *=
msg, size_t size,
 		ssize_t plen;
=20
 		/* use the existing memory in an allocated page */
-		if (ctx->merge) {
+		if (ctx->merge && !(msg->msg_flags & MSG_SPLICE_PAGES)) {
 			sgl =3D list_entry(ctx->tsgl_list.prev,
 					 struct af_alg_tsgl, list);
 			sg =3D sgl->sg + sgl->cur - 1;
@@ -1054,6 +1054,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr=
 *msg, size_t size,
 			ctx->used +=3D plen;
 			copied +=3D plen;
 			size -=3D plen;
+			ctx->merge =3D 0;
 		} else {
 			do {
 				struct page *pg;
@@ -1085,12 +1086,12 @@ int af_alg_sendmsg(struct socket *sock, struct msgh=
dr *msg, size_t size,
 				size -=3D plen;
 				sgl->cur++;
 			} while (len && sgl->cur < MAX_SGL_ENTS);
+
+			ctx->merge =3D plen & (PAGE_SIZE - 1);
 		}
=20
 		if (!size)
 			sg_mark_end(sg + sgl->cur - 1);
-
-		ctx->merge =3D plen & (PAGE_SIZE - 1);
 	}
=20
 	err =3D 0;


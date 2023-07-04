Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF84EB64D9
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jul 2023 09:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjGDJAf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jul 2023 05:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbjGDJA2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2023 05:00:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37CB187
        for <linux-crypto@vger.kernel.org>; Tue,  4 Jul 2023 01:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688461170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=paC8amlCs7TRJUekiCqVmk/KBu19mn9NCI2LAP9sEbM=;
        b=bYn1rlpl/epkiuKA6/QI02DTHkA70EZzUNRiLLqXOM0dcA8e5v+/ligiEDV4bk3sy8+V20
        sIm26pp0LBWHq8CPe44oU/cGmBx/UmPBL24x3NcLYBCu9IMV/KKvc0gXeCchV4o+H6v01l
        pBVatnXVF6XcTRIGq0+zDJLsYUUhnXk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-nHh9GI1JOcuf4wkhORAM2A-1; Tue, 04 Jul 2023 04:59:27 -0400
X-MC-Unique: nHh9GI1JOcuf4wkhORAM2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4722F88D1A0;
        Tue,  4 Jul 2023 08:59:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B9BDC00049;
        Tue,  4 Jul 2023 08:59:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAAUqJDvFuvms55Td1c=XKv6epfRnnP78438nZQ-JKyuCptGBiQ@mail.gmail.com>
References: <CAAUqJDvFuvms55Td1c=XKv6epfRnnP78438nZQ-JKyuCptGBiQ@mail.gmail.com>
To:     =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc:     dhowells@redhat.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: Regression bisected to "crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1357959.1688461165.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 04 Jul 2023 09:59:25 +0100
Message-ID: <1357960.1688461165@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The attached makes the SEGV go away.  Just removing SPLICE_F_GIFT isn't
sufficient.

David
---
diff --git a/lib/kcapi-kernel-if.c b/lib/kcapi-kernel-if.c
index b4d7f74..33e0337 100644
--- a/lib/kcapi-kernel-if.c
+++ b/lib/kcapi-kernel-if.c
@@ -321,7 +321,7 @@ ssize_t _kcapi_common_vmsplice_iov(struct kcapi_handle=
 *handle,
 	if (ret)
 		return ret;
 =

-	ret =3D vmsplice(handle->pipes[1], iov, iovlen, SPLICE_F_GIFT|flags);
+	ret =3D writev(handle->pipes[1], iov, (int)iovlen);
 	if (ret < 0) {
 		ret =3D -errno;
 		kcapi_dolog(KCAPI_LOG_DEBUG,


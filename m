Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0299EB64D9
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jul 2023 14:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjGDOe5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jul 2023 10:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjGDOe5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2023 10:34:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EC0E5B
        for <linux-crypto@vger.kernel.org>; Tue,  4 Jul 2023 07:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688481253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gYHch/SklDJL/CopH6fHbY5oof68s+i62UNUpHYmC24=;
        b=WVolJ3hXZFrf47aLRYJIU6JEC90Gbcf5UpFYbl0jA1XS5l5wpm4OD6yM4i5jCA9cuUR6qt
        G2pRz2isMszaJcyYLeDpaeTp2BL1UIIFhsh3cqMQKvbrShF1U8kocdN7tZ85cNln6ceGVe
        yq4DE/7H2u6O9P0vHZVnIXfgG2ZHEuo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-TumVCkMINnWZXNJl7_pR8g-1; Tue, 04 Jul 2023 10:34:10 -0400
X-MC-Unique: TumVCkMINnWZXNJl7_pR8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8077B1C04B40;
        Tue,  4 Jul 2023 14:34:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0A681121314;
        Tue,  4 Jul 2023 14:34:08 +0000 (UTC)
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
Content-ID: <1506613.1688481248.1@warthog.procyon.org.uk>
Date:   Tue, 04 Jul 2023 15:34:08 +0100
Message-ID: <1506614.1688481248@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The problem is caused by this bit in af_alg_sendmsg():

		/* use the existing memory in an allocated page */
		if (ctx->merge) {
			sgl = list_entry(ctx->tsgl_list.prev,
					 struct af_alg_tsgl, list);
			sg = sgl->sg + sgl->cur - 1;
			len = min_t(size_t, len,
				    PAGE_SIZE - sg->offset - sg->length);

			err = memcpy_from_msg(page_address(sg_page(sg)) +
					      sg->offset + sg->length,
					      msg, len);
			if (err)
				goto unlock;

			sg->length += len;
			ctx->merge = (sg->offset + sg->length) &
				     (PAGE_SIZE - 1);

			ctx->used += len;
			copied += len;
			size -= len;
			continue;
		}

it doesn't exist in the old af_alg_sendpage() code.  It merges data supplied
by sendmsg() into the last page in the list if there's space.  So we need a
flag to keep track of whether the last page is appendable-to or not.

David


Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882D3C001B0
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Aug 2023 08:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjHNI2V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Aug 2023 04:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbjHNI1s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2023 04:27:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134B110B
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2023 01:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692001614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H33gECP+9hXyb+EizpAzFVTxGWbGL8MsN4gYGXEf7/Q=;
        b=MMvrviWMD3qHlkzdgt46YDVKHYQEEJ1XI5SPpWyJdFau2BA3wOpxHdyJF2u4ROgAiZiKT+
        eFSG6FpDr3AgbsYrHRXIm38PcPQutf2zCkPk9YCWBw6NCdwYTXfrkn7ZRpQOaQHJQFC/yJ
        Dq98gUrb6wpztBvMyNSm2fC98G8JVz4=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-UZ9e3W2COM-03RqOQaRmKA-1; Mon, 14 Aug 2023 04:26:52 -0400
X-MC-Unique: UZ9e3W2COM-03RqOQaRmKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 174012A59575;
        Mon, 14 Aug 2023 08:26:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4FB41121315;
        Mon, 14 Aug 2023 08:26:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230813122344.14142-1-paskripkin@gmail.com>
References: <20230813122344.14142-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, pabeni@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+cba21d50095623218389@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: fix uninit-value in af_alg_free_resources
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3954479.1692001609.1@warthog.procyon.org.uk>
Date:   Mon, 14 Aug 2023 09:26:49 +0100
Message-ID: <3954480.1692001609@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> wrote:

> Syzbot was able to trigger use of uninitialized memory in
> af_alg_free_resources.
> 
> Bug is caused by missing initialization of rsgl->sgl.need_unpin before
> adding to rsgl_list. Then in case of extract_iter_to_sg() failure, rsgl
> is left with uninitialized need_unpin which is read during clean up

Looks feasible :-).

> +		rsgl->sgl.need_unpin = 0;
> +

The blank line isn't really necessary and it's a bool, so can you use 'false'
rather than '0'?

Alternatively, it might be better to move:

		rsgl->sgl.need_unpin =
			iov_iter_extract_will_pin(&msg->msg_iter);

up instead.

David


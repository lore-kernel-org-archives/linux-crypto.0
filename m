Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05D2EB64D9
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jul 2023 06:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjGGGB7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jul 2023 02:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjGGGB6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2023 02:01:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDBE1FC6
        for <linux-crypto@vger.kernel.org>; Thu,  6 Jul 2023 23:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688709676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RW78yBHBVifbb508B+Nr2a052QJ90AYozIpUCk7W+5k=;
        b=Xj0S8JYecXlMi4PgyhMOqonLKHx8cE+IqS6+nYG5doX77prjVQjPtqtKAS4IcyebkL+olx
        Nt284dHBQtOcTBZKoX61Ev5jco7BFmHrLTjVzv+SWdadJ4uRliCOPTDqzOoPPCYVkIN2nj
        KIbnFNhu3+yoS2FZFMCE4Loi6/Nw97M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-L8ycMmuaOm6Y_LdlEWrHkA-1; Fri, 07 Jul 2023 02:01:11 -0400
X-MC-Unique: L8ycMmuaOm6Y_LdlEWrHkA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F6E7803B25;
        Fri,  7 Jul 2023 06:01:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2F484087C6B;
        Fri,  7 Jul 2023 06:01:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <c5e34c6a-da1e-4585-98c4-14701b0e093e@moroto.mountain>
References: <c5e34c6a-da1e-4585-98c4-14701b0e093e@moroto.mountain>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KEYS: asymmetric: Fix error codes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2210839.1688709669.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 07 Jul 2023 07:01:09 +0100
Message-ID: <2210840.1688709669@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dan Carpenter <dan.carpenter@linaro.org> wrote:

> These error paths should return the appropriate error codes instead of
> returning success.
> =

> Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without=
 scatterlists")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: David Howells <dhowells@redhat.com>


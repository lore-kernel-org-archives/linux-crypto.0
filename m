Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AFAC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Mar 2022 12:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344278AbiC3MzV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Mar 2022 08:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345265AbiC3MzT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Mar 2022 08:55:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2F78A9946
        for <linux-crypto@vger.kernel.org>; Wed, 30 Mar 2022 05:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648644813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UxAUy7q/bwbjnZH+uuAP6NaBEIgbf127Gn+Ruta26qg=;
        b=iU9cChoGDs+2fKO+EjjaYges9BCXC/IbZ99SMXOSZ/rF6iBDys3aZSK0KrBxtDYGx2TYT6
        4jaj4/1fXoLSmUaeHHpCOSrIpMlNcxvoaEzzmEpcOhgckCPZ9hCAdXY1nKi05tgwVDAVD2
        yWL+6yUaeU4HFHIVJK4fF7kh5rSH+Lc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-6MnJVqZzM5iPCIFFO_AhoQ-1; Wed, 30 Mar 2022 08:53:29 -0400
X-MC-Unique: 6MnJVqZzM5iPCIFFO_AhoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA7172800F6E;
        Wed, 30 Mar 2022 12:53:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4341EC202C6;
        Wed, 30 Mar 2022 12:53:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220322111323.542184-2-mic@digikod.net>
References: <20220322111323.542184-2-mic@digikod.net> <20220322111323.542184-1-mic@digikod.net>
To:     =?us-ascii?Q?=3D=3FUTF-8=3Fq=3FMicka=3DC3=3DABl=3D20Sala=3DC3=3DBCn=3F?=
         =?us-ascii?Q?=3D?= <mic@digikod.net>
Cc:     dhowells@redhat.com, Jarkko Sakkinen <jarkko@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Eric Snowberg <eric.snowberg@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?us-ascii?Q?=3D=3FUTF-8=3Fq=3FMicka=3DC3=3DABl?=
         =?us-ascii?Q?=3D20Sala=3DC3=3DBCn=3F=3D?= 
        <mic@linux.microsoft.com>
Subject: Re: [PATCH v2 1/1] certs: Explain the rationale to call panic()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 30 Mar 2022 13:53:26 +0100
Message-ID: <2933967.1648644806@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wrote:

> The blacklist_init() function calls panic() for memory allocation
> errors.  This change documents the reason why we don't return -ENODEV.

Why, though?

This is only called whilst the kernel is booting.  If you hit ENOMEM, you
aren't likely to get much further with the boot process.

David


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A615C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jan 2021 09:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 175D220759
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jan 2021 09:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhA0Jpi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Jan 2021 04:45:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235421AbhA0Jmb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Jan 2021 04:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611740462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6nw3vFf/Td11sFLAlbl27mXmQ2H9WscAygorAYmqSIE=;
        b=dSBBRaEYrNb8n+AAvBnqfhyT0pDUwt7+8gl3lXy+xw7ozJuntp5kR8tIIgbCabWXJqbHm5
        fMLk7g2/Aant+/8pBeokYGUv4j96xVNTme2yMKQndSWmdZYTB2btVacDmJxRNEJkS6yCwy
        prZZAvzdM8dBIOPWWFZNfVUReyCt3R8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-QAN8C2BSMw63OvZqA_oaQw-1; Wed, 27 Jan 2021 04:40:58 -0500
X-MC-Unique: QAN8C2BSMw63OvZqA_oaQw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BADA107ACE3;
        Wed, 27 Jan 2021 09:40:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDE5310023B3;
        Wed, 27 Jan 2021 09:40:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <YAi/gERomykYZqKZ@kernel.org>
References: <YAi/gERomykYZqKZ@kernel.org> <20210120090517.23851-1-jlee@suse.com> <20210120090517.23851-2-jlee@suse.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     dhowells@redhat.com, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Ben Boeckel <me@benboeckel.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Malte Gell <malte.gell@gmx.de>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH 1/4] X.509: Add CodeSigning extended key usage parsing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3050315.1611740453.1@warthog.procyon.org.uk>
Date:   Wed, 27 Jan 2021 09:40:53 +0000
Message-ID: <3050316.1611740453@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jarkko Sakkinen <jarkko@kernel.org> wrote:

> With eBPF around, does this make any sense?

bpf/ebpf may be partially disabled if you boot in secure boot mode - not sure
whether that affects this.

David


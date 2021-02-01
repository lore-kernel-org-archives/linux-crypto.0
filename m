Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6A9C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 15:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 883BC64DAF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 15:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhBAPJ0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 10:09:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231473AbhBAPJK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 10:09:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612192064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rJ1BNHbLyBivT85os4ZEgQB+CLLa83qJkWROJrNOKGM=;
        b=hd6oXuz3QwPFYtttQmMAH2ZKjqQCCme/1I8tBfqk76NMiP0Cacd2rGcx09XrREkJSjrx8A
        9O/pskuXaNL2h0pe6k7ug4xIlTNsu4ILbKM4NRk12WhmG4Dd13rSFmyMv6vBWl02gjqyW7
        FU4rhIc9u8yG/0XqgIYVNK4BqKuM7qc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-RvKMTgIPPmaxLkH-Yb_XOQ-1; Mon, 01 Feb 2021 10:07:40 -0500
X-MC-Unique: RvKMTgIPPmaxLkH-Yb_XOQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB8F0801817;
        Mon,  1 Feb 2021 15:07:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D38EA5C1A1;
        Mon,  1 Feb 2021 15:07:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <58935b00f65e389e9ae3da2425d06bd88d280e43.camel@linux.ibm.com>
References: <58935b00f65e389e9ae3da2425d06bd88d280e43.camel@linux.ibm.com> <20210129150355.850093-3-stefanb@linux.vnet.ibm.com> <20210129150355.850093-1-stefanb@linux.vnet.ibm.com> <4162801.1612185801@warthog.procyon.org.uk> <71a77d10-e645-194f-5073-ebf180a8d70e@linux.ibm.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     dhowells@redhat.com, Stefan Berger <stefanb@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, patrick@puiterwijk.org,
        linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 2/4] x509: Detect sm2 keys by their parameters OID
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4170407.1612192055.1@warthog.procyon.org.uk>
Date:   Mon, 01 Feb 2021 15:07:35 +0000
Message-ID: <4170408.1612192055@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Mimi Zohar <zohar@linux.ibm.com> wrote:

> > > Do you have a branch you want me to pull or did you want me to take just
> > > patches 2-4?
> > 
> > Please take it from the mailing list. If there are requests for more 
> > changes on the crypto level, I will send another series. I personally am 
> > waiting for some sort of verdict on the crypto level...
> 
> The entire patch set should be upstreamed as a single patch set, after
> having each of the maintainer's Ack it.  In addition, the v6 version is
> missing some Reviewed-by tags.  (Stefan will re-post a v7 patch set.)
> 
> David, I don't have problem with this patch set being upstreamed via
> the keys subsystem, assuming it's been tested.

Herbert wants the first patch to go through the crypto tree.  Maybe all of
them should proceed by that route if Herbert is willing?

What do patches 2-4 do if patch 1 isn't applied?

David


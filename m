Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE39C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 13:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFAE764E7A
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 13:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBANWR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 08:22:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232134AbhBANVc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 08:21:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612185606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IUHx+ZmyPT9Dyu1dEfWtcZBy3fkG4ai+h8kqNZZO+ns=;
        b=PBvfeOtRl9J/o6DCF+sp2nL9ZOK1EfFALGecEXkF7WJ5XuURKybLkmfzruIqnDgCPaLanv
        5WDysWB2kkQLQCEN4dXVWblYv5BBBs/nsGe4TAJZ8J/KXFtJqew5pSUMrKTngMVHTM9InQ
        0OzUVo+vdv2C0PmK5UIEIG4m3sNDBis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-HCE66KfhPEWQgCyY3tplGA-1; Mon, 01 Feb 2021 08:20:02 -0500
X-MC-Unique: HCE66KfhPEWQgCyY3tplGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1F181005513;
        Mon,  1 Feb 2021 13:20:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBDBD5C276;
        Mon,  1 Feb 2021 13:19:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210129155529.brxbmgzzosvtwrzw@altlinux.org>
References: <20210129155529.brxbmgzzosvtwrzw@altlinux.org> <20210129150355.850093-1-stefanb@linux.vnet.ibm.com> <20210129150355.850093-5-stefanb@linux.vnet.ibm.com>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     dhowells@redhat.com, Stefan Berger <stefanb@linux.vnet.ibm.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, patrick@puiterwijk.org,
        linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH v5 4/4] ima: Support EC keys for signature verification
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4162570.1612185598.1@warthog.procyon.org.uk>
Date:   Mon, 01 Feb 2021 13:19:58 +0000
Message-ID: <4162571.1612185598@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Vitaly Chikunov <vt@altlinux.org> wrote:

> > +static inline
> > +const struct public_key *asymmetric_key_public_key(const struct key *key)
> > +{
> > +	return key->payload.data[asym_crypto];
> > +}
> 
> I wonder why use this accessor which does nothing else, because in all
> other places payload.data[asym_crypto] accessed directly.

We should probably move to using wrappers rather than accessing directly for
type safety.

David


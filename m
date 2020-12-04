Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A30AC4361B
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 14:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E4D422B3B
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 14:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbgLDOLC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:11:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728722AbgLDOLB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Dec 2020 09:11:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9OEt87d7w9rWChprEgMK6QTgcsKqWJCNvTmx79LgE9w=;
        b=LCl8BQkR/+l922WVUfugT96EfUx3ZQFShcgj2b92IUSuToNNJrDr31Y1cKb3+6HT72EbBy
        8q2IcamxkWFCPX96o4U+UEpvDDqQcWDR23QeqKR40DQ6I/4R0t1kbfKXZ9Kgd3IbT/yIVO
        SWbOWL/ThAXT/K3evxHruQsyFgZBWJs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-R7LpfNlGPqiujmB7WtwOnQ-1; Fri, 04 Dec 2020 09:09:31 -0500
X-MC-Unique: R7LpfNlGPqiujmB7WtwOnQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D84D107ACF6;
        Fri,  4 Dec 2020 14:09:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66EFB60861;
        Fri,  4 Dec 2020 14:09:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201120180426.922572-3-mic@digikod.net>
References: <20201120180426.922572-3-mic@digikod.net> <20201120180426.922572-1-mic@digikod.net>
To:     =?us-ascii?Q?=3D=3FUTF-8=3Fq=3FMicka=3DC3=3DABl=3D20Sala=3DC3=3DBCn=3F?=
         =?us-ascii?Q?=3D?= <mic@digikod.net>
Cc:     dhowells@redhat.com, David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?us-ascii?Q?=3D=3FUTF-8=3Fq=3FMicka=3DC3=3DABl?=
         =?us-ascii?Q?=3D20Sala=3DC3=3DBCn=3F=3D?= 
        <mic@linux.microsoft.com>, Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v1 2/9] certs: Make blacklist_vet_description() more strict
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 04 Dec 2020 14:09:25 +0000
Message-ID: <113978.1607090965@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wrote:

> +	if (*desc)
> +		/* The hash is greater than MAX_HASH_LEN. */
> +		return -EINVAL;

-ENOPKG might be better.  It's not that the string is invalid, it's just th=
at
it's unsupported at the moment.

David


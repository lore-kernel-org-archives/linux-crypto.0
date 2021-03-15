Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748DDC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Mar 2021 10:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A2B864EE2
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Mar 2021 10:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCOKxB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Mar 2021 06:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229636AbhCOKw5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Mar 2021 06:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615805576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LK2mxkow7e8brVvXEdY4+jZpUz8M80ZpwI/loM8Aq14=;
        b=Hge9OH3UCfbXi8dRnUK+ZbtH3kfJ0w2Gfh0aDB1RGguIEo29/QGHXAtMS7g/6hIJgAAFfY
        4G2xx0o8oklIxGdvVVxFnYiay1cWhIkRoNKCDYXPi15vchYo50HUalh6DnvxtD/oNttVLE
        RHYkVFbtj0OZejt7kZgApFsqlt09EoM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-z1C2DBT7MCGPLdvuszLy1w-1; Mon, 15 Mar 2021 06:52:54 -0400
X-MC-Unique: z1C2DBT7MCGPLdvuszLy1w-1
Received: by mail-ed1-f70.google.com with SMTP id y10so3430101edr.20
        for <linux-crypto@vger.kernel.org>; Mon, 15 Mar 2021 03:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LK2mxkow7e8brVvXEdY4+jZpUz8M80ZpwI/loM8Aq14=;
        b=SHHt9YjlGQ3Ggv5/7+YcK00BW6Nj9pSldWokm6emT8EFUrCHxZ/YeYrjQ/6IWHlvno
         IJCrhcY2ZC6bn86e37emW4y6KSuQJx/U8NKQsRZ/9z7OaJzrn3T4bUCo7uvsQFnx/zUZ
         6P9RLw/oaR/yqQX/cfDiGeFShVntWtz+PkK5A7npEdDLOvFXhZBBTRIrCTTKUMBJg57D
         WE2NZj+WnaZbjHrHE3FUUW1uME9QcV4vTnJPhfDL/9a7Jym5Pfj5pcjUPtFD3PlJ3Rxc
         CMLR9xbuEsyDElQZtickLJQueBZHm/B9mm4dUb3J5PB9PKm6f+B2pc0XhZF5yjjmOgnY
         /9tg==
X-Gm-Message-State: AOAM532EY0Gimor0GJHNfeKcgz+PPhk6ob4dEb+fhPJjyYEkCKw7/FGs
        iJ6HdM1/ybE8Rrhh5p64JJ+QbpLcL0h+6zj+zat+T1fW5OvGgf09CDaQlQY2fQu4b21T0D63rJW
        BCmkRxAWHaXMljdCqtrVw1sgi
X-Received: by 2002:aa7:df84:: with SMTP id b4mr28919056edy.240.1615805573751;
        Mon, 15 Mar 2021 03:52:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwx9wCpiGKad6zkmoQf20XvPw/JdC59hTlwQbulqEsV40iMgbgWHPodUkiEnuXQgGqtdDrTYA==
X-Received: by 2002:aa7:df84:: with SMTP id b4mr28919049edy.240.1615805573623;
        Mon, 15 Mar 2021 03:52:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id lk12sm7058344ejb.14.2021.03.15.03.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 03:52:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 76BD418027E; Mon, 15 Mar 2021 11:52:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
In-Reply-To: <YEi1RgPgwfT7qHQM@kroah.com>
References: <875z419ihk.fsf@toke.dk> <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
 <2656681.1610542679@warthog.procyon.org.uk> <87sg6yqich.fsf@toke.dk>
 <YEi1RgPgwfT7qHQM@kroah.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 15 Mar 2021 11:52:52 +0100
Message-ID: <87czw0pu2j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Mon, Jan 18, 2021 at 06:13:02PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> David Howells <dhowells@redhat.com> writes:
>>=20
>> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> >
>> >> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>=20
>> >> and also, if you like:
>> >>=20
>> >> Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >
>> > Thanks!
>>=20
>> Any chance of that patch getting into -stable anytime soon? Would be
>> nice to have working WiFi without having to compile my own kernels ;)
>
> What ever happened to this patch?  I can't seem to find it in Linus's
> tree anywhere :(

This was a matter of crossed streams: Tianjia had already submitted an
identical fix, which went in as:

7178a107f5ea ("X.509: Fix crash caused by NULL pointer")

And that has made it into -stable, so all is well as far as I'm
concerned. Sorry for the confusion!

-Toke


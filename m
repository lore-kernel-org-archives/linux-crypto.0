Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FB7C433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 11:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 169AC233E2
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 11:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbhAMLax (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 06:30:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727049AbhAMLaw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 06:30:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610537366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RBvUo/6vjpBKP0pLeQRwuVWC4Mf8TIQXAT6GH3pLh/A=;
        b=Oa5dnnd7Kq7MCfMY8Nv0Vg/1QPTSNSQDSjfDoUq/UM6NlZ04lP4monn+nAAgGTH5dJDLx/
        A0Z8xxXjvT+OJgzS6fcTCCWx+l+iKbSaikZEMsLumU+1zB4loZAtSj/9P9AMVCiavcuHPC
        GwNXKbyoDcUDoeqmjILbp6JDmVR/x7U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-NG3TLWA1MyK0u1ntAUr5rA-1; Wed, 13 Jan 2021 06:29:24 -0500
X-MC-Unique: NG3TLWA1MyK0u1ntAUr5rA-1
Received: by mail-ej1-f70.google.com with SMTP id j14so617131eja.15
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2021 03:29:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RBvUo/6vjpBKP0pLeQRwuVWC4Mf8TIQXAT6GH3pLh/A=;
        b=oesBbUAl4UYegp/bsDv5L1peXl1t5F5FA7KgXS6O7Ypy+60mQVtoi515wJUTMR9Guy
         xcpMnstUqWeq0k9qZ/vFiI9Svpu7p0oZoyfbVBr+1eGRhyp6oHNZwznvbmW3uBQ+5HNc
         sB3H1a4i3ry7X0HsxxUdSG4TpWUscSk8F0MLRm8nEnTBqRq9D63PMj+Mt0jDf9rbAl69
         DHadxJSObJy0/JUbgOFCDz2itsBuNaD8fDBK3DFMhIvV3r2lmcoD9o+VIsPw/hT+3sYU
         XjGnOoTF/ISIUsrZzvovffjhGa+ZPOp/3F9RgH4Ztnl7vLOywVLvVwZfyg9+AE1dL+zI
         n9rQ==
X-Gm-Message-State: AOAM532c2VzpWxh6fT6H8MIaGwrseC2Ls2+SgJlwAnDOlYAlJDEa4OLA
        Fv7oDE4cnbEGecZDbVsLS2ebpGVESx4OBiCd5nqR5TIrhLZqV8iQnxKNiqVfA+ugT03nC9cDF/K
        BLqECR1+aiWzTHi6gmvIg/vRL
X-Received: by 2002:a17:906:c10e:: with SMTP id do14mr1293943ejc.166.1610537362770;
        Wed, 13 Jan 2021 03:29:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwV0UhPTkqnfz0zhus4V2pdERz5D9Xe87p960xLKFrM1TiE4FX3YbkCxBmnvrwbXxFrSOjddA==
X-Received: by 2002:a17:906:c10e:: with SMTP id do14mr1293933ejc.166.1610537362623;
        Wed, 13 Jan 2021 03:29:22 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y22sm588794ejj.111.2021.01.13.03.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 03:29:22 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ACE1618032B; Wed, 13 Jan 2021 12:29:20 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
In-Reply-To: <d7a50628-5559-a054-bc47-2d45746eb503@linux.alibaba.com>
References: <20210112161044.3101-1-toke@redhat.com>
 <d7a50628-5559-a054-bc47-2d45746eb503@linux.alibaba.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 13 Jan 2021 12:29:20 +0100
Message-ID: <878s8x9isv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:

> Hi,
>
> I have fixed this problem last week. Still thanks for your fixing.
> patch is here: https://lkml.org/lkml/2021/1/7/201

Ah, awesome! I did look if this had already been fixed, but your patch
wasn't in the crypto tree and didn't think to go perusing the mailing
lists. So sorry for the duplicate, and thanks for fixing this :)

-Toke


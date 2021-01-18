Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34FFC433E9
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 17:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C10B22CB1
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 17:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406892AbhARRS0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jan 2021 12:18:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393356AbhARROj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jan 2021 12:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610989986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ZQuQssCdyTqykXxuhtozSB36nIfhI3yRHQhSeUcS84=;
        b=K6WXDgurZghRXQ7MrESFGjXrReE3Ly7AX8B4qeG+grgzRwQvGTg5jfPY2vyyULbxHmiHwG
        lW5DMiF1c7zwW6hzYarhkF52K76vJ+c9nHXhw3I9Ezj6AUBQKVBUgDjW4ooMGG//WvPhIJ
        3TajJ4YiASuODdceRduVBOa9Hb66t6c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-MS9MY7kBOqGwacIYjZZaXg-1; Mon, 18 Jan 2021 12:13:05 -0500
X-MC-Unique: MS9MY7kBOqGwacIYjZZaXg-1
Received: by mail-ed1-f71.google.com with SMTP id x13so8141447edi.7
        for <linux-crypto@vger.kernel.org>; Mon, 18 Jan 2021 09:13:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+ZQuQssCdyTqykXxuhtozSB36nIfhI3yRHQhSeUcS84=;
        b=V8PfkMmYxinSkCrfWoY/wEsSlpJav4hIAPz4s8IjAH/iDs9W6pHC/Fe7LK8lxM92ax
         0/dUOLRq2o/aULWTVH2tcsVbLqheg6S2SAo4LU3Qv6C2WGkgdUcbXwMAyrHaKA5+shvW
         3wrJugMcqn/MYPDBCCrrFXKMBsQ6iQ8L/FckzPuPWKIrVEx1ZImGSdnS25B5sCXiUX8H
         5PHblnemwMYKpOiP3/d9/3h3brHmmnJNUNfLEW2uA6pcy6txdXTpz8GgsjEayBN9d6Rd
         WgkAu9I9cAiaVohzsgDqcHCekK3N1AHaDFNTXgnGv4QCPS8SdELJe4Ar0VxFbORd4v/B
         JFjg==
X-Gm-Message-State: AOAM532t6fxOesAlUOi2+HVakLrvArErf6NqBYeJyk62ZsikMEAkv72R
        4XyItStLUJ0s3t8ef8ygTybmA2LaLWll/Hzldvez2YpHJySz2mU23c610lmaK1puAiGYRByaxet
        9RN6HYFhBrm8RmzCxPQX6w+Gn
X-Received: by 2002:a50:fb96:: with SMTP id e22mr373244edq.118.1610989983826;
        Mon, 18 Jan 2021 09:13:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyw+tzOHSRfMLYBvN8RcGuoU8mSHIyg/cLq/STtApXB2+U3/ywmrncMYnUa7zAfdo91piVF/A==
X-Received: by 2002:a50:fb96:: with SMTP id e22mr373234edq.118.1610989983647;
        Mon, 18 Jan 2021 09:13:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x6sm8092178ejw.69.2021.01.18.09.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 09:13:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9E8E718032D; Mon, 18 Jan 2021 18:13:02 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
In-Reply-To: <2656681.1610542679@warthog.procyon.org.uk>
References: <875z419ihk.fsf@toke.dk> <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
 <2656681.1610542679@warthog.procyon.org.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 Jan 2021 18:13:02 +0100
Message-ID: <87sg6yqich.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
>> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> and also, if you like:
>>=20
>> Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Thanks!

Any chance of that patch getting into -stable anytime soon? Would be
nice to have working WiFi without having to compile my own kernels ;)

-Toke


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A022BC433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 11:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D763233F7
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 11:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbhAMLhi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 06:37:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728272AbhAMLhh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 06:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610537771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQcSb6CyS4Rcj5w1L4KFo4VX77Uj3QkqX6PSofKeGPI=;
        b=FevGkXsNuJvSV0XZ71icVHZMER0FsTiOoaCgJ5v3jm157yIowC0VCGjNCCbos/NvOCqCie
        j82nrJhZ9i6KPqrzpxAUdNXjKYCFFSaP52Z8iwUtyQm5hGFZkdX+o4SkB8l9yj9JAGyx7W
        QGRBlaGs2HouzRr2AQbqHUT5qz5RD/I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-qMw66yCFOyi4LNGe5lO7nw-1; Wed, 13 Jan 2021 06:36:09 -0500
X-MC-Unique: qMw66yCFOyi4LNGe5lO7nw-1
Received: by mail-wm1-f70.google.com with SMTP id f18so707141wmq.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2021 03:36:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pQcSb6CyS4Rcj5w1L4KFo4VX77Uj3QkqX6PSofKeGPI=;
        b=AhsCvQto/FWYyGdMAtZzkG/1ynTisNIS66acU3qoVe1ytxZRt7jLY3Vj9Bk1uLlHZf
         qzVX8UTgd+m19REaQYSI1tPOelMs+yDV3Q4fP8t9apl/DH6NddOz6FdTQBnOTRT3nxzH
         ekjjTyVbsZxxaB3gw7svf2xCPNEWSv+TvoG7aX7onkZbhnJ4mAT8IZkP6TMyCUAFI7yE
         K54CF28UlndRupnSLnBMd/SsY36C06peZz6w/rPAJI/7EnfKh3F6lbiVsvOPk4Nh5TgJ
         8PIs3yWPMfRAyI/Aq8iLhPG8uFd9QJXeDHe7xwH1Bl+/sxc0t1BG25Wl0duHh8XpkYUQ
         qIhQ==
X-Gm-Message-State: AOAM5331st9n55RN4soVb58n7lj8aHnEWBAimXmF9sTNcO1iauPL6uet
        30Sb+kEerWOFygwu+9sc/i8kzj9d17/NwGXc7GSQhyHdqgzkHMmKXqdH1hZC8a2QkugeeUNyiP3
        dODDVg6rkFrk9Pmviyys2Vpv3
X-Received: by 2002:a1c:a5d4:: with SMTP id o203mr1795405wme.41.1610537768794;
        Wed, 13 Jan 2021 03:36:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxS14vUOEEQ/bzWnoAQ2ltyWpCLjwA+Z3r9kH8HEWajdFCUX904JSU013CXi5oc1xfSAEvgHA==
X-Received: by 2002:a1c:a5d4:: with SMTP id o203mr1795384wme.41.1610537768581;
        Wed, 13 Jan 2021 03:36:08 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r20sm2460567wmh.15.2021.01.13.03.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 03:36:08 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A504C18032B; Wed, 13 Jan 2021 12:36:07 +0100 (CET)
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
In-Reply-To: <2648795.1610536273@warthog.procyon.org.uk>
References: <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 13 Jan 2021 12:36:07 +0100
Message-ID: <875z419ihk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> I'm intending to use Tianjia's patch.

Yeah, sorry for missing that.

> Would you like to add a Reviewed-by?

Sure:

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

and also, if you like:

Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


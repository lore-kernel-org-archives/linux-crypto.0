Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3391C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 07:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbiBJHXw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 02:23:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiBJHXv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 02:23:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBFF0262
        for <linux-crypto@vger.kernel.org>; Wed,  9 Feb 2022 23:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644477828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ceq+h6pyLcJE8lDQD7/Uv89e7ZbHt+Awtz79f2IG+wA=;
        b=EFzGOpweFAYm3D/PDthofmGf6Y1dIiTZ2gl40UZAVq3p0Q4cZRSZgips8Ruj6cS93EUPEd
        vShIEXzETchtInL3VAO+JEnO21NHF5rY6gF0UzTomwXQZgePVvF+SU2Q71GFqQSgBVlQzm
        YLG4o+lk07M54ZrY82cwzUDpxThuKPs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-3hsc00uBOd2cbfftwBywPw-1; Thu, 10 Feb 2022 02:23:47 -0500
X-MC-Unique: 3hsc00uBOd2cbfftwBywPw-1
Received: by mail-ed1-f71.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso2801904edt.20
        for <linux-crypto@vger.kernel.org>; Wed, 09 Feb 2022 23:23:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ceq+h6pyLcJE8lDQD7/Uv89e7ZbHt+Awtz79f2IG+wA=;
        b=rY10gBIBgHxJ5fV8b2URONdXr6rosTKJ3hSuzM0ejr7D7ksiRo15VjbyDhNNeieFKq
         bfHKZRX6QslrIicR2625zVSv8/j49wVwUJhn+6eBMkC74Z3otzPWruKkn1qtOFQuylUA
         Jkj4eZZFTYlJQf6warpW9XyXpcTUiVyL0WyWD7Es9B9G59YSfrdiZ+BgYtB6WzB0++1Y
         0rFSL5NMsx8tqCQrIko4Mu+jjl3aISnGJp9esRL5vNjDIEYz4JLTEFtbTlYNAdgXR3QY
         7H+GI5taM5OacDSClE/xrjjzYpNtb73vNK6IhXJjS322/uEmQpMtgdkd7GANNJ5LmOWu
         KChg==
X-Gm-Message-State: AOAM5319PmdgaEpG2d8Sl2chF63pBKU3Smo/9ui8qnHDq3s7Rq1OImml
        Yyx2Kh/odfYOZe04IEV2qxzoAOm8eOUQrN0s7Nh3IFeJlBCJDAA5/9IJg0qdvYL2ZeLLHGdZ3E/
        fNqxsNFklJ6N7XfztxEUkguPO
X-Received: by 2002:a05:6402:b1c:: with SMTP id bm28mr6857037edb.299.1644477826395;
        Wed, 09 Feb 2022 23:23:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyM9Av3U8CMtb+HUyYhDNUnlTEKQRuxt6w5X3ri0rXAfJGknuvg3b7lxz4SCGRkGFPZ++zLiA==
X-Received: by 2002:a05:6402:b1c:: with SMTP id bm28mr6857028edb.299.1644477826241;
        Wed, 09 Feb 2022 23:23:46 -0800 (PST)
Received: from redhat.com ([2.55.139.162])
        by smtp.gmail.com with ESMTPSA id ck9sm3667076edb.61.2022.02.09.23.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 23:23:45 -0800 (PST)
Date:   Thu, 10 Feb 2022 02:23:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        helei.sig11@bytedance.com
Subject: Re: PING: [PATCH 0/3] Introduce akcipher service for virtio-crypto
Message-ID: <20220210022221-mutt-send-email-mst@kernel.org>
References: <20220121022438.1042547-1-pizhenwei@bytedance.com>
 <9d07cc9d-b3f1-6fc9-eca1-6124f7baf7e0@bytedance.com>
 <CACGkMEsxnFU5TnPGxU3TjFG6MWZhtCyu93f2qzeAq08ce6VJ_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEsxnFU5TnPGxU3TjFG6MWZhtCyu93f2qzeAq08ce6VJ_g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 03:17:38PM +0800, Jason Wang wrote:
> On Thu, Feb 10, 2022 at 2:58 PM zhenwei pi <pizhenwei@bytedance.com> wrote:
> >
> > PING!
> 
> I think it would be helpful to get ack/reviewing from crypto gurus.

For sure, but with the robot warning some people might just assume
there's a problem and wait for the next version to review.
Just post v2, don't forget the changelog.

> Maybe Herbert?
> 
> Thanks
> 
> >
> > PS: Please ignore the warning from kernel test robot, I'll fix it in
> > next version.
> >
> > On 1/21/22 10:24 AM, zhenwei pi wrote:
> > > Introduce akcipher service, implement RSA algorithm, and a minor fix.
> > >
> > > zhenwei pi (3):
> > >    virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
> > >    virtio-crypto: introduce akcipher service
> > >    virtio-crypto: implement RSA algorithm
> > >
> > >   drivers/crypto/virtio/Makefile                |   1 +
> > >   .../virtio/virtio_crypto_akcipher_algo.c      | 584 ++++++++++++++++++
> > >   drivers/crypto/virtio/virtio_crypto_common.h  |   3 +
> > >   drivers/crypto/virtio/virtio_crypto_core.c    |   6 +-
> > >   drivers/crypto/virtio/virtio_crypto_mgr.c     |  11 +
> > >   include/uapi/linux/virtio_crypto.h            |  98 ++-
> > >   6 files changed, 693 insertions(+), 10 deletions(-)
> > >   create mode 100644 drivers/crypto/virtio/virtio_crypto_akcipher_algo.c
> > >
> >
> > --
> > zhenwei pi
> >


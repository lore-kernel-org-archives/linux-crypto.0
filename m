Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D851C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 07:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbiBJHRy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 02:17:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiBJHRy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 02:17:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 210C21E1
        for <linux-crypto@vger.kernel.org>; Wed,  9 Feb 2022 23:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644477473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sTTuT1wpA5V7YCk5otpnqf5l5jYPgeufibvl+UEqn2c=;
        b=ZOxG36gyBnKuGxgtSWrGn7to9do5WTBhQCXpeDzxCc5GeJaMhsUgIzp0mXhL9AL62xNG1Y
        +Au9r/0fa6suYe/u5quKYwAqNTOXoGWDi3ZWQwWLWhpushXLllodPSrH547tkO+9q8JH+C
        HBO0S4+HVMECK3vzqprArbBLhxn/4yM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-2v7RmlUWMUOEThrg1YjFag-1; Thu, 10 Feb 2022 02:17:51 -0500
X-MC-Unique: 2v7RmlUWMUOEThrg1YjFag-1
Received: by mail-lf1-f71.google.com with SMTP id i28-20020a056512007c00b00437f0f6da15so1121660lfo.16
        for <linux-crypto@vger.kernel.org>; Wed, 09 Feb 2022 23:17:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sTTuT1wpA5V7YCk5otpnqf5l5jYPgeufibvl+UEqn2c=;
        b=NJbWNA0DHxE9x8D6VO741hQ4M53rgzx18xp27Bh4bOMugo50G/1aF3vKsyFla15fhY
         7wO0eMwTZZOkMDIyv0ZWqmUHbnHEfsLBs8YFJr7DhmJ1tMWcQveTtPTYCEA/pYDZECgA
         sVu7IeMFOadhN9WFY06jcS1ZFw2mXGmRvwxyd2Y5gOSYlj7qjWn+ztGH5JzK8aH+EKmA
         OKburHY4WukP33XptbrF3iGibA1QFC/7QfnPBYkposSo8G2h3x8XLOaTq37g10mMe4bK
         i9MjmYkW4/EzJI972dEskRJC0H731zW4O3cMicXUOYryxuLJd5oauzKJs3vRS6fNY5wL
         6pXg==
X-Gm-Message-State: AOAM532N6sYv7syDLNLwFhjoQUUKpNeLvkdrFi1fLu5sDcqSs1XrX+lR
        VOHqGBHsrDZSFqkiwEP8SGLr/k9KRrknLHOCUcZO4OhiWx6bndzyUjo3hWZ8lNq4ICyCOK9TrS2
        k8imTCM2gIRRG1KAhUq8wD5zLbWHqLKMJ3gJBzUfI
X-Received: by 2002:a05:6512:3401:: with SMTP id i1mr4335988lfr.629.1644477469720;
        Wed, 09 Feb 2022 23:17:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxUZBEMHIZcF/XRpUs2UnPvBf2bdlBn1YAVjX3H39EwXxKO5k6jiLG/IEtXn0SyNmkzAr6Jv4pBMsj4aeyw8JM=
X-Received: by 2002:a05:6512:3401:: with SMTP id i1mr4335979lfr.629.1644477469533;
 Wed, 09 Feb 2022 23:17:49 -0800 (PST)
MIME-Version: 1.0
References: <20220121022438.1042547-1-pizhenwei@bytedance.com> <9d07cc9d-b3f1-6fc9-eca1-6124f7baf7e0@bytedance.com>
In-Reply-To: <9d07cc9d-b3f1-6fc9-eca1-6124f7baf7e0@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Feb 2022 15:17:38 +0800
Message-ID: <CACGkMEsxnFU5TnPGxU3TjFG6MWZhtCyu93f2qzeAq08ce6VJ_g@mail.gmail.com>
Subject: Re: PING: [PATCH 0/3] Introduce akcipher service for virtio-crypto
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst <mst@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        helei.sig11@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 2:58 PM zhenwei pi <pizhenwei@bytedance.com> wrote:
>
> PING!

I think it would be helpful to get ack/reviewing from crypto gurus.
Maybe Herbert?

Thanks

>
> PS: Please ignore the warning from kernel test robot, I'll fix it in
> next version.
>
> On 1/21/22 10:24 AM, zhenwei pi wrote:
> > Introduce akcipher service, implement RSA algorithm, and a minor fix.
> >
> > zhenwei pi (3):
> >    virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
> >    virtio-crypto: introduce akcipher service
> >    virtio-crypto: implement RSA algorithm
> >
> >   drivers/crypto/virtio/Makefile                |   1 +
> >   .../virtio/virtio_crypto_akcipher_algo.c      | 584 ++++++++++++++++++
> >   drivers/crypto/virtio/virtio_crypto_common.h  |   3 +
> >   drivers/crypto/virtio/virtio_crypto_core.c    |   6 +-
> >   drivers/crypto/virtio/virtio_crypto_mgr.c     |  11 +
> >   include/uapi/linux/virtio_crypto.h            |  98 ++-
> >   6 files changed, 693 insertions(+), 10 deletions(-)
> >   create mode 100644 drivers/crypto/virtio/virtio_crypto_akcipher_algo.c
> >
>
> --
> zhenwei pi
>


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB73C43334
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jun 2022 04:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiFHEp3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jun 2022 00:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiFHEpA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jun 2022 00:45:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A1D213F90B
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 19:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654655750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K4gannku3cD3bDCFoY39hZ+ipBpvR06huyXSqGOx7GQ=;
        b=eW1vAERXGyx4xCnFdf7cnwbawxDm/EzWRcNOAkO1PCfGV6d7RGXiBiz/1wQSM4awpKNCah
        tE8IKuOAwZqf9c6jHXMFY8fJNGi8Lt7IMKXbIsmh3CzJ+nnGsoYCcImFAimjFdt0PONwJN
        ysBJ1sRNIsnnoOtlbF6rMq6lkBaONRk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-vk6ImfN2Mr-yMTfkh5rvEA-1; Tue, 07 Jun 2022 22:35:48 -0400
X-MC-Unique: vk6ImfN2Mr-yMTfkh5rvEA-1
Received: by mail-lf1-f71.google.com with SMTP id e13-20020a19674d000000b0047944c80861so3544943lfj.19
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2022 19:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K4gannku3cD3bDCFoY39hZ+ipBpvR06huyXSqGOx7GQ=;
        b=oOQi3D7sNmwKKDeVrI8rHHGWhk6qvxhadK6sLRR2QvSNgy+KpXsGmC7Siti4gkvwbx
         im/X6YRmNptXhHZX59SKzCmvFc7iFO1vHq2Rk4jPxMExxPI77+gYbudMXzVO1HDa4fwg
         xZ4OTIEBE0mnK6amH8/UzVIOz+UhQTqYYJWEr+aV843eTM91VmcUpAnynMvw/IYNgKNu
         5aHfW1kIO18i/xNALOpWO+sg/9vPm7ncN2n4W7TvYiDsq6x0VWGP2B6Sps7V62KMhw6E
         i/8zkklMkXuDh9qVkmuIdUdebRSLwSfuFibmV7TiJDxTkA135YvJsYDSLsURdhYcx0tt
         s/bw==
X-Gm-Message-State: AOAM532tzWJCUc5Zjvxde16/uKNWfrF80ApeLGfpyDXpPlkoUaULyX9r
        TyppAI6QT1G8HnbYllmxVxbmR1GM7XOPQ0m4ICcBB/0yjmCsHGiXfJExQVHU156R95CFhDB+cqx
        LLWqpn0MPn245JJsGD4QRjziVeLtwx4Xl3D5qDIpq
X-Received: by 2002:a05:6512:3130:b0:479:385f:e2ac with SMTP id p16-20020a056512313000b00479385fe2acmr10282600lfd.575.1654655747453;
        Tue, 07 Jun 2022 19:35:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6PTdL2iQbnlRkFFk3B+toTiehZhE3ZjEV06tKErjTWBkqxnS3ACVhG1QE08Nfywp1LEi9aACvUeNgRUIS7EQ=
X-Received: by 2002:a05:6512:3130:b0:479:385f:e2ac with SMTP id
 p16-20020a056512313000b00479385fe2acmr10282595lfd.575.1654655747247; Tue, 07
 Jun 2022 19:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <CACGkMEseR-vDzgei21jftC8Grm0Not+e1XEefyLgV8C4yfWOHQ@mail.gmail.com>
 <000000000000a09fc105e0e5bedb@google.com>
In-Reply-To: <000000000000a09fc105e0e5bedb@google.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 8 Jun 2022 10:35:36 +0800
Message-ID: <CACGkMEt_e59wRotUo9D1UqubAhe+txy0GF=r1BYBVdND8-uKbA@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in add_early_randomness (2)
To:     syzbot <syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux@dominikbrodowski.net, mpm@selenic.com, mst <mst@redhat.com>,
        syzkaller-bugs@googlegroups.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 8, 2022 at 9:37 AM syzbot
<syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: task hung in add_early_randomness
>

Ok, looking at virtio-rng.c, probe_common() tries to kick the
virtqueue before DRIVER_OK which is kind of violates the spec.

Please test the following patch:

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next

diff --git a/drivers/char/hw_random/virtio-rng.c
b/drivers/char/hw_random/virtio-rng.c
index e856df7e285c..a6f3a8a2aca6 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -159,6 +159,8 @@ static int probe_common(struct virtio_device *vdev)
                goto err_find;
        }

+       virtio_device_ready(vdev);
+
        /* we always have a pending entropy request */
        request_entropy(vi);


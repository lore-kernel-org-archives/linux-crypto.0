Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5758AC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jun 2022 05:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiFHFW0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jun 2022 01:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiFHFVf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jun 2022 01:21:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 667E0271A92
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 19:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654656616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hoU/O6w4YUxRgQevDzGWElcceiZ5d1yaMFWFpbdwK/w=;
        b=I0BQ566MC2XU/6BQF7zKJZY0U8Xsk73Vc4ZZ8Bf+vXzVxHXy2qYi6BgvgVR397k4umlbrA
        YSc930TE8D4d9kZrCxL1mAmmPH/8UGkUjtCpLvd3H+3yiMy5GY/Tk/jtFl5iVPL/McbCQj
        U2Ct37V9XS4yqCW38cZfyQSwOCRPaG8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-z9t6CCb8PZSr8GAd5IKMlg-1; Tue, 07 Jun 2022 22:50:15 -0400
X-MC-Unique: z9t6CCb8PZSr8GAd5IKMlg-1
Received: by mail-lj1-f199.google.com with SMTP id b26-20020a2e989a000000b002556f92fa13so3295219ljj.15
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2022 19:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hoU/O6w4YUxRgQevDzGWElcceiZ5d1yaMFWFpbdwK/w=;
        b=XxjltycrI4UD3QJ33mCKH9wia4FDMBLcsCllnZ8FuMYBewx49zUAiRtqYG+vUg4WN+
         KLyMhvVGKciyh9E8uQvVVfBN8Q/FKAhbxB7pNRENkClLVkaDpeqbzAwz0LTfTndb9+sU
         RhdsIQbLIQlf/GdiP2K50MIKEdy1Q2FDhOWD9qXG1sZEunsJ2AYGHsZPCZBRKAdKy0S5
         s9jqc80Exki5pZYHZ6Ys3f0Y7iLChN97FHLDgG6pqu4Yo4zwgG2JQfTxfdrsw5SCpgIB
         GMO3td041x9jmQq0ENT1fFe1tBJ32nkZY+gUg+Bryi9U+dOz/JNQEDP7TQfpkAi9Kz5m
         S4qA==
X-Gm-Message-State: AOAM531zbkTjtq5H4NAZEfS4QlSiIXHnrZT/Q/qguqL0S2czR58t4gqz
        eIdlm90ISYGoE+5o8Tqhq7Jn3+824sG6+SCZ+xCTQrRvUEkFuiYFCsGRe/eDpwdRUBn3skAamLH
        HQuGxS+KNuYBhiU98KhBSRsWnIYpnwH3b+StDBgpy
X-Received: by 2002:a05:6512:3130:b0:479:385f:e2ac with SMTP id p16-20020a056512313000b00479385fe2acmr10304383lfd.575.1654656613667;
        Tue, 07 Jun 2022 19:50:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/wfYs6HkHvDClc0YAeZNLik8QgxxmOJ07fcWIYgWskZhjMfRl7qmsfjJQ28CN49VdSzGUpv/CZ6BO3tueZYs=
X-Received: by 2002:a05:6512:3130:b0:479:385f:e2ac with SMTP id
 p16-20020a056512313000b00479385fe2acmr10304377lfd.575.1654656613505; Tue, 07
 Jun 2022 19:50:13 -0700 (PDT)
MIME-Version: 1.0
References: <CACGkMEt_e59wRotUo9D1UqubAhe+txy0GF=r1BYBVdND8-uKbA@mail.gmail.com>
 <0000000000002cccbd05e0e69570@google.com>
In-Reply-To: <0000000000002cccbd05e0e69570@google.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 8 Jun 2022 10:50:02 +0800
Message-ID: <CACGkMEvtV+hVdpgpkYvAmkRteYDN+2dDacrfXsYDv0ZzjJU+ag@mail.gmail.com>
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

On Wed, Jun 8, 2022 at 10:37 AM syzbot
<syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot tried to test the proposed patch but the build/boot failed:
>
> failed to apply patch:
> checking file drivers/char/hw_random/virtio-rng.c
> patch: **** unexpected end of file in patch
>

Copy-paste error :(

Let's try this:

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

--


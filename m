Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A57C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jun 2022 04:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiFHEJf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jun 2022 00:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiFHEIz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jun 2022 00:08:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCBBC2A3BB0
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 18:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654651361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6uwkiRGsYZn8rUtF99I2UJq3400horEmj+dim7FwiyM=;
        b=acMKBvvz1HrFa/Q0/DP9uBCTzTAc+jEy/LQzlLXTixmxr1fNMtvk3CFsDWc0zGgEyQx09Q
        6KDrssiFOECjfoFJRNzXi0E8D1UGdHSzjcunISVSIcfy19oCspt8DdJNcrOhjTYsWebE8c
        36yQiJ8hYqxOINukzko4IMHz8LIFhJM=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-0zD-dsEAOmWx9cqQTdN3SQ-1; Tue, 07 Jun 2022 21:19:19 -0400
X-MC-Unique: 0zD-dsEAOmWx9cqQTdN3SQ-1
Received: by mail-lf1-f69.google.com with SMTP id l12-20020a056512110c00b0047961681d22so2124149lfg.9
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2022 18:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6uwkiRGsYZn8rUtF99I2UJq3400horEmj+dim7FwiyM=;
        b=tvjM2yNh7RofCEGqfpS0FtYdak/Lt+OZ2PZsZGUkWPQ28Bb3Qgw3qknWRKujqYqniH
         Gelo+Cp50cZ48rLOyugHqhLqZShDbsPvvpgsA9drwS2fdggurrveBxfJAWpgnhVXHUIm
         J4bU0JGw7/Ql6LFL02haRYnocwVvbiOPg9DHLPd5VafOWJ5CwodAtTzmnGyabdg0l+yc
         Yfh4rxOODFzXzwrMUvEGhkt/DJZUX/4jyoslNdZk4UsESPtiHZnWxNDQC+smhJseVktY
         XrZSYs7B/xDpdBxXvcCkOpisakfPbnSdrkE6huzj8fFVmC6i8iFQZTyWcEgt5gwZJnhB
         G7Zg==
X-Gm-Message-State: AOAM532iWrENV918tmZ+iHownloO2XMYbybHkbxJUDLd+FQE6JOUPSOY
        EcPCPtZ/QZqjX1D/w+6QnhvXkjgS9lf57KzHvl//HPsMuo+xayQjP2ZdMRPBqim6TGvjgLIA4Zc
        gUQ1x1TZI6g3wz7a4lOYi/pIz0Ma2pF3dhu3z+2/q
X-Received: by 2002:a05:651c:895:b0:250:c5ec:bc89 with SMTP id d21-20020a05651c089500b00250c5ecbc89mr57507909ljq.251.1654651157681;
        Tue, 07 Jun 2022 18:19:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOsQZO8WTdRosM8N+3sCyKwgo0XMifS1CU9yfTXKIjvXJR7jQ7t9P2C5sIUJE5kpOxTYWK3qcWS0ZUMKz4EYo=
X-Received: by 2002:a05:651c:895:b0:250:c5ec:bc89 with SMTP id
 d21-20020a05651c089500b00250c5ecbc89mr57507894ljq.251.1654651157415; Tue, 07
 Jun 2022 18:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fc128605e08585c6@google.com> <00000000000068486805e0d68f94@google.com>
 <CACGkMEvCmtmfBSDeq1psgW4+MTymfs_T-EFQx=2UdXfy1vWDiw@mail.gmail.com> <20220607063908-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220607063908-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 8 Jun 2022 09:19:06 +0800
Message-ID: <CACGkMEseR-vDzgei21jftC8Grm0Not+e1XEefyLgV8C4yfWOHQ@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in add_early_randomness (2)
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     syzbot <syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux@dominikbrodowski.net, mpm@selenic.com,
        syzkaller-bugs@googlegroups.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 7, 2022 at 6:54 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jun 07, 2022 at 05:05:41PM +0800, Jason Wang wrote:
> > On Tue, Jun 7, 2022 at 3:30 PM syzbot
> > <syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has bisected this issue to:
> > >
> > > commit 8b4ec69d7e098a7ddf832e1e7840de53ed474c77
> > > Author: Jason Wang <jasowang@redhat.com>
> > > Date:   Fri May 27 06:01:19 2022 +0000
> > >
> > >     virtio: harden vring IRQ
> > >
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1175c3c7f00000
> > > start commit:   f2906aa86338 Linux 5.19-rc1
> > > git tree:       upstream
> > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=1375c3c7f00000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1575c3c7f00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=cbd131cc02ee620e
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=5b59d6d459306a556f54
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104f4d4ff00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d6782df00000
> > >
> > > Reported-by: syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com
> > > Fixes: 8b4ec69d7e09 ("virtio: harden vring IRQ")
> > >
> > > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > >
> >
> > I wonder if it's related to shared IRQ.
> >
> > Want to know if the attached patch works.
> >
> > Thanks
>
> Please, post patches inline.
> In this case I don't see the printk in the console.
>

Ok, let's try this:

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 13a7348cedff..1af55e576505 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2137,7 +2137,7 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
        if (unlikely(vq->broken)) {
                dev_warn_once(&vq->vq.vdev->dev,
                              "virtio vring IRQ raised before DRIVER_OK");
-               return IRQ_NONE;
+               return IRQ_HANDLED;
        }

        /* Just a hint for performance: so it's ok that this can be racy! */


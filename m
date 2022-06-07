Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AC3C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jun 2022 10:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242249AbiFGK6o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jun 2022 06:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242332AbiFGK6S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jun 2022 06:58:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22394BCE8A
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 03:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654599239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TNzwBB7ZZPSH1ON+WNEP8BayJieoALczPxALrkpLXG8=;
        b=OXCtOKRsAzM05QGeWptnyX+kHfYGvEP0nLZqeFNG65W4dO/cE6eYdD1JtVwGijTvtVFeS/
        fygm3BX3JA9BPjVtIm8oUitmQiz0Ywbacp7flWJXaAieATmpnnLPss9pYxHhEY/dFij50X
        /QCcAqvrQ5pbcXcYDVH6758Gc2ULIb4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-54SjLBMRNmmenxFQRy4wJQ-1; Tue, 07 Jun 2022 06:53:56 -0400
X-MC-Unique: 54SjLBMRNmmenxFQRy4wJQ-1
Received: by mail-wr1-f69.google.com with SMTP id d9-20020adfe849000000b00213375a746aso3265972wrn.18
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2022 03:53:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TNzwBB7ZZPSH1ON+WNEP8BayJieoALczPxALrkpLXG8=;
        b=eBgOp5EZW1VQP17r+jia+zBhwCPdHCxdXtFLQ9Ip1hzwtwCtxI25UVL0B8aH6WOhrs
         Qmkmj/r8+g4SUz8qS1pZfQxbXnlS8xR980OadLcamyLmxrd/J2qcR6VwCPE51g9rOpwY
         4lPtGjk7A7r3WNUYA3Tj80d1StSjYFx44C80tXsRz3yZz8yP4Y0mV5M3zLw+WxeTecz8
         1CESfsFV6p2GSx7u0RhWY0AMGbrgcmIPr3WtrcqjoRJwM+mn+n6jqpyUfdRTr9q/fYuu
         o8E2ba7CoxfAdRlMsfRxUsmq7g1dONUxOl88U1THCOOPYUDTGT4Le2kDVPNmsSfy2Ofb
         /7ww==
X-Gm-Message-State: AOAM532odfRHXTKQubDg8TLgGleIacHW0wF17HtVTxCPdIvoQPlzaJQk
        WbV7e1ziuK3ztA2tikLZQVKEB+HgrcLlApm/MM+IeGWrxqLhGoeauDwCU7Ns+o51klBt9D9jS8z
        iLiE1eLp3Z+qJCw9Dajs7qeQW
X-Received: by 2002:a05:600c:3c91:b0:39b:6b:d5de with SMTP id bg17-20020a05600c3c9100b0039b006bd5demr45872568wmb.132.1654599235357;
        Tue, 07 Jun 2022 03:53:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzK5yzKOuJeouwPfQtcbHMdqzqb6HbES3Z0zDNMHRBbEzDy7YqCTRKXRqBSIdxKatWDeYG4A==
X-Received: by 2002:a05:600c:3c91:b0:39b:6b:d5de with SMTP id bg17-20020a05600c3c9100b0039b006bd5demr45872550wmb.132.1654599235142;
        Tue, 07 Jun 2022 03:53:55 -0700 (PDT)
Received: from redhat.com ([2.55.169.1])
        by smtp.gmail.com with ESMTPSA id l10-20020a5d410a000000b0020fc6590a12sm17187136wrp.41.2022.06.07.03.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 03:53:54 -0700 (PDT)
Date:   Tue, 7 Jun 2022 06:53:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     syzbot <syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux@dominikbrodowski.net, mpm@selenic.com,
        syzkaller-bugs@googlegroups.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, yuehaibing@huawei.com
Subject: Re: [syzbot] INFO: task hung in add_early_randomness (2)
Message-ID: <20220607063908-mutt-send-email-mst@kernel.org>
References: <000000000000fc128605e08585c6@google.com>
 <00000000000068486805e0d68f94@google.com>
 <CACGkMEvCmtmfBSDeq1psgW4+MTymfs_T-EFQx=2UdXfy1vWDiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvCmtmfBSDeq1psgW4+MTymfs_T-EFQx=2UdXfy1vWDiw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 07, 2022 at 05:05:41PM +0800, Jason Wang wrote:
> On Tue, Jun 7, 2022 at 3:30 PM syzbot
> <syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has bisected this issue to:
> >
> > commit 8b4ec69d7e098a7ddf832e1e7840de53ed474c77
> > Author: Jason Wang <jasowang@redhat.com>
> > Date:   Fri May 27 06:01:19 2022 +0000
> >
> >     virtio: harden vring IRQ
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1175c3c7f00000
> > start commit:   f2906aa86338 Linux 5.19-rc1
> > git tree:       upstream
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=1375c3c7f00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1575c3c7f00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=cbd131cc02ee620e
> > dashboard link: https://syzkaller.appspot.com/bug?extid=5b59d6d459306a556f54
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104f4d4ff00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d6782df00000
> >
> > Reported-by: syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com
> > Fixes: 8b4ec69d7e09 ("virtio: harden vring IRQ")
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> >
> 
> I wonder if it's related to shared IRQ.
> 
> Want to know if the attached patch works.
> 
> Thanks

Please, post patches inline.
In this case I don't see the printk in the console.


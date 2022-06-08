Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0275C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jun 2022 06:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiFHGx7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354213AbiFHGT1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jun 2022 02:19:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6E2123BEA
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 23:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654668441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=btPsJ5x7niNmjEjOGerzCn59AIO0rvNFat3C8BRTa+c=;
        b=M1yKatjL4ofZDIJIpJ3HLHwPphPykOspk6R9Zo/f+h0xf0bzWha39DOE2iuVQLGGoCSnRS
        cum3NAEkS4wJlg5/oQO/8U0kOev4d09flV4QSUx70Y+VvRBdmTejhkr5fM2pHHYikuE6mV
        TM1wzoAVnLNu9D3QQXOOuHP3y1zZ7fM=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-qlALEXmmNq-h1iIARFSN_A-1; Wed, 08 Jun 2022 02:07:19 -0400
X-MC-Unique: qlALEXmmNq-h1iIARFSN_A-1
Received: by mail-lf1-f69.google.com with SMTP id p36-20020a05651213a400b004779d806c13so9833986lfa.10
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2022 23:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=btPsJ5x7niNmjEjOGerzCn59AIO0rvNFat3C8BRTa+c=;
        b=gdTJzX7NNAVXtBfrsKWWJch2cFBrx9p0Rg2jMO//6Mn5b6SC0+IjDRDqlliekaDxsw
         vQ246X5gkCl+iC9BDKwjAFbIDcsHwW1G8w1fq04IKUT0xdMANMoal9RzHEw27PoXaMWC
         wtC/78QpvgarFlIhhV5KCr4PA5pQ2G/af20UclxNoM+XxfUezDEZ2sB2BaYpd/n/m4Rq
         rFzrjVCGrpSjWw/NkdLt9kUndjTnDvhcwF4VM3etPa7MckAiWW8P/T1P8jxIstNkC24R
         6Y2AuYg+Fw4N6pXDqU78P1uqzj/+kl0vN2kCmmbY8HNyivpQzcLm0EIfFfQev/2srmjy
         gV7A==
X-Gm-Message-State: AOAM531IYIOZw84yAHNX2i77e8FBvyygrI6xscVug0xQzp0BXcspWOhh
        yjfieaEaphZWxfC4E6Q3N3U0wossOzvud5jdquPCoKR2xb7R0ZI/vZzb7NHWCv0UqmXhAoFJE5C
        nTU2B4og06xhfJH0hGKXM1TfvlL/qfm2nuxX/oI83
X-Received: by 2002:a2e:bc05:0:b0:24b:212d:7521 with SMTP id b5-20020a2ebc05000000b0024b212d7521mr54409486ljf.243.1654668437628;
        Tue, 07 Jun 2022 23:07:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4UR8Bopi8bBvbC6iJ/qjLlWKuBEd8b7c2mUsEsz3iehoCWZh44Tb08CL360aRmFvrNFEl9Zn9DxVhXaP5YUE=
X-Received: by 2002:a2e:bc05:0:b0:24b:212d:7521 with SMTP id
 b5-20020a2ebc05000000b0024b212d7521mr54409469ljf.243.1654668437408; Tue, 07
 Jun 2022 23:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <CACGkMEus=RMMcDk+sM8X14=AtFjK+-3p_Lo=O6tfv9H=0wXENw@mail.gmail.com>
 <000000000000d5113205e0e71c8f@google.com>
In-Reply-To: <000000000000d5113205e0e71c8f@google.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 8 Jun 2022 14:07:06 +0800
Message-ID: <CACGkMEtQPxaEbZmEYj9vtUbCAaW+X4_nZW0tyC4RDG1OJKJooQ@mail.gmail.com>
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

On Wed, Jun 8, 2022 at 11:15 AM syzbot
<syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>
> Reported-and-tested-by: syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com
>
> Tested on:
>
> commit:         bd8bb9ae vdpa: ifcvf: set pci driver data in probe
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8d4cbb773055caee
> dashboard link: https://syzkaller.appspot.com/bug?extid=5b59d6d459306a556f54
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=1731eaf7f00000
>
> Note: testing is done by a robot and is best-effort only.
>

Cool, let me post a formal patch.

Thanks


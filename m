Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0485EC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 07:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D53DA6109E
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 07:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbhJ0HWk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 03:22:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240429AbhJ0HWg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 03:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635319211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+DbhW314EmWGlap+YeCS5cDQceQCNE6F+RMcBvYpSBk=;
        b=gL/f8+I3t/GzJiN3Xfc8hz/F/D7/KGmIJ2bT+Ql5lkH7ddz4us/mHS5G3wrpHsEnLnr8iw
        GJGeD8RLIfTt/63lbzcqu5huHC+s3wrCAuf1vFDLb1W/Rd3MtAzdQt8BzbiuBKHte4Vb+U
        xP9jN9b9H2RLeisBVid0ibzPYziiOgo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-lQWKM5O9Pw2DcjyOdSuOWA-1; Wed, 27 Oct 2021 03:20:09 -0400
X-MC-Unique: lQWKM5O9Pw2DcjyOdSuOWA-1
Received: by mail-ed1-f72.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so1450809edv.10
        for <linux-crypto@vger.kernel.org>; Wed, 27 Oct 2021 00:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+DbhW314EmWGlap+YeCS5cDQceQCNE6F+RMcBvYpSBk=;
        b=tmUDTtoPnUOGvi0qSmwqzGs6Lr2V20J4MEEEbNOs71vn2YMEU9gRNF7vmyT/4Nlm3P
         Eww0OLbZmID1zxXOK9ehX0fGSZ2JtOxhhiz4SEc4Zt6+WIGangdqRlNbq+zdgJP/f6bV
         xro2Lb7hYM6zobCsRiSw513zyWDb+Cb9t4ffNYD4TDX+inPBTQQUNDWBvM1L++TLoqej
         BIS3ttaePJeRiTBMP9Fnkj/Yu0oOh9w+GA9DHRhrYb490yTTXri0v6MvPvtvR4b0QnNj
         mG82qSaeN4+6ZJO12vV+XEIc+EEueIgkGl54L/Qi3h+KgUYoZwn4tWU5JzU0TH6YmZ3d
         bSWw==
X-Gm-Message-State: AOAM532h7K/6KCMLkoGi4N6aniE7kx5kTd4UfJVhbEO0x+TeLZykjOkm
        fQy9XviIHV9j5gm/IeATBs+QNiAe9O3aK1HIZIS6/K2S1kyXKXIXjSB8VkC7+ds+dv/yPnA0gjV
        YzoSj3ngdepkK3mPR6XaKLZef
X-Received: by 2002:a17:906:4f8c:: with SMTP id o12mr36638846eju.115.1635319208801;
        Wed, 27 Oct 2021 00:20:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCIQAlR+x1uvtXUAqxKjm8vS6/c+bMTwwJhi3bbhlIT3AboUf6m65iBGZdjxqc9u2af1k2tw==
X-Received: by 2002:a17:906:4f8c:: with SMTP id o12mr36638822eju.115.1635319208614;
        Wed, 27 Oct 2021 00:20:08 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:a543:72f:c4d1:8911:6346])
        by smtp.gmail.com with ESMTPSA id e13sm10143344eje.95.2021.10.27.00.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 00:20:08 -0700 (PDT)
Date:   Wed, 27 Oct 2021 03:20:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
Message-ID: <20211027031847-mutt-send-email-mst@kernel.org>
References: <000000000000a4cd2105cf441e76@google.com>
 <b6d96f08-78df-cf34-5e58-572b3fd4b566@gmail.com>
 <6c7e48b9-5204-352f-18e7-26b13d70f966@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c7e48b9-5204-352f-18e7-26b13d70f966@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 27, 2021 at 09:08:04AM +0200, Laurent Vivier wrote:
> On 27/10/2021 00:34, Eric Dumazet wrote:
> > 
> > 
> > On 10/26/21 9:39 AM, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following issue on:
> > > 
> > > HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
> > > 
> > > The issue was bisected to:
> > > 
> > > commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
> > > Author: Leon Romanovsky <leonro@nvidia.com>
> > > Date:   Thu Oct 21 14:16:14 2021 +0000
> > > 
> > >      devlink: Remove not-executed trap policer notifications
> > 
> > More likely this came with
> > 
> > caaf2874ba27b92bca6f0298bf88bad94067ec37 hwrng: virtio - don't waste entropy
> > 
> 
> I'm going to have a look.
> 
> Thanks,
> Laurent

How bad is it if we just drop this and waste some bytes of entropy?

-- 
MST


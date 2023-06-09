Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0083CC7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 14:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjFIOGD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 10:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjFIOGC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 10:06:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA8F1BC6;
        Fri,  9 Jun 2023 07:06:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4E0965847;
        Fri,  9 Jun 2023 14:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DE9C433D2;
        Fri,  9 Jun 2023 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1686319560;
        bh=kgO/2c+NjKZyd1iafWHrG8i9N2lcKWxvnLxiKEZHcSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vNr7hdLCTjdv+lb2+2bCz4KNEEQE5RmUFO5PbsMtBT8H2HIcsXYBO2yM/9F9Z2p6/
         skSGokOV3XQInW2ZGGlBV+KxWCR2Vw4Uyg3cyriHxIXjgA49ZhucK1ZJ0VPCMGGzeS
         hHJqu9C8XrumksEs6l06A2a92jJQzlea8JD6aFVk=
Date:   Fri, 9 Jun 2023 16:05:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, amit@kernel.org, arnd@arndb.de,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <tianxianting.txt@alibaba-inc.com>
Subject: Re: [PATCH 1/3] virtio-crypto: fixup potential cpu stall when free
 unused bufs
Message-ID: <2023060924-onion-armhole-803e@gregkh>
References: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
 <20230609131817.712867-2-xianting.tian@linux.alibaba.com>
 <2023060924-skinning-reset-e256@gregkh>
 <2023060940-wrongdoer-wince-5701@gregkh>
 <91aa6ce0-e8a3-21ac-d29e-b2a47f6386d1@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91aa6ce0-e8a3-21ac-d29e-b2a47f6386d1@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 09, 2023 at 09:49:39PM +0800, Xianting Tian wrote:
> 
> 在 2023/6/9 下午9:41, Greg KH 写道:
> > On Fri, Jun 09, 2023 at 03:39:24PM +0200, Greg KH wrote:
> > > On Fri, Jun 09, 2023 at 09:18:15PM +0800, Xianting Tian wrote:
> > > > From: Xianting Tian <tianxianting.txt@alibaba-inc.com>
> > > > 
> > > > Cpu stall issue may happen if device is configured with multi queues
> > > > and large queue depth, so fix it.
> > > > 
> > > > Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> > > > ---
> > > >   drivers/crypto/virtio/virtio_crypto_core.c | 1 +
> > > >   1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> > > > index 1198bd306365..94849fa3bd74 100644
> > > > --- a/drivers/crypto/virtio/virtio_crypto_core.c
> > > > +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> > > > @@ -480,6 +480,7 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
> > > >   			kfree(vc_req->req_data);
> > > >   			kfree(vc_req->sgs);
> > > >   		}
> > > > +		cond_resched();
> > > that's not "fixing a stall", it is "call the scheduler because we are
> > > taking too long".  The CPU isn't stalled at all, just busy.
> > > 
> > > Are you sure this isn't just a bug in the code?  Why is this code taking
> > > so long that you have to force the scheduler to run?  This is almost
> > > always a sign that something else needs to be fixed instead.
> > And same comment on the other 2 patches, please fix this properly.
> > 
> > Also, this is a tight loop that is just freeing memory, why is it taking
> > so long?  Why do you want it to take longer (which is what you are doing
> > here), ideally it would be faster, not slower, so you are now slowing
> > down the system overall with this patchset, right?
> 
> yes, it is the similar fix with one for virtio-net
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/virtio_net.c?h=v6.4-rc5&id=f8bb5104394560e29017c25bcade4c6b7aabd108 <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/virtio_net.c?h=v6.4-rc5&id=f8bb5104394560e29017c25bcade4c6b7aabd108>

I would argue that this too is incorrect, because why does freeing
memory take so long?  And again, you are making it take longer, is that
ok?

thanks,

greg k-h

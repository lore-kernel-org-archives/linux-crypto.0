Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F002C7EE2E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 16:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjFIQDg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 12:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242043AbjFIQDf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 12:03:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25EE30D6
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 09:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686326569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bDPqvNvCKDaRoxVabZXpCEaO3eFktyKlsug6+VBWhkY=;
        b=BGSw7a49uwoT9nD7F0vGLR0yntGuBwyze6VgUUkkltVbSRAWnwq7i6gajfOXRSvWoVEAx+
        265azM7pa8x6En3VnsWuMipfv+3TIRjtawrzNaFzSqav7eLun/bH3WXHvdc2KdAxacxLgQ
        CGTu78N2Rgi3We3TN/49UWJxS56kPL8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-xqWomrh4OSGDW-oJJAojyw-1; Fri, 09 Jun 2023 12:02:42 -0400
X-MC-Unique: xqWomrh4OSGDW-oJJAojyw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f611d31577so13443105e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jun 2023 09:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686326561; x=1688918561;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bDPqvNvCKDaRoxVabZXpCEaO3eFktyKlsug6+VBWhkY=;
        b=coZo+zkLltkLeTJ/j/+k/jAaryulfWVsnzGX1AQ3U5FxVD6GJoOI5JN0EKg03UwU8S
         RKi22psD5N9Bi58kXF8eJyDK6tBJLQcptpKHfmQh1z3YvVncwGUOpR1hy1vtGSZipuuV
         KVUcGBLFqVGXeW8E+UZnX1zsmKKAAhr+9JAOnQg3ifxl0kt1nONJoIfy5hcfPqfYLWuR
         HmHkLn+4gG7kKqPdzk81lqulDBaiEEB4Ab77EbmKigsdFJsoMvmXly+OnVTPgH1ok5Ib
         hq6ifefbWNJTcNh/V22Nsnd9MD/7EOBtQdUVVL8yEE90aUQebYxUzJsPUM9P92D2pWLe
         WDog==
X-Gm-Message-State: AC+VfDycoW3Hb9OIG2iIaWoXCd3QG9h8Snm/aBd5f6/ZgtgCg5rHDZ4L
        wJ2vYav1kwN7mkw819dpIgZ8Ba2gqrZLLpHHwEyhgwnR0U6B8jYsYwxttjFWu3VgtqyGDoLcnYG
        P6ozHlchOc9TmNJJRrWsXIEqT
X-Received: by 2002:a05:600c:2041:b0:3f6:1b7:11f0 with SMTP id p1-20020a05600c204100b003f601b711f0mr1872766wmg.7.1686326560748;
        Fri, 09 Jun 2023 09:02:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6+cTGEsumPbrhQKIm8DZ1NuiAlUbhAlNIbDxc4Q5231NUq4aWWlHrRMiiaodCaJ/J+lriS5Q==
X-Received: by 2002:a05:600c:2041:b0:3f6:1b7:11f0 with SMTP id p1-20020a05600c204100b003f601b711f0mr1872735wmg.7.1686326560330;
        Fri, 09 Jun 2023 09:02:40 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7403:2800:22a6:7656:500:4dab])
        by smtp.gmail.com with ESMTPSA id f16-20020a1c6a10000000b003f60fb2addbsm3062327wmc.44.2023.06.09.09.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 09:02:39 -0700 (PDT)
Date:   Fri, 9 Jun 2023 12:02:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        arei.gonglei@huawei.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, amit@kernel.org, arnd@arndb.de,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <tianxianting.txt@alibaba-inc.com>
Subject: Re: [PATCH 1/3] virtio-crypto: fixup potential cpu stall when free
 unused bufs
Message-ID: <20230609115840-mutt-send-email-mst@kernel.org>
References: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
 <20230609131817.712867-2-xianting.tian@linux.alibaba.com>
 <2023060924-skinning-reset-e256@gregkh>
 <2023060940-wrongdoer-wince-5701@gregkh>
 <91aa6ce0-e8a3-21ac-d29e-b2a47f6386d1@linux.alibaba.com>
 <2023060924-onion-armhole-803e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023060924-onion-armhole-803e@gregkh>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 09, 2023 at 04:05:57PM +0200, Greg KH wrote:
> On Fri, Jun 09, 2023 at 09:49:39PM +0800, Xianting Tian wrote:
> > 
> > 在 2023/6/9 下午9:41, Greg KH 写道:
> > > On Fri, Jun 09, 2023 at 03:39:24PM +0200, Greg KH wrote:
> > > > On Fri, Jun 09, 2023 at 09:18:15PM +0800, Xianting Tian wrote:
> > > > > From: Xianting Tian <tianxianting.txt@alibaba-inc.com>
> > > > > 
> > > > > Cpu stall issue may happen if device is configured with multi queues
> > > > > and large queue depth, so fix it.
> > > > > 
> > > > > Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> > > > > ---
> > > > >   drivers/crypto/virtio/virtio_crypto_core.c | 1 +
> > > > >   1 file changed, 1 insertion(+)
> > > > > 
> > > > > diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> > > > > index 1198bd306365..94849fa3bd74 100644
> > > > > --- a/drivers/crypto/virtio/virtio_crypto_core.c
> > > > > +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> > > > > @@ -480,6 +480,7 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
> > > > >   			kfree(vc_req->req_data);
> > > > >   			kfree(vc_req->sgs);
> > > > >   		}
> > > > > +		cond_resched();
> > > > that's not "fixing a stall", it is "call the scheduler because we are
> > > > taking too long".  The CPU isn't stalled at all, just busy.
> > > > 
> > > > Are you sure this isn't just a bug in the code?  Why is this code taking
> > > > so long that you have to force the scheduler to run?  This is almost
> > > > always a sign that something else needs to be fixed instead.
> > > And same comment on the other 2 patches, please fix this properly.
> > > 
> > > Also, this is a tight loop that is just freeing memory, why is it taking
> > > so long?  Why do you want it to take longer (which is what you are doing
> > > here), ideally it would be faster, not slower, so you are now slowing
> > > down the system overall with this patchset, right?
> > 
> > yes, it is the similar fix with one for virtio-net
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/virtio_net.c?h=v6.4-rc5&id=f8bb5104394560e29017c25bcade4c6b7aabd108 <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/virtio_net.c?h=v6.4-rc5&id=f8bb5104394560e29017c25bcade4c6b7aabd108>

Well that one actually at least describes the configuration:


	For multi-queue and large ring-size use case, the following error
	occurred when free_unused_bufs:
	rcu: INFO: rcu_sched self-detected stall on CPU.

So a similar fix but not a similar commit log, this one lacks Fixes tag and
description of what the problem is and when does it trigger.

> I would argue that this too is incorrect, because why does freeing
> memory take so long?

You are correct that even that one lacks detailed explanation
why does the patch help.

And the explanation why it takes so long is exactly that
we have very deep queues and a very large number of queues.
What the patch does is gives scheduler a chance
to do some work between the queues.





>  And again, you are making it take longer, is that
> ok?
> 
> thanks,
> 
> greg k-h


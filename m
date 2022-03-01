Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCA4C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Mar 2022 19:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbiCATbh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Mar 2022 14:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbiCATbg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Mar 2022 14:31:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2142252E23
        for <linux-crypto@vger.kernel.org>; Tue,  1 Mar 2022 11:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646163054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rVYpDZQDb15Izn1lzcbcKE0MfzfOugZfslLcf4XgvGM=;
        b=hMeWnDq+no7L2xJe3xTPuoqqt3DArmQ+G5dQPXWP5J6r/PQtYoMAhDMHqmpwty8IFfekFJ
        jUiB3yWZkNmxwDUmPX67JfttoPC/uEQKo38qFZGU9geebS/BFukYO70OQYaDC8e0EYUZvr
        qVGlU23KIuCKWlNOKi8rh73AtwfkyTY=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-c7B_4w19NCSpIgPdAm5O_A-1; Tue, 01 Mar 2022 14:30:53 -0500
X-MC-Unique: c7B_4w19NCSpIgPdAm5O_A-1
Received: by mail-oo1-f69.google.com with SMTP id b10-20020a4a340a000000b0031937d5a5efso10987300ooa.15
        for <linux-crypto@vger.kernel.org>; Tue, 01 Mar 2022 11:30:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rVYpDZQDb15Izn1lzcbcKE0MfzfOugZfslLcf4XgvGM=;
        b=u7qcglJVsdYiYAeZMOIhCwaYVFvdzbcHe0X5tdyQJnaNjr7+C3YvaUnQWVbPg0dRpd
         0aaEV2+J+axbmzX+YPIiCjFo4NamcOSBF9xdD31OrJiYmFxC7Gh3zkBA/jh9j0WgYpqx
         lDZaQoi34HeuUlbop2+E8kchOC/T+Xt4tkUYgMvpJGb6ov6iWLLfOm++zrvo0K8HhoPl
         n5wQ+pBSVt3NAj3ySPSv+pIwz40I2aJWwg4SW38L+Cm8bX0rcvzRz63EtUf9Qr49hhpb
         7Di1aXb5eR5C5syDHpywQTNiEq3zknqvVFnglb+hAh/3b7bN7pifREqWxN3O6KJAJ3EC
         4fnA==
X-Gm-Message-State: AOAM532ud82xNRdalSnuQr7wFTF0VrKELtboqqivAW8ZmaFiJ2STvBKA
        lsFA5pOnD+omd6lJMGwWImwktq/9JC2P9NQ6T84b7FKuWSmMvtgsk8HzDTxN05S0yQ/B4fZpYmK
        ZGQDVRQ/HFNO9PDC1gzRHJl/c
X-Received: by 2002:a05:6830:19c3:b0:5af:451a:c030 with SMTP id p3-20020a05683019c300b005af451ac030mr13071174otp.286.1646163051372;
        Tue, 01 Mar 2022 11:30:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaF5m1Erd0R+xb0TZC3q6x+BbKcLz2naWnbTQTKf1pIDI8DHgroVSZtRv1ObZHIAudTnp4WQ==
X-Received: by 2002:a05:6830:19c3:b0:5af:451a:c030 with SMTP id p3-20020a05683019c300b005af451ac030mr13071154otp.286.1646163051083;
        Tue, 01 Mar 2022 11:30:51 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a10-20020a9d74ca000000b005af640e9377sm6767132otl.17.2022.03.01.11.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:30:50 -0800 (PST)
Date:   Tue, 1 Mar 2022 12:30:47 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220301123047.1171c730.alex.williamson@redhat.com>
In-Reply-To: <20220301131528.GW219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
        <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
        <20220228145731.GH219866@nvidia.com>
        <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
        <20220228180520.GO219866@nvidia.com>
        <20220228131614.27ad37dc.alex.williamson@redhat.com>
        <20220228202919.GP219866@nvidia.com>
        <20220228142034.024e7be6.alex.williamson@redhat.com>
        <20220228234709.GV219866@nvidia.com>
        <20220228214110.4deb551f.alex.williamson@redhat.com>
        <20220301131528.GW219866@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 1 Mar 2022 09:15:28 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 28, 2022 at 09:41:10PM -0700, Alex Williamson wrote:
> 
> > > + * returning readable. ENOMSG may not be returned in STOP_COPY. Support
> > > + * for this ioctl is required when VFIO_MIGRATION_PRE_COPY is set.  
> > 
> > This entire ioctl on the data_fd seems a bit strange given the previous
> > fuss about how difficult it is for a driver to estimate their migration
> > data size.  Now drivers are forced to provide those estimates even if
> > they only intend to use PRE_COPY as an early compatibility test?  
> 
> Well, yes. PRE_COPY is designed to be general, not just to serve for
> compatability. Qemu needs data to understand how the internal dirty
> accumulation in the device is progressing. So everything has to
> provide estimates, and at least for acc this is trivial.

But we're not really even living up to that expectation of dirty bytes
with acc afaict.  We're giving QEMU some initial data it can have
early, but it looks like the latest proposal hard codes dirty-bytes to
zero, so QEMU doesn't gain any insight into dirty accumulation, nor
does it know that the field is invalid.

Wouldn't it make more sense if initial-bytes started at QM_MATCH_SIZE
and dirty-bytes was always sizeof(vf_data) - QM_MATCH_SIZE?  ie. QEMU
would know that it has sizeof(vf_data) - QM_MATCH_SIZE remaining even
while it's getting ENOMSG after reading QM_MATCH_SIZE bytes of data.

> > Obviously it's trivial for the acc driver that doesn't support dirty
> > tracking and only has a fixed size migration structure, but it seems to
> > contradict your earlier statements.   
> 
> mlx5 knows exactly this data size once it completes entering
> STOP_COPY, it has a migf->total_size just like acc, so no problem to
> generate this ioctl. We just don't have a use case for it and qemu
> would never call it, so trying not to add dead things to the kernel.
> 
> Are you are talking about the prior discussion about getting this data
> before reaching STOP_COPY?

That would be the ideal scenario, but again if knowing this information
once we're in STOP_COPY continues to be useful, which I infer by the
ongoing operation of this ioctl, then why don't we switch to an ioctl
that just reports bytes-remaining at that point rather than trying to
fit the square peg in the round hole to contort a STOP_COPY data
representation into initial-bytes and dirty-bytes?  If that's not
useful yet and you don't want to add dead kernel code, then let's
define that this ioctl is only available in the PRE_COPY* states and
returns -errno in the STOP_COPY state.

> > For instance, can mlx5 implement a PRE_COPY solely for compatibility
> > testing or is it blocked by an inability to provide data estimates
> > for this ioctl?  
> 
> I expect it can, it works very similar to acc. It just doesn't match
> where we are planning for compatability. mlx5 has a more dynamic
> compatability requirement, it needs to be exposed to orchestration not
> hidden in pre_copy. acc looks like it is static, so 'have acc' is
> enough info for orchestration.
> 
> > Now if we propose that this ioctl is useful during the STOP_COPY phase,
> > how does a non-PRE_COPY driver opt-in to that beneficial use case?    
> 
> Just implement it - userspace will learn if the driver supports it on
> the first ioctl = ENOTTY means no support.
> 
> > Do we later add a different, optional ioctl for non-PRE_COPY and
> > then require userspace to support two different methods of getting
> > remaining data estimates for a device in STOP_COPY?  
> 
> I wouldn't add a new ioctl unless we discover a new requirement when
> an implementation is made.

So let's define that this ioctl is only valid in PRE_COPY* states and
return -errno in STOP_COPY so that we have consistency between all
devices in STOP_COPY and let's also define if there's actually anything
userspace can infer about remaining STOP_COPY data size while in
PRE_COPY* via this ioctl.  For example, is dirty-bytes zero or the
remaining data structure size?

...
> > I'm sure that raises questions about how we correlate a
> > PRE_COPY* session to a STOP_COPY session though, but this PRE_COPY*
> > specific but ongoing usage in STOP_COPY ioctl seems ad-hoc.  
> 
> I do not think it is "pre_copy specific" - the ioctl returns the
> estimated length of the data_fd, this is always a valid concept.

Yes, some sort of remaining-bytes is always a valid concept.  Splitting
that into initial-bytes and dirty-bytes doesn't make any sense at
STOP_COPY though.  If there's no use case for this ioctl in STOP_COPY
and the partitioning of data exposed in PRE_COPY* mode is fundamentally
specific to pre-copy support, why not disable the ioctl with the
intention to replace it with a common one specific to STOP_COPY once
there's a userspace use case?  Thanks,

Alex


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE53C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Mar 2022 22:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbiCAWpS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Mar 2022 17:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiCAWpR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Mar 2022 17:45:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23A9077AB2
        for <linux-crypto@vger.kernel.org>; Tue,  1 Mar 2022 14:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646174675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGMUuYb5facBAKE4BWWQblYiu2u5yGmxdG+wUrk0CNE=;
        b=QE6ihr3CP258wFsjkLnbYa1utwikrCAGijbYu7t2DBuzLARRX13Xru4nr3ea0quegsTnyQ
        HDRR2+Hj7yPoJsjC7mgOPtqbz576g356VWHnzfdf/6tCeH8FeUJvgG1cBfTe4BrmSrVN0d
        MRKuxXntQsrGvUgtHuWoQOvcpRrAj2M=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-Ds1Cb_x3MmC2KpOlB3b7Ow-1; Tue, 01 Mar 2022 17:44:34 -0500
X-MC-Unique: Ds1Cb_x3MmC2KpOlB3b7Ow-1
Received: by mail-oo1-f69.google.com with SMTP id c82-20020a4a4f55000000b0031be4c923d3so11309819oob.16
        for <linux-crypto@vger.kernel.org>; Tue, 01 Mar 2022 14:44:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mGMUuYb5facBAKE4BWWQblYiu2u5yGmxdG+wUrk0CNE=;
        b=me1zlhgbdfdOwTUVTeQDL/QYOaHYF+7CNr1pJk7YG6p7gzI6PP0bJ8tZEPATrhBNkO
         NuSEio7Iojc5VWk+IKX9nBX8vwLzoOp7HeIhFwuh/oVhsDEfeY3nt68h2nANmwOjmkDY
         SKAWpPJIrrj3MwKm9C3xXwaY+M+cpSI1j0hvmsAQSM0JN00UN3+qW9H+c0JDuSyohcNr
         OUCwgZGgSIsjmI3MrNYU2Mz7YU3ujTWOjMezxNS37GkX+Wf5+192hmSSmh0h9qqtfiLG
         aNKR9U+68e/v/vWS7zRSCZTZfaO1dMTetdeH7+43Adl+k5zU5nmQYINSHfHsGU4+vYOx
         qA8A==
X-Gm-Message-State: AOAM531SYRVRV63ITZcam4ymxrlM0zWa2yj8H49V+6PsXXTVRidwVKPc
        aP2N3HABEd94l+nIXsh32Mj+su1zwbTpF/SLI7QX5+UG6etRBNa4b09l4W3jsRgLwZ29gH084Ym
        OXFTA/b5+F+R9nCgQTgx32BX/
X-Received: by 2002:a05:6870:65a0:b0:d7:547:3c0b with SMTP id fp32-20020a05687065a000b000d705473c0bmr10477963oab.79.1646174673370;
        Tue, 01 Mar 2022 14:44:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0+uzXIFvxXkkhsLvg5Psp36LJMpZFA1kLIP23iFYOblelNGSikei+BKT4/FUoBnmsURZE9Q==
X-Received: by 2002:a05:6870:65a0:b0:d7:547:3c0b with SMTP id fp32-20020a05687065a000b000d705473c0bmr10477943oab.79.1646174673084;
        Tue, 01 Mar 2022 14:44:33 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f10-20020a9d5e8a000000b0059fa2fa9b4bsm6918556otl.13.2022.03.01.14.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 14:44:32 -0800 (PST)
Date:   Tue, 1 Mar 2022 15:44:31 -0700
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
Message-ID: <20220301154431.42b27278.alex.williamson@redhat.com>
In-Reply-To: <20220301203938.GY219866@nvidia.com>
References: <20220228145731.GH219866@nvidia.com>
        <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
        <20220228180520.GO219866@nvidia.com>
        <20220228131614.27ad37dc.alex.williamson@redhat.com>
        <20220228202919.GP219866@nvidia.com>
        <20220228142034.024e7be6.alex.williamson@redhat.com>
        <20220228234709.GV219866@nvidia.com>
        <20220228214110.4deb551f.alex.williamson@redhat.com>
        <20220301131528.GW219866@nvidia.com>
        <20220301123047.1171c730.alex.williamson@redhat.com>
        <20220301203938.GY219866@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 1 Mar 2022 16:39:38 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 01, 2022 at 12:30:47PM -0700, Alex Williamson wrote:
> > Wouldn't it make more sense if initial-bytes started at QM_MATCH_SIZE
> > and dirty-bytes was always sizeof(vf_data) - QM_MATCH_SIZE?  ie. QEMU
> > would know that it has sizeof(vf_data) - QM_MATCH_SIZE remaining even
> > while it's getting ENOMSG after reading QM_MATCH_SIZE bytes of data.  
> 
> The purpose of this ioctl is to help userspace guess when moving on to
> STOP_COPY is a good idea ie when the device has done almost all the
> work it is going to be able to do in PRE_COPY. ENOMSG is a similar
> indicator.
> 
> I expect all devices to have some additional STOP_COPY trailer_data in
> addition to their PRE_COPY initial_data and dirty_data
> 
> There is a choice to make if we report the trailer_data during
> PRE_COPY or not. As this is all estimates, it doesn't matter unless
> the trailer_data is very big.
> 
> Having all devices trend toward a 0 dirty_bytes to say they are are
> done all the pre-copy they can do makes sense from an API
> perspective. If one device trends toward 10MB due to a big
> trailer_data and one trends toward 0 bytes, how will qemu consistently
> decide when best to trigger STOP_COPY? It makes the API less useful.
>
> So, I would not include trailer_data in the dirty_bytes.

That assumes that it's possible to keep up with the device dirty rate.
It seems like a better approach for userspace would be to look at how
dirty_bytes is trending.  A zero value and a steady state value are
equivalent, there's nothing more to be gained by further iterations.  If
the value is trending down, it might be worthwhile to iterate in
PRE_COPY a while longer.  If the value is trending up, it might be time
to cut to STOP_COPY or abort the migration.

If we exclude STOP_COPY trailing data from the VFIO_DEVICE_MIG_PRECOPY
ioctl, it seems even more of a disconnect that when we enter the
STOP_COPY state, suddenly we start getting new data out of a PRECOPY
ioctl.

BTW, "VFIO_DEVICE" should be reserved for ioctls and data structures
relative to the device FD, appending it with _MIG is too subtle for me.
This is also a GET operation for INFO, so I'd think for consistency
with the existing vfio uAPI we'd name this something like
VFIO_MIG_GET_PRECOPY_INFO where the structure might be named
vfio_precopy_info.

> Estimating when to move on to STOP_COPY and trying to enforce a SLA on
> STOP_COPY are different tasks and will probably end up with different
> interfaces.
> 
> I still think the right way to approach the SLA is to inform the
> driver what the permitted time and data size target is for STOP_COPY
> and the driver can proceed or not based on its own internal
> calculation.

So if we don't think this is the right approach for STOP_COPY, then why
are we pushing that it has any purpose outside of PRECOPY or might be
implemented by a non-PRECOPY driver for use in STOP_COPY?
 
> > useful yet and you don't want to add dead kernel code, then let's
> > define that this ioctl is only available in the PRE_COPY* states and
> > returns -errno in the STOP_COPY state.  
> 
> I'm OK with that, in acc it is done by checking migf->total_bytes >
> QM_MATCH_SIZE during the read fop
> 
> > devices in STOP_COPY and let's also define if there's actually anything
> > userspace can infer about remaining STOP_COPY data size while in
> > PRE_COPY* via this ioctl.  For example, is dirty-bytes zero or the
> > remaining data structure size?  
> 
> If we keep it then I would say it doesn't matter, userspace has to sum
> the two values to get the total remaining length estimate, it is just
> a bit quirky.

For the reasons above, I just can't figure out why wouldn't decide that
use of this outside of PRECOPY is too quirky to bother with.  Thanks,

Alex


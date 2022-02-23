Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D24C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 16:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiBWQfQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Feb 2022 11:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242667AbiBWQfP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Feb 2022 11:35:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 180E350E0F
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 08:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645634087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nQ3OobjVOllFjF//341g+8FVMNuOOL65pOBy6n0VyaU=;
        b=Ejj2iU4cZ/2qtJPBUiHrCiWJ7Qm1ARp14iPAWckKRRG7uYyZ1RsXc6U3UlHe5mVi0wsEkm
        HmoivDhmm5y8UcYHjfUi/sS6Po1SYvd3KFL82ZaOx2ibrYGsYld9k6nvNhpHuQkRe6FPk9
        agdZKBpV80/o9Oohwkz8DCssXw99BQo=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-zmg8bS27N5yPPHufbecXOA-1; Wed, 23 Feb 2022 11:34:46 -0500
X-MC-Unique: zmg8bS27N5yPPHufbecXOA-1
Received: by mail-ot1-f72.google.com with SMTP id l23-20020a056830239700b005ad40210ca2so10612907ots.3
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 08:34:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nQ3OobjVOllFjF//341g+8FVMNuOOL65pOBy6n0VyaU=;
        b=rfkKyHA6BzbAf0W6MHTs4pl4WR92jqvKyTbTBWhCEoAqFzDNDwLNTI+ugBRRL3kRkl
         WND1cBN+tXYzEImBQyijuQyWnPfkieWMmcvpX3Xu4It5v7eSgYV+mL5bdPXB2tm6IYRJ
         G1iZ8Xy81vbCr+RHsoGLgED3wuD95/+1Eyyls0S0mYVLtEBRuxC1a8lmOgCQlZwhZPes
         HqzfWhZ6HYQdd3eLUXg0FFITmb7Dqc2j/2Vojr9lPa2b6QGOYyaTp4+7bBvtL6S0nEfD
         4SVOlWils0Qla05RW6eqdazQhALao5RVG/P3zPvNwfwcWnRp/OLv3ou/8zahw6Kf/2CE
         B6Og==
X-Gm-Message-State: AOAM530u7R3nBvJCl7YjYPY5Ls/DhbssfyFPHGTJsnAG0b0dxroPlpPH
        IrQx6CFiNJQwTElvXIcWVrSwMqvIA8+rftj6vrEqCYyoCagyrH/3/ib4aDwT2OMqZnSkmGahV8x
        XEVJryPGg+Quc8UvIwiBqNob0
X-Received: by 2002:a54:4085:0:b0:2d4:6f0b:f3b7 with SMTP id i5-20020a544085000000b002d46f0bf3b7mr258687oii.148.1645634085370;
        Wed, 23 Feb 2022 08:34:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaP/1ZvmMsLm7zZq6HfYZWjNtio48LTCUjFpR9oZZdGxGMhkpLSdC41ujeIjXVdKBnwi0P6A==
X-Received: by 2002:a54:4085:0:b0:2d4:6f0b:f3b7 with SMTP id i5-20020a544085000000b002d46f0bf3b7mr258680oii.148.1645634085157;
        Wed, 23 Feb 2022 08:34:45 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s9sm55235otg.6.2022.02.23.08.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 08:34:44 -0800 (PST)
Date:   Wed, 23 Feb 2022 09:34:43 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v5 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220223093443.367ee531.alex.williamson@redhat.com>
In-Reply-To: <20220223005251.GJ10061@nvidia.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
        <20220221114043.2030-8-shameerali.kolothum.thodi@huawei.com>
        <20220223005251.GJ10061@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 22 Feb 2022 20:52:51 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 21, 2022 at 11:40:42AM +0000, Shameer Kolothum wrote:
> 
> > +	/*
> > +	 * ACC VF dev BAR2 region consists of both functional register space
> > +	 * and migration control register space. For migration to work, we
> > +	 * need access to both. Hence, we map the entire BAR2 region here.
> > +	 * But from a security point of view, we restrict access to the
> > +	 * migration control space from Guest(Please see mmap/ioctl/read/write
> > +	 * override functions).
> > +	 *
> > +	 * Also the HiSilicon ACC VF devices supported by this driver on
> > +	 * HiSilicon hardware platforms are integrated end point devices
> > +	 * and has no capability to perform PCIe P2P.  
> 
> If that is the case why not implement the RUNNING_P2P as well as a
> NOP?
> 
> Alex expressed concerned about proliferation of non-P2P devices as it
> complicates qemu to support mixes

I read the above as more of a statement about isolation, ie. grouping.
Given that all DMA from the device is translated by the IOMMU, how is
it possible that a device can entirely lack p2p support, or even know
that the target address post-translation is to a peer device rather
than system memory.  If this is the case, it sounds like a restriction
of the SMMU not supporting translations that reflect back to the I/O
bus rather than a feature of the device itself.  Thanks,

Alex


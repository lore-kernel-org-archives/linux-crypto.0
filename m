Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBFAC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Mar 2022 19:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245174AbiCGTxl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Mar 2022 14:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245167AbiCGTxj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Mar 2022 14:53:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7231F37A3D
        for <linux-crypto@vger.kernel.org>; Mon,  7 Mar 2022 11:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646682762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iFbyRAhrzPJ35m4rXo3BdXpPkOXNFqEyv1VvtxCidZQ=;
        b=jFLimqnENX2TR+7bzNt1xhS0ld1VUPt32LUGqYqczLeNjdaICeGze6rUwK38LTwJjyBgfT
        ay21zHfYZnVIeQfOv6Zk/iCBlLlcfGyUPYN4vt+oJYLrcERlCN100+MDYLuIq8iadzq8nx
        uyIP0fG67YbHIWzNc+ZGZMfji4kzPbQ=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-uQt0zFLTNayY0ZC_tHKLpA-1; Mon, 07 Mar 2022 14:52:41 -0500
X-MC-Unique: uQt0zFLTNayY0ZC_tHKLpA-1
Received: by mail-ot1-f70.google.com with SMTP id q8-20020a056830232800b005ab75f5e906so13824373otg.18
        for <linux-crypto@vger.kernel.org>; Mon, 07 Mar 2022 11:52:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFbyRAhrzPJ35m4rXo3BdXpPkOXNFqEyv1VvtxCidZQ=;
        b=0BneIsUK5h32xj7AjItHFna5ZtHPbdSHosgYjkffCvRU2JlZ87mzShSvKydI0ZQ1PO
         heH0z9Kgw/j9tj+qJbc9MZchDp+9dsyKhLOiyO39Q8wal8X6aZZ1gbc2BysxWFUq1URQ
         z2EQnkoFXDL4+PCANDRrDZWatf3rPV3RBGO+qx0u7NJDFLGHQy389bcSk+ohOK/H88+3
         hr1ePTxV1kCwvHxtoKTlaVzCRhY5NyZrQxU+CmyY1/c2ck9F8NTA3cN8vD9/l2FHBh4l
         OhOx5gh7OgQeBrWnBmwXE+7lY9BEaf+vEpV6QOAA1mpCNHSbvSqONok8fsj1krfEJo4O
         N+hg==
X-Gm-Message-State: AOAM5318VgIrxfg6N7ZqB2+PwdkT+sGvHYY5j3cXRkipdd6LH2asPZ1s
        N1wtNUmBVZgT37MgUC8M3yYDUFsmbOKaTxMm5PWsGrK+SSRykitrKpWR0yRfBOQdnRygVZTxFv/
        8oF/SdckOfq5eI+JqnRbdBD0l
X-Received: by 2002:a05:6870:a986:b0:da:b3f:3277 with SMTP id ep6-20020a056870a98600b000da0b3f3277mr342137oab.295.1646682761031;
        Mon, 07 Mar 2022 11:52:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0o5c3OjTqpzOiX0FaElSIgrmfr2mM6c5nUGHrH+xd+UeH8aVo4Q4lHgUzzZO76/LqpgApLg==
X-Received: by 2002:a05:6870:a986:b0:da:b3f:3277 with SMTP id ep6-20020a056870a98600b000da0b3f3277mr342120oab.295.1646682760849;
        Mon, 07 Mar 2022 11:52:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u21-20020a056870951500b000d9b9ac69cdsm5373410oal.1.2022.03.07.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 11:52:40 -0800 (PST)
Date:   Mon, 7 Mar 2022 12:52:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220307125239.7261c97d.alex.williamson@redhat.com>
In-Reply-To: <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
        <20220304205720.GE219866@nvidia.com>
        <20220307120513.74743f17.alex.williamson@redhat.com>
        <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 7 Mar 2022 19:29:06 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: 07 March 2022 19:05
> > To: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> > kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org; cohuck@redhat.com;
> > mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> > <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> > <prime.zeng@hisilicon.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> > Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
> > migration
> > 
> > On Fri, 4 Mar 2022 16:57:20 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Thu, Mar 03, 2022 at 11:01:30PM +0000, Shameer Kolothum wrote:  
> > > > From: Longfang Liu <liulongfang@huawei.com>
> > > >
> > > > VMs assigned with HiSilicon ACC VF devices can now perform live  
> > migration  
> > > > if the VF devices are bind to the hisi_acc_vfio_pci driver.
> > > >
> > > > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > > > Signed-off-by: Shameer Kolothum  
> > <shameerali.kolothum.thodi@huawei.com>  
> > > > ---
> > > >  drivers/vfio/pci/hisilicon/Kconfig            |    7 +
> > > >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 1078 ++++++++++++++++-
> > > >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  114 ++
> > > >  3 files changed, 1181 insertions(+), 18 deletions(-)
> > > >  create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > > >
> > > > diff --git a/drivers/vfio/pci/hisilicon/Kconfig  
> > b/drivers/vfio/pci/hisilicon/Kconfig  
> > > > index dc723bad05c2..2a68d39f339f 100644
> > > > --- a/drivers/vfio/pci/hisilicon/Kconfig
> > > > +++ b/drivers/vfio/pci/hisilicon/Kconfig
> > > > @@ -3,6 +3,13 @@ config HISI_ACC_VFIO_PCI
> > > >  	tristate "VFIO PCI support for HiSilicon ACC devices"
> > > >  	depends on ARM64 || (COMPILE_TEST && 64BIT)
> > > >  	depends on VFIO_PCI_CORE
> > > > +	depends on PCI && PCI_MSI  
> > >
> > > PCI is already in the depends from the 2nd line in
> > > drivers/vfio/pci/Kconfig, but it is harmless
> > >  
> > > > +	depends on UACCE || UACCE=n
> > > > +	depends on ACPI  
> > >
> > > Scratching my head a bit on why we have these  
> > 
> > Same curiosity from me, each of the CRYPTO_DEV_HISI_* options selected
> > also depend on these so they seem redundant.  
> 
> Yes, they are redundant now since we have added CRYPTO_DEV_HISI_ drivers
> as "depends" now. I will remove that.
>  
> > I think we still require acks from Bjorn and Zaibo for select patches
> > in this series.  
> 
> I checked with Ziabo. He moved projects and is no longer looking into crypto stuff.
> Wangzhou and LiuLongfang now take care of this. Received acks from Wangzhou
> already and I will request Longfang to provide his. Hope that's ok.

Maybe a good time to have them update MAINTAINERS as well.  Thanks,

Alex


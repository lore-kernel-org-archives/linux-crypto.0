Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BF8C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 20:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiB1UYd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiB1UYc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 15:24:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A49D856222
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 12:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646079831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90VxHOyFuo2ODBqrQg2kpbHyzlakM2kYCuGAJwvAK6A=;
        b=aTIWLXGeh2miDuNwMlFDCMyqHJgsCo1jhmOe3n7q4T9Qr5rObMx0sIaX1W9RnoS8GHSqxe
        jpJupPj9DdmnfwFiY30paF78su8ZUMD5zZnHGE1InXgNmfLKI2Tf3jQWy4YuRiwALEZDYU
        eGxcB8YM4iOtDTqQM594P7QOYQRS0+A=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-TKGPwOEvNSykpiPpT641lQ-1; Mon, 28 Feb 2022 15:23:49 -0500
X-MC-Unique: TKGPwOEvNSykpiPpT641lQ-1
Received: by mail-oo1-f71.google.com with SMTP id 7-20020a4a0007000000b0031d5b7742c6so4658089ooh.2
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 12:23:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=90VxHOyFuo2ODBqrQg2kpbHyzlakM2kYCuGAJwvAK6A=;
        b=SP0P1rRCwU9ZVFrPpvdiG3pqYpDn0prKusAj8m110rl1ujkyzKx33QJS/A9S//z7pq
         oRcNUCmlRRRRBO3lD21lz+jU/9GDH5REMVRdo2lBMJwslKWQDhfVdIGUp7orZe9wDPnE
         01JRDhufaxXDlPBwGNNR2fIk+5aTw4BiCC/h1rhA4EjcR1EBRDQCO4mGQqvjmKoRcpXO
         VBspvbKZinmvbSQvP1lY5VxQim6GMljXhTHYgaTjDt9MDdmMoeI0npRDG4mie1LHZsch
         KzXKIZWFHxoGsuDz1c7HbrLG4pKK3dXcNoGfvRkj6ByQPZeLT7i2tAvOvYZHafSebdNN
         0I0w==
X-Gm-Message-State: AOAM531+lC+DvojDLXtE3eTK7av77y46ovrhGxY3fIOJsz280LiT3pJY
        Jb2rRG/lvu8gtf+3RINQKXY88fqInIMpuEEZI5ilLIhmLSREpTRHjivtygGO2KtPPUHWsAMn4Gj
        nHPLOjHTwQGhFKdUptyVKErRl
X-Received: by 2002:a05:6870:678c:b0:d6:e495:e9e2 with SMTP id gc12-20020a056870678c00b000d6e495e9e2mr1729694oab.154.1646079829027;
        Mon, 28 Feb 2022 12:23:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCoTJvK0Zs83kxVjGLCSp366fI2fadM1e3pMs0iu/tKtBzyVo7yn+bdexHYiCmEVEg2PXmsQ==
X-Received: by 2002:a05:6870:678c:b0:d6:e495:e9e2 with SMTP id gc12-20020a056870678c00b000d6e495e9e2mr1729684oab.154.1646079828768;
        Mon, 28 Feb 2022 12:23:48 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v5-20020a544d05000000b002d7652b3c52sm4653982oix.25.2022.02.28.12.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 12:23:48 -0800 (PST)
Date:   Mon, 28 Feb 2022 13:23:46 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, jgg@nvidia.com, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 03/10] hisi_acc_qm: Move PCI device IDs to common
 header
Message-ID: <20220228132346.77624e5b.alex.williamson@redhat.com>
In-Reply-To: <20220228201259.GA516607@bhelgaas>
References: <20220228103338.76da0b3b.alex.williamson@redhat.com>
        <20220228201259.GA516607@bhelgaas>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 28 Feb 2022 14:12:59 -0600
Bjorn Helgaas <helgaas@kernel.org> wrote:

> On Mon, Feb 28, 2022 at 10:33:38AM -0700, Alex Williamson wrote:
> > [Cc+ Bjorn, linux-pci]
> > 
> > On Mon, 28 Feb 2022 09:01:14 +0000
> > Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> >   
> > > Move the PCI Device IDs of HiSilicon ACC devices to
> > > a common header and use a uniform naming convention.  
> 
> > > --- a/include/linux/pci_ids.h
> > > +++ b/include/linux/pci_ids.h
> > > @@ -2529,6 +2529,12 @@
> > >  #define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
> > >  
> > >  #define PCI_VENDOR_ID_HUAWEI		0x19e5
> > > +#define PCI_DEVICE_ID_HUAWEI_ZIP_PF	0xa250
> > > +#define PCI_DEVICE_ID_HUAWEI_ZIP_VF	0xa251
> > > +#define PCI_DEVICE_ID_HUAWEI_SEC_PF	0xa255
> > > +#define PCI_DEVICE_ID_HUAWEI_SEC_VF	0xa256
> > > +#define PCI_DEVICE_ID_HUAWEI_HPRE_PF	0xa258
> > > +#define PCI_DEVICE_ID_HUAWEI_HPRE_VF	0xa259  
> 
> We usually don't add things to pci_ids.h unless they're used in more
> than one place (see the comment at the top of the file).  AFAICT,
> these device IDs are only used in one file, so you can leave the
> #defines in the file that uses them or use bare hex values.

Later in this series the VF IDs are added to a vendor variant of the
vfio-pci driver:

https://lore.kernel.org/all/20220228090121.1903-5-shameerali.kolothum.thodi@huawei.com/

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
new file mode 100644
index 000000000000..8129c3457b3b
--- /dev/null
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
...
+static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_SEC_VF) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_HPRE_VF) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_ZIP_VF) },
+	{ }
+};

So I think the VFs IDs meet the requirements, but perhaps not the PF
IDs.  Would it be ok if the PFs were dropped?  Thanks,

Alex


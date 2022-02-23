Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009FDC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 23:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244866AbiBWXhp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Feb 2022 18:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244879AbiBWXhp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Feb 2022 18:37:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B9235A5B8
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 15:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645659435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8aSBb/VoBYcQvKUpDDSg+cPg7cKg8nOk6XOiSIXQhhk=;
        b=b06AXcNdZZEfzKhWRc+jf79T/mDj9jFtRd8B1vIrjhvkG2EMbr+l6PRI36U+RzVjGPtOxC
        bhybJUn6zxTbOrM+1041i3AnP35Kq6IGKcWtGUr5XMa6r5fwz1XFeBylpuXJaOgcBq5qbT
        SJdqIbtdL0NrJ44pOSFO1NS51XEzVkA=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-Es1WNrD7O3WIwqOcjMWoTA-1; Wed, 23 Feb 2022 18:37:14 -0500
X-MC-Unique: Es1WNrD7O3WIwqOcjMWoTA-1
Received: by mail-oo1-f70.google.com with SMTP id k10-20020a4ad98a000000b003185c75574dso333428oou.1
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 15:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8aSBb/VoBYcQvKUpDDSg+cPg7cKg8nOk6XOiSIXQhhk=;
        b=wCRBSumLbiqQKG/ZCEj5nbVzA8/GPScafz0b+I/OwEgQsFziHe/0Qsmp9BNvieWIL5
         OyiR486vEgUU9ICRS7V8pUv2Phpo7NOCBAQt6yS2xqXE4taS6cZs/Cz5td9+0tRBj3ia
         w3Z3S0vaWtkUHwB8d/DJk/x6/gR1HYujUWuV7F17WePSXlSfOS3i1HoLVPDNFRrQ4Xcl
         cg6xjKTCOHLaJSooKyLBB8qPiDpsbKO1WA+E2TZCmybvtubz/vULr8fKnphGyjFYZKD2
         aMht66vyy0ZEJGsLGeJBGwVI4lJSgmqux3iG4bstmvMYkK5Y9J9gGOhogQZ+G//FDSO6
         1cTQ==
X-Gm-Message-State: AOAM5319Ft/n8jW76S/n/m6PD3qhGpxSi2Z55ZbWnBx+Q+uWHGPESI3s
        qOxo5UXWKS2SFvmj+LTU4s2fiJdt6MtyYZXotNZ0Hzr5mLQwZJhm/67xUwUHhkeyZ4DoNnElK5Y
        RZMP+AfPwlEESMYZn2NnK/qhF
X-Received: by 2002:a05:6808:1406:b0:2d4:f822:578e with SMTP id w6-20020a056808140600b002d4f822578emr3873oiv.338.1645659433457;
        Wed, 23 Feb 2022 15:37:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznNClK9/UStphScNTKJaAAaGciiCfDkCBkb4WaYTlVNDrZwr4pfhqYR+GafH5TyVRk/JPZCw==
X-Received: by 2002:a05:6808:1406:b0:2d4:f822:578e with SMTP id w6-20020a056808140600b002d4f822578emr3863oiv.338.1645659433265;
        Wed, 23 Feb 2022 15:37:13 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 5sm481997otf.30.2022.02.23.15.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 15:37:12 -0800 (PST)
Date:   Wed, 23 Feb 2022 16:37:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v5 6/8] hisi_acc_vfio_pci: Add helper to retrieve the PF
 qm data
Message-ID: <20220223163711.42c5d928.alex.williamson@redhat.com>
In-Reply-To: <20220221114043.2030-7-shameerali.kolothum.thodi@huawei.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
        <20220221114043.2030-7-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Feb 2022 11:40:41 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Provides a helper function to retrieve the PF QM data associated
> with a ACC VF dev. This makes use of the  pci_iov_get_pf_drvdata()
> to get PF drvdata safely. Introduces helpers to retrieve the ACC
> PF dev struct pci_driver pointers as this is an input into the
> pci_iov_get_pf_drvdata().
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c     |  6 ++++
>  drivers/crypto/hisilicon/sec2/sec_main.c      |  6 ++++
>  drivers/crypto/hisilicon/zip/zip_main.c       |  6 ++++
>  drivers/vfio/pci/hisilicon/Kconfig            |  7 +++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 30 +++++++++++++++++++
>  include/linux/hisi_acc_qm.h                   |  5 ++++
>  6 files changed, 60 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index ba4043447e53..80fb9ef8c571 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -1189,6 +1189,12 @@ static struct pci_driver hpre_pci_driver = {
>  	.driver.pm		= &hpre_pm_ops,
>  };
>  
> +struct pci_driver *hisi_hpre_get_pf_driver(void)
> +{
> +	return &hpre_pci_driver;
> +}
> +EXPORT_SYMBOL(hisi_hpre_get_pf_driver);

Curious why none of these are _GPL symbols.  Thanks,

Alex


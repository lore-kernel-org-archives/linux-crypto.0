Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A7FC07E96
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jul 2021 20:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D991A61411
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jul 2021 20:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhGBUcP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jul 2021 16:32:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231549AbhGBUcO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jul 2021 16:32:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625257781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=43m9ZMNlwSNeKVrq0tRO/O1TR5j/lIl0glWtuE7KCzs=;
        b=PwpVO4SWPwy4ZIgZB5lf2AyVvgwpNXrWMtJOK+i0Wg4Ui0k4II/KKDlU1pG1lC+wWfgPwP
        wSxXjKjobvJGrSWUwbM053mMXc3Gk8MiDzw0319o9isuGMEbhxLZRn7AGSwWcTqa/HYjBY
        vSoPhl/C56PPWcLgyBUN6cE0ywHb8oY=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-5cu0ZnNQNlOfx0IRaVBMHg-1; Fri, 02 Jul 2021 16:29:39 -0400
X-MC-Unique: 5cu0ZnNQNlOfx0IRaVBMHg-1
Received: by mail-oo1-f71.google.com with SMTP id r4-20020a4ab5040000b02902446eb55473so6151408ooo.20
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jul 2021 13:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43m9ZMNlwSNeKVrq0tRO/O1TR5j/lIl0glWtuE7KCzs=;
        b=FxjS+stRmUEdzk8OA5JaLdh5ruM0ZASh+HOxtcJeK9lhe4TIHOAqQ1W8LkRGyMkoEG
         MwMGywRnLx/Am3dBvSANNS8baeeUtmd6cqXLLBqwhAkaMNh+49BEdMJ0l8dhu8sn3Qj6
         J9LMVQzD3LrrzPJuzYKGnaBAM+Gw5zO7g/bQ6e1L779f3jFc2JhtS7xEHJIrjr1/pMef
         +kldBSHrTReb2+0ZNckkhmBfGjg/F6fzEwf50+xob46EIpD2gmmwABVF7dVVtNSEXb97
         KP8khDiEg18NchVlBuzc+RE8AzP6oaYsvFCqjtn0jIyj1sWnSdDs211XaMVaUUSPbv7b
         RNwg==
X-Gm-Message-State: AOAM530pW8XUUvgseQd/z0elqrjbHkCYI48okSpw1KNX4/DzDjFXuS6F
        DQXj0uhjcEqSRGGorxMawzVE1T1mt/+saiBa1JIbwIi5wvLBbHQW91mJ/zMIehOtaa/FaHcjVPj
        +XU+p2fUTyVGibDnG+JKjiGaL
X-Received: by 2002:aca:3bc3:: with SMTP id i186mr1209789oia.102.1625257778611;
        Fri, 02 Jul 2021 13:29:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJGZxdvdDgbA5jf/eA3mNAUGNVwqo/oKw3QtnN938999lHw9G7kVlYyunnUZrw5ODGPAbp+Q==
X-Received: by 2002:aca:3bc3:: with SMTP id i186mr1209778oia.102.1625257778458;
        Fri, 02 Jul 2021 13:29:38 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id o45sm788385ota.59.2021.07.02.13.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 13:29:38 -0700 (PDT)
Date:   Fri, 2 Jul 2021 14:29:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <yuzenghui@huawei.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 2/4] hisi_acc_vfio_pci: Override ioctl method to limit
 BAR2 region size
Message-ID: <20210702142937.5cbe366f.alex.williamson@redhat.com>
In-Reply-To: <20210702095849.1610-3-shameerali.kolothum.thodi@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
        <20210702095849.1610-3-shameerali.kolothum.thodi@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2 Jul 2021 10:58:47 +0100
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> HiSilicon ACC VF device BAR2 region consists of both functional register
> space and migration control register space. From a security point of
> view, it's not advisable to export the migration control region to Guest.
> 
> Hence, hide the migration region and report only the functional register
> space.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/pci/hisi_acc_vfio_pci.c | 42 +++++++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> index a9e173098ab5..d57cf6d7adaf 100644
> --- a/drivers/vfio/pci/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> @@ -12,6 +12,46 @@
>  #include <linux/vfio.h>
>  #include <linux/vfio_pci_core.h>
>  
> +static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> +				    unsigned long arg)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +
> +	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> +		struct pci_dev *pdev = vdev->pdev;
> +		struct vfio_region_info info;
> +		unsigned long minsz;
> +
> +		minsz = offsetofend(struct vfio_region_info, offset);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +
> +			/*
> +			 * ACC VF dev BAR2 region(64K) consists of both functional
> +			 * register space and migration control register space.
> +			 * Report only the first 32K(functional region) to Guest.
> +			 */
> +			info.size = pci_resource_len(pdev, info.index) / 2;
> +

Great, but what actually prevents the user from accessing the full
extent of the BAR since you're re-using core code for read/write/mmap,
which are all basing access on pci_resource_len()?  Thanks,

Alex

> +			info.flags = VFIO_REGION_INFO_FLAG_READ |
> +					VFIO_REGION_INFO_FLAG_WRITE |
> +					VFIO_REGION_INFO_FLAG_MMAP;
> +
> +			return copy_to_user((void __user *)arg, &info, minsz) ?
> +					    -EFAULT : 0;
> +		}
> +	}
> +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +}
> +
>  static int hisi_acc_vfio_pci_open(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =
> @@ -33,7 +73,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>  	.name		= "hisi-acc-vfio-pci",
>  	.open		= hisi_acc_vfio_pci_open,
>  	.release	= vfio_pci_core_release,
> -	.ioctl		= vfio_pci_core_ioctl,
> +	.ioctl		= hisi_acc_vfio_pci_ioctl,
>  	.read		= vfio_pci_core_read,
>  	.write		= vfio_pci_core_write,
>  	.mmap		= vfio_pci_core_mmap,


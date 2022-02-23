Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E606AC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 23:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244847AbiBWXhi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Feb 2022 18:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243015AbiBWXhh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Feb 2022 18:37:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BD5D5A09B
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 15:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645659427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4uZUFplVlE5Y8frdrAqmVb5e+dpaoHXAN39OVRnAh4=;
        b=HfvT7Km9xEzosgW97guxKGspVDkjt76JZH5i66eL0dZz+5SAiA89HX/SFfSMixfdbkUm9/
        R7JL5Qr89KYMQccOueAEwl2IQj2VVwk1PkhhUBlSmq4bS+8bM/H7kC18jbKblhgpge/qDb
        9aWlteAKioJ7b1PZ3bjUdTgWo2Q00V0=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-wNXS-AERPTygATocEsD7Rg-1; Wed, 23 Feb 2022 18:37:06 -0500
X-MC-Unique: wNXS-AERPTygATocEsD7Rg-1
Received: by mail-ot1-f71.google.com with SMTP id j12-20020a056830270c00b005af74a640abso143783otu.9
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 15:37:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=T4uZUFplVlE5Y8frdrAqmVb5e+dpaoHXAN39OVRnAh4=;
        b=sBEYIU9/oqd+Hh0gCWZNS6tE4sBMmDx6ZdSl0FfhpLqTrkflUADS/vI82swKZjf9qX
         u4LMP9a9y/z0/URzaTCCj4ZUpdpvxi+XPHHM93G1FUrlwZ3u06mMDJae1XPkhufsUmO6
         N7oDzhTEjJXJSP3T/jB19W1OBEqLzMZItHEfA6Cw2uBeOKKIGDgGYAtCro7ySOQUSJWP
         qcRbMVgbtUpxFPiurHVQoX/EtCWOYKz3/FNu61dyZViAAdSUZd93u5gErg4z32ofa9LI
         KbtxMDlLSSVNUX7ppRtQeH9KipRbMj2ern4alJUERV4ZzjdDczjbQ+rYuawdWX3D3ZRz
         rcjw==
X-Gm-Message-State: AOAM531HweVXQDNg9VLxvMh97LXkq/x0ifYk/ItOJvvs+895QKh2rDl2
        sIhuM18pLpYsHHNDL77V9GflD8LzdsEkZ2Yie9+C2EXErOuVkUuPiu4qOtQ8uglit2hkeYBCv9G
        jRjE/pLVFL/Vsj+GpagRDfxeh
X-Received: by 2002:a9d:7016:0:b0:5af:157b:685 with SMTP id k22-20020a9d7016000000b005af157b0685mr10037otj.16.1645659425852;
        Wed, 23 Feb 2022 15:37:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxofdQSoSC1/kDx6fUUcLtOCsSdUzQ0Bk8PapztMnNq1yES+yHaSrNxhft1rMXuy1CFcMCgtg==
X-Received: by 2002:a9d:7016:0:b0:5af:157b:685 with SMTP id k22-20020a9d7016000000b005af157b0685mr10026otj.16.1645659425637;
        Wed, 23 Feb 2022 15:37:05 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q73sm422469ooq.33.2022.02.23.15.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 15:37:05 -0800 (PST)
Date:   Wed, 23 Feb 2022 16:37:03 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v5 5/8] hisi_acc_vfio_pci: Restrict access to VF dev
 BAR2 migration region
Message-ID: <20220223163703.20690b29.alex.williamson@redhat.com>
In-Reply-To: <20220221114043.2030-6-shameerali.kolothum.thodi@huawei.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
        <20220221114043.2030-6-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Feb 2022 11:40:40 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
>  
> +static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
> +	.name = "hisi-acc-vfio-pci",

Use a different name from the ops below?  Thanks,

Alex

> +	.open_device = hisi_acc_vfio_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = hisi_acc_vfio_pci_ioctl,
> +	.device_feature = vfio_pci_core_ioctl_feature,
> +	.read = hisi_acc_vfio_pci_read,
> +	.write = hisi_acc_vfio_pci_write,
> +	.mmap = hisi_acc_vfio_pci_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +};
> +
>  static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>  	.name = "hisi-acc-vfio-pci",
>  	.open_device = hisi_acc_vfio_pci_open_device,


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E920EC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 02:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiBJCAY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 21:00:24 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiBJB7V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 20:59:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D482D2B6AF
        for <linux-crypto@vger.kernel.org>; Wed,  9 Feb 2022 17:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644457515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QqS6aRbHUDdzpsG8gLAbed/VgqomfvLKE7ZO5PCIOxw=;
        b=EAWUge6OpYCxHvMymJyzXL0u6KeNKQUU7UmOf3hbi6wNGumwmhGn5JElsE2ja4BUF7CKTk
        tWV90Y9Iz8kOCpJDBcOWk+GdTEN4/DxWQvUL0LMEPMqlwoZQT5MxIet6fgh4z1SXxc4awf
        wo4tIlJ5A3FTplwCKy4zT8zvpt8Bozs=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-07ZQlN-YOsWDsuyU0c9-Qg-1; Wed, 09 Feb 2022 18:44:43 -0500
X-MC-Unique: 07ZQlN-YOsWDsuyU0c9-Qg-1
Received: by mail-io1-f69.google.com with SMTP id b15-20020a056602330f00b006109348c3daso2881436ioz.3
        for <linux-crypto@vger.kernel.org>; Wed, 09 Feb 2022 15:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QqS6aRbHUDdzpsG8gLAbed/VgqomfvLKE7ZO5PCIOxw=;
        b=3GB36QubjD6VUouIskvJgcZkNa2JcTwS70qIrzrSc9E1oJqiMLWvdj6kNUqHMxb/PA
         z2dTw2RnzF+4Onj9SpSqlsrLwWB2p+qNg0e/LO6XQJ0q+RK38TUV0rAUpDzy8uebOnZ0
         zSL3xK/wtZ3rPYWqzyC984Kqd/SQ3X+Vmb2sc66zi/QlCeKRy20eBBt6rAtMGU4UcrZx
         cAhMVKpNcPSW0yEH5PWtNB5aSuQBkmHE9cNSKQHerwT89liE88ReQxGQPh0gn3YcqOfT
         ppfD61xK85xR7cV6BB/C4JeGB4y5zmJosxB82s+tm5u6HXE/xNeGsLCECB093rTGlQee
         q9gQ==
X-Gm-Message-State: AOAM531e8x7QKGlNmJFQuXT2MdAyXwowFscMn6gYYDNBoucOLgbs1bJ+
        1D5/U7HtQDr1sUPahBPEgwmWwhh30n1IuCZHfzoQce37VFEX9Jg4lYpmaAGJTNggAng8EosPef1
        pElABSiK2GTUEaR0TnZ5Zkest
X-Received: by 2002:a05:6602:2209:: with SMTP id n9mr2470388ion.106.1644450283116;
        Wed, 09 Feb 2022 15:44:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxT6HD2F4lnfPsmgFD3PhnkTPzmCmvBRL9NupZBHsvlbk18vuDpteUdQty0XS8Ul8opPEqcow==
X-Received: by 2002:a05:6602:2209:: with SMTP id n9mr2470381ion.106.1644450282952;
        Wed, 09 Feb 2022 15:44:42 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w19sm10870685iov.16.2022.02.09.15.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 15:44:42 -0800 (PST)
Date:   Wed, 9 Feb 2022 16:44:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220209164440.0d77284c.alex.williamson@redhat.com>
In-Reply-To: <20220208133425.1096-8-shameerali.kolothum.thodi@huawei.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
        <20220208133425.1096-8-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 8 Feb 2022 13:34:24 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> +
> +static struct hisi_acc_vf_migration_file *
> +hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +{
> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> +	struct device *dev = &hisi_acc_vdev->vf_dev->dev;
> +	struct hisi_acc_vf_migration_file *migf;
> +	int ret;
> +
> +	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
> +		dev_info(dev, "QM device not ready, no data to transfer\n");
> +		return 0;
> +	}

This return value looks suspicious and I think would cause a segfault
in the calling code:

+		migf = hisi_acc_vf_stop_copy(hisi_acc_vdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		hisi_acc_vdev->saving_migf = migf;
+		return migf->filp;

Thanks,
Alex


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795141B942
	for <linux-crypto@vger.kernel.org>; Tue,  6 Feb 2024 21:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707254094; cv=none; b=CUCL5MHMKxLN+2JCvezuQyLGZcNi1C249Zpzkzh5LETB1IGIlCXpOvvBtatvlUapu6CeOciANIT2kHvgIvYicWFRMJIiSGStKTpb0TWvWmT042k36JOC+VWiI3HKxY0U4Ba/UHqAt+s2LSNwjbQoVY4+/3uvQizfRf3C4TsP9po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707254094; c=relaxed/simple;
	bh=rs009olvY/9WzzrCZpUhTiAvosuJDsNllQJzmm0cAf0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dwrg5UfQ4BcHNi+PDVWIa2F73FrZzwBJ27i/XnYeW4NLW06DMORPmQdxUtaeWmwYI9g4qc25lMgM9Ky3/clAv8ab9M9UHsU71jBLVkEvV/HDQMg/MG5refqcy732+TYZvInTilMkcao+kVyqCOEwfwk+GcTgyaUua9kNunIp8Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fP6M4LyU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fP6M4LyU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707254091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8hAmI/kTzxWy7R6bfZhnn1+RfmTFQ/1/obEiDj09sR4=;
	b=fP6M4LyUlvT2G1PJioq7WUvDVpdrrcwxRGFwaQULmFJ5OWk7J9uLxpLNgvJJY7z6iOA46b
	vhRiv2Q/1+wffh4qIhW0M9ZQG7TvToKb7hyDHQ+jBSR5d3112l6OF1THjBjxuMOxV8ZK4D
	aSIz9uiQvyP0Bucef9hEj4jefcwp9U4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-nEdrdHBbOlKm6UheZ2Gbqw-1; Tue, 06 Feb 2024 16:14:50 -0500
X-MC-Unique: nEdrdHBbOlKm6UheZ2Gbqw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7baa6cc3af2so668117239f.2
        for <linux-crypto@vger.kernel.org>; Tue, 06 Feb 2024 13:14:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707254089; x=1707858889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8hAmI/kTzxWy7R6bfZhnn1+RfmTFQ/1/obEiDj09sR4=;
        b=i1wVXFwIdcDzWFy1j245Uequh9T28/RoRLgKP/ImW2TrujyRQ6moXCBylC68YhoM2p
         rLhc3v3/TNDX5tRfdKcxWPpmJYP4fcVs1Epq7t/tfv0WJxSojdgkf7itDN2vGo98QqBy
         AFBN9NM5Ef26A+l13y8ONZCkFRLp+boClqcCxgG/sJLdwhD3G23Qn4PwI1SngrHYf30O
         fq6u9hKo6kFLUtWKWn0SaqtTgkpc9XOubDLWYsdczrTgqhndqCNaMvrgKj04Z4qNTl+o
         DBCEkaZCs5VxCGlzdpf8sDXtwqBY8aPsyTAGKxwQCmNo6gqx8QSyD50aqxrUfIsJfX+n
         78Zw==
X-Gm-Message-State: AOJu0YwCIl0pWI+sEuFAg0rOHqa+acuIe+5Va8be6MvDmNB2YaQ05VZz
	QffHy6tRIXINgewyymQsUJ8AO4Bd4sY2LNrWvAAuTbeRaHBvENoflhJQFBubU0G9AgSJYYPO69F
	HjM+yz+K7wOunIVdlOE5/h3UXX0fgRGhY6dBLExmmQE6sWwY4g/B+iRZhfEEs6g==
X-Received: by 2002:a5e:8e49:0:b0:7c3:f324:2fe3 with SMTP id r9-20020a5e8e49000000b007c3f3242fe3mr2860589ioo.17.1707254089172;
        Tue, 06 Feb 2024 13:14:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGaXoxO7J7wKDfWZtVSDEai0dLBM1FbmBcZ2Bc6IpfP3hxy51t/zZahiAjZCbuk5fzj9XvRSA==
X-Received: by 2002:a5e:8e49:0:b0:7c3:f324:2fe3 with SMTP id r9-20020a5e8e49000000b007c3f3242fe3mr2860579ioo.17.1707254088908;
        Tue, 06 Feb 2024 13:14:48 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCV+gMiE68QABRZ8gdjoRk+ExjhzvPonKBa+sPDkwIjgOVosM/6jB8tfRJAnWJ0xaFh6nUnyjIHsDeIOCo+ZeWQDwz68i781IPfFj/S/dj5ws1JfbEvWM1QAv0Y+kFJwCcJ3tbR/4iATAvM6sBeizFaH2Ua8oKQUlb19gmykURbsynjvs2HAdUMeppOnSfKab6LPjIybj81XEJ5EZIApuuaSWnfA61teGFUbA/uAbobBH4VTijtELYeP+XUEHgyO0qTr2AEPXXZmfj4jBKHRpbhSbxZgK6xO/LiFHVpGFsE7Qx1Phj3X2UYhNV7t
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id f26-20020a056638023a00b0047133a05f33sm743055jaq.49.2024.02.06.13.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 13:14:48 -0800 (PST)
Date: Tue, 6 Feb 2024 14:14:46 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: herbert@gondor.apana.org.au, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, qat-linux@intel.com,
 Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240206141446.3547e4a9.alex.williamson@redhat.com>
In-Reply-To: <20240201153337.4033490-11-xin.zeng@intel.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
	<20240201153337.4033490-11-xin.zeng@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Feb 2024 23:33:37 +0800
Xin Zeng <xin.zeng@intel.com> wrote:

> Add vfio pci driver for Intel QAT VF devices.
> 
> This driver uses vfio_pci_core to register to the VFIO subsystem. It
> acts as a vfio agent and interacts with the QAT PF driver to implement
> VF live migration.
> 
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  MAINTAINERS                         |   8 +
>  drivers/vfio/pci/Kconfig            |   2 +
>  drivers/vfio/pci/Makefile           |   2 +
>  drivers/vfio/pci/intel/qat/Kconfig  |  13 +
>  drivers/vfio/pci/intel/qat/Makefile |   4 +
>  drivers/vfio/pci/intel/qat/main.c   | 572 ++++++++++++++++++++++++++++
>  6 files changed, 601 insertions(+)
>  create mode 100644 drivers/vfio/pci/intel/qat/Kconfig
>  create mode 100644 drivers/vfio/pci/intel/qat/Makefile
>  create mode 100644 drivers/vfio/pci/intel/qat/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8d1052fa6a69..c1d3e4cb3892 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23095,6 +23095,14 @@ S:	Maintained
>  F:	Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst
>  F:	drivers/vfio/pci/pds/
>  
> +VFIO QAT PCI DRIVER
> +M:	Xin Zeng <xin.zeng@intel.com>
> +M:	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> +L:	kvm@vger.kernel.org
> +L:	qat-linux@intel.com
> +S:	Supported
> +F:	drivers/vfio/pci/intel/qat/
> +
>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
>  L:	kvm@vger.kernel.org
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 18c397df566d..329d25c53274 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -67,4 +67,6 @@ source "drivers/vfio/pci/pds/Kconfig"
>  
>  source "drivers/vfio/pci/virtio/Kconfig"
>  
> +source "drivers/vfio/pci/intel/qat/Kconfig"
> +
>  endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 046139a4eca5..a87b6b43ce1c 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -15,3 +15,5 @@ obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>  obj-$(CONFIG_PDS_VFIO_PCI) += pds/
>  
>  obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
> +
> +obj-$(CONFIG_QAT_VFIO_PCI) += intel/qat/
> diff --git a/drivers/vfio/pci/intel/qat/Kconfig b/drivers/vfio/pci/intel/qat/Kconfig
> new file mode 100644
> index 000000000000..71b28ac0bf6a
> --- /dev/null
> +++ b/drivers/vfio/pci/intel/qat/Kconfig
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config QAT_VFIO_PCI
> +	tristate "VFIO support for QAT VF PCI devices"
> +	select VFIO_PCI_CORE
> +	depends on CRYPTO_DEV_QAT
> +	depends on CRYPTO_DEV_QAT_4XXX

CRYPTO_DEV_QAT_4XXX selects CRYPTO_DEV_QAT, is it necessary to depend
on CRYPTO_DEV_QAT here?

> +	help
> +	  This provides migration support for Intel(R) QAT Virtual Function
> +	  using the VFIO framework.
> +
> +	  To compile this as a module, choose M here: the module
> +	  will be called qat_vfio_pci. If you don't know what to do here,
> +	  say N.
> diff --git a/drivers/vfio/pci/intel/qat/Makefile b/drivers/vfio/pci/intel/qat/Makefile
> new file mode 100644
> index 000000000000..9289ae4c51bf
> --- /dev/null
> +++ b/drivers/vfio/pci/intel/qat/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_QAT_VFIO_PCI) += qat_vfio_pci.o
> +qat_vfio_pci-y := main.o
> +

Blank line at end of file.

> diff --git a/drivers/vfio/pci/intel/qat/main.c b/drivers/vfio/pci/intel/qat/main.c
> new file mode 100644
> index 000000000000..85d0ed701397
> --- /dev/null
> +++ b/drivers/vfio/pci/intel/qat/main.c
> @@ -0,0 +1,572 @@
...
> +static int qat_vf_pci_init_dev(struct vfio_device *core_vdev)
> +{
> +	struct qat_vf_core_device *qat_vdev = container_of(core_vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +	struct qat_migdev_ops *ops;
> +	struct qat_mig_dev *mdev;
> +	struct pci_dev *parent;
> +	int ret, vf_id;
> +
> +	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;

AFAICT it's always good practice to support VFIO_MIGRATION_PRE_COPY,
even if only to leave yourself an option to mark an incompatible ABI
change in the data stream that can be checked before the stop-copy
phase of migration.  See for example the mtty sample driver.  Thanks,

Alex

> +	core_vdev->mig_ops = &qat_vf_pci_mig_ops;
> +
> +	ret = vfio_pci_core_init_dev(core_vdev);
> +	if (ret)
> +		return ret;
> +
> +	mutex_init(&qat_vdev->state_mutex);
> +	spin_lock_init(&qat_vdev->reset_lock);
> +
> +	parent = qat_vdev->core_device.pdev->physfn;
> +	vf_id = pci_iov_vf_id(qat_vdev->core_device.pdev);
> +	if (!parent || vf_id < 0) {
> +		ret = -ENODEV;
> +		goto err_rel;
> +	}
> +
> +	mdev = qat_vfmig_create(parent, vf_id);
> +	if (IS_ERR(mdev)) {
> +		ret = PTR_ERR(mdev);
> +		goto err_rel;
> +	}
> +
> +	ops = mdev->ops;
> +	if (!ops || !ops->init || !ops->cleanup ||
> +	    !ops->open || !ops->close ||
> +	    !ops->save_state || !ops->load_state ||
> +	    !ops->suspend || !ops->resume) {
> +		ret = -EIO;
> +		dev_err(&parent->dev, "Incomplete device migration ops structure!");
> +		goto err_destroy;
> +	}
> +	ret = ops->init(mdev);
> +	if (ret)
> +		goto err_destroy;
> +
> +	qat_vdev->mdev = mdev;
> +
> +	return 0;
> +
> +err_destroy:
> +	qat_vfmig_destroy(mdev);
> +err_rel:
> +	vfio_pci_core_release_dev(core_vdev);
> +	return ret;
> +}


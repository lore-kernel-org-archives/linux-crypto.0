Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F1136AFB
	for <linux-crypto@vger.kernel.org>; Thu, 18 Apr 2024 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713480883; cv=none; b=aSt83lnaHkgj8dBWfRmW6DW5UZZDyEHIsXgVbq680stHUfHFiNnAzFZ+7Xgm/kfxbbkEK2C88I7TfoQDE2WxOGO+Spr59143pjmI7ex/2fbuyGg6ec2VrylB8NU9awjfJWNz9LJg5IOKYGCbBOsY8W8Avd5N3WT/7FZXVNqELTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713480883; c=relaxed/simple;
	bh=YhdtaVfh4088buH+XZg/IkImHaxqcTSecceCrXaDNTA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0xhgco3kA4PazKsX5jEInPRuZWeHU21yFOMm+Hj/Nzsh7LQMjK7ja0JJworCj1RInEME9V9PFOR0T0WmvUctvj5TbeyE1paDwekCEpo1QEjwG/RpvP7dV+993RgEM9YTelXss8Cv3m7Xca+WmvCLsUJHpAnTcaXpj2S/kZrd08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WD/or5iL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WD/or5iL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713480879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Qa3hR1GgJrmWTXgAvlGxLrVho0/A5qeW+iYF0awOyc=;
	b=WD/or5iLokdv12x7J6kufpcpOgNr6YTZ2zDrCIa2R+8h5YOOsb9EelWHmxY4ZoXPKNw4p3
	H9ixZTGXGTiXg442oLNKNOO0bI2f9MILVRlRjLDlWxaYEPXYpX0v05Z3G18yK9gPAeWqaQ
	kPv0O+/uJVX1XZOPey5s3hjGh9WmTrg=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-dFx9QauGP-CsWgtKE4JQEg-1; Thu, 18 Apr 2024 18:54:37 -0400
X-MC-Unique: dFx9QauGP-CsWgtKE4JQEg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-36a1e4a5017so17178075ab.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Apr 2024 15:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713480877; x=1714085677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Qa3hR1GgJrmWTXgAvlGxLrVho0/A5qeW+iYF0awOyc=;
        b=G9IMh+KPK+AVgXqUi3R44Q0UlZ53AknJKhJmZLde7Vl9qfgSUA4BBaT9F1qvgMsWZe
         wucQYT1xZ/lmXRqbIR23PGdqzT0C59jGqLB3RG11M3PNo0VGDQ8LVAA7lv5P3sbJitT9
         RWsNorp+N3KZKiaBhJR3u496WocvzCMFjJQ17XMSFJg1wpBk/uGcqz5BL/nwlrUkM9U5
         SViIJ0Jcksdsdw+rSzkiStSh5xqhG9WJB/Pt2F+6B3C+uKzQMO1cyhRgaHpjnGmNdRsD
         Tb34KrWRXorU52BROb1lJRgsUP4f/6oP3vimspvxrWMWEgrV/8c83+HO3lE32oYUdKtn
         KE3A==
X-Forwarded-Encrypted: i=1; AJvYcCUkTXzZ9rt/ewgpLwtpWwxVV2eM9YwpCs6bmDyCeAgm+mVGF9Uqp7JJ73o0KX4WHmdDCDbRwTzYm2Eq4vRVc3RnWRFGQhZyJeSvuPmD
X-Gm-Message-State: AOJu0YwifTQcDd+UUBfWztg/6iphHfh374mIYhd9oxufkX0mz7Hgm/6V
	AQp4KRFSg/Jjqe/+4ZhDoum75Q1DYljp0Jj+vbCgOUB/J36mT9i2HalALu1qQVAz5/H/MGDTCtw
	5EerUcfvJvcCIlhOb+IcWT3jYk9LiWowZJKyZBrg+PpFe0zhXfqBUFJECz21ABQ==
X-Received: by 2002:a05:6e02:1688:b0:36b:36b:1115 with SMTP id f8-20020a056e02168800b0036b036b1115mr5408040ila.1.1713480877178;
        Thu, 18 Apr 2024 15:54:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElkIPKIuNl9ph1Phq9PzvzzBElJf7MnvsKrZ/DLV6aq5UhFYH+VCNTGKZAYpXsg0QJpGLyAg==
X-Received: by 2002:a05:6e02:1688:b0:36b:36b:1115 with SMTP id f8-20020a056e02168800b0036b036b1115mr5408028ila.1.1713480876877;
        Thu, 18 Apr 2024 15:54:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id i3-20020a05663813c300b00482f19f6d4csm650381jaj.110.2024.04.18.15.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 15:54:36 -0700 (PDT)
Date: Thu, 18 Apr 2024 16:54:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: herbert@gondor.apana.org.au, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, qat-linux@intel.com,
 Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT
 SR-IOV VF devices
Message-ID: <20240418165434.1da52cf0.alex.williamson@redhat.com>
In-Reply-To: <20240417143141.1909824-2-xin.zeng@intel.com>
References: <20240417143141.1909824-1-xin.zeng@intel.com>
	<20240417143141.1909824-2-xin.zeng@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Apr 2024 22:31:41 +0800
Xin Zeng <xin.zeng@intel.com> wrote:

> Add vfio pci variant driver for Intel QAT SR-IOV VF devices. This driver
> registers to the vfio subsystem through the interfaces exposed by the
> susbsystem. It follows the live migration protocol v2 defined in
> uapi/linux/vfio.h and interacts with Intel QAT PF driver through a set
> of interfaces defined in qat/qat_mig_dev.h to support live migration of
> Intel QAT VF devices.

=46rom here down could actually just be a comment towards the top of the
driver.

> The migration data of each Intel QAT GEN4 VF device is encapsulated into
> a 4096 bytes block. The data consists of two parts.
>=20
> The first is a pre-configured set of attributes of the VF being migrated,
> which are only set when it is created. This can be migrated during pre-co=
py
> stage and used for a device compatibility check.
>=20
> The second is the VF state. This includes the required MMIO regions and
> the shadow states maintained by the QAT PF driver. This part can only be
> saved when the VF is fully quiesced and be migrated during stop-copy stag=
e.
>=20
> Both these 2 parts of data are saved in hierarchical structures including
> a preamble section and several raw state sections.
>=20
> When the pre-configured part of the migration data is fully retrieved from
> user space, the preamble section are used to validate the correctness of
> the data blocks and check the version compatibility. The raw state
> sections are then used to do a device compatibility check.
>=20
> When the device transits from RESUMING state, the VF states are extracted
> from the raw state sections of the VF state part of the migration data and
> then loaded into the device.
>=20
> This version only covers migration for Intel QAT GEN4 VF devices.
>=20
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  MAINTAINERS                   |   8 +
>  drivers/vfio/pci/Kconfig      |   2 +
>  drivers/vfio/pci/Makefile     |   2 +
>  drivers/vfio/pci/qat/Kconfig  |  12 +
>  drivers/vfio/pci/qat/Makefile |   3 +
>  drivers/vfio/pci/qat/main.c   | 679 ++++++++++++++++++++++++++++++++++
>  6 files changed, 706 insertions(+)
>  create mode 100644 drivers/vfio/pci/qat/Kconfig
>  create mode 100644 drivers/vfio/pci/qat/Makefile
>  create mode 100644 drivers/vfio/pci/qat/main.c
...
> +static struct file *qat_vf_pci_step_device_state(struct qat_vf_core_devi=
ce *qat_vdev, u32 new)
> +{
> +	u32 cur =3D qat_vdev->mig_state;
> +	int ret;
> +
> +	/*
> +	 * As the device is not capable of just stopping P2P DMAs, suspend the
> +	 * device completely once any of the P2P states are reached.
> +	 * On the opposite direction, resume the device after transiting from
> +	 * the P2P state.
> +	 */
> +	if ((cur =3D=3D VFIO_DEVICE_STATE_RUNNING && new =3D=3D VFIO_DEVICE_STA=
TE_RUNNING_P2P) ||
> +	    (cur =3D=3D VFIO_DEVICE_STATE_PRE_COPY && new =3D=3D VFIO_DEVICE_ST=
ATE_PRE_COPY_P2P)) {
> +		ret =3D qat_vfmig_suspend(qat_vdev->mdev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +		return NULL;
> +	}

This doesn't appear to be a valid way to support P2P, the P2P states
are defined as running states.  The guest driver may legitimately
access and modify the device state during P2P states.  Should this
device be advertising support for P2P?  Thanks,

Alex


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A724C2D1
	for <linux-crypto@vger.kernel.org>; Wed, 16 Jul 2025 20:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752697425; cv=none; b=gmvhdg5SULNXzfXdJU7Vn9KqP+B17yLdJSqaiJg7O1l5WWCQ7Ml3L2o1rI5ScrU5xCZjEoh07aDIG0foORClLkueLiN2k3qRTg0iDuUo1g2REdkn8pqpoOsuW4PvKlMuCu/Hg7rOPxrg0wdycFaGKsrwV56m2YmJOp0LGB4FoNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752697425; c=relaxed/simple;
	bh=9y5dIKyKcHriMVF+KPx9heA9eZVH1cEEVWtkW4af3I4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I7JyNubRjegnMZnRuUxvJyuSk/x6D0yqVQajx69W2k4+T/tpcNMIEzz6wQpSZa2ee+KT2edMjpTzajOghNMGxdbORDCG72jI5oGixKxmbfg1ZcKJ9vfZL5jwwRQS0n8qgw1WfzHHij63/BqkQit98Ouqf1v7Tqay1xQtCsVOPEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DP/AWZ3Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DP/AWZ3Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752697422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=My5jpWLBkASAD4KArmdY125PUanYXYQ2hsJPAgTrsRo=;
	b=DP/AWZ3Y9mwrhVjCcSBQFhSCNveiLVYIGozaJD78LWtDPrZOhAxIIVBK/HzE25RUJY9yK2
	QVpZS6Apjgk09aFKGcRvk8MFNDsKgE7KsElHNYhL54uZDCO7XQmMj7IY6dd5yJMpOhBj5m
	mxc2tu8IUnJYkgCZR5cwngdQusFAbH0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-uMe2k0zrPoOtMyQ2Wk5WcQ-1; Wed, 16 Jul 2025 16:23:41 -0400
X-MC-Unique: uMe2k0zrPoOtMyQ2Wk5WcQ-1
X-Mimecast-MFC-AGG-ID: uMe2k0zrPoOtMyQ2Wk5WcQ_1752697421
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ddc47aebc2so527865ab.0
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jul 2025 13:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752697421; x=1753302221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=My5jpWLBkASAD4KArmdY125PUanYXYQ2hsJPAgTrsRo=;
        b=jA/7typY9yGhYLnm3/MxNdMVeRiUGtw9UHOeHfTfV9dEFpYOUTqP8KoKh7PR+nTF5C
         T69OoUPIm1VZiqaefCHWTTpUw5/apWoaICzHslqQX655rDsyMsiLVsB5w+xZxJt+7Lu+
         g7HDKUe4EZBMOAJXXnHFEdZ2zLH3HBfAw8VsYdZhWeTu+eITW8r9E9G0peB5WCPOM5Og
         /OGfJ6YaT/G/8bEb70NxR2xd/rZgVzgSAQ1mxAeb91ccTimswFmvgJBSY+abV7WLCPhP
         ZSzT/gHg+7ACVhf2tCbLhH2PnwU5pGzoWCrTn+Bu7vkVEkQoJQmpZ0jsabhtVYjAc7A6
         qp9w==
X-Forwarded-Encrypted: i=1; AJvYcCUF89D4u4Tm/mQMH4zHzGvBONjg4XHjdKPUI/+9eV7gW34dzn80gAtjwGUGyQ8TMO6fRPD6il5DpiPE4dc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFlpFkVpHFwGcp9LG6FeBlu1FjbTsqF+UeAIJd1SKz7KzxHvnH
	bJu+PE972Y7hMdjju+52ITBd0QpBFA4OkCYwyVJ6Y9ygrXpTKqnC9bRTGtvS6BMg4JKcN/lDZZu
	TmxRXkx0oNNkkXwH6pLOANYvo+zctvo9kpqwlI8KFWB75udfEEwUDnKzzqGvWaoYXAg==
X-Gm-Gg: ASbGncudLj7V02fDZvLK+UoEay34aHP03FpmMfmV89DzqaY5031WE+nhOmnF74Vf3uX
	pLJ+Rldloi/a1yLa0BMfcw0VA2gXAhxRrBQ9sp+TDAk8YU8RF2jRgNlxptOrAVJiH8x3ivHTAFU
	NztRl24WSL5u0A7K6lQ5u0g6LJOu7x5Y8VYsL0k3YRp9bqPKcKzq5giojFi3AA8Vj/gW5mdaWgu
	f/CukQ4vetdpe/i9gYtUeR342a5XpjX5wYG8YOB2qccgcSBhIlJ3CbDxGoQwVSyCqwcjd071xqE
	5NOCFRqGujS1lS5IKZs6A3Q9OV+HgclbNEpQE25sKgY=
X-Received: by 2002:a05:6e02:19c7:b0:3dd:c947:b3a7 with SMTP id e9e14a558f8ab-3e28248636amr13309675ab.5.1752697421113;
        Wed, 16 Jul 2025 13:23:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMl6y7UqY2FBdwuRnrCWvwt+QUeVsLSVmif96lmdg75vZtFWDA98rR4kL8WbkV9VEitm+gsw==
X-Received: by 2002:a05:6e02:19c7:b0:3dd:c947:b3a7 with SMTP id e9e14a558f8ab-3e28248636amr13309375ab.5.1752697418882;
        Wed, 16 Jul 2025 13:23:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e246134e8fsm48302815ab.22.2025.07.16.13.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 13:23:38 -0700 (PDT)
Date: Wed, 16 Jul 2025 14:23:37 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: jgg@ziepe.ca, yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, linux-crypto@vger.kernel.org, qat-linux@intel.com,
 kvm@vger.kernel.org, herbert@gondor.apana.org.au,
 giovanni.cabiddu@intel.com
Subject: Re: [PATCH] vfio/qat: add support for intel QAT 6xxx virtual
 functions
Message-ID: <20250716142337.64ba908d.alex.williamson@redhat.com>
In-Reply-To: <20250715081150.1244466-1-suman.kumar.chakraborty@intel.com>
References: <20250715081150.1244466-1-suman.kumar.chakraborty@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Jul 2025 09:11:50 +0100
Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com> wrote:

> From: Ma=C5=82gorzata Mielnik <malgorzata.mielnik@intel.com>
>=20
> Extend the qat_vfio_pci variant driver to support QAT 6xxx Virtual
> Functions (VFs). Add the relevant QAT 6xxx VF device IDs to the driver's
> probe table, enabling proper detection and initialization of these device=
s.
>=20
> Update the module description to reflect that the driver now supports all
> QAT generations.
>=20
> Signed-off-by: Ma=C5=82gorzata Mielnik <malgorzata.mielnik@intel.com>
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/vfio/pci/qat/main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
> index 845ed15b6771..499c9e1d67ee 100644
> --- a/drivers/vfio/pci/qat/main.c
> +++ b/drivers/vfio/pci/qat/main.c
> @@ -675,6 +675,8 @@ static const struct pci_device_id qat_vf_vfio_pci_tab=
le[] =3D {
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4941) },
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4943) },
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4945) },
> +	/* Intel QAT GEN6 6xxx VF device */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4949) },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(pci, qat_vf_vfio_pci_table);
> @@ -696,5 +698,5 @@ module_pci_driver(qat_vf_vfio_pci_driver);
> =20
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Xin Zeng <xin.zeng@intel.com>");
> -MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration s=
upport for Intel(R) QAT GEN4 device family");
> +MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration s=
upport for Intel(R) QAT device family");
>  MODULE_IMPORT_NS("CRYPTO_QAT");
>=20
> base-commit: bfeda8f971d01d0c1d0e3f4cf9d4e2b0a2b09d89

Applied to vfio next branch for v6.17.  Thanks,

Alex


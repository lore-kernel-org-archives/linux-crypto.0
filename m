Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6646C59149
	for <linux-crypto@vger.kernel.org>; Fri,  1 Mar 2024 23:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709337535; cv=none; b=HomKebZMoN1T5mk8YHnpW7o4NcC45jHCYIR+Rn9y4ey3xeA0HE3JeAaFceKzp92GI0Abxev2sHYk6ZIxnCsoHBSeBh6t09xd3nYdFzdIMXr1OxuLwjSeY9dehEQm4uyLAhqFtkSEeCwvIaGNZkBRJnOYjX0u+xWkTkg1SWLJyRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709337535; c=relaxed/simple;
	bh=TEiZWx4zhHeYJu6Wn/bCg5XXbQXaRGha6ZvizIYbH7I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eAECmjtf7BfBnzuLrxnVMAO7z1C7FbCVXBmxcFzJKmWIYIXjhzmG3tc954OpliMugCkATzO0j5+RvEv1IT+iZrldmA8wHa9U9yRHQIKUevUUOPQHEepjauFd48H28129iMuqnQLV0C9rR7EDums+tOl9PZlP341Mz/4wfVtpNz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HcF0iIua; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HcF0iIua"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709337532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YlCAVuX4UaRN1aV/EeYQU1fnCBON103irv5ZBsuVOqI=;
	b=HcF0iIuakwYsFtvRAu+TuIf3Bl4qy0S/msXCjzkIpExHT8+LmNsT38p6J2PHz7TvT+qj8Q
	LYbhDKeZ+jSJEqbSq0GcCVxYwCDNVTDiN18vFHO03aRkVJFmEbw3aEHVNoz9MdPPuvW1Dy
	CU/4YKILd4YgQ6dhiMhvGcN02EVPMxg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-XWXs8MOcMNa7wPunTzP5sg-1; Fri, 01 Mar 2024 18:58:51 -0500
X-MC-Unique: XWXs8MOcMNa7wPunTzP5sg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-36424431577so32257305ab.3
        for <linux-crypto@vger.kernel.org>; Fri, 01 Mar 2024 15:58:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709337530; x=1709942330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YlCAVuX4UaRN1aV/EeYQU1fnCBON103irv5ZBsuVOqI=;
        b=iUroZ8z/B0c9HZY2OV2Qw51c8FJq7Tsdin1FkZ82oqxopkD7lV2H78fKVOIeY9hP5Y
         njrj8BmZTXqtefbcTbLcBBK8YYHcWF4otKWpyo2Z0T1JqwuGJPSpkz+a9kzRkO01i3oT
         rngu5S2ZkyKHl4sCMRW4byPQKASAM18IdRq9F0RrNxBokwyC96PuDdq92VvXdD17Kwgn
         YG7D5r0YWEPtFGOy3Qqne/t0BruT8jZwaByjY+Rd5y9BDcGoa88JeTpYLpZU0mAMq7CD
         Ho6PGWMAxU2btMF4sTSv5/BHy9iezmFearWtUAFxPFpVlxn3fqHgHXqEVMhGYEuD80YF
         fqqQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/2FATyCNw54gA9fut1u8Qk2asrunk6CUD+A58nacNpT6aN5Wb9P8yhfyE/zDESlnypOC3P2Q73zXxJmf12RwTvM9Yfyu95MfMJSMS
X-Gm-Message-State: AOJu0YyxLh50+hyUXYo/Rk7zCAs2BwgmsfUbGIbSdk2F8A6WpI1mjhVk
	jOEqEcJYwZYCogphZUOpawhsDZ4IjCIAYiFC54TTYPyxf+WY2aPHiSZpcfWvHlSN8tpEAf1R5TE
	Ss1lv2RrIbkmP1bJZTYrjOLhnZ1esMzsYWrIKWjhq7DXV47rc1VCouG27QmEsTA==
X-Received: by 2002:a05:6e02:2164:b0:365:1b7c:670 with SMTP id s4-20020a056e02216400b003651b7c0670mr4106982ilv.8.1709337530257;
        Fri, 01 Mar 2024 15:58:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbRepeUVWR47zVjqTIDy6q8VcNd2j88dfXjLkatYc3K1nuWkkGOazRwHcZWscPqnqCuZazBQ==
X-Received: by 2002:a05:6e02:2164:b0:365:1b7c:670 with SMTP id s4-20020a056e02216400b003651b7c0670mr4106972ilv.8.1709337529949;
        Fri, 01 Mar 2024 15:58:49 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id y11-20020a92c74b000000b003642688819csm1177284ilp.69.2024.03.01.15.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 15:58:49 -0800 (PST)
Date: Fri, 1 Mar 2024 16:58:48 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: herbert@gondor.apana.org.au, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, qat-linux@intel.com,
 Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v4 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240301165848.37cfffaf.alex.williamson@redhat.com>
In-Reply-To: <20240228143402.89219-11-xin.zeng@intel.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
	<20240228143402.89219-11-xin.zeng@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Feb 2024 22:34:02 +0800
Xin Zeng <xin.zeng@intel.com> wrote:
> +static int
> +qat_vf_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct qat_vf_core_device *qat_vdev;
> +	int ret;
> +
> +	if (!pci_match_id(id, pdev)) {
> +		pci_err(pdev, "Incompatible device, disallowing driver_override\n");
> +		return -ENODEV;
> +	}

I think the question of whether this is the right thing to do is still
up for debate, but as noted in the thread where I raised the question,
this mechanism doesn't actually work.

The probe callback is passed the matching ID from the set of dynamic
IDs added via new_id, the driver id_table, or pci_device_id_any for a
strictly driver_override match.  Any of those would satisfy
pci_match_id().

If we wanted the probe function to exclusively match devices in the
id_table, we should call this as:

	if (!pci_match_id(qat_vf_vfio_pci_table, pdev))...

If we wanted to still allow dynamic IDs, the test might be more like:

	if (id == &pci_device_id_any)...

Allowing dynamic IDs but failing driver_override requires a slightly
more sophisticated user, but is inconsistent.  Do we have any
consensus on this?  Thanks,

Alex


> +
> +	qat_vdev = vfio_alloc_device(qat_vf_core_device, core_device.vdev, dev, &qat_vf_pci_ops);
> +	if (IS_ERR(qat_vdev))
> +		return PTR_ERR(qat_vdev);
> +
> +	pci_set_drvdata(pdev, &qat_vdev->core_device);
> +	ret = vfio_pci_core_register_device(&qat_vdev->core_device);
> +	if (ret)
> +		goto out_put_device;
> +
> +	return 0;
> +
> +out_put_device:
> +	vfio_put_device(&qat_vdev->core_device.vdev);
> +	return ret;
> +}


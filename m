Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF21205512
	for <linux-crypto@vger.kernel.org>; Tue,  1 Apr 2025 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523425; cv=none; b=aZQ5HaTqYgdOMixU6zF5IRv5hCxwrmDP/beCxx86Cg6dyfFaS7v9ySPCIgmhxWXG4bEMaf4c4OooTirjCfxJLEqqfkPO5yyYfpa7YQlZgvDZgU/U/s3rPxtDg408Mtpal8dDROmjSD8u3txvIuN/107D0FNpuy4A2xy6rnaolik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523425; c=relaxed/simple;
	bh=xnUsRAnCTM6iow/f/UCejEdDYoiWEl5F6w3kOCDrBoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFt/JWTEJrqCLR9eXwqAklRaNQzo37WsWPGfBwNuv7gBemRuLmHK/gCtVUltCeUA2XMB639ESvrSTk206+b0s5xSwSlY+EA2qIVRbYlXxTET3unutR2F6DfLPBsS+Q5ECdZifwcLAC97VYqlVXt7nTAzn97ZVhwgfTmkk0ryPh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VAWPmv2v; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VAWPmv2v"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7c5c815f8efso531977685a.2
        for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2025 09:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1743523422; x=1744128222; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HUIWAEN6Qyb8+Hz58OV+4wJouq5dad93BnZ8Do0foZI=;
        b=VAWPmv2vgdrgIZYQ+IyU5bPlsVeKFD8gZ1OyyuWhpXZg+GVLGzCoZV+rpDPC9KYwsj
         eG8Hkgj+vKSC4Efpo6oLrgBcs06tFYEYGMYoGFzyiVCyuYJAZzloRsYqtWUFAVRoiu5p
         UvBkkCsBPfX2zfz0UdP+0+h/GaNkbPSupRBY3gFWf1/dnmVx28rTHPb9+l4KcuKiyxab
         s5amtKNg8muf/FpVkWwJifWQa4cpZybl1Z6l/mZih1fZ8eX2h5O/le7dfsytwOl3IVBN
         Zl4WI5kg/nStRH9f9pPMlPtUiLi6IhA5iuHYC+49a3UlL/gervngmrw2l00kT77FmqYP
         MbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523422; x=1744128222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUIWAEN6Qyb8+Hz58OV+4wJouq5dad93BnZ8Do0foZI=;
        b=aAZJya6cBrTRXW6EKFM9k4s8lPfQgrMgEmfhglAoIU5PafO0N7GJBUTiimTgbZ6sQp
         6WeF5eT84wbsauNxyYeJGR+swh582IX56sQ9SKozxwLh0NRlulBXpMdGgdiKJtKeAkzm
         OAtyEb/QVFiGYI4lxjp2tnBVpmoFW0DpC7ceipZBAI+IFBeWkEd7EWnrbVMHXvQfpOz/
         Pq8F7JGCJi7ysUiFj6vajXAQjnSGg/3morw5xKAyNAT6tRbWgcsEaBXX6vZabHKmvgWa
         LKf4xxjIbdFO/M13Q2mtJHl2siACgtCU60wP7CBPjYpLQ7bhpjUBpX1c2boG0to+uMNU
         OijA==
X-Forwarded-Encrypted: i=1; AJvYcCV5UHTnJ3EpZS7XohoxcJvLO+4ZpW0mPvEEKlgj+6WO/rxR1NSbvKncus8xWNP7pojA57S1ItKqyGiIPHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKI4l3tV3EBu/dXNO2BRbAE2UrOc595MyrbRpOv77MIimsWEVO
	gAzhQwGaHOn6Cn8BdxVo2RGRgJJ828NPWFqhNDrHKv7x/VT18jg69LTswpjB9mw=
X-Gm-Gg: ASbGncuFS4nBdDC1TmclgJHElNglfHYtPWAeXmcBLrU2Yq9daaKKgVRFlra/LZGXpuX
	/5MFR63SBAyLQW+EqaSvsIcfrM8ueDt26A4ijmpzD2WfQcTYjf4j/dZHdJ5ED9uSFKIyG6vwm2v
	qVbRsyLGyifNW5dbuda5ST9H2J5yaCFNftlTlXjb4USrn7UoJA4X9uzlD6aMEJTPvHe0cJZxmJy
	DZJOasd00MGcCFl2WzZX2xflVfjsF4HzIN3Auh0oJM7xtkC5VE4LfF91q6hRCx7p59AT6pAt8cr
	n6uYEMIthSOWdmuWBCw5Kvv0UZ/XHquO/bvQFY/6HQN61/rnYBTG3g2xmIPIVzorUfw/pl0ARXq
	nZGhQ7sjEXkOdPGLr0w6ZXcc8zo2B/OJ7/g==
X-Google-Smtp-Source: AGHT+IEK38CnaMLkGKnp6wFhyTba4uVPU2YkYY6SqmlutfADek1SIeamjKZM91laT+FptTnOqcHgWw==
X-Received: by 2002:a05:620a:2551:b0:7c5:6045:beb7 with SMTP id af79cd13be357-7c69072c8b5mr2068616685a.32.1743523422038;
        Tue, 01 Apr 2025 09:03:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5f77802c0sm673482385a.104.2025.04.01.09.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:03:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tze5U-00000001MIe-3oUm;
	Tue, 01 Apr 2025 13:03:40 -0300
Date: Tue, 1 Apr 2025 13:03:40 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>, x86@kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-arch@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Christoph Hellwig <hch@lst.de>, Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	Lukas Wunner <lukas@wunner.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dionna Glaze <dionnaglaze@google.com>, Yi Liu <yi.l.liu@intel.com>,
	iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>, AXu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v2 14/22] iommufd: Add TIO calls
Message-ID: <20250401160340.GK186258@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <yq5av7rt7mix.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5av7rt7mix.fsf@kernel.org>

On Fri, Mar 28, 2025 at 10:57:18AM +0530, Aneesh Kumar K.V wrote:
> > +int iommufd_vdevice_tsm_bind_ioctl(struct iommufd_ucmd *ucmd)
> > +{
> > +	struct iommu_vdevice_tsm_bind *cmd = ucmd->cmd;
> > +	struct iommufd_viommu *viommu;
> > +	struct iommufd_vdevice *vdev;
> > +	struct iommufd_device *idev;
> > +	struct tsm_tdi *tdi;
> > +	int rc = 0;
> > +
> > +	viommu = iommufd_get_viommu(ucmd, cmd->viommu_id);
> > +	if (IS_ERR(viommu))
> > +		return PTR_ERR(viommu);
> >
> 
> Would this require an IOMMU_HWPT_ALLOC_NEST_PARENT page table
> allocation?

Probably. That flag is what forces a S2 page table.

> How would this work in cases where there's no need to set up Stage 1
> IOMMU tables?

Either attach the raw HWPT of the IOMMU_HWPT_ALLOC_NEST_PARENT or:

> Alternatively, should we allocate an IOMMU_HWPT_ALLOC_NEST_PARENT with a
> Stage 1 disabled translation config? (In the ARM case, this could mean
> marking STE entries as Stage 1 bypass and Stage 2 translate.)

For arm you mean IOMMU_HWPT_DATA_ARM_SMMUV3.. But yes, this can work
too and is mandatory if you want the various viommu linked features to
work.

> Also, if a particular setup doesn't require creating IOMMU
> entries because the entire guest RAM is identity-mapped in the IOMMU, do
> we still need to make tsm_tdi_bind use this abstraction in iommufd?

Even if the viommu will not be exposed to the guest I'm expecting that
iommufd will have a viommu object, just not use various features. We
are using viommu as the handle for the KVM, vmid and other things that
are likely important here.

Jason

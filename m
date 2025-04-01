Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1985421A437
	for <linux-crypto@vger.kernel.org>; Tue,  1 Apr 2025 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523903; cv=none; b=MsmxChW/NM3axg+aPmp+9wa/aRt98RxN2FwBXFmsaTAAtJtRMH2N+6oB3LvnGCWV29OB8AxbSoE69+KUD1l2F63A9bVdfThMOZDLJ95bqn5N9FJmOJ+abYxn/87yaUCGjd9S02SsCaIHAUGui8M7KJB6Cum5ZAGN9ILDKHZXoHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523903; c=relaxed/simple;
	bh=0bfnfRwxd83qT6YHXSQ35/Sc5Ii17MOf/lTvNc4Gkxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usPSkiF9Yj7slfS/BU+IfB+oAxGeu8uDB4wJa6DWY/MqYGUHKqQKad+nIigRed1NtgYbhdaRo74AZH75Ror11vgLo4x3xkmn2CsAYaRVzUpjJxTd31cteZ1aDbOjGTeofwIK/WVe/xeB6eqFmmUffq28Uo9W3axq3/dijkUGYBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=lDnUmh5L; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="lDnUmh5L"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-476977848c4so56649441cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2025 09:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1743523900; x=1744128700; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ht+/cjgqGqzgXcB/qQp4vlm60uUPBRIV+JZ12u7d0fU=;
        b=lDnUmh5L+0rCze4HHaOY0fInhE2/g4OqB70O4lroUA66m4berrddssMHgXIfslNESy
         C4hfoVX0sS0Ze4HunAg/LvTPqunpMT1UZOLYuOXxRI40B1VjlFIOHheEFEtAtiMQAJY8
         2jvJlMZ9GF/WJn7VoTDSlhBdM210lL0c2n9LdArDdhYtf48EvNbgvb19vva8SFzBCxOE
         Iqkd6NI5Ae489ogm6T5ittm5N2Y9bHE+jdnh/7iSPprDhI18kSDd7h/yl2DiOXOYf/GX
         qy2NlTBZDOzWV1KtmR3NlYhkSac5+1sQsNKsqHMaYb5ADqRT9eb1LH2fFjLywbm+CWhP
         ipRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523900; x=1744128700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ht+/cjgqGqzgXcB/qQp4vlm60uUPBRIV+JZ12u7d0fU=;
        b=OLfFq7rCBAcYZHvhn3GwHY50TrvvOArQytSudPONTDq8IuTnNw89fU6bJ6PozRnrI4
         UQUkEP6+Lb3ojczXl0fZFJ5tAhSM0+sljFoCcmLXrvL2BLnP7DLwTrQCLVXLrrt0JD6Y
         tO7qYsreBLqdjdTK6uzZGIcY70EdaiHYzyfqzmWdpI1FA4EA3kZ6jMy7arNIB2Sc1x/P
         SsDZMzyWTolQ+g0nOuowmBIWxJ0EYK4r0n1g2ofLTvqcJCRNCAZOznI6QS5AZy9LUwda
         DYxl9dPBo+wHWk506GxzFyWUX0K5KqbxkQyo4yclSM13V1KlgUYs1HvQUmz3ou/S2eTg
         mr9w==
X-Forwarded-Encrypted: i=1; AJvYcCWIElEHUmEk5X3VKqO5ZElrkq0LcxJKkJ+GycM5Q7Op8nXaYMt/g2t0ABLuHp3+Wc6+AKI5eU9P8dcFJB0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrkMWNU5Sqwrqi/SvjGQyl5e/YgWqY+aZF08KgyOAmNphVgZuG
	FwaZRe2Oiom09NJc7ACl2+tPxhJLz8BxIWoZXxxzBTEZYpXQjQxr1plEtaqw4ts=
X-Gm-Gg: ASbGnct9BgmzFd9NUqOcgJfHrflZwdCJrBFXwHEM4HZKhPcYnhh+Tom032m3WgtDICW
	HAeMbicTUbCZreqtKSpFseEVWcK8hS1jt4H7hssypffWnzzPH096BPC5c9O/Gzi0gLWvYzSY4uh
	3v53xY7TLvnWzt+c9FLhAvQex7Qx1qYfjgLtkU8OYeRtybkijgbzb96FE/TEqL7RXwuiadhHqo4
	u7h5eDI1Cs0Jp9Wgg9Qfc6//2g/cwP5ayTy6EBa1Jf2a3r5VaoiARukFomTDfBAZxXMGUsmbd/k
	XHKdlqT9aHiZg4QTtdaDcqlz6ATS3WBi36aELt/R1kSyadD4kqJeNt52bbAytWN95l5CUB6bWnE
	HXilqKqydIA8DoEBzJ+Ff/OI=
X-Google-Smtp-Source: AGHT+IGqQTmKBPGxEDnar5cvqd0kVzoGqHi3v/f2hQrPfOnvCsqaEdb1Xw9stjow0mGeS+auqOd8Yw==
X-Received: by 2002:a05:622a:13d4:b0:476:ae71:eabe with SMTP id d75a77b69052e-477ed779bf5mr236227621cf.50.1743523900002;
        Tue, 01 Apr 2025 09:11:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47790ef0976sm57062041cf.59.2025.04.01.09.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tzeDC-00000001ML9-3rkm;
	Tue, 01 Apr 2025 13:11:38 -0300
Date: Tue, 1 Apr 2025 13:11:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
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
	Zhi Wang <zhiw@nvidia.com>, AXu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH v2 13/22] iommufd: amd-iommu: Add vdevice support
Message-ID: <20250401161138.GL186258@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-14-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218111017.491719-14-aik@amd.com>

On Tue, Feb 18, 2025 at 10:10:00PM +1100, Alexey Kardashevskiy wrote:
> @@ -939,6 +939,7 @@ struct iommu_fault_alloc {
>  enum iommu_viommu_type {
>  	IOMMU_VIOMMU_TYPE_DEFAULT = 0,
>  	IOMMU_VIOMMU_TYPE_ARM_SMMUV3 = 1,
> +	IOMMU_VIOMMU_TYPE_TSM = 2,

This should probably be some kind of AMD_TSM and the driver data blob
should carry any additional data needed to create the vIOMMU that is
visible to the guest.

> @@ -2068,7 +2069,18 @@ static void set_dte_entry(struct amd_iommu *iommu,
>  		new.data[1] |= DTE_FLAG_IOTLB;
>  
>  	old_domid = READ_ONCE(dte->data[1]) & DEV_DOMID_MASK;
> -	new.data[1] |= domid;
> +
> +	if (domain->aviommu) {

AMD should be implementing viommu natively without CC as well, try to
structure things so it fits together better. This should only trigger
for the CC viommu type..

> +		/*
> +		 * This runs when VFIO is bound to a device but TDI is not yet.
> +		 * Ideally TSM should change DTE only when TDI is bound.
> +		 */
> +		dev_info(dev_data->dev, "Skip DomainID=%x and set bit96\n", domid);
> +		new.data[1] |= 1ULL << (96 - 64);
> +	} else {
> +		dev_info(dev_data->dev, "Not skip DomainID=%x and not set bit96\n", domid);
> +		new.data[1] |= domid;
> +	}
>  
>  	/*
>  	 * Restore cached persistent DTE bits, which can be set by information
> @@ -2549,12 +2561,15 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
>  {
>  	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
>  	const u32 supported_flags = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> +						IOMMU_HWPT_ALLOC_PASID |
> +						IOMMU_HWPT_ALLOC_NEST_PARENT;
> +	const u32 supported_flags2 = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
>  						IOMMU_HWPT_ALLOC_PASID;

Just ignore NEST_PARENT? That seems wrong, it should force a V1 page
table??

> +static struct iommufd_viommu *amd_viommu_alloc(struct device *dev,
> +					       struct iommu_domain *parent,
> +					       struct iommufd_ctx *ictx,
> +					       unsigned int viommu_type)
> +{
> +	struct amd_viommu *aviommu;
> +	struct protection_domain *domain = to_pdomain(parent);
> +
> +	if (viommu_type != IOMMU_VIOMMU_TYPE_TSM)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	aviommu = iommufd_viommu_alloc(ictx, struct amd_viommu, core, &amd_viommu_ops);
> +	if (IS_ERR(aviommu))
> +		return ERR_CAST(aviommu);
> +
> +	aviommu->domain = domain;

This is not OK, the parent domain of the viommu can be used with
multiple viommu objects, it can't just have a naked back reference
like this.

You can get 1:1 domain objects linked to the viommu by creating the
'S1' type domains, maybe that is what you want here. A special domain
type that is TSM that has a special DTE.

Though I'd really rather see the domain attach logic and DTE formation
in the AMD driver be fixed up before we made it more complex :\

It would be nice to see normal nesting and viommu support first too :\

Jason

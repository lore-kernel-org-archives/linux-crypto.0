Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE23820E035
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 16:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744044014; cv=none; b=rC90ASy0v9M11jWJVVH6XLpAP5jnY0JJ1lmo0O8YkHLhvoyTryOS6WH9PfVIFI3iiiHmtY+Qs6iCnBraBuGj715tVrGP7L7NziOA2SOK1gMQVpNECAyJ8Z24HhX+IROseMA9ZUA6WLlnlQvk8d0D6+66NTdlkmiipRywHXJXt7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744044014; c=relaxed/simple;
	bh=xekbj8Um5XwrEOGdzENZPa2iQeQhDeMvkZT0NVb5BK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oaXo2itL94HSIvQAeL50NqOhl8+guccULxAbgyk/fgON6sGoHlQbrYLclAnnwXDvN/e4brrkkIqq95HUm550g+FoYek7EE1tGrQvrWFdUnxYmV3LzGm34f+01iXak4jhQvQEhWemIekrfJPcsMVRrRRYqE7bBmdAbgWl50tCoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=C1e9a7Rl; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="C1e9a7Rl"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7c5f720c717so584326885a.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Apr 2025 09:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1744044011; x=1744648811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KVaiHAMacLy0yHf6meYzZ4WkOGggIQHdshTAyck4dh4=;
        b=C1e9a7RlDnHM1HSLQZ5q8CNKgVYLTqgByhvy9WMxUJRN581QJO0J+rvZli6pcgyuMe
         5x/L9DLnre5qvLPL5k5U9nmgJHaHr8q9l1/zwNTnFpGVRYulzqA8D4D/OXVoMOxkDgdz
         vNsIxXM2KegZvo48VvlijiqqbTA7Dfhy/dkzRA6yp2EAAnp6x16CF3JkwqsD44nLtG3o
         FsxD2OY/lGWRmlsYbVwcbPTKuAhsUyE10NIZ40gkK8l4dwIjH+fcSTybgCImC74fgk57
         rGIff4B4Vn0IHEYEv+B4NXhPIYkaPyW0kTvRsSciPf4oXRWlj0J7czCO8jjf45rgRLKh
         9wbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744044011; x=1744648811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVaiHAMacLy0yHf6meYzZ4WkOGggIQHdshTAyck4dh4=;
        b=sNBMbCTeVYda/12MmzjMO6dE1fhAJ0QxWD1Hi9TeF1bFKBlcmjT7faxQBjqZOAtAV7
         kLENExneWUCys4in72fcmITIwjY6mbOT/biDeqkISgd5BZwP8YZ4O1M5cSwUWs2GadjR
         Mj1/iKuL9VSowPngYFxLT6IhNZerQV/MKCKenq+23M1OsyHfmQ1Jm3hzlXlP2B11M/4R
         YkNRBDp7Hh8/RtYKdxBg/7d0Esq00STsuDeGk/4Jj74zj4+gzO1KtweODW6B01nBUuJ3
         +518vNo25BAYmPfFm8C0zkS0uRoqVB7Qfz9rrW5HXt2NOYEtoruBXRznGWccsEAjFbfI
         yJjg==
X-Forwarded-Encrypted: i=1; AJvYcCXv7D2UeEzlacaWaS4kxJyJbiKABsVeuZH2ZqlF8jofakBhYoq9kMuEkxAcNrFqh+EUrlIQhyc2zxeyFGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhfMcEZoEQtF74deBd0TJ/93RC78Eg0KOMQnjuOMYxqU3TXvcA
	nPG9dijHlYy/6Ym9/UyBCRnoVvLUjb0PlvZfU1UVKNSBdtMgTJpPnqvW4xZhIU4=
X-Gm-Gg: ASbGncuLBddhBETCoimwOUwtMH5N1gTwSPNy8/haf8KtI9yEl/LTvjuwz/yxjqcL2kk
	v7pVzG6DgFqLU6zHFDEOgDzM5xjvSYMtdGAN0Q+ZmF1zAYy98HoLIMpz5CMYmPgz6kNnTi1UIYN
	s33YeQQADMx7MOLP79ZZgfHapd5ijGo6PnBx98ZP3KEr0s51dbXnj339yf/+2Yf+4ioi2n8mR8t
	DebIHP0fDaMqi84eOqKKSxAcMMeY5H3eANZxEEkontKqDk4NXvAcYQjsy+FRmcUOpnlwfvxwujB
	v+pH2RIF8lK24CNSm0sNkmygy9kPat8m2veg84QRCumC3mhbBOTqkR9bS9+zy3KhkzwM8cnhMKE
	Xrpv7JgKPZjMl9PxmyoL6fUQ=
X-Google-Smtp-Source: AGHT+IEFf/klcawRT/DLAKNVY/s1kWSMw+u/XuSys5u9G30IOfriJNNXl5A9JC2j6VoZritBscM43A==
X-Received: by 2002:a05:620a:25c8:b0:7c0:ad47:db3d with SMTP id af79cd13be357-7c7940ba2a0mr22422685a.21.1744044010744;
        Mon, 07 Apr 2025 09:40:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76e96e870sm618914485a.60.2025.04.07.09.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 09:40:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u1pW5-00000007DRV-3Cjz;
	Mon, 07 Apr 2025 13:40:09 -0300
Date: Mon, 7 Apr 2025 13:40:09 -0300
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
Message-ID: <20250407164009.GC1562048@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <yq5av7rt7mix.fsf@kernel.org>
 <20250401160340.GK186258@ziepe.ca>
 <yq5a4iz019oy.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a4iz019oy.fsf@kernel.org>

On Mon, Apr 07, 2025 at 05:10:29PM +0530, Aneesh Kumar K.V wrote:
> I was trying to prototype this using kvmtool and I have run into some
> issues. First i needed the below change for vIOMMU alloc to work
> 
> modified   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -4405,6 +4405,8 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>  	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
>  	if (FIELD_GET(IDR3_RIL, reg))
>  		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
> +	if (FIELD_GET(IDR3_FWB, reg))
> +		smmu->features |= ARM_SMMU_FEAT_S2FWB;
>  
>  	/* IDR5 */
>  	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);

Oh wow, I don't know what happened there that the IDR3 got dropped
maybe a rebase mistake? It was in earlier versions of the patch at
least :\ Please send a formal patch!!

> Also current code don't allow a Stage 1 bypass, Stage2 translation when
> allocating HWPT.
>
> arm_vsmmu_alloc_domain_nested -> arm_smmu_validate_vste -> 
> 
> 	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg->ste[0]));
> 	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
> 	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
> 		return -EIO;
> 
> This only allow a abort or bypass or stage1 translate/stage2 bypass config

The above is for the vSTE, the cfg is not copied as is to the host
STE. See how arm_smmu_make_nested_domain_ste() transforms it.

STRTAB_STE_0_CFG_ABORT blocks all DMA
STRTAB_STE_0_CFG_BYPASS "bypass" for the VM is S2 translation only
STRTAB_STE_0_CFG_S1_TRANS "s1 only" for the VM is S1 & S1 translation

> Also if we don't need stage1 table, what will
> iommufd_viommu_alloc_hwpt_nested() return?

A wrapper around whatever STE configuration that userspace requested
logically linked to the viommu.

Jason

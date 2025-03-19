Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FC61DF747
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 17:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742406062; cv=none; b=YLK79f4q7S1ZzAYKpt+tWUrUjATgCZlrM/aRtr3o/vdVD6gIpsu9IA0t2+sbTl0yBGHChXUqMvChCT8NZe0rUBYayOfSjIXkGdR8/waGECReSrQHGwW9RtgmUZgN1WE4HmierY5Je+XN+AIKzF9mUTxxQEqC6N5tOwHNP7/gd50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742406062; c=relaxed/simple;
	bh=Uup4ij0e3QxR7P+2AXE6ojI6gZ035al5TOyCCZJD8FY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYbyoeCmcFgrcqmNVGS10k7LMYVWz3pJNfbN1QNoXgoyh7uHPGoXf0aRFdSBpb5MJhFnLaYIgWrqcxFHPL7uzqJ0Nrv/gKPOsyxo5sanPdKp1ep5nEe/ehryfQYnX/Vc1vH1RQf9tvuXLM6UQ9ZC5j1UVyfKVkgrzYi2bJvCQ+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=nV/VpToK; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nV/VpToK"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7c597760323so240241885a.3
        for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 10:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1742406059; x=1743010859; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=leCUW9KEkZQcVeVok9ACFyeDj4RZoftXqhcJPMWCJYU=;
        b=nV/VpToKK1Aoc35hYasv8EBUTMZK3YWljurPD2RE8K95jFcoCmONYbBpbib1QPyFbd
         zSv/Fnk+PNhWJ/yPZHfQrWxfNZCut2KGrxd3hZas9X5TZ7EXb7a/dokHKpxOytAT4pQ9
         gfeyNgK4YiJtjD06hxgzxo38t1AVC0Vdkwe+i1EL1u+f4qzlchDtmyVqmWb5xb9CtAnf
         CMt/PYJWppWD+Yuqh6qT9h2143TT+qM7QypYtCpfyJf8bTECAWu3m0vRYjgL+whCaBCP
         +g+MkRpdKaz0uAvhepSHNFG2+jIm5/kc50U3IlZji0KHpX/QBJGLS8rOlfY0KbgUMJAR
         wnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742406059; x=1743010859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=leCUW9KEkZQcVeVok9ACFyeDj4RZoftXqhcJPMWCJYU=;
        b=RlRheqsC3VVjerLw8hfwG0/pAxcQ02oEJ7rrWK1H4ta5VSN/dvjtzn7DqqqcDGmstR
         gXmk2xR7qQqbs1ijeyyK+MrYdd/480EOyZCJEhz1yFgd9Eb+c5VFfGFa8VTBDM3ljHpV
         jBTKpygfmtDw+Qa8b3+nFZvO7ggPyD0lKwlCzzy6Sidr4NXhl6rrhRNrPUqcDbbRJRFP
         SWW2JnFukxLLmDGJExYxwLBfeqJLR69HfS6k6sLdGeEzR8SgLsYABQ13Os5H0u2UBLDJ
         C685smlICe8xvvCsNSCEyAoeaKVBpOGxcyzpgDIOe1FzT2rSYyobqLUYE99QphHKdKeG
         pc2g==
X-Forwarded-Encrypted: i=1; AJvYcCXSDU2Ky4QNIMO9yhEODj2+lZFVePe834zLjt8K4hHP1aLQaF+qTf3nXUcnbVBu8wiWF++tJk0bwZ8tEd8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9oOWcs5cloY7QHH/khfhlbMaAnwyDXyq9eN+cicCIVlAEe6yw
	AoKuJ9/Ej0eCVAyjNxoGGSizc6cCA2qv80iSgszzIfDGDBexM7sTa4lSVsd4vaA=
X-Gm-Gg: ASbGncvdOVYa/MDqFdXVMfjhDmUk+q3tVn+YIadcl/sF7Ub5Zyiix8MW78YrOTcUGjo
	eHITq65wsa76ZYvjaDPmyEVuusb2b+aN8PDB2o7t2ZuXItFTuLX00kBxZtFnBPkH4l3FrPn3BCF
	i0SYa4fyw+V70tQrZZair98lTeQf1+jQ10TxVZ7XTN7/J0TZ7In6KAyrfvkDxvU6rG4uLwzUmnv
	In78Fqa3rb735NKKtoJnSVjn98jDfel+e1ChsqKXHGAzXJjzDlXBCkSc+JxqhH6pZiTHab9CIro
	al4DUAFmxjVyuVmXqvXQtfnXN9ONooQiu12qyHGLqQLl3jpfTkgtSN34+qqV93Lth4QDYL7Nd4S
	O0vsaQQV2digWXDesVN2LRy8Qx7GT
X-Google-Smtp-Source: AGHT+IFoJAQ9bGba/Z0yZg+D8yG6xp2ytZSUuDU+bbhNp9w3ofz/kSX0XQcOY4VVJjVXQ+26hrcvHQ==
X-Received: by 2002:a05:620a:57b:b0:7c5:6ba5:dd65 with SMTP id af79cd13be357-7c5a84a3654mr479964285a.55.1742406059344;
        Wed, 19 Mar 2025 10:40:59 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573c4dd2bsm884915085a.14.2025.03.19.10.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 10:40:58 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tuxPW-00000000WcK-0irF;
	Wed, 19 Mar 2025 14:40:58 -0300
Date: Wed, 19 Mar 2025 14:40:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
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
Subject: Re: [RFC PATCH v2 12/22] iommufd: Allow mapping from guest_memfd
Message-ID: <20250319174058.GF10600@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-13-aik@amd.com>
 <20250218141634.GI3696814@ziepe.ca>
 <340d8dba-1b09-4875-8604-cd9f66ca1407@amd.com>
 <20250218235105.GK3696814@ziepe.ca>
 <06b850ab-5321-4134-9b24-a83aaab704bf@amd.com>
 <20250219133516.GL3696814@ziepe.ca>
 <20250219202324.uq2kq27kmpmptbwx@amd.com>
 <20250219203708.GO3696814@ziepe.ca>
 <604c0d0e-048f-402a-893a-62e1ce8d24ba@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604c0d0e-048f-402a-893a-62e1ce8d24ba@amd.com>

On Thu, Mar 13, 2025 at 03:51:13PM +1100, Alexey Kardashevskiy wrote:

> About this atomical restructure - I looked at yours iommu-pt branch on
> github but  __cut_mapping()->pt_table_install64() only atomically swaps the
> PDE but it does not do IOMMU TLB invalidate, have I missed it? 

That branch doesn't have the invalidation wired in, there is another
branch that has invalidation but not cut yet.. It is a journey

> And if it did so, that would not be atomic but it won't matter as
> long as we do not destroy the old PDE before invalidating IOMMU TLB,
> is this the idea? Thanks,

When splitting the change in the PDE->PTE doesn't change the
translation in effect.

So if the IOTLB has cached the PDE, the SW will update it to an array
of PTEs of same address, any concurrent DMA will continue to hit the
same address, then when we invalidate the IOTLB the PDE will get
dropped from cache and the next DMA will load PTEs.

When I say atomic I mean from the perspective of the DMA initator
there is no visible alteration. Perhaps I should say hitless.

Jason

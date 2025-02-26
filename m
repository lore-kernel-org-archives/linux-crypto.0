Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B842E42A8B
	for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2025 13:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740575288; cv=none; b=eGyTQHeP0jhhBQHhaBbVw9fOFBN849EFfiHF8F+dYlIGc4dcrNoUtf0i7Kyckd3Mt4LLwkKN9HEDil3J56b0oPBMDJ4fyGiI2CRWByi9lBb7sOJ3BSdKWsgSD4/jqFC+J+BAS7jiQW0d307tT/soujWPwa+U0iIB6AdPNPxjhcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740575288; c=relaxed/simple;
	bh=gZlf2V4DZl06PCel9kKPigzKNxKnfgpO2YLnb7fz6Tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgLrExG4RD7ZeWH3HZ4cQoAraeHGTNgDXw1pSMqb6EvkObw0viDx6HOw2WETfmqNaJGkiPD1z+kdXEG3GH+p0iJLgbUefebGjoCtnBW9n9gYG3TS3rPdsSp6iIO8d432CzkRDP18mGsAWZxodCdhfDDCZgiQldgRw2Ofj3tpwYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=T/QbiIKv; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="T/QbiIKv"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7c0818add57so683993785a.3
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2025 05:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1740575285; x=1741180085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ECSFx2fiYRGYbPUPOKEj5uQjkNpa71sMCoCExCmYew=;
        b=T/QbiIKvtcqcqQSWAzZogMWpsvqW+MI/HTEr2rnGR+RwQZ9gmuTns4FjikIKYrcMze
         4FJMlwQCBDA+2A++4l1iyFsZYKWksJ55MgCltjETpB4KXpMP2UB+UUdUr4JoNrxVpNt/
         ELA1o4PGTsQmKZgR77zNp8cVXLbpRGexH2ALUw/bkZ+arvQw+JoETdEeUG2bLQ/wIITc
         fiLAcA65IEtHSJ/NA0jKRPWwTHgQyPhNVJ9V1BZTXxvoMn2S6pN4DaauGRgO8LlqJGVm
         a77QBoeHa0ihVuzWgR0h+w8mUy7w83ixeRqFPZaVUu8Oe4/BkxuzBv2ZajAEDbYKcmzo
         OBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740575285; x=1741180085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ECSFx2fiYRGYbPUPOKEj5uQjkNpa71sMCoCExCmYew=;
        b=pX3WpvDS+bxp+nA5/lJ1D7AHze2VbmLbhSMh+xsGtV5VDGZOU/oQru0pBb/UJtZc+c
         bmzR2Ci6FfnD5xQaYZEdPCScDjenbFQXXgNu+awNC2rg9yfi1BY+XS3f2RqwoiJmYYRi
         FdJiKi2X8C9ok7HGy9TOBA18Fe/JcU3ul1HoGh+4Iqe9t+UHbT5wlFNcKZBg1bYR66M9
         fyjpDEYgP9exe5+gSrQkq2SzIFRTqALsXrUS04gANFJ47Br+AxtMPXki4U+d7Qx766Wu
         iBT9EpiVkvE01YetnP1oBRPiXD8bjaIUEOz6QxhJJIVACVL48myXlwpntxjkD2DNZcpZ
         PafQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFPYll4rsVIbBAmfgDzJqSzodNt8arLS6E5PtnZe+/7ObchCplpnkZy/js5yBYJCke7R3XLSxZkynjbhA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfG/UyZWhQ1b2xn6pgzxFwVs3kwxKFu4lNqpo0Wu9Dyu8rHbLq
	JAG8igR+Alnaa4q9q1I6UncQXFU/3C5o/GKl3tP76wShxML6GUYIaD4OKjTzzrcdEcTwPi80KAC
	n
X-Gm-Gg: ASbGnctoXh3kO3Pz65d/9LWemToNeBdI9epaorEnVGPLMVBBzpgw1i+w6zkJS/3Ws1z
	VMIZ54/1EQL4wdUicocoaxULx5BrpT/2ArIT0siC/TeXxQOa3UBbE8Pp3pnsNTTtfjxrgpRR3uj
	DJvgixfFFhxwr4HywZsjyMZmkczaJGwkWJlHJH7YkM43ioLxSGs09b64ueCmh789T8yC+ao42n6
	qN8GuVEVTkJrhDhWCEOKw/6PdD6isXROyoLeC42MA6134wWMi0ZVWz2Rzi0y3uZmuTUJZcGqfwV
	NoPNkJsKKhNkLo3dQaJdFZZL2RdgnRSDFgwoPBP7oF4hmi/K18FAAGaOFksz49FMb1Jn42I4u/k
	=
X-Google-Smtp-Source: AGHT+IHSaPI2di23wd/r7DmUcJvEuSIfSDJiLalxe/seFWwJNz69RZ6l150d7LgWyVVQcH9URorRQA==
X-Received: by 2002:a05:620a:44c1:b0:7c0:c650:e243 with SMTP id af79cd13be357-7c0cf8ea459mr3058987685a.30.1740575285615;
        Wed, 26 Feb 2025 05:08:05 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c23c2c0fb4sm237968885a.56.2025.02.26.05.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 05:08:04 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tnH8u-000000007Mk-0RRT;
	Wed, 26 Feb 2025 09:08:04 -0400
Date: Wed, 26 Feb 2025 09:08:04 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>, x86@kernel.org,
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
	Zhi Wang <zhiw@nvidia.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH v2 14/22] iommufd: Add TIO calls
Message-ID: <20250226130804.GG5011@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>

On Wed, Feb 26, 2025 at 11:12:32AM +1100, Alexey Kardashevskiy wrote:
> > I still have concern about the vdevice interface for bind. Bind put the
> > device to LOCKED state, so is more of a device configuration rather
> > than an iommu configuration. So seems more reasonable put the API in VFIO?
> 
> IOMMUFD means pretty much VFIO (in the same way "VFIO means KVM" as 95+% of
> VFIO users use it from KVM, although VFIO works fine without KVM) so not
> much difference where to put this API and can be done either way. VFIO is
> reasonable, the immediate problem is that IOMMUFD's vIOMMU knows the guest
> BDFn (well, for AMD) and VFIO PCI does not.

I would re-enforce what I said before, VFIO & iommufd alone should be
able to operate a TDISP device and get device encrpytion without
requiring KVM.

It makes sense that if the secure firmware object handles (like the
viommu, vdevice, vBDF) are accessed through iommufd then iommufd will
relay operations against those handles.

Jason

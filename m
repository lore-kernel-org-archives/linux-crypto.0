Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E4233985
	for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 00:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740013052; cv=none; b=jg0KwB23yrRxjO7Po0d2wjHeV7vKygxRCi8Ef8XMB1MViQM04buquI9bqfZKc7GAhRwc3PVBapLZ/DPjH3MaBi1M3XocIuJmJDDSMaRTzAjZtC6p+H8IiZrc5yWrMgpM0740fIJFwHoKo1tQ4Cabseg6XlgI4fTED0pT/BnnE1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740013052; c=relaxed/simple;
	bh=Lnj8ZPF5lrE7Xc/uMpcIj9FkYaJnkbOF/02TZqJAndk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFouicNriPYfCuNab9zfHis7MGLQ48z9D/zCeDe9YOIAN63WJ1GRUokCoMKisMZEUs5iZwQzqwmKfWMaX/CpU1sCaVa6vNxkPY4c0H2CTcy5/LU03P+GJL+5QbLTzqE7s0s5DNGAaWruDwpEZhpvaQfvzASz9huE+AG84F+CN00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=e8WDMlVf; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="e8WDMlVf"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-46fcbb96ba9so5006781cf.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2025 16:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1740013049; x=1740617849; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0/Q3pmbQgFaUMEz//cVYqBy+kD1niHA/UXy9NuQBpQc=;
        b=e8WDMlVfE5yxeWllC+GQsVY5Fcurb8PVVRLHcsL72GNWikAIAyXRdKLROdZjblWNlR
         wrcGOp99vmw0hE+MAEjtnkHQwpXYmsG6WMuRR/9L1MwFX9F0HitATK7ux72o08XVDR7h
         +l51hpxLMbptyGFfy6ln9NGior+w4ObgMcmDP88d60O8P2ByBv29QfgB7+Ay/bFR1Ydt
         P7bXM6RQcCwotY/6a1V55ZbmllEGtjRzC/I3pW3tzBFkh2xrha9uH2o1BbWRLjnGCQoJ
         YPxbnuMBnQoSM2qL4qGcRCYX6moS7UTTgzvshw6St5sKIr8Yw7CcxO197shj5vSY5xq0
         q3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740013049; x=1740617849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/Q3pmbQgFaUMEz//cVYqBy+kD1niHA/UXy9NuQBpQc=;
        b=cL+Vdk+s2ttxOLGssEZ3g+EcULp3d3WC7a6rohamA8dQIERVWri5kfhQG24GvDngnl
         XrwozMAn+Ky9LRrqMEKUusIBtlTTd8KwA2SeJnrufoXlCzBI6mGiO4qpPrKAye2o5luu
         O53A2bRia3M/IiemnP6Z/BgJ6GyNshwchq4OI7zGRP/rwaCftjTP9v1hUzZLqCQ0ktr6
         mUdAUlxcZsPiPHzlUUF3IRgoMKmVub7K+JYSFWvCKChX6GZKAKZ8Pf2tZLJoG+SubXKY
         EBD7e5I4XARt7lmupVwy/afFEvmfddV6/q1JGEqyrJbVaqZj/Sp97XQCfe5Of2NCYtYV
         7BGA==
X-Forwarded-Encrypted: i=1; AJvYcCV4I8c8YVAs2xM4sslUPqzVa44tTu58z81e09dmJoNoIAuBQ9zVzcgNjWOEXWDtaFqGo4/xG+h1qzjVF8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBSTrhQYVX0eoP9TqZcA2enc02XH2eEmr6aBQ/yAXqtOH2WDUL
	tz4Ta0vXxWNnVSe0HFTQv11wYKpdR0Y9cNWyMC92v6WDwNCE5HNxz1+PaKZx+Vk=
X-Gm-Gg: ASbGncv7p8V+h9Er3Gxo3GdZCkdxhdsK199y/A9EUNzCb9F5j0wSvKVUuU2iAjweRFn
	cTpW8t631MIk/cbgu8EkQ7I19LEyyFY2dCwbW1n41amtwDEtOKmcAzMLqsXIkTrhJNauy7A953f
	xZ3lvuf/DNVY/eVSgjoYAkAmVUc9q7VW0mHTtkZwuYxd1dREKFgN0GFJo/chhcDDTBdFR4H934K
	clbQvBWSPkhkhSGP0dl4WrK6zi4io7nW5HcKUJDUE0cilFyMUBoSveDoYWyitUIJPnqxC20xnrp
	UbtLkCEgpKnLbwOsCBjt65cH+m+rQllUWFAn5FaLDvtxUummzafyvDsBpeS5AQHA
X-Google-Smtp-Source: AGHT+IG5zCh9CoeLQY7rC+mk5ewFMnBFHyg7FBmH5U0ScrNRvZkI+aTZATrHIvB820rTi8JmR7A9wg==
X-Received: by 2002:a05:622a:1a02:b0:471:a2c7:b6be with SMTP id d75a77b69052e-471dbea0a25mr253348721cf.45.1740013049013;
        Wed, 19 Feb 2025 16:57:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471f3f6e90bsm36101381cf.79.2025.02.19.16.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 16:57:28 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tkusZ-00000000D45-0QWL;
	Wed, 19 Feb 2025 20:57:27 -0400
Date: Wed, 19 Feb 2025 20:57:27 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Michael Roth <michael.roth@amd.com>
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
Message-ID: <20250220005727.GP3696814@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-13-aik@amd.com>
 <20250218141634.GI3696814@ziepe.ca>
 <340d8dba-1b09-4875-8604-cd9f66ca1407@amd.com>
 <20250218235105.GK3696814@ziepe.ca>
 <06b850ab-5321-4134-9b24-a83aaab704bf@amd.com>
 <20250219133516.GL3696814@ziepe.ca>
 <20250219202324.uq2kq27kmpmptbwx@amd.com>
 <20250219203708.GO3696814@ziepe.ca>
 <20250219213037.ku2wi7oyd5kxtwiv@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219213037.ku2wi7oyd5kxtwiv@amd.com>

On Wed, Feb 19, 2025 at 03:30:37PM -0600, Michael Roth wrote:
> I think the documentation only mentioned 1G specifically since that's
> the next level up in host/nested page table mappings, and that more
> generally anything mapping at a higher granularity than 2MB would be
> broken down into individual checks on each 2MB range within. But it's
> quite possible things are handled differently for IOMMU so definitely
> worth confirming.

Hmm, well, I'd very much like it if we are all on the same page as to
why the new kernel parameters were needed. Joerg was definitely seeing
testing failures without them.

IMHO we should not require parameters like that, I expect the kernel
to fix this stuff on its own.

> But regardless, we'll still end up dealing with 4K RMP entries since
> we'll need to split 2MB RMP entries in response to private->conversions
> that aren't 2MB aligned/sized.

:( What is the point of even allowing < 2MP private/shared conversion?

> > Then the HW will not see IOPTEs that exceed the shared/private
> > granularity of the VM.
> 
> That sounds very interesting. It would allow us to use larger IOMMU
> mappings even for guest_memfd as it exists today, while still supporting
> shared memory discard and avoiding the additional host memory usage
> mentioned above. Are there patches available publicly?

https://patch.msgid.link/r/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com

I'm getting quite close to having something non-RFC that just does AMD
and the bare minimum. I will add you two to the CC

Jason

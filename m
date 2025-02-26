Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAE521C19B
	for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2025 13:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740575526; cv=none; b=cAD9VVjwcz3eNui79OIHAjnoNCttLYM6Lm3FaY+Z7c+jq+vzKRJBKtORMQegGQg8r7pln/sV1tneO/4hhhJtq4jjycuDxwHzEyMahdHk+fYEDvrlDWg+wBVz2WqXcP3Ey/YAE2L0wAIAgA8j9w8uRZGSCg8gV//uGKUBysdb87c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740575526; c=relaxed/simple;
	bh=UcN+Yc8/BXf/BDVbG/QiIbLhSfNGYB+VDmHOpxILJEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKrkVN+UWjyv1fM5r98sIYRG+wowCsoR5c2fdT9Q0ALi7I83MYmJPtOM63goIP1z/6QrVqnZkX/YmLhYuA6bGsWmy8NLqtkzEvTAfOfWPsbh6tYRvols2pZUA2n+BCqmuf7ciMCaHvTrbSiMpwi9h7kanok0mMviVI0Ad9xtZA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gmth0zxt; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gmth0zxt"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-471eb0e3536so106012391cf.3
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2025 05:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1740575524; x=1741180324; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m6Xk4LHq+vuxMrWb9QEhIjcrWUMHuvgAEq1BuTfNkWI=;
        b=gmth0zxtEmjcsNxhBouoEvOu6qEY7rYm3pbfVqVxZNY4Ii5Y7msKJbC1NsvZynHU5R
         Pj8JH1hsT/VZ2W77VKd3PwwUxgWVNV/ip6dmtM4btdxUBO3oIxNTQYrQcaZ9RQ85KLc2
         ekFyj+uNmcQnZu1aTxpm36sszGsbpiDSaWzqFYDeT7VD++qMH8/w9/dkASEjWY8vR0s8
         UWGf52ZsR1ROQS6uqAfFwSnR0OdudCeR0Gb06DOGGTrrLWZJvA8QZ2hMSnY0Dou/yEAZ
         MKOSXAI6ZxkjfOxw2RoK2mO/BwnFfQiepLvqACzK3aUibTLaW3EZarLFBvvn7sqhaX+z
         s1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740575524; x=1741180324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6Xk4LHq+vuxMrWb9QEhIjcrWUMHuvgAEq1BuTfNkWI=;
        b=hd486o/byKTrciD/iRXgyEk2j+89GpoDurqXfHsZaqYJELehjsYBXKdKNc1wtbWMOJ
         JlyXXtaiTWfcFyifqC2+TpkKPnEt0N1Z+o0LmERyfbeyL+yvGJtxFguTWdNujaes8MC6
         W/sjROkTq6C84SUlFFQheo8b3UrH5hW/nsxOReHto5idf8T96U5jrSpcxVOl156mWV+X
         xxlYNgKkgJggogJh6klntO3ATzBg5KYrpLd3uZF6finik/7Hymzn6PIssiclM89wLQXE
         6Hd3XIsog3S9TAYBjxe7voWtJmaPzgGCUuHaXzdixIw7An3PAYW7PYfhFGht3eMt+EbD
         kncw==
X-Forwarded-Encrypted: i=1; AJvYcCWKA50EX9WWsE39tG43gyTbXikzcmdJb8+88+xKUYL/8Z1PRkAF4XpWbkjm0F9ugYlHeEmVDtIVNgESXv0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl97JSGMjGWHMC/iZt4HzUEBm0yUxsz4v0ypiVZRoaZwdTVeyU
	Sp7p0utbctlS0r9b9bd8yx/Perr5QUeLSFfIwVeT3pC8GDLcKLrkXQbYy0MX7TM=
X-Gm-Gg: ASbGncsSkUHt6hlZ905LiheUuTt08v3YmEEL6EMiwotIrWSVqIDOgXHfE6Bj7qYOX5u
	OK1TIaeXPRdG6iHtlVXJ3pdGlvqYwGtzFSGtN1d46BxQmyIe/Q5mrPbacDiABv70Hsud3960d4Y
	HKfY7/ONMRbMQ6bVajVP37sl/tJ44D8EyIqGlTUAYNDSmFjwRxdifKCH4qZhAE01OHF8f2W9YtA
	JAcdZavzP+Bni8bPtWFivA13HEiu06JA/bL9cnAOiYBOlfaBUAaN5auzMD2D4gs6lXkR+u20ziD
	cs+ZzBRbjBo7n5Wu0nacYCcQP7y5sCxJqgI/z4Mec+cL0zK95/I3BOgWNNKm2m3aCukL7UZpOeo
	=
X-Google-Smtp-Source: AGHT+IEEfwlXAvWZ2xNGVxvzUGP6nDfT13h++oyNBWTrRPp0M1zvh40QuIYqQQDMaC1/myckxEJxtw==
X-Received: by 2002:a05:622a:13ce:b0:471:f619:db45 with SMTP id d75a77b69052e-4737725caa7mr88331981cf.42.1740575523795;
        Wed, 26 Feb 2025 05:12:03 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47377e21fcdsm23423041cf.39.2025.02.26.05.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 05:12:02 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tnHCk-000000007O6-0KPx;
	Wed, 26 Feb 2025 09:12:02 -0400
Date: Wed, 26 Feb 2025 09:12:02 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
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
	Zhi Wang <zhiw@nvidia.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH v2 14/22] iommufd: Add TIO calls
Message-ID: <20250226131202.GH5011@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
 <Z77xrqLtJfB84dJF@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z77xrqLtJfB84dJF@yilunxu-OptiPlex-7050>

On Wed, Feb 26, 2025 at 06:49:18PM +0800, Xu Yilun wrote:

> E.g. I don't think VFIO driver would expect its MMIO access suddenly
> failed without knowing what happened.

What do people expect to happen here anyhow? Do you still intend to
mmap any of the MMIO into the hypervisor? No, right? It is all locked
down?

So perhaps the answer is that the VFIO side has to put the device into
CC mode which disables MMAP/etc, then the viommu/vdevice iommufd
object can control it.

> Back to your concern, I don't think it is a problem. From your patch,
> vIOMMU doesn't know the guest BDFn by nature, it is just the user
> stores the id in vdevice via iommufd_vdevice_alloc_ioctl(). A proper
> VFIO API could also do this work.

We don't want duplication though. If the viommu/vdevice/vbdf are owned
and lifecycle controlled by iommufd then the operations against them
must go through iommufd and through it's locking regime.
> 
> The implementation is basically no difference from:
> 
> +       vdev = container_of(iommufd_get_object(ucmd->ictx, cmd->vdevice_id,
> +                                              IOMMUFD_OBJ_VDEVICE),
> 
> The real concern is the device owner, VFIO, should initiate the bind.

There is a big different, the above has correct locking, the other
does not :)

Jason

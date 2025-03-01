Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFA53595A
	for <linux-crypto@vger.kernel.org>; Sat,  1 Mar 2025 00:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740789124; cv=none; b=G23XFcE2Y1Iehiyns2OZhHk5DbhJwKad6XfbHhTHOtcJ7xgh0pqygddDTHJzT4/Hz4gSm3pMea9Z01VdXDtHMJHICqwWSHYHtjpOU1WR6/tEcqtK5LO6DrGuwO8HQBjVB6vXOfUoZ334RydjQIbhSC47zzGRDokzAdrnw/61Ch8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740789124; c=relaxed/simple;
	bh=IJ/uAZ1nD5RItLsU4XWErABvAF+S58BRfovN898A/9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQK3SlIOp6uov7MxQ1fcSF1fLJhPfu7nLf7RaVtcO3OE7pNrvYyfGrYlFQNAX7+h+sL1oPv2aROySOUaHw9A5j9wTLKGjCiuASpsp4ao0bVu2K1xjAvR/zMJwSobfcjqDYFrlLemeZL+yXhUYhk06R7t+DR4FS6l1t5wafNnOa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mFC1B1ap; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mFC1B1ap"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6e88f3159e3so22150496d6.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 16:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1740789122; x=1741393922; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UGmZpux3eW+jxhKZP1ofv0c4XveJW25IwmZp9EBvmdU=;
        b=mFC1B1apIrNCT3CEaWOaZfF897Bwkk91NcFrXzphWUUjDCnqun+uvkpQFsbIpfhh7x
         T37YvUVFipOnx7mADpt9lRYYd0wDcKsNYbbT8BArnl9PDN1xFPcA5iDUPdqZW72H2Wb8
         IZdspFVXT2eCxubp/t3zh/EfQHx0oI32EDDn8piS2H99QusRurSm2irfuQzIqLq1r56h
         qpWyoTRv4WgwMnEnZ4l3k8iV9z49jZLsXw7hnxhX2O4npR74xVsnUnCOBnCHxnMh2uNC
         m0CgQ8RsrrlPJwLH0B3Lz2gMZayQxGS5PnuZH0GX4KErifVzQGyhlUp9OXDj88E93NDD
         9rrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740789122; x=1741393922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGmZpux3eW+jxhKZP1ofv0c4XveJW25IwmZp9EBvmdU=;
        b=cD9w4KiYkr8/RmGxpg3mHh4lBevXhJ4mkSYdH/UoVqyWADUDzi7ODDASlAW+WNwSi2
         QknYuxfHXqb50ed9oTnZGW2f3HxPKwYv1tFS6fKNT3lmgfuDUM+B0D0C2/gBhholIMaI
         xbywAcjmv2SDQ5ozNMQm9NKrtv3RnBhV2h68/uuHg6PVdYoMSUDenC1f7oz0xVjWQLcC
         9gbUON+MySghPU4ZSaSe0sWOWBhbw4FIl9K7OeZh8InpRnyOAvo67AsVHg1BBaQowmYU
         sQDufm7jSG/mkNBgcDGtCFZaSY0XjvblwfTDSsvFhTgasimmiGhj+8qUoAVdlXZvW74Q
         0cXA==
X-Forwarded-Encrypted: i=1; AJvYcCVOspFkrNSHwjGMt50YOC1yUAW4Gd2p9mzsrn2umizfphL+E4ad6ang/CLnQORicEl+VCaU+ipy7c6sYuE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5vB0Snc1nTfhEC56Lii5G/SI8IWf5M4v+u/itKnkiTgOZJAX4
	pjHcshJ8BAmlElZaKc2HGX09yvIO6DDjlT118yj4urvpwJUhhdDX7LF5vDLGRsE=
X-Gm-Gg: ASbGncubJi76qKMuILKMLyp+k9nvOsT2DFaAuBgYV109v1gxi99ictbW5TdiSav4V7I
	d/JvzORK3mqrUd3ne/kFn2PuWpY+Kx7zBC2EujIomCb1GZABDZl4sx3WsYd6WsUAKVDBQj5pPGA
	CcTIG+NkCmavEPQVXSF361iJBq4JcvbCgbB5RQ4LCWlnJ/QB3IDczYPr+pKjdK1hASCTBzjMAaV
	enW9aJB+lkZrnohyYW1CBmXgeSoZKqzniy5pmzz37qaH6+53Zp6w2FlXWLreaB+XFY62FhlLipX
	vZFQjy5hZhPTn88ZbUlQYgb3/EH5OAyRJJ/e2F+X7j6JPhWMKyDgJC2C5OOH4ErTQX8dwXeYR+F
	U6MvR3VovAF/eDJk8cw==
X-Google-Smtp-Source: AGHT+IGisC/6wMYSFfGCwksz3Hqk310E6+QHChS9Lt2rzSb1IaRmOie8VRdlWltqdIKsz9jGOQcrlw==
X-Received: by 2002:a05:6214:2586:b0:6e6:617c:abb6 with SMTP id 6a1803df08f44-6e8a0cd3b06mr68816196d6.6.1740789122305;
        Fri, 28 Feb 2025 16:32:02 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e897652066sm27657806d6.30.2025.02.28.16.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 16:32:01 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1toAls-00000000VPg-3Ini;
	Fri, 28 Feb 2025 20:32:00 -0400
Date: Fri, 28 Feb 2025 20:32:00 -0400
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
Message-ID: <20250301003200.GQ5011@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
 <Z77xrqLtJfB84dJF@yilunxu-OptiPlex-7050>
 <20250226131202.GH5011@ziepe.ca>
 <433217be-55e3-477b-bc10-cf81f02ab21e@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <433217be-55e3-477b-bc10-cf81f02ab21e@amd.com>

On Thu, Feb 27, 2025 at 11:33:31AM +1100, Alexey Kardashevskiy wrote:
> 
> 
> On 27/2/25 00:12, Jason Gunthorpe wrote:
> > On Wed, Feb 26, 2025 at 06:49:18PM +0800, Xu Yilun wrote:
> > 
> > > E.g. I don't think VFIO driver would expect its MMIO access suddenly
> > > failed without knowing what happened.
> > 
> > What do people expect to happen here anyhow? Do you still intend to
> > mmap any of the MMIO into the hypervisor? No, right? It is all locked
> > down?
> 
> This patchset expects it to be mmap'able as this is how MMIO gets mapped in
> the NPT and SEV-SNP still works with that (and updates the RMPs on top), the
> host os is not expected to access these though. TDX will handle this somehow
> different. Thanks,

I'm expecting you'll wrap that in a FD, since iommufd will not be
accessing MMIO through mmaps.

Jason

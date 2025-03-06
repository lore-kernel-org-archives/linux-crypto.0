Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A067B26E63D
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 18:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741285580; cv=none; b=AhymT87E8lbJFa2xwUEWYVrcBKwvF4fWGqfrfHTlZQbfFX575iXDSJQwgSrPmKwnjCmzBJu2OCDSrtDeDX7e4spQiy33DNGrQUP4TddsNhY5WDPft3MPQyzvNLcNyr3i1jZfY5hxq8qvp9XMaJ+2JL2P1v2vtRBmJuU77vlp//g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741285580; c=relaxed/simple;
	bh=A0wvu3n9vFC16f3qlUsNA6dfIvpISQcUDrHPkbUkZ+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g02El8dHMEChZsLL3zkjz6cZeuOmEbmy794NlTKi3u+iudZS4h8fcxqbsO9cgQfTcmzJYtyp8ZK9X5DQ6HrD2WVEuVDTd9ZJrjVZ22Cc03d+8NrtBEhdAPDal2GxAnMBR1q8Ag951vUbmYXE5k32UuEfdZjeZx49NtYG/Qe4gZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=nG6pM+Le; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nG6pM+Le"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6e8ffa00555so997526d6.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Mar 2025 10:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1741285576; x=1741890376; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kJmNeR7cBbicmXZ58VNFTx5zHy0Fy/985QYAD/du2Go=;
        b=nG6pM+Le+dA7yx4K76TErK7cKIwxirglTLAX04hH3hDNDA8cO9wuZpsL7sMorxgsOe
         Qv0UvNAxBlphErKEkHv8P4LDRP85oK8K/jgj+XsC3CBLCy9cT4znC/llySYS3extxW2x
         Ur13UqVfGcDRXiJbM8DH2rHSbtgqsT8vzs4fvw1rhKDqjJRMFKStH1vegah/CVVjwttc
         Qkt94OgjwpgcLJs14fKW4NYd+6J6ZMv/JuVIUXQg5b61JMsqXhzCKUWvGExH8Q0L0bpZ
         MzQCNoG6mUoHY3dKaPI19z6FyVSREYBteG41fVazwLX1f7QLdNaSmvR7K09OweJNVB4T
         ehOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741285576; x=1741890376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJmNeR7cBbicmXZ58VNFTx5zHy0Fy/985QYAD/du2Go=;
        b=nlu/zoYM3hl/pyQcA5rU3nqRYc6Xs1tcTTQhbd2seOup1ery8+hNE/JHE8vnSf4AwB
         xk09d4JEc7Mqb2n99ITHqdctQP0JhqGyaNprSoy+Bax0IUnwgs1IZzDbbl491GBN4LYP
         8QnV6CU3oWquj24w9jT6pPelruUjZX+a/HSbo9cLe26fb1NMzN0jzbg3Ve/p9rS2X/u2
         5Oih4vkY4GBxxzITMoXUQCYKBe2hnnwzIDh3cVfQkcnJtRawN5aSZNWn7gPz8L90vBqH
         yE2BnNi8fHa5Ells2PxAIAa1SpXYMW4SuJFc276SluznK5wchvHEmnNThAKPny7P66qT
         XMeg==
X-Forwarded-Encrypted: i=1; AJvYcCXdUgQJH2OBprOCIkVohqavx82GYRCEnkFLOpvCzaNvnphbNSnXigZ7+1+cMU8EFpOS6aUT8f8UFfnHiXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzYGk6PpM0qXKuYTSnZFE9rCH1O7hwuhkUfEiO67JpKlVe418m
	IJ4b1+dKicXgXylnronssRQ9PTHgFqg6FX+JNL/dzM1ZVF4AbyVF/GHnUCgaTzY=
X-Gm-Gg: ASbGncuC/GsSG/Pny1Wa968oYb6WnkZdU0eEHWEvBO0GJt7LHdAjiqnU9yRK1N4y1uU
	hmIRSZYVRec+IzZ6NL41XXuM+zcEQxeOH1D3KAQvF3/C4U9XEJvpfE1iSHjAMSpB96N39XdBhOk
	DcTOq9dJF/7UDUAlKDfgob0m0ixonLQl6LQGsR/FUwEKLyuYSJdzyjtMSWYGuT2AqDl2QudpvPJ
	8Qj60ic6f7e1zK4wbsvPI09C5yna6QqZXbPUuTc2+0SUTJ1l+fjv85YIBQCXshIjMtMsdAHXY6i
	ER1kUn/OiDn0h9dVgIN1tlhn8URnMcaMyasK/Dpm7ZDqHqQgdiYDiuHyT84FzdAjNZjxO4Wh/+Y
	sheQHD0vL1S8wvTQu6g==
X-Google-Smtp-Source: AGHT+IHdLGu9+NkI+poSobXraQKM371I6DGk+LdkIPbK8ktXY1plTaVgGJ4wX3yHHMcP8NJrRnY4AQ==
X-Received: by 2002:a05:6214:76c:b0:6e8:fde9:5d07 with SMTP id 6a1803df08f44-6e90066a2e7mr783186d6.26.1741285576387;
        Thu, 06 Mar 2025 10:26:16 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8f7090c4csm9806836d6.33.2025.03.06.10.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 10:26:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tqFvC-00000001eHR-3E6L;
	Thu, 06 Mar 2025 14:26:14 -0400
Date: Thu, 6 Mar 2025 14:26:14 -0400
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
Message-ID: <20250306182614.GF354403@ziepe.ca>
References: <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
 <Z77xrqLtJfB84dJF@yilunxu-OptiPlex-7050>
 <20250226131202.GH5011@ziepe.ca>
 <Z7/jFhlsBrbrloia@yilunxu-OptiPlex-7050>
 <20250301003711.GR5011@ziepe.ca>
 <Z8U+/0IYyn7XX3ao@yilunxu-OptiPlex-7050>
 <20250305192842.GE354403@ziepe.ca>
 <Z8lE+5OpqZc746mT@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8lE+5OpqZc746mT@yilunxu-OptiPlex-7050>

On Thu, Mar 06, 2025 at 02:47:23PM +0800, Xu Yilun wrote:

> While for AMD:
>         ...
>         b.guest_device_id = guest_rid;  //TDI ID, it is the vBDF
>         b.gctx_paddr = gctx_paddr;      //AMDs CoCo-VM ID
> 
>         ret = sev_tio_do_cmd(SEV_CMD_TIO_TDI_BIND, &b, ...
> 
> 
> Neither of them use vIOMMU ID or any IOMMU info, so the only concern is
> vBDF.

I think that is enough, we should not be putting this in VFIO if it
cannot execute it for AMD :\

> > You could also issue the TSM bind against the idev on the iommufd
> > side..
> 
> But I cannot figure out how idev could ensure no mmap on VFIO, and how
> idev could call dma_buf_move_notify.

I suggest you start out this way from the VFIO. Put the device in a CC
mode which bans the mmap entirely and pass that CC capable as a flag
into iommufd when creating the idev.

If it really needs to be dyanmic a VFIO feature could change the CC
mode and that could call back to iommufd to synchronize if that is
allowed.

Jason

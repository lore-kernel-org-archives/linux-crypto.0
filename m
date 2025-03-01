Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59967D2FB
	for <linux-crypto@vger.kernel.org>; Sat,  1 Mar 2025 00:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740789435; cv=none; b=m/B6lFNRH1K4RQWPAl+Q7P6tCXaAy1JhYBLflouNORaQSX72eVgcc1vqJagxgb9mSahGF61c1x/Nca36J6EeZZ1dfrkU345/hokkTVK4RLO75v7cbjUaP02g5ytd5AGo4I8OHQNkDMNgLRzhCuB1zc3XCVyn+MnHSvvIArcSrB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740789435; c=relaxed/simple;
	bh=KWp+JkEQ384C2ZZM2vnmvijKALezyZ2yoZO4XWGrnII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNF+nkkJx0bg7mlSZNgZ8cGrRwlJFanu0g8rHMJiJ4AvBNElC6F7TbG2yGJKcBuv5I6UJaQfIPIWq6aC9pgdlqF/NwSxvqnfygUCATBCM8h4HDWZSFR9myiWBZK+mH4J6RV4Y8QqkpIL+eUDYm7Uj5DjAeXkKX8gc262x2EzIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Z8vaSmji; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Z8vaSmji"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c24ae82de4so261270085a.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 16:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1740789432; x=1741394232; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Td3ECwr3BYX3Fk7gFnUV4jIGzq67kra6+CNEYMgu4U=;
        b=Z8vaSmjiEs+nPorZdfUrAjkI1nEevckyK9Dh0B6Eq0ipato35eeCQa5LdGx3pwfRj0
         oHw5Z/HV64Z6ebo2cDFx2aJiu+12an0VTAwKlta62BwuP1Xt/rXOogyne1kCkwFon4fD
         OdyRkws1GJPN8HkEAc4rUylqjiKZts2fNC/Pnc9Aa6PUvYEWOcR8YxOg5nZ+roDZFuVg
         HkkWbUSMKmhusUHsKo1fLm3AGkT8mgStDoqea3zdc8aM0Nuj29X9MTfH0lHAjFLCE0Hx
         6uAKoPwQJoAjVepzI4fhcsqRsXYRTZDS6wZ8haCsLuYDzxWUe1ufMnTZlLPqmQ2LmJzD
         /l3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740789432; x=1741394232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Td3ECwr3BYX3Fk7gFnUV4jIGzq67kra6+CNEYMgu4U=;
        b=UAanlAeTBde5UcnqQjdZ/yxROFSDtcJhl/U9doBpzsCGO6S1rawUwGAPDyZM6JSr7b
         LwDqDra900mlABppHPdh1vlz8amneIq4kKvZhcOAlrJOUNDf68BO7lF91MSZlQUJhV8L
         ZdV+K5QOUDijPksmPzaAbXeluPjcID8R9zmDPcpMK5OfjqXsyAAoLujAssKjpSazioPw
         OlYPXfM0u7XMmz1g42OseejxMElqaHqmv/BNv7ATOxTU+nupv8FGN/FORSa4Ws4wFs5n
         FmdN5JDRlseOcTLBV/X95Zlst/lfVz7DjJx+qC69EJ+dhrMdbwYnwLMMTMIiIknR04yP
         xPLw==
X-Forwarded-Encrypted: i=1; AJvYcCVyQCZzi43z3ovsTPFBMaM6G3ploHD5ekfE5tBiXTttbBb1TiuHQzYvROC5N538nasd+8CfE3ZmXQT2gf0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbJT3nVeCXW2rHBQkP/geNo8Pd64fd9i60q3+EVdi0YS3vbSbi
	AJ1feQAiP/zPlMXjF7z3nWUVWAt/XKDR4ckzrCPjdIhFcUCxE/t3jQmR831TRLc=
X-Gm-Gg: ASbGncv5J91D20KSf8FhXuHGRV68fCxo6f/p58swBRw81C6JefcY7KxK+8R/S2WoJek
	WzbLBFg1blXUsYUIqgfPHVxPKdgePF172gKDZ2/ZulZwzMdieKu7SQ+ym01j+B6wLG9iG87mAtj
	w215jt/utrcuscgsvHm/DyBMPf6l+Nyv06Gi7EIFO7Nc+Q4dpPId6XPrghAdpyUiot+3drDGhyE
	VuREMLuzvjLBv/dyAwK9VlG4S1A/XxA9BpMgfi137LrLyxQ8tM/wZMsov9TAQXurMsNh1doBkGs
	E5vm/KqNXX/5NjO5C7Hv4DulsWlQOWI+69CjGMm4YYCj9/XMp3SEvOprm+kTAXJ0HN7JftdcoF6
	IZ7pQlNaUcx+Wqm7Xvw==
X-Google-Smtp-Source: AGHT+IFOn/ksSHuws3wokBJvJa6/sj/LoYkAsoS+wBwh3GzDwSM7WHVrzGwS02MkZWU6Ex8ojjGm5Q==
X-Received: by 2002:a05:620a:4051:b0:7c0:9ac5:7f9e with SMTP id af79cd13be357-7c39c6691eamr774480385a.50.1740789432305;
        Fri, 28 Feb 2025 16:37:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c378dac6d3sm310478485a.97.2025.02.28.16.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 16:37:11 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1toAqt-00000000VRk-15Wo;
	Fri, 28 Feb 2025 20:37:11 -0400
Date: Fri, 28 Feb 2025 20:37:11 -0400
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
Message-ID: <20250301003711.GR5011@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
 <Z77xrqLtJfB84dJF@yilunxu-OptiPlex-7050>
 <20250226131202.GH5011@ziepe.ca>
 <Z7/jFhlsBrbrloia@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7/jFhlsBrbrloia@yilunxu-OptiPlex-7050>

On Thu, Feb 27, 2025 at 11:59:18AM +0800, Xu Yilun wrote:
> On Wed, Feb 26, 2025 at 09:12:02AM -0400, Jason Gunthorpe wrote:
> > On Wed, Feb 26, 2025 at 06:49:18PM +0800, Xu Yilun wrote:
> > 
> > > E.g. I don't think VFIO driver would expect its MMIO access suddenly
> > > failed without knowing what happened.
> > 
> > What do people expect to happen here anyhow? Do you still intend to
> > mmap any of the MMIO into the hypervisor? No, right? It is all locked
> 
> Not expecting mmap the MMIO, but I switched to another way. VFIO doesn't
> disallow mmap until bind, and if there is mmap on bind, bind failed.
> That's my understanding of your comments.

That seems reasonable

> Another concern is about dma-buf importer (e.g. KVM) mapping the MMIO.
> Recall we are working on the VFIO dma-buf solution, on bind/unbind the
> MMIO accessibility is being changed and importers should be notified to
> remove their mapping beforehand, and rebuild later if possible.
> An immediate requirement for Intel TDX is, KVM should remove secure EPT
> mapping for MMIO before unbind.

dmabuf can do that..

> > > The implementation is basically no difference from:
> > > 
> > > +       vdev = container_of(iommufd_get_object(ucmd->ictx, cmd->vdevice_id,
> > > +                                              IOMMUFD_OBJ_VDEVICE),
> > > 
> > > The real concern is the device owner, VFIO, should initiate the bind.
> > 
> > There is a big different, the above has correct locking, the other
> > does not :)
> 
> Could you elaborate more on that? Any locking problem if we implement
> bind/unbind outside iommufd. Thanks in advance.

You will be unable to access any information iommufd has in the viommu
and vdevice objects. So you will not be able to pass a viommu ID or
vBDF to the secure world unless you enter through an iommufd path, and
use iommufd_get_object() to obtain the required locks.
 
I don't know what the API signatures are for all three platforms to
tell if this is a problem or not.

Jason

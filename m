Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0195F1DDC1D
	for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2025 23:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739922670; cv=none; b=fcJId9TJiQ5XPAPod1Ubu7HwE7aYOIWynN3K9KZvZNz73DHTGITXVTg9eDD5YoPX7J1MqNhTlyqAyiDjMveSzVC2XAXzq5Zdnc3zjxp7tsJwB3c/uGHKHEb7qsGZOdS6YBhSNLk/+A9r2HbNlPiFI4ZVbsHXH1/Mpiotb9ecPFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739922670; c=relaxed/simple;
	bh=iKT5gRHJFTk24cvpT8KmAyPqwcHjrkHc67AQuv3guHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuJuQKIyMUg7ubRAgk+NAhbC41Wia2xi8sZu7Krs6zYoDpiV+QmWW0kX/f3Z14wCgP8hN5VDP8lG2QCWvIbvrtNSJqZECNzrUDl7grmFglEtFgGLY8yYC1Pz+ULyOCImdIjTvHhYkyHExismcZwpESaoqfQSHoV8LWUpZpNslmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gyCO2oxs; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gyCO2oxs"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6e17d3e92d9so52903266d6.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2025 15:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1739922668; x=1740527468; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iKT5gRHJFTk24cvpT8KmAyPqwcHjrkHc67AQuv3guHc=;
        b=gyCO2oxspS7/wo6nKrTP+PvPC3WHPNTT6/JmRriOfZhLiACAnYCQEFSI25NC0zC/bF
         qsqrC37zkhXUI/9OmKKjpIkhjLKCHctLj335ADwtwMIBl1hIncXGBVtv5/nxRpL8ejbX
         LHz+b9Vz/nMApEUQDq9Lc5nBJyHsPBK7k1DyN33LgalFNLN0UL1+RbukmuC4ysEwj0qh
         wgCE/wPcuCDwaNsLdoAk7Eoi6GPSmFhhQDxSHDe5yQpmi9qqG1KNX8rJaDxWtRjwzTh3
         d0tAgD7OX+mSpXFQ6cw+c7BSzWiMhmu1TvZF45FwzBYu7VwPqmD7oEa3C2DbfCbikDIT
         6lug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739922668; x=1740527468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iKT5gRHJFTk24cvpT8KmAyPqwcHjrkHc67AQuv3guHc=;
        b=MJM8LAZGn55vEzQQmxkEY1BeJ6YcCX4Gs9ye7aPiqjNKOvYlqNIQWY8oNpEDd5mocu
         YfB1zXjYf+gGeg7dUlQP0bDk5RKc8QGo0SW6POgc7GnFMh7Iw1BQHL/kd1IBdi15jtU8
         5esV2R/zh7rVvxB14j84T3xU3gJtvB3bsnVkV9XUiksVCWKfPuEtqwvqJ9RViVPBYtue
         gxcQ5ZMoCgRXoOnsIvEPcnUIwC/cinqBkyhDQZQmqjxm9B87avGNugxxv7zlm/t+xIBN
         4urPS+Gl1/iwP2g26OAWG1N0BNlfrqGd1hztaaGB0EkP480JeEx8ThEnsHuKy8Ln584Q
         /uCw==
X-Forwarded-Encrypted: i=1; AJvYcCVUFKIQaCIlHZ5sphky5tygdCEGuXBGk0c2eBBooE8Gxb4YCQSoBntW/aHv4Z3lUzNvBDsHd9f3x6NN8Ug=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa23tAE3aYYliNzF7VyAnOqxd7rI9dstLnqvjVhAzcwQ5K8qHP
	YJmlD1TquibwgaOa7ZVM8h5DEXL8ZJzW3Fvd2AnNyHXNEewABqQ+A1lnAJVOSO4=
X-Gm-Gg: ASbGnctR+h5iIopfS3mWYBHU+YzyuD/rhAaD2SRuuWqbmLAySSD33HQbN1zJtLpsYpe
	eCN2t/VVrWQX9O2/Ywt794KpyjkSlkQgJ4gPBOtl2Jzu6nJ9e3gkg0Y+PgrfUFU9gWA6LlGCZ6R
	bYzqqxLwB0u/eHzg14AiIFNkpWi+x4Ht9jHa4y63NPMhkd0eMKgzvSKYRynuMakUsfHMgVbKUWD
	wUwlGmlfbbt+7pRMrwk+QxA6QdecG7TdJtd1M1dS3G2vwRDnpUF6lUW9/D+YMi5VYsvnGaCR13/
	pOlfPF1xzO0rh26nO9EWWEkPe7rnMFKgEbJodV5Fx4SardrOtyUG8cP+P5gNMCPG
X-Google-Smtp-Source: AGHT+IFO1/6l3OUxeVa8mqeoAIRJldW9bBpco9S18W39RUG+1rvPlDolxLvoJK10Ea2Dnll0//ehxQ==
X-Received: by 2002:a05:6214:1d09:b0:6d4:3593:2def with SMTP id 6a1803df08f44-6e66cc8aba1mr253639746d6.5.1739922667835;
        Tue, 18 Feb 2025 15:51:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e65d9f325fsm68981726d6.76.2025.02.18.15.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 15:51:06 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tkXMn-0000000020v-3I9I;
	Tue, 18 Feb 2025 19:51:05 -0400
Date: Tue, 18 Feb 2025 19:51:05 -0400
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
Subject: Re: [RFC PATCH v2 12/22] iommufd: Allow mapping from guest_memfd
Message-ID: <20250218235105.GK3696814@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-13-aik@amd.com>
 <20250218141634.GI3696814@ziepe.ca>
 <340d8dba-1b09-4875-8604-cd9f66ca1407@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <340d8dba-1b09-4875-8604-cd9f66ca1407@amd.com>

On Wed, Feb 19, 2025 at 10:35:28AM +1100, Alexey Kardashevskiy wrote:

> With in-place conversion, we could map the entire guest once in the HV IOMMU
> and control the Cbit via the guest's IOMMU table (when available). Thanks,

Isn't it more complicated than that? I understood you need to have a
IOPTE boundary in the hypervisor at any point where the guest Cbit
changes - so you can't just dump 1G hypervisor pages to cover the
whole VM, you have to actively resize ioptes?

This was the whole motivation to adding the page size override kernel
command line.

Jason

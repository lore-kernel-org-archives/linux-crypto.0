Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74CA20C470
	for <linux-crypto@vger.kernel.org>; Tue,  1 Apr 2025 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743522826; cv=none; b=hBXKXk6UhfqboydnalZpl+0xlEHQfeQ3Bj1bRTayMwHhzE8U/yWi+PHVx+NzYyitN0+nVoEK7DtSHXJixRT0cy7dhIdzA4ivn8Kbmbyd+97eYV8+ak+z/QQnTWuUAFRfBZ0kGZwzO8bYDGIts0NzcNRhocEXza08F2yQamOIa2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743522826; c=relaxed/simple;
	bh=MKudk/LIkF1mIN1017i5vn/dv6GMx6eTBMj2oFhk/BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OD/ewg95AZlVHWnPkAK9NWM1ltE8uHf/80/k8WuVkxikrkA2zAvtXXozUZ4rxBN3l+fcMuPHPl23/+w/UOLeGeIgK7LmMG4RGjvlDBg1tbNWIweYDPi8Jy6WXX6wPZ9VHV+fSM+U2YQrB5p42ljgpJ3mMDhAMC823jXmDjsk/dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ZdJmAgh6; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZdJmAgh6"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6e904f53151so48988196d6.3
        for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2025 08:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1743522823; x=1744127623; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MKudk/LIkF1mIN1017i5vn/dv6GMx6eTBMj2oFhk/BU=;
        b=ZdJmAgh6BfI7FR71xO9Ltvyd+AqEmpa8+KXtD/0JgUoI2BXIYhrdSfOzzIPSIMyrPa
         iOtzJa69RJtuxBoWBivEXVE4F3G093H6PQhBJPTCP6aTJi0Y28885B0dPBaMFC5faUDa
         Z6ciQ7Ir6vu7c1vY6pcE8OQ6WaSISYO50Q0tGj/Z/UrOfesMwrCLBf0zXRaDHuT0RD20
         ly/ztp6GibJIvR2hUzsbrNk/T7CNcOtFu8WGGnkIuVRmywGHIdAqHgqQgh7lox70jBEe
         4QqUUZB7K1NIhLRHsnhwQrxSt9EdBJev7wvPG1dr/6BLG6NMJuNiM3ae0F4iLGsC83jC
         YDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743522823; x=1744127623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKudk/LIkF1mIN1017i5vn/dv6GMx6eTBMj2oFhk/BU=;
        b=ae0nlz/ec9CXMTNA0BQRQxl1klWhRK6av0iPStuC6fGJuYCN81nkTDMBcuf/uOMUrp
         ydX0IiTque/AWn7Dejg9ntmgr2nS3G+7joO4Hn5R87nuAUfniGnOu0mIZKWb9Uq/0aBr
         Glfkh8nCH9CXYaE6zb6KScwKkUKEKNlg/b+/KS4DF58LiBRkvfbksG/p2kVTwdS9/Xk2
         Dq/cKrV5xF7ANx97L/yDnGzgihp2yqhYa0FORp5rS5fD5CaxuA/g+YOiWhHYiNgxUewP
         eq46qDkA4OgeJT/+GfoZLIiF2kAcIHRpq2osAfRYUEjCwy4NCk3cLmwjVzGl5darSY7q
         i8/A==
X-Forwarded-Encrypted: i=1; AJvYcCVhhfFLFbni9m2Kp/j9wspyBBszqmLOpTYIYToSrAZuosj1USq2LpFWQIHDlo2KFelAm0jtTAWckpCg+rw=@vger.kernel.org
X-Gm-Message-State: AOJu0YydzAUPFPyTBonXC5M+2p5xfiUqruCAg4a4NHpOWC0la3H3TNuT
	XmqCKPaebW0MmTSVX77dUPL/bMMtLtUqtc2GKOOFI235LXe3OdAkNDh3Zs2ljDo=
X-Gm-Gg: ASbGncs8+1NBo0ognkaXfLws0y5UG+Sh8RoDJPatLSpNgoPkvtkusQWfuhzq6sd/E6+
	yfNKhM04sTq1k/PwJDIswvMhvgeoV8QySsKbK/8sBMLFZkImoAyjV4Gilk4+nNNt2dCSWM9jzsM
	8n9NcHSyGm5BdUgEE4oHdSmBBfuD0oW7fOcN+osi+3WLzoPXWfk+WqtWUh+JnrXKemXCGs6sauU
	pfhscBH+0HcuW7ewByunkich155ozfzHytrLKaburAA1nPBz4P+V39TU4RhUSHVXXCsLP4wtzC+
	E9bb1sUJvQiDZPh8TpcEaMwPLHoUdC+DtRyfkCSlvWt2CM+0hN4+SPB4KaZvooow9dfXAJY+1Q8
	+7hWKRRzlfbv61comilGwaEQ=
X-Google-Smtp-Source: AGHT+IFJ+ooR1gogrE/PHgnfFzjzVnCoIzBOEcYnCXUPK3x+TiFlSiO2UYFbU0xPUKL90AfGX3nrhQ==
X-Received: by 2002:ad4:5c86:0:b0:6e8:9a55:8259 with SMTP id 6a1803df08f44-6eed5f924f4mr229513566d6.9.1743522823661;
        Tue, 01 Apr 2025 08:53:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eec97970a2sm63068746d6.98.2025.04.01.08.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 08:53:43 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tzdvq-00000001MFn-2LDi;
	Tue, 01 Apr 2025 12:53:42 -0300
Date: Tue, 1 Apr 2025 12:53:42 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Christoph Hellwig <hch@lst.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
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
Message-ID: <20250401155342.GJ186258@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
 <20250226130804.GG5011@ziepe.ca>
 <67d4d3a5622f9_12e3129480@dwillia2-xfh.jf.intel.com.notmuch>
 <926022a3-3985-4971-94bd-05c09e40c404@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <926022a3-3985-4971-94bd-05c09e40c404@amd.com>

On Mon, Mar 17, 2025 at 01:32:31PM +1100, Alexey Kardashevskiy wrote:

> It is about accessing MMIO with Cbit set, and running DMA to/from private
> memory, in DPDK. On AMD, if we want the PCI's Tbit in MMIO, the Cbit needs
> to be set in some page table. "TVM" in this case is a few private pages (+
> bunch of PSP calls to bring to the right state) pretending to be a CVM which
> does not need to run. Thanks,

Yeah, though that may be infeasible on other platforms. I'm pretty
sure ARM and Intel route the Tbit packets directly to their secure
worlds so there is no possibility for VFIO to use them without also
using the secure world to create a VM.

Maybe AMD is different, IDK.

Jason

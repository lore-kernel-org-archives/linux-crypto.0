Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9C6267F4C
	for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739888199; cv=none; b=azBZMYgUuPNQgbsnLGd+GtBNfoBC02PjcUVNSNUJ7EPNc6XRfKc3w/hCF1rl/8f9uW6ldjf4Rcsm0LOl/FVqF3Li4VV0O4qiSv/21bWYnpMww0opnyr62oLgFUWY17n6DfNVxmADgoMdG/26aRNx5oezQQoJ795Mw9L7f6GOftI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739888199; c=relaxed/simple;
	bh=H5OrTZZF1T4+dJOoCeOR8BRC+wmih1HhO3WIjrfxabQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tg+hR1mS83Kdf4GSirsRR5gTKvPv10jI/nDHzeHxitVtgP9au7byI7N5weBwnD2MXSkRk+AwiQhyXIEPWfhwTYRzggqo/v5uuAnHof3/rmSDzJKrvnXePedei8ML+lXzuZRrX0ldB5GiQa7GgiMKdhS08RIVeiWy+TYc7QB75hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=htSu3g77; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="htSu3g77"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6e65be7d86fso51651476d6.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2025 06:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1739888196; x=1740492996; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vW41P4u1zMYmLe3HNGTznFnlXAaZ2jlrVM/2Fm/eU+s=;
        b=htSu3g772Koeih9rq+ETGyDQyK0fLJLUJ4lHLA36xWeEES5ExANZ4Lt4W+wl53N7n2
         oqcIYuWZdsB7nHUzdiwFQoKXHRtrIM8QpxvJx/b0Kt2FwMphbAjcRAiSnSWZeD7jMUyU
         Z59kqBe34+K35qykVGWuMjoRQR6u5RBUZaUXvRIJlrUUEgs5bWFguTOOFxxhzpTlywPe
         4DF+p6cQypJV86EbpHnsscPI42Pdo16u6UIP3UQKIdlny86q+9QbuHygW2CF+9odcIRX
         9oaFymvRWYVpoAsLhSJBOXGVVNi4V5nalQvluazefFomz5w6l7tPaUYmMHpYJIzjMRqg
         Uo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739888196; x=1740492996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vW41P4u1zMYmLe3HNGTznFnlXAaZ2jlrVM/2Fm/eU+s=;
        b=UCg7NLsFAnSpT4pIsM5bGzwSCreNKluqaYvWXT3nS77paIviqQUfQD5AHtu87UxlAb
         GGxqbXo9S5cwfGkPvo9gnDzUodDeo5v/Jb9EVND3KIZ3vyeO3InO6oLhdRkHjCJhMXXn
         3wHvZGgdmtEM23Yw7s5qH82BjlJ3rQJdgXGM8b+k/W4Bmwk4CdpVOWVjq4rG80lB4Q3q
         FgWEfmedxDcGXg6XFojwoFgSTB+m0miM8sLAieeuCN7pZJw7PfmSakUjoULpmUzTA96q
         jbYhwl/seB8GeDSSsCrxfsgVp0wO64ZAnmzdh7J/HxPpKh/YwG3i6YNTR3dQBqvd5+yY
         FHdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/oSPHfy7cW/ecyT6kED9RWA4ZIbBJl77PBkMWA6pp/LtalEB9nyqrAr8pQ1WLX5r1pptWkUStFn2KTpY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv8rQTMIf0kQfvoNXmy4v9cdF0+b7po/bck03kHfg8AqybZ4U1
	F//RsE1ldziEuSPsoO/LYNI0iDXAUAHv8COsOnkPeDm80ITGOlzDuDYSShI4Q/s=
X-Gm-Gg: ASbGncvY366Zd+M/gyJjOH6NVOKl0Ks6JBw6JlC+Vp+RiPgVpXrBi0VqVUyDqk/hZyc
	qZbnOevt/94SjJugh+hP01lWW3hrv92qbdzIiwUVGWS1UymxAxs8EtmVZZy2AXuhIRjwBvBRikT
	hYNZh1mHYhGf5pLRoMDbLNdVafBQJ5WVEvP9KQGtJ8mVDWMqe1sY2om04TFmIPuxXMcliu4AFn/
	UFUjqVsCkc5SVsCvgENTunXGYh95om5G5SJzg/Rf3vsi1mZWzO9qIiI8ZdNXqikd9AFU0hybKV2
	MUJYpuR5zDnajAskkzmXmltjjAluC1BjdtFkkK+gnJNmKkeU0wrzooRsIX9ZUfI2
X-Google-Smtp-Source: AGHT+IHJ10gwa7TkqX4u90KVitfcSqaAYhvBMLdYu0xRO1z75bkcNOGu9RXUBILo5K1eyOZ8Epx6hg==
X-Received: by 2002:a05:6214:c6c:b0:6e2:3761:71b0 with SMTP id 6a1803df08f44-6e66cfd6c68mr183301176d6.5.1739888196592;
        Tue, 18 Feb 2025 06:16:36 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e65d779271sm64214796d6.3.2025.02.18.06.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 06:16:34 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tkOOo-0000000HUGc-0mkn;
	Tue, 18 Feb 2025 10:16:34 -0400
Date: Tue, 18 Feb 2025 10:16:34 -0400
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
Message-ID: <20250218141634.GI3696814@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-13-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218111017.491719-13-aik@amd.com>

On Tue, Feb 18, 2025 at 10:09:59PM +1100, Alexey Kardashevskiy wrote:
> CoCo VMs get their private memory allocated from guest_memfd
> ("gmemfd") which is a KVM facility similar to memfd.
> At the moment gmemfds cannot mmap() so the usual GUP API does
> not work on these as expected.
> 
> Use the existing IOMMU_IOAS_MAP_FILE API to allow mapping from
> fd + offset. Detect the gmemfd case in pfn_reader_user_pin() and
> simplified mapping.
> 
> The long term plan is to ditch this workaround and follow
> the usual memfd path.

How is that possible though?

> +static struct folio *guest_memfd_get_pfn(struct file *file, unsigned long index,
> +					 unsigned long *pfn, int *max_order)
> +{
> +	struct folio *folio;
> +	int ret = 0;
> +
> +	folio = filemap_grab_folio(file_inode(file)->i_mapping, index);
> +
> +	if (IS_ERR(folio))
> +		return folio;
> +
> +	if (folio_test_hwpoison(folio)) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return ERR_PTR(-EHWPOISON);
> +	}
> +
> +	*pfn = folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
> +	if (!max_order)
> +		goto unlock_exit;
> +
> +	/* Refs for unpin_user_page_range_dirty_lock->gup_put_folio(FOLL_PIN) */
> +	ret = folio_add_pins(folio, 1);
> +	folio_put(folio); /* Drop ref from filemap_grab_folio */
> +
> +unlock_exit:
> +	folio_unlock(folio);
> +	if (ret)
> +		folio = ERR_PTR(ret);
> +
> +	return folio;
> +}

Connecting iommufd to guestmemfd through the FD is broadly the right
idea, but I'm not sure this matches the design of guestmemfd regarding
pinnability. IIRC they were adamant that the pages would not be
pinned..

folio_add_pins() just prevents the folio from being freed, it doesn't
prevent the guestmemfd code from messing with the filemap.

You should separate this from the rest of the series and discuss it
directly with the guestmemfd maintainers.
 
As I understood it the requirement here is to have some kind of
invalidation callback so that iommufd can drop mappings, but I don't
really know and AFAIK AMD is special in wanting private pages mapped
to the hypervisor iommu..

Jason

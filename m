Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAC71BF24
	for <linux-crypto@vger.kernel.org>; Fri,  3 May 2024 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714750908; cv=none; b=hjaCg37ur9ETne+LnYFM2kyU2hxaqDiyOYw2u2lk/cJMWZO7Kndn2EHvrSyOQOWA0ebsEeQ1f8308eWucJhST5SRtrg8nlHx+ByImssaAXc/47oWW12gHqJ5IXJJ09l6oo5zL3Qq+C2jKRYNtUaK0cZ5JPxyIFNvCPAtKTB4YXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714750908; c=relaxed/simple;
	bh=rVld10tE0C52HYanJVGtq1wK+8/S48n/EcxiWlbDXtw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hl6GVJA9wXlP0RCAajcF/4ewZcnkXKWr8CjxQH3n4wEUyGpByhvjQ9euFTm3wNQeugnSB6zr9NwIRvDN5/RFZTmWCDH5HvQ32ytwtm5t6gKJ0xH1vLQgzzdmZZpv6lY5+KmhGU73BIkkZTvMCdtZismwaLoIeHrgOpFsnxumQn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dv+kE0Et; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dv+kE0Et"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714750906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pnFu+vibcwvq3xNtE6dk2KrEqW6IYlf8YWi6hQ7dcY8=;
	b=dv+kE0EtZlg7tXI97TzCMX9Ict8RFEkT9TNbKemUZLHrjSe3ytJ9a5xn+vxLSzG9vk3iV2
	7PCbubqdT5FGm5Lh23JTjQXP0JkjAbhuRpa+YwtPH89Kve0nxtJswhnyw5+wf2uYVF4+ak
	M29/apyarVfUmXamYxwJZAdWJpxGYKU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-ZUema2v2P0mEsxyyydwOtg-1; Fri, 03 May 2024 11:41:44 -0400
X-MC-Unique: ZUema2v2P0mEsxyyydwOtg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7dece1fa472so560273139f.0
        for <linux-crypto@vger.kernel.org>; Fri, 03 May 2024 08:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714750904; x=1715355704;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pnFu+vibcwvq3xNtE6dk2KrEqW6IYlf8YWi6hQ7dcY8=;
        b=h2y2BFohQMf+17mOrZvAXTNEmK8WOuEvfwpZoZRyFIRpYj7/9TA2U5Az7BSQa3ceN0
         CGveC9zGvV2ANUMtXmbfWZV3kGum09Pdbpb0Yo+w1OJSjPqXioGunsqF9R/rgfEfIq6J
         t5amXb08jE+QzK5ybnd+6/khBIVqApFIxZt0rWoz39FIoekIc81CaU2nEnwVI3RvAfe/
         /6EZt/lKnOmYci7Zaw9AoCupsSSj/qUSAKIbAF2Er05XkasvlmOSa2pIPT35rbJB5GPV
         n5jblQ/GyAwOHg0X8dfh9iG1Delxb75jP8rG9elBIRJASEAXYo6QLJWv1kuYTVfCw7jH
         FhnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHGZ6I8d4tsuDNqXDJI49MlDksOp4pYnrNYG0dmSHtTOle1Bx8dLdSj1r+kivI8YNfI+4qyv/5QhA5uTGQr61tIS23iCgnhwjuN8jo
X-Gm-Message-State: AOJu0YztpAmyRu80JRneVfwdSGXgmyCu5Vb7gvmv11BIi4Mj6cicgvbS
	5MJhxQVeg7/1xhkVuc3ZLvL90q1kG/tSUj7rMZm/o3ZgOb3Mq9GCuo0YsRYMvjvrPEZmwpWQGD4
	IMvsJKk/LnoauJnWcJ95ZvYOfAq0ftCFGTXuUUCEh0JcU+npRAncSNq2JfBfCLA==
X-Received: by 2002:a05:6e02:dc3:b0:36c:9b0:2e5f with SMTP id l3-20020a056e020dc300b0036c09b02e5fmr2581765ilj.7.1714750903569;
        Fri, 03 May 2024 08:41:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4dQjkdj8kmj0CmeULShj4qV/zxtJET/hncYpj1wfcrqV7ncF7NLfAQMxwQcxXu4DLh0IugA==
X-Received: by 2002:a05:6e02:dc3:b0:36c:9b0:2e5f with SMTP id l3-20020a056e020dc300b0036c09b02e5fmr2581709ilj.7.1714750901795;
        Fri, 03 May 2024 08:41:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id o16-20020a056638269000b00485128ef27csm838777jat.168.2024.05.03.08.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 08:41:41 -0700 (PDT)
Date: Fri, 3 May 2024 09:41:38 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: herbert@gondor.apana.org.au, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, qat-linux@intel.com,
 Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v7] vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV
 VF devices
Message-ID: <20240503094138.1f921e49.alex.williamson@redhat.com>
In-Reply-To: <20240426064051.2859652-1-xin.zeng@intel.com>
References: <20240426064051.2859652-1-xin.zeng@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Apr 2024 14:40:51 +0800
Xin Zeng <xin.zeng@intel.com> wrote:

> Add vfio pci variant driver for Intel QAT SR-IOV VF devices. This driver
> registers to the vfio subsystem through the interfaces exposed by the
> susbsystem. It follows the live migration protocol v2 defined in
> uapi/linux/vfio.h and interacts with Intel QAT PF driver through a set
> of interfaces defined in qat/qat_mig_dev.h to support live migration of
> Intel QAT VF devices.
> 
> This version only covers migration for Intel QAT GEN4 VF devices.
> 
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
> Changes in v7:
> - Move some device specific details from the commit message into driver
>   and add more comments around the P2P state handler (Alex)
> 
> V6:
> https://lore.kernel.org/kvm/20240417143141.1909824-1-xin.zeng@intel.com
> ---
>  MAINTAINERS                   |   8 +
>  drivers/vfio/pci/Kconfig      |   2 +
>  drivers/vfio/pci/Makefile     |   2 +
>  drivers/vfio/pci/qat/Kconfig  |  12 +
>  drivers/vfio/pci/qat/Makefile |   3 +
>  drivers/vfio/pci/qat/main.c   | 702 ++++++++++++++++++++++++++++++++++
>  6 files changed, 729 insertions(+)
>  create mode 100644 drivers/vfio/pci/qat/Kconfig
>  create mode 100644 drivers/vfio/pci/qat/Makefile
>  create mode 100644 drivers/vfio/pci/qat/main.c

Applied to vfio next branch for v6.10.  Thanks,

Alex


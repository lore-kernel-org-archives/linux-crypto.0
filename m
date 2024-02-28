Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A4671EB9
	for <linux-crypto@vger.kernel.org>; Wed, 28 Feb 2024 19:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709147239; cv=none; b=e5HFWJrNGFvslpwtO6wj/Y/g+OlOrbIJPbhnOijOYf2ViFjnT1ipJTW+vRya1h8+oBVIOKui20ci8S+6nq/7ErKQYADRcH9u/1svLkgb/5gakLjnAo4/8mQ/X4T2cDeSt3tJ9oNruWqNA9pACuOEPgGvwyOedKdqLxdcpscp6uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709147239; c=relaxed/simple;
	bh=Qz2Vdj2rBC2mJZbNt9ILBRIAFfLJFVWy5MELjmgC5jo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VrqcO///ZcOQXWJoNVq68q/L4bNzvjGEXFacBTPH3e1jF+9tC6jb0CRuigu3IZv2sprJtKw+1IFCIw48KXQYZmK1xfViM3PExZ6yGjoGZZTILYYosC8rmGvA4pPKhCyilfTaNtM+wrDRY7Gs8AZ6oQHlWQ8y0T4LfdwBeKOgfos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b6IR6NnT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b6IR6NnT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709147236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYV4SrxcohGt3HtzPUZ+rdkqbt8EWPpbUaoKo3V+foI=;
	b=b6IR6NnTAiiJfACCD7pQhVZY8mnAu67FqItpzgL0uGBR14TFGw69q2YKuKjzWWLiGPSCBZ
	+9f9UNgNVJLtD9yMljjuQg3EShhbGK3d8gwB9HbxFCMEljoGFj3KPf8YzF6IaLIT1jJfH6
	q/kahHO3zaVnx9VsdBdyGEKqMERRb9k=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-mzeSPoI_PZ6055kU9_9R1g-1; Wed, 28 Feb 2024 14:07:11 -0500
X-MC-Unique: mzeSPoI_PZ6055kU9_9R1g-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c7e21711d0so1530839f.3
        for <linux-crypto@vger.kernel.org>; Wed, 28 Feb 2024 11:07:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709147230; x=1709752030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rYV4SrxcohGt3HtzPUZ+rdkqbt8EWPpbUaoKo3V+foI=;
        b=ssVpQPD2TVuz2uYN+QutrWXFq74EvqoqXPAxBtw+w6Gf8J6ZWZb8yc+CZzGscXmVJD
         5K4SqW+sXsjpfK6t0JRIfqilFH1rPo6VNp+wiPs0i4QkrI4lUreOjgFmiVHLc56W0VuD
         ZZJWwJGGe7rrgRywl3Z/eIe5bYO2lj7cUYGIlfF9JzByZ9P31J6VMDd6V5l+XW2O+Mgp
         NglZCBzl/JkFYE1236y0qNZgi13LMwXl08NzORjIB+bNmKVDnMdV1JhdJaDI8YyTJTB+
         5KRMwEXkHoV3QDmnvps83/DQhcL26pfX7dzISHUStWbhvWPGR6mRcjDsC8ythitGMm0S
         jSoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUb7WP5XLHpn/6COcnM1/FhUC+Kv5On7UqExPyuMx5lp7gmNHRRsy0X5Je/+WT2Fm6jeM8SNKjRYJFqcgVCuJn5O10KehOTU23Bl3Uq
X-Gm-Message-State: AOJu0YwXwHxBfucabqtqCw5gEjgu0YOFrODjLtk+E6PBz4bAO0DNX/KK
	L4lcaN0fG7J3WUX30H8PF8fAw56Y6SXi7SP440lPgPh+FwcW3VmHCue7ShdukumsrctZyQaznH3
	IYsIyAzpT5KcpvjvgcK/7xbetNWPZxNPNjqfOqC7E48hp2w8BIj5N5iQjzItCKA==
X-Received: by 2002:a5e:c249:0:b0:7c7:8fda:e836 with SMTP id w9-20020a5ec249000000b007c78fdae836mr120305iop.0.1709147230206;
        Wed, 28 Feb 2024 11:07:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmyZUluB62eCjXZWTg6QnIXee6qM5qrhHOGBlbNEDBmI1cB3oVfXg/I91wseTQnvRrL5Hn8g==
X-Received: by 2002:a5e:c249:0:b0:7c7:8fda:e836 with SMTP id w9-20020a5ec249000000b007c78fdae836mr120281iop.0.1709147229895;
        Wed, 28 Feb 2024 11:07:09 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm2360704jab.22.2024.02.28.11.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 11:07:09 -0800 (PST)
Date: Wed, 28 Feb 2024 12:07:06 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Xin Zeng <xin.zeng@intel.com>, herbert@gondor.apana.org.au,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
 qat-linux@intel.com, Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240228120706.715bc385.alex.williamson@redhat.com>
In-Reply-To: <20240226152458.2b8a0f83.alex.williamson@redhat.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
	<20240221155008.960369-11-xin.zeng@intel.com>
	<20240226115556.3f494157.alex.williamson@redhat.com>
	<20240226191220.GM13330@nvidia.com>
	<20240226124107.4317b3c3.alex.williamson@redhat.com>
	<20240226194952.GO13330@nvidia.com>
	<20240226152458.2b8a0f83.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Feb 2024 15:24:58 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 26 Feb 2024 15:49:52 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Feb 26, 2024 at 12:41:07PM -0700, Alex Williamson wrote:  
> > > On Mon, 26 Feb 2024 15:12:20 -0400
> > > libvirt recently implemented support for managed="yes" with variant
> > > drivers where it will find the best "vfio_pci" driver for a device
> > > using an algorithm like Max suggested, but in practice it's not clear
> > > how useful that will be considering devices likes CX7 require
> > > configuration before binding to the variant driver.  libvirt has no
> > > hooks to specify or perform configuration at that point.    
> > 
> > I don't think this is fully accurate (or at least not what was
> > intended), the VFIO device can be configured any time up until the VM
> > mlx5 driver reaches the device startup.
> > 
> > Is something preventing this? Did we accidentally cache the migratable
> > flag in vfio or something??  
> 
> I don't think so, I think this was just the policy we had decided
> relative to profiling VFs when they're created rather than providing a
> means to do it though a common vfio variant driver interface[1].

Turns out that yes, migration support needs to be established at probe
time.  vfio_pci_core_register_device() expects migration_flags,
mig_ops, and log_ops to all be established by this point, which for
mlx5-vfio-pci occurs when the .init function calls
mlx5vf_cmd_set_migratable().

So the VF does indeed need to be "profiled" to enabled migration prior
to binding to the mlx5-vfio-pci driver in order to report support.

That also makes me wonder what happens if migration support is disabled
via devlink after binding the VF to mlx5-vfio-pci.  Arguably this could
be considered user error, but what's the failure mode and support
implication?  Thanks,

Alex


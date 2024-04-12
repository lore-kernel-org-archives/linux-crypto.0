Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9A115099C
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 23:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712962806; cv=none; b=tcpUEpPOpYlhvAi3xv2GkwmHhAm2JGQ1nAvd3RNj/ENkBwpsr3O1Bf3agCYMPsvNmjRmioJ2K0saaGBS55CzBhx97uuDz0yIC4Cj9X6knkCQXUUzdPuDMEu4pJg8sDAsDhQ92Wq6XzuW2+uMUK7Oys05HEIz4wwhpZKLNSLvu8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712962806; c=relaxed/simple;
	bh=e5jrULAtUKpdI5emYxz+qUL2+/vP0GWvcFutzVEdFCw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=blSMq/T4mhU4PKzFQeTvVS6NIZ4egC4mNF1VeYXrE3MC3xYat1anpF4vvGQlWuCPRKnJKKe6GDdA182F3YbAnOESmT2tjVN/mVoAWeal6NTn4+V8aggGvlSkQzelwsmYUQDJdJBsQ54+2cot9aJDqDO0O1vWQQOdQPPs+bPYDKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WD/eVOog; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WD/eVOog"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712962803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XtdF5YIQMmHx7s8x+KaNdKrE1bMDggAMXEluGAHCnoQ=;
	b=WD/eVOogLLTW/dtYpaPHTlZHKdjLUYHLL/VOuA5Xd/PGg4MTKRBMeqbEJPqYBZoGzyBJ4q
	73IZogenIXAzpESw6nQzphVaXzcI2todcXE7tcV5mfXJRcmMjg0ffY01b0p+DwQcwAfdDU
	Iz2E2SBajUWqfKlzOJbeXhke008dfW4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-Uu_igpuSO-6qlXb1X_pwfw-1; Fri, 12 Apr 2024 19:00:02 -0400
X-MC-Unique: Uu_igpuSO-6qlXb1X_pwfw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7d6bf30c9e3so82202739f.2
        for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 16:00:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712962801; x=1713567601;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XtdF5YIQMmHx7s8x+KaNdKrE1bMDggAMXEluGAHCnoQ=;
        b=ol/QmsRc+NPbEbS/kYp1TNpCg8jx33puzJ5wZ2Fsm+dnVtv+J6xdvKQc5OtuTvhM/E
         pdUQIoyPgiCMsEM5X1S/GQfa1cj5yCz3po2OxrXn8IoX9HPFRLcE+cfwHdZJjiNAfL8m
         vSQwKiVzSjZF1xxgKWY5l21HlCd1N3Uvc2GaBVhNSKQ1w64xl+Q3gQSXua0L7S+rJAqS
         huVzf6KQrhQNCliTLif8o8Gaa7Hg1Va9kOegtmA1peSnzgNaHAStuKp/WJwQXljYzH6k
         x5x9G+JuerpyL6DoIYoCn8OB5yWuMJAZyx0ebZgxi7ynbxRQ7IEsGEi1AXoh201CJIB3
         Qw9g==
X-Forwarded-Encrypted: i=1; AJvYcCXjlHNK4Yy7n+JXK0BI0PUaGPQFUF1UyEZ5HCzyGXYyBBcnQCvhQRsGcTfC+o7BOpEQdydraaDV5e00Vr7KBIPIOUqFzr0Akp+ZXCra
X-Gm-Message-State: AOJu0YwU3mD82xlWdDHLTfDwlj5/aYcQsI2DLbVqLi2weGEOeWO1xnUZ
	ZfV65iNJySRpLHk6X3+fldqMndvg21To90xcuVggXpUhICvT1jgnF15vo2VIRhhBn5g/qvsezmv
	68+Igbhk89B1uId6SYdXOsmQatTEKlyO0Asyzt/DSvt/ISGT6HaKQ7m6ehtQl9Q==
X-Received: by 2002:a05:6602:3e86:b0:7d0:ba6f:92c5 with SMTP id el6-20020a0566023e8600b007d0ba6f92c5mr5359838iob.13.1712962801557;
        Fri, 12 Apr 2024 16:00:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpPzwFiwRVcn16zKGoAaDgOZpZ3ArB1zhEd7Vx4LLD00B6pR02mVtTXKuGag0ybQX8PSGIuw==
X-Received: by 2002:a05:6602:3e86:b0:7d0:ba6f:92c5 with SMTP id el6-20020a0566023e8600b007d0ba6f92c5mr5359817iob.13.1712962801258;
        Fri, 12 Apr 2024 16:00:01 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id bp15-20020a056638440f00b00482c7617f1dsm1338296jab.25.2024.04.12.16.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 16:00:00 -0700 (PDT)
Date: Fri, 12 Apr 2024 16:59:59 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Xin Zeng <xin.zeng@intel.com>,
 <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
 <qat-linux@intel.com>
Subject: Re: [PATCH v5 00/10] crypto: qat - enable QAT GEN4 SRIOV VF live
 migration for QAT GEN4
Message-ID: <20240412165959.4b7aefad.alex.williamson@redhat.com>
In-Reply-To: <ZhlC4lWg1ExOuNnl@gcabiddu-mobl.ger.corp.intel.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
	<ZgVLvdhhU6o7sJwF@gondor.apana.org.au>
	<20240328090349.4f18cb36.alex.williamson@redhat.com>
	<Zgty1rGVX+u6RRQf@gondor.apana.org.au>
	<ZhlC4lWg1ExOuNnl@gcabiddu-mobl.ger.corp.intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Apr 2024 15:19:14 +0100
"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com> wrote:

> Hi Alex,
> 
> On Tue, Apr 02, 2024 at 10:52:06AM +0800, Herbert Xu wrote:
> > On Thu, Mar 28, 2024 at 09:03:49AM -0600, Alex Williamson wrote:  
> > >
> > > Would you mind making a branch available for those in anticipation of
> > > the qat vfio variant driver itself being merged through the vfio tree?
> > > Thanks,  
> > 
> > OK, I've just pushed out a vfio branch.  Please take a look to
> > see if I messed anything up.  
> What are the next steps here?
> 
> Shall we re-send the patch `vfio/qat: Add vfio_pci driver for Intel QAT
> VF devices` rebased against vfio-next?
> Or, wait for you to merge the branch from Herbert, then rebase and re-send?
> Or, are you going to take the patch that was sent to the mailing list as is
> and handle the rebase? (There is only a small conflict to sort on the
> makefiles).

Hi Giovanni,

The code itself looks fine to me, the Makefile conflict is trivial,
MAINTAINERS also requires a trivial re-ordering to keep it alphabetical
now that virtio-vfio-pci is merged.  The only thing I spot that could
use some attention is the documentation, where our acceptance criteria
requests:

  Additionally, drivers should make an attempt to provide sufficient
  documentation for reviewers to understand the device specific
  extensions, for example in the case of migration data, how is the
  device state composed and consumed, which portions are not otherwise
  available to the user via vfio-pci, what safeguards exist to validate
  the data, etc.

A lot of the code here is very similar in flow to the other migration
drivers, but I think it would be good to address some of the topics
above in comments throughout the driver.  For example, how does the
driver address P2P states, what information is provided in PRE_COPY,
how is versioning handled, is user sensitive data included in the
device migration data, typical ranges of device migration data size,
etc.

Kevin might have an edge in understanding the theory of operation
here already and documenting the interesting aspects of the driver in
comments might drive a little more engagement.  Thanks,

Alex


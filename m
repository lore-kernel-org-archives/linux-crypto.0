Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A0A5644E
	for <linux-crypto@vger.kernel.org>; Mon, 18 Mar 2024 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710784736; cv=none; b=GTwUPLqCm8VM3GenVN98muyQtyLcvcUelJPdRzfGFk33NNbCtEmyfzAwhx5UyIaQfqiv00BVzVj7ZgHH7IH0SR/Dh5Ya/RzJCExKBbAwtS6UkqRyuuw8BrGxPTkyYJc7mm58J6eKa+bIirJ9HipgX3JL8GzXw6VO0vy6I7h0eJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710784736; c=relaxed/simple;
	bh=M0lYPdq6gZvP9XA7abbEiFJfN+8f8N/2HWpURxOJKy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ped/aUJjHqX2ZNR/Q8odLcld9M96J1asGTAyTUBU6pUfIpC2L3Wz2SYnmMeDgPO9E9WCaG9b1acrzkwz3mlcIFhQDeJyNSMF7DZejbouyUkdjVXOTzW1m7KnUiwEu15fFhDa4Ooa/V15XapIiimKf9VFLIvXdkrGK11eI6opaYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CRDsZBeH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRDsZBeH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710784733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=okOiWDrPolsdiUTKJz5kckyz9ECFo32ZFjUOlTarkZM=;
	b=CRDsZBeH2Zwo1hHMRpfe97hr3aBGaq2jC+7DYatUVx90HYE/lPXUH8jHzdgq3Ouggxf4Ur
	baGxJ/dpOS9VmnArtdQKMyTLJVBdTw3oeHGoQ/SJ6lKhkeSOdR6Tlh1VUB6wHD/cSL7zOi
	Fq2jnReeZuvzWcWTS1/F63XkcQmdmSo=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-8uRhjiACPniW5RnGARHD_w-1; Mon, 18 Mar 2024 13:58:51 -0400
X-MC-Unique: 8uRhjiACPniW5RnGARHD_w-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-47669714d2cso397083137.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 Mar 2024 10:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710784731; x=1711389531;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=okOiWDrPolsdiUTKJz5kckyz9ECFo32ZFjUOlTarkZM=;
        b=N1nWrZiHGoIhkGhYseVtqObEs1gF5XdWjHXWdO+7rYnJMxKcgIVHXPTpWiKa0msGDj
         N+X3IafCLNnY6DgWEFmDpktUonBM+LeN9KG1ctdDVIwDyrtshBwW5v2S3lCApiWNVuRG
         psUWwjzUGsxsJj/5jB0CQJx2Ofd67uINtVbYlQSlzzKd9wcYvK4xkBrM7ujdAojbXR/D
         KY/WZwLTa/KOgNx7O9QazGPUz5WXWwAWAZM76DO4Gc88fWCn+IzWOZuNYNdyo+kELe0d
         9vVymOCk3fE0VZVXKeTQszSb2yZ9l/DV9n5syoh9hZQqynsfQebkRxg540rV5HyrQAL4
         GL0w==
X-Forwarded-Encrypted: i=1; AJvYcCXJj7PaX9Yth7zOcs2XsxyYfCJaWDRXSEfiaX61TygYUBpe05ru4PShb5g2sswqiscFVAlw0btQqxxKc90GuvydRgg99cOvfI2KVJ/1
X-Gm-Message-State: AOJu0YwKelbyYF0k9mgWBSvP2MsufLQbAv2i8MlY3HHAxhUm1Aax/kJv
	a3neRQGVGLXdOZvxeJSzOFFs2RApquuuWrig2bFs4FEBZlxku0TP5ciisEsoM7LD8fUNL9AYlWP
	I83cU4ynYYp/ljDWV47s3gK5dAn0mwlgvzOxUkHGTlC9LAJvZcw7KmXYCJfRFwg==
X-Received: by 2002:a05:6102:4c58:b0:474:c443:2fd6 with SMTP id jz24-20020a0561024c5800b00474c4432fd6mr36113vsb.10.1710784730973;
        Mon, 18 Mar 2024 10:58:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFml4BWyqgb5yrN/Dv4NEnw0o0gvweGci2BQdvBDDj8fBXECnj4qB5vcGgeQidcdW+hW4V/Dg==
X-Received: by 2002:a05:6102:4c58:b0:474:c443:2fd6 with SMTP id jz24-20020a0561024c5800b00474c4432fd6mr36096vsb.10.1710784730596;
        Mon, 18 Mar 2024 10:58:50 -0700 (PDT)
Received: from localhost (ip70-163-216-141.ph.ph.cox.net. [70.163.216.141])
        by smtp.gmail.com with ESMTPSA id x8-20020a0c8e88000000b006915f47090dsm5423797qvb.68.2024.03.18.10.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 10:58:49 -0700 (PDT)
Date: Mon, 18 Mar 2024 10:58:46 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa: Fix some errors in IAA documentation
Message-ID: <hdb2l73guzxz2ck5qbkvpmpfiez646t33ocfqawdgxrnemwrpp@izvr4k6b2jft>
References: <20240318064421.833348-1-jsnitsel@redhat.com>
 <jhpuhcengkgdpgyb7qsez4lugpa5nhjjn3zqehbcbrtr2xh5md@cc3vz7v2xzdu>
 <f6487dcb03a31c35c272225197af87795df2a409.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6487dcb03a31c35c272225197af87795df2a409.camel@linux.intel.com>

On Mon, Mar 18, 2024 at 11:26:31AM -0500, Tom Zanussi wrote:
> Hi Jerry,
> 
> On Mon, 2024-03-18 at 00:49 -0700, Jerry Snitselaar wrote:
> > On Sun, Mar 17, 2024 at 11:44:21PM -0700, Jerry Snitselaar wrote:
> > > This cleans up the following issues I ran into when trying to use
> > > the
> > > scripts and commands in the iaa-crypto.rst document.
> > > 
> > > - Fix incorrect arguments being passed to accel-config
> > >   config-wq.
> > >     - Replace --device_name with --driver-name.
> > >     - Replace --driver_name with --driver-name.
> > >     - Replace --size with --wq-size.
> > >     - Add missing --priority argument.
> > > - Add missing accel-config config-engine command after the
> > >   config-wq commands.
> > > - Fix wq name passed to accel-config config-wq.
> > > - Add rmmod/modprobe of iaa_crypto to script that disables,
> > >   then enables all devices and workqueues to avoid enable-wq
> > >   failing with -EEXIST when trying to register to compression
> > >   algorithm.
> > > - Fix device name in cases where iaa was used instead of iax.
> > > 
> > > Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
> > > Cc: Jonathan Corbet <corbet@lwn.net>
> > > Cc: linux-crypto@vger.kernel.org
> > > Cc: linux-doc@vger.kernel.org
> > > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > > ---
> > >  .../driver-api/crypto/iaa/iaa-crypto.rst      | 22 ++++++++++++++-
> > > ----
> > >  1 file changed, 16 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > > b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > > index de587cf9cbed..330d35df5f16 100644
> > > --- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > > +++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> > > @@ -179,7 +179,9 @@ has the old 'iax' device naming in place) ::
> > >  
> > >    # configure wq1.0
> > >  
> > > -  accel-config config-wq --group-id=0 --mode=dedicated --
> > > type=kernel --name="iaa_crypto" --device_name="crypto" iax1/wq1.0
> > > +  accel-config config-wq --group-id=0 --mode=dedicated --
> > > type=kernel --priority=10 --name="iaa_crypto" --driver-
> > > name="crypto" iax1/wq1.0
> > > +
> > > +  accel-config config-engine iax1/engine1.0 --group-id=0
> > >  
> > >    # enable IAA device iax1
> > >  
> > > @@ -536,12 +538,20 @@ The below script automatically does that::
> > >  
> > >    echo "End Disable IAA"
> > >  
> > > +  echo "Reload iaa_crypto module"
> > > +
> > > +  rmmod iaa_crypto
> > > +  modprobe iaa_crypto
> > > +
> > > +  echo "End Reload iaa_crypto module"
> > > +
> > >    #
> > >    # configure iaa wqs and devices
> > >    #
> > >    echo "Configure IAA"
> > >    for ((i = 1; i < ${num_iaa} * 2; i += 2)); do
> > > -      accel-config config-wq --group-id=0 --mode=dedicated --
> > > size=128 --priority=10 --type=kernel --name="iaa_crypto" --
> > > driver_name="crypto" iax${i}/wq${i}
> > > +      accel-config config-wq --group-id=0 --mode=dedicated --wq-
> > > size=128 --priority=10 --type=kernel --name="iaa_crypto" --driver-
> > > name="crypto" iax${i}/wq${i}.0
> > > +      accel-config config-engine iax${i}/engine${i}.0 --group-id=0
> > >    done
> > >  
> > >    echo "End Configure IAA"
> > > @@ -552,10 +562,10 @@ The below script automatically does that::
> > >    echo "Enable IAA"
> > >  
> > >    for ((i = 1; i < ${num_iaa} * 2; i += 2)); do
> > > -      echo enable iaa iaa${i}
> > > -      accel-config enable-device iaa${i}
> > > -      echo enable wq iaa${i}/wq${i}.0
> > > -      accel-config enable-wq iaa${i}/wq${i}.0
> > > +      echo enable iaa iax${i}
> > > +      accel-config enable-device iax${i}
> > > +      echo enable wq iax${i}/wq${i}.0
> > > +      accel-config enable-wq iax${i}/wq${i}.0
> > >    done
> > >  
> > >    echo "End Enable IAA"
> > > -- 
> > > 2.41.0
> > > 
> > 
> > In addition to the above, the sections related to the modes seem
> > to be off to me.
> > 
> > Legacy mode in the Intel IOMMU context is when the IOMMU does not
> > have
> > scalable mode enabled. If you pass intel_iommu=off the Intel IOMMU
> > will not be initialized, and I think that would correspond to the No
> > IOMMU
> > mode instead of Legacy mode. The other suggestion for Legacy mode of
> > disabling VT-d in the BIOS would also be No IOMMU mode, but in
> > addition to the dma remapping units being disabled it would disable
> > interrupt remapping since the DMAR table would no longer be presented
> > to the OS by the BIOS.
> > 
> > I think the modes should be:
> > 
> > Scalable mode: intel_iommu=on,sm_on
> > Legacy mode: intel_iommu=on
> > No IOMMU mode: intel_iommu=off (or VT-d disabled in BIOS)
> > 
> 
> Yes, I think you're correct, those make more sense.
> 
> > Since Intel IOMMU and scabale mode have config options that allow
> > them
> > to be enabled by default, there are different parameter variations
> > that would match the above cases. I don't know if they need to
> > be detailed here, or if it would just make it more confusing.
> > 
> 
> Personally, I think it would be useful to have them detailed and might
> lessen confusion for people setting things up and/or debugging a setup.
> 
> Thanks,
> 
> Tom

Hi Tom,

This is what I came up with last night for the kernel parameters when thinking about it:


| mode \ default enable | intel_iommu + /sm + | intel_iommu + / sm - | intel_iommu - / sm +  | intel_iommu - / sm - |
|-----------------------+---------------------+----------------------+-----------------------+----------------------|
| Scalable Mode         | nothing             | intel_iommu=sm_on    | intel_iommu=on        | intel_iommu=on,sm_on |
| Legacy Mode           | intel_iommu=sm_off  | nothing              | intel_iommu=on,sm_off | intel_iommu=on       |
| No IOMMU Mode         | intel_iommu=off     | intel_iommu=off      | nothing               | nothing              |


Regards,
Jerry



> 
> > Regards,
> > Jerry
> > 
> 


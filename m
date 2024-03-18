Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A8522EFB
	for <linux-crypto@vger.kernel.org>; Mon, 18 Mar 2024 07:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710748166; cv=none; b=VYwFmrkyvqSL/sTA6QrIq5BevlhTYwgi7QpdHnJIN0THkFJT1i+j5Ts12+e0VUOLHLbatgyv9SgpGiEwjgy+uWROajju4oVAlcmSV11xHTg9ovsgwWh2JzykznbpAcvnZfd9ceV+GmsZgWuasV1EEz+z/A9mj7Fi7qDh1RTmL1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710748166; c=relaxed/simple;
	bh=15xcVyjtS23QwfOxh5npEThTgAr9K+GFqp6y/Hir+nI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUa35jDl0S2rWQ/u96/8/mg+NlRv9Df40QsASxJjerXBxzLWuQBLH5vTB+BX1ylGuA7pK0vDYPa3s6PI4wO3B4bDVwMD68XIqfdg7qKrPayU5cbZTd1UXFkNrWjZtOzUC5ZxrOfgwGL7DoPqWfotbeWsO3F3q5tepXvYwUweYM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chMVj7YM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chMVj7YM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710748163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hw3N3rKbRfObqQCjnzMro1ULUvDI+xFvOVwAh3eTCiU=;
	b=chMVj7YMhI3uVZ9p5gPALWL3+O9E9iEE3lTgNmSIEKrVnzyV6vpt+fccUVS1BYJz6hMjoG
	a0oIEQWMwOV6CLUIx41pyuSI3FCuktjFpC5S18cLzs3p92bZfJsvHz8V4XbFsucASoEQO+
	HMGZ3uqt0LxVIApiF7hU+XJRWiZDf3I=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-sNcyokC-NomJZNQFAjnaoQ-1; Mon, 18 Mar 2024 03:49:22 -0400
X-MC-Unique: sNcyokC-NomJZNQFAjnaoQ-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-430baecb018so25956971cf.2
        for <linux-crypto@vger.kernel.org>; Mon, 18 Mar 2024 00:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710748161; x=1711352961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hw3N3rKbRfObqQCjnzMro1ULUvDI+xFvOVwAh3eTCiU=;
        b=PJZq6jHprOBhrwR0J7xI1FZXE7whjnj4sVe1Z56M2OhPgPV7EbbU5Xpc2dzUbl8w1y
         oZsq2lhj4HXzzF9OXqwvzVhU1t8CRKMyR8MbDtdXM5bxemsT7Dy1PdBEhAnvLGBO532A
         HSnHXv4e1y7+HCD6WSbmA92cee/rgeb7J43lRLabse1qhAeehkbG+tExldUGA7Jqy+3/
         sMHja2euDExfXWviN6FHXDkICA7wm8mVTQHaNQpeU3HCY+Vo7/0szUpOUtqpBYt8fhJ9
         DXuF8zDecCjfUAo+8TqJNFROGGvt4qAlasnhis92IaUuf/IIjYG/ddt61Axm9B3Gn2oJ
         pWbA==
X-Forwarded-Encrypted: i=1; AJvYcCWe01qNqCdX3+7f/eyNeRiyzPPETzjcSvdRNTKQn3FsimXyN67ObIAg3J5pkhtoucAqLveF41601ZHPXHtOByPuL6lLGn0y/Ki3u1ty
X-Gm-Message-State: AOJu0YzIIL0kfRzQ2OaTZSu4bpPYUlArI9eNMH/FpTALdc/2vHv6zaqP
	EPA3CkcPSHhoTM4kU7mWKoAxRWk2fNDrXecgZcK33rKdU2vQJ/yDl67V3Z75/PRFQpoPi7ydbZ9
	xdjvJIr8a81UviKgn+fkBrVyjOFKz4VQbRA1sOu6UZUO/eYuzvU/m4JTj/tolaQ==
X-Received: by 2002:ac8:7d0e:0:b0:430:c769:c747 with SMTP id g14-20020ac87d0e000000b00430c769c747mr4158275qtb.22.1710748161575;
        Mon, 18 Mar 2024 00:49:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUm3RY8ZnlG2VNiVbIkjz1nSzJks63N+Pz5IdxrajiTHHgE59rRqHBxHQ/JyqB9k3qzRWU1A==
X-Received: by 2002:ac8:7d0e:0:b0:430:c769:c747 with SMTP id g14-20020ac87d0e000000b00430c769c747mr4158261qtb.22.1710748161261;
        Mon, 18 Mar 2024 00:49:21 -0700 (PDT)
Received: from localhost (ip70-163-216-141.ph.ph.cox.net. [70.163.216.141])
        by smtp.gmail.com with ESMTPSA id h20-20020ac87154000000b0042c61b99f42sm4715917qtp.46.2024.03.18.00.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 00:49:20 -0700 (PDT)
Date: Mon, 18 Mar 2024 00:49:19 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa: Fix some errors in IAA documentation
Message-ID: <jhpuhcengkgdpgyb7qsez4lugpa5nhjjn3zqehbcbrtr2xh5md@cc3vz7v2xzdu>
References: <20240318064421.833348-1-jsnitsel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318064421.833348-1-jsnitsel@redhat.com>

On Sun, Mar 17, 2024 at 11:44:21PM -0700, Jerry Snitselaar wrote:
> This cleans up the following issues I ran into when trying to use the
> scripts and commands in the iaa-crypto.rst document.
> 
> - Fix incorrect arguments being passed to accel-config
>   config-wq.
>     - Replace --device_name with --driver-name.
>     - Replace --driver_name with --driver-name.
>     - Replace --size with --wq-size.
>     - Add missing --priority argument.
> - Add missing accel-config config-engine command after the
>   config-wq commands.
> - Fix wq name passed to accel-config config-wq.
> - Add rmmod/modprobe of iaa_crypto to script that disables,
>   then enables all devices and workqueues to avoid enable-wq
>   failing with -EEXIST when trying to register to compression
>   algorithm.
> - Fix device name in cases where iaa was used instead of iax.
> 
> Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> ---
>  .../driver-api/crypto/iaa/iaa-crypto.rst      | 22 ++++++++++++++-----
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> index de587cf9cbed..330d35df5f16 100644
> --- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> +++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
> @@ -179,7 +179,9 @@ has the old 'iax' device naming in place) ::
>  
>    # configure wq1.0
>  
> -  accel-config config-wq --group-id=0 --mode=dedicated --type=kernel --name="iaa_crypto" --device_name="crypto" iax1/wq1.0
> +  accel-config config-wq --group-id=0 --mode=dedicated --type=kernel --priority=10 --name="iaa_crypto" --driver-name="crypto" iax1/wq1.0
> +
> +  accel-config config-engine iax1/engine1.0 --group-id=0
>  
>    # enable IAA device iax1
>  
> @@ -536,12 +538,20 @@ The below script automatically does that::
>  
>    echo "End Disable IAA"
>  
> +  echo "Reload iaa_crypto module"
> +
> +  rmmod iaa_crypto
> +  modprobe iaa_crypto
> +
> +  echo "End Reload iaa_crypto module"
> +
>    #
>    # configure iaa wqs and devices
>    #
>    echo "Configure IAA"
>    for ((i = 1; i < ${num_iaa} * 2; i += 2)); do
> -      accel-config config-wq --group-id=0 --mode=dedicated --size=128 --priority=10 --type=kernel --name="iaa_crypto" --driver_name="crypto" iax${i}/wq${i}
> +      accel-config config-wq --group-id=0 --mode=dedicated --wq-size=128 --priority=10 --type=kernel --name="iaa_crypto" --driver-name="crypto" iax${i}/wq${i}.0
> +      accel-config config-engine iax${i}/engine${i}.0 --group-id=0
>    done
>  
>    echo "End Configure IAA"
> @@ -552,10 +562,10 @@ The below script automatically does that::
>    echo "Enable IAA"
>  
>    for ((i = 1; i < ${num_iaa} * 2; i += 2)); do
> -      echo enable iaa iaa${i}
> -      accel-config enable-device iaa${i}
> -      echo enable wq iaa${i}/wq${i}.0
> -      accel-config enable-wq iaa${i}/wq${i}.0
> +      echo enable iaa iax${i}
> +      accel-config enable-device iax${i}
> +      echo enable wq iax${i}/wq${i}.0
> +      accel-config enable-wq iax${i}/wq${i}.0
>    done
>  
>    echo "End Enable IAA"
> -- 
> 2.41.0
> 

In addition to the above, the sections related to the modes seem
to be off to me.

Legacy mode in the Intel IOMMU context is when the IOMMU does not have
scalable mode enabled. If you pass intel_iommu=off the Intel IOMMU
will not be initialized, and I think that would correspond to the No IOMMU
mode instead of Legacy mode. The other suggestion for Legacy mode of
disabling VT-d in the BIOS would also be No IOMMU mode, but in
addition to the dma remapping units being disabled it would disable
interrupt remapping since the DMAR table would no longer be presented
to the OS by the BIOS.

I think the modes should be:

Scalable mode: intel_iommu=on,sm_on
Legacy mode: intel_iommu=on
No IOMMU mode: intel_iommu=off (or VT-d disabled in BIOS)


Since Intel IOMMU and scabale mode have config options that allow them
to be enabled by default, there are different parameter variations
that would match the above cases. I don't know if they need to
be detailed here, or if it would just make it more confusing.


Regards,
Jerry


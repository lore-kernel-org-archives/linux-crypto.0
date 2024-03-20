Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC9186151
	for <linux-crypto@vger.kernel.org>; Wed, 20 Mar 2024 23:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710978727; cv=none; b=e6Ii0awNLPafBAYlUXkpUnzxl4Rs3veXiLr3fyrDGDKlnkwyazR4kKval6IFDqnx7Mbw8/f3Rs8GLO0mcxRDKBJcL4g6HFufGt08fGHH/ebEzVJRAGex7K/b97DqgOz8uUPuxjaeeVIz8n+hKKfpDl3B79CMeQhEpztGwpTU6cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710978727; c=relaxed/simple;
	bh=v1xqrfSCsLOu3FlzspginDA5QopRKJ5Kf48HMRMuLwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5P9euEsfU1qxSdOhXnqaS2WWteu67iA9WKAU3kKTNk4wx3x5fnA9Hhfb0M711xfy92jMD/eo4upduTkdTG3pWR6p7VCoAweK5EXng6BKZEVNZyo2SWaAcaqXTnvNGmvYgqQfDaWX03mye1SwTpHoAfVMbrXiG7q8EQZicDNncg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZSwpkjYy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZSwpkjYy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710978724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mHY5OWpWUzvCDWgSbn3vIS3+1WVWz1gYsRbJ6daTcx4=;
	b=ZSwpkjYyxHa9Zb2bvY0vdf/NUnE+M8FX8YlecgzUraXhcStDG3gpZIbVWrALuuZz2APBbr
	kCA0JFUj/mVHZ4rYWR/2oMSLr0eEwfqeV9zhNZODJ8adT6fvryHAK3V/HCddlKcML4O/B9
	i0ki4tWoVphyjCO71riQNs/AZx0YQww=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-Oe2gQH_nN2uO-F1KUgBfUg-1; Wed, 20 Mar 2024 19:52:02 -0400
X-MC-Unique: Oe2gQH_nN2uO-F1KUgBfUg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-696429af0efso23602336d6.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 Mar 2024 16:52:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710978722; x=1711583522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mHY5OWpWUzvCDWgSbn3vIS3+1WVWz1gYsRbJ6daTcx4=;
        b=fdMeSPOw06tAWKD0lTlUYSw3vl0ZTJLenlkInboZ6PAaV3Xht2jn1jwExMqKAEdCYG
         C6AwnNEzz/ucjP7pO4qZn6z+2T7h+iwLx2nWF05HO5/B0s8MyvyAFWkS26goQc5eqHEO
         hF5D8vjvU3Br7AQl5VObvkJJOcLLUXlflB3E32tby7e2oAgp1UT0pRet4Jed3FrUJ7yo
         4bPaOUz+lHHE6ib6D9MxPnaPdV6cby/ugx3M9wSpzzCLNv2beiExPjpY1Wxab9T0OTHv
         v6VV+QioNr+7VPju/nRaA/2e01rV94LK+ilBj2WD7Yyk83i9poGgbktdHKN9hji8CTn/
         Bztw==
X-Forwarded-Encrypted: i=1; AJvYcCVM44LLX93pcz5+LD3/E66tt7PrgBxpD0MbKMw10tuYuLMnLymml6dp9amBKlck8wGvXdtNuQP3+eeCQvsFNNUeF/UZiUSs1VOkDfss
X-Gm-Message-State: AOJu0Yyu7jO4Dbqa9Ef0bJ2VnJ1z7bkyS5IunCF/XSypkbwjs4skAXn3
	xFutY2yO+KcPeoYab72OY1ii5+hhCxTWAEJZTtky0ebGnNoSV3LcrJwYWI/41oRhvdgJu9qqmRh
	mWYrj3jtuz8FpoU/LrkDZQ7Ve4eT8/XwE+P8qjtyScFz9qpdmcw7w81wSamp4boMP7u1wTA==
X-Received: by 2002:a05:6214:c6a:b0:696:4488:dcd8 with SMTP id t10-20020a0562140c6a00b006964488dcd8mr2114444qvj.29.1710978721898;
        Wed, 20 Mar 2024 16:52:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOwpKZngf/SbzUQavt1JLU5f+FR2L/a6VXdEYnU9pgqZdVS8wEuKq0iqH70cyUKInPUhEyYA==
X-Received: by 2002:a05:6214:c6a:b0:696:4488:dcd8 with SMTP id t10-20020a0562140c6a00b006964488dcd8mr2114435qvj.29.1710978721631;
        Wed, 20 Mar 2024 16:52:01 -0700 (PDT)
Received: from localhost (ip70-163-216-141.ph.ph.cox.net. [70.163.216.141])
        by smtp.gmail.com with ESMTPSA id jl10-20020ad45e8a000000b0069019c6eff1sm8316497qvb.31.2024.03.20.16.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 16:52:01 -0700 (PDT)
Date: Wed, 20 Mar 2024 16:51:59 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>, 
	Vladis Dronov <vdronov@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: Divide by zero in iaa_crypto during boot of a kdump kernel
Message-ID: <wiux57n6yvk5mkysy3fmsmehzepghkphjwexco6gluhhu2vver@c5lj735s3sd5>
References: <hyf3fggjvnjjdbkk4hvocmlfhbz2wapxjhmppurthqavgvk23m@j47q5vlzb2om>
 <39f73bd559aa96051b4d5c8e42d0ce942194b64f.camel@linux.intel.com>
 <4e917f9a299c46c82e1eb206c26e349fb7d810e7.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e917f9a299c46c82e1eb206c26e349fb7d810e7.camel@linux.intel.com>

On Wed, Mar 20, 2024 at 01:13:48PM -0500, Tom Zanussi wrote:
> Hi Jerry,
> 
> On Tue, 2024-03-19 at 17:19 -0500, Tom Zanussi wrote:
> > Hi Jerry,
> > 
> > On Tue, 2024-03-19 at 13:51 -0700, Jerry Snitselaar wrote:
> > > Hi Tom,
> > > 
> > > While looking at a different issue on a GNR system I noticed that
> > > during the boot of the kdump kernel it crashes when probing
> > > iaa_crypto
> > > due to a divide by zero in rebalance_wq_table. The problem is that
> > > the
> > > kdump kernel comes up with a single cpu, and if there are multiple
> > > iaa
> > > devices cpus_per_iaa is going to be calculated to be 0, and then
> > > the
> > > 'if ((cpu % cpus_per_iaa) == 0)' in rebalance_wq_table results in a
> > > divide by zero. I reproduced it with the 6.8 eln kernel, and so far
> > > have reproduced it on GNR, EMR, and SRF systems. I'm assuming the
> > > same
> > > will be the case on and SPR system with IAA devices enabled if I
> > > can
> > > find one.
> > > 
> > 
> > Good catch, I've never tested that before. Thanks for reporting it.
> > 
> > > Should save_iaa_wq return an error if the number of iaa devices is
> > > greater
> > > than the number of cpus?
> > > 
> > 
> > No, you should still be able to use the driver with just one cpu,
> > maybe
> > it just always maps to the same device. I'll take a look and come up
> > with a fix.
> > 
> > Tom
> 
> The patch below fixes it for me. It gets rid of the crash and I was
> able to run some basic tests successfully.
> 
> Tom 
> 

It avoids the crash for me.

Regards,
Jerry

> 
> From 37dc97831c9e12c103115cb5fc9866b42cad7bc5 Mon Sep 17 00:00:00 2001
> From: Tom Zanussi <tom.zanussi@linux.intel.com>
> Date: Wed, 20 Mar 2024 05:37:11 -0700
> Subject: [PATCH] crypto: iaa - Fix nr_cpus < nr_iaa case
> 
> If nr_cpus < nr_iaa, the calculated cpus_per_iaa will be 0, which
> causes a divide-by-0 in rebalance_wq_table().
> 
> Make sure cpus_per_iaa is 1 in that case, and also in the nr_iaa == 0
> case, even though cpus_per_iaa is never used if nr_iaa == 0, for
> paranoia.
> 
> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> index 1cd304de5388..b2191ade9011 100644
> --- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> +++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> @@ -806,6 +806,8 @@ static int save_iaa_wq(struct idxd_wq *wq)
>  		return -EINVAL;
>  
>  	cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
> +	if (!cpus_per_iaa)
> +		cpus_per_iaa = 1;
>  out:
>  	return 0;
>  }
> @@ -821,10 +823,12 @@ static void remove_iaa_wq(struct idxd_wq *wq)
>  		}
>  	}
>  
> -	if (nr_iaa)
> +	if (nr_iaa) {
>  		cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
> -	else
> -		cpus_per_iaa = 0;
> +		if (!cpus_per_iaa)
> +			cpus_per_iaa = 1;
> +	} else
> +		cpus_per_iaa = 1;
>  }
>  
>  static int wq_table_add_wqs(int iaa, int cpu)
> -- 
> 2.34.1
> 
> 


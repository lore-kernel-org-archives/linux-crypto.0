Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B195392837
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 09:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781169041; cv=none; b=LY1hehwhY48ROz8GVdeVY6Pft6YFydLIy7tURKCoO998YDo9BmYJypMGJxCtzZyDaYHGPOwh23EdSMZBzUvqyD6VziPa7iapLkge5ZP0iMjs+KPI3x1Jh5INB1u2NnixINT+SVMA7h2zQsTpurgQHkl71M62+bhyHvDhhQ1sWbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781169041; c=relaxed/simple;
	bh=ngimsOS9hzgh2ezE0TEY4e5wFmKWHB3Fv7cSOMsZbsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSDZ9r+KqdAbKmDk4a/GtQS86R7wtgdm2QjegNFTCCOhAdAj84IjNXK8gz7X1k/Q0tsYavhO/Dss/Wk4iGrGZZ5muZcMDdsSFyGQ317f7oKQjSsclZyW0WMnp7/cdekmaBqsWuvvJEtrXsdp++yLIiuNYjKi3tDTymsm7O+pHKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b0VLzkWY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=b2NAjCs+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b0VLzkWY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="b2NAjCs+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781169039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PriinPzTGWMIUfhykveslGOYnSGaX13PaffHy++jEKM=;
	b=b0VLzkWYkVtVbBPnsPDFwqjZnPmyJ691S3rsZu3Q+pBmmA36Xig2s7uBBsNME/HEWGq1ae
	bJEtoTY/pld3iMc424/p3QBhUhFaTiJiwiS8YbhRq2BJVUQjB68R2YaZXbFi3hAA91Ilqo
	z6wsD9T8Frzeh2M0xjFlBwhcfeYP4hg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-hp5MMLPaMkCcuTvEhyYUGg-1; Thu, 11 Jun 2026 05:10:37 -0400
X-MC-Unique: hp5MMLPaMkCcuTvEhyYUGg-1
X-Mimecast-MFC-AGG-ID: hp5MMLPaMkCcuTvEhyYUGg_1781169037
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-460198535bcso4970425f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 02:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781169036; x=1781773836; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PriinPzTGWMIUfhykveslGOYnSGaX13PaffHy++jEKM=;
        b=b2NAjCs+yiocQ1EEMnKNWuTgzwjJqAoJvYaTBkId6WNxbzMw8MGCP+L0EnWjUKIqjI
         t9AjeHcGq7Rx+ml1EHQYMaSVyuSN9nCvMAY3cC50auM7kSzIpi1DvcKZ9gW71YvhqYGS
         /DSict8K0+f+y1mYNSFCQ6we744ImjdMrqboGFaRct0gz81QBQ9RgK7dts5HYflLNEJn
         WdXhiRZTvyxvNlNnjwqGgIFdEQHCmOxz6qsNT1yyQm/LT2rLCvewN5A6tTBNI5VxHD5i
         YbIXpLh4d4n7s7ZcmI3HzcOhf40ZRdVNBgOLVr+BnsHZaB9U6kZhOgDjjEJR+iDF1g9l
         Viiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781169036; x=1781773836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PriinPzTGWMIUfhykveslGOYnSGaX13PaffHy++jEKM=;
        b=I9xv8aH70JeBDTaLi4QYsEHrv1qEZqTl4y3KEPFCtvx/nXoopdvdd+ZunvBpFvpRZy
         ojyqSjsUZF6eg/UZlyesrAGBwjWDlo7UJI26EqVllKnR/kdBAQWKHirdtKTMAM3KBCOV
         llCigJ3k4nayaWcq3tCo6y2ISRBdz3yG7W0ym/6hSO3x16M22DPWTptWkXxowuqvxuPB
         2WWFhUmRTkYTX3nOD0DipAYatM8qe8CKSsgqqzSCNLVzGiLDAkC0d9HrMfPU+X78R14z
         h3DMojp83XyaZjZL8RJJN0WTiSowrPQMFyPJiv7p0m9vvJUYGBadpK0oiGj/ROu4d/jJ
         o9WA==
X-Forwarded-Encrypted: i=1; AFNElJ8tRMUeTN9Y4qW3Ingbc2C6835DgYWOF3iDdmZmmqgXzu2AwsXd/SE0ZglkvnjmuZ4S6CS6gQFAuTQyEX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRDFZY24rzUpqr/rYrvvNpE+U8wFLdz1/6JCNg9muMFK5XnB4K
	2/Oxlx/DHWOnRiZecTPpWiFRVZazVxnZTPMckvM+8aI9+R5pyJ5+UaGJcwgDlvvk24Mg7srEitQ
	c3X42h/YfYj2pPlfhXkkz+o91hV1qWRNfiPGRh9+6NpGdD0LmkK3IosMPRAWW75tKMA==
X-Gm-Gg: Acq92OFN8aF7OrVdo3utQJAGnEyISZLORSZikYY//pzwsT0keQC2cbf98lH6FcW+fTC
	daZB3Ya7YwzdU/Xq0DMTL4u6nVOS89Jr2IJJNC2C1Pqb3rkCynb5rAog9Ec8HBz/tiobhSoUCy/
	SAIqcT/AnuD7bq0+m8h3y9SkIFtpll5fSNX7IQqtF7MVCHsk6grq9sh34TB1xyoSIRkxGE/Wjks
	SAXWV0ypygP2azyoNqTU4kLN9hfrKNI1n2bR/IJNGRWalSoz3Strrg4D9ZLeM6qeBoovE5Jzjj6
	hygTE5ZctqxcP4ufQ+rzgc3XeG60/s9j3bBkeGzbQbbvGplL7nEvKXRpkCmkwrDbfd4KIq+QyHy
	vmasYcINQaQpsWObDtC+dXbwvIP8wPxYahosWNEoTqZF2aqVUi5V1ZA==
X-Received: by 2002:a05:6000:18ac:b0:45e:b21e:f840 with SMTP id ffacd0b85a97d-46067469f27mr2851820f8f.8.1781169036396;
        Thu, 11 Jun 2026 02:10:36 -0700 (PDT)
X-Received: by 2002:a05:6000:18ac:b0:45e:b21e:f840 with SMTP id ffacd0b85a97d-46067469f27mr2851771f8f.8.1781169035966;
        Thu, 11 Jun 2026 02:10:35 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4602cda3651sm68120262f8f.32.2026.06.11.02.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 02:10:35 -0700 (PDT)
Date: Thu, 11 Jun 2026 05:10:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael Bommarito <michael.bommarito@gmail.com>,
	Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>, Kees Cook <kees@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org,
	alan@linux.intel.com, tglx@linutronix.de
Subject: Re: [PATCH v3] hwrng: virtio: clamp device-reported used.len at
 copy_data()
Message-ID: <20260611050731-mutt-send-email-mst@kernel.org>
References: <20260531142251.2792061-1-michael.bommarito@gmail.com>
 <aio83ZWadVTiuNpR@gondor.apana.org.au>
 <20260611025916-mutt-send-email-mst@kernel.org>
 <aipn8sIAQ6Ai2sax@gondor.apana.org.au>
 <20260611035035-mutt-send-email-mst@kernel.org>
 <aipvZhfvdtRxOQm0@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aipvZhfvdtRxOQm0@gondor.apana.org.au>

On Thu, Jun 11, 2026 at 04:18:46PM +0800, Herbert Xu wrote:
> On Thu, Jun 11, 2026 at 03:58:17AM -0400, Michael S. Tsirkin wrote:
> > On Thu, Jun 11, 2026 at 03:46:58PM +0800, Herbert Xu wrote:
> > > On Thu, Jun 11, 2026 at 03:30:14AM -0400, Michael S. Tsirkin wrote:
> > > > On Thu, Jun 11, 2026 at 12:43:09PM +0800, Herbert Xu wrote:
> > > > > On Sun, May 31, 2026 at 10:22:51AM -0400, Michael Bommarito wrote:
> > > > > >
> > > > > > +	size = min_t(unsigned int, size, avail - vi->data_idx);
> > > > > > +	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
> > > > > > +	memcpy(buf, vi->data + idx, size);
> > > > 
> > > > All the "malicious device" things are confusing. Spectre things -
> > > > doubly so.
> > > > 
> > > > So if an access is speculated then CPU might speculate feeding a kernel
> > > > secret into RNG. And then the speculated RNG value maybe can be also
> > > > speculatively be used by some kernel code as an index
> > > > to trigger a cache access, finally leaking the secret?
> > > > 
> > > > Maybe?
> > > 
> > > The way Spectre works is if you have an actual instruction using
> > > idx directly.  I don't see how that translates to memcpy.
> > 
> > I am not sure it has to be direct:
> > 
> > if (malicious_idx > SIZE)
> > 	return;
> > src += malicious_idx;
> 
> Wait but vi->data_idx isn't even under the hypervisor's control.
> 
> It's an index maintained by our own driver.  So how can it be
> malicious?
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


data_avail is under hypervisor control

        avail = min_t(unsigned int, vi->data_avail, sizeof(vi->data));
        if (vi->data_idx >= avail) {
        	vi->data_idx = 0;

and maybe this can speculate past the if?

I agree, this is all speculation )


-- 
MST


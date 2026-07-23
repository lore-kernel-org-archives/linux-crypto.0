Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363833EDE4D
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 08:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793682; cv=none; b=L6+vK9cDkg0MAU3XccqiKK700sEkGt73dQZJd0zCBWsi0T5+IZ73/8kNUy/JAQZZ0KlUgr5KiSaTwK8ZqBfgO85raYC/TsNqf2Mk9HpsNg774poHyXgWH40mnkSjho88qIfRH4bajvpy+/Fh2Uhly9ObqxOA4hjQ4OdCr+VKf/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793682; c=relaxed/simple;
	bh=NZm4HE1t7ovqsimC8eS8IajPVaVSXkWV+c3pw5RpZ5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqLt7kIljZ5xQ5wQLreUwG14fVukjK+XP9u6oiY77xyUz+XUmriM6GvD1kI3kL6f4H9I98G5FB1ndY3zG7h6Wf4VR5BRIam9uu9rlW7k9YrAvRjLCma9Ey2D7W9FzPs67hnpxRT62dKUs1aLgAu/JOUnN3236GnOzJIGW2hhjj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TcphHTM4; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TcphHTM4"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f7854678bso96646f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 01:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784793679; x=1785398479; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5iH+ccPfGwLQBlMReI2VXk3NgL9FBKXNaSd0GoxYN8w=;
        b=TcphHTM4J+Ue2S3JO6qktPC2ire2nBXu2Pbehicv5N5DRsodvxDcJ9djEVxPMqZjgZ
         oZyx0waXUxIGIfe5vwDxTH/+RmyouAZOcDB18/60fZL9JSy7eCU2p4u6i3khHjnsY9+O
         g0teNvZYw3k6wG5YyK8VscKsljBgNhipDgL9igMTgqCluC1bCBuYJx7Yjcu8+2lruljT
         3YbE9KHfD0GdEkZCF+V54h1VRCj9O2hV0/dC/HpzDfiASEjt8jhmaWmdplbb7ca16ax0
         E1l7oii3lI5mV6UcivQBU2SgkT9Yk9wT+FctSPvi4743NHIY7R/ffq3Yq0IRKml7dIX+
         1nYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793679; x=1785398479;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5iH+ccPfGwLQBlMReI2VXk3NgL9FBKXNaSd0GoxYN8w=;
        b=iFd+EpZ9LiYbvapr3DP1dTkYtypg4RtIAgIIovDkTBxFcgPT9X4nBsWKzKAMlaUeL/
         Nmzdr8NgjsSb/TCauIBnus8bccVfwgm6hTs1kWFwRncEITLdWISNsM81VEHQzMyF2UrA
         taeC9ISb5RsHNRgDeZFGdPyqRFzapCbXlIWONhaK2WKbs+Z4y3MZ3rGKLOEKHj2c22gj
         48mhnYk1HXffheSTrCUSpi+5ae3u0YFwdt+dMzRzTRPoYvWJxeS0Z5J+xRn0reOH2CHn
         ESK3byvxP/SriVOn2APWbZ/L0ewWqXdHDud1Q8ll3c971h4hE7DxkPQQgFNQcAnVTAmU
         NPSg==
X-Forwarded-Encrypted: i=1; AHgh+RpaQRVasQBiWO5s0laVY50S+4dobRUFfWVFhaimnLa9JwKCj5GGZ6NbB8QRFhx27fna6Ybh9PL884am9Cg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7uHH9BhhU7VNwEN1gJ6KUtGC4yLirqHYfWxwYBFksxrrN284i
	CnAUHt4k4LmCeGke3MzxNEyHQuWynjIDmq+MWxvCjtUSVGrUq7phxILJ
X-Gm-Gg: AR+sD11xTwi3sUibyIcyXmDZbtS4LgbP7f8vbqm2C1QLsYUORX7n+wq637ueUNRMqZF
	NWlkllM0UjlFKSx0lNQzpEh76SRJQIJFGjS7u/lYrAEkjtWdpOSmVhykLEMsFzQGi4Vcn5YsLkb
	7l0+BGW5iflaZoRCUwz6xYQwmYd5T97+kcv3x7yYw2D1/GFzTmqEtvVZlZL8cX48irq4p6B+Sns
	Eg7j6IcjmP86bK7ZEIOTKF1CuA2MsGOqnV7tRTSo6OP5NzZrkooTbKN5TTq1LHdeiAmvSnkO2L8
	WsRaZNn3rklet9yFU7SALribrMDZcNSGg7/pQ3RHapiuUf6LaFzF6PWSkmrYxNzPNJC8cUIyKga
	X9NoUJAE0bY5atYZ1ikg9OOjRele1GT5IxNyzupGemGmLm7V3XxtaKS4RZhHD+iWokZaCAHdBri
	fcFvujC3opgaHdvfkCSs36rq1KAEEiwdIeN9xGyPk=
X-Received: by 2002:a05:6000:2387:b0:47f:6fbd:89eb with SMTP id ffacd0b85a97d-47f8dc936b1mr2500295f8f.57.1784793679031;
        Thu, 23 Jul 2026 01:01:19 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb5a46sm12996832f8f.9.2026.07.23.01.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 01:01:18 -0700 (PDT)
Date: Thu, 23 Jul 2026 09:01:13 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Hendrik Donner <hd@os-cillation.de>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Steffen Klassert
 <steffen.klassert@secunet.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] crypto: pcrypt - Remove pcrypt
Message-ID: <20260723090113.5c2b9995@pumpkin>
In-Reply-To: <d45ed4a1-da22-44a3-9f9e-78041dd338b1@hogyros.de>
References: <20260713223234.24812-1-ebiggers@kernel.org>
	<20260713223234.24812-2-ebiggers@kernel.org>
	<37ecba68-947a-45ad-9ec4-361facc06a05@os-cillation.de>
	<20260721195004.GA3383223@google.com>
	<19613c3e-9756-45fc-84b6-b650ba3723a7@os-cillation.de>
	<20260722194023.GB2118@quark>
	<d45ed4a1-da22-44a3-9f9e-78041dd338b1@hogyros.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 08:30:47 +0900
Simon Richter <Simon.Richter@hogyros.de> wrote:

> Hi,
> 
> On 7/23/26 4:40 AM, Eric Biggers wrote:
> 
> > So while maybe pcrypt does still help a bit on this platform for now,
> > the approach does seem quite dated and largely a workaround for
> > inefficiencies elsewhere in the stack (including systems where the
> > optimized crypto code is accidentally not enabled).  
> 
> There is one additional aspect: offloading frees the CPU to do something 
> else -- and that is where even offload engines that are slower than the 
> CPU can still be beneficial in the big picture.

Provided what is being offload actually takes long enough to allow for
setting up the iommu, the two context switches and the interrupt as well as
the obvious setup costs.

	David

> 
>     Simon
> 


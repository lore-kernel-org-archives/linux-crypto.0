Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28990215034
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 17:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731000857; cv=none; b=BTXoFg2bmYFT6q3brOB7ABlPGsGZ9wCtjbo5BOGvxL/CsClaYUPPNBcjuuqQW8KCp+TUOfkYc38LDcKuP3iE/4+RqXxhlAF3KtvI9AcrqyjXHYGP6UPk7tcZTGoa9oFnJNhZv1Xe3jIMOtsJwxraNNyZW4x7P82aTxTqkysU9iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731000857; c=relaxed/simple;
	bh=nZxe12R/t4PRr8xSkQrlsz5xDqGIXL6AbF80acmCNIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCn7XSodOd68Q702/Iu9b/l9zqUJ9dIHlJmlJ9ktb229cC9AW+zfictSEy+ilfng0eMrsSopC1D86LGmI9EcBVkTcy9uhgdSOY+6eWuOjjPSlTzwbGxdi5HijmkZk80ssfLqPvPEYLgMpsRc6jWT5OGQrNTncGClqrkOPDnCJhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=hBOHqBb+; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="hBOHqBb+"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6cbcd49b833so6807946d6.3
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2024 09:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1731000854; x=1731605654; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cWemB79fAe6SpnaBm2nNh5Iw35FC11YRxCP1qALK8Wo=;
        b=hBOHqBb+FDn0R+DiMuPB0rOYtz7BMu2YO2i8MiM1V9/xjT64t01B1f5stcxSDJylQi
         EE/AM9HoQ1xY54WjKSuu7PFjVTfH4pYC8aEdMfQbkQSwiDasE4rRQr83k9hwz+gHiNkQ
         aPqh/qP4+W1T4wcNoQWqO86XjG1d3P+C4V1MPcV/FNY2rx0mozgqphYRScVGEYU5+lal
         unDr5H+Ph7vEEWOfzyd62sk2YAMvJ0szNFvNlbL71dXh+daBnDVw0aq1O0Q/vEXdyWH8
         7mSDJVTWa43QMm4dTUNrBueeR0TwSn+BLhSzkolavlZvzEeDDC32r4Pcf7gi6jwUkZaR
         5DTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731000854; x=1731605654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWemB79fAe6SpnaBm2nNh5Iw35FC11YRxCP1qALK8Wo=;
        b=nEnU7FBOVG9RkJoKj4h3D16O9ZG8WB0hGvyWufF6V4ReV8K5LOoSxx8sMuCi0Uzeu2
         3hhfMMaqZ3f6dX8Gwh5oWvjlam0k1G56z92yXKPKIorcEtIZZdfefYsL6qP2P737Q8fy
         yDQaaWAMRDzcVXS/boqv1r0QaZmatfNhbIO7372cJRgJsc0pB+AVp1wRQ7qlOseDUljY
         0nDx+GrSyOAE5T5s+/3REZBCsqK1LELrA87Ws88p0/2azZfU7IQMQv7BUBfZ/ikI1eKd
         JvSfq3+OIegnTNK2r3S6CxcUwP40gPykdvzcLaT29ZzGaB7uuWjyiSo3i+J6WUcednzw
         FZLA==
X-Forwarded-Encrypted: i=1; AJvYcCVTR4NU3XKNzd6nVHcEMp+N9W+fpSyV0/DQ3f4H8ZQo8v6j91gaZv+8Nr87ci8VSN4ThhTzzEKSofjBItc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzko9+NFiTnWSDWceFTY4Zv5nf4IQErzXY5VtLystRiHCnpgu3A
	xQj3AHoMqnSnt7iI50G5JP01mOc1B+wyyhgrp3K2r1AzSjDlJ+sFyXMdtt0WaeI=
X-Google-Smtp-Source: AGHT+IF89BIZHtrWpN7In5LhF5z5/XKx84pBBultLGiUVGLDmfyvJdljNxUNIPKtS6p776sAZRxOMg==
X-Received: by 2002:a05:6214:3909:b0:6d3:9292:6ce with SMTP id 6a1803df08f44-6d39d990990mr2468756d6.27.1731000854126;
        Thu, 07 Nov 2024 09:34:14 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:da5e:d3ff:fee7:26e7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d39643b384sm9773336d6.91.2024.11.07.09.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 09:34:13 -0800 (PST)
Date: Thu, 7 Nov 2024 12:34:12 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, yosryahmed@google.com,
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com, zanussi@kernel.org,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Message-ID: <20241107173412.GE1172372@cmpxchg.org>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-13-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106192105.6731-13-kanchana.p.sridhar@intel.com>

On Wed, Nov 06, 2024 at 11:21:04AM -0800, Kanchana P Sridhar wrote:
> The sysctl vm.compress-batching parameter is 0 by default. If the platform
> has Intel IAA, the user can run experiments with IAA compress batching of
> large folios in zswap_store() as follows:
> 
> sysctl vm.compress-batching=1
> echo deflate-iaa > /sys/module/zswap/parameters/compressor

A sysctl seems uncalled for. Can't the batching code be gated on
deflate-iaa being the compressor? It can still be generalized later if
another compressor is shown to benefit from batching.

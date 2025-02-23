Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB2B5383
	for <linux-crypto@vger.kernel.org>; Sun, 23 Feb 2025 01:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740275863; cv=none; b=dCtVPmmI8/+b9CogYsi9VNrH5OY38NepMNpDtzyUt5RnM3hct0LMT/QenygqZ2CdSTnTT+ulrATAm2ReeBPsCb6hR2lQcfu3lD437dBhJh4Z2K5qrc3uP+tM3cIM8Pcowm7c9zCMDFiQB7CBFYXfZFphetYOauQ9HBzUGpQYMwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740275863; c=relaxed/simple;
	bh=XLFqnSSQMR6rPMvcQEZDGnYFKuR9e7aqfh+KZTZe82Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/lYCddP5iv+WyCtl601L9diGsOpB0dIuR8HJk9/AFVXAph0I/K02eSePg0WT499uHZ/aEgNrSpkhD8sbq1F6xjlQUlwDzCcer1374ZoVzoy9qZIurG3yHZBIy+I6jKPaJ9A4YK7yS7oA3bOdmdVE/1TRypKqW8rKQnU5sMmWU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=if6TwOhm; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="if6TwOhm"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22101839807so71120215ad.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Feb 2025 17:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740275860; x=1740880660; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7x8218mq/S8HeiUV2pmXqSOq4XmH8eb1lmWxoCs5iac=;
        b=if6TwOhmNus5aklvtvruM4YT4MP+gAYK2YWbKSv2SZLKEFLP4tXt1XeU3BtFYUiQ82
         +CTN4PbrjO2Agu73l5H8utZYcg7/B4ISd88dFhJXtrC47z3WXWwQbA71wi/fa9M3mDXI
         xbiXiSFNCAgagVahHMzYH8bWLPnuhEo0k/t7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740275860; x=1740880660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7x8218mq/S8HeiUV2pmXqSOq4XmH8eb1lmWxoCs5iac=;
        b=DOubEuEzMr5hhHkrwNDYffXf2jqLuORoUvUe34mJWLXdj6N/0kj9r/dORp3Fhnm3O7
         RJrWQrxFxWDBA4L2w/JsgTJDTmgHwPeEBHdbdd/2U/COmDISlUZooFzeANkOyVGR/VkE
         NsVjoBFggrShVKq3BoAiDng8tc/O6SLf8IMblo+eBva3UvVpiXgPqDJNdu6/+SH2VyzA
         pn+4CqdsERIYT0kM8zuuE1o3QPTqbTU/pSITpuVle2b3yVKMDqNkAZnuOygAQanD/BtF
         CbL/EjjNkXtPLTDH1ud+JRItRteww9RFQGSqrI3ERCCC6FgnS+expTN8+rIdFsWUX9CL
         QH9g==
X-Forwarded-Encrypted: i=1; AJvYcCXoZ74eMI7F3/ACfctKq9/tYt/izQfhMOXStX72CWT+YJoSkc+0WqdLBQi7wtllnNgkFjVeIUfj4LGEMlA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGW9OvBeoprnaDCdD3z/46PzpPvtNbYeQvDvff6MV9aHKtU1Vh
	lZBGwDSupbGJ4/gTFbWR07CgWz4BqDfiI6NJzufGhWUDwJ2y51r+T2DUGcuQM4TopuKGJ7CFxrU
	=
X-Gm-Gg: ASbGncsqxrRR//2uVOMoRPkIvg4tvvtEO3Ph3RnApJGE66kW6TbXHRL00CPm66RrWJ3
	fJqGzzd7HLg3ADBaDCV23exW6t4STI3fvt2Itw4ojexvqRzcSfK+TDcLcEp1zX2HgVtE7AOSpuY
	YSnLhdmay99KD/r1NTuK81Q58hB3FfiU6sHTtK5WJOU7weSjEJlZGHcxxg8zSJMpRezMW95xIdr
	uGeCtqpHogBCH690Tj3mSpKrjxyJj2/evwkNgvoYqReX8Jc8MjqQJbdfMVidXd93bW38zRvAK+Z
	Ycc23CbswFtnaCT5s8UmhNtVrVHg
X-Google-Smtp-Source: AGHT+IHLIy9S1gN9GykDrxcBionqbpTUc73s1xpGPi/v5ic7ifqBg1hoW+uEceGXFz+sq5W77XBfwQ==
X-Received: by 2002:a05:6a00:4fc4:b0:730:7771:39c6 with SMTP id d2e1a72fcca58-73426cab09emr16896880b3a.8.1740275860537;
        Sat, 22 Feb 2025 17:57:40 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:badf:54f:bbc8:4593])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-732771a01bbsm12445699b3a.78.2025.02.22.17.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 17:57:40 -0800 (PST)
Date: Sun, 23 Feb 2025 10:57:31 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Barry Song <21cnbao@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "usamaarif642@gmail.com" <usamaarif642@gmail.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <oiglkbyqz4cmzkjaguwgjkdu6dq6rj6oclppnd5xkwa7ekebwa@a4pbo4md3gvq>
References: <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
 <Z7pq2ayAsRsTW_vd@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7pq2ayAsRsTW_vd@gondor.apana.org.au>

On (25/02/23 08:24), Herbert Xu wrote:
> On Sat, Feb 22, 2025 at 09:31:41PM +0900, Sergey Senozhatsky wrote:
> >
> > The idea behind zram's code is that incompressible pages are not unusual,
> > they are quite usual, in fact,  It's not necessarily that the data grew
> > in size after compression, the data is incompressible from zsmalloc PoV.
> > That is the algorithm wasn't able to compress a PAGE_SIZE buffer to an
> > object smaller than zsmalloc's huge-class-watermark (around 3600 bytes,
> > depending on zspage chain size).  That's why we look at the comp-len.
> > Anything else is an error, perhaps a pretty catastrophic error.
> 
> If you're rejecting everything above the watermark then you should
> simply pass the watermark as the output length to the algorithm so
> that it can stop doing useless work once it gets past that point.

Makes sense.

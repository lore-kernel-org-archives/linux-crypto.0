Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219C31FA15C;
	Wed,  8 Jan 2025 12:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736338814; cv=none; b=FZeQ3wOevbu8qQNH3+sWz4Z7HVG7mgYAooQlSgjqTVwsVocekCu+lgtQU7sI3iWaDfccad+iSMNfBH7fU4Xp8LTbXiXAVh9SrHqPX6YezQ/4ZOUmMGsRJHaRfbm1p4fo9zixdTXjfuMmBGeZOiDSTnOFhdR27C25OLhiJrCFhS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736338814; c=relaxed/simple;
	bh=psC96hGThSrXWDDpjppiOYa5dVQa1twKUb1zxXZvS2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VS3R3vvxzBtkqbTY5GNKr6W0h+5tghyyB+6Ycm4h72/4Uj6AplpWk8IGJyMru6m6asSvN2rKPZveQPRoHLiV0fcpeheUxr4kgJCOcSivd091ldLNoL3WAsFycgNBZIrI+gBnKuklr8J4RKp+S4hW52Iuk226cRGVwj30oSnFueo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d932eac638so7666662a12.1;
        Wed, 08 Jan 2025 04:20:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736338811; x=1736943611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gBFg4Bhi0ssoJ+zZkMYuUyTLeYoitBIeZtECwrD9GaU=;
        b=BUgn0Qkn1OaksKH4S71k3YFy32e1vYCsXkSpCviCNZPfmyYK2WSPku+HfdXxJ0jp2k
         cwK/sfQF7pGvHFlrXZS+Hdtr1M9kUAei6sZjeZhKybu4YgrjZ4nWvLCNmH0dTKIEDXC/
         cpuSEA3wSvogz6z/JN1Mq46CnQoaBBffABhbpe6uzbmKetDjrcwtbbfAXeEdyukih2ZE
         sYbmPdoOUFfRTnCICEz4RoFEAa6aKQpD+R7JZ6PAYjkCAbUjwAJeT4foFM+ySKI8fUIg
         L+jgjHJ9aZm9enCseVbmOMWII9ZOVxl9AKMd0JDhJZ2LtqQ3vY2H5Ss/xC9pDG5Es3hp
         mtEw==
X-Forwarded-Encrypted: i=1; AJvYcCVAD0j29kZ8FOaKuefvGTj1mBrcobGTwYpayEJf1bZz/grMKuK1p230NJUTgYDpU90/AZzRRrCt@vger.kernel.org, AJvYcCXlR7Ai3ie5rYFYILCt1PhGDSbhqRKAV6jm/So0DJ8KbfAi2dQE5t7DGU/tkPxdUNtJAzjRpGEjYXTry+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdcfQZq7xd/iK4hzbpFH5ejm16AiC51sEMqt6P1Q6SjNxwX3Ru
	BzVAJr/vKJ3oV2qHLUXyLjoCpY1t8YszwMrUkwgSKvKB4xBTpudR
X-Gm-Gg: ASbGncvpayDqpp9/knvNSLirSbH1jRWUQxLDNBl6h/V+1kndxgXeomyGgVIOQMrZtON
	/lKxtV2abOsiZ/d7uOkOhg6DRKvMLGOwHQ+N0s4+kSRg5Wb6vjVtxVgQair30McjA2QEUbQWjR2
	SYsJnDdJAnlSG5xpMMVGXyq3zhZ3ZiEeZtbis3706NEFA7nc1nl0iXUgUSE/Hwr6OZLIK7CXam8
	eBQ1ShCjgmBWQTSjBdZnSKp3Z2EvoRBARwiVEj7AR6Maco=
X-Google-Smtp-Source: AGHT+IHWO5vLxafuUApNxdvwx8CDjd/fGi89O8UCOvaoBBxdvpAxSS1H9g4wPSpUBBSNnq/kZ3njlw==
X-Received: by 2002:a17:906:f5a0:b0:aaf:87e6:8fe3 with SMTP id a640c23a62f3a-ab2ab6a75damr230027166b.6.1736338811256;
        Wed, 08 Jan 2025 04:20:11 -0800 (PST)
Received: from gmail.com ([2a03:2880:30ff:1::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e83017asm2483129966b.32.2025.01.08.04.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 04:20:10 -0800 (PST)
Date: Wed, 8 Jan 2025 04:20:08 -0800
From: Breno Leitao <leitao@debian.org>
To: Oliver Sang <oliver.sang@intel.com>
Cc: lkp@intel.com, oe-lkp@lists.linux.dev, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, Tejun Heo <tj@kernel.org>,
	netdev@vger.kernel.org
Subject: Re: [herbert-cryptodev-2.6:master] [rhashtable]  e1d3422c95:
 stress-ng.syscall.ops_per_sec 98.9% regression
Message-ID: <20250108-smiling-sensible-llama-d8b124@leitao>
References: <202412271017.cad7675-lkp@intel.com>
 <20250103-singing-crow-of-fantasy-fd061f@leitao>
 <Z3zLQObsD42R6Nwz@xsang-OptiPlex-9020>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3zLQObsD42R6Nwz@xsang-OptiPlex-9020>

Hello Oliver,

On Tue, Jan 07, 2025 at 02:35:44PM +0800, Oliver Sang wrote:
> hi, Breno Leitao,
> 
> > I am trying to reproduce this report, and I would appreciate some help
> > to understand what is being measured, and try to reproduce the reported
> > problem.
> > 
> > On Fri, Dec 27, 2024 at 11:10:11AM +0800, kernel test robot wrote:
> > > kernel test robot noticed a 98.9% regression of stress-ng.syscall.ops_per_sec on:
> > 
> > Is this metric coming from `bogo ops/s` from stress-ng?
> 
> yes, it's from bogo ops/s (real time).
> 
> one thing we want to mention is the test runs unstably upon e1d3422c95.
> as below, %stddev for it reaches 67%.

Thanks. From what I understand, this is clock time, which can vary a
lot.

I see a small variation, but, inside the standard deviation:

Kernels I've tested:
	Kernel A: 6.13-rc6 (9d89551994a43)
	Kernel B: 9d89551994a43 + cherry pick of e1d3422c95f003e ("rhashtable: Fix potential deadlock by moving schedule_work outside lock")

Average result: (Bogo op/s)
	* kernel A:
		* Average      : 2776.70
		* Min value    : 1946.22
		* Max value    : 3278.67 
		* Standard dev :  387.01

	* Kernel B:
		* Average      : 3158.60
		* Min value    : 1850.91
		* Max value    : 4120.10
		* Standard dev :  507.19

Host: Intel(R) Xeon(R) D-2191A CPU with 64GB of RAM.

I booted the machines 2 times, with A, B, kernel sequentially, and
for each case I run the following command 10 times:

	stress-ng --timeout 10 --times --verify --metrics --no-rand-seed --syscall 224

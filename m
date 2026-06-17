Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428363D47C3
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781690728; cv=none; b=VOzydnD/jEdKizzvxaENDA4ojYCUzXi+RBImI984mghLT/foNA0qRw4Jsj44cvSYUJ7x7Ef5m3FXqSW/9/PCmn1HFDktCRNwtzmyOORI1IH18+EGt2ce+p0NpaakG1hJKCc0Wj3Q1t2XwjnTA1/rG5eMqOqkK4p205mDDcOyX48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781690728; c=relaxed/simple;
	bh=GRels6+00DOfhtua/SMwmdOjxdx+1fjruBc3u5+ohXk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WU+9Q4WvHVqaCF38FIXItTWGhc36lDtnohkvu7kPW3VI6h3Ubpdmn0+RSMUq33FssgKefPXMBbT6YpxH+4qwa6NvlvXjXeriwTwWvqEjo1mlUgSKcf1yJjyivrlvRqbNFgBV3C/pMxcfyenDNMUYzbm1OwF5irdJgjL+xRBGPnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHVdx7Fs; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHVdx7Fs"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4629d80fa08so518121f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 03:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781690720; x=1782295520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2OPmLF096KqR20zLR2fjLEx0fdz7L4iVkInjy+NLrw=;
        b=KHVdx7FsSUX70y3nKbzgeoG+EGfzuN1tVtPT9iW1MdcrPaD+DmOKUZZzWJ7/TKiUNw
         LAIgDSl/dhkhFfZ8N8B0kFHVKw6XH4kD3FnQzzMxOXzCVtvjTGpRjYNq0ollIURBJgWH
         c/blhzVx+wytjXV6FkmHdZ6X+6Kgyay6SRM8RNcfDnRkadFc18p8QEic7dBGKn4ssFRR
         N2D4QhBJm9ZVz7Ww3B9g+fRM6nEZhI2k4e68uz7NXOYaM3MTZpgQ99W6Sog49cNuQDZt
         c27kTW0qz6uz4tEckDe/lVI3UP99ejgTQtSNgxZVvmjEh5yTk5fqRmQ+jwh/42CWKn1Q
         stiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781690720; x=1782295520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f2OPmLF096KqR20zLR2fjLEx0fdz7L4iVkInjy+NLrw=;
        b=TowDOGx5pBmWG/lrb5CyZDicEKq5VESs/2DRmtZQCdhC6wioJXaFqEDDEoNqvkEDEf
         Vtm4tED/gIobEF2LnBUdItheAlxFnNk4RGFQg+kKFaliGtoAGk0yNUg+TGtr71cstipd
         yPJh1tEyiCOksrr3hUfuHp0OjScAe5LAQfiY/qsVI+4eNcUjeX8TccLcNH8YAUpU+s/o
         K4IRd0JqMQtLmIUXrUlfGBK8xwuWHzwd75Kowj9XvqEZJ9/9pMhNobR5+gHr500A/3hU
         qb6ofhzq4O0+Uok3zO5sjFR3qhgWp/elmW4pR9sVBr8SxaHyuxGjx4rfa3WsnbhPCvzF
         9Krg==
X-Forwarded-Encrypted: i=1; AFNElJ8+8Sqp+4PIvED068XaCyKUCGHDF9oJRmmkL+nhl8JBr1BUMdV0VCmu8fSZqxJNLjLwKqERDODBrgPMT+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkyptEAE0i4mTXVBqSh2Lw6WxiLzeh1hGEbDluraUy7WdaSUi8
	dAQuRWHC11gXu7LxXLYbrGrCbOYgV7TIvA86Wa8PsVs0t78XUaF2Webq
X-Gm-Gg: AfdE7clFAc63FqqIMTaqNgn4leTA1BaFRLzTtG3XS07HfvOjNAVd/3v7L1cJf7FMMWQ
	7pOO7q3lMN1s3GcFC5+l9ATb51Car7T/38odBIVXWQd0aR4+x1FASOMtu5GfceGbdNGKZw2hORA
	mO9EPKH967Om/N3AJN3v+Dy/+eA5owcVc0yWH2UzCbT+lFYYZhNrjpnGAmKKXyJZ8+sEA45+q2b
	a+45k2U6e1+XO6rHQUtZEfN+m5pG5frBzHH/Ecr5cfkO7QjHCeP07GA0QMm36AHS38XAt5jDtj5
	gGEHvnGbJurTz8yhHdE7OS6jgTxO51A+buE0qaQv3alS3PYmjoRjpM7Ino+icPjrxPSDXV1Y1do
	5Zn8xbMolTv+aXFTmToKQf9oZvKdqe9VFHmCpfvwPIm67BadFHpecgeq/e/OXvIBgUu2aPn91FY
	OZVlCoj0wnpUrEOibT6pqKAhTq7E75SgkX1vJNf+WwcW/rGDggjg==
X-Received: by 2002:a05:6000:461e:b0:45e:f2bd:2b17 with SMTP id ffacd0b85a97d-46238acb523mr5897596f8f.21.1781690720067;
        Wed, 17 Jun 2026 03:05:20 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2dbfb1sm55720157f8f.35.2026.06.17.03.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:05:19 -0700 (PDT)
Date: Wed, 17 Jun 2026 11:05:16 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260617110516.0a70950e@pumpkin>
In-Reply-To: <20260617055653.GB19218@lst.de>
References: <20260615190338.26581-1-ebiggers@kernel.org>
	<20260617055653.GB19218@lst.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Jun 2026 07:56:53 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Can use the xor: prefix used for all other commits to lib/raid/xor?
> 
> > Benchmark on AMD Ryzen 9 9950X (Zen 5):
> > 
> >     src_cnt    avx          avx512       Improvement
> >     =======    ==========   ==========   ===========
> >     1          56353 MB/s   75388 MB/s   33%
> >     2          54274 MB/s   68409 MB/s   26%
> >     3          44649 MB/s   64042 MB/s   43%
> >     4          41315 MB/s   55002 MB/s   33%  
> 
> On my Zen 5 mobile (AMD Ryzen AI 7 PRO 350) both the existing
> AVX2 and this AVX512 code give numbers in the 200+ GB/s range.  Not
> sure if is just the different benchmarking or something else going on.

I'd expect benchmarking of the xor loop to show that it is doing
2 memory reads every clock.
At 5GHz (I'm sure my zen5 will reach that single threaded) that
is 320 GB/s for src_cnt == 1 and 160 GB/s for src_cnt == 3.

200 GB/s with 32 byte cache reads would need a 200/32 = 6GHz cpu
just for the reads.

But I expect Eric is benchmarking more code and may be limited
by data cache refills.

> 
> FYI, one or 2 sources are basically useless as they RAID5 configs
> that have no benefits over simple mirroring and thus the numbers
> aren't too interesting.

With three disks you xor two buffers (src_count == 1) to get the parity
to write to the third - so that is a valid RAID5 config.

> 
> > +DO_XOR_BLOCKS(avx512_inner, xor_avx512_2, xor_avx512_3, xor_avx512_4,
> > +	      xor_avx512_5);  
> 
> Is there really much of a benefit of doing the historic DO_XOR_BLOCKS
> vs doing the loop manually?  Especially as the common cases for a
> modern RAID will usually loop over more disks than this was built
> for.  I.e., in practice one or two source buffers only happen at the
> end of a loop over more disks.

I stopped looking at what was being tested at that point :-)

	David


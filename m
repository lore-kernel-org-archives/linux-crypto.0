Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FC01F9423;
	Fri,  3 Jan 2025 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735911722; cv=none; b=NejAckHcpvvbImMTNlqkqTEOwDshcOBA70GcgwsYxcrgIqN4ZTcGJmwJQZpPuW70kcNcgu5tEL6VSgo6qF63f2yuSIO+vN6SST2GlFuKgCYE5XrLCRIbqn4f06kQMKC7m6bDB5maSwBvNwvBR8D9qI8uhmYe+KGl/Ppuo8Nwq8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735911722; c=relaxed/simple;
	bh=YwzmqaD7Gv6N8nEsMEN1t1XBhXgQYBpPgx60QOsjJq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZpAQRqIuQaZ6nio4d+xOLmJ1kwIhgKEr52/mbVirc7cg2w5tXNaYQZnANYsKNbTIH6tJT+g0DImvzUUhMRvKTcrEJQ1PkJWKg2U74r9/ogt7jH75790BjYF9MWz7wdckA557TQCelDxBbmF/K+nZy0xY9/S3mSMUnNxQv4hC3cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa67ac42819so1730152366b.0;
        Fri, 03 Jan 2025 05:42:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735911719; x=1736516519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dB07t4o4mu+ZjNcnROOEP8UVbxrHyYf1oPcMLyNVXss=;
        b=c8RK27MATyXWbd5mq8o2bV/C0s7OgKbagypmlbauSDKLI1jLsACRWIA/n1C13GCyNQ
         gXTuPRpvKqJIGWX+QZv4MEroDX8buorWqkk5rmj1GL733QrUzMadCRGik1Yu+GmZJPQ/
         GAtHr0l8N+L0BOQdk5ZRYDo8d23/WKP6RwgSdP934WiZf8rxNfN3NGMJIU9ldKKmYQdw
         FSqVuG6kCoTTxc+XOuNzZCe760iSlCvm+vnAprdjRiLDc1zY4n5OJ42EOL6Ldoxe1FI0
         Wi7IceWjL4gkL+VjXA5dtzooo/G4xb04sCoeDqoV2aWlbqpC76A6VZYlsYGYfVLM3+eq
         e0aQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe+QDNMoyIQp9+sPY67Pv2qsLazZ9hSd68KRse+dYYCz7LrLiYq3k2mgAv0QpuI9D7pNez/Om2@vger.kernel.org, AJvYcCWsShhzv6XzMw9SWHJzaPklDVUdORzTQZDQHLxaWJuzuBYlPN1pZuFkQA5bOBwe0aXcm+zJm/X9XrcaMjA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3C8+qourPYhLe0xnrupdnQuDV6xRR2Bb0jmwWy+B25px7xBXt
	LD9fU6y3p0ufoKNQuMk1bCoT/qQ5NMxshPX3xbfuMKtdkXET69aS
X-Gm-Gg: ASbGncu2mygIYilEWOneY9a74hD8sGMuvWh+iGQ+vEmtY0JmijNeOfRtArJrTDBLB3g
	6YKTnrZMvdGVzgGwTOsqd6uoKTFlV4SK2c35nB7CuZ3+NSp1r3SlqBh4fJKBkY4NjNXtlnNCuQj
	9OU9vowvvRzFGptyWeeyfRGGKCxsS2xbuxqceyZhPgSAqJQF9CDqwuIDA/0vq/KfXgIaUKXIV9v
	xHtbxi4wSdu/IlW4bg17Bu6qDtQVUEve7BaXBE6GXHfdM4=
X-Google-Smtp-Source: AGHT+IFtHssCSogTuYAP8cFKox2R3LGjnNMokBmM8CQ7u2W64Yu1xN7FqCsmh0WDx/JTFNHhAmE+Kg==
X-Received: by 2002:a17:907:7da5:b0:aa6:8781:9909 with SMTP id a640c23a62f3a-aac2d32837amr4634971866b.29.1735911719057;
        Fri, 03 Jan 2025 05:41:59 -0800 (PST)
Received: from gmail.com ([2a03:2880:30ff:9::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0efe46a6sm1891039566b.116.2025.01.03.05.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 05:41:58 -0800 (PST)
Date: Fri, 3 Jan 2025 05:41:56 -0800
From: Breno Leitao <leitao@debian.org>
To: kernel test robot <oliver.sang@intel.com>, lkp@intel.com,
	oe-lkp@lists.linux.dev
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, Tejun Heo <tj@kernel.org>,
	netdev@vger.kernel.org
Subject: Re: [herbert-cryptodev-2.6:master] [rhashtable]  e1d3422c95:
 stress-ng.syscall.ops_per_sec 98.9% regression
Message-ID: <20250103-singing-crow-of-fantasy-fd061f@leitao>
References: <202412271017.cad7675-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202412271017.cad7675-lkp@intel.com>

Hello "kernel robot" team,

First of all, thank you very much for running these tests against the
linux kernel.

I am trying to reproduce this report, and I would appreciate some help
to understand what is being measured, and try to reproduce the reported
problem.

On Fri, Dec 27, 2024 at 11:10:11AM +0800, kernel test robot wrote:
> kernel test robot noticed a 98.9% regression of stress-ng.syscall.ops_per_sec on:

Is this metric coming from `bogo ops/s` from stress-ng?

I am trying to reproduce this problem, running the following script:
https://download.01.org/0day-ci/archive/20241227/202412271017.cad7675-lkp@intel.com/repro-script

And I see the output like the one below, but, it is unclear to me what
metric regressed stress-ng.syscall.ops_per_sec means exactly.  Would you
mind helping me to understand what is stress-ng.syscall.ops_per_sec and
how it maps to stress-ng metrics?

Output of `stress-ng --timeout 60 --times --verify --metrics --no-rand-seed --syscall 224`:

	stress-ng: info:  [59621] setting to a 1 min, 0 secs run per stressor
	stress-ng: info:  [59621] dispatching hogs: 224 syscall
	stress-ng: info:  [59647] syscall: using method 'fast75'
	stress-ng: info:  [59647] syscall: 292 system call tests, 219 (75.0%) fastest non-failing tests fully exercised
	stress-ng: info:  [59647] syscall: Top 10 fastest system calls (timings in nanosecs):
	stress-ng: info:  [59647] syscall:               System Call   Avg (ns)   Min (ns)   Max (ns)
	stress-ng: info:  [59647] syscall:                  pkey_get      156.0        127        185
	stress-ng: info:  [59647] syscall:                      time      212.5        195        230
	stress-ng: info:  [59647] syscall:                  pkey_set      235.5        193        278
	stress-ng: info:  [59647] syscall:              gettimeofday      282.5        255        310
	stress-ng: info:  [59647] syscall:                    getcpu      457.0        388        526
	stress-ng: info:  [59647] syscall:           set_robust_list      791.5        745        838
	stress-ng: info:  [59647] syscall:                    getgid     1137.0        974       1300
	stress-ng: info:  [59647] syscall:                 setresuid     1146.0       1070       1222
	stress-ng: info:  [59647] syscall:                    getuid     1162.5        902       1423
	stress-ng: info:  [59647] syscall:                 setresgid     1211.5       1159       1264
	stress-ng: metrc: [59621] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
	stress-ng: metrc: [59621]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
	stress-ng: metrc: [59621] syscall          114464     86.78      1.27    364.05      1318.95         313.33         1.88          4500
	stress-ng: info:  [59621] for a 98.30s run time:
	stress-ng: info:  [59621]    3538.93s available CPU time
	stress-ng: info:  [59621]       1.26s user time   (  0.04%)
	stress-ng: info:  [59621]     366.66s system time ( 10.36%)
	stress-ng: info:  [59621]     367.92s total time  ( 10.40%)
	stress-ng: info:  [59621] load average: 80.45 43.94 20.82
	stress-ng: info:  [59621] skipped: 0
	stress-ng: info:  [59621] passed: 224: syscall (224)
	stress-ng: info:  [59621] failed: 0
	stress-ng: info:  [59621] metrics untrustworthy: 0
	stress-ng: info:  [59621] successful run completed in 1 min, 38.30 secs

Thank you!
--breno

Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC11E157465
	for <linux-crypto@vger.kernel.org>; Wed, 24 Apr 2024 23:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713999619; cv=none; b=a8IK/HNg8W4K33fgsKiOWPLtjgSBycQOOS60PTPgC0DBHd8LuiwHhn3e5a0YvCEERM6erih0f3Nj/6i94ps3zQtrmCq3u6eOu09Dz5WT/e7F7QNMjddrzxVeV8Zr5nFBk9aVZRz6aqDn1lVDGHpuunXVeuCDeiQoTz6gjkES2pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713999619; c=relaxed/simple;
	bh=OPwcFaLQ9T8uCG4Wo6nTpdLpWu2UtD2m1jc+3stupew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=reqkLW3oV6hKWKBxHtoFo7bpjOxCZ/RBCoyi8nSHYkJF3subBlPEl5TaGJTeKLWm0urgpPzQgavO+sSbEPClRBGAv/9aC+VgPPifqDYWZK/of4Nc+ztZfcuA+t5dEssgj8KWYmtENJfCc4jDdTsz/kdv3BHiaEw78vFyu2VhP7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eDV+aDLu; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eDV+aDLu"
Message-ID: <caa03909-267e-4f57-8e61-d64d20dbd305@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713999615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3BMDKen4lDURPKayU5eYO0kmKgOVuk4M52gCuVuXlKI=;
	b=eDV+aDLuhu/FM3EG5Abpe4ZHT75SyrOUwXolWHIpOwxSuxWAgvRM4W7Rip7kDYGVwdST/T
	evUomv5riMmlvJ4ma7pYn+8xSFW58hqpLFsH3K6KpFrAUV0HQvdVFq5GUK6AY1F5odIFbD
	3i2n48w6uNjvBcDbV7aotQtcvLD5la4=
Date: Thu, 25 Apr 2024 00:00:11 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v10 4/4] selftests: bpf: crypto: add benchmark
 for crypto functions
To: Martin KaFai Lau <martin.lau@linux.dev>, Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, bpf@vger.kernel.org
References: <20240422225024.2847039-1-vadfed@meta.com>
 <20240422225024.2847039-5-vadfed@meta.com>
 <54ff0e5d-1089-4370-913a-d4fdf2fd8ad1@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <54ff0e5d-1089-4370-913a-d4fdf2fd8ad1@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 24/04/2024 23:43, Martin KaFai Lau wrote:
> On 4/22/24 3:50 PM, Vadim Fedorenko wrote:
>> diff --git a/tools/testing/selftests/bpf/benchs/bench_bpf_crypto.c 
>> b/tools/testing/selftests/bpf/benchs/bench_bpf_crypto.c
>> new file mode 100644
>> index 000000000000..0b8c1f2fe7e6
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/benchs/bench_bpf_crypto.c
>> @@ -0,0 +1,185 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2024 Meta Platforms, Inc. and affiliates. */
>> +
>> +#include <argp.h>
>> +#include "bench.h"
>> +#include "crypto_bench.skel.h"
>> +
>> +#define MAX_CIPHER_LEN 32
>> +static char *input;
> 
> [ ... ]
> 
>> +static void *crypto_producer(void *input)
> 
> The bench result has all 0s in the output:
> 
> $> ./bench -p 4 crypto-decrypt
> Setting up benchmark 'crypto-decrypt'...
> Benchmark 'crypto-decrypt' started.
> Iter   0 (209.082us): hits    0.000M/s (  0.000M/prod), drops    
> 0.000M/s, total operations    0.000M/s
> Iter   1 (154.618us): hits    0.000M/s (  0.000M/prod), drops    
> 0.000M/s, total operations    0.000M/s
> Iter   2 (-36.658us): hits    0.000M/s (  0.000M/prod), drops    
> 0.000M/s, total operations    0.000M/s
> 
> This "void *input" arg shadowed the global variable.
> 

Got it. Will do re-spin then...

>> +{
>> +    LIBBPF_OPTS(bpf_test_run_opts, opts,
>> +        .repeat = 64,
>> +        .data_in = input,
>> +        .data_size_in = args.crypto_len,
>> +    );
>> +
>> +    while (true)
>> +        (void)bpf_prog_test_run_opts(ctx.pfd, &opts);
>> +    return NULL;
>> +}
> 


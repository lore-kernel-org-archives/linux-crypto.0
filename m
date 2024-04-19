Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601642AEF5
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 22:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713564170; cv=none; b=OYUOqE4fw80gEFgVBnLv3IoSLwF/Q56OdMSGkNaD3KdkLAaaEG4AxtmCkU2gwvzYfrwvMa9kryzZ+IztfDlsX9n06NOaLk/IKl1zQS8GrSEJaESUUpcjq5CHu7pwQyB4WwVZnsCPvG9Z8mIl5lyCESd/0r7WIfGvSA6eqH9fbMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713564170; c=relaxed/simple;
	bh=AfdO+0Me9W7VANipR4NZV3TFKTNZBZY7mwW6w6fNqA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qzk8HERh1DWUf7lTSzRqu7m5X5XkNzSSIf7l5+N4nY5tnlPPlJ6+uMV6JyDYf3GDXulxq4Dxp1VZYTy8HLX8Y0ZW6PSGWkcFp1zrQMwCpbNFUGFoAzyI6m7ltkFB3ZnFVBjZFBK6jZyy/9OJH+1GTQqqjvdMB/1y9FHNnB5gmts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eBu8+Az4; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eBu8+Az4"
Message-ID: <bd2019d6-4b26-4420-8b33-2c17c5445965@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713564165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+5KPFPoBy3bMK61a4m6dGjRcvp2dUEUOluA+i1rXC48=;
	b=eBu8+Az4PJ3A4rHF0Ao5xsdDogwgd+EtE/cIa5ZTYmqAT9l/3nstjU8ihnlGYw8AsG2NA+
	UhgF+cICehDCS95JhaZdZCra8cgwkOIJ03DSu1+BLkVCb2FXNSjYL7agIJ1BM18UawGzj1
	kOG59CdTdnVWa3ac+MovN1yzIObYvEU=
Date: Fri, 19 Apr 2024 15:02:38 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v9 4/4] selftests: bpf: crypto: add benchmark for
 crypto functions
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>,
 Jakub Kicinski <kuba@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, bpf@vger.kernel.org
References: <20240416204004.3942393-1-vadfed@meta.com>
 <20240416204004.3942393-5-vadfed@meta.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20240416204004.3942393-5-vadfed@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 4/16/24 1:40 PM, Vadim Fedorenko wrote:
> +static void *crypto_producer(void *)

The bpf CI cannot compile:

benchs/bench_bpf_crypto.c:157:36: error: omitting the parameter name in a function definition is a C23 extension [-Werror,-Wc23-extensions]
     157 | static void *crypto_producer(void *)

https://github.com/kernel-patches/bpf/actions/runs/8712330655

> +{
> +	LIBBPF_OPTS(bpf_test_run_opts, opts,
> +		.repeat = 64,
> +		.data_in = input,
> +		.data_size_in = args.crypto_len,
> +	);
> +
> +	while (true)
> +		(void)bpf_prog_test_run_opts(ctx.pfd, &opts);
> +	return NULL;
> +}


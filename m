Received: from cmx-mtlrgo001.bell.net (mta-mtl-003.bell.net [209.71.208.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B3C1ABCCB;
	Thu, 20 Jun 2024 12:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.71.208.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718887031; cv=none; b=RR51Ix0Zo/0/Tw+agklW7HxCi7sMw8VUHkaPKM4LSVMX/0mFPDRXPkSkPLN+ClQ6+ej2O6kZbn66VE+j304ZdWs9KNNNL+xgYvFNKarucSKm6fbxLto15jMV+2OuX9zZpMj/e4Ctv3fEhUhGfHx6lHMAYh+K7sTIZ42qNWdrymw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718887031; c=relaxed/simple;
	bh=TwYXTim1EBWvEA7mE58LOjtZB9EcSGR2jHy4iH3A0Fs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EqaA5Y5BTnTOyMaurrRhAXNS5EMVZRz/VHSV7mkCzvojtht/jgKBJkhQ7Ek7YzMbHNE/zcfpu6+kIWSG6ZeFAQjuLjApGTxd+GW6TARpEvYUUF6i0NjpGP9sZ3prT0EMPt0mE9afGu0MjKYrUHKjvIlEOh1V0+WVVHXCy5KjYSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bell.net; spf=pass smtp.mailfrom=bell.net; dkim=pass (2048-bit key) header.d=bell.net header.i=@bell.net header.b=RygCIeaJ; arc=none smtp.client-ip=209.71.208.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bell.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bell.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bell.net header.i=@bell.net header.b="RygCIeaJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bell.net; s=selector1; t=1718887029; 
        bh=+E/2zxxAWIItKbBMB1r1Hy5Fzry+6EIG2lPlZEid8eU=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:In-Reply-To:Content-Type;
        b=RygCIeaJgUOuGdGJ/8IoIpYJmfUzBj5fkcY3tRkMMw6X5LjLVcaVefXQVDqi3OsEhUSopawk3IbhEv3wEqCCBOxLl+3pkphokePdMP1w819DTX7y7tVyxDwqapld/g3Sd6TfMqWRwgRw2kJ2QQkaG80vWW2v8xNg5BsuRJuijUpmNiFw2LTgKzLofglGiTkTaj+5ZQiVFWRTb1Vb1RtcFsx91i2pzUiyYYgxNF7CuDfIvzwmGqejrW/F0aYnHBIuO37CZvagMbOQSEHb+BT3kuoP0V6ik3X7VXRXFACARQXJ54oxZur9MYpRE33MLyd1pvZ68WktgZyyrPX67mcSIQ==
X-RG-SOPHOS: Clean
X-RG-VADE-SC: 0
X-RG-VADE: Clean
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 66730BD900259CFB
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvledrfeefvddgheegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuuefgnffnpdfqfgfvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeenucfhrhhomheplfhohhhnucffrghvihguucetnhhglhhinhcuoegurghvvgdrrghnghhlihhnsegsvghllhdrnhgvtheqnecuggftrfgrthhtvghrnhepjeelffffjeehgffgueehleegfeegueeigedtkeffgeduueetffegffejudekgfeunecukfhppeejtddrhedvrdduiedvrdeijeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopegludelvddrudeikedrvddrgeelngdpihhnvghtpeejtddrhedvrdduiedvrdeijedpmhgrihhlfhhrohhmpegurghvvgdrrghnghhlihhnsegsvghllhdrnhgvthdpnhgspghrtghpthhtohepjedprhgtphhtthhopegrrhgusgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggrvhgvrdgrnhhglhhinhessggvlhhlrdhnvghtpdhrtghpthhtohepuggvlhhlvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
	vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received-SPF: softfail (cmx-mtlrgo001.bell.net: domain bell.net does not
 designate 70.52.162.67 as permitted sender) identity=mailfrom;
 receiver=cmx-mtlrgo001.bell.net; client-ip=70.52.162.67;
 envelope-from=dave.anglin@bell.net; helo=[192.168.2.49];
Received: from [192.168.2.49] (70.52.162.67) by cmx-mtlrgo001.bell.net (authenticated as dave.anglin@bell.net)
        id 66730BD900259CFB; Thu, 20 Jun 2024 08:34:11 -0400
Message-ID: <1381b751-18cf-4872-99ec-17b4b629d3ef@bell.net>
Date: Thu, 20 Jun 2024 08:34:10 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: xor - fix template benchmarking
To: Helge Deller <deller@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <ZnMWDdKJHfYQLDzS@p100>
Content-Language: en-US
From: John David Anglin <dave.anglin@bell.net>
Autocrypt: addr=dave.anglin@bell.net; keydata=
 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
 T70V9SSrl2hiw38vRzsl
In-Reply-To: <ZnMWDdKJHfYQLDzS@p100>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024-06-19 1:31 p.m., Helge Deller wrote:
> Commit c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
> switched from using jiffies to ktime-based performance benchmarking.
>
> This works nicely on machines which have a fine-grained ktime()
> clocksource as e.g. x86 machoines with TSC.
> But other machines, e.g. my 4-way HP PARISC server, don't have such
> fine-grained clocksources, which is why it seems that 800 xor loops
> take zero seconds, which then calculates in the logs as:
>
>   xor: measuring software checksum speed
>      8regs           : -1018167296 MB/sec
>      8regs_prefetch  : -1018167296 MB/sec
>      32regs          : -1018167296 MB/sec
>      32regs_prefetch : -1018167296 MB/sec
>
> Fix this with some small modifications to the existing code to improve
> the algorithm to always produce correct results without introducing
> major delays for architectures with a fine-grained ktime()
> clocksource:
> a) Delay start of the timing until ktime() just advanced. On machines
> with a fast ktime() this should be just one additional ktime() call.
> b) Count the number of loops. Run at minimum 800 loops and finish
> earliest when the ktime() counter has progressed.
>
> With that the throughput can now be calculated more accurately under all
> conditions.
>
> Fixes: c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
> Signed-off-by: Helge Deller <deller@gmx.de>
You can add my "Tested-by".

I wonder if prefetch versions are implemented correctly on parisc:

[   29.353868] xor: measuring software checksum speed
[   29.360030]    8regs           :  2266 MB/sec
[   29.368031]    8regs_prefetch  :  2076 MB/sec
[   29.376031]    32regs          :  2259 MB/sec
[   29.384031]    32regs_prefetch :  2075 MB/sec
[   29.384080] xor: using function: 8regs (2266 MB/sec)

>
> diff --git a/crypto/xor.c b/crypto/xor.c
> index 8e72e5d5db0d..29b4c0fd89d7 100644
> --- a/crypto/xor.c
> +++ b/crypto/xor.c
> @@ -83,33 +83,29 @@ static void __init
>   do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
>   {
>   	int speed;
> -	int i, j;
> -	ktime_t min, start, diff;
> +	unsigned long reps;
> +	ktime_t min, start, t0;
>   
>   	tmpl->next = template_list;
>   	template_list = tmpl;
>   
>   	preempt_disable();
>   
> -	min = (ktime_t)S64_MAX;
> -	for (i = 0; i < 3; i++) {
> -		start = ktime_get();
> -		for (j = 0; j < REPS; j++) {
> -			mb(); /* prevent loop optimization */
> -			tmpl->do_2(BENCH_SIZE, b1, b2);
> -			mb();
> -		}
> -		diff = ktime_sub(ktime_get(), start);
> -		if (diff < min)
> -			min = diff;
> -	}
> +	t0 = ktime_get();
> +	/* delay start until time has advanced */
> +	do { start = ktime_get(); } while (start == t0);
> +	reps = 0;
> +	do {
> +		mb(); /* prevent loop optimization */
> +		tmpl->do_2(BENCH_SIZE, b1, b2);
> +		mb();
> +	} while (reps++ < REPS || (t0 = ktime_get()) == start);
> +	min = ktime_sub(t0, start);
>   
>   	preempt_enable();
>   
>   	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
> -	if (!min)
> -		min = 1;
> -	speed = (1000 * REPS * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
> +	speed = (1000 * reps * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
>   	tmpl->speed = speed;
>   
>   	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
>


-- 
John David Anglin  dave.anglin@bell.net


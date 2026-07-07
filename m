Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D805633B6DB
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783436489; cv=none; b=odYeNdW9HDnZ6r1+VGkIcIzi4g+UC2Vxeig+DKxMxbdecOy/0e9Blgl3pTezRrAyPjZq92Xhvpl/fMbZqrEWJ++/zpPTGDzz/ybVFNbsVy9N/cGrUs3n2XMQ0D6/HwpzUy9fYdgq72149z0w9evPxf2ukkP8Mclt9M8wPqQDEz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783436489; c=relaxed/simple;
	bh=3mS+KjhdFHDqHMEBVGKCMbWVK2wP3syP9PWdYZ8pKiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nQTkWGaZQzmzwdxJjSGkm5SijcvrDuq0z5AXuSiiqSASNZeg7s+R5o9pDRZQBwgiVyhhxXzZvoxH+AG9xD6p5pGdizrRGg81pJBlCeakrrUyyoegJQ1Ua6qn0n460Q2rAufP8KwB4oTGjPuVqn6ycSP8ih+WcOREH5m0Oj9UFNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GfXfNO4g; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GfXfNO4g"
Message-ID: <10eafa42-1142-4ed2-a485-f46c496bddfb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783436484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuQqxQg7r/xR/o3Ylk2pziM3Ibn3JhprjKIqfkLSpGg=;
	b=GfXfNO4gP0tGatijwzLh+aPsLu2SAN6EOKMuANhj/xzaS0/RDhvnUt8w5DVXz+NeOTi/n6
	MLTu26UFbLokzQkxwBjd08vUCCuA2tGyvTXgLprd3wstxgz3nNNVLFyFuUGNAN/ZEZMo6E
	M5pNQylpw1Hv9qI3V3ceUL6k/JgyHNU=
Date: Tue, 7 Jul 2026 16:01:13 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 29/33] bpf: crypto: Use AES-CBC and AES-ECB libraries
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-30-ebiggers@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20260707053503.209874-30-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

cc +bpf

On 07/07/2026 06:34, Eric Biggers wrote:
> BPF crypto was implemented using the lskcipher API, which doesn't seem
> to be going anywhere.  It supports only "arc4", "cbc(aes)", "ecb(aes)",
> and only with unoptimized implementations.
> 
> Library APIs also have been found to be a much better approach, for a
> variety of reasons, including reduced overhead, greater flexibility, and
> having to be explicit about the crypto algorithms that are supported.
> 
> We can safely ignore the theoretical "arc4" support in BPF crypto as
> unused, which leaves "cbc(aes)" and "ecb(aes)".  Why these algorithms
> were chosen, it's unclear.  Regardless, I'll assume that "cbc(aes)" and
> "ecb(aes)" need to continue to be supported for backwards compatibility.

That was done for single use case of decrypting small blocks in TC
layer with "cbc(aes)", with assumption of extending it later.

This change looks great, but it would be great to CC bpf folks just to
be aware of the refactoring.

> 
> There are library APIs for these now, which are much easier to use and
> more efficient.  Reimplement BPF crypto on top of them, greatly
> simplifying the code.  As part of this, the bpf_crypto_type abstraction
> layer is removed, as it's not useful.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>


Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8FE24B29
	for <linux-crypto@vger.kernel.org>; Sun, 23 Mar 2025 13:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742735346; cv=none; b=HKrHK/wpQCL+AjNnwk3ae8Go7wF0MeS0OovTfjz560VCfbGa3AZW5xF48T5ECXeFQ+byhtRFA+d5viNT4r6iTut67DD28xdguAtu80GtyWgHXUQYHWAxa7cf+GYvHsyBYWZXC9VkEj5riiyKRXFufmGphBf+yh1yq9EE/cOB+PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742735346; c=relaxed/simple;
	bh=85EmCOfONknJUXdFIILoDitRDC/T1YtQUj+OWwMUVx8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=jDWn+mllDX9tJsIJJTaLZlH4WhjthflkUuLAKqu4Pqcv92RF4Y2G8IF38Zzad1Y08r23h/Oge4Z7BxPLOZ634DdjeXgCwizIkvAbx8GxDRM7Mp/rBMLLYntrEEo75taZy5Zgmr0rXxbGzRmJh8gwhrYLnM04jF7yIvWkMukNNaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y+n2dgDD; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y+n2dgDD"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742735331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NVeG39Bhc9xgVTTSj8NOH3gFDFWj/i6XzMve8aAh2gg=;
	b=Y+n2dgDDheVMelgUqDsuHMfW2mWq946tbUMNeg4WleYJxBf8yZdRPKXc7ETmEzqQoZcdTz
	olFfIcSgCGC0/jNQ+HVvchJk+ra5c/KjdJN+q2R5UtXPG9kfDefPrdkgrHLBAGwyqoK+ns
	n0RBY3BTgvZPA357TKmhANI/FAmCHgA=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.1\))
Subject: Re: [PATCH] crypto: essiv - Replace memcpy() + NUL-termination with
 strscpy()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <20250323102057.79c810f1@pumpkin>
Date: Sun, 23 Mar 2025 14:08:38 +0100
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <99BDF560-307D-4F94-BC14-44B58ED579CC@linux.dev>
References: <20250316211504.39327-2-thorsten.blum@linux.dev>
 <20250323102057.79c810f1@pumpkin>
To: David Laight <david.laight.linux@gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi David,

On 23. Mar 2025, at 11:20, David Laight wrote:
> On Sun, 16 Mar 2025 22:15:04 +0100 Thorsten Blum wrote:
> 
>> Use strscpy() to copy the NUL-terminated string 'p' to the destination
>> buffer instead of using memcpy() followed by a manual NUL-termination.
>> 
>> No functional changes intended.
>> 
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
> 
> The 'len' argument to strscpy() is supposed to be the length of the
> buffer (in order to avoid overflow) not the number of characters.

Not necessarily, see linux/string.h:

/**
 * strscpy - Copy a C-string into a sized buffer
 * ...
 * The size argument @... is only required when @dst is not an array, or
 * when the copy needs to be smaller than sizeof(@dst).
 * ...
 */

> In this case the bound check is before the copy (and the buffer assumed
> to be the right size!)
> So memcpy() + terminate is exactly correct.

Yes, this is simply a refactoring, there's nothing wrong with memcpy()
followed by a manual NUL-termination.

However, strscpy() is shorter and semantically better imo because we're
copying C-strings and not just raw bytes. strscpy() also has additional
compile-time checks regarding C-strings that memcpy() doesn't.

Thanks,
Thorsten


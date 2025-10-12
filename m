Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA3117A2E1
	for <linux-crypto@vger.kernel.org>; Sun, 12 Oct 2025 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760275404; cv=none; b=kN0VNnPhrV4pGyi1hADNLNX5BDnp/DvBEXx/Wxfr6iP3lVa3EiGZRZCk3ZHmf489Qk/UHQsNi+Vu35R8ze/ezh3rzsCntdHCrqadbe+CxaoS5l+hw5osWzgSKj2zVVvilRMb33WYXx/2Ule8XljxfOqmMK0TyqkgGZy4aYKkQXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760275404; c=relaxed/simple;
	bh=xW7vrgIMkFpkvysk3qIyoknOdvPYvzPU/rmAHSKgUhk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=RzqBQ1tddoWuWXP8FPN7SGgJCtlmNBJFz99aLXdwiCGuVt8U+YCLIyCWJnc5y+tdruE/JabM6deqHtqXr94JcMgdeEStnZ+qf2CwZgXMfwo2EVHslUGhs8NthsK0nvnKEmXmPxPWIYYUNEp+u3KoaBhwaVRjruQKApOmBxeB6A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ditdHmn1; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ditdHmn1"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760275389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0VTZ3wDaUKClfqe3G2M5ryu4iWYV/VPU2x3dyoai7Wc=;
	b=ditdHmn1apksGr14p9GLn5bw0GfuwIdty4zG9l+y5vjJSaGlb+dGdPPIHYLYpH3jtKJqBP
	dx2ZNjIz92Tq4QQWqCOqO7L4/hCn11ZhdQJZirhALhV4JqTMIiElTFxAriM1eikmrDvNwQ
	BLehygD8621E03NMLx4E1JhRJ0rtCNc=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 2/2] crypto: asymmetric_keys - simplify
 asymmetric_key_hex_to_key_id
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <aOuavtSpoNLWHoMS@wunner.de>
Date: Sun, 12 Oct 2025 15:23:02 +0200
Cc: David Howells <dhowells@redhat.com>,
 Ignat Korchagin <ignat@cloudflare.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 keyrings@vger.kernel.org,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A0C349D1-C7FA-40C6-971B-910122B1AAE1@linux.dev>
References: <20251007185220.234611-2-thorsten.blum@linux.dev>
 <20251007185220.234611-3-thorsten.blum@linux.dev>
 <aOuavtSpoNLWHoMS@wunner.de>
To: Lukas Wunner <lukas@wunner.de>
X-Migadu-Flow: FLOW_OUT

On 12. Oct 2025, at 14:10, Lukas Wunner wrote:
> On Tue, Oct 07, 2025 at 08:52:21PM +0200, Thorsten Blum wrote:
>> Use struct_size() to calculate the number of bytes to allocate for the
>> asymmetric key id.
> 
> Why?  To what end?  To guard against an overflow?

I find struct_size() to be more readable because it explicitly
communicates the relationship between the flexible array member 'data'
and 'asciihexlen / 2', which the open-coded version doesn't.

'sizeof(struct asymmetric_key_id) + asciihexlen / 2' works because the
flexible array 'data' is an unsigned char (1 byte). This will probably
never change, but struct_size() would still work even if it did change
to a data type that isn't exactly 1 byte.

Additionally, struct_size() has some extra compile-time checks (e.g.,
__must_be_array()).

>> -	ret = __asymmetric_key_hex_to_key_id(id, match_id, asciihexlen / 2);
>> -	if (ret < 0) {
>> +	if (__asymmetric_key_hex_to_key_id(id, match_id, hexlen) < 0) {
>> 		kfree(match_id);
>> 		return ERR_PTR(-EINVAL);
>> 	}
> 
> If anything, return ret instead of removing the ret variable.
> The only negative return value of __asymmetric_key_hex_to_key_id()
> is -EINVAL, hence that's returned directly here.

Ok, I'll change this in v2.

Thanks,
Thorsten


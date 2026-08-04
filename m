Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0FD3E7159;
	Tue,  4 Aug 2026 02:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785810103; cv=none; b=WKl11utpqdrVDufnsMSH3gh0HDa/Uf7txBQorOvrzb7NjsmxIhnw26yLqEthBIbRup1nbtP6S2PznqtBMx6keVS23zTac925RLDyOmdW/dyvYEwm0tYHFiZf2Dt+vHBEXCq7zc796pin43Gpvj6KW1Q+Pzs2a49HFOECrEGYZzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785810103; c=relaxed/simple;
	bh=Lc2HxMTkymc2KNhwEbOVpKacQ+UGIQlvteADjIvbpQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YwcxNBynmMm5TwXixLy6S7/wEZNJIUecRSS35nt8JJTMjqO4fj8UjyUD1E/4b0hZUQBW4bYn8RGv+FxhdWcU18NOhOZpgzKRQLDvy+6qLsYOorWGCry0a/NuDXety/DsYa12LnHvyVSHHW2nwXB97kvnRvRkXjKtwWkbWyfer/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [192.168.10.92] (unknown [39.110.247.193])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id 9EA783F202;
	Tue,  4 Aug 2026 04:21:35 +0200 (CEST)
Message-ID: <d7764cb3-152e-4b52-bed3-d23b45fce540@hogyros.de>
Date: Tue, 4 Aug 2026 11:21:30 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] crypto: Provide a wrapper for zeroizing
 crypto_aes_ctx
To: Eric Biggers <ebiggers@kernel.org>, Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Simo Sorce <simo@redhat.com>
References: <20260803094432.70505-1-thuth@redhat.com>
 <20260803094432.70505-2-thuth@redhat.com> <20260803190540.GD2062@quark>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <20260803190540.GD2062@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 8/4/26 4:05 AM, Eric Biggers wrote:

> I guess we should start using __cleanup with type-specific zeroization
> functions like this more often.
Frame challenge: should key material be copied that often that we need a 
mechanism to keep track of it?

My feeling is that this wasn't a conscious decision, but is the result 
of two other decisions (that individually make sense): contexts need to 
be self-contained (so need to include key material), and context 
creation should be cheap (so stack contexts are allowed).

So I can see two other approaches:

1. add a parameter to library functions that instructs them to clear the 
key material from the context. Most callers with the context on the 
stack could probably use that mechanism, and SIMD based implementations 
might even be able to do this rather early.

2. allow contexts to refer to key material stored elsewhere to avoid the 
copy. That opens the lifetime tracking can of worms, but the on-stack 
crypto context is rather short-lived.

    Simon

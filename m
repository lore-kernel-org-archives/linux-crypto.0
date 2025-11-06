Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2F2DE1FE;
	Thu,  6 Nov 2025 07:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762413844; cv=none; b=p2HVsiEpuVYQwkl9O7DhmS1oByrJn5yzd+u/lmv9YlV5J8Hg1i42rzpmMlrI7ChqJd1B42Hm2pYGPBMQ5TXmMhdW5st66XqPilXa3PEF5rjgcbbwAB9CDQ499ubAGbC6WHcHtJTfW59O7qGxHLGyfk7gZK/Hwhxt7rD58/difNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762413844; c=relaxed/simple;
	bh=wljagbX7AqpVKaYlbJPff7lxG2b1Pk3LOJIK8dwwGQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R353mc5SS4pL3r/VOOZpGQUbUj8ujzyjetu2/4u/GYBMO0o9qXB0N+8UpCufmGkWruC0+Wo//HmF22CqXQDWRrKFOoHZwSRgpO/26Fc4O5Xkj20wv3+WHONQA12xBwiuIW7QGSekONqR+Q0Uv+P6qiVwr0TQYQ0jnX4AwIYEmDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AJkES2eG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AJkES2eG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=s7u2FYxwfy2t8ftGqfABpZj4gxjeyyVbnshkaKWkvIk=; 
	b=AJkES2eGD+adJ8MfnR59+CqYOaXWNzovy7j21moDxkd6XzqlGwg6S4wkWAcQ9TYdGxzenzETakO
	qv6PP3vvx07F2R2WWnT9QDYLg11UKE7o9EHDrpZf/CTjzXI3qnKS2yMm+pjzrNgW3CHINp82MAbaR
	V+Ips7sy7Z7TSuAYPRUT/hJM+YZL84epN6SCnMojxguyq5VhdgtQBvUMtfezOdLuxUIXQR84Qk8lM
	Vm2NiYDZ0zJpbNP5l1FNEMcYDp5s+rbAwNzmXj/q8fhAeuPs2sx5wX9Bu27gSJB1DiSDNDzblbYKV
	LiCU3mXUlEuw9PLXzQVVpE54ocZfFBfuGkOg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGuLR-000rq7-0C;
	Thu, 06 Nov 2025 15:23:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 15:23:45 +0800
Date: Thu, 6 Nov 2025 15:23:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sai Krishna <saikrishnag@marvell.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2 - Replace deprecated strcpy in
 cpt_ucode_load_fw
Message-ID: <aQxNAY1yzAgtE-lY@gondor.apana.org.au>
References: <20251101140445.2226-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251101140445.2226-1-thorsten.blum@linux.dev>

On Sat, Nov 01, 2025 at 03:04:42PM +0100, Thorsten Blum wrote:
> strcpy() is deprecated; use the safer strscpy() instead.
> 
> The destination buffer is only zero-initialized for the first iteration
> and since strscpy() guarantees its NUL termination anyway, remove
> zero-initializing 'eng_type'.
> 
> Link: https://github.com/KSPP/linux/issues/88
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

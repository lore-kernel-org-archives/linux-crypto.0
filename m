Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793783088;
	b=5sRhoQS9NbnvrLPWz5tWQ4PVzz/V+WP0wZW8NffPKgxWvZwZO+VeWmOrcC+Iv1Q102UO
	 fRNSw6SbGJ3SijLURMa1QPnbM0e2qKPgM+nibvmdEff0BNAZEP0mf3xLIS2FiuBSZ3Uz6
	 J60KZAejayR6RlMkAK76YWcvBIoaJEuL6hV4xeTn4jeQYBkxG+YoUlnTVuP4CCbWV6KtP
	 A/IPBHF9ZEbfSieJ4aCOoCtsyIp01FSh6qRn17HdvyS90R4uVt6963pJNikH64K5IQcTs
	 I7B1AtTCDMttbJ6BUpNHEFOhIXOBrXvyaB4eS6TKlllw8u9Yyy/MnjIpkn8YIAIuiHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783088;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=jS8EmX9YEz1aAtqHNYTh2/HG8DpSqns+F77LtDtIDbI=;
	b=adxAjxX32EHquj3rFcjpN+sQ8fgLUPjqLvdfxqvc+YlHu3/BYl8csner6/CndFURL+p7
	 NZz87oF22vOgRd6Q7EH+ynr2C3FtyOz2doPV0o/f1Km5oLCwtH4mh8sR1XHst+uDb8rv3
	 yglHkYXfzBlXYrPC+sGiDjIq8zQPH5OP8xI2C9QdvySGO9TBmjjCT+diaceLj/a3Zdz8M
	 KRHv9UK5Fu4b5JjRQApwpGuJZyWho0DAPr+ROPcBnf5r5Mt+jdLLrv/dh8GgLMMLQE7Kb
	 JTVAKxkr4zqLaBWryoM631hleh3MqxHwI1AztE/ybMO4+LP1+w1kE2S5fQoQpgDsxSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=X2R+6IL2;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48DE606A339;
	Wed,  4 Nov 2026 09:04:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C48DE606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=X2R+6IL2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=jS8EmX9YEz1aAtqHNYTh2/HG8DpSqns+F77LtDtIDbI=; 
	b=X2R+6IL2gnfc5FgubrtLAKLQSJY+mN0EfeVOSFCsM/IEf302O+Su0HqqjRbbqRoGUIZWFZQ+KKm
	o/aO8U+iHj/27Ra1L4Vt/PJBWovhO0PXxCkkfrozk/Sn/PacWeYKXtNKjTVlSD5zBgPnb6ulv/ZEc
	PZJiTrqGHL+gplGx/vytt+Ogz5nK9nXq77qTCjegD+D0h9RQesgGW5HtUxb8q72gY3i1c4K0xtmHl
	BEI1B6TuUUM1x6nxJlb11XmbO1tqbU73dIZxSr4UmxTE2jvQcYQYZqr49P+X5Ip7P9k2748NP8kiT
	ncKMIVn7guVlRtiBaPwCEan94G7xQPikTVSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOWvC-0000000AnKs-1L9j;
	Wed, 04 Nov 2026 17:04:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 17:04:42 +0800
Date: Wed, 4 Nov 2026 17:04:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [REPOST PATCH] crypto: caam - reject overlong RSA CRT parameters
Message-ID: <aur1Kpi3GRQ-fT2W@gondor.apana.org.au>
References: <20261008093553.384608-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261008093553.384608-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Thu, Oct 08, 2026 at 09:35:53AM +0000, Jérémy Jean wrote:
> caam_read_rsa_crt() right-aligns dP, dQ, and qInv in buffers sized
> from the corresponding prime. rsa_parse_priv_key() only bounds these
> integers against n, so a malformed key can provide, for example, a
> two-byte dP with a one-byte p. dstlen - nbytes then underflows and
> memcpy() writes outside the allocation during set_priv_key(). KASAN
> reports a slab-out-of-bounds write in caam_read_rsa_crt().
> 
> Reject empty or overlong CRT parameters after stripping leading zeros.
> qInv is consumed by CAAM as a p-sized value, so size it from p rather
> than q to match the DMA mapping in set_rsa_priv_f3_pdb(). Let the
> top-level key cleanup handle partial form-3 allocations and return the
> specific error to the caller.
> 
> Also test nbytes before dereferencing it while stripping zeros, so an
> all-zero integer does not read one byte beyond its input.
> 
> Fixes: 4a651b122adb ("crypto: caam - add support for RSA key form 3")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  drivers/crypto/caam/caampkc.c | 69 +++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 39 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

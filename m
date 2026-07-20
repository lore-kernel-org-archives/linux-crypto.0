Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB9B3AC0EB;
	Mon, 20 Jul 2026 06:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784528366; cv=none; b=ashPows+CI8jxC2HMR/ILOEMbCWkYwATILhJNtimdbOXbGz9N4oG27eL+BemAk2kWJs3nVIs8RJKAOTa+ye8yjJu+q4Q0aCHuZIQN18GeWgyVb90HcIwuA50zAvRVhBvm2UWSuwTqhzf3Xmza5yw91pYWR5s9FjE9erGgUWZqqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784528366; c=relaxed/simple;
	bh=dq9NEunjlJ5oQKkMxkvdCk2/7urzLlE2kq6l+aFaB5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUPrVr/nj8R895pInLQSGm+95r5N/MqloTNTBUnhlxXzeS58xxvit+kcQ82lUkzGsFUbBRCj75Pz2WqhHQfDgEpswKOTCiITrkxM/OYJVYpbyMuUFSCqILpwqDXFqILjiRt3FwipyNxGnBH6wW+LYL8Ekhzl9zR49CftWwI78Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id 90DBC10DF0;
	Mon, 20 Jul 2026 08:19:12 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 82554602F93C; Mon, 20 Jul 2026 08:19:12 +0200 (CEST)
Date: Mon, 20 Jul 2026 08:19:12 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: ignat@linux.win, herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	13667453960@163.com
Subject: Re: [PATCH] crypto: rsassa-pkcs1 - Use constant-time digest
 comparison
Message-ID: <al294FVRcs8-ulcZ@wunner.de>
References: <20260720021322.122784-1-yijiangshan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720021322.122784-1-yijiangshan@kylinos.cn>

On Mon, Jul 20, 2026 at 10:13:22AM +0800, Jiangshan Yi wrote:
> +++ b/crypto/rsassa-pkcs1.c
> @@ -291,7 +291,7 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
>  	/* RFC 8017 sec 8.2.2 step 4 - comparison of digest with out_buf */
>  	if (dlen != dst_len - pos)
>  		return -EKEYREJECTED;
> -	if (memcmp(digest, out_buf + pos, dlen) != 0)
> +	if (crypto_memneq(digest, out_buf + pos, dlen))
>  		return -EKEYREJECTED;
>  
>  	return 0;

The exact same patch was previously submitted by someone else
and rejected:

https://lore.kernel.org/all/alEr_e-G0L2nxxv-@fudgebox/T/#u

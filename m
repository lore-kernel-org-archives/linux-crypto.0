Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8635939F18A;
	Mon, 20 Jul 2026 06:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784528936; cv=none; b=GdHHAYTVXhGCfYjw036Vw2BQDfwjhWJVfwxbBKZWNr108tyNZOmTfPRvv0ZwZoSDMSm8U1w+1AyWZkjrKtN2hBiKUXjFf2ZPekzNS4+hLVBDoxhDE8P7u1/MNsaV3KqK1xp1twZdtzL4qjjnWbSDfOdc/sZ+7ztZUXWXMWBBEME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784528936; c=relaxed/simple;
	bh=HYDTNHZJe6QdXcPy89MxEZMtJSjZfsVcoKjQFbY4tps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+vtJRTDlE4Y2V0zhIUBlx2QP9cwsjuNKfQ+gs0txS0pBcbT/9pKKY0w6tklLLJhRsbQCHbEdwTmUBfbxoUveV0lLpKbfJgrKspmtytAp1Hr+Rabhag07COelzMHzCZTDDMxBHlDnNkXWSK2TtXhxRtQMc6VaQ0dhyMeT8GEhPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 60517C2D;
	Mon, 20 Jul 2026 08:21:17 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 3975F602F93C; Mon, 20 Jul 2026 08:21:17 +0200 (CEST)
Date: Mon, 20 Jul 2026 08:21:17 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: dhowells@redhat.com, ignat@linux.win, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
	13667453960@163.com
Subject: Re: [PATCH] crypto: pkcs7 - Use constant-time message digest
 comparison
Message-ID: <al2-XdcuEYRbnFLw@wunner.de>
References: <20260720032316.210113-1-yijiangshan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720032316.210113-1-yijiangshan@kylinos.cn>

On Mon, Jul 20, 2026 at 11:23:16AM +0800, Jiangshan Yi wrote:
> +++ b/crypto/asymmetric_keys/pkcs7_verify.c
> @@ -93,8 +94,8 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
>  			goto error;
>  		}
>  
> -		if (memcmp(sig->m, sinfo->msgdigest,
> -			   sinfo->msgdigest_len) != 0) {
> +		if (crypto_memneq(sig->m, sinfo->msgdigest,
> +				  sinfo->msgdigest_len)) {
>  			pr_warn("Sig %u: Message digest doesn't match\n",
>  				sinfo->index);
>  			ret = -EKEYREJECTED;

The exact same patch was previously submitted by someone else
and rejected:

https://lore.kernel.org/all/alEsSl8i1_FpoU0f@fudgebox/T/#u

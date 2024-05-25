Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703D120ED;
	Sat, 25 May 2024 00:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716595635; cv=none; b=t5aHbaMj4hE5OQk8sh+n1kKarFg2HTnzJFGKumNwO0ICzfpHG/10sIO3ENTDS4yCbEFNOPFjl0IjDM7EyCpc0uz4LTgNhZfbAfMzhwSO1N7rO6r7sY2x+XvK+mQIioa/NSfkdQRAaGq8YPF668gy/TaMq3hwJOcTTtqiIp0kUNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716595635; c=relaxed/simple;
	bh=i7c0xrLGjRLjOfnTFWEM02by6TC1LzF474GBRQlEAfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgQKn+fyKyK7qMtd8AdlAjesLud+0qi1ta+RCb2W0Nw2DkZlSA1TRFhnsKkRhvX3oNX/yLWVz7eQd1qI85NgU0fpCVuYrdDtepkOki23diPgehTtyXwnvgftkwRpaUMFq4+1SHt21aeExDZ4lv/l86uLBPbBiMIsTio3O9JB+5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ikRgGvRx; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ikRgGvRx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=/NsSx95Bs+fPVa9db7gdA+rBRPf+SHgkqbU0mYfNc8I=; b=ikRgGvRxX3EObEiL
	DJLIw0GnFT3Lwt+m0cFJUPkYlODNCnFFBca+zg5BaERFdvTGCFd7q8FivLjU/TrqKAamlNFeLDfYn
	UZozYHUG0Ys7CYEw3mHM9M2pqpQO+9vhDm45GCBdWApG4I9zom+/uzSgeb+sEr4MKfm43lunxOMK2
	ex0pbe0Xhx6sFwoTiE+FtkHGJoUEA5b0NNBIClHyQ7uc0KNHMdfquVri4VQPQvU0kfbdXYqPlylUb
	30COAqHX8fJBV929SjTfxi/1oRfi7ea8w8JB4VfgspFJSl/Oe5jCxcJCocFqA8nP608eCDJXeqJK7
	8ps75CgqTo6SMqQvcQ==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1sAewI-002TQU-25;
	Sat, 25 May 2024 00:07:10 +0000
Date: Sat, 25 May 2024 00:07:10 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: gilad@benyossef.com, herbert@gondor.apana.org.au
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree: Remove unused struct 'tdes_keys'
Message-ID: <ZlErrjJWq7A6UUw8@gallifrey>
References: <20240511145200.226295-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240511145200.226295-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 00:06:36 up 16 days, 11:20,  1 user,  load average: 0.00, 0.01, 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'tdes_keys' appears unused.
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Ping.

> ---
>  drivers/crypto/ccree/cc_cipher.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
> index cd66a580e8b64..3fb667a17bbb1 100644
> --- a/drivers/crypto/ccree/cc_cipher.c
> +++ b/drivers/crypto/ccree/cc_cipher.c
> @@ -261,12 +261,6 @@ static void cc_cipher_exit(struct crypto_tfm *tfm)
>  	kfree_sensitive(ctx_p->user.key);
>  }
>  
> -struct tdes_keys {
> -	u8	key1[DES_KEY_SIZE];
> -	u8	key2[DES_KEY_SIZE];
> -	u8	key3[DES_KEY_SIZE];
> -};
> -
>  static enum cc_hw_crypto_key cc_slot_to_hw_key(u8 slot_num)
>  {
>  	switch (slot_num) {
> -- 
> 2.45.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

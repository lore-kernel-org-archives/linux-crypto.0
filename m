Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C61475347
	for <linux-crypto@vger.kernel.org>; Fri,  2 Oct 2026 09:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790933078; cv=none; b=RO+shfX+gCbg9Lq3TAs8Ldcba6A/IPGyaQ4JH1q6CHYl13J8m8LG78jvEuxAAgQxYWLzeR/F6lU+fs1mZmhOpEDANma4KfxfdXCvjLo28sRvOZdoZE46kNsdTDYH2CvZulBy61kmC8iYOFRUE+qhOX5Mg34+HG23UdyDRiCWWNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790933078; c=relaxed/simple;
	bh=08Ci8fj1DOUcWMa5e7hTxyMBm6vW29UQdAqjE2Ixklo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f43Yva0ECWlQcbL4beKevuxHLjpi6J9PDDhT74RtrETpP163yCtYUZ4mzw7lAyU+pZ6sHzkTaESCf9BcZ1wekklFj0sdnXn8xpOOUHLltm/y94n4aAV+TQXYO+p0pXOqOxWlZUto7MLfTZDhI9adZfTdoW9JlgYmjKPaGHFBfp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e2I5UONi; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2I5UONi"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b042e00f7so1431128f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 02 Oct 2026 02:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790933075; x=1791537875; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=crWOBlGGUju8RDLxyaVK+zkXbZKM1vH+7+dULKDp4T8=;
        b=e2I5UONi3YwwHCmukmS/hiI8YwTp0my+pokWNxC0sUHl0j70eI5OVwfOxnquFiZ5Q/
         /px36TUOn9+TjW6VieQDVrgXVCw8Fh3dOrya+vbxB95ot0BBdINuozFnKQk2m3Fr5PD+
         pdAa/tqZtMKmLc1Jg2jmvGPsmWPpAFG6bMoigfpT88OJozf0QrkjB6UfP4DEuHNgYbYj
         1XUi6aFE4xIJ2k3UGLhvDYjNKjsxDd/KVgIU6sEpLKTxUwN/aA1d3/XJeHctl27VjI3O
         s5S/fR+RP42s2GpIZ7Bj5KrB6DwPgQUlnwCunRLziSI/ZRYjvMhZejLq8Ne1w+oAI9IL
         U3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790933075; x=1791537875;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=crWOBlGGUju8RDLxyaVK+zkXbZKM1vH+7+dULKDp4T8=;
        b=VZ5BwJQQJPtBud1eGXXdo2jzYy5B489FPjGi4q4NnAhQcPsXXbckNgMIgllqML1vjx
         fVnW/xZZqjPOFeXJoATBOKnZf6ydrbT7aIg7/eVcfBnK7reBi0+d8Yi8BZVsdJAYPikG
         mRleGTHUhDZedrFON+LnLjQQRGXyd6GB0ANVeq6enT9AL7pbVfa4KNlU7jkI0zsAr+cr
         qLGG6BvRtvXbkvDhSRHXUviun8ZRWUbyTAufwwmbegKpLA3GSfOAOZOQOEfQzp4nQG+G
         GrhvlwFHlQDoGrHUxfN7S8IgQNYt5pXfgJVbubtPQxYVBshofX2RqboRakClrOsVhFLX
         LRXA==
X-Forwarded-Encrypted: i=1; AKwUvBxVlhF9+x6Q0ySQ1BCTQwj734J5XG+zbbiNGWzV4f0QB4RTLQiPXEw9fIQB0WS86hWqquOhxSLFgRWSmPk=@vger.kernel.org
X-Gm-Message-State: AFq9FYIMiRiSd8bqAXPOoq/9wYFoC+Xqw550pGmJioNXgZYrpPMk2F5k
	bvVUKugoof584vLh8Dp1pNC27J47wj51S5+zofcw5XIecKTdwRGgSRy3
X-Gm-Gg: AYBFou1KLB8nGyqugRaOjeFqutYIKwak8pHJwIAFUEhLmwI2XG0rjPlhyeYXTjr64EG
	D0wcZC3j8296NwHUyj7vucaQoJD4DNMQLQYVxtHDBS4Zr6WY/5vSXat7I38pGfDQGjKaFzoFeQf
	Ns0ujv1NeoKoO7M0SJumKbZVrICNSoJgyXgFg0T7TS2BVqtl1iBYTH3y5Y7WYKcX5ZeH9L/7V+V
	iLHQyWQYMg+N2b/j3jxOj3rD0mN2Vzo6NZ/LWylzYXzy2rwbsK9NwxXHnr7EUOeM95XoYoX/WOy
	WqtwI0GDjVuJoainrPOIR/LrRylH/h3roVVHfvKnLiKy94kabtQPpzGvncQPK6tYt2W267MhMFK
	8GYSkoBAb8WuNLCGsgbyg41pNrljkmkiWd7Ff8UPCQ4ARtAwEIcXCv5+SgEaSbe5OIGfUBdN618
	ZPbTdoPbxvdbdR5FwH4KUdl5iv+2pbsP692oXdr6x/lEQ1kTvkTXB5qyupUiNOz5OBWPd2nqRJ4
	0hjh5LDPI3hAU5ovigIbvpuxpZDH9RHn07R4wwqedkD+8A=
X-Received: by 2002:a05:6000:26c8:b0:487:35c:6513 with SMTP id ffacd0b85a97d-48b12720148mr4450874f8f.42.1790933074740;
        Fri, 02 Oct 2026 02:24:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b382f8ab4sm4228409f8f.35.2026.10.02.02.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:24:34 -0700 (PDT)
Date: Fri, 2 Oct 2026 10:24:30 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Thorsten Blum <blum@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] crypto: cast5 - use memcpy_and_pad() in
 cast5_setkey()
Message-ID: <20261002102430.65e546ae@pumpkin>
In-Reply-To: <20260921061120.29694-6-blum@kernel.org>
References: <20260921061120.29694-6-blum@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 21 Sep 2026 08:11:20 +0200
Thorsten Blum <blum@kernel.org> wrote:

> Use memcpy_and_pad() instead of separate memcpy() and memset() calls to
> simplify cast5_setkey().
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  crypto/cast5_generic.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/crypto/cast5_generic.c b/crypto/cast5_generic.c
> index f68330793e0c..1de0dc966a03 100644
> --- a/crypto/cast5_generic.c
> +++ b/crypto/cast5_generic.c
> @@ -483,9 +483,7 @@ int cast5_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len)
>  
>  	c->rr = key_len <= 10 ? 1 : 0;
>  
> -	memset(p_key, 0, 16);
> -	memcpy(p_key, key, key_len);
> -
> +	memcpy_and_pad(p_key, sizeof(p_key), key, key_len, 0);

This will almost certainly be slower and larger.
The fixed size memset() will be two 8byte writes on 64bit,
definitely cheaper than the calculations required for the memset.

More worrying in not verifying that the key_len isn't too big.
Maybe the length is validated against cia_max_keysize somewhere,
but there are whole lot of unrelated constants that have to match.

David
 
>  
>  	x[0] = be32_to_cpu(p_key[0]);
>  	x[1] = be32_to_cpu(p_key[1]);
> 


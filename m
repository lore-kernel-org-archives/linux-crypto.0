Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793610880;
	b=yX5UZ+bgcC3uTTpSdsB+JNGgYmC3XD4QinFp+2X2M2KRUdsLstH65tIVUjUeJcZnJ2cF
	 M0DxVIbodjWm7odbWvJ8pT4v9QaSyX8Y68vkCneJT7TUq4lPLmuSrUIt0iVFpVOlUKejl
	 ltoBYR0l/b1vnn2aC0SdYu+sOjclDo5LWsWwHFVIYN/Db0Dll0GtvjwZu1u6mRNDM7Oi3
	 LnaIV9tAJRlnZDvU9fLNLB4eSl8cbEN4iBcbQuc+hlQVEdR1s9j0pTDF1DgBRMcYqOUoM
	 cjbAZDk0UOSSblOOqfecQ9rIMYS2RzW7pOdVr+0NwbrIEoWuo6iJ1EKRhhFu/buDmSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793610880;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=RtM4TfNeNcZEfOsSrkyE8FKiVAmOs/IPKHRj6Rwpt2c=;
	b=A3UsPLWCRGGvoDplv8BLCjo6eS6nYiqLobJdQDDOV9G5UuaoqfVwBi4ynU36wVUaCY/8
	 0OgZ26Rud5g0gmw1RBx+kYZMKzVgUHIJx28v5DR2p6N/rjTI41KmiDwFUDJylM3vb9Fp4
	 kbuWdCxUWkdr0bj4RTMfga4GTmX998qjOrsExv4i2fxLHhf4W+oo052i84WBTX4yBcdwX
	 EfSjua9HVg8FDA37JFxOH9kPdtd0X4bVM0CZNnyz25Rv7Zd4IkwOJiS76om1y/wn8YFon
	 oPqaBJYmLfD3SmxnZFS2Ci3OnLygkRJuOfgYpLtHxjal8z2ZZjFicgnZQkhLMyFTlAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oQidSbhC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F8D606A326
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 09:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oQidSbhC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA531F0093A;
	Mon,  2 Nov 2026 09:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610879;
	bh=RtM4TfNeNcZEfOsSrkyE8FKiVAmOs/IPKHRj6Rwpt2c=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=oQidSbhC2YSbpciEVyylDV/oqD8EONjaYiMY1/zYEPp7kur5O7E5s0ww21XK6v7hT
	 7e5zBqm06ccocLWluqYHk4aRLRutiyKZfljmX9+aOTKsUPssZWPe3LaFw7gY9kR2pd
	 SJoMhw7L617GkIS0eozWUpfh8hYgcqRC4+xnWiPTPN1ePGEGdeCWkbIM4fmKJnv0LA
	 oft57vE4if/v7jbNzc9WezMsF+qgu29waJJ1SLsCTOC0WgP7KR42Kc69MJ28NSq3cP
	 q7BFVMwkxWG1L2S23CSF4cW1hF+7XVsMVaUs7lqXRCcIHj9ZUVF4Qexq2AxagyfS+a
	 su6i81+42oetA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6F01A198003A;
	Mon,  2 Nov 2026 04:14:37 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 02 Nov 2026 04:14:37 -0500
X-ME-Sender: <xms:e1Toah5HRLLvpBMJayh6HMNIu8TVs2a094jKhGlXSIQuylNQ3yJv3Q>
    <xme:e1ToapsPLq4Qvo0QCNN9fOk27Nf0ljbbhNKkE-91-Dn29Rf19vZBAGLB4Bg5t_-r2
    P0c2pj5-bFrCT_0qvwmkzIfGBuGvPrBhkh9ZgyMSm4AqpYkZrzPqRrr>
X-ME-Proxy-Cause: dmFkZTEw0mAKKSDBL1N2SVicnD0HcPD2guvdwlHqXY1kMDh0qbrLEgjf9L7o3Eag+ivPmk
    atoseacVqrQVMQHZPTyNpNXkGBFTyftknoWyXwejwhscZIS1fo9me5LqXHp1FLBjNyyIji
    Fx8eUZcy8KSe+xdjvzEzeyUcFzHPZ3xuxbUNfBBYn5nxWxuXkOMDlIY+70E2LKTbWKi54x
    QdJVRVSxXWdjK9ld0ncAx1Uam5BCzFvMWdvvIAE0XJwneBm5sYjDYIkJfAy1RchsTCRZVq
    mAc5sdmvDJD4xL2/2qV/0ENMMbG3DLbIP4ugITw3bJuI2SKrxQqoqTvG4VqLQg6IK4PIkK
    BG6aL63SoKcjOWCxdHW+CvERgqsAgkfdtQ+GpGNGL7XUQvjKVntO0CnPU2TCVQZHd4iEDd
    q1pAMX5CBCvJFuH7Vj1BcboWCUkffSg5r1lKpqG/UKKTgQJr8T54TGOnUKlM3x8D8FPjzL
    1Pczt0WfLByS31ME17ZgLH0vmHnyI9FMB2a8csdrgChNVerFjuN1v3cce7DJqkDio+TbZP
    68trDku/G1IRT7oTpYt2f+RsyuTFEZ+Go9rVB2X1z/wTEMPpFC+c1fE8E82fkRiTEE/Sik
    5rtgIYw6936C2PzWZYDXqDa92ONSeC9NXZNxh/1g7fLzmv3wR4+It0WdIRfA
X-ME-Proxy: <xmx:fVToarlIBKxq8mgpa3hmfsn6rFAId0euGixdy6rteP1eSF-jdaX2iQ>
    <xmx:fVToalsT4qpd-NFxkQSH9FoeriuWUOfou6hgbYFv5xDGsRMY2n1Vkg>
    <xmx:fVToap-SnETuIzi1XqaqCfJLQDMk3oOtotUa2QmzSfieaoPtR-oOnQ>
    <xmx:fVToavNxmnSXR6mGqFL2JBYl-TGU5IXdq88ZTSOTaPzbRETlDGZBfQ>
    <xmx:fVToanGTPGOJzje8FulUr4V9JUjFd0mzkm9KHtPvnMk9OuJdH0TT1yzW>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id B3475F8008E; Mon,  2 Nov 2026 04:14:35 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 02 Nov 2026 10:12:58 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <098d2205-2d0a-4984-ad48-bdae0b075461@app.fastmail.com>
In-Reply-To: <20261031052154.202008-1-ebiggers@kernel.org>
References: <20261031052154.202008-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: gf128mul: Hide selection mask values from compilers
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sat, 31 Oct 2026, at 06:21, Eric Biggers wrote:
> Hide selection mask values from compilers, so that they cannot see that
> they are used to select between two values and potentially generate a
> secret-dependent branch.  This is not known to be happening here, but we
> might as well be extra careful.
>
> For the cases where the selected values are only 0x87 and 0, change the
> type of the mask to 'unsigned long' so that the compiler is not forced
> to materialize it in a register pair on 32-bit architectures.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  include/crypto/gf128mul.h | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
> index 6ed2a8351902..8fb6f8dbbfa9 100644
> --- a/include/crypto/gf128mul.h
> +++ b/include/crypto/gf128mul.h
> @@ -171,35 +171,28 @@ void gf128mul_lle(be128 *a, const be128 *b);
>   * They are defined here for performance.
>   */
> 
> -static inline u64 gf128mul_mask_from_bit(u64 x, int which)
> -{
> -	/* a constant-time version of 'x & ((u64)1 << which) ? (u64)-1 : 0' */
> -	return ((s64)(x << (63 - which)) >> 63);
> -}
> -
>  static inline void gf128mul_x_lle(be128 *r, const be128 *x)
>  {
>  	u64 a = be64_to_cpu(x->a);
>  	u64 b = be64_to_cpu(x->b);
> +	u64 mask = -(b & 1);
> 
> -	/* equivalent to gf128mul_table_le[(b << 7) & 0xff] << 48
> -	 * (see crypto/gf128mul.c): */
> -	u64 _tt = gf128mul_mask_from_bit(b, 0) & ((u64)0xe1 << 56);
> +	OPTIMIZER_HIDE_VAR(mask);
> 
>  	r->b = cpu_to_be64((b >> 1) | (a << 63));
> -	r->a = cpu_to_be64((a >> 1) ^ _tt);
> +	r->a = cpu_to_be64((a >> 1) ^ (mask & ((u64)0xe1 << 56)));
>  }
> 
>  static inline void gf128mul_x_bbe(be128 *r, const be128 *x)
>  {
>  	u64 a = be64_to_cpu(x->a);
>  	u64 b = be64_to_cpu(x->b);
> +	unsigned long mask = (s64)a >> 63;
> 
> -	/* equivalent to gf128mul_table_be[a >> 63] (see crypto/gf128mul.c): */
> -	u64 _tt = gf128mul_mask_from_bit(a, 63) & 0x87;
> +	OPTIMIZER_HIDE_VAR(mask);
> 
>  	r->a = cpu_to_be64((a << 1) | (b >> 63));
> -	r->b = cpu_to_be64((b << 1) ^ _tt);
> +	r->b = cpu_to_be64((b << 1) ^ (mask & 0x87));
>  }
> 
>  /* needed by XTS */
> @@ -207,12 +200,12 @@ static inline void gf128mul_x_ble(le128 *r, const 
> le128 *x)
>  {
>  	u64 a = le64_to_cpu(x->a);
>  	u64 b = le64_to_cpu(x->b);
> +	unsigned long mask = (s64)a >> 63;
> 
> -	/* equivalent to gf128mul_table_be[b >> 63] (see crypto/gf128mul.c): */
> -	u64 _tt = gf128mul_mask_from_bit(a, 63) & 0x87;
> +	OPTIMIZER_HIDE_VAR(mask);
> 
>  	r->a = cpu_to_le64((a << 1) | (b >> 63));
> -	r->b = cpu_to_le64((b << 1) ^ _tt);
> +	r->b = cpu_to_le64((b << 1) ^ (mask & 0x87));
>  }
> 
>  void gf128mul_x8_ble(le128 *r, const le128 *x);
>
> base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
> -- 
> 2.56.0

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793610935;
	b=UxcGzyPcbk2Mk7aSvfht/hay8wver21Nz1RhQ3Y4Pbrbvgqu02kHqivwBY8f0tRCc77W
	 PnnYiEb/7HRc2lF38GGV7xuhyDi1IagJYbtZRDMR+rXwvx8rto70U6b8SGpwZGJ42MujR
	 ni1Nl8rx6Nvpr4j18mDoLqy/jWjQaDIHrepgduMlchVE9XYM/bn9Bk/49MxRc9tRS59KL
	 UR/AvJTTkrc11a5SrPNKJiDSwJlDcPsXDcCR98LTu2YcYwsM4P0tkq/UuUQgVaF1VGcJP
	 R/yenqjsO1hOSylyDa2rluAlzXWgtTeR8n6oUoJiRIbjYoS4pov4hbm+rxv0Y6Hergw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793610935;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=yDfpqJH1Ftp3euH/05Eddb4f5u79S3Xza32h6C5hdQw=;
	b=RFEObOgGg36U3yQWh5Dw9rYPudwpE26HlogcYAKbTCUcuIfM8fuJ3EXVvsMXgOdOjax7
	 rehf4qNItyMNbvX7/BWayi1mIbgB74oOw9Qqxij/hNTsFe9YrP6Zyl4fbO0WGcwtfs4W2
	 J7GqyU3H0iXfqi3GP9GkKNnU9nwt7GIK8zmd5sgSop1upBrhG1lHUa6PHRXVZg0YLC3Px
	 aZz+eG8r9/c/MwvN4NsmSvLvdfB6ksHezLtGvyHXvezj07D/Tgjcdu7+gb5JRtftDe0qp
	 2kYprSlWH787J0pG/kv2uQ3ECtlOprqfM9Bn5RgdhjSCGKjN7HeBsjSN/j6Y8+pCBDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XrQYBV8S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F90F606A327
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 09:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XrQYBV8S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A89A1F00A02
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 09:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610934;
	bh=yDfpqJH1Ftp3euH/05Eddb4f5u79S3Xza32h6C5hdQw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=XrQYBV8SCoS3X545wL36GF7tNCsmqYSoKUX7DXc3++4DQ6tuDmQHq2XK9QCwQNJsH
	 joLaRjmj+YK1qxtvDnt1ORYXuEkG76hYB1qj2uPguaNrGmwX1Knz4/X2RAZghXc3mD
	 6EBrth/Y1GuxRJUcBn35w385sp1MCffbwy08mFVYSRfO6ajyDYZ9Y67VUrbK06Pnx6
	 tJlZTmJ3MB9buWQzPcg/UR5/r2joVEJl/f0YIYvGPCIkUR6BXP2LD7olz9jQ5XfSwF
	 y54OsAljJR6OOKBT6V44/PQIYl+8h/PltZgKVXjytnnZpR3rSebohIHRwmHVs2ktxF
	 4AEf27XBBBOHQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id DE3CC198003A;
	Mon,  2 Nov 2026 04:15:32 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 02 Nov 2026 04:15:32 -0500
X-ME-Sender: <xms:s1ToanM7MjZYOFVn1OnItPNdcA4uxdD4-Tgx6CCzyLWWdFSVk9BLeQ>
    <xme:s1Toasx1X5iyTdZhyrIeCl4mKcLQoXOSbeqa5kCbM1sWAxqH3_OBbyu0z84KggTrR
    qDnPfMNlkPIMdMUrVim8JSEssy7T01MhJI3wGlKrYrZwZrD3TTTUj_a>
X-ME-Proxy-Cause: dmFkZTEaK45BE/0jQT3YYJxCaGH2Kfh2KXBSQcfiPkjruNj7ZUSQZaZi4hDPAYx/X3mDZj
    C/5umqcnVngMExJqWX9NDsm3e+58IPkVaBnkYQAy5GdKd9u7Ky4w0/fy/P+cZBnBxBFR9s
    JThW/vhDDTS45hrSCZPvCtWMV7K2LvpklieLeNfVYIwtOtnUEYA4anXLxxil4GFGd2WEDo
    lVvN6uwnH6MYHH6mIrmGUXlkf++scYkVnZr3qHYG4h0El+aKufodt4LoMaG5IyA8GE8qmD
    Z9Z/d9QCt0CxTyWcMo8gKzOhpdHdxCeybuzd2exU6iaVcByGgdSKP6auAeyUzPQxv3aeCz
    dB1f/Q1XuPTHaWxadkoFLJCsAYtYdo1svOHQ6hpXAtuSqW+aAiCc2+hTWM56ov7TtogHv3
    /oBx3Iry6YqGZJX27xp1wlFUBhwVasQouWDpdOG1TpbNOewkzo8qOM7F7gxqLZQagGPoVT
    JJS3+AoRFwj1l1vVsVprqeCLg4CKmQTCUaMGkOqGYMLpCIQ54BWmOgJg+pLd714Xe+87wM
    NnvNDNeX5z+R9bAkodHVtOqFpf6TbgdWxoUC6uclPLOBvmg/s7RZ42irQmU4blTJjR86bn
    xFFthA8owUqT0hcEEBa2H0rYpQjLwy3ssP4bo3m/WOMiy/zOBGqz08ulJxjw
X-ME-Proxy: <xmx:tFToagxmH88X9Nyoe9Hxg8By0kzTTdOVOcwcpLyEQv6d5Yy9MD00Kw>
    <xmx:tFToavzNL4S05IdpjVVNihF1Wa9KZAR3osnW5I79F701iCsrE61Krw>
    <xmx:tFToaoxGXC3n6yoQ35EdCXCeu2KRKJ_hbJwmUrWKCpLUcz5WA_K7RA>
    <xmx:tFToapaO0d3mUb9ysogMd3A6ztyTGe-AbVEraq-vxeZqvCdi61J_Sg>
    <xmx:tFToapXTmELo-jxkikLVJa8oVIiR64RMUIQ4ShVijzW4m2WVJz34ixCv>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id ADBE2F8008E; Mon,  2 Nov 2026 04:15:31 -0500 (EST)
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
Date: Mon, 02 Nov 2026 10:15:11 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <2c122f4c-bd28-4617-90fd-ca73e95177f4@app.fastmail.com>
In-Reply-To: <20261031052149.201983-1-ebiggers@kernel.org>
References: <20261031052149.201983-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: gf128hash: Hide selection mask values from compilers
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 31 Oct 2026, at 06:21, Eric Biggers wrote:
> Hide selection mask values from compilers, so that they cannot see that
> they are used to select between two values and potentially generate a
> secret-dependent branch.  This is not known to be happening here, but we
> might as well be extra careful.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/gf128hash.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>


> diff --git a/lib/crypto/gf128hash.c b/lib/crypto/gf128hash.c
> index 8dcdf5ec98be..5b8ae98cafed 100644
> --- a/lib/crypto/gf128hash.c
> +++ b/lib/crypto/gf128hash.c
> @@ -88,10 +88,18 @@ static void clmul64(u64 a, u64 b, u64 *out_lo, u64 *out_hi)
>  		  (a2 * (u128)b1) ^ (a3 * (u128)b0);
> 
>  	/* Multiply the low 4 bits of @a by @b. */
> -	u64 e0 = -(a & 1) & b;
> -	u64 e1 = -((a >> 1) & 1) & b;
> -	u64 e2 = -((a >> 2) & 1) & b;
> -	u64 e3 = -((a >> 3) & 1) & b;
> +	u64 e0 = -(a & 1);
> +	u64 e1 = -((a >> 1) & 1);
> +	u64 e2 = -((a >> 2) & 1);
> +	u64 e3 = -((a >> 3) & 1);
> +	OPTIMIZER_HIDE_VAR(e0);
> +	OPTIMIZER_HIDE_VAR(e1);
> +	OPTIMIZER_HIDE_VAR(e2);
> +	OPTIMIZER_HIDE_VAR(e3);
> +	e0 &= b;
> +	e1 &= b;
> +	e2 &= b;
> +	e3 &= b;
>  	u64 extra_lo = e0 ^ (e1 << 1) ^ (e2 << 2) ^ (e3 << 3);
>  	u64 extra_hi = (e1 >> 63) ^ (e2 >> 62) ^ (e3 >> 61);
> 
> @@ -245,6 +253,7 @@ static void __maybe_unused 
> ghash_key_to_polyval(const u8 in[GHASH_BLOCK_SIZE],
>  	u64 lo = get_unaligned_be64(&in[8]);
>  	u64 mask = (s64)hi >> 63;
> 
> +	OPTIMIZER_HIDE_VAR(mask);
>  	hi = (hi << 1) ^ (lo >> 63) ^ (mask & ((u64)0xc2 << 56));
>  	lo = (lo << 1) ^ (mask & 1);
>  	out->lo = cpu_to_le64(lo);
>
> base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
> -- 
> 2.56.0

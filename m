Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180B03382CB
	for <linux-crypto@vger.kernel.org>; Sat,  3 Oct 2026 07:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791012888; cv=none; b=rvtyedwBXLeTr8HyYqkKD7Xrvqjd/W/ZE46eQdILnhqN9P52IMchAtM3uyEW+9DKkZ7lTg/lABe3rRCn7mRBAtXbvpy/j/rZOPDF7aDvJobg5Ve4aRoDHxoQxrg5+uWRGKPG082TDm5FPp8l7f99TBayAnKn+Gyu+iDSpPSBHRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791012888; c=relaxed/simple;
	bh=JI5meg9Y+N5PGOfPmS8AmteGtmiH28zLKCv938nDuK8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=UYXQvk8VpYzZELK0wiwPqdwKz4i7xneOsuSXYj6Y2jQk9rqmYPjcbc97UNi5RRqdGlfFBnu5peThVM90d+apPucysi9c91gSRkC6WgKH2CSMBnJaqOoad/Yvz2dlA0wYMHSEF0bXuMWl91iPURSxJ+F1sepR7cWGuTT7TGdyr5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WYQyq4Me; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYQyq4Me"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DE21F0089D;
	Sat,  3 Oct 2026 07:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791012886;
	bh=kqhpRcWtMe7BR3qSONW6oEGsEH2C2z6yBYNd65orP8g=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=WYQyq4MesjMAaQzScvp7QeHSTJnAkOl0c0YlwvCjM1DlgGiVUMJ7U86XR2WhT3SAk
	 V9sjdEOY95yAUwJAMbuka5S9pQ1vhQl9JPj0h3dQIPPs1saiIxqfd7RER5qKwQTFC0
	 zSimTmN4AgkYpNX3MhVcj2R7wwsGedHPAFwT4fz6RBmO4HE+flcxRcRF5+/vFBDTTJ
	 pafwcljhkmK/mQLuOkNQHbpt0L4v0ZzbomY1JyydfyU967b+nHKEjJdPGX0lmRm4xs
	 9R3iKMDShqMNE0AXQxxma5Dll56ppjOxFgxDGkLPF3NvyLUH+3A8Bisk0+Xs4INaPu
	 3yCcth9JS8MRQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BA781198003A;
	Sat,  3 Oct 2026 03:34:44 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sat, 03 Oct 2026 03:34:44 -0400
X-ME-Sender: <xms:ErDAapwIEeWqEvMSQC7VW6O4ZbAgDYf-yzdA2ni9bhCMbKDlNIg2qw>
    <xme:ErDAakGmW-lceV7s6H3xDbC4IFrmNZLnomyhbs21Bu3XPqs_j56ffKSPNwHLHUanM
    aldXpKYBzQQepb_DEb9niGLUWb-jIyiHnA7dS_vUSkfBlC4nUyF48p5cw>
X-ME-Proxy-Cause: dmFkZTFvci9LgTVkO8YAK5DRX0xpuv7lnyVgN1YhmTbMrkkWzAi3dXrxYdtJHro3Lesaxg
    bfGQGNA/0bQFt1gwW90keJ3rnTg4aP2mf/z2/ZTqqZXuaTourwR0NHnZZ8flf2Sham1XUY
    42FxVCAdmriHWATdc8ejG11Le/6bR5l83KUD3AfC2+GTMrD7tYbmiAdCaFAK1+mfDRbFiz
    NQdd9Rsb9SdEpuwiDxDIDHG+9LF8E4Z3EAqHnCd4Dfohu1NEojm5zJEw5btEeR914RjBCw
    sQoiEw7/OL3zX3Ynww78zfvBveCn40a/B4MqYAwqGH/5V3mYl5TD1fUcgEOi8RylJIUhab
    ryg7CEcy9uSerdR2KFGEeLtsSDd/xc011dc0NAwHMpirwU19Zwa4lNvFwVMVWXeO3iiAFe
    gKqSQf/waGK5aCpjicJJPcF6btlJ28zRRllLQdVZ6pQUuFdOVfVllEO95/eVY8qHigVRGy
    67UmOI78+xDnfnZ4uzxAbeypUBM3vRyFbqpCOHRsqmAuqgEA2foiprbL59GxCRt6G9tNxa
    GgFBvJCBtlkd84TxASUTmO6aKYUpkMoj7WDa6avMtnFygjGhkrJgX6V4uDgY6WcRXrcXh6
    xSffoEOSc7Q5sEPxPvewlxlAUSyeTuS8pM2HaI7F0rOWD8Y+lW7KWluTdnXQ
X-ME-Proxy: <xmx:FLDAarRLGxGPOa1niVLLbPOhFtsom-H_BXPuFKk13kL075rf-83c_Q>
    <xmx:FLDAapXaXijI7JRMm3WOIAJwZWisky4Oc3oEcQ7MoHYItucmHvKMKg>
    <xmx:FLDAalQox5M_kNqwTOqzBZsNKz8N7TUqkZOlbVM5RX7ACSnPiaTB8A>
    <xmx:FLDAah2l7A9jyEIOi1ouwm434F6Bk5IURrjp1wHdQSYDicRa_DmgTw>
    <xmx:FLDAalcz9By-izeaKZ75uvPT4d7xwzgiFUIFEZF6OcHsqrHrGeJ7HEtD>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id B3215F80090; Sat,  3 Oct 2026 03:34:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 03 Oct 2026 09:34:21 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mohamad Raizudeen" <raizudeen.kerneldev@gmail.com>,
 "Eric Biggers" <ebiggers@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Shuah Khan" <skhan@linuxfoundation.org>, me@brighamcampbell.com,
 jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-Id: <b937fca8-f436-47a5-988c-963fa1af6296@app.fastmail.com>
In-Reply-To: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>
References: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>
Subject: Re: [PATCH] crypto: chacha20poly1305 - Fix missing state zeroization in
 xchacha decrypt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 3 Oct 2026, at 08:08, Mohamad Raizudeen wrote:
> The `__chacha20poly1305_decrypt` function does not zeroize the chacha
> state, unlike its encrypt counterpart. The regular
> `chacha20poly1305_decrypt` function handles this by manually calling
> chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
> the result directly without clearing the state.
>
> This leaves the derived chacha20 subkey on the stack after the function
> returns. Fix this by storing the return value, calling
> chacha_zeroize_state() and then returning the result, matching the
> logic in `chacha20poly1305_decrypt`.
>
> Fixes: ed20078b7e333 ("crypto: chacha20poly1305 - import construction 
> and selftest from Zinc")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
>  lib/crypto/chacha20poly1305.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/lib/crypto/chacha20poly1305.c 
> b/lib/crypto/chacha20poly1305.c
> index ea42a28f4ff7..03b14d272520 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -199,10 +199,13 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 
> *src, const size_t src_len,
>  			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
>  {
>  	struct chacha_state chacha_state;
> +	bool ret;
> 
>  	xchacha_init(&chacha_state, key, nonce);
> -	return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
> +	ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
>  					  &chacha_state);
> +	chacha_zeroize_state(&chacha_state);
> +	return ret;
>  }
>  EXPORT_SYMBOL(xchacha20poly1305_decrypt);
> 

Wouldn't it be better to move the existing call from chacha20poly1305_decrypt()
to __chacha20poly1305_decrypt()?


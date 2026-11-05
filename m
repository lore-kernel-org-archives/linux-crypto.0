Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793840525;
	b=lRTv6DfY5dj/sriFMTqkDs7oXLWlNP5iJr5jowxG9GZOyZ+nlan5JFXHmbUX5ZwcLuYt
	 vX+06kIozTpUnlw+bE7XfPtVT/Rnku5rxfjkawp+L5xLCeEv+J9JKTlouTwmUC6nbaJqq
	 Geas1lTlcAK7rq8/Zvxh1HMqltcz5PEMa52b0NzEy13fwugyuCyRvF9/x32IZZGr+BTBy
	 jt4PlgNxdwdPLdfcAOsMQCPTCC82OSqvSC6MOb8Ae1COFBrmudRSHUyHoubsg5/aTILVh
	 uRGFGfzSvng8BjY64xrUDlOgqjUMY92NrxEyJSjuz5TN4GxMjPRPtzS4nnXxJKrvMeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793840525;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=iddlibwHylbcGjyxMtI74PmgfcTkrOFQcKT+J34fn3A=;
	b=CCElyRA4fRgSOX0atjshmCC32WIh5JUAxnyTOxMT3bKcYjr+eDe28BW9b/3sjuVdGyQY
	 XnHKIt3Znj1DAljgbMPbuHAtnnqWZLNTg4lxkyqHFzo+R1T4VsDIQCCRFgloC5XQUsmXi
	 x/9uemM4QQsIo92JeTCIfHkT3aDz6edJZynpfg8vgcHwE+yZw8dQjLWeT0QUUPQ959oTG
	 tPw3JpYpC5BMk/89bZfO/cmddiV785pxrbjGqLkIT3jM2Y8QVYPpKU1at2td1oo0xP/MP
	 TUAlV7g02eGdztl34lrzgHecF3yKi/S9HKNKLsyCHPaXj1kh6FSP7ayc61itZQZY6+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=menIgw4h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92F3606A32F;
	Thu,  5 Nov 2026 01:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=menIgw4h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A271F000C1;
	Thu,  5 Nov 2026 01:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793840524;
	bh=iddlibwHylbcGjyxMtI74PmgfcTkrOFQcKT+J34fn3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=menIgw4hLQFv34khikyvkP39JYjUXXeDwg8lKE7JsbiAZURLv7mvQtahpFyMZ3kbm
	 J1cq5WLONDd9gZKNRrKmSti7PpdHa/9TXLnX0dXbNJCQlrf4x//y9Z5G3lXjY10OW8
	 SVatb2aL2sHnuHZ7RRFF82KsQY5joTOmWTQwj80W2tqzmqxVAnDtKGdcTuXJfICySw
	 P/eD4ChhKYtZbgmMAnSlZqWP/B8Q1EIOLFwHHpFAtqWWvzq0YHBKFSBbFkZQyP6Rol
	 CaeY/nDRcDVbBDZiFMBDYLWaqTMkG8I6BKqACQyCWDpi3DUxrkDkZhep9youxKRSJD
	 iQ7T9Z9y/W0MA==
Date: Wed, 4 Nov 2026 17:02:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: Add a sentence about zeroizing raw key
 structures
Message-ID: <20261105010202.GB2084@sol>
References: <20261104105352.135540-1-thuth@redhat.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104105352.135540-1-thuth@redhat.com>

On Wed, Nov 04, 2026 at 11:53:52AM +0100, Thomas Huth wrote:
> Let's make it clear that raw key material has to be zeroized, too.
> 
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Suggested here:
>  https://lore.kernel.org/linux-crypto/20260930201434.GA61218@google.com/
> 
>  Documentation/crypto/libcrypto-zeroization.rst | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/crypto/libcrypto-zeroization.rst b/Documentation/crypto/libcrypto-zeroization.rst
> index 76b6506711634..fe9f94413d1f2 100644
> --- a/Documentation/crypto/libcrypto-zeroization.rst
> +++ b/Documentation/crypto/libcrypto-zeroization.rst
> @@ -47,7 +47,9 @@ The following types of structures hold sensitive material and should be
>  zeroized after use:
>  
>  - **Key structures** (e.g. ``struct aes_key``, ``struct hmac_sha256_key``):
> -  contain expanded round keys or prepared key material.
> +  contain expanded round keys or prepared key material. Note: Arrays and
> +  structures that contain raw key material (e.g. raw AES keys) of course
> +  need to be zeroized as well as soon as the data is not required anymore.

It's better than nothing, but it reads kind of like an afterthought.
Might be worth its own paragraph before the one beginning with "The
following types of structures".

- Eric

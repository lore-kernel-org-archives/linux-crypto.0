Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA3134DCD1
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 11:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745689; cv=none; b=mJFZvmJ9e5ke+y+e7EZ9WxUrYdBPIhScddXDBwTfhvHV2wH62AF00kYUE4z9627P9KY7tB68fE4vzfJpCbU80eRkoLBHtyRnSBvtsxjuhYvOKxUFx2r58a59EAeAj1AWPSuhiSjirJMQhNx273KcjWnzrSVEHLjF1f8ikTTEopc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745689; c=relaxed/simple;
	bh=314cjoPirp9ww5Jz15IEtFouHNkTpjXfseX+v3N7cds=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=k/zI0Scmjkc66GHnbavVtfyijqMxColwzGErDSzvajcXwXQAOzoMEfyi6UGTYAxZS9EqNjiMkXORQ9jva9fl9TUhIf5luobg4MrZRqN8MH1+myFg7I///kGEtnwnqHqu5B5rzRcp6KmkJqYbWSpGtPqLBqq8S97zgyNPuaVwt50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/AwuJhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/AwuJhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDD3C19425;
	Tue, 17 Mar 2026 11:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745689;
	bh=314cjoPirp9ww5Jz15IEtFouHNkTpjXfseX+v3N7cds=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=j/AwuJhQ6bgJReL4TCCvQj5cJahIpVxFJnPVSlkxkD05HbmMus7wFeofeiKrZk/2B
	 Ul0zfmoEA6K6MGa11wao1WBakUqA/9XiBMM+n/3QJ02b5vjq6GZDikqwqe5gaVpfUy
	 29HJWDP74meHg85wZqFkF1dX7YhILb67QPTXd7MIu7QTXP2syGI5JPlnYVPjYv3ifO
	 THSJGWjn7k7w07rR4VZdekHYMCsdu5wexggfxEm6I76rw9/nDTUHISgmn0pufSjQYZ
	 fYaa3GQQl/R6Q57fJ6Ibg/236DPWLeq7SKZCK063F95RMwE7+R4MBUmwjGBfTx8c3L
	 yCt0+3maKklxw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 51F13F40069;
	Tue, 17 Mar 2026 07:08:08 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Mar 2026 07:08:08 -0400
X-ME-Sender: <xms:GDa5aVXhPNfLTg9TEpJHHdpGdlzsEu1R6Nt4CkhMfzpnjvkMIcv4EA>
    <xme:GDa5aQYjSaP2uCmEvLRRMJftEvfRxErND5VjGDdW1YrjTCjFRApTIbIy-0VleuFt-
    Vn94C3QeybmuVQh-vXUoWp89Sgh4npP4nAwt7OpwohDYurvaQjDAeH1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpth
    htohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhig
    qdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuh
    igqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjrghs
    ohhnseiigidvtgegrdgtohhm
X-ME-Proxy: <xmx:GDa5aTAaua0-jyCCsDxF5-bl2dJo2e6sxUtPT2Ut-xPd1W-9yj-mmg>
    <xmx:GDa5aS22hO3CCY-qGc2ButYT0p9viAPaGmO-j-aO1nyYFlOVOvKgIw>
    <xmx:GDa5aV3OH7tcsbWpZT7TSPhu08rK0P2gyvWUPRdjncsSIJfUjKkXqg>
    <xmx:GDa5aXCK3rJJcwJHPXk6GjRIhCs6_CepIVGhks3_bBSfF0K_J1wEtA>
    <xmx:GDa5aU4IauZ9cyXH5AXXifVlTzRFpmAdD4vpRewd6eD9L_zL7dem7mpD>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3161E700065; Tue, 17 Mar 2026 07:08:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ACP3a-Mj7Mlg
Date: Tue, 17 Mar 2026 12:07:46 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <ae2293ea-580d-40c2-beb1-b1aa1f6d5ae5@app.fastmail.com>
In-Reply-To: <20260314173526.17349-1-ebiggers@kernel.org>
References: <20260314173526.17349-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: Remove unused file blockhash.h
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 14 Mar 2026, at 18:35, Eric Biggers wrote:
> For a short time this file was used by the SHA-256 and Poly1305 library
> code, but they are no longer using it.  Remove this unused file.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting libcrypto-next
>
>  include/crypto/internal/blockhash.h | 52 -----------------------------
>  1 file changed, 52 deletions(-)
>  delete mode 100644 include/crypto/internal/blockhash.h
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/include/crypto/internal/blockhash.h 
> b/include/crypto/internal/blockhash.h
> deleted file mode 100644
> index 52d9d4c82493d..0000000000000
> --- a/include/crypto/internal/blockhash.h
> +++ /dev/null
> @@ -1,52 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> -/*
> - * Handle partial blocks for block hash.
> - *
> - * Copyright (c) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
> - * Copyright (c) 2025 Herbert Xu <herbert@gondor.apana.org.au>
> - */
> -
> -#ifndef _CRYPTO_INTERNAL_BLOCKHASH_H
> -#define _CRYPTO_INTERNAL_BLOCKHASH_H
> -
> -#include <linux/string.h>
> -#include <linux/types.h>
> -
> -#define BLOCK_HASH_UPDATE_BASE(block_fn, state, src, nbytes, bs, dv,	\
> -			       buf, buflen)				\
> -	({								\
> -		typeof(block_fn) *_block_fn = &(block_fn);		\
> -		typeof(state + 0) _state = (state);			\
> -		unsigned int _buflen = (buflen);			\
> -		size_t _nbytes = (nbytes);				\
> -		unsigned int _bs = (bs);				\
> -		const u8 *_src = (src);					\
> -		u8 *_buf = (buf);					\
> -		while ((_buflen + _nbytes) >= _bs) {			\
> -			const u8 *data = _src;				\
> -			size_t len = _nbytes;				\
> -			size_t blocks;					\
> -			int remain;					\
> -			if (_buflen) {					\
> -				remain = _bs - _buflen;			\
> -				memcpy(_buf + _buflen, _src, remain);	\
> -				data = _buf;				\
> -				len = _bs;				\
> -			}						\
> -			remain = len % bs;				\
> -			blocks = (len - remain) / (dv);			\
> -			(*_block_fn)(_state, data, blocks);		\
> -			_src += len - remain - _buflen;			\
> -			_nbytes -= len - remain - _buflen;		\
> -			_buflen = 0;					\
> -		}							\
> -		memcpy(_buf + _buflen, _src, _nbytes);			\
> -		_buflen += _nbytes;					\
> -	})
> -
> -#define BLOCK_HASH_UPDATE(block, state, src, nbytes, bs, buf, buflen) \
> -	BLOCK_HASH_UPDATE_BASE(block, state, src, nbytes, bs, 1, buf, buflen)
> -#define BLOCK_HASH_UPDATE_BLOCKS(block, state, src, nbytes, bs, buf, 
> buflen) \
> -	BLOCK_HASH_UPDATE_BASE(block, state, src, nbytes, bs, bs, buf, buflen)
> -
> -#endif	/* _CRYPTO_INTERNAL_BLOCKHASH_H */
>
> base-commit: ce260754bb435aea18e6a1a1ce3759249013f5a4
> -- 
> 2.53.0

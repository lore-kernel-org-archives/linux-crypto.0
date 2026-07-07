Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00C136CDE3;
	Tue,  7 Jul 2026 19:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783452179; cv=none; b=r5bPNBDUy/rMAkB463gb6ZzYg7+V6YaDzuIi8WySK6kZAMxBVLfpJq4mBHJZB4Rg0jXpykmMHiS/SQVW7k064X805ObpSpsWrLNJEqAIzjyO55aaehpJw55zfmSXtblbt7i9kKcpf/rEsJi4POUAJywTNo8iJZoc9nw2oCHS1Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783452179; c=relaxed/simple;
	bh=MyVAyXn9jdYc7+7OrFcAeG/PBmDs2VGZiSgiHNeDzy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmVi6h5D/fHXeVsnyUJd14UGwtjZ6ryl6WER8Jx2ass3z3bzgIbPe05w1VqwWU3CixkCKvx07xzDylehaaA+mF9H0187mv/wXCXPcqsmeYtH8aXEn918xvBcpPS/YCfvGgz1Vn6q+7RT7Wm7aEfuAibncgG5GQeuy0NP3OBt3sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7/2VlvQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7/2VlvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E53D1F000E9;
	Tue,  7 Jul 2026 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783452177;
	bh=0GkpB9Iq/R5nt/996xhy1/+ov227Kb5twNR3cKzuSb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W7/2VlvQDdVNwgRIw1RcjfZmfjrdYpOtU1XI59h3NOrThmfp/bLC5UxuTFKECrUIm
	 QVRl7mB5jfrba5JDTrp1Y7aLRojCMlS/qL//on1/i2kOSyPtzt7pr948idNHxzn09m
	 EBUwIwrVcJ0GELpacIrreLzNO1a7X1nKfG57ktFHzji7jSstg7YPdojWNjXtN+vVy3
	 X4QpF2EtBZcqrH+WRi0xNXIVIZXerxqcS+T3dIFLWZfu4hd0okEgkNSfXSpyKSbI6P
	 wKBpWh7gqF/Tn1rzL6J+lGrrTTT95zS1UWK/+KZNZwIO4o3sE88oQywtU7+ycqiWNX
	 sr8wOfAxYxsJg==
Date: Tue, 7 Jul 2026 12:22:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 02/33] lib/crypto: aes: Add ECB support
Message-ID: <20260707192256.GB2238@quark>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-3-ebiggers@kernel.org>
 <f41f7217-c444-41da-84b9-1592dcd9b58d@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f41f7217-c444-41da-84b9-1592dcd9b58d@redhat.com>

On Tue, Jul 07, 2026 at 03:59:24PM +0200, Thomas Huth wrote:
> > +Unauthenticated encryption
> > +==========================
> > +
> > +Support for unauthenticated encryption and decryption, including bare stream
> > +ciphers and other length-preserving algorithms such as block ciphers in XTS
> > +mode.
> 
> This sentence no verb?

It's a noun phrase that introduces what the section contains, before
transitioning into full sentences.

I used this in all existing Documentation/crypto/libcrypto-*.rst.  It's
also fairly common in the help text for kconfig symbols (across the
kernel, not just the kconfig help text I've written).

I guess it's a bad practice.  But if we go with something else here,
like "These functions provide support for ...", I should update the
existing libcrypto-*.rst too.

> > +void aes_ecb_encrypt(u8 *dst, const u8 *src, size_t len, aes_encrypt_arg key);
> 
> Other similar functions like aes_encrypt() use the key as first argument ...
> so maybe do the same here, too, for consistency?

For single-block AES, there's indeed already aes_encrypt(key, dst, src)
and aes_decrypt(key, dst, src).  But for actual AEAD encryption there's
already:

    chacha20poly1305_encrypt(dst, src, src_len, ad, ad_len, nonce, key)
    chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len, nonce, key)
    xchacha20poly1305_encrypt(dst, src, src_len, ad, ad_len, nonce, key)
    xchacha20poly1305_decrypt(dst, src, src_len, ad, ad_len, nonce, key)
    chacha20poly1305_encrypt_sg_inplace(src, src_len, ad, ad_len, nonce, key)
    chacha20poly1305_decrypt_sg_inplace(src, src_len, ad, ad_len, nonce, key)

Those follow the convention described by Jason here:
https://lore.kernel.org/linux-crypto/aPT3dImhaI6Dpqs7@zx2c4.com/

This series prioritizes consistency with those (and other functions
taking [dst, src, len]] such as memcpy() and crypto_xor()), adding:

    aes_ecb_encrypt(dst, src, len, key);
    aes_ecb_decrypt(dst, src, len, key);
    aes_cbc_encrypt(dst, src, len, iv, key);
    aes_cbc_decrypt(dst, src, len, iv, key);
    aes_cbc_cts_encrypt(dst, src, len, iv, key);
    aes_cbc_cts_decrypt(dst, src, len, iv, key);
    aes_ctr(dst, src, len, ctr, key);
    aes_xctr(dst, src, len, ctr, iv, key);
    aes_xts_encrypt(dst, src, len, tweak, key, cont);
    aes_xts_decrypt(dst, src, len, tweak, key, cont);
    aes_gcm_encrypt(dst, authtag, src, data_len, ad, ad_len, nonce, key)
    aes_gcm_decrypt(dst, src, authtag, data_len, ad, ad_len, nonce, key)
    aes_ccm_encrypt(dst, authtag, src, data_len, ad, ad_len, nonce, nonce_len, key)
    aes_ccm_decrypt(dst, src, authtag, data_len, ad, ad_len, nonce, nonce_len, key)

(Side note: looking at it again, the last four maybe should all use
[dst, src, data_len, authtag].  In this series, the authtag is instead
grouped with the src or dst to which it's usually concatenated.)

If key is put at the beginning instead, it then raises the question of
why should it be different from nonce/iv/ctr and (ad, ad_len).  So would
it really be:

    aes_gcm_encrypt(key, dst, authtag, src, data_len, ad, ad_len, nonce)

... or would it actually be something like:

    aes_gcm_encrypt(key, nonce, ad, ad_len, dst, authtag, src, data_len)

It's conventional to put "the object being operated on" at the
beginning, which could be argued to apply to the key.  But alternatively
the key could just be considered another input.  crypto_skcipher was
"object-like"; however, with the library the key is a simple struct, or
even just a byte array in the case of ChaCha20Poly1305.

There's no single right answer here.  But we should consider the full
picture including the chacha20poly1305 functions.  The (dst, src, len,
auxiliary stuff) order also helps for things like the AES_CRYPT_SG macro
in crypto/aes.c, as the "auxiliary stuff" is together and at the end.

Note that if we decide we like this order, we could reorder the
arguments of aes_encrypt() and aes_decrypt() to match.

Maybe let's see what other people prefer?

- Eric

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899C7347BDB
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763723065; cv=none; b=auHnnM6j8G5tt97R2siGWNKA+F/3XzKVIfHYC5NY+ggaXQOtqkqUXKf1M0AplJo79j0PrgbSuuKQQvuZjVt54xR9YGKoy/+smeXgNCCoIw/EzTavt9xuQV6f2nspw6zh9jiCZ87n6nMGNuZG6yBoJtjxkepzfbkzvDmaWNnuXXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763723065; c=relaxed/simple;
	bh=2lqoZhJhWzOaQOcc2jlQQmCm/jrutcMHKMnjjh+1frk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tngqFwnZ5B8RJeCICkWXVfCixqEH4G6nxHKkbUZ3NVgvKRtfiWHw4q5KZ5uzQViQS3eKH9dQDMjEYUJb6rhfJHaDiW7HpPImgbe1CrMDkpJJb93L7x8pvFe6pIUIl6Bdg7eAtZHXvQeFGKeuds18CVTlCHpCcnl4uQCO5tY3I9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=st/si38r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="st/si38r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F50C113D0
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 11:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763723065;
	bh=2lqoZhJhWzOaQOcc2jlQQmCm/jrutcMHKMnjjh+1frk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=st/si38rjHPmq01QmAkVnIqZyCkAqti6ZXMJXGnqm0DARsXyTMrtzxR8XMsQ8lFDj
	 X+8G1FEBzRjRh0adwBC+c3TkIa3zODPlNwVEEPh/In1/u+ZbSLs9TKBOIIOpPCXZLa
	 XLTdl1ZA5vxmxZu61VZudytMh/uB8JuOJgryaQNenWHofM0uVodtq3Zi1DvEwgS34B
	 u5ss5a9qYuDrdF9THgmodnmx7jw2MRRxSFmKhq6shR1VG/HxcxMrPZ15SVvQkvDa3H
	 c7C2IML11Wo6y6yOcFLyVeryORvZk1wXKxv/bnzgs9z8iqfqpllm8MM9fYC5j/V/dv
	 +zwF/uDkMQx0g==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-595819064cdso2645685e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 03:04:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCULR4tBXG7Q5HQtobk/n9J/xJEWk4jgxJ79HicZnvBy4APefpdSZi3w9W0eZkDMI0smn1Nkivotnx9w4WY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkNLe8OeJuLXJWfPbW5gJXnCDksnTA55iG6JmjDSkfJDFG/wVk
	OU0uIFFzDE2OEOSgxdq27vrbCiPDKgdbz8G6cUROcjQn8lT1GWL2T5PzAtQaateosezRnF0dY7M
	/iBugxGcw54Uav264ANpmIp1SXuz4NlI=
X-Google-Smtp-Source: AGHT+IEwN75NZD1JJesdPT00UPc9CVIFLIe8DKm8g78iHQDXVGf2PM61twkFy1AgPn2cyccKGKMx3IOA4ylOHY4fgD0=
X-Received: by 2002:a05:6512:2216:b0:596:9cf0:fb85 with SMTP id
 2adb3069b0e04-5969e9d3099mr2147482e87.4.1763723063750; Fri, 21 Nov 2025
 03:04:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120011022.1558674-1-Jason@zx2c4.com> <20251120011022.1558674-3-Jason@zx2c4.com>
In-Reply-To: <20251120011022.1558674-3-Jason@zx2c4.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 21 Nov 2025 12:04:12 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGtDxf+GWx8xNQZcdvqfgJ+xL8m3U3TCoOypTGw7_-t3Q@mail.gmail.com>
X-Gm-Features: AWmQ_bk7lzjwJeZAwkSJGw4x3J6HKOSV6NPQSBusLtxnERslFf2OZHcnoVHg-Yo
Message-ID: <CAMj1kXGtDxf+GWx8xNQZcdvqfgJ+xL8m3U3TCoOypTGw7_-t3Q@mail.gmail.com>
Subject: Re: [PATCH libcrypto v2 3/3] crypto: chacha20poly1305: statically
 check fixed array lengths
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers@kernel.org>, 
	Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Nov 2025 at 02:11, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Several parameters of the chacha20poly1305 functions require arrays of
> an exact length. Use the new at_least keyword to instruct gcc and
> clang to statically check that the caller is passing an object of at
> least that length.
>
> Here it is in action, with this faulty patch to wireguard's cookie.h:
>
>      struct cookie_checker {
>         u8 secret[NOISE_HASH_LEN];
>     -   u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN];
>     +   u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN - 1];
>         u8 message_mac1_key[NOISE_SYMMETRIC_KEY_LEN];
>
> If I try compiling this code, I get this helpful warning:
>
>   CC      drivers/net/wireguard/cookie.o
> drivers/net/wireguard/cookie.c: In function =E2=80=98wg_cookie_message_cr=
eate=E2=80=99:
> drivers/net/wireguard/cookie.c:193:9: warning: =E2=80=98xchacha20poly1305=
_encrypt=E2=80=99 reading 32 bytes from a region of size 31 [-Wstringop-ove=
rread]
>   193 |         xchacha20poly1305_encrypt(dst->encrypted_cookie, cookie, =
COOKIE_LEN,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
>   194 |                                   macs->mac1, COOKIE_LEN, dst->no=
nce,
>       |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~
>   195 |                                   checker->cookie_encryption_key)=
;
>       |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireguard/cookie.c:193:9: note: referencing argument 7 of typ=
e =E2=80=98const u8 *=E2=80=99 {aka =E2=80=98const unsigned char *=E2=80=99=
}
> In file included from drivers/net/wireguard/messages.h:10,
>                  from drivers/net/wireguard/cookie.h:9,
>                  from drivers/net/wireguard/cookie.c:6:
> include/crypto/chacha20poly1305.h:28:6: note: in a call to function =E2=
=80=98xchacha20poly1305_encrypt=E2=80=99
>    28 | void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size=
_t src_len,
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  include/crypto/chacha20poly1305.h | 16 ++++++++--------
>  lib/crypto/chacha20poly1305.c     | 18 +++++++++---------
>  2 files changed, 17 insertions(+), 17 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/include/crypto/chacha20poly1305.h b/include/crypto/chacha20p=
oly1305.h
> index d2ac3ff7dc1e..7617366f8218 100644
> --- a/include/crypto/chacha20poly1305.h
> +++ b/include/crypto/chacha20poly1305.h
> @@ -18,32 +18,32 @@ enum chacha20poly1305_lengths {
>  void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_l=
en,
>                               const u8 *ad, const size_t ad_len,
>                               const u64 nonce,
> -                             const u8 key[CHACHA20POLY1305_KEY_SIZE]);
> +                             const u8 key[at_least CHACHA20POLY1305_KEY_=
SIZE]);
>
>  bool __must_check
>  chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>                          const u8 *ad, const size_t ad_len, const u64 non=
ce,
> -                        const u8 key[CHACHA20POLY1305_KEY_SIZE]);
> +                        const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]=
);
>
>  void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_=
len,
>                                const u8 *ad, const size_t ad_len,
> -                              const u8 nonce[XCHACHA20POLY1305_NONCE_SIZ=
E],
> -                              const u8 key[CHACHA20POLY1305_KEY_SIZE]);
> +                              const u8 nonce[at_least XCHACHA20POLY1305_=
NONCE_SIZE],
> +                              const u8 key[at_least CHACHA20POLY1305_KEY=
_SIZE]);
>
>  bool __must_check xchacha20poly1305_decrypt(
>         u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
> -       const size_t ad_len, const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE]=
,
> -       const u8 key[CHACHA20POLY1305_KEY_SIZE]);
> +       const size_t ad_len, const u8 nonce[at_least XCHACHA20POLY1305_NO=
NCE_SIZE],
> +       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
>
>  bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t=
 src_len,
>                                          const u8 *ad, const size_t ad_le=
n,
>                                          const u64 nonce,
> -                                        const u8 key[CHACHA20POLY1305_KE=
Y_SIZE]);
> +                                        const u8 key[at_least CHACHA20PO=
LY1305_KEY_SIZE]);
>
>  bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t=
 src_len,
>                                          const u8 *ad, const size_t ad_le=
n,
>                                          const u64 nonce,
> -                                        const u8 key[CHACHA20POLY1305_KE=
Y_SIZE]);
> +                                        const u8 key[at_least CHACHA20PO=
LY1305_KEY_SIZE]);
>
>  bool chacha20poly1305_selftest(void);
>
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.=
c
> index 0b49d6aedefd..212ce33562af 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -89,7 +89,7 @@ __chacha20poly1305_encrypt(u8 *dst, const u8 *src, cons=
t size_t src_len,
>  void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_l=
en,
>                               const u8 *ad, const size_t ad_len,
>                               const u64 nonce,
> -                             const u8 key[CHACHA20POLY1305_KEY_SIZE])
> +                             const u8 key[at_least CHACHA20POLY1305_KEY_=
SIZE])
>  {
>         struct chacha_state chacha_state;
>         u32 k[CHACHA_KEY_WORDS];
> @@ -111,8 +111,8 @@ EXPORT_SYMBOL(chacha20poly1305_encrypt);
>
>  void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_=
len,
>                                const u8 *ad, const size_t ad_len,
> -                              const u8 nonce[XCHACHA20POLY1305_NONCE_SIZ=
E],
> -                              const u8 key[CHACHA20POLY1305_KEY_SIZE])
> +                              const u8 nonce[at_least XCHACHA20POLY1305_=
NONCE_SIZE],
> +                              const u8 key[at_least CHACHA20POLY1305_KEY=
_SIZE])
>  {
>         struct chacha_state chacha_state;
>
> @@ -170,7 +170,7 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, co=
nst size_t src_len,
>  bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_l=
en,
>                               const u8 *ad, const size_t ad_len,
>                               const u64 nonce,
> -                             const u8 key[CHACHA20POLY1305_KEY_SIZE])
> +                             const u8 key[at_least CHACHA20POLY1305_KEY_=
SIZE])
>  {
>         struct chacha_state chacha_state;
>         u32 k[CHACHA_KEY_WORDS];
> @@ -195,8 +195,8 @@ EXPORT_SYMBOL(chacha20poly1305_decrypt);
>
>  bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_=
len,
>                                const u8 *ad, const size_t ad_len,
> -                              const u8 nonce[XCHACHA20POLY1305_NONCE_SIZ=
E],
> -                              const u8 key[CHACHA20POLY1305_KEY_SIZE])
> +                              const u8 nonce[at_least XCHACHA20POLY1305_=
NONCE_SIZE],
> +                              const u8 key[at_least CHACHA20POLY1305_KEY=
_SIZE])
>  {
>         struct chacha_state chacha_state;
>
> @@ -211,7 +211,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatter=
list *src,
>                                        const size_t src_len,
>                                        const u8 *ad, const size_t ad_len,
>                                        const u64 nonce,
> -                                      const u8 key[CHACHA20POLY1305_KEY_=
SIZE],
> +                                      const u8 key[at_least CHACHA20POLY=
1305_KEY_SIZE],
>                                        int encrypt)
>  {
>         const u8 *pad0 =3D page_address(ZERO_PAGE(0));
> @@ -335,7 +335,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatter=
list *src,
>  bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t=
 src_len,
>                                          const u8 *ad, const size_t ad_le=
n,
>                                          const u64 nonce,
> -                                        const u8 key[CHACHA20POLY1305_KE=
Y_SIZE])
> +                                        const u8 key[at_least CHACHA20PO=
LY1305_KEY_SIZE])
>  {
>         return chacha20poly1305_crypt_sg_inplace(src, src_len, ad, ad_len=
,
>                                                  nonce, key, 1);
> @@ -345,7 +345,7 @@ EXPORT_SYMBOL(chacha20poly1305_encrypt_sg_inplace);
>  bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t=
 src_len,
>                                          const u8 *ad, const size_t ad_le=
n,
>                                          const u64 nonce,
> -                                        const u8 key[CHACHA20POLY1305_KE=
Y_SIZE])
> +                                        const u8 key[at_least CHACHA20PO=
LY1305_KEY_SIZE])
>  {
>         if (unlikely(src_len < POLY1305_DIGEST_SIZE))
>                 return false;
> --
> 2.52.0
>

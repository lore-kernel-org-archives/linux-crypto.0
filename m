Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793771878;
	b=1EFZQ3ZY9kl7IsBuY8a7d0ag37fXXAErxXiGdAYXjeo2h/qGMgJ3OHiaV5lMbYYcaXik
	 V3km2Na302t7/ySWn7xMVMpIliYqkwHyq29meyJlhkg5MApe4qVk8ZyIAP7/rQp/u3M5p
	 naoaR3B5+e42uqdgnprZfSjZ1mC5Ta8nzVzoKY4D8PGTjw5cjOZCm4uxtK9ByVGIPeJIv
	 eCvfoSJFKH4GRrCHob5vjSh3gtiUMIZM/PBmSL2O4t/6FUSb+n44av/2s1kEtMVISOdpv
	 3Z9VriCRKQR9W5eTxSeJ/EQ09TKoyPB4Mz5O7iBvmtb7/qmKC0zHtMs8AjkGOFxndUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771878;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/IFUnINR9sULzg22n0kIUN+Gh4AGRVugA84EuF0io3g=;
	b=xqTKVjYmeS7l5I+L6hXvQLawQ7ieBDTZ5Sgm3vSr+KVysR43YClsLIj1t0gu7FZTCbKI
	 0BOzl3N/KVcdQc/OE5wWSzAmzbZ0GazkVyUIkQGgzSuEhk6falnnQbK3EDQqZLClbiemD
	 LeLIZZ+cZo7L0vY00ZvizB8UfCufGuqsZHgKRfQnVOK1NfevG4h+XrPcLqzWt9rUQiwST
	 9lwGZhrItcF3TPzUw0bSQUCp0cO6YCVXj7tsSY6dTOe7AYifJIwdi+ht14+cOmVxLzL0S
	 1KR3grEg6otaJD87jeoPPOf9oR7nyvanJipd3i47SdTZSb+20HQce0hVp+9qHN43Bgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZc2KLBw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371E0606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZc2KLBw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AC51F000C1;
	Wed,  4 Nov 2026 05:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793771878;
	bh=/IFUnINR9sULzg22n0kIUN+Gh4AGRVugA84EuF0io3g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IZc2KLBw6awUdRBozEPTFbbMthhq798yo2oCGjlGRosV1lwXyJbeR31rxEvYrJhCb
	 cLRVUvHSg2APbLyJpva3YqO+p/trhBwReWPpOodHNbE+liCqjZlQyy65lMl4kq3/NP
	 n5qKfl4Es04wm6pybJN5xBzYLK2HYoZmBHeqdIYaYgp3cRRNaeohxCKXf2TJIwQHT5
	 Wm5S2ivXVMPOb48mzKq10J5Zbuc+ux7+bzzpe/fX5DRqXD7b3qzej7++NFN1ekwHU0
	 ZtdfkYoqRNSRdkj5nz6NDNaIANgVI3+8X/Zlby4LkRMgveU+K0qQgVEz0ona+gOFcB
	 G8LRrPhujt8wg==
Message-ID: <sashiko-outbox-196709@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/30] crypto: sa2ul - remove unused includes and
 defines
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manorit Chawdhry" <m-chawdhry@ti.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>, "Colin Ian
 King" <colin.i.king@gmail.com>
Cc: "Andrew Davis" <afd@ti.com>, "Pratham T" <t-pratham@ti.com>, "Kamlesh
 Gurudasani" <kamlesh@ti.com>, "Udit Kumar" <u-kumar1@ti.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-7-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
 <20261104-b4-upstream-sa2ul-cleanup-v2-7-15ab90b3f9c2@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 05:57:57 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] crypto: sa2ul - commit message omits struct field removals and leav=
es dead declarations
--

commit ffe272048a90096ed2fcdf326cdc814515cd3d94
Author: Manorit Chawdhry <m-chawdhry@ti.com>

crypto: sa2ul - remove unused includes and defines

This commit removes an unused header include, unused macro definitions,
and unused structure fields in the SA2UL crypto driver.

>     crypto: sa2ul - remove unused includes and defines
>    =20
>     Remove unused includes and define statements that are not
>     referenced anywhere in the driver.
>    =20
>     Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
>=20
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index 98075f9ffeb2a..e1e537de2d16b 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c

[ ... ]

> @@ -207,14 +196,12 @@ struct sa_rx_data {
>   * @mdata_size: metadata size passed to DMA
>   */
>  struct sa_req {
> -	struct device *dev;
>  	u16 size;
>  	u8 enc_offset;
>  	u16 enc_size;
>  	u8 *enc_iv;
>  	u8 auth_offset;
>  	u16 auth_size;
> -	u8 *auth_iv;
>  	u32 type;
>  	u32 *cmdl;
>  	struct crypto_async_request *base;
> diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
> index 6d5a3e65dae78..eedfad49793b2 100644
> --- a/drivers/crypto/sa2ul.h
> +++ b/drivers/crypto/sa2ul.h

[ ... ]

> @@ -201,7 +200,6 @@ struct sa_crypto_data {
>  	u16		sc_id;
>  	unsigned long	ctx_bm[DIV_ROUND_UP(SA_MAX_NUM_CTX,
>  				BITS_PER_LONG)];
> -	struct sa_tfm_ctx	*ctx;
>  	struct dma_chan		*dma_rx1;
>  	struct dma_chan		*dma_rx2;
>  	struct dma_chan		*dma_tx;
> @@ -210,19 +208,16 @@ struct sa_crypto_data {
>  /**
>   * struct sa_cmdl_param_info: Command label parameters info
>   * @index: Index of the parameter in the command label format
> - * @offset: the offset of the parameter
>   * @size: Size of the parameter
>   */
>  struct sa_cmdl_param_info {
>  	u16	index;
> -	u16	offset;
>  	u16	size;
>  };
> =20
>  /**
>   * struct sa_cmdl_upd_info: Command label updation info
>   * @flags: flags in command label
> - * @submode: Encryption submodes
>   * @enc_size: Size of first pass encryption size
>   * @enc_offset: Encryption payload offset in the packet
>   * @enc_iv: Encryption initialization vector for pass2
> @@ -231,7 +226,6 @@ struct sa_cmdl_param_info {
>   */
>  struct sa_cmdl_upd_info {
>  	u16	flags;
> -	u16	submode;
>  	struct sa_cmdl_param_info	enc_size;
>  	struct sa_cmdl_param_info	enc_offset;
>  	struct sa_cmdl_param_info	enc_iv;
> @@ -294,13 +288,9 @@ struct sa_tfm_ctx {
> =20
>  /**
>   * struct sa_sha_req_ctx: Structure used for sha request
> - * @dev_data: struct sa_crypto_data pointer
> - * @cmdl: Complete command label with psdata and epib included
>   * @fallback_req: SW fallback request container
>   */
>  struct sa_sha_req_ctx {
> -	struct sa_crypto_data	*dev_data;
> -	u32			cmdl[SA_MAX_CMDL_WORDS + SA_PSDATA_CTX_WORDS];
>  	struct ahash_request	fallback_req;
>  };

[Severity: Low]
This isn't a bug, but the commit title and message only mention removing
unused includes and define statements, whereas all of the changes in
drivers/crypto/sa2ul.h and part of drivers/crypto/sa2ul.c remove unused
structure members from struct sa_req, struct sa_crypto_data,
struct sa_cmdl_param_info, struct sa_cmdl_upd_info, and
struct sa_sha_req_ctx.

Also, now that struct sa_tfm_ctx *ctx is removed from
struct sa_crypto_data, the forward declaration near the top of
drivers/crypto/sa2ul.h is no longer needed:

    #define SA_ENGINE_STATUS		0x0008
    #define SA_ENGINE_ENABLE_CONTROL	0x1000

    struct sa_tfm_ctx;

And in struct sa_req in drivers/crypto/sa2ul.c, the cmdl member is also
never read or written anywhere in the driver.

Could the commit message be updated to mention removing unused struct
members, and should the unused struct sa_tfm_ctx forward declaration and
sa_req::cmdl field be removed as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-b4-upstrea=
m-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com?part=3D7

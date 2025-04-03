Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2DC1AAC9;
	Thu,  3 Apr 2025 08:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743667249; cv=none; b=cfEWaXprhO8TRxzKOqojVWSMb6NpauSsE6NfRhc1hVfWPRmafp5AwSX1Pq04nImtjmvaTfAHBDVQYPiwlWKZKL1zbkn1acP3Bk8esfyBWp9+/iIqyCR5n/u9LqIVXb+RhITr1EFV8PznIoVrQ9+svPVxd3zXVqnk44vA/POo+lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743667249; c=relaxed/simple;
	bh=OcpLJiwgybP4ohaSbygs08WEiRWpDE5aV0XSWIRmEPQ=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=ZFP1LMsIkHPmPNeozepWoRfqougRjpTor8Ek7Jh8e3dKV0ZQ6tg2PVBKmHHOjBRfmuBpdBUSuqRX8ZMuriXA3RXRtVZuzvqftTvK+Y3egSWzE1vvf0Q8XGpPqJOjakmQ6UIz96lorgTkZrH7QTAaosgBxpCmhYpPD9Nus6VK38E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ppe1MS16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ppe1MS16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC89C4CEE8;
	Thu,  3 Apr 2025 08:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743667249;
	bh=OcpLJiwgybP4ohaSbygs08WEiRWpDE5aV0XSWIRmEPQ=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=Ppe1MS16aGT4ga8Jo7wnDMVJFhBuPkbFEe1eL3jQHDSPJOGeh7/DvGSuog0gos4Tc
	 U0krqRIq45QxU+Di/EWbpVWfSM+TwjWdk4isGJYaggbwxGUwxtMQsyIxzv5ZqwwmgX
	 hJmsip3VYS6sAI9s8cMNc+W+WkPNXE3toDDbTn806h713yIWhKr2YUa72UYDA00Jqx
	 /nEyHQAeQY8QclEFUkgTUMUK1UFncxh58N3MiDSeEtISECzAL3dgkX5Y/fr8SLpnCR
	 fUh3QJijsL20hgd5ZrqcKqFd/wx6xA21qGxZ9h3pPsxcg5opt8k0wTg3rXqzZpmWRb
	 fEvDm+d+lTvZA==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250402111347.409795-1-colin.i.king@gmail.com>
References: <20250402111347.409795-1-colin.i.king@gmail.com>
Subject: Re: [PATCH] crypto: eip93: Make read-only arrays static const
From: Antoine Tenart <atenart@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christian Marangi <ansuelsmth@gmail.com>, Colin Ian King <colin.i.king@gmail.com>, David S . Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Date: Thu, 03 Apr 2025 10:00:45 +0200
Message-ID: <174366724527.4506.2393301557013834716@kwain>

Quoting Colin Ian King (2025-04-02 13:13:47)
> Don't populate the read-only arrays sha256_init, sha224_init, sha1_init
> and md5_init on the stack at run time, instead make them static.
>=20
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
>  .../crypto/inside-secure/eip93/eip93-hash.c   | 20 +++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/cr=
ypto/inside-secure/eip93/eip93-hash.c
> index 5e9627467a42..528d5bd864c9 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
> @@ -97,12 +97,20 @@ void eip93_hash_handle_result(struct crypto_async_req=
uest *async, int err)
> =20
>  static void eip93_hash_init_sa_state_digest(u32 hash, u8 *digest)
>  {
> -       u32 sha256_init[] =3D { SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H=
3,
> -                             SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7 =
};
> -       u32 sha224_init[] =3D { SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H=
3,
> -                             SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7 =
};
> -       u32 sha1_init[] =3D { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4=
 };
> -       u32 md5_init[] =3D { MD5_H0, MD5_H1, MD5_H2, MD5_H3 };
> +       static const u32 sha256_init[] =3D {
> +               SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
> +               SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
> +       };
> +       static const u32 sha224_init[] =3D {
> +               SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
> +               SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7
> +       };
> +       static const u32 sha1_init[] =3D {
> +               SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4
> +       };
> +       static const u32 md5_init[] =3D {
> +               MD5_H0, MD5_H1, MD5_H2, MD5_H3
> +       };
> =20
>         /* Init HASH constant */
>         switch (hash) {
> --=20
> 2.49.0
>

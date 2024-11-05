Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A5E7710C;
	Tue,  5 Nov 2024 16:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730822427; cv=none; b=mme9xvR3ZbQXTV7Gdle3DAKTR+Qkj2ctntK/+YGZAKp+Lxj6AOXhf+n+z1+OwE54ODMdHWiKkHekL6u235Qa413+7M7aFFRoVFmj/+lRWIQd1C1YX9F70oOHiwF0un0dFPTy3ba/XcXTLI1ozJZWbYvaB2G/wxNxGsTEogNTfWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730822427; c=relaxed/simple;
	bh=V6cdn4iEtDIyN/q6+O++ooUhnADPfXD/N74KSkmIMzw=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=UzJcl8CvgVeeIKYxrp4uTu8UU32sxJaK48ltr+kPdukhSXOgCpc700zG9ouZDSR8ycqKC6ZdWpXkcwqJv+x/qM6d0thJH3IYWfqScEfOnQzBmDNx/irUtJLHRAsJIpaDOF5xuSQxuLGIJwnJMQz8jKXhK9pTaYOV+DbR+kjaUno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyGg9BLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyGg9BLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87000C4CED3;
	Tue,  5 Nov 2024 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730822427;
	bh=V6cdn4iEtDIyN/q6+O++ooUhnADPfXD/N74KSkmIMzw=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=NyGg9BLTx4pPapcJi+qjxTs6+JDahplJnDFgmnB8jbqxSG8JrecxViN+lWxqz/9TB
	 wmBGcpsCJmyZsIQaK3D2OB8TBx0BvOfDe7zr97w4M421gEEPZ6lNfay48lRD1FXIb6
	 d78BS4YJ9ISgJpiLgJhUf84VtZWscA3Nh7evo337F/lM9vhIgXLz4VDmsctT26gZn+
	 dO2zYUBxeQ/YCEpxQe/GT4s544K0k+FxU3N8NSCN8opNX5qNUQPCVt14nzL7855yps
	 e2Ox1sC6okVEBm6IqtIcVVj0LuKU8sN3mgFqPEehzxSSOPnJAYGYEGbjlbExsYGfu0
	 1LEeCTMc1hOeg==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20241031112755.2949815-1-lihuafei1@huawei.com>
References: <20241031112755.2949815-1-lihuafei1@huawei.com>
Subject: Re: [PATCH] crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()
From: Antoine Tenart <atenart@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, lihuafei1@huawei.com
To: Li Huafei <lihuafei1@huawei.com>, davem@davemloft.net, herbert@gondor.apana.org.au, pliem@maxlinear.com
Date: Tue, 05 Nov 2024 17:00:23 +0100
Message-ID: <173082242323.5505.14169181853894683603@kwain>

Quoting Li Huafei (2024-10-31 12:27:55)
> The commit 320406cb60b6 ("crypto: inside-secure - Replace generic aes
> with libaes") replaced crypto_alloc_cipher() with kmalloc(), but did not
> modify the handling of the return value. When kmalloc() returns NULL,
> PTR_ERR_OR_ZERO(NULL) returns 0, but in fact, the memory allocation has
> failed, and -ENOMEM should be returned.
>=20
> Fixes: 320406cb60b6 ("crypto: inside-secure - Replace generic aes with li=
baes")
> Signed-off-by: Li Huafei <lihuafei1@huawei.com>

Acked-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypt=
o/inside-secure/safexcel_hash.c
> index e17577b785c3..f44c08f5f5ec 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -2093,7 +2093,7 @@ static int safexcel_xcbcmac_cra_init(struct crypto_=
tfm *tfm)
> =20
>         safexcel_ahash_cra_init(tfm);
>         ctx->aes =3D kmalloc(sizeof(*ctx->aes), GFP_KERNEL);
> -       return PTR_ERR_OR_ZERO(ctx->aes);
> +       return ctx->aes =3D=3D NULL ? -ENOMEM : 0;
>  }
> =20
>  static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
> --=20
> 2.25.1
>

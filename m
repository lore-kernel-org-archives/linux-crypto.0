Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795593354;
	b=i1lJu1FkFhL0OhEOO+aongtk4r3eFdX2ge0vxiPb9DNUnJ0/uynV3AIpbifvVFwovBMT
	 PYGLsgp5zGoJxN3icMLHvdQZZIUTz7C/132+AY4AOWK7asgrWzG5+aRWx4Ku66NX48TS6
	 9sFIGjJNv8uHW5ys4iIaFBt1wgWQw/LIHIK9WjHXSlO9ObT+eu3fvHvPyuDojLeJJv/po
	 TvZ0UG0lqXbWGeywCW6zyp/EQ5WiW5w67azwTNdzD6OSbA4L0KTZJwLlDg+BNYDlCZn1D
	 QEc2FyV4NOI0EYwiq/7332gAAX0GwG4cnMFzvhTtBQnPiPO1C1km6b5c0lb0SS5J/eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593354;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FnkMWyCV4b1M+YmxooerwPxU2vwelU83rWbAnbDUdBM=;
	b=j1pbietho5e1Dyqu0v2ozV7EmKsROiHxGu6i+chyyo+x1D6XxHREabx+B4CgnSqklz4M
	 52STdCmUtHMaAOVEVxymm85uNT1eGDgw2yirTxwUbq89Hkv+ahEaZ207xZsMaIxualeIz
	 WK8CgubRRNo2xpWahxobutYuNCi477Xxb2VZTNITxp2l4f7HAjXM37g4NsiZfuIvEM+Bn
	 KaYy1O21QbXHG+9xn9ebPjqw3OzOlvI+gdaWlQm5Xof43gXdW9srFhQ6siQK06eBQtzTy
	 XjhzvM5yszimqVwcdCf0F81wYL9yPEMXQsAsKm+bk4u++CWtjYKtlnB0p9Ti8YQJufQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HDLufEV7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABBE606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 07:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HDLufEV7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9D31F000C4;
	Wed, 25 Nov 2026 07:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795593353;
	bh=FnkMWyCV4b1M+YmxooerwPxU2vwelU83rWbAnbDUdBM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HDLufEV7S1Gsqon1x0dZj/d1RMx1e2gZhISS7YUIoSdI0L5teUtlyma8kS1xzokpq
	 MYKTAhUp6EgGa2R9a/gravxsGFrpKQN+Arbd7s36aU6FYfbd+ZFurszDzil3Dlnh8b
	 RKGM3/JKGnLPIushu6WSfiExKvnb65/YWdSv+Yc7n3aaYMbRKMlU230+rzAhFfBKHm
	 AAF+i85/+CIDU+wnHA6Q89nAWKpQXrY5FeBEF+48mYFSpKhfCRwk8JXlbGkQqWt3Fa
	 wsBPwRaybudCM2v520Ev2ktdcLTYIO8i77CQpxE731z4jQpDOTF9FMpxeYfC+fqU+r
	 UiJZoFCxrxnRA==
Message-ID: <sashiko-outbox-232852@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/11] crypto: ccp - add engine capability and version
 information
Reply-To: sashiko-reviews@lists.linux.dev
To: "Depei Yang" <yangdepei@hygon.cn>, linux-crypto@vger.kernel.org
Cc: "Tom Lendacky" <thomas.lendacky@amd.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Gary R Hook" <gary.hook@amd.com>, "Shan
 Chen" <chenshan@hygon.cn>, "Yongwei Xu" <xuyongwei@hygon.cn>, "Xiaochen
 Shen" <shenxiaochen@hygon.cn>
In-Reply-To: <2512ecc20c8969a2d51403d8f184bf2f3260cc29.1795588986.git.yangdepei@hygon.cn>
References: <cover.1795588986.git.yangdepei@hygon.cn>
 <2512ecc20c8969a2d51403d8f184bf2f3260cc29.1795588986.git.yangdepei@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 07:55:52 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] crypto: ccp - missing @cap kernel-doc description for
  ccp_has_cap() in ccp.h
--

commit a6f9105aa384767e740aed303e637b97511d7aa6
Author: Depei Yang <yangdepei@hygon.cn>

crypto: ccp - add engine capability and version information

This commit adds struct ccp_caps, a get_caps callback for CCP v3 and v5
devices, and a ccp_has_cap() helper to query engine capabilities.

> diff --git a/include/linux/ccp.h b/include/linux/ccp.h
> index e6c599243f116..06c3b14a1eb68 100644
> --- a/include/linux/ccp.h
> +++ b/include/linux/ccp.h
> @@ -11,6 +11,7 @@
>  #ifndef __CCP_H__
>  #define __CCP_H__
> =20
> +#include <linux/bits.h>
>  #include <linux/scatterlist.h>
>  #include <linux/workqueue.h>
>  #include <linux/list.h>
> @@ -30,6 +31,13 @@ struct ccp_cmd;
>   */
>  int ccp_present(void);
> =20
> +/**
> + * ccp_has_cap - check whether any CCP device provides a capability
> + *
> + * Returns: true if at least one registered CCP device provides it.
> + */
> +bool ccp_has_cap(unsigned int cap);

[Severity: Low]
This kernel-doc comment on ccp_has_cap() omits the @cap parameter
description (unlike the definition in drivers/crypto/ccp/ccp-dev.c), which
causes kernel-doc to emit a warning when parsing include/linux/ccp.h.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795588986.gi=
t.yangdepei@hygon.cn?part=3D3

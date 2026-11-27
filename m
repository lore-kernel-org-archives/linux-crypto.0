Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795772514;
	b=BIEU5LX4gtuRxRf8NbwpdEaF8wYI4hJB0JUndMqobVBfP3eKTWosa92eGtGG781qDI79
	 JK0uQ41CbvIVmqQeXNms7ElBUeZSx9tf5KzmuTG/sT0RlFPIJ1d0zi0G7gN9NaVWhngt+
	 DR79uWTWSjF+F60QUr9f2MZrFrt1vASg5qr65d4bf4pdXHcesHBIU5xSCpFxPgK+VDEFh
	 Xk9WvUzJxEV0Rd3X8gisBspQNfQ4ededKu7u60s08f+05J8X3W3CiVIOVBtGC9N8rqIyb
	 d+WJuvESUOyZXooW2fkfEzk247m/dd4Gw0DI4ja2S/Dua7EtEu8llQr9bbNAX/vBiHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795772514;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DedWLHAMyORNz4IiINVy3Vkzg1ksE2Jj3wzyLD4Lg2E=;
	b=PckbjEg55mxuZrTjbwuoA4IEkmFV4rHDQ0KKHtkzTxTNm+QQxJVdkOjYKSKKX8V/EZNd
	 gUvI73QZ2WZnOFhUKIb89i3+7ahWodqyQAbRoSS1XlRS/5I9xIEkZR7joVaq0dU4k2pgt
	 ahgLXF7YlYpPKxHwlQ2TgdRkjuxClYoV/8/XqMaFpmJUo0hrAeUIRbV7EzS0FJG5tMCG1
	 vVds0OWk5BVv7DHpTc57bV330r1tdVROKK2lMJAN3ZtF715UP57EATeTqhLGQBtXU4kXt
	 pzpUMXMdluIvgdXMa/Z1lNhPPfAE5Hvb/YoX7iKjS/WsqQOtbIoaWK64sILDEr0FEAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ncTTEzrg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CD1606A321
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 09:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ncTTEzrg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4209C1F00923;
	Fri, 27 Nov 2026 09:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795772513;
	bh=DedWLHAMyORNz4IiINVy3Vkzg1ksE2Jj3wzyLD4Lg2E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ncTTEzrg6zU9a5X6mWcn4zt5+Na8tCEW2hD98d1OnW2ARrVKjmd3uTNEjnOyPAIG4
	 kunhDp5nIcdoYZsgy/kD3Wj0uJbq5I51jp5qQILEloP1KQdja15ZWkjAjPHb6/50Ey
	 wsKPjAFYDBMxGDf9S9CXTUEizWAaCsYNQQkGJE97YGGPc/P2kXReXDclz79/oXA1tb
	 7lwp4oXVZoxdOBfs6AEq0muLMKNsgJzVMwMDFQnWEViZ86rMVuPUiPGQYq6uNPFxiU
	 R6hu8WCKjgvOP9wvlE6OmwlidKk4RaCRiVTEs/XoZ6Ej4OUcasYnfrAiSOwQwhFlwI
	 DvW8/LUOwsBqA==
Message-ID: <sashiko-outbox-236995@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] firmware: stratix10-svc: add FCS random-number
 command for Agilex 5
Reply-To: sashiko-reviews@lists.linux.dev
To: hang.suan.wang@altera.com, "Dinh Nguyen" <dinguyen@kernel.org>, "Olivia
 Mackall" <olivia@selenic.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Eric
 Biggers" <ebiggers@kernel.org>, "Miquel Raynal" <miquel.raynal@bootlin.com>, "Wolfram
 Sang" <wsa+renesas@sang-engineering.com>, "Frank Li" <Frank.Li@nxp.com>, "Jean-Michel
 Hautbois" <jeanmichel.hautbois@yoseli.org>, linux-crypto@vger.kernel.org
Cc: muhammad.nazim.amirul.nazle.asmade@altera.com, tze.yee.ng@altera.com, chee.nouk.phoon@altera.com, genevieve.chan@altera.com, adrian.ho.yin.ng@altera.com
In-Reply-To: <20261127092808.15537-2-hang.suan.wang@altera.com>
References: <20261127092808.15537-1-hang.suan.wang@altera.com>
 <20261127092808.15537-2-hang.suan.wang@altera.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 09:41:52 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] firmware: stratix10-svc: unchecked svc_va_to_pa() in
  stratix10_svc_async_send()
- [Low] firmware: stratix10-svc: missing
  COMMAND_FCS_RANDOM_NUMBER_GEN_EXT kernel-doc
--

commit c0a1d02e8645ffb7a27140a1a15768caf7cd4db0
Author: Hang Suan Wang <hang.suan.wang@altera.com>

firmware: stratix10-svc: add FCS random-number command for Agilex 5

This commit adds the asynchronous COMMAND_FCS_RANDOM_NUMBER_GEN_EXT client
command and corresponding SIP SMC function IDs to support the Agilex 5 FCS
random-number primitive.

> diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix1=
0-svc.c
> index 386673bc093fe..d6d1cf19d5a56 100644
> --- a/drivers/firmware/stratix10-svc.c
> +++ b/drivers/firmware/stratix10-svc.c
> @@ -1643,6 +1643,13 @@ int stratix10_svc_async_send(struct stratix10_svc_=
chan *chan, void *msg,
>  		args.a0 =3D INTEL_SIP_SMC_ASYNC_FCS_CLOSE_CS_SESSION;
>  		args.a2 =3D p_msg->arg[0];
>  		break;
> +	case COMMAND_FCS_RANDOM_NUMBER_GEN_EXT:
> +		args.a0 =3D INTEL_SIP_SMC_ASYNC_FCS_RANDOM_NUMBER_EXT;
> +		args.a2 =3D p_msg->arg[0];
> +		args.a3 =3D p_msg->arg[1];
> +		args.a4 =3D svc_va_to_pa(ctrl, p_msg->payload);
> +		args.a5 =3D p_msg->payload_length;
> +		break;
>  	case COMMAND_FCS_SDOS_DATA_EXT:
>  		args.a0 =3D INTEL_SIP_SMC_ASYNC_FCS_CRYPTION_EXT;
>  		args.a2 =3D p_msg->arg[0];

[Severity: Medium]
Should stratix10_svc_async_send() abort when svc_va_to_pa() returns 0 for
args.a4?

svc_va_to_pa() returns 0 when p_msg->payload is not a registered service
layer buffer or when iommu_iova_to_phys() resolves to a physical address
above U32_MAX that the SDM cannot reach.  Without a check on args.a4, the
SMC call still proceeds and passes physical address 0 as the destination
buffer to EL3/SDM firmware.

[ ... ]

> diff --git a/include/linux/firmware/intel/stratix10-svc-client.h b/includ=
e/linux/firmware/intel/stratix10-svc-client.h
> index edd7953d5d082..c924dc9a6ef2e 100644
> --- a/include/linux/firmware/intel/stratix10-svc-client.h
> +++ b/include/linux/firmware/intel/stratix10-svc-client.h
> @@ -202,6 +202,7 @@ enum stratix10_svc_command_code {
>  	/* for crypto service */
>  	COMMAND_FCS_CRYPTO_OPEN_SESSION =3D 50,
>  	COMMAND_FCS_CRYPTO_CLOSE_SESSION,
> +	COMMAND_FCS_RANDOM_NUMBER_GEN_EXT =3D 81,
>  	/* for extended SDOS encrypt/decrypt */
>  	COMMAND_FCS_SDOS_DATA_EXT =3D 82,
>  	/* for generic mailbox send command */

[Severity: Low]
COMMAND_FCS_RANDOM_NUMBER_GEN_EXT is missing from the kernel-doc comment
for enum stratix10_svc_command_code, which causes a kernel-doc warning
when building documentation (via
Documentation/driver-api/firmware/other_interfaces.rst) or with W=3D1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127092808.1553=
7-1-hang.suan.wang@altera.com?part=3D1

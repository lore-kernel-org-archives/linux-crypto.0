Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794331222;
	b=McxenayUSzGG6a9IWvDVulozNMnPUf7Q2VN/31ndKVAyjRZGv2//uQmUG1QiNhH81P0e
	 Q8sZrvRDlxhisRYNsHEHgk0U15nNLmepe4qnELfxtUFvpLtTGCCh1CbR8Mn2VO21XrELT
	 edt6gLb9nhvtbYGJbjwBt8O+9TKGvcZ/TboEPCBBplFoq7ox8k3WPJIQ+KGWnBkiTbF6W
	 2iKdepis1cBlv+dxERyuE1Jiyv7wnpF/M8GRRgzEWqifenGPcoUmEgTh9wVmYMc7m5ZgK
	 c+g9rbESWHNkJnxxsvbJGylrzMDqfioo4ggU9Aie2yzdbFPAbdtDrYR8IIM8kQwfoOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794331222;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XwRHJ5rgcBcS/4oDRmK/CSwkap1QXXY5pWQdVGpfuaE=;
	b=RRPYHa+xh3e+MRJJNN88+vAYgV6nNRLXTakqJsOZz7H7x7LxMU3pZGkR+mdnsLxDHXsn
	 HFUcynZ4kes72ErnQvMVLOzrWMRZWs4lGq0QG5wB/K5a/PG6olN+xHmGtkyLSjhMpRreB
	 wa2MXguh02cKdj3q6+/Mk2CZXFTQ+ZAprAvjFJBALieABiG61ACGrCVftoH1fPKsZWkpA
	 xjaroIsPpoyHIEHYDrlcRdC603ahmPkIqCs5c7IWqzsdfU1vvojCMs/u8wtJhzE0p3jW3
	 wyIGZ30J6iuBRQW84baG3oqVmAvbYMZ+FKXIN/+c2zck3hhwV5J07IUhAqYUAoy/myA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWIfuL3b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E987606A323;
	Tue, 10 Nov 2026 17:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWIfuL3b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FED1F008A1;
	Tue, 10 Nov 2026 17:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794331222;
	bh=XwRHJ5rgcBcS/4oDRmK/CSwkap1QXXY5pWQdVGpfuaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aWIfuL3biVKcls24awRmlDaxX50cwvW8NTp+Aa/EzJdEwMU1fhbGDxg+SjhTp5iug
	 yEW7edgKdyNirTBn1O7tFs9gIOTpQ9rRhHZjmidlb3deOMxrufYS6dlROvSNAV3weE
	 0DbrTCslV6QhXF7TtxObbOnk+r2YotVslR09KwTLxcsatsmhNiY9WromBP5WCBVUy5
	 LxSoOp7G1yESkGPXS057ZH3nsEpnfJ71wq2oYqIlBYGfpygltQRGfa6Yz7Ja5Jafts
	 JYGbDdMcU2CNUHKGhfeTAz+2iOncfXO2/y+LNB1YyRebsY9N/afsgPNoXqtDhhfbDr
	 COQsNLKXaIJ+g==
Message-ID: <sashiko-outbox-207462@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 1/5] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alex Ousherovitch" <aousherovitch@rambus.com>, "Saravanakrishnan
 Krishnamoorthy" <skrishnamoorthy@rambus.com>, "Joel Wittenauer" <Joel.Wittenauer@cryptography.com>, "Thi
 Nguyen" <thin@rambus.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261110-cmh-b4-a-v8-v8-1-4cea8ebc1d40@rambus.com>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
 <20261110-cmh-b4-a-v8-v8-1-4cea8ebc1d40@rambus.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 17:20:21 +0000
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
- [Medium] dt-bindings: crypto: rambus,cmh-v1030: invalid unit suffix
  and $ref on rambus,slot-stride-bytes
--

commit fe48437ab6a40e215371f9ad1c5f69cf88124d19
Author: Alex Ousherovitch <aousherovitch@rambus.com>

dt-bindings: crypto: add Rambus CryptoManager Hub

This commit adds the device tree binding schema for the Rambus
CryptoManager Hub hardware crypto accelerator and registers the rambus
vendor prefix.

> diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.ya=
ml b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
> new file mode 100644
> index 0000000000000..eef82c2d71794
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
> @@ -0,0 +1,145 @@

[ ... ]

> +      rambus,slot-stride-bytes:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [512, 1024]
> +        default: 512
> +        description:
> +          Stride in bytes between consecutive VCQ ring slots for this
> +          mailbox's command queue.  Like rambus,num-slots this is a
> +          per-board host-memory ring geometry, not derived from the
> +          compatible.  A slot must hold a complete command sequence,
> +          which needs at least 512 bytes.

[Severity: Medium]
Does rambus,slot-stride-bytes cause make dt_binding_check to fail?

In dtschema (meta-schemas/vendor-props.yaml), the -bytes unit suffix is
deprecated and disallowed on vendor properties, and properties using a
standard unit suffix already have their uint32 type assigned by the core
schema and must not specify $ref: /schemas/types.yaml#/definitions/uint32.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-cmh-b4-a-v=
8-v8-0-4cea8ebc1d40@rambus.com?part=3D1

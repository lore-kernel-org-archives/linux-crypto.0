Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522513;
	b=PJzXV/S4y54BbNjv+WZrB+xdky8v/2bX94MmbxvMQvzs5R79J1NJYtoyt1cEWbBQM7/4
	 vk3+tA1LvVAWLwFXqFEPlodLIKnC3wgtsa5y/yc+oQOhkUeMPL7fVgT1nU6YuMTQ2Mdth
	 Mwqm/ifxMe4OEbyjlCpgJWFoizc8I6gociDBwZnb3mXMZdWV6s2eZmKFHJfSZpBM9shG7
	 MEz8uG7ketFM70xg5/64Jx0C7K9Eee9vNxldHBf3vegZEBwf8++tmyukVSaF0VsRwsD8J
	 Wc9a9+HzRsA8wTUZ1sq0a5tQM3HokMWzn0y7lIptRFK3hCfkQwewX9DNQJxE4W2Pviw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522513;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=pKCNvDsg+oBottVPeFIlN7p+2x8Q5LX68PIH3n/ihSw=;
	b=W+evM7xt0T09+7hmZvlYDnOFhjtmgSERDZM7hjO1P5/CpCa3KXXi75QkbGDwwVirDjJc
	 x6TkuD91rQvCxzTpUGbF8dmgKPaMOrOhpJcRHGwDceHX1/eml9+xiaQpw77giXuca+mok
	 89R3tI4JVGWMIS0pxb3Iro2jF4mG/3QxAnezAJ9AD9bwmmxkwJna60obxpuuPcJydmCF1
	 QWu0A/8OZtURDP5g+8kIKVzCE2npbeZmEq0Q6k5Ni+oqts+VwluphxkBC1qfem7JgM9x8
	 10C+8zbPbNs3uSpWuPpCBGxjxbb8oRWfxk0o3fPl9oOp1550c6ZhkXr1VGunyqWsksw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MwRLVPVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EE4606A31C;
	Thu, 12 Nov 2026 22:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MwRLVPVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC381F000C4;
	Thu, 12 Nov 2026 22:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794522513;
	bh=pKCNvDsg+oBottVPeFIlN7p+2x8Q5LX68PIH3n/ihSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MwRLVPVoSTFwCs3OOmBLZv1XjQye0eWFg4emCJGTKbE2KOq1idYvxEKOwdnaGmggD
	 3JG8iHJC14U7DiDp/GEWZMv5UB9x6E7e8Xiko1Uwp0B4GwMK+ooAGCY2SH7XkKt46S
	 qL3AsdcJWxdntKmNSaVH77uFynaJsaqRTuWYSAml//vp2p1TCUHXuDsW96mV3Fxpl3
	 wNrhjvSyio8rl1NAFJAhV6Xx4V0WVPI6CUVAjVxiU48mEkYTMNlYicJj4IJE2bkhmG
	 /WX24bimBt+vzuOGWEtkVm4QVCy+6rrcnmlVeEZjEZLo2qET7DVrCViuEO2l7keS/5
	 PPGeFLL3tUi/A==
Date: Thu, 12 Nov 2026 16:28:27 -0600
From: Rob Herring <robh@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Alex Ousherovitch <aousherovitch@rambus.com>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	Thi Nguyen <thin@rambus.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v8 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
Message-ID: <20261112222827.GA1685895-robh@kernel.org>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
 <20261110-cmh-b4-a-v8-v8-1-4cea8ebc1d40@rambus.com>
 <sashiko-outbox-207462@kernel.org>
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
In-Reply-To: <sashiko-outbox-207462@kernel.org>

On Tue, Nov 10, 2026 at 05:20:21PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] dt-bindings: crypto: rambus,cmh-v1030: invalid unit suffix
>   and $ref on rambus,slot-stride-bytes
> --
> 
> commit fe48437ab6a40e215371f9ad1c5f69cf88124d19
> Author: Alex Ousherovitch <aousherovitch@rambus.com>
> 
> dt-bindings: crypto: add Rambus CryptoManager Hub
> 
> This commit adds the device tree binding schema for the Rambus
> CryptoManager Hub hardware crypto accelerator and registers the rambus
> vendor prefix.
> 
> > diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
> > new file mode 100644
> > index 0000000000000..eef82c2d71794
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
> > @@ -0,0 +1,145 @@
> 
> [ ... ]
> 
> > +      rambus,slot-stride-bytes:
> > +        $ref: /schemas/types.yaml#/definitions/uint32
> > +        enum: [512, 1024]
> > +        default: 512
> > +        description:
> > +          Stride in bytes between consecutive VCQ ring slots for this
> > +          mailbox's command queue.  Like rambus,num-slots this is a
> > +          per-board host-memory ring geometry, not derived from the
> > +          compatible.  A slot must hold a complete command sequence,
> > +          which needs at least 512 bytes.
> 
> [Severity: Medium]
> Does rambus,slot-stride-bytes cause make dt_binding_check to fail?
> 
> In dtschema (meta-schemas/vendor-props.yaml), the -bytes unit suffix is
> deprecated and disallowed on vendor properties, and properties using a
> standard unit suffix already have their uint32 type assigned by the core
> schema and must not specify $ref: /schemas/types.yaml#/definitions/uint32.

That's got to be the worst hallucination I've seen from sashiko. There 
is no -bytes suffix.

Rob

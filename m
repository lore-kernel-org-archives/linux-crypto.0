Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794371036;
	b=ri/Thx2Ci9chM4+ZXSh+tnj8YIx+ZlzMNHrlEqyUAvMKsN8gbqzOS6eXry6NI/sLWwgj
	 KyCxa/zCJtZpm7T1vT72meIWegF/shT/3ZFBusW/KYXTipmcQ/Nspixq2k8eB+FHa3EBS
	 CLPnyC3nC0wj7gVXHKc8JbNGkggBN8umQ1UvjnrZdvDvb8kZ8NWn3kzBZ7BtKWHyOHVIR
	 8tTfUfuQWMjusWmGLkZSrXOzHZu6waevbjLIvrqkzb+4XIkckmaBlOo427cJiJmusHVH1
	 zZooTgnwwYV9Zy4FMgU1G2soG4IUemiGKvDdTKtz5qSmFvIjmTaJ7f5Qckb3LnDVtxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794371036;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=3/oMUvfjnRDqTYECREY0yvKf+oNzhYCqjwUaHTL4kiI=;
	b=wJ2rb+hp3/xmMRiuhjIEemwaPZgxe0Pk0Px0U/y07dqBXvKxFNvT+4Zd/gEYb+IAoxA9
	 Inl7yufPmNtZ7wkylwAXwvjGiihC5f3OFbWjSearonyfMGyDZl54PNzMO6vrSbc78Flm4
	 PQjzJOdLatiLy03Kr2jIN7rP2oVrsZKRlwTjSEMZICGck6KDS7BROofnb8L95VOF1OkVk
	 iaXpqi1S4tIU3d/JXPWPlQeLhCLeXVP76PvXze51sVL3qvncHwYAf5rWaebMDUZ6qm4DN
	 RfUSR8RGudPwWuHousxTlFtRJPCNTMQJWWBoD3Xt4uEjHanKSKkCYvfZHpNwZmWzp6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=andrewgigena.dev;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.170
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732A6606A31C
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 04:23:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 732A6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=andrewgigena.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b37c7d767aso21872537b3.3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2026 20:23:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371035; x=1794975835;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3/oMUvfjnRDqTYECREY0yvKf+oNzhYCqjwUaHTL4kiI=;
        b=Mkl+lELHRUEJrH5ew92DvgfVolYH+TaKQd3mA9r9LdWACJoyIiQrwn0CX5FScaSP2D
         i10+032rZ04oWj83EgL2zECx0A86Q0qjoIS88wrjOBqTA26iJjN3b2a1JNVNydgpeaod
         +z/hRjfK4665RnwgH4gPXfvMa3wX6ZbvhFsILWAAisgQFGy9CzOlMCoyy44IYVHtN5Xa
         Kq5IhQK2phlMSrUKzhqYtO73OO69WKMrXD0Vwl6901cQ/fu4EK+4IRhBiWKIXzQqSbIq
         fIpFSBM1R75/p/C5T64CXK/UjHEiMoJALO1sskN8Wyvh3OxuaZtb2GfJCcJbn7mCFJqF
         tXzg==
X-Forwarded-Encrypted: i=1; AL+hErGaG//8ffVxEq2S4lTPGbgK2+2BKgBM5gEcKX1FY24OKRHqYoh0J9UPk66D9PYB71qCriaTKcyN/wgPAA8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+fqxpcZO8jKJF1BP8LITcO5HJlbD1g7Wr65Y5g2xw+rQ8ZyozB
	8V6BewY23f+f2xVe7zkn8iCwBWZgAeX8cJeVaBhu4YuwhmY968V9MV3I
X-Gm-Gg: AYBFou31pqdOKOWXFc3xDv677c3NuO0vlv4EZwHWCQZvJlVgsQXIrmZ4e0cBNsOz1tD
	dKoftYbfrupYB4bOctwRpkbeV2l2kcvxAi1fVOi6MXC147ZEAr+6a7pdIty78oXtAyvSOvCRPi6
	kTJWipPJ1lOUGKzlYJ7FYl1amrfWD8YilWp97V6fW3IiphKXJYtguMvMeSL+2+H+tXXW7mpO0U1
	9AV++0DLLYdMARkAsg91MSc51BGJgMQf0Nv8gtIB4iEDnkLxi4uduH47nB8Cf396dy/HUmvQt6j
	CBHm6qdm2hjvpFnUAxn016NDZVMg0H8ujmfrOJGm2y8rH3PnM6m8cs3C/I72n3dNO4/qEefChcV
	XYOZlJpwQtP/i/+BfCp1uRdhBUnhlLNrvE47/s1zwGXwCGBiyMNndK4G+abFF6LGqQ4WwXkNzGx
	eQ3GkLAp76WQZc4Yj0j3kv0KLDJUEI9raR7G7mVvEcPSfnAjCJKnvqLR5FrYEAX2xwbtu/08GgK
	NLIu/gqmJ8TIU4Wl0WS2s71CYFm4mdLQxAHBvOjbKNAQTOPinbubV9nJGkKpwoedmQu6CsAt788
	VXzlk2UGjG2P4LfZkl/DxOhPzSSErb/RCplH59rg8tkFbTr2a9pn2QU89YWBDWYOZViafRAQ
X-Received: by 2002:a05:690c:7342:b0:8b3:23f3:134d with SMTP id 00721157ae682-8b3a80ee26emr9648857b3.42.1794371035274;
        Tue, 10 Nov 2026 20:23:55 -0800 (PST)
Received: from ?IPV6:2800:a4:806:ef00:6378:bcd1:64fa:19e3? ([2800:a4:806:ef00:6378:bcd1:64fa:19e3])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3933a165csm36073107b3.14.2026.11.10.20.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 20:23:54 -0800 (PST)
Message-ID: <fb4d03b3-eb35-4aeb-baa1-f4df54653192@andrewgigena.dev>
Date: Wed, 11 Nov 2026 04:23:48 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: ice: Document sm8150 inline
 crypto engine
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Abel Vesa <abelvesa@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>,
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>,
 Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v2-1-d697bbce0278@andrewgigena.dev>
 <20261106-offbeat-hawk-of-purring-50a8aa@quoll>
Content-Language: en-US
From: Andrew Gigena <mail@andrewgigena.dev>
In-Reply-To: <20261106-offbeat-hawk-of-purring-50a8aa@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> This part should be a separate commit.

I splitted it into two commits in v3:
1. Add qcom,sm8150-inline-crypto-engine compatible.
2. Move qcom,sm8150-ufshc to the standalone-ICE UFS binding.

> And what about eight clock? All existing DTS will report warning? I
> don't quite get the need of this move.

After the move, SM8150 UFS no longer provides the ICE register region or
ice_core_clk; those live in the standalone ICE node. The only in-tree
user of qcom,sm8150-ufshc is arch/arm64/boot/dts/qcom/sm8150.dtsi, which
is converted in the DTS patch, so there are no leftover users of the
embedded-ICE binding for this compatible and no schema warnings.

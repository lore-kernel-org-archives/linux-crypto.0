Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AF230269;
	Tue,  3 Jun 2025 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748953566; cv=none; b=nn4Ei5VjYcMdm0Xd2AgTEyozQ7tJ77nSvzkIDY1G7VSn2NLA14iwj7g1sjD00/bNTPQtcgrM8Ltvb0fYaNJRJg88FI4tSmmhud+6icecuf4E2YbFOosqx9lM6f1Vp7K/dzOdd+BMzEtnqq7udt98zvRCMGIz8sKyp4giq0BbEYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748953566; c=relaxed/simple;
	bh=tHZkS2gDc5R6PRSSy2GDSAjrvxvt8ls4OrmreSQgCpk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iSC0wfiKcBWqX0LeO3bTbtQp6QXxWXrODA8UknmKPEFKsY4/fQ6fxpkJ5wnm4VgWsX8ezvUNfvpuP8pLhA3J2soALufXjfE+PCncWSs3Zs6MP9PrWWeHYplFiVppnYAxPxsNrPCvCNY/zN9/abAkqY4CQFJqp7aoh7giyC+383U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qFm9vfNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qFm9vfNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6544C4CEED;
	Tue,  3 Jun 2025 12:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748953566;
	bh=tHZkS2gDc5R6PRSSy2GDSAjrvxvt8ls4OrmreSQgCpk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qFm9vfNmitMHtkOT7TKrqnVlYO25yxCnAddldmljgmE57iso/wVRVfQXR/naZn52R
	 1eE1rlSA+XdzIn5AwL0nuh4k1ioRzqBIDS9F84mvdNQQ6roh9EbpceJjIoKnn2pJqY
	 4mPhnkmNLb3XAS3Re2IFURDN2NdtUXx44kWP4gE18HvBg7TVqjH7HF2zc2tJrwLzup
	 RpVfMexUsGDPl1xVs0ANYaAX0eEsX0kqBH1tE76nik3sVVi0sleUBM9IUtRHsOz21J
	 c8C154/rTtOPlAZw9thd/odBzUI+pzq2bh/SsqPYhCVnn/WTpaiZbHe+lm96SYoDdD
	 hcuTKLs31P/Ew==
Message-ID: <88c50d26-2e47-402f-a8e7-a058f06d08bd@kernel.org>
Date: Tue, 3 Jun 2025 14:25:59 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
To: T Pratham <t-pratham@ti.com>, "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Praneeth Bajjuri <praneeth@ti.com>, Krzysztof Kozlowski
 <krzk+dt@kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
 devicetree@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
 Conor Dooley <conor+dt@kernel.org>, Kamlesh Gurudasani <kamlesh@ti.com>,
 linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <20250508101723.846210-2-t-pratham@ti.com>
 <20250508101723.846210-3-t-pratham@ti.com>
 <174670267292.3889463.9488828665934209667.robh@kernel.org>
 <b254325e-32c6-4b5d-a20c-abe2888fea27@ti.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <b254325e-32c6-4b5d-a20c-abe2888fea27@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/06/2025 12:52, T Pratham wrote:
> On 08/05/25 16:41, Rob Herring (Arm) wrote:
>>
>> On Thu, 08 May 2025 15:37:40 +0530, T Pratham wrote:
>>> Add DT binding for Texas Instruments DTHE V2 crypto accelerator.
>>>
>>> DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
>>> only found in it.
>>>
>>> Signed-off-by: T Pratham <t-pratham@ti.com>
>>> ---
>>>  .../bindings/crypto/ti,am62l-dthev2.yaml      | 50 +++++++++++++++++++
>>>  MAINTAINERS                                   |  6 +++
>>>  2 files changed, 56 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
>>>
>>
>> My bot found errors running 'make dt_binding_check' on your patch:
>>
>> yamllint warnings/errors:
>>
>> dtschema/dtc warnings/errors:
>>
>>
>> doc reference errors (make refcheckdocs):
>>
>> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250508101723.846210-3-t-pratham@ti.com
>>
> Hi, the error logs here are empty. What does this mean (error, no error)?
> 
> Also, I ran `make dt_binding_check` locally and did not see any errors. Below dependencies are installed and up to date. 


Probably false-positive. This happens sometimes, sorry for this. Service
is provided as is, in good faith.

Best regards,
Krzysztof

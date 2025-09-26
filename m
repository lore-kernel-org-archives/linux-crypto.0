Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40FE15667D;
	Fri, 26 Sep 2025 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758919999; cv=none; b=riJq/MV+mHKzUrmKop22u8NKHIOj29da2Y4sk3UqH4texGsrT2qRFFCwZkah/G4ONk2Td3P4Az71BOUafOKoCe+UwsD1/r/9mDjCRxFTbHVDKXdh6lv10cg183YzZC+ZTf2x5FZ5zQm/k9d/qhkkBGW3LHxpW0A8EW7u35OSWRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758919999; c=relaxed/simple;
	bh=VX9muv7LJ2bgSE7kEQcSdlQrPIKoHywwIEEO4EYQl9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfuvQsmNczLyHTah20/6PNijZI7ces/LjzGRcm+Wnjv+VaZt8QDxPF1xPuu5NDxu8N35J5tulrirrNGV9OtXV/O8Gfbti366kyEyStUfkpfN0mYCoavWip3fqNG7B4cgO3KBEpxbye8jToaqzZfLt4Mt8s8zGFkhIuy8LHdeYLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tI2pqM1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tI2pqM1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBADC4CEF4;
	Fri, 26 Sep 2025 20:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758919999;
	bh=VX9muv7LJ2bgSE7kEQcSdlQrPIKoHywwIEEO4EYQl9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tI2pqM1r6pDeKJC51PpWH0TUYTQjM/V++cU2xMqx9sNFSIu66prh2NZdG+AQ7WRsU
	 uO9CFippUQdmLOBa3JGwGjXki3SEFMNV+smX64SPWW7wtqzlyMrNIOMMNyA4ZNsE2h
	 eDKqdfhmklnnWgLMrDPDwVa2imdWzGavmiqar7uHvJINr850OX2wUMRvk45ib+LlDq
	 3h7EKflsQFpJaEFoE0f8dADg3GTC+UQhVpsd7E4lTldvqXmUlvkG3TDCrFrGudmqQb
	 vD1uS1lh3Z0Pv/ZpLL3v/aE9sdW56K40d5OrgfItSls4evfgHoYObG/inKyQ+rdQJl
	 R/iOipE3gmlSw==
Date: Fri, 26 Sep 2025 15:53:01 -0500
From: Rob Herring <robh@kernel.org>
To: Kael D'Alcamo <dev@kael-k.io>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] dt-bindings: rng: sparc_sun_oracle_rng: convert
 to DT
Message-ID: <20250926205301.GA1448549-robh@kernel.org>
References: <uprke6fujhmckymlpy6oskecol4awhqyroqlg25tprmhnkeyy6@ztozdrlmeotp>
 <20250924141247.69323-2-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924141247.69323-2-dev@kael-k.io>

On Wed, Sep 24, 2025 at 04:09:18PM +0200, Kael D'Alcamo wrote:
> Changelog v1 -> v2:
> * updated vendor-list by loosening the regex for names without prefixs
> * removed extra example in DT binding
> * updated DT binding filename
> * updated DT binding title
> 
> Kael D'Alcamo (2):
>   dt-bindings: rng: sparc_sun_oracle_rng: convert to DT schema
>   dt-bindings: vendor-prefixes: updated regex for properties without a
>     prefix

The reported failure is because you need to reverse the order of the 
patches. Normally Herbert would take it, but I went ahead and applied it 
reversing the order.

Thanks,
Rob

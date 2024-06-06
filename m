Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06108EEC5;
	Thu,  6 Jun 2024 00:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717634054; cv=none; b=Ve2q2islumecJcry55dNVbZKIvyJt9ODUC0f5h/VbbAEvz5PEMP/r13+4NfKhjlTdhomQL8r0qaQ/LbGMj/VKegapAmJlI28RDeY7jrjZGW6ejJIkTVc+MB0rHcrBLDWuFwz1C+K6gYK+to2TAIoVPMNOZE0RIoL6NqjAVys8uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717634054; c=relaxed/simple;
	bh=m0r5W0VjsS2kLZZU03Axuz4ultnH7JPnF9siiZ0d0TE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYVedwAbrgjNktsj2RmiUQ1Nw4JfzKAj3KYJDIcwrAbC0hpdRUsCwi8G92WaBODM+EOIWWjwGxPa7D3zB0Dpxr/aGU5l7Hsj/5xODe1AL06tzZtLO7biEqpdazMDepdQHoBXCC9+A6jIi+nOq2VNV4KATbjhrghnu8QBckjpXuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5JNv9td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5JNv9td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520DEC32782;
	Thu,  6 Jun 2024 00:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717634053;
	bh=m0r5W0VjsS2kLZZU03Axuz4ultnH7JPnF9siiZ0d0TE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g5JNv9tdIuEGHFhQxoSBGim1OynMbSGQIbVQug1PKEGppvqN2xHOC1LNyWYzISMiS
	 IX1jijNfw6Lmx3YK3hQGiYWCQaP+Wnhq2tUvrUYxBWYIAvtiamqc3Iu4bQpdTtTFFp
	 sPdU+Vbzx23eSMmzGOM91Urj8Olm6WVa5FpYTDy5KHW4kj8ufEvm7KeiwPGHvneUIa
	 vU71z4+zbTTiDbwNZ72DSZ5JhDtjqc6MAsriHzJg7jPzJY21sXfiLaIPbi9qE2HLnK
	 tbib7il6J9rU6RudRDAKrib7lqLW8WtcEzLhPSuwOf5rA+D/wtQI00LPXF3JORAeoF
	 niFBTLv1INs4w==
Date: Wed, 5 Jun 2024 18:34:11 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-amlogic@lists.infradead.org,
	Conor Dooley <conor+dt@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-kernel@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	Kevin Hilman <khilman@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	Jerome Brunet <jbrunet@baylibre.com>
Subject: Re: [PATCH] dt-bindings: rng: meson: add optional power-domains
Message-ID: <171763404853.3520126.5459259781285680481.robh@kernel.org>
References: <20240605-topic-amlogic-upstream-bindings-fixes-power-domains-rng-v1-1-0a55a7ba55e4@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605-topic-amlogic-upstream-bindings-fixes-power-domains-rng-v1-1-0a55a7ba55e4@linaro.org>


On Wed, 05 Jun 2024 11:36:33 +0200, Neil Armstrong wrote:
> On newer SoCs, the random number generator can require a power-domain to
> operate, add it as optional.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>


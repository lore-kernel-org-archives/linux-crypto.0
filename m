Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55A4258CDF;
	Mon, 22 Sep 2025 20:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758574246; cv=none; b=uEizxDG4f1He8x9DsyaLDXNQ2zCPbcaHqTDu6VQDoIK4KAkBcq7c3jUQ5LKd+AsYV16CvgsxH38Nv5yIu69r5GH29+VZzEOF8D+8cLePzZFFHLaICLR6CLgY0GOt0uPRSk05ZwMnE1MepMoMhPzewkUgK8BVfnpfFtbLBvCh1QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758574246; c=relaxed/simple;
	bh=ZokxDKW/Ze423JieQnSL8uJWgX2kMCdYOdtmF/G1p1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dVdhkwarzgWuAgJ/umWb95kCqSHpz6lkPZUJzX7N7M3mnHO8fQG6j41nvXAlgJdeg3r88NtAYIlIc6nvUQ+V9h/+dJ2j9Meh8A+k19TIQDBRf/rto44lhzWLO4SBk1Mc7QUFia7z1mmCd0NrYOl9LBp5if6ONHTAcfQhw7k+/fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4vBGQLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4vBGQLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39C7C4CEF0;
	Mon, 22 Sep 2025 20:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758574245;
	bh=ZokxDKW/Ze423JieQnSL8uJWgX2kMCdYOdtmF/G1p1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A4vBGQLiBGXnskKUlxNzGPymxL1Uvbxc+w+xYKOZCdZqx36hMUPKhv4neir33lfqV
	 kItoZ82ZRonTL7ChYMbbBD6Jhg1zgA8AgslT8F1luTAXWJ1ndqechrgpYUKK4LS9b/
	 kZw8N+Jlpi66CeW6zK/1plnDOOuf6XcFqJPXeTz3Tf+e/wp2T5hXjlywT66FSiNmCp
	 ipe2QT+vZVOD7EZg95XkHlLYUf/5sgTGxv8wHG5uWE//EHYArkjMy+osfL/AyaYFwq
	 y7xIOmcgFlg0P6oCu1bGk6RTZxgzrZn/xGH06/UtMpyrtJRUYcAAS77vnf1e1GNqhP
	 c5B9lU3+t0N0g==
Date: Mon, 22 Sep 2025 15:50:44 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Kael D'Alcamo <dev@kael-k.io>
Cc: Olivia Mackall <olivia@selenic.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: hisi-rng: convert to DT schema
Message-ID: <175857424390.1302338.1567970121229635988.robh@kernel.org>
References: <20250921161139.99047-1-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250921161139.99047-1-dev@kael-k.io>


On Sun, 21 Sep 2025 18:11:34 +0200, Kael D'Alcamo wrote:
> Convert the Devicetree binding documentation for hisilicon,hip04-rng
> and hisilicon,hip05-rng from plain text to YAML.
> 
> Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
> ---
>  .../devicetree/bindings/rng/hisi-rng.txt      | 12 -------
>  .../devicetree/bindings/rng/hisi-rng.yaml     | 32 +++++++++++++++++++
>  2 files changed, 32 insertions(+), 12 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.yaml
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>


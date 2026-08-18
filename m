Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9108023EA97;
	Tue, 18 Aug 2026 07:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038610; cv=none; b=kT8z/WzKiY+7kl5Su0RV9N/4V4ueqsmK0hXNgZpg2izrNy+PcbW8Cs1IJY1PnUz6jEDfQd+Gtn9LhxtbuqFkKQIrgX8qncDu0MjLTLJNlculUEzwHFDyV4gKeLtzcWldjyiCQTBilyXDVUgXVWVK2R6XkxYT/Fgf48RrVo7f7HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038610; c=relaxed/simple;
	bh=JJ/aE6Wjngy1fNNepJBWrQqa3OC4LEP8movRCdS6xTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rfNDbb1zBduXlCAAX1AC615WLaJxCXYPj1dY9KovHYCx83IZbqIDqVFqKLRDPumLTfQzGxkQGKCpW9oVEZnEE4pji+lcbB1iDoevnps4YfdTedKB8Be8a4/AFtmgTvewjRbyc2lHs1ClQhv4nA+AOET+Nb61zfVy38TkfcDsvNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1P4a9ou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1P4a9ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183431F000E9;
	Tue, 18 Aug 2026 07:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787038609;
	bh=rtkd86yXauUYJ1yESUkr9rEpociEDl/J/0AtQD1n78I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k1P4a9ou7tb8cnDpwVNWLEsgCBoIDWXh62nxOvjt5agsWxXw2VY9LykwQ43Y14OA2
	 mMWZTx8mlBD8sBZFdOx6oigS2bv8lnui8AX78kHz3vzHi14P7/I2XZW2yqqIFVLchg
	 5aHlx7touN00eIywRNx7wv04+yzZ+yV/FR0ecMlrpDM4+00HETwPoLd6zWAAcWtNYi
	 1dGrrCIIqlqj0TqcCOkWRZiYQq9y4JMtRMPGAK6nvpkLSZxrUZSBglboImWqyb5fHf
	 3Ald4L46lSnvTvpS2cvmGXjHipJZKUzWdIlfk2z4SmQKtC5QixdLQnzh8b9+MExgy6
	 ebLpSZUPIdVeA==
Date: Tue, 18 Aug 2026 09:36:44 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Dawid Olesinski <dawidro@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
	Diederik de Haas <diederik@cknow-tech.com>, Eric Biggers <ebiggers@kernel.org>, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Conor Dooley <conor+dt@kernel.org>, Corentin Labbe <clabbe@baylibre.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] crypto: rockchip: Add RK356x/RK3588 cryptographic
 offloader driver
Message-ID: <20260818-enigmatic-friendly-lizard-bc8aaf@quoll>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <20260816194112.552100-1-dawidro@gmail.com>
 <20260816194112.552100-3-dawidro@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260816194112.552100-3-dawidro@gmail.com>

On Sun, Aug 16, 2026 at 08:39:45PM +0100, Dawid Olesinski wrote:
> Add a driver for the second-generation Rockchip cryptographic hardware
> accelerator found on RK3568 and RK3588 SoCs (compatible strings
> "rockchip,rk3568-crypto" and "rockchip,rk3588-crypto").
> 
> The hardware provides:
>   - AES block cipher engine: ECB, CBC, and XTS modes, 128/192/256-bit
>     keys. XTS hardware is limited to single-SG requests.
>   - Hash engine: SHA-1, SHA-256, SHA-384, SHA-512, MD5, SM3.
>     The hardware padding engine (HW_PAD) requires the total message
>     length upfront and cannot maintain state across LLI descriptor
>     boundaries, so multi-SG and unaligned requests are routed to a
>     software fallback.
>   - DMA engine: linked-list descriptor (LLI) based, with a 20-entry
>     coherent descriptor table.

Hardware encryption drivers are being removed or at least tried to be
removed multipled times, so would be nice to see here WHY this one
should be added.

Best regards,
Krzysztof


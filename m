Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6717D3D0C07;
	Tue, 18 Aug 2026 18:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787079498; cv=none; b=u4KW9XIRa2pGwIdCfLtrEiu37TgDoe2SGG24FzftvQpQAsM2hPcafbEF0WeBKeLLoCIZDjRVfCYM8hku+VFWEosrRCtDB0V7PqSyUmvaobe4bzTibbYIEhZmr6YLbdG0hqji+h1D5eQzT9/VkTCszwMSxZWPi/D0f64MsL2Xw50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787079498; c=relaxed/simple;
	bh=ZlX+z9pUsHDoQD+A2WgqgdQ5xieqmIN1OC0HWPgG6sM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X8TYvhBDTRsyXUbJxP+SxQOWcULWss8A24YBXK7zv3Lt+YLZpz054CUIQMMsemxacR+FEqWTlcEltx9GUfIHCpdyIlS65egckqall7WykmYLrlLDHfMfr8vCwQGflBwswZIU4ifvXO+2ZZ0pSJKO3sCHFHQtBoCXlE0LCa9XX70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNPmA0KJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNPmA0KJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DEA1F000E9;
	Tue, 18 Aug 2026 18:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787079497;
	bh=O8Peqt8WT9DHzwVxnRsjnPx1R7Yii5C9/fDHVNMD5OM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mNPmA0KJ5e1sb3umUDgc+4IqrU1UL+fZSsNk/G13SaU+3hP6f8diRPka2DRXpOvyg
	 UAtxBPME1LgL9MdcbOoOTC0zSxLTS4eSYchw9gsstaNGFXloZKpmpzYdXaD4iKcUdg
	 EOb4DY9ciHXm4WoTE34miBDG5zk6GNTqep8vksMjBFkJLGG0bT7MQG9V03kjnGQ8X6
	 XWY0Xf996doD5tXFTMzVUVdq7yp5r6PkcytJmDpWDpVBVvkY+j5aR8//GTn4WyqVuK
	 A74iy3KISEgZrKulbuPPcuXiyPXddXs09m3ZItzFc2C+Vui8CXDInOSd/dnDDpmqRF
	 7/0Jx6V+FtLEQ==
Date: Tue, 18 Aug 2026 11:58:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Diederik de Haas <diederik@cknow-tech.com>
Cc: Dawid Olesinski <dawidro@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Corentin Labbe <clabbe@baylibre.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] crypto: rockchip: Add RK356x/RK3588 cryptographic
 offloader
Message-ID: <20260818185810.GA7030@quark>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <DKF8V3IHKTL2.1PUA8O5IVIRYC@cknow-tech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKF8V3IHKTL2.1PUA8O5IVIRYC@cknow-tech.com>

On Mon, Aug 03, 2026 at 12:42:03PM +0200, Diederik de Haas wrote:
> crypto-rk3566-test-no-crypto-module-log.txt:
> https://paste.sr.ht/~diederik/bb5dbfd59f244a6422b965b30f9796ebbfdb1fcb
> crypto-rk3566-test-with-crypto-module-log.txt:
> https://paste.sr.ht/~diederik/ea72297678e19cbbc987de9548f9884382e1d1cc
> crypto-rk3568-test-no-crypto-module-log.txt:
> https://paste.sr.ht/~diederik/309e519e6b1c31f4c1c5bcb1ea16cc8569a54830
> crypto-rk3568-test-with-crypto-module-log.txt:
> https://paste.sr.ht/~diederik/1e1e938ebbbae75128974fe0a7c240843bce04c8
> crypto-rk3588-test-no-crypto-module-log.txt:
> https://paste.sr.ht/~diederik/9a2adc2b2e42131445ce4576589e00ecf51ccb4b
> crypto-rk3588-test-with-crypto-module-log.txt:
> https://paste.sr.ht/~diederik/e04c11c8809031ca45662f7d4c227c1ba6162b65

Thanks for running some benchmarks!

Looking at your results for rk3566 for example, SHA-256 on 4096-byte
blocks is 115 cycles/operation for sha256-lib (i.e. ARMv8 CE) or 3027
cycles/operation for rk2-sha256.  So the Rockchip driver is 26 times
slower than simply using the existing well-tested CPU-based code.

Don't you love "accelerators" that make things 26 times slower?

I guess we'll get the usual argument that this driver is really just for
"testing" or whatever.

- Eric

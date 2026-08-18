Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D4337AA9A;
	Tue, 18 Aug 2026 20:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787085477; cv=none; b=FMMcN1REKoUR9ZsEu+3TJdE3pXCrEVRopZcIOFBzhxvCDBUPkBQ7/9DdAfN0AvZhlR6m0aG3waGX+VYgERsBab7/RtSGimsrmSGLTtCtpOEItnI4Yha97I65eKGcLWWLP5//i4RtaDCiqk0HEaIcDHPTiZKM2HnHeExI10UZBm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787085477; c=relaxed/simple;
	bh=mkSI/9W/d7bUsWNb/xai+iU+XQgKRAfDFFvJt5drREo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZyxLhlOX8P052qcfgBiX6C7KVPuv/UPXCMmbK7q5VZnR9CJUs1qMNA8o3tH1DK8zzmm+PT/4D85ThzZdyzKxVNLEvJZKdNHzRaXBzXgF4J819rgSoR5PtQBoaKK3YLNDOg6IwJXU2Jb+977UnPFKHVlOnzEro84DwD8hrf2jVWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kp3ftP8l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kp3ftP8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C311F000E9;
	Tue, 18 Aug 2026 20:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787085475;
	bh=vS+hrw7DR5QjvngIhGCIUMUP90zpgBBzUMr8U2SbJEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kp3ftP8lgwzzmR4XG4D3ofqWLPKNHPwk31tk6KCBZ4wcRAzJS9CoKTfizilk33tEN
	 rhX+GqTNYJSKYTogq47ReDOXZiQoiE555xBjVR3wW5XSD03NMgmXcUy625f933ceef
	 2xM+zufoxlvj1A3ZK3MSHgNx8W8AepObJOl424/vHbLr6YI2rpizHCUPf53RNJK3BI
	 etRxeEHEhi81pgkcv8lSzvDM4/v0wD4M6HEHtUsZG38z+OxkoVRwLBQQWPooKQJosT
	 gkV2by9tcrh4zz+wpXh10F3OlKKtBC7HmKfRlTpP4yGjPs8a1uAlVdq9mfI3Xy302C
	 D7zjY38D7YC7g==
Date: Tue, 18 Aug 2026 20:37:53 +0000
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
Message-ID: <20260818203753.GA3388792@google.com>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <DKF8V3IHKTL2.1PUA8O5IVIRYC@cknow-tech.com>
 <20260818185810.GA7030@quark>
 <DKSBIH29Z9DE.1OR442P0XUSCS@cknow-tech.com>
 <20260818200454.GA2718123@google.com>
 <DKSCMAUXS10I.2AB9KERO16FRG@cknow-tech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKSCMAUXS10I.2AB9KERO16FRG@cknow-tech.com>

On Tue, Aug 18, 2026 at 10:23:18PM +0200, Diederik de Haas wrote:
> On Tue Aug 18, 2026 at 10:04 PM CEST, Eric Biggers wrote:
> > tcrypt.c reports cycle counts from get_cycles(), which has an
> > architecture-dependent meaning.  On x86_64 it is something approximating
> > the CPU cycles (3-5 GHz) whereas on arm64 it is the ARM Generic Timer
> > which tends to be around 24 MHz or so, over 100 times slower than the
> > actual CPU.  So 9044 vs 115 "cycles" for x86_64 vs arm64 sounds about
> > expected, and they suggest the real times are likely similar but
> > slightly faster on x86_64 as expected.
> 
> Phew, thanks for the explanation :-)
> 
> > This sort of thing is why benchmarks usually should measure real time.
> > The legacy module tcrypt.c unfortunately uses get_cycles() instead.
> 
> What would be a better/non-legacy way to test crypto performance?
> Is that documented somewhere?

The KUnit tests in lib/crypto/tests/ have benchmarks in them.  They can
be run like any other KUnit tests, though you do need to set
CONFIG_CRYPTO_LIB_BENCHMARK=y to enable the benchmark test cases.  I'll
add some more information to libcrypto.rst about how to do this, but
besides the extra option it's no different from any other KUnit tests.

Anyway, that is just for the code that actually matters, not legacy
drivers like this one.  So you're right to have used tcrypt.c to try to
benchmark this legacy driver, as it is one of the ways to do so, just it
is a bit pointless since this type of driver is known to be very slow.

- Eric

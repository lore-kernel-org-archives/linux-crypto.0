Received: from mta1.migadu.com (out-136.mta1.migadu.com [95.215.58.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8205433C19E
	for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2026 20:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787084615; cv=none; b=EZG7GihJjH/4HsrGp6Cuo5anjO9m5+82q3xaNjAmxkg4MLcdcGucFpi8eEgrf5bIQbkgN7pTgaZPpIPUfoWUmiL9V4PsaJFSWMOy1D4vFfZ8G8BbebifeBa7V/03Bc8BusdaLCXvZp/Wa3j6jMJ1CCVGk7AqcffBxvki5HMChrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787084615; c=relaxed/simple;
	bh=AqJeH+5LKRNmRQzJ4ZHVSBjhlvotk7eHnatQlagjm3E=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=qijS+9cAaVyZ9zD8tSnpcdMzm/hXs19t6GUXJ0nBIHB9mGCvRlWF4LiZeKdJmU0Q1+DV257J/s9uHrSIIod4SY2V2fXjifqrWx/+5RsTg1TjfiYPP6leiBFYQ86RxU7UFdB7SHAXIS2UD83lJeEd2YP2bYmpZ3Vr/DrQHTQDzZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=EuV0Ut8m; arc=none smtp.client-ip=95.215.58.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="EuV0Ut8m"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AqJeH+5LKRNmRQzJ4ZHVSBjhlvotk7eHnatQlagjm3E=;
 c=simple/simple; d=cknow-tech.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787084609; v=1; x=1787689409;
 b=EuV0Ut8m3bx+Jytvwzqdg2h8IEQsQw453LdXkbQtrC3ORpOre07Tbei7lUgOTZi3qUtj+JsH
 fYOYY6vJhb8ocWkfupU9xrzbw38FuQ4QVsFVN5SKzhuQv4fvzlggrAK1iDo6Ki3inl5TDlsAsPr
 FsWizV7G/i8RuUEXHSVYaI17hehjI0H+qjZq2Ti9V1D5BHj6/NMsM0XkrD3tdiBASUL2494i4V2
 LAOlenuPwemcftck0H1udTkgnPxgDl7zpA6kc6TFyqBbnrEjAOiu4gjs6wn2g/zxHznh9X4cglb
 EAQ07jyqXAA93/F7oOkavbjtWiwqcIcYsxhsi4yl8E4+g==
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (92.254.112.55)
	by smtp.migadu.com with ESMTPS id 00a65aeb1c26adae;
	Tue, 18 Aug 2026 20:23:19 +0000
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Aug 2026 22:23:18 +0200
Message-Id: <DKSCMAUXS10I.2AB9KERO16FRG@cknow-tech.com>
Cc: "Dawid Olesinski" <dawidro@gmail.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 "Rob Herring" <robh@kernel.org>, "Krzysztof Kozlowski"
 <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Heiko
 Stuebner" <heiko@sntech.de>, "Corentin Labbe" <clabbe@baylibre.com>,
 <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>,
 <linux-rockchip@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] crypto: rockchip: Add RK356x/RK3588
 cryptographic offloader
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: "Eric Biggers" <ebiggers@kernel.org>, "Diederik de Haas"
 <diederik@cknow-tech.com>
X-Mailer: aerc 0.22.0-9-ge948bb7230f4
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <DKF8V3IHKTL2.1PUA8O5IVIRYC@cknow-tech.com> <20260818185810.GA7030@quark>
 <DKSBIH29Z9DE.1OR442P0XUSCS@cknow-tech.com>
 <20260818200454.GA2718123@google.com>
In-Reply-To: <20260818200454.GA2718123@google.com>

On Tue Aug 18, 2026 at 10:04 PM CEST, Eric Biggers wrote:
> tcrypt.c reports cycle counts from get_cycles(), which has an
> architecture-dependent meaning.  On x86_64 it is something approximating
> the CPU cycles (3-5 GHz) whereas on arm64 it is the ARM Generic Timer
> which tends to be around 24 MHz or so, over 100 times slower than the
> actual CPU.  So 9044 vs 115 "cycles" for x86_64 vs arm64 sounds about
> expected, and they suggest the real times are likely similar but
> slightly faster on x86_64 as expected.

Phew, thanks for the explanation :-)

> This sort of thing is why benchmarks usually should measure real time.
> The legacy module tcrypt.c unfortunately uses get_cycles() instead.

What would be a better/non-legacy way to test crypto performance?
Is that documented somewhere?

Cheers,
  Diederik

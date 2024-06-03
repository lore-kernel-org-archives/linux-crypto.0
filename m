Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32692E57B;
	Mon,  3 Jun 2024 13:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717420513; cv=none; b=k6ip6MW9bRkEVinZ3cmTYn0ToH0BM8HZx0XnRyKZhBxtz5vrlH9xGBEwgh6siBxWM0BgQf2W2FXXtf06NLTiNpe7j0HcKqTG/y2a5RwgIayCdiyrKC/LvWjS5HB0QOTXnIpKMOP0ABAtZ6elf8DbQA9AQP9auZDROtQ0A8XkkP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717420513; c=relaxed/simple;
	bh=DpiA1zvswJuCrGoJ7xJp9YJ3ZvV9Anvqhk6oAcantTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o60tycpheBLF1+0Fw+aNsO0fo2VMIkfiny10xWRUVIIOCG3f5q/zaOfW/kBbTx/b0PKxk7jwE/6QJECGZK94I8WuvfU/JtA0LoyOjrsmM1jS1rtyWNZn4CtrkytbbbkTQA5MwBpwAA/LPpVj5zPJBbXBDhwtvaMU2e6GGhHPIXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPLYDLBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPLYDLBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411C6C2BD10;
	Mon,  3 Jun 2024 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717420512;
	bh=DpiA1zvswJuCrGoJ7xJp9YJ3ZvV9Anvqhk6oAcantTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZPLYDLBAlZtETDFyeQVh9r88GG5nNhT0ZnpN7zW00pwTDb2HoiSPIf08CBfJa+viz
	 LmTxc8DsyH09iYkbS2CdhhtvxU6+zqdEMpsg/vHeD7Vt7aL3PMy0Uwdl3Jj2+LKGJl
	 woalZjzM7PAeBRH62t7yN3zfEk1YT1ya54BlUBgbjFjmPSQRYd7IoKnrAJXlTFfGln
	 esG77yPUAInsv/UoHnvHkR3+L4OL86Ky62CrEYneAPXhpH8y3M5W0YloZKsT9x6r48
	 jJHNmMDxAKmYvJihZZupLQZ45xWLcrkiGzCqrwpeyxlZ0nxBYPobf0DVPJXGA1+Spv
	 XLlBDBReZG/Hw==
Date: Mon, 3 Jun 2024 14:15:08 +0100
From: Will Deacon <will@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64/crypto: Raise priority of NEON crct10dif
 implementation
Message-ID: <20240603131507.GD18991@willie-the-truck>
References: <20240521-arm64-crct10dif-neon-prio-v1-1-e2975754b8f3@kernel.org>
 <e103fabb-6854-4ce1-b4f9-6f6b7f912895@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e103fabb-6854-4ce1-b4f9-6f6b7f912895@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 22, 2024 at 12:17:41PM +0100, Mark Brown wrote:
> On Tue, May 21, 2024 at 09:22:49PM +0100, Mark Brown wrote:
> > The NEON implementation of crctd10dif is registered with a priority of 100
> > which is identical to that used by the generic C implementation. Raise the
> > priority to 150, half way between the PMULL based implementation and the
> > NEON one, so that it will be preferred over the generic implementation.
> 
> That second NEON should be PMULL, sorry.

Sorry, I don't grok that now:

  | half way between the PMULL based implementation and the PMULL one

doesn't mean anything?

Will

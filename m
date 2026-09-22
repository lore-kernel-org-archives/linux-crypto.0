Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD65952941C;
	Tue, 22 Sep 2026 09:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068243; cv=none; b=RIGN8G/usTGESh4JPOumfHaZxZyvxEjKNKJGeYIliUtPvT53AOkxv6NwGUpGuMwb8tHGkvWU+oi77/3kRwzTIOvSXPc9eSiCvOgKnT2D1z7PaW1W5+s404gLWXaSRSaI5DS9iV9BdkVM0kl9Kq5OAdAKys3Wmn4y1wGoi+apqvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068243; c=relaxed/simple;
	bh=HgNPZpTKClc/Bo/qq9vfCxCccTNYewVv7YgeFQs+kt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKtFokPkpzfPUXHwaarboWrWgNuDG+9T3tuecwT7uUDKyiW1SEA2fYrpqWY6M49XzYCpluhx/aF/BuqKGwMq43pAPeRxEaSn6qHWGduAz7JpmX3Z5Rfax2olEDDBdDifu/IQ5zWKKTxLfy+EmGsxJo3xuGc2FVThEiyvSRfYY5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ier3rHDD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ier3rHDD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lTIWqkgW/6XrBcOyuAOlGNAiOa8BHpB9D8z7LSFGgBo=; 
	b=ier3rHDDJlJUQBz3c36Be5kf/981YOqlS3a2HBR4Mp6UH1nMuGB2PFUdV3PGqD6e7HCLBnu2GD/
	F051EddPgPc6AyP4Tp0cEY1Z6zykTt0A0lP5iQgdb2iCgbnGs45VP/JDYxSqjt38cKa3T32wRacZW
	/EschcBGB86E7L18quk5VXK0DNInRu4MmpsDeUAaiWnXmvBECDTKyYjqt5dTgZlQDJ3iNJCsdaWY4
	W3zBNPH1EkjeUdABpC+lSIQ2V9MCFH8pinyd4Kypw6TGx7j/2X2WX0QL41f84XXTb8DwvtbgqlDuw
	Yd26yyqd5pUmgQkn3Jqh1YmpRt4fPsFUHuXw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x8wWA-0000000Ga8S-1wID;
	Tue, 22 Sep 2026 17:10:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Sep 2026 19:10:26 +1000
Date: Tue, 22 Sep 2026 19:10:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	stable@vger.kernel.org, Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Abel Vesa <abelvesa@kernel.org>
Subject: Re: [PATCH v8 00/14] crypto: qce - Fix crypto self-test failures
Message-ID: <arJGAjRRC-5EPjH6@gondor.apana.org.au>
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
 <CAMRc=MdWZhLy7AXd2OiVsaT92xTh1EF+B+LNo2b-1D2TO3rAmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MdWZhLy7AXd2OiVsaT92xTh1EF+B+LNo2b-1D2TO3rAmA@mail.gmail.com>

On Tue, Sep 22, 2026 at 01:22:31AM -0700, Bartosz Golaszewski wrote:
>
> Herbert: Sashiko still says it fails to apply. I have no idea why, it applies
> fine on top of current linux-next.

The first patch doesn't apply for me either using git apply.  Please
download the latest cryptodev-2.6 (a9a2152d292fd0bc73814eb4a127278ee7dd3f6a)
and rebase.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

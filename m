Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D00421257;
	Fri,  2 Oct 2026 08:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929473; cv=none; b=WcJN7+m4cqFkYwCz6B+5TLW++aR0T2NBh5ruoVBLjJTCkXqTDP+O71XkTjbsHu/nCcvx/sGr/N3MOhYEYMLTymh/cp00yH0XYJfDXbRVYwCrzv9x0ys+x9JkhXCro85va1Yw+GIpalrtKO42V1lWPmtc4eUid8eTfyMQ+KisJTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929473; c=relaxed/simple;
	bh=pY481j7VqhY4jlVePy5UJsgbm9XJGRO4KST2UPrSd5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UqemDXM5kwvLXZtgljqKfsmjYZPaYynmWrn3gwKVgKl9uJ/1H7rQ/lbYGtcYLu0tOX+/pD7RUQE1XMKAyyn7uHsNGp6ftZS21j/RRcivJSn3EVgz9ZKBGZ/NTp4r/RfhQclEP+7AuC1oC+TsHI56wQak7zsJVwyYi9MnaQtlenQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LZbdrwOJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LZbdrwOJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dDYAyKpyE1u9tXd1NgeesAd5uKLQ18jJ7ka9XYxEvJc=; 
	b=LZbdrwOJL5TkDIVbq8kSrEAMiYfT4Ww/G4pCXD7WiOcwz6PkAbu8xisaqqDMPEiUc0ILq1qEwJV
	ZI0WlYh1gdZbS9whxb3plCdPkbYSWYtZA3c+9IG4EUGdKxmDGQMy18d1lC5Vl7NX54tHaf/RprsWU
	qNQxbB9XSb9Yi7Q/ZnQEtKhdIUisSmrKQhf7i/Cb0bcvYHHCTOV2j5f+ocR9m9YmcP0pu44HhtZvn
	gUAzy3opB+aeVDulac+CjWBt9znvJvASDDli+7SUw9EVdSF0OKiHB/65cEujhIwxeD9v3oQvwXq4Q
	0BD8sMXNGwZKPTrjqr3bBgGF7dDMpOFoU6wQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYZ4-00000002mhJ-0iWJ;
	Fri, 02 Oct 2026 16:24:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:24:22 +1000
Date: Fri, 2 Oct 2026 18:24:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	brgl@kernel.org, linux-arm-kernel@lists.infradead.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v9 00/14] crypto: qce - Fix crypto self-test failures
Message-ID: <ar9qNirrzOTDLipN@gondor.apana.org.au>
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>

On Tue, Sep 22, 2026 at 02:57:15PM +0200, Bartosz Golaszewski wrote:
> This iteration - in addition to the previous fixes - proposes to split
> the QCE driver into a core part necessary to bind to the QCE DT node and
> enable runtime power management in order to allow to drop the
> interconnect votes, and the crypto part registering the crypto
> algorithms. The core module is then enabled in arm64 defconfig while the
> crypto part stays disabled by default. In addition: the actual
> registration of crypto algos is gated with a module parameter that
> default to false.

Please check the Sashiko comments:

https://sashiko.dev/#/patchset/20260922-qce-fix-self-tests-v9-0-b1aa742e79af%40oss.qualcomm.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

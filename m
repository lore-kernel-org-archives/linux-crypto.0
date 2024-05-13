Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2885E42A86
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 03:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715571157; cv=none; b=C/9OlZWUm/8sR+A25c4kE4ZYpKNwjg2ou6akwsKhJ58QtrO2Xha2N0dLjaLCgKkysatYaLTyD1Dc+TTH/EWElG7rUA3UtdeWOnICLcYV4hvTHBsMM4ZuDg8rKN273Q2YWpx5rDGEfgEAd1NGoJ/8ico9p008n/qMKOMsk29ke8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715571157; c=relaxed/simple;
	bh=KZbc8s26uW/IjfLiPpi3eKlYY+rNChUbHh0jPK8CLjc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=RVh8PiOTpE1aSdrESbTZTLIDYzxsReZskhtsdyevmT8JyBCjhuKp9wA/3T5i+t6hAd3PgiesGwuDySqEUv1JPeDP5YxMbRUiJ2pBVSGWRXHnPQ67sEzk+A0tx2fa+Bdg99bW3U68NusULOVRmHqr2nhUjJrKUMsLv1mdvr6Mzys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZHCjl4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZHCjl4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A175C116B1;
	Mon, 13 May 2024 03:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715571156;
	bh=KZbc8s26uW/IjfLiPpi3eKlYY+rNChUbHh0jPK8CLjc=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=JZHCjl4Lklx9y5aawT71eggYdoMw085cL0pXmmiyMDBQPUz0p6cCjMNIpQbiewSrv
	 382NIGs+I2dl+V80aP3HulgoR+IUJVqlsnZuL6t8CUQ1kBc2DHCWLNHZbKJNjmi6M0
	 ofBY7g5amEN+ai3Kbr0oKZ8HmiSBlGsdxfsUgmD60ddZY7ozvVqdrSMU4Jg28mqSS5
	 ERlYtRX3peSQUsMuzC9DeFLJNuX3kE7/bktzqyrcRaNCPM15z/20GiTp/ednkgox/L
	 RonqkuN96rnFO64Amah6P/Lhk8JCfLGZ5SjPBnYF7Af35d0D9xm69hZ/7ouw2TjPnp
	 y61yXZrEePiYA==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 May 2024 06:32:33 +0300
Message-Id: <D1877VQTZCSH.34HXR84JU5JK1@kernel.org>
Cc: <linux-crypto@vger.kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David Howells" <dhowells@redhat.com>, "Simo
 Sorce" <simo@redhat.com>, "Stephan Mueller" <smueller@chronox.de>
Subject: Re: [PATCH v4 1/2] certs: Move RSA self-test data to separate file
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Joachim Vandersmissen"
 <git@jvdsn.com>
X-Mailer: aerc 0.17.0
References: <20240511062354.190688-1-git@jvdsn.com>
 <D181O1G1V18T.1SFRUIEFUPCQI@kernel.org>
 <70b6dbf0-eb54-4e23-a295-6f7f0d02a23c@jvdsn.com>
 <D184NU1V1GK5.38B7O2NKVESUE@kernel.org>
 <29254c3b-7d99-4c60-9652-671921367a96@jvdsn.com>
 <D1873QS946LC.ZULHW8WB5IQP@kernel.org>
In-Reply-To: <D1873QS946LC.ZULHW8WB5IQP@kernel.org>

On Mon May 13, 2024 at 6:27 AM EEST, Jarkko Sakkinen wrote:
> On Mon May 13, 2024 at 4:43 AM EEST, Joachim Vandersmissen wrote:
> > I think this is part of a patch set, is it not? There should be a 2/2=
=20
> > patch ("Add ECDSA signature verification self-test"), you should be on=
=20
> > CC for that one too.
>
> OK found it! Yep, pretty much similar remarks (like putting change log
> to diffstat).
>
> Also it is best to have full change log instead of the entry just for
> the latest version. So at least the current v4 entry and then v5...

I'll try to get this still picked to 6.10 i.e. if we can put this
during first half of this week, then it should make it.

I'm also working asymmetric keys patch set [1] but that is likely
to be postponed to 6.11.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/=
log/?h=3Dtpm2_key

BR, Jarkko

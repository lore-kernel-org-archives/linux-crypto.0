Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A7D145A11
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 03:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715570833; cv=none; b=Fi1hN5G2Gg4EN03qj/pTHPHEDRkLvitx+xQsK/HW+dLi3tZnf0P5pz0NhKTnAKQnztzfVAWqgzUtWODKlBl13Bet/B9mqhUOfArv4aGE2+KOleCN0FEOEQDGtsX9eh06GrkSwbs8WPKGhVtWlhMXt1oz+c/1N4CQ10SVxAxTfXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715570833; c=relaxed/simple;
	bh=u374i+iAZkX921I0/CkdgEiAJhdKI8XIGbTIxpn5VEI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=nkUZiHfXib2e2meOjKIwL9O8PLvIxEfKJcS70cKPnZfQQYd4xv8W7Lc3bWrcKpTgvYbiuc/DlEPMnpYiq4c7scvwApNCmLLNwe2fSPI4tIEIEph0fhOkV9+BPUZKLno9MjdcKOMN4/8B44idZ4ETUFxECXqpRjION1wCNMLjc14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AkC0j/XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AkC0j/XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178E4C116B1;
	Mon, 13 May 2024 03:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715570832;
	bh=u374i+iAZkX921I0/CkdgEiAJhdKI8XIGbTIxpn5VEI=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=AkC0j/XULcb5P4Io2e2DGv3kTeN1INwCoZBz+f8ahh9Cz1THcTkPrM+8XUyLbnODN
	 eJFmHnydXGLaFkG7RsBnhRDPva8TfBwxOVZuVkn8vcS3Pt/ZVDRn/2KihqY4o53zOu
	 5PtPQ06bowc9jGjZ/UlfmH/Yv2lvTFD+uqbUJuHMj5EY9/1YhQ4xjk3sT2WzQvDDD4
	 snuogNO+zE9MevaG+qqwgRUfUozQ/5gvi0uOwjAGL3lXyADDHJCVBdeaMItiJ8PXkP
	 VeWxe/rAY4EDHxUOqIMUMejtiR6Fda+v312FB5/Fm30aJzj/Ms7shz0/ojKMVweoHA
	 VXqaeKeH8DJxw==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 May 2024 06:27:09 +0300
Message-Id: <D1873QS946LC.ZULHW8WB5IQP@kernel.org>
Cc: <linux-crypto@vger.kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David Howells" <dhowells@redhat.com>, "Simo
 Sorce" <simo@redhat.com>, "Stephan Mueller" <smueller@chronox.de>
Subject: Re: [PATCH v4 1/2] certs: Move RSA self-test data to separate file
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Joachim Vandersmissen" <git@jvdsn.com>
X-Mailer: aerc 0.17.0
References: <20240511062354.190688-1-git@jvdsn.com>
 <D181O1G1V18T.1SFRUIEFUPCQI@kernel.org>
 <70b6dbf0-eb54-4e23-a295-6f7f0d02a23c@jvdsn.com>
 <D184NU1V1GK5.38B7O2NKVESUE@kernel.org>
 <29254c3b-7d99-4c60-9652-671921367a96@jvdsn.com>
In-Reply-To: <29254c3b-7d99-4c60-9652-671921367a96@jvdsn.com>

On Mon May 13, 2024 at 4:43 AM EEST, Joachim Vandersmissen wrote:
> I think this is part of a patch set, is it not? There should be a 2/2=20
> patch ("Add ECDSA signature verification self-test"), you should be on=20
> CC for that one too.

OK found it! Yep, pretty much similar remarks (like putting change log
to diffstat).

Also it is best to have full change log instead of the entry just for
the latest version. So at least the current v4 entry and then v5...


BR, Jarkko

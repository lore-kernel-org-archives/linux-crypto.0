Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B63328F5
	for <linux-crypto@vger.kernel.org>; Sun, 12 May 2024 23:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715555496; cv=none; b=nC0GEHLwNYmy94FYgj7Ge9csTFsSB21cx71lDW2xv/cVpwRRyAwMlmqRRUgTSHjXw+qaNYqPuxTftpr1c3OR3rRx2w/rvDOKWXLCxQSzyBQJn6XeIY9v9qmmBEBsIHrtSFNrtXFiMjF//bpfTiPI2Aw4e08DpGqtrJxgFvqj/5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715555496; c=relaxed/simple;
	bh=8hDUzU59EB8LBYkJxfcPeaVkEUm6AOGlOhdRDq5NBeM=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=ItPR0b65Xmze28kmkdweUoWb+/okV6PaL6ppqx/gOWHNi1N9vI+138ZY3EkTHnpm8LqtZo2pNn8djN4VtYwEPJfrbWh2Ra5Rmk8Te6dG0mxVSJqwlNTLjp9p0AMSCiS1BSfX9293WdX5Y8IHMZBzUjPJHZp1xfd8CpB3goRuuIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8NFap8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8NFap8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD329C116B1;
	Sun, 12 May 2024 23:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715555496;
	bh=8hDUzU59EB8LBYkJxfcPeaVkEUm6AOGlOhdRDq5NBeM=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=Z8NFap8ECVO52mD9SgDF3fIUKS0DnVRPSk4jncyP+Ul9xWai0Dm+5SN4uunxu/CzJ
	 NHGElEqxgkqxzCnTvDi59+/dzVUtTMVDtuNFDLCZpt9kODYb6NfyO5SinCYE1An02Y
	 n5Lq+RNkjmn9ipHbsI5n83QsrV9ZCuoednR7+27R3O2qFKzD6/2QnmuKQLD1jWpQm7
	 gWnFKXzIV1V8TaV0WxS7t5YMlhuq9jzkZgTqJ0smTGCaKMehPD4pMvMR0Xplrz2Y65
	 sEzKBc1L7ObVN65gYz9wo3WDutjbFf6Rthp4RBlPsWK0TcgepPDu7GoiIS15bgOo10
	 9h+C76wDu5Kzg==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 May 2024 02:11:33 +0300
Message-Id: <D181O1G1V18T.1SFRUIEFUPCQI@kernel.org>
To: "Joachim Vandersmissen" <git@jvdsn.com>, <linux-crypto@vger.kernel.org>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: "David Howells" <dhowells@redhat.com>, "Simo Sorce" <simo@redhat.com>,
 "Stephan Mueller" <smueller@chronox.de>
Subject: Re: [PATCH v4 1/2] certs: Move RSA self-test data to separate file
From: "Jarkko Sakkinen" <jarkko@kernel.org>
X-Mailer: aerc 0.17.0
References: <20240511062354.190688-1-git@jvdsn.com>
In-Reply-To: <20240511062354.190688-1-git@jvdsn.com>

On Sat May 11, 2024 at 9:23 AM EEST, Joachim Vandersmissen wrote:
> v4: FIPS_SIGNATURE_SELFTEST_RSA is no longer user-configurable and will
> be set when the dependencies are fulfilled.
>
> ---8<---

This is in wrong place. If the patch is applied it will be included to
the kernel git log. Please put your log before diffstat.

> In preparation of adding new ECDSA self-tests, the existing data is
> moved to a separate file. A new configuration option is added to
> control the compilation of the separate file. This configuration option
> also enforces dependencies that were missing from the existing
> CONFIG_FIPS_SIGNATURE_SELFTEST option.

1. Please just call the thing by its name instead of building tension
   with "the new configuration option".
2. Lacks the motivation of adding a new configuration option.

> The old fips_signature_selftest is no longer an init function, but now
> a helper function called from fips_signature_selftest_rsa.

This is confusing, please remove.

So why just send this and not this plus the selftest? Feels incomplete
to me.

BR, Jarkko

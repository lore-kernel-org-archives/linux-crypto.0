Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE444519B9;
	Sat,  3 Oct 2026 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791044347; cv=none; b=QvQ8qBDDruBHpypLHraZ+evcYD6vMqor4FuHN1ndSwSOPECmwkzoOGH32pnTbQcbfv8aX+FUmmafSiYpVLVqF6YGsX/7g2O0+2FSLZOT8sXH/sGBhdqPCgSvBButXmvODfDVln05Mo+8UgzQVzbGPg4Y7Fa2KkeVvEN2McqmJLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791044347; c=relaxed/simple;
	bh=5FSRtkKceZUj12fybG6Diw0dSoK9VMn/+RLvZWLZo+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NR4UIB5lTW5Gij4J1VW2SpqaizpCqHrojVH+zESSueNJspCNyjCX8GwkwMfEZs0vCXuU4KwZ1B8bf5QbnzDHrOuMQSrYrN9Nk8OzaAxtIESrfwLQTZGYXHqku4fa4VPmoipoEe6ebGonU/2KlNeQTo+Ffbn5BmjcD7IVbCho7II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hublZXby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hublZXby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6D41F0089B;
	Sat,  3 Oct 2026 16:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791044345;
	bh=Xo2wV/W+X2DnccKKvAsAuav2HhrRKEVacpQcpS3C6qI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hublZXby2Tx/tRq6e4TkQGIZZjGideq/Jqb32OF13A87uYR+ui4ckuY5sWj6jJb5X
	 dDrliG93z+iCf3JKitpLV9dthFV4gPWoBECwnvHcRkQPehQvfozpxgNl/G7QohHv+c
	 ZcPxuOuwhMKe5bMryyJPPK3z17zSc5Uc6I6ots3FWm0Z+n6ZRPJWqyc+n4GzpBMXSX
	 iZ4IdEebn93bkjvk6X1w+ZqjdHvPAYO4nra1NO23o99ULy7E1OXllIFWQB4KfAtqJf
	 0+IUihNmwwKhZbJ7VskHJ3aMdAbDNE4UhP4mUILBL7uM23pul4GAd0o927vaMSpbZj
	 kF6BVFmweFNGQ==
Date: Sat, 3 Oct 2026 18:18:59 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: "Justin M. Forbes" <jforbes@fedoraproject.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow hmac(sha512) for unpriviledged users
Message-ID: <20261003161859.GA152469@quark>
References: <20261003160302.3000325-1-jforbes@fedoraproject.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003160302.3000325-1-jforbes@fedoraproject.org>

On Sat, Oct 03, 2026 at 10:03:02AM -0600, Justin M. Forbes wrote:
> By default users cannot run sha512hmac with the current set up. This
> is problematic because our kernel builds call this for FIPS compliance.
> Rather than have anyone turn off af_alg_restrict all together, let's
> allow a common use case.
> 
> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>

The fips hook in dracut was taken into account already, and it runs as
root.  So this patch shouldn't be needed.  Can you clarify why you think
it is needed?

- Eric

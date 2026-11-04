Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785910;
	b=TcciEYRpU8M1XoqPnqHg0mMn8hqX41d1KT6Xg7R/b7561Ze8MVbxTENP58xnQKxH39yb
	 3/AmXpqT944VjiLcoHUK0ikyeFsPpnJGqBGRmlqwhDJayjhExwJmJCZQy30ZhmSPdQcXZ
	 6VpDGbT3UtnfqtTp5FS6fyJ+0uNeMhHwkeMjE3sJ5RMq2wDSlrsbN1nd3u4AQkBhVeaI4
	 +GLpTpkY9cJQ3Uxqv/uInlfXKjcbAX2sAc2mSt9TRIycJPmASnE4OxZivKNZnTq4ysRll
	 63Z+MDckcHfy8hBp2lS83SEmkb5EJPn5H+XdO+rJ25Mv04PBTZDdrQgn1HZA8CUGZ6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785910;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Gfxg1lta6Xccxui9ZGERoA+N5fEAbqN1z+ZUbR4yIS4=;
	b=GR7sR6OKM/ZNnNcExV1pXIb+07twOveHZxaCk/1oLNky9DWMkmkC1IzE2sZupJDv+sBY
	 gV5g9L1WAOs0jx4tcwM48qtpKmKlFRhIm5utVIW2RNNVp1DXgtRBdBpPaDB9oFWIiIqmi
	 Fo3xN9r2Pl2V71sGAl3IciLNX9sMGzj8gqAUEPiVjYM55cw1wKsD27GlRTMQlixFsTd0P
	 R4Bf1X9+YxpRwfNOBzpKe9z7ycUOdIZjYUItPQetQrd7HN9HBMsaJbj15A87cUyUZfKPr
	 12sO9uX22g7Ipvx5x1sv3EGt0rXiFAoRhvm8BLjT6/q80OjoYjY0ZfOlmHYcfiyfjDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="c/xHrbcM";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE0E606A335
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 09:51:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCE0E606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=c/xHrbcM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Gfxg1lta6Xccxui9ZGERoA+N5fEAbqN1z+ZUbR4yIS4=; 
	b=c/xHrbcMWKshIuGLvu7ujHECIvV+dyFfUc/3H2eOKN5a9mcjdcbzUU4TuMJqq20oGIBQDGmqOaM
	0F6IAqQhltn8tXBvRdQvm8uBbhKTNH+j1YSt8cqfZk5tCywSMbeeVAbEe2Rla6oOIPXMRPh5kh9r3
	lapS7dfgJ/XHvb68nbTFCoRHCLj0Ao9ceyOlJnyuTz+HRvwXTQrLhIjirn+/orT3GtjgoUe3F1F7w
	9UV+oofPyFwA2dANkCxtzkphVmTcL1RK91wR5bE8zaFUPnlLSYvHolZuvCm1JLFGvXyPIqEeyD8x1
	hDyLun0DkIfGIQEyEQv/cMozJ8F49aPsrVlQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOXej-0000000AoU5-0IZe;
	Wed, 04 Nov 2026 17:51:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 17:51:45 +0800
Date: Wed, 4 Nov 2026 17:51:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael Roth <michael.roth@amd.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	ackerleytng@google.com, thomas.lendacky@amd.com,
	ashish.kalra@amd.com, aik@amd.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v3 1/1] crypto: ccp - Make usage of sev_cmd_mutex more
 granular
Message-ID: <ausAMSsOUJ1T9Kvd@gondor.apana.org.au>
References: <20261021192434.1924950-1-michael.roth@amd.com>
 <20261021192434.1924950-2-michael.roth@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021192434.1924950-2-michael.roth@amd.com>

On Wed, Oct 21, 2026 at 02:15:17PM -0500, Michael Roth wrote:
> The current code makes very coarse usage of the sev_cmd_mutex; for SEV
> firmware ioctls, it is essentially taken upon entry, and ends up
> wrapping a lot of potentially time-consuming prep work that may need to
> be done before issuing the actual firmware call, which is the main thing
> the mutex is meant to protect.
> 
> Additionally, some of that prep work involves
> copy_from_user()/copy_to_user() calls which can generate page faults and
> unecessarily lead to potential deadlock scenarios. No known case exists
> in current upstream, but with the upcoming KVM/guest_memfd support for
> in-place conversion of the same PFN between shared/private state, a
> special fault handler is needed that could theoretically deadlock if a
> malicious user tries to use guest_memfd pages as the source/target of
> previously mentioned copy_from_user()/copy_to_user() scenarios.
> 
> There's no reason to hold the mutex across these problematic scenarios
> however. Push sev_cmd_mutex down from the top-level sev_ioctl() into
> each individual command handler, acquiring the mutex mainly around the
> platform state transitions and firmware command execution.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 101 ++++++++++++++++++++++++++---------
>  1 file changed, 76 insertions(+), 25 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

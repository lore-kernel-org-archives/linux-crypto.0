Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C1C19E7E2;
	Tue, 23 Sep 2025 15:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758640687; cv=none; b=SOukPkYlAt+2HXBFy7U8XYagRGisBVNyubEvb4qyHPc5QozUpjP/H/gCNusW4lVL404j6pCzCpywZXQ6QeMtteZ1iStXpFGKt8iPI11nN9coi8fhSvJmMm45jqN7B0Oxd1T+T0uP1LWGLKAueXSezrpjFZ4f+WF4hBWzl3P85hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758640687; c=relaxed/simple;
	bh=jOkIG82JE6eFQhmRsua5S/Xf1YfnCGQR0GsifuejOnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/c+IlRDbW4EmrMuAlK9D+S1KV8kFeaFBW7QbDYhwWlJcre6++/cCJnkzGgS/fHlf/7YbNCd10fefnNNxHm8j7Re01O1oBT2dbws+D3MRDeibYlr7lnErhPxbc0ySthUW61pUlXuvgW6jCljErJZoHOk6HvSZfkbda6eTpEzEm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ncmZ57hD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ncmZ57hD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=aluICmYv/poF/jPuEzyapMuOw+2Sj8QbpIF36kad7y0=; b=ncmZ57hDil3AiDjZsshpgILsab
	7nC3K0X0Dm1yJ07hntdByvtlHHwjWj+8Ml93bsryJWoZo+2jBp0AZ5fO6idcf8dHj0ZoeSobYEdQK
	rsIuHgXHH8JV2sWBrla/UvNzA3K7WfVcOOS+RZha06cgyjXhj7NH9RtNKWFsUCp5i3cCtOi0o9mL7
	v+FOtgYNAyM/ZNzdM/PuB07ZI6L/8c/2BwxQ2RhCKa7oKu3jYvAuECvuleRhrLh94xdC3KBdyLtJj
	0yAq6FQoz8vpIjMKFfwQr4WeabEsAPuYAXmSoXexlXGu638tud31DwCUeEFooxSFrzJ8iLAJWNkMc
	ERhPG1YA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v14m8-007ict-1z;
	Tue, 23 Sep 2025 23:17:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 23 Sep 2025 23:17:52 +0800
Date: Tue, 23 Sep 2025 23:17:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>, linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	agk@redhat.com, snitzer@kernel.org,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto/authenc: don't return -EBUSY when enqueuing the
 hash request
Message-ID: <aNK6IMzUgslPVi3x@gondor.apana.org.au>
References: <20250908131642.385445532@debian4.vm>
 <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
 <f799d7ab97470f2529b8dcb5566fd673@linux.ibm.com>
 <e26aedc6-7132-46c3-78f3-a3582b1c4f9a@redhat.com>
 <aNIYTm6neC3lC6dP@gondor.apana.org.au>
 <194f9d1e-b6b0-54c7-6eb8-37ac0c0c1f9d@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194f9d1e-b6b0-54c7-6eb8-37ac0c0c1f9d@redhat.com>

On Tue, Sep 23, 2025 at 01:14:10PM +0200, Mikulas Patocka wrote:
>
> static void authenc_request_complete(struct aead_request *req, int err)
> {
>         if (err != -EINPROGRESS)
>                 aead_request_complete(req, err);
> }

Oh OK.  That was kind of a hack which worked because authenc was
used by IPsec only, so it didn't expect to be called with MAY_BACKLOG.

Now that you're calling it with MAY_BACKLOG, we need to fix it to
distinguish between an EINPROGRESS notification for EBUSY and one
that's returned directly by an async function.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

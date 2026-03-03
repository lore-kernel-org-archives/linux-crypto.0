Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512E839023D
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772578091; cv=none; b=UrG68H+ZowYeSTvVbkSGla/jfCxCw5fhdoDM5uVJEZCGKyLWgOb6VmlHvvFxv9ifEfx4DAkMikBiQOc8uqcO+8jEf2+2Fhqj7zJM+g4vMbLerklCQZxluCGZAXFO3mglgkeTkBI9IRVoFOrT3RotQ7QOBEXYsYXA4XDqVxl2SMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772578091; c=relaxed/simple;
	bh=bAO7IfWfh2uzgt7mKu6T4wlPWgjOnj3fUEWEPayVzSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MwNmMoyVVljJ4DL3+WXa+ioluumkP/EIJPYq4GifuKg6WfaLLCN1ftlj3Ozum8r+5yGMUNK4vyttSIjL5Yq5Ratm2xN50ZN6/oYyX2goR6NX58K/mSurt9c12gne4FOCoN/OsWNoYFViXHrTtniigpNuBQ4pC9LxCzPzdghAMIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D+wOig4v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D+wOig4v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772578089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pl2zG4pI79B5FV4b1qWY7o+8Dm13AOeYPsXsZmBVTMc=;
	b=D+wOig4vX83Sf7IO8F+euQVNmmKWDcqmu9phBb4GV1VWCOKfNwFfOC3Dc0+gaX70Ahtrpb
	QwQII1B4p/x/E89mtvSso1qB6JRWORJSUZjRR7tjMOckZMRhifVIqVatZERyos58vbWpY0
	1n+t9/zkfwXBm7RNf84eGqjkF6RS/fA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-RgNbitvyOf-TNuzEwPefWA-1; Tue,
 03 Mar 2026 17:48:04 -0500
X-MC-Unique: RgNbitvyOf-TNuzEwPefWA-1
X-Mimecast-MFC-AGG-ID: RgNbitvyOf-TNuzEwPefWA_1772578082
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48965180034D;
	Tue,  3 Mar 2026 22:48:01 +0000 (UTC)
Received: from my-developer-toolbox-latest (unknown [10.2.16.250])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 9194718005A7;
	Tue,  3 Mar 2026 22:47:57 +0000 (UTC)
Date: Tue, 3 Mar 2026 14:47:56 -0800
From: Chris Leech <cleech@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org, 
	Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 04/21] nvme-auth: common: add KUnit tests for TLS key
 derivation
Message-ID: <20260303-slush-hydrated-8b1929ec6a30@redhat.com>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260302075959.338638-5-ebiggers@kernel.org>
 <1de7ef59-4236-4372-81f6-60d5a4f1e253@suse.de>
 <20260303002649.GE20209@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303002649.GE20209@quark>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Mar 02, 2026 at 04:26:49PM -0800, Eric Biggers wrote:
> On Mon, Mar 02, 2026 at 11:04:43AM +0100, Hannes Reinecke wrote:
> > Which discrepancies do you see between the specified algorithm
> > and the implementation?
> 
> I'm looking at the latest NVM Express Base Specification, v2.3.
> 
> First, there's the following:
> 
>     The host computes KS as the hash of the ephemeral DH key resulting
>     from the combination of the random value y selected by the host with
>     the DH exponential (i.e., gx mod p) received from the controller
>     (i.e., KS = H((gx mod p)y mod p) = H(gxy mod p)).
> 
> The actual code skips that step when deriving the PSK, and just
> considers the DH value directly to be "KS" and uses it directly as an
> HMAC key.  That is something that should never be done.  DH values are
> not uniformly distributed and must not be used directly as keys.

I'm doing some testing with a patch to immediatly hash the DH value
after the kpp request is complete, fixing nvme_auth_generate_psk(),
while removing the hashing step from nvme_auth_augmented_challenge().
That only allows the use of KS as the raw DH output is not saved.

But, I think things are saved by DH values always being larger than the
HMAC block size and therefor hashed within hmac_shaXXX_preparekey().
Maybe more lucky than correct, but the same result.

- Chris


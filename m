Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516734D4897
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 16:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791562555; cv=none; b=nP8oGFSAlmYFpDQjQF1PZCHWuSM7QEEJGFzSEMPKnIY8CzE3OPN4MdgsS6h5fWCl1nn+JqH8zm3vNbey4OFWLeBVYlyVjRqW8S/NLcCeCL0AwkGXTxQW8XxWIXuThy0dRbjwejU0WyYwumg/230zpQnHVFudyvI1oMh+Zv47/oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791562555; c=relaxed/simple;
	bh=IK8TbghIl0NZfbVJsRDaB6BJx8tcVo78aLNrKNODjOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uv2KObD7SN/0NZSlDHndgvL7MRg5A2Sk1Jr8bJ82oP0vFeORUgqoZUvQ+c+m6d+j7YUntxU1KDibvUdf/EDGJCtrk8QE7sm4eTOrr8efqD0ljacqFjIhx9X2MuPZOG113lNeQ3JQl4YjgT2Zm8r8ql/IVssmFJU4Qgx6A/YSLR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=mJRBv9s3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mJRBv9s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B481F000FF
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1791562540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbGK0Sz7kyHCLqIYUeDRcT+I53yH0bFA2b5RQEVnd20=;
	b=mJRBv9s3wnaDUPUjbCa0GHWuvfv7vWsQ9RyQ6IaDLpiHSs+ZJnNK3UxwoiGCX8q8yzthII
	tCPcGFAGwx0CPGP+qYP+h/6vogFLHV9t+ne/xTfNryspur5+iVSRcFf6MmHIPViKnYqptV
	unEgvEAMbNdpsFodKuC7r5RpmNY7Jrk=
Received: 
	by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id bd4aacc6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-crypto@vger.kernel.org>;
	Fri, 9 Oct 2026 16:15:39 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c169ae1cb26so353884666b.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Oct 2026 09:15:39 -0700 (PDT)
X-Gm-Message-State: AFq9FYIpKhvKEiug5vGcTiz760oXdie1rq806f027bMIfhpPljA3Wh2Q
	A8pN7b/KvWd9Yb8NTEYOjDZXndUdAH19P9jJXhCAKpBqz2keSJL4vHLOjdg+QqFt6KGBneGrQX+
	Tn6LreIh+TFvl6KNEWJg4NwNKmMfira0=
X-Received: by 2002:a17:907:7f86:b0:c2d:cdc6:8271 with SMTP id
 a640c23a62f3a-c31a702da86mr320375966b.13.1791562538187; Fri, 09 Oct 2026
 09:15:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261009125354.315476-1-ebiggers@kernel.org> <20261009125354.315476-2-ebiggers@kernel.org>
 <20261009161328.GE321175@quark>
In-Reply-To: <20261009161328.GE321175@quark>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 9 Oct 2026 18:15:26 +0200
X-Gmail-Original-Message-ID: <CAHmME9rGhu0-0EhhHq3vKgw5PNa9umB4iTnUJw1am-=9zEYn4Q@mail.gmail.com>
X-Gm-Features: AclHuK9owDu-KUZU6Q-fxO8D1wjx4SnJTfIFvrUjEFDQlu1-zO_TXwzWlmcjBxg
Message-ID: <CAHmME9rGhu0-0EhhHq3vKgw5PNa9umB4iTnUJw1am-=9zEYn4Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] lib/crypto: arm64: Fix lost Poly1305 carry when
 resuming NEON state
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-kernel@lists.infradead.org, 
	=?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This is a nice catch. Thanks for this, Jeremy.

    Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>

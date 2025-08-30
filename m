Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C20207A0B
	for <linux-crypto@vger.kernel.org>; Sat, 30 Aug 2025 10:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756550360; cv=none; b=DxXSon5pryUHST8RwCld/L4MPJ3f/qkYmpuPm0l9eiC9h7vzfEXZvgvW4SmcnCcktujyrs4AjES+SPATK6K7jEQ8InJQqpiGdJUZ3/T2P8L2g5vcFqN8b+8gTPflWvmPo05Jtvq36oy5EowSRu76zoIhCYv1pOyenac6Y0KKh64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756550360; c=relaxed/simple;
	bh=5H8BUQ/Vgu8KvU6zqWvKPnpUdDUWFP0qb4ojEk5gCKk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=qbaCey70KX3h0TmzkIq1KpMmnZnczhFFpubO3wDL5EZgqhT9qA//m2X1c2sEQgJTKWPcpnwxv75pMNkJLoDtXCZ/KvY8RPHK+ROcNGUiefRmueELfA2ei27bo9bDftXCjN7ZR+R6BVLidUveO/XxuKToexWiIe8baXxYCiuFQiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fs88.email; spf=pass smtp.mailfrom=fs88.email; dkim=pass (2048-bit key) header.d=fs88.email header.i=@fs88.email header.b=FXHx4x2p; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=l8FgvPsl; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fs88.email
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fs88.email
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fs88.email header.i=@fs88.email header.b="FXHx4x2p";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="l8FgvPsl"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id DE5481D0016F;
	Sat, 30 Aug 2025 06:39:16 -0400 (EDT)
Received: from phl-imap-07 ([10.202.2.97])
  by phl-compute-03.internal (MEProxy); Sat, 30 Aug 2025 06:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fs88.email; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1756550356;
	 x=1756636756; bh=ezq8vUpBYUZbPiXgNQvPmzjd7Mt7NDb6ZGamE98mM+c=; b=
	FXHx4x2pQLalFVxYwKAlKI3eH/MNVvL8/tewIeQYcYUgut4AzPTX9sXovF5nXdoa
	2M01VtnAOX0dnjNjl5Ps0zl3pW9rv47plK3FWSCFLyXflEkPa3pZS1cxQNNLqtwe
	0qEl/pVDC75R5LEQSZaiE+jT6SwPhchp9dVzCuDnuP3EChDdtiC56B0aiHlq9lh/
	SSHkk2mpd+zzGnYbe6eoAXUmhwTstIX2I7h0CwZUVUi+g3d53P/g734tWMyd61S7
	EjfbxXJEOdKIS5mXfhDQwtWx+ANFPZ0JvQZK5KudS2UEWg5UfLDv2K7ie1QgM7YD
	QVZrq1KxgFl1gPXZbEp5aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1756550356; x=
	1756636756; bh=ezq8vUpBYUZbPiXgNQvPmzjd7Mt7NDb6ZGamE98mM+c=; b=l
	8FgvPsleZEsATa3pgn4ANiHep+U6rSYS1b3i/Z3it7IgBRRcFWKokcYamKqzeyqy
	fc0DgRlvZRIbOWOrAMj1g41mG06NhEfl8jP3cquKdcpmnGtfcJFdxN+gCPXrxFrt
	17Iofqs7AmIMd4cSnW6p7VLUzHDtOsBrkbqQ9B9EB1v1DYZ+uPXJRHQWuyhyPzrG
	73rZfgs3kk+elqT5u1HxYjzTgD8TijABJ/hC118TAsOLiemzjmsoQeBsJ8s/1gQn
	0Od+1sTOmPKyLUpZ/TxtNZO268W9gxTV+I2d1P2KzXLUGjJTO3nZ8dyLexYpntxR
	yA6CL5n0Uthi31GJGOCpA==
X-ME-Sender: <xms:1NSyaKaxfc7S-VgsBmv7OlGUrER8SrWG6teCJMfNQTt-HLM_fSs_lg>
    <xme:1NSyaNbjHdogkH9BMMe_WmVHzOXipMhhhc2lJyWqpjJCtluWI8Fa3WmoHRHTh6Bgu
    EWaR-Bw-5nSTlqojf0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddukeeiudejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfhfgrsghi
    ohcuufgtrggttggrsggrrhhoiiiiihdfuceolhhinhhugidqkhgvrhhnvghlqdhhkedtgh
    dvfeesfhhskeekrdgvmhgrihhlqeenucggtffrrghtthgvrhhnpeeffeffiefgteeviefh
    feelgfevveejgedtleeklefhueegheelgfejiedujeegffenucffohhmrghinhepkhgvrh
    hnvghlrdhorhhgpdgrphgrnhgrrdhorhhgrdgruhenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehlihhnuhigqdhkvghrnhgvlhdqhhektdhgvd
    efsehfshekkedrvghmrghilhdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrd
    gruhdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdr
    ohhrgh
X-ME-Proxy: <xmx:1NSyaCj8YMTm8ieaN01V4f9YB3zpl5A1MxTQUup0Tc5SLQhsGwTIpA>
    <xmx:1NSyaGRVNRlQAQWvehuRyf93BQh20fhwSJdCBdIX8jSi6cHJB49a_w>
    <xmx:1NSyaDi3Z_-NuqXZ64a079PZ3aGiLIFAu4dx9bhWP0Sx5vwoQ1GANQ>
    <xmx:1NSyaG7Oxs838_PvrsVJBWVcZR9O4d1VJbb7GH--0tXCit2MDKofvg>
    <xmx:1NSyaN6IPy3vlIS2Ld6vahY4urgzdulp3H5LR4ui3ZHRgOwttyzWHmBU>
Feedback-ID: if26e4832:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 72DDD1EA0066; Sat, 30 Aug 2025 06:39:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ARZGDFgGXqZR
Date: Sat, 30 Aug 2025 11:38:40 +0100
From: "Fabio Scaccabarozzi" <linux-kernel-h80g23@fs88.email>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Message-Id: <e23feed1-bcfd-4805-9e32-090b0894113f@app.fastmail.com>
In-Reply-To: <aKg5qUBqzVY7VHj1@gondor.apana.org.au>
References: <0e568af0-7eb7-4b19-bba0-947e95418c56@app.fastmail.com>
 <aKg5qUBqzVY7VHj1@gondor.apana.org.au>
Subject: Re: Bug #220387 - 6.16.0 CFI panic at boot in crypto/zstd.c
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I saw the patch was merged in 6.16.4, but I still have the boot panic.

I've updated the bug with new findings, please let me know if I can help debugging further.


Thank you,

On Fri, Aug 22, 2025, at 10:34, Herbert Xu wrote:
> On Sat, Aug 16, 2025 at 12:44:18PM +0100, Fabio Scaccabarozzi wrote:
> > 
> > I reported the bug in subject on the kernel bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=220387
> > 
> > Kernel 6.16.0 crashes with a CFI panic at boot in crypto/zstd.c (am compiling with Clang+thinLTO).
> > I bisected, did some digging and managed to produce a working patch (I'm not sure of the correctness of it).
> > Can you please take a look at the bug and apply/rework the patch as you see fit?
> > 
> > I guess this could be added to stable in 6.16.2 then (patch still applies cleanly on 6.16.1).
> 
> This bug is already fixed by
> 
> commit 962ddc5a7a4b04c007bba0f3e7298cda13c62efd
> Author: Eric Biggers <ebiggers@kernel.org>
> Date:   Tue Jul 8 17:59:54 2025 -0700
> 
>     crypto: acomp - Fix CFI failure due to type punning
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 

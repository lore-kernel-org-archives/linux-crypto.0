Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477853ED12B
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 06:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783318902; cv=pass; b=QyYJrxv/KKYpEj8Y3WsR5qx7iYfVgli5lrZJ2pbqum2ApD6dKBb2xE25X6hs7wMXV8Tixv//XGF2I0nTkWmjl9UcB5CAkFTiGgUzBYVQTR8U/IArGYgsHgquYrCsdGfNURh5EjYZ7W6c5sZJk+FaE3pF41pj6bqHVjvQkvYWAkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783318902; c=relaxed/simple;
	bh=5h/w81ipHlPB1RtMroY5x6RcoyPoudM9cXn4KgPa+CQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=K8dUiOsd7IwOUG9uUvACy/DtX3IZ4z1FZaWafHCqk5yTAGI9SH2myGuR5CC/OhNc1uvlpaLg3Vw4wd1Hi7tFS0xx0yi8pADSEa6wN4EFNiUuPNyMS2Fhg+eu/nfJS5jHZTq6ChCAlV6JDjoM5e4qPR2ksP0DS7gcOgJOcayf6Y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=snu.ac.kr; dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b=o7/Pg0Md; arc=pass smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b="o7/Pg0Md"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-492046a3313so1946761b6e.2
        for <linux-crypto@vger.kernel.org>; Sun, 05 Jul 2026 23:21:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783318880; cv=none;
        d=google.com; s=arc-20260327;
        b=RgyIr3dob6z+ok+LXWlOXkESeU0D8Uq5K+ZgHH1j1WkPIVyEqPp9hhjCbh1XMdRLNf
         Jt/LZusQgA4GmqBmLRys0sqCjfXQTxh3J35CGo7yEIyHQU+MaIvYspEqNKS3JBB1YAB2
         AoyE8BVz6bK3TbsAjPQe0Y8R2b5JvQDTahtqUO9MgCNWABWr7sDyqrGIE22lToi/eK50
         Tpulhs+myF6iR7/KrneMSotUkq66r1Gl/AN+Zx3MZB+9woj67yQGO4TqU23HDLW8Ad/j
         RUr4pd84ZP7wvHzzE90TPNm8FfPZDVOB4bvSmZHbDCSqJxn1E8Cz8bzKhXTtPUMm8TJn
         cnMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=HKZnKiaFnIBL/a+gtN/QFOxOezQzMZ7lGA5rB+T0VzU=;
        fh=y8yDxLpMLBDX98uGQJBKFO/LL9mHVgxD/Hxa21JtAD8=;
        b=ZKma8Z2bTT7paJYnR8O/NVVYeRCm2LCTHC3xLW+yD23m75siiT9IAf3Nh/0oXCBtJp
         WXkMy/8SwZUUAA/U0gbS+fQNUFTSwcSn+Y8e7Pl4/QLj2pSN+22XJ1cP4c3RPQX3PGvB
         yAk9hvyvK+Re+3CbRdaGLxKpj6sTUMcvPjMaMmYhb+cXO80tkvGgC10grCWlCjqYXbGX
         Y9iAXGJx46NmzzTJ+jSosojDooAlsKVnXqj0zzqNLQXvQGwExRj5/+ftCSR2+8q84+Fi
         n6c74D0DNu/2nWTVR0/t6p6vsaMC6v6Usd6flLioryptfWWrHsK0kWc2NAHiBxMUNsbZ
         Y/Dg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1783318880; x=1783923680; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HKZnKiaFnIBL/a+gtN/QFOxOezQzMZ7lGA5rB+T0VzU=;
        b=o7/Pg0MdBPkXbIZ5TQw4j+w7vn+28Ag0iubFynjF68cyBsQDpvaY8mfnYMRcQbdmlX
         SjdzgpP7sNzlmJIWqU+30UPkIR26zu328U1/CCtARLF2IcixI43g1kqiqAXS5GB1rIXS
         z9ycQLAqNuoCbZyPELoe49skBYijGe6d0t+yw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783318880; x=1783923680;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HKZnKiaFnIBL/a+gtN/QFOxOezQzMZ7lGA5rB+T0VzU=;
        b=rCozhdFUeShrPbK8Mxd0PtAOXPFml+fxKu5FXqEROtbXH7T2IR7gD6T0HptHRtvgut
         MylX+KlRfzc62zOI5JrrER1lBVAqdiViWbMk95KBr+pLcNKC5oUmH4JeEu3LQhOdF4vY
         2BN4LA4q/rDblbtg5nZoXetB0BiUlQEbZPt66OzQl+u5T5+GJBXEu9qN5rnyemQK2SqG
         JcDV4IOewD3QOsl5QllunvHP0kCThHnzsXcWcUQFv7aaANMudlCOXKUOuLfcQG7rgSNS
         i3/FiHde/WUlkSJxMN3jab3lijiTAbSR1lMggrrBAxxrORLvkKsBhWYeoy7IRZAvZ4Tq
         3QAw==
X-Forwarded-Encrypted: i=1; AFNElJ9Y68+67iaurX/cmSdWa8LqByTMJTe/ZfWdXQ6b01w7Yt4R4ZefM127QVz5x0jv2T6TMxT13bPDyhkVA1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YywIxoPztSWylM5ibjRR+Qm7JyFSzIRznqJPV3/bxCCVd9vGXcQ
	Nv+ZR233pXCyXcNl/rmFaxwRF+ekFbipIvLF9MCIZ8cNpVSP+y7mk8oprcdoOe3MlTN94N5ZTQY
	cHk2Z4VEciT5tRmY5icgVAv1WbnKixguI+ki34ikaHiTRHBYkqIOA3Xu36g==
X-Gm-Gg: AfdE7cmzRQh9KEcMG+JfAQtKdJAUi99yyubiBHyxYuFs02SUOfn9GkQXXkodMVscHbT
	gYAt5bK5tx9h1QBWxJjG4TkNPqBOXlhrPQQ6VY+ZAr8ChyfFWI+zZoGt1m2K/pQAfhYzh6tIF+F
	jaUswfikrnxVPiWBS9abMDFOy1Y2Is8uOMTv1V5OUlGPsHts2wSevhQ+JWNJQS7HsoxmBVuroDh
	Dgp9sWfU1ONiW5tw3OosWLxTFiuj2Za4QW4IPRVlUuvG55NCp76tuK5a1Gp2B0ACJE/hW2i1kw1
	a/6UILM=
X-Received: by 2002:a05:6808:23c4:b0:495:e5a5:d62 with SMTP id
 5614622812f47-499b6959d92mr6327550b6e.6.1783318880536; Sun, 05 Jul 2026
 23:21:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?7J2067OR7Jqx?= <kennethbwlee@snu.ac.kr>
Date: Mon, 6 Jul 2026 15:21:09 +0900
X-Gm-Features: AVVi8CeLITREWJSfBCEW23PHXt-lLzCk0wylj_x5ml_xeAVCTD16Njcx3aN9esw
Message-ID: <CANJoUNx1RiFFRG95K2DK6acazdfe+A2VgHVXYFdH=WFNNQzB0A@mail.gmail.com>
Subject: [RFC] crypto: af_alg: where should writable ownership be enforced for MSG_SPLICE_PAGES?
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am studying the AF_ALG MSG_SPLICE_PAGES path and would like to ask where
writable ownership is expected to be enforced for scatterlists used as AEAD
destinations.

The path I am looking at is roughly:

        pipe_buffer
          -> bio_vec / iov_iter_bvec
          -> AF_ALG TX scatterlist
          -> AF_ALG RX/DST scatterlist
          -> AEAD implementation

In the MSG_SPLICE_PAGES case, AF_ALG can import page references into the TX
scatterlist through extract_iter_to_sg().  During AEAD recvmsg decryption,
some data is copied into the RX scatterlist, while some TX scatterlist entries
may be reassigned or chained into the request scatterlist used for the
operation.

What I am trying to understand is the intended ownership rule here.  A
scatterlist entry describes a page extent, but it does not seem to say whether
that page is safe to use as an in-place write destination.

For example, if an entry ultimately refers to a borrowed file page-cache page,
then an AEAD implementation that writes to the destination scatterlist would
need that page to have been copied or COWed first.

Is the intended invariant something like the following?

        Pages reachable from an AEAD destination scatterlist must be writable
        by the crypto operation, and borrowed file page-cache references must
        be copied before they can appear there.

If so, where would maintainers prefer this to be enforced?

  1. in AF_ALG when constructing or chaining the RX/DST scatterlist,
  2. in the MSG_SPLICE_PAGES import path,
  3. in individual AEAD implementations before in-place writes,
  4. or somewhere else?

I am asking before preparing an RFC patch because I would like to avoid
proposing metadata or API changes in the wrong layer.

Thanks,
Kenneth Lee

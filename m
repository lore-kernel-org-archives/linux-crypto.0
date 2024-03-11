Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6741956B69
	for <linux-crypto@vger.kernel.org>; Mon, 11 Mar 2024 21:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710191188; cv=pass; b=aexsJ3yjakDksvM6WDZrjcIYF7evCtBxPMq2tLMp+3Qgs5HHhVhAq90kCVhvrLrNouqapjlUrhNpxtli0PukNrTBOZl5Y04TsEgi5V22Z8r85mfab11Avfj/yOlKn8Qb9wlVNUVQrOpcKKiFZxWKho5wwcv09V0j12zRrXyW3tA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710191188; c=relaxed/simple;
	bh=V1SfSwQZjj5EO1OubMIhRmlBasTEOasOvya+QkQKP+E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CaSk0m08X1j229GFytJzM7DqXU5DxUg0gAn2sKTPReVLWC3+4gqaoKjnuF+KZYfCK8axCXAsCkNpcp6voQA6VXqNJhAoDagcL3fPFTkEmJQFwkRVwnnG3ea2/Y7mpornJy1eLyl1lhbu9ElsaDn/VXtTtArM1BdGhK5BXBq/tnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=N9mUri3G; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=4iDcxoG9; arc=pass smtp.client-ip=85.215.255.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="N9mUri3G";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="4iDcxoG9"
ARC-Seal: i=1; a=rsa-sha256; t=1710189381; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=JRFl+UYn35v53GmoCN/ZTWRH1uSTQiJjp79+fMptU6uYdhJkVGbpyOdOGYgnBklIH6
    nOnqVyupO/ybvR7bzwOnDKwtmIhDXb9mVvoKeTFnzkf6ybm2+MtL4N0mPVOHHwgUIszn
    NWJ6PqH5/PJi+jB3lb8ZJXP6hZWrw/ehLR8RA/JFxGXyTnS0+qNv+YzYbG/vC4QHNxpB
    mBLsZRNPVssZIXk1H1a11iquknB/R517565D3xeL+BJsFdcFdFA8RLkHPn6HZ0z7srDn
    ZsGvYM8Z10NstbyiuauEzbIF6rtUDmsC/V6nD0dpOQf7fGvNdILC2C1D67wulEvhTN3x
    InLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1710189381;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=wB7AVYvXRy/WYjLy1IgpYy2RLkDpoev38NbcRymy0j8=;
    b=O/dts3ytuIdJfTrV5Nbo5uUia5GO0k0Xr7lgFQGuTsAKX17z5+TIs7pwS6/4P8zkJ/
    QsSd8yVXhX6herYBE72Y7clrA+sySSe1z67IZc4p+I4wYAy9+khngNLh8KxjkDjjxQes
    PP3+NVwkoTkA0NDQwMn805gxa6fSyoVgCq/tvqYUAxDMuBAtIpJitG/LpipVqzxnMhGm
    Ir5gvaYDHrzsoxoRXDQJ1LRbu1Ig28Pzny1/nbOn8z/NxtCIaPFqIv37nKjzEnutq/ps
    OLq2gQor+FSZbSoQzwXeUeSGtFsvLUARc+iO8YaiSxQIhYOkXk/fNfHfZpEaYpfPY+i9
    mI7w==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1710189381;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=wB7AVYvXRy/WYjLy1IgpYy2RLkDpoev38NbcRymy0j8=;
    b=N9mUri3G5m1HERAMcrlNDa252dRLW24aBgsKmHtou/5iVzeYAlTOtt42jqsBMKQO8P
    OpFJDMg8l7+QgjUxwjby3j+JqUyuSE8rV2+/g+ePBnzoZewUn8V4YSZlmyP5UzGDxLX2
    ugtOa+IwFgrjKKy7hnGfR2EtjxzwOLX5sXQ2fCtyfKopS1AAr70DXqgq7P622dsiqars
    F7VEJfLl+jHjVTBJPGMY+6PC5K7cyvKo0B8z46hnJd4wx9i+l48RcPPjF3cHvUASWmmm
    On9CEGne//vIUhg/PfjaS7PyHTjrSWaF2mrNLXAroU6pzUQK83oB4tnhkb9qP0iqEJEz
    yLBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1710189381;
    s=strato-dkim-0003; d=chronox.de;
    h=Message-ID:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=wB7AVYvXRy/WYjLy1IgpYy2RLkDpoev38NbcRymy0j8=;
    b=4iDcxoG9Wd3ePBmdb6HIVUlaSn3fU65f6BIx/3dyjqRSv/7sTvoXvzGR1s92cjdB3b
    ty3KtSDOtIsrtC9hZCDg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zm4KKRQaXCnmSVvqb4/J3A=="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 50.2.0 DYNA|AUTH)
    with ESMTPSA id c0ee7602BKaLHBQ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate)
    for <linux-crypto@vger.kernel.org>;
    Mon, 11 Mar 2024 21:36:21 +0100 (CET)
From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: linux-crypto@vger.kernel.org
Subject: PQC Kyber and Dilithium kernel support
Date: Mon, 11 Mar 2024 21:36:35 +0100
Message-ID: <1986391.PYKUYFuaPT@positron.chronox.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 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
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

considering the approach of PQC algorithms to either supplement or replace 
classic asymmetric algorithms, the leancrypto library [1] offers the following 
algorithms accessible via the kernel crypto API as documented in [2]:

Accessible via kpp API:

- Kyber

- hybrid Kyber / X25519 as defined in [3]

Accessible via akcipher API:

- Dilithium

- hybrid Dilithium / ED25519

The implementation may allow developers to play around with these new 
algorithms as part of the Linux kernel. It offers both C and accelerated 
implementation support for these algorithms.

Additional algorithms such as SHAKE, cSHAKE and KMAC are also available via 
the kernel crypto API.

[1] https://leancrypto.org/leancrypto/index.html

[2] https://leancrypto.org/leancrypto/linux_kernel/index.html

[3] https://leancrypto.org/papers/Hybrid_KEM_algorithm.pdf

Ciao
Stephan



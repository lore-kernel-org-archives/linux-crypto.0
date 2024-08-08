Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631D718306C
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 05:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.166
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723096617; cv=pass; b=VrV87HeXuTwTNW+buqWfIJRpTGoNNtfLbrZSZ1g1OUaHYd8dj93wMrvSRCwiN+Idc7ctKfKsGKBuI0UC3AtPJBmlxgiHAZ3YdvVDxVR/WmUPXtizxVLXmqpsiVtWgccMpzKwSGbErnl759kIBp0bGuEQpybNMOzoEmaMF+Ea46w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723096617; c=relaxed/simple;
	bh=QUhU/DAYCi/1PHHyjDeilWqEpKAZhBieSMHCpTAxePA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j6XLxxfDZeNowmJhMximjsauB8HbElQEf5L6/HTvKlV+dM1rtCtbTVLpqbagprS796c5JxezlMVjVlM4lT2bDd5QApDzSihHB67gcOeaKttIE89hNwiGByE89GtOw8yE0hdMX7Vqf6XeTlEuJ3P7a++Jwa/IH5TwN9aXNKfBju8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=WpXxVltw; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=MsKKgX82; arc=pass smtp.client-ip=81.169.146.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="WpXxVltw";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="MsKKgX82"
ARC-Seal: i=1; a=rsa-sha256; t=1723096599; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=UE3s6GSzvkpbChReLdqCB0xAOxfvyL0GlSOVMDBjOXLW4lzU2RrLkhwrfv+WNku2pl
    yuAT+lcK+UKrlMFPS6CJcxtXquvJNTi6Oy1+JKINYEsFF/q0VhFkmAFBhLgbhftzV6Ei
    ghjfb9Vb5CwfVPn5uYQBSyqFtWhtr+fhdF/d/uTuzU9PgLfa64KQ1mmNQu/HcnJmGgOJ
    5NUZ11cdVVjz94en7nG1a5KgCunrGpkGyo+fvEM4+1ANcXDb6D44baVghBtrbCg7N/Gl
    pVxk3YXbIf8bw8U9afNAGW3mvID83zMZWIjEbg3EC6+zp4AWj82pQa8i+bF7XHR1kJMo
    Mm4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1723096599;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ZXWZlOTlqZ4FINs54KN3e2aPFixYwaqyD9OwZB3bSE8=;
    b=kFCf2kP/CmWjH/LPICHjWFZeb+zh8NMjDsv6u558v2st40OmcTdCW61MubbAP9bx3+
    E40hDHyD3al2UhHR3Jk7HOlf0Q9liky/GYvggLVOo0fhYZddO78nc/45TnqZjZ9JNQuH
    erMpzA8N90BViS40PvZ+nbFirEJDn7Jqa3dcNGipbIbBpLb4p3VjwK8z3HMAVOmIiacr
    uGr2pq7k8fuO7azLsK6xC1E5s309JER0FN+nEnSeUI47pKEYUB9eWY/lX3YkR1dXC0Rk
    abDjHZxuBCnhGXqZp6YVFnNIozPmvaaTQykSQmUfJ8rl25CMU+RgpFCcSqXTebf8tvtQ
    7uwQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1723096599;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ZXWZlOTlqZ4FINs54KN3e2aPFixYwaqyD9OwZB3bSE8=;
    b=WpXxVltwCcRT1J3jjACf3RvBFm1vPFDsYEiK2HXeuV23t77azBiZLMYxNHZTIfnVzQ
    INBLlZsgTsYwa7zs+Mn2G4W15qyNJMGYmJDoSeIrOD+IUDHl+vmPUYpCngMOSHzGMDxM
    UlkaXhWFJiPWK1HSv8kv7LCNHO77rOxbOMYnOWGysc4ZbRy6Y63Go7aUCspAaC1ACYDQ
    4fyyCfAMGL3tuWaOsWsPrXWGzK9f+d/rArB8elarkvkPGJd3E4Vrw+n6FrBKLO+3KATK
    F/glMTC/UD4kphODDLhi2620yBIJn/bWgoyxt3eb6pCxjwtZHQl1A788h3/OAm9JjhWp
    vSQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1723096599;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ZXWZlOTlqZ4FINs54KN3e2aPFixYwaqyD9OwZB3bSE8=;
    b=MsKKgX827qX+wwlciu1x4su4CiXsiBt1yAmkiDbl4KijuIjerctJwTu6qgsuCXk3II
    2RNxZS7sLqClxOg+xrAw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYIvSdwfQ="
Received: from tauon.atsec.com
    by smtp.strato.de (RZmta 51.1.0 DYNA|AUTH)
    with ESMTPSA id f5d0fe0785ud0oF
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 8 Aug 2024 07:56:39 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Jeff Barnes <jeffbarnes@microsoft.com>, Vladis Dronov <vdronov@redhat.com>,
 "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
 Tyler Hicks <Tyler.Hicks@microsoft.com>,
 Shyam Saini <shyamsaini@microsoft.com>
Subject:
 Re: Intermittent EHEALTH Failure in FIPS Mode - jitterentropy
 jent_entropy_init() in Kernel 6.6.14
Date: Thu, 08 Aug 2024 07:56:39 +0200
Message-ID: <2533289.B1Duu4BR7M@tauon.atsec.com>
In-Reply-To: <ZrRUzaPVqoDAcRLk@gondor.apana.org.au>
References:
 <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
 <2143341.7H5Lhh2ooS@tauon.atsec.com> <ZrRUzaPVqoDAcRLk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Am Donnerstag, 8. August 2024, 07:17:01 MESZ schrieb Herbert Xu:

Hi Herbert,

> On Wed, Aug 07, 2024 at 03:21:04PM +0200, Stephan Mueller wrote:
> > The proper way to handle it is the following: set
> > CONFIG_CRYPTO_JITTERENTROPY_OSR to a higer value as it is - like 3 (the
> > default is 1). The higher you set it the slower the collection will get as
> > more samples are collected.
> 
> Stephan, it's not acceptable to rely on adjusting a Kconfig knob
> to obtain a working system.  This needs to work out of the box.

The user-space version uses an OSR of 3. Using this value, I have not heard of 
any problems. I will prepare a patch.
> 
> Thanks,


Ciao
Stephan



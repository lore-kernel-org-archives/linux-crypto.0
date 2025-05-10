Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7721E51FF;
	Sat, 10 May 2025 11:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746877162; cv=none; b=AnrZJAPDSUXv7dRVbrOl2E0Zh7oY1qsq4zy4RVoSa8ZsSXXq/+0a1nikjn9Ph6g+Httwz2r3pmDetfiYPyrkdP9yWvWnMq65FOWsONWdSUab29nkopAQDNQr5s8JdqKT+tiQ0KdQ4iO+bvJTGtkksKwxKifggxbyMwRrb3DooEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746877162; c=relaxed/simple;
	bh=EDQuRvyjOhBKQFQpvBLiE8UiAZWa+KcFbF2YJnhHHpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jx9FwBCgmIVcFJNtx4yBAqF8xXkqjlFqA0Dq+VRdCAeSS0r1cctOlAZL2bvVA/uzR+B6MLPahhOgZ5ms0n2i1IwnELhMz4MeFcL2fFYOLxXzi+SXN0wa5ssJLQIHO/FaOpPQC1CN+fHDA1tCWOP/JHBu1IMVzNXLadhk6Fay7Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FHTg5FoI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FHTg5FoI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P02P98sxQcu6HHUuTs3FtpD/eLhHV+smfCERXdEZBaM=; b=FHTg5FoITJwqL+qsvbSXIndvUx
	PaJYmoi0ikCx+xhr/997BMAFnHX2AoTisXwczoPBg+ZiBwJdFuwn3nTbd1VaYc8rp88mENngdX7jH
	08Wm7RLMQHZ9iamGq465R4STZbA4i5JtJEtudIEcn4kCHbN2B5w15bqmbpG179I9NlOrnH8LbyvOF
	aBdIqugMFXjD8h1DtU1WoDSLNZXvwe3HYRRrtPhcdu+8eWDWdOncunNcbg/N8zdPtRFoeWQh4oUhL
	vE6IdPUfTxGjL6TNP7vIqdRYJZ/Drljm6gRNclk50zAGeLRxyY33cuvs+RNAB4bSxity4lca+beNE
	ox3Ieu5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDiXy-0053ll-39;
	Sat, 10 May 2025 19:39:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 May 2025 19:39:14 +0800
Date: Sat, 10 May 2025 19:39:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aB864l2mx4ZChZBE@gondor.apana.org.au>
References: <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
 <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
 <aB81Dh83fZoKa2st@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB81Dh83fZoKa2st@Red>

On Sat, May 10, 2025 at 01:14:22PM +0200, Corentin Labbe wrote:
>
> This is the git diff result to be sure I didnt miss a patch: http://kernel.montjoie.ovh/cesa.debug.diff

Thanks! I think we have a smoking gun:

[   45.700298] mv_cesa_dma_step: 1 0xc7011440 0x9256040 "0x9256020"
[   45.706141] mv_cesa_ahash_req_cleanup: 0 0xc93b9c00
[   45.711996] mv_cesa_int: 1 0x4ea1 0x80
[   45.716875] mv_cesa_int: 0 0x4ea1 0x80
[   45.720627] mv_cesa_tdma_process: 1 "0x9256020"
[   45.724380] mv_cesa_tdma_process: 0 0x9256140
[   45.728757] mv_cesa_ahash_complete: 1 0xc7011400
[   45.733112] mv_cesa_ahash_complete: 0 0xc7011200
[   45.737741] mv_cesa_tdma_process: 1 0 0xc7011400
[   45.742364] mv_cesa_tdma_process: 0 0 0xc7011200
[   45.746994] mv_cesa_ahash_req_cleanup: 1 0xc7011400
[   45.751614] mv_cesa_ahash_req_cleanup: 0 0xc7011200
[   45.756635] mv_cesa_ahash_queue_req: 0 0xc93b9c00
[   45.766104] mv_cesa_dma_step: 0 0xc93b9c40 "0x9256020" 0x9256000
[   45.771972] alg: ahash: mv-sha1 test failed (wrong result) on test vector 3, cfg="init+update+update+final two even splits"

The descriptor 0x9256020 was just freed by engine 1, and it's still
the current pointer of engine 1.  It was then immediately reused by
engine 0 starting a new chain.  It's conceivable that engine 1 then
somehow starts executing on it at the same time.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

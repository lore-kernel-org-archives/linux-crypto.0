Received: from mx1.secunet.com (mx1.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8161A38F9;
	Tue, 14 Jul 2026 08:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784016044; cv=none; b=J5hfKWuhVeO/eczSZWOJaRdarSqW1XvY0Kx2ER2nQqf8ipbwZrXTLvlrNG3C5ge7HOFdHN6m0Uv8954JCwkibEbnIt8hrl9bHdK1TvHmZgjKJR/xYvMmIZ8IUvxMVm0vpnSIDudw1GjZGN1bb9Gf+9t1dCmBuOTGoTptBcttSBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784016044; c=relaxed/simple;
	bh=lczrq4Wq1EhQvROZoZT33BuqmzgLX9Tkx5j+byiR58A=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1GRomiG+JLj1u83Bol84wtglWISCKUy2cFyqYDHbV8Yf33dre2wST4uUIzOWhfO5JBvoKPd11enm2RHgIScDv1nvwESQlTJfJ0PdmAlq+uHx4TyeNaT+ZcdOG+L8J7+QONBCloCVwE2o5nX++fvAfkCUN3sF4eQKFnivCELBwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=vjQFSrQM; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="vjQFSrQM"
Received: from localhost (localhost [127.0.0.1])
	by mx1.secunet.com (Postfix) with ESMTP id 9768A2065A;
	Tue, 14 Jul 2026 10:00:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from mx1.secunet.com ([127.0.0.1])
 by localhost (mx1.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A6YUFFZZehSg; Tue, 14 Jul 2026 10:00:32 +0200 (CEST)
Received: from EXCH-01.secunet.de (rl1.secunet.de [10.32.0.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.secunet.com (Postfix) with ESMTPS id CDA8B20643;
	Tue, 14 Jul 2026 10:00:32 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.secunet.com CDA8B20643
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1784016032;
	bh=zzzr7bgGfPkhtHATb7RDXhK8weqXzOaB5npsw5BmWHY=;
	h=Date:From:To:CC:Subject:References:In-Reply-To:From;
	b=vjQFSrQM0PfFsGsoyx7rN6+6ywJZ8U5YNTQG4kU0i20cIX5U3910cfELEKOpNE5xa
	 IJBbDe/9y21z9rOnr7XSdKoXkIjNGi6c1RWkmNJ+M3GR+BfSx915TxcMXdvM/oKKuf
	 shYpktoJxk3qfsfbLjYGnSzhGsagQyJZw63tWNEed4cmquX9Xr7f8wcZU7hPgewZzR
	 NLunrVG5rQ+bsG0CQUIxBxoEPqdEAHxYJcWDE8W1LjYhQ6hFvdwqkuInaz9r3OxxR2
	 L39qV+4ypy8a+aRgk0pV5bUhfBk9jAzcbuCaUaLMs04kVSRE5f1HXskxNV1pkzcu00
	 ziN8sAUHPJquA==
Received: from secunet.com (10.182.7.193) by EXCH-01.secunet.de (10.32.0.171)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 14 Jul
 2026 10:00:32 +0200
Received: (nullmailer pid 570222 invoked by uid 1000);
	Tue, 14 Jul 2026 08:00:31 -0000
Date: Tue, 14 Jul 2026 10:00:31 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Thomas Huth <thuth@redhat.com>,
	"David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] crypto: pcrypt - Disallow nesting of the pcrypt
 wrapper
Message-ID: <alXsn7_N81fPGJdj@secunet.com>
References: <20260701143947.944593-1-thuth@redhat.com>
 <alRNusgXIT06hTow@gondor.apana.org.au>
 <20260713024654.GE4362@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260713024654.GE4362@quark>
X-ClientProxiedBy: EXCH-02.secunet.de (10.32.0.172) To EXCH-01.secunet.de
 (10.32.0.171)

On Sun, Jul 12, 2026 at 10:46:54PM -0400, Eric Biggers wrote:
> On Mon, Jul 13, 2026 at 12:30:18PM +1000, Herbert Xu wrote:
> > This doesn't fix the problem completely since you can nest in other
> > ways, e.g., pcrypt(cryptd(pcrypt(...))).  How about handling the name-
> > too-long error more gracefully?
> 
> Could we just delete pcrypt instead of continuing to try to fix all the
> weird problems it has?  A web search for pcrypt just finds CVEs and
> advice not to use it, e.g.
> https://github.com/libreswan/libreswan/wiki/Internals:-Cryptographic-Acceleration#obsoleted-ipsec-accelerations

The comments on pctypt there are not quite right, but it
is obsolte, that's correct. It was usefull back in the
days when the overhead of (slow) software crypto was
high compared to an IPI. I guess there are not many
users left, so I'm OK with removing it.


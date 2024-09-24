Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4B11A3A9C;
	Tue, 24 Sep 2024 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727184656; cv=none; b=LIeLz0AyWtPPlVouMx8LDJaz6weh3oqsuwyys7BvYirU/f9GrWbDRqHy0DTiTycEbKZQlBb2XSsTyhQDqLoWEN5PLUDrjhDup/8G0KysAMbvO/EhzcXJKfWYlDF5NY2WtJqAmz4KEtvfd7ilexeX8HxKHWGJdNhKqmMP0NEg4o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727184656; c=relaxed/simple;
	bh=Zzmag5B4d9rMI5KRInab3TIef9RWWex2VD4e5f7PNFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eCHf/GckEDQcfHBidS5666aA156e/Gsu3xDS6bq+9mBVbWvUkK5xOAu+BU8MsrMjKKAO/qBQzJhlNOOkOxXJehJ8ZGcQgfZFwG/OLv0t1MOmkCQ1jrRo4o7V7z7F/2VjuQghSU6lc+rfxnD5aRQOrXPbClEQJMvOt97KFYi/Hgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=owxnGKyh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="owxnGKyh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qzNhgBZN/5wjd+yDm2cjASGFuH1G1TFsEgliMH/h3wU=; b=owxnGKyhYfbroz8DQpbpVmxOAt
	4QLOvDuzLQb8mPz3b/Nb5EanhpCGdMmRAxe2gcMmz/W6Iq9xjuECbQ96XqColG6HKP3Yvtarbxqgs
	L2Nxtskf93tfN4LHu+VADYNTIpQl6Jb8x66i97rfYVDVhicU3xkVBYRq+rop2eHxJ0QMjMrEL7iaz
	tFxgWMabaj82s5PfocyURJWsPADk4Egn0qHd/vqO8h5GfP5fBCEpFsQ6bF+dCvORZxWmD0bii+wIL
	0buwVkLe4X6D8rxlA2vs2k5RFy/ObHpY9+B+r3MAWKsE3N96XGhp17kYQnBqJKtF5WyLIRB6wO4S8
	5ur7MyUQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1st5Sr-004LDo-2R;
	Tue, 24 Sep 2024 21:30:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 24 Sep 2024 21:30:39 +0800
Date: Tue, 24 Sep 2024 21:30:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: LTP List <ltp@lists.linux.it>, open list <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	lkft-triage@lists.linaro.org,
	"David S. Miller" <davem@davemloft.net>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, chrubis <chrubis@suse.cz>
Subject: Re: af_alg01.c:36: TFAIL: instantiated nested hmac algorithm
 ('hmac(hmac(md5))')!
Message-ID: <ZvK-_5QKQ2e0S2Sd@gondor.apana.org.au>
References: <CA+G9fYtu-h_pp_hNfmx1pBg48oGeRiEDnEc4b-r3AiC_QfWiKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtu-h_pp_hNfmx1pBg48oGeRiEDnEc4b-r3AiC_QfWiKg@mail.gmail.com>

On Tue, Sep 24, 2024 at 03:16:09PM +0530, Naresh Kamboju wrote:
>
> Warning log:
> ----------
> tst_test.c:1617: TINFO: Timeout per run is 0h 02m 30s
> af_alg01.c:36: TFAIL: instantiated nested hmac algorithm ('hmac(hmac(md5))')!
> tst_af_alg.c:46: TBROK: unexpected error binding AF_ALG socket to hash
> algorithm 'hmac(hmac(md5))': EINVAL (22)

This is expected.  You need to fix the test to not treat this as an
error.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5282155392;
	Mon,  7 Oct 2024 08:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728289636; cv=none; b=OPGYaKocg1Ucf/wQKgGEnUGRwg/zSVUQkNdP6zeY4uAB/dQofvOPzRT6U3N9hNNNfz6NELC7O5eOc1cA2vq9U8OQUKMUxOnmidD58L/0M/zctS/pcLRlM8ztu4f4AjKNEhxymAQEdkgbFP2R3NBo7wBI5GkG2yzhqUvsxz+EHT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728289636; c=relaxed/simple;
	bh=/DEumeMKfYtmKeu9QKHlVKoKRxxkOKCMbAFMFiaIbP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnS1+QNtxYtrAq1KZjx/rBGa0zJzvBZL3M42CZtytxJm4dC/3WRzDfOyiwHKJL2Y+uQXVURzD4sSnFBkX8B5DLXo/f5ymcbmbRTUElheks4mr5OCeP06MKmaBT/d9eVlBafpB2lyLfIi0fAiXMTjnfAyuJcWno9zJPbzBdaK2fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=j3hAgh86; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="j3hAgh86"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RuyZ7+6pKeGTHQngiptrZxInMDTe3rjS9S1l0dgXSeU=; b=j3hAgh865YBLbTpZbpfzCjAs53
	7A+n696DJR25kPKbEB5eJEGxMwMT2zK5bYihQM5CGNEdmZtf/RPdUAKrCGz19gpBYCmIUj5bvvhhH
	8Jo7+/HFxbuHG7ONNMjuIfMClztsNBBt1N//yH1taXnIlYSlDyhrymBfvbNIwZOuSALN6aPLUCkbR
	7RCoJOdJTxcGH1FN5PbqOcV1s9nzlHBw7PlLK94LXs3Ev8SS2/WK9v26fTHcFcTtrciO+fK9vfxzF
	mHAfl0hGzX9F3UcNXoGiYUBKtTuZMaxjM7sS/IUFIFUmd1YjOyGTCWq4XycMTWxfvpmu82oVYNa7j
	iq4vBFaQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sxivI-007Orm-0g;
	Mon, 07 Oct 2024 16:27:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Oct 2024 16:27:09 +0800
Date: Mon, 7 Oct 2024 16:27:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
Message-ID: <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
References: <ZwJUO5Nz3S7EeqO6@gondor.apana.org.au>
 <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>

On Sun, Oct 06, 2024 at 11:23:12AM +0200, Klaus Kudielka wrote:
>
> Here we go.

Thanks!

I see where the problem is.  Unfortunately this is not a regression,
but instead we've managed to identify an existing bug.

The cesa driver is buggy when you invoke it in parallel.  This
would've previously resulted in incorrect hashes being produced,
which would not be easily discoverable (networking users would
simply retry if they hit this, while storage probably doesn't
use these algorithms at all).

What happened here is that the new async testing launches all
built-in algorithm self-tests at the same time and in parallel.
Previously self-tests of built-in algorithms were launched one-by-one
so there is only ever one test in flight at any moment.

This causes the cesa driver to be invoked in parallel, thus
triggering the buggy code where two hash requests would be submitted
to the hardware at the same time.

So I think it's a good thing that the self-test has managed to
discover this by itself and the result is also harmless, the buggy
algorithms are disabled.

I'll try to fix this but it's going to take some effort and I'll need
your help as I don't have the hardware myself.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

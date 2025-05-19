Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8266C26B2AE
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 08:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747643675; cv=none; b=nO8jetR59zPkvHtMLtX+/5frdGGgCBtapNxSd/FZcx1zLve/5RRTJEKjyHnflObWZKo8FTvQoXKnJXxWqkXML89QV0R8F7ZhafJ7O62IutsjiCxvo4paeTE8DHxno7Ivr+fvm7Sr8/lQ7eGYEoaI7uuvFnz2YnQWHykb1FVmmt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747643675; c=relaxed/simple;
	bh=sCVvnp/ghUYZ0ld7wMGIa5QQquhnpkm58oAOnMxftMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXdv0gXMtjQGQ5JQbnitucYn9zpd4zV9UlmMXiFSi34mVD6F/MifaJMRy00yAKDjINua6qRwyX37Yq2ClGqyg++HBSfTUk7xFaIB+0t3uJqQ4IvVvgsCPn8ISCIFmcrA351+oV5D7HrQkItBFZ0eu+5fHSYvUPyvR857EKCxSh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=H8iu0+eR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="H8iu0+eR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GlZb9baQfTPOQP4zi3wLYvnAUAH5ja94d/r9pcx+zPs=; b=H8iu0+eRMhzfiGqOpHSBfg6MVN
	LE07G91UyvhHDBw6sBK3Tv2AMKc6R2wmVVduKiEWPE6KpwWKs3O422HrXHrNddZb2qJp8cO3AVadk
	pcQbsCdTKx1pjZpTThrIyDmFEja/vhtEcv745OlZxcNvUin5oNc9h4TvbFV8B+CMOfmjXkPPPkunU
	9ENo1eSpNVepV8/74NnoYy7A/E8htIoA6rWC2N1li+aO2hWDbmEuUDOakVWw+HkUJcmCLHbhOcdRy
	INPuA1NFEMxJRGv5v9/wETjC5V6yQjX7sTVjwHeMg4IObiPmCaCL7umD4qoXe5LEorsThyIjEgBmF
	8GIzHmOg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGvwy-007AQE-2O;
	Mon, 19 May 2025 16:34:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 16:34:20 +0800
Date: Mon, 19 May 2025 16:34:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: Sporadic errors with alg selftest on next kernel.
Message-ID: <aCrtDPVJwK6SAN6b@gondor.apana.org.au>
References: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>

On Mon, May 19, 2025 at 10:09:10AM +0200, Ingo Franzki wrote:
>
> We did not see these kind of errors since long time, and still don't see them on kernels other than next. 

Could you check whether the CI runs have the extra testing enabled
for non-next kernels? If they actually had extra tests enabled before
the current next kernel then that would be surprising.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

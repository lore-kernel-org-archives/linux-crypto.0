Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A60F1F95A
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 00:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741221746; cv=none; b=elD3K3iTlVQL76quZQ2eeCcbPLjVjQbUf7B57XHsc1Ec16THkeInrFhg3FAAM+QH0xVri4C9Cj0LcrloYBos3VrKASLL8gzBaSutLHiPnJfBTZXjChZBseai8ao4j3cHYjJbwGbQ/wP4oKsqfVNnNXo5/i2SxUP1w4ny/Ypsv+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741221746; c=relaxed/simple;
	bh=grbNMNIVFjgrEnLK2g8m1d27z94ZLqPqw3OSIguVLzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hw8gvjfYqprU5ulU6eneyGwQth9oKuWvrB3L1JnuCeQPb/ylUNqkAD9OlEkWa7UEEyIdXMQYBJnvd9/HCKQglZ+Y6VM2/b7Sra+rxbWDx2IyLi1EJp0jQVw7cCla5XOBnjPAbExI9PyWEcvjHx42yhyiWliD0Hr1cJPTR/TI2lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sfDPtm7K; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sfDPtm7K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ABnUmf5L52AWIvD/O6e2rE3RUAaN0V6pvGaEQN32yPI=; b=sfDPtm7Kiru3KZV3CqcTfRSpV+
	IlBigfskW0dS7jGtQxTDtcEE2itE/C3sPjWX5otnjKJLkgC+YwNcHem/wO8Lxige9gpxzp+gTnSpH
	uVMRIs8j5mfm2Tn9NRbZlledc5axjFMsa2VzH5xwzXb0FG8tsZFUINxkexjAVTA/44z06AzZwv12C
	0TZVwaK0zbRzRPD/vn29h+BWI3f779hbh5uhMRH4SnhW1OR++bHJQGUUTckkHnuAg5Xb8rQB//hX4
	JoRO+x1Rt3lIPvWziaWiD2x5q69CiXzEhaxKgnZ5ry15NvHHbVeRqiftfr69e5dX8Dg18KVm8Tl2N
	KKe24vCg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpzJc-0048tl-0w;
	Thu, 06 Mar 2025 08:42:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Mar 2025 08:42:20 +0800
Date: Thu, 6 Mar 2025 08:42:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: Re: [v2 PATCH 0/7] crypto: acomp - Add request chaining and virtual
 address support
Message-ID: <Z8jvbL8dbjsx83g1@gondor.apana.org.au>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
 <Z8jEJ1YVRU0K1N8/@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8jEJ1YVRU0K1N8/@gcabiddu-mobl.ger.corp.intel.com>

On Wed, Mar 05, 2025 at 09:37:43PM +0000, Cabiddu, Giovanni wrote:
> 
> What is the target tree for this set? It doesn't cleanly apply to
> cryptodev.

It's based on the other two acomp patches in my queue:

https://patchwork.kernel.org/project/linux-crypto/list/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

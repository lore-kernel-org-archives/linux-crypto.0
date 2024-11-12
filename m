Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151E13D97A;
	Tue, 12 Nov 2024 01:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731375274; cv=none; b=HlmSXiO5SuIe3IkzS9p2VtcZgIxDePds85yapUKTNhxmxPKxqMDLUNiAWSycWnrB+8/KRl3BFnM+AcXBDzazF50MblJPcqEZRQtpwgcCKSpu4U5s4SFf9fp9H8CtpWBwrwwCKTGedSRULI4H+AxyUSjF5l7B+4Uz1NV3tIyeSLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731375274; c=relaxed/simple;
	bh=5YHJGn+Gdmgqyac2oHz65rXX8ewkpJYfiPmpRlXT5eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KV9qgfXx2pAm5l6M8eCeDWVHEysOioNgncy/mkg7UFrWpj6tHen8KIrgEeLWFPryHCs+QiMyIC+RysAezF59fCS3lX+r/gRCr9p2sW35jLGcMsLuq+C+jK123S+2cpykvIx6bQ1oZnfP15pUk+rUStwlrv3i4l43ju1CJxiGlhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EF3uS+Aa; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EF3uS+Aa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=80rvyGBaUm+BiWZpuZxfYYGxuemVStaZ44sYY4QmweQ=; b=EF3uS+AaWTP88tzaiewyx/lQiq
	oiND8moWz788toexq5aPz5P6Je3dsTfjZG2+l9F4YkRZQ4mkvXbHsHZFCbqUv6MO7GfR9nEZDxyWI
	ZChUZpSiKAh/fjvSld24ZQM7+4mhLe12Qk0TegxSTLiTxVwOvy3rLwxTGwvaOvsFBMqaDLPR7/3+U
	bKu4mbX5MsFp6uSPEOezcR8Uc6uAMVYDQpzzroKnaLVkjEM15u8g5keW7LpF1tcitPIN3hkTVmM2X
	nAjzV8qVBUdSaTkX6/UCQChke6hqCrdCNG+fq3BsOpG1eBLB49i7FXp6Tn1bZuiArUffGfHMIxXg8
	tB0TpKJg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tAfnO-00G7je-06;
	Tue, 12 Nov 2024 09:34:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 12 Nov 2024 09:34:18 +0800
Date: Tue, 12 Nov 2024 09:34:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org, dengler@linux.ibm.com,
	davem@davemloft.net, hca@linux.ibm.com
Subject: Re: [PATCH v3 3/3] s390/crypto: New s390 specific shash phmac
Message-ID: <ZzKwms8HEUYkEXnf@gondor.apana.org.au>
References: <20241107145521.424769-1-freude@linux.ibm.com>
 <20241107145521.424769-4-freude@linux.ibm.com>
 <ea93f581-795b-49c3-865a-76a00ee46c01@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea93f581-795b-49c3-865a-76a00ee46c01@linux.ibm.com>

On Mon, Nov 11, 2024 at 01:13:34PM +0100, Ingo Franzki wrote:
>
> There is no need to perform the (possibly time consuming) key conversation at every init.

The key is converted not just at init, but multiple times during
each update operation.  Remember the API is multi-threaded, so at
any time there could be multiple tfm's, each with a different key
being operated on in parallel.

If the hardware is such that you can only have one converted key,
then I'm afraid you're stuck with having to do the conversion before
each use.

However, since we are converting the key during each update, why
is it even stored in the tfm_ctx?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

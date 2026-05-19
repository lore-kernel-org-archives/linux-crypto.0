Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC3A2E6CCD;
	Tue, 19 May 2026 04:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779164705; cv=none; b=SAh5llD07QYtRdSUIh4dCzRJLyygphcGMZ9rXzK/d+FLBAvYhdLBYkjnAqtGw6nYr0hN3et0fu2OPSk536fs9XgDa8avmBjcrxVofDrR5/nqN8jPhEdoZwpdMHTjjAJasoxRzRfOBkK3MlTm57450/mjXsYS7bXEPaNEquuma0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779164705; c=relaxed/simple;
	bh=jNvtVD7p43tF+JXikksfl5TxDZ0XeYZiC3JHt68e0MQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUnVEiJSpDmwZMsiQvLlZYvTEaCZtj2QgAF3Zi+6iDpA717RDqTEcrM3BqQ84K7Bv/3K6RVJPzeX/g2sps0DZTrxIUMpDI7ar6LPw2fjBuXTM5VJ5Fqs31r9Pt0ctZ08Wpk5ZYCcngfHVE96lyrhckJ8X0bIzPlepcKUiPMNm2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TeOUL1EZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TeOUL1EZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=h3zO3alyt8HkJ8b8MhK5sraUyHEHdTsBo5xD1B65p5s=; 
	b=TeOUL1EZN3fgpwER9YqkOcHEIyrkcOfFvm3BcKG7NT4TN2FwdznN7LqyiOI5cwUsVrw/wb6k/+d
	KMpp8R2CfyQstiRZPj9AGeJM1YFQ9zzZmqsQKEN7Yd2kG2Vwr8vqmgn05bSzJqfD052IjwFafA9Qx
	z+Gho4rg+8TC3fShbweCNSZ4y1ityVL1z1vcV9d3cQ8SWsOLVhSHZ0LjFlH4YdLUpzEYw41aoIBoc
	PgfOnqPbDmGM0gf1UGmZBAW/deT7ygNviMBHcUnniuwy5edi1XJ98G9kFwIghccCs6x9V1kU0rlpa
	uI2+FmUkw4sJYkyx40LevNMBMmHkxagPY0sA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wPC0g-00FMT1-06;
	Tue, 19 May 2026 12:24:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 19 May 2026 12:24:50 +0800
Date: Tue, 19 May 2026 12:24:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 1/3] crypto: ti - Add support for SHA224/256/384/512
 in DTHEv2 driver
Message-ID: <agvmEgXWGlS11ZE8@gondor.apana.org.au>
References: <20260226131103.3560884-1-t-pratham@ti.com>
 <20260226131103.3560884-2-t-pratham@ti.com>
 <abTdJSPtLYN0VJWm@gondor.apana.org.au>
 <e3612486-20ee-4c0c-b5f5-677ee9f724dd@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3612486-20ee-4c0c-b5f5-677ee9f724dd@ti.com>

On Mon, May 18, 2026 at 07:05:04PM +0530, T Pratham wrote:
>
> I fixed the above and will send a new patch. But I had a question.
> What is the expected export/import format for HMAC algorithms? Can't
> seem to find a struct similar to sha512_state/sha256_state for hmac.

For all new drivers the export format should match that of the
standard software implementation.

For hmac, the export format is that of the underlying hash, with
the caveat that upon initialisation the ipad is already hashed
into the state.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

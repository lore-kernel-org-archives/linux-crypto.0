Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C421D799D
	for <linux-crypto@vger.kernel.org>; Mon, 26 May 2025 09:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748252904; cv=none; b=C+YYRC1b2bWyar6WyyLJUtuvdq2ptOQoBjwGrEg9tbO0QIBaOhgfqtokLhc0BLBfT8XGqlyEYTdGnRDqCCIMwnB564PWFR5LENEskOXFQpxeleFeN8FIZjbbSzrpcoOocAx6Ud4I0S7Cx09byCwRNd4w03RftDRr5k4fyVbNue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748252904; c=relaxed/simple;
	bh=M0SRKdnWgcpWbU1Wd3keoK+di0ycAscOHzE1e0oL3Fw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnvJmt1wJleSMGeutvUU+YYYVBYuJvjh9sffe2Y11zmWF1jxcvempGNx8u7aCxnvL7Y9uU5f3lmIj8eZ4JPCstALAYlNicDA7qGO1MwgE+SVVvR7+k6riP9gUTWL93VYD7u3G7ivukphr7+8yfSIfyzZUVcNEV+cAZlrgWIYppY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rUHAaHvj; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rUHAaHvj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EC8Qc1/rT48gkwhfcixsQm9KP+TrzalDgGRO7+mZHOw=; b=rUHAaHvjF7Mx9/oxNvMBOmoENs
	sCcqqZL5IpusEPm3XhAnSsrck39W+2WevEDtV9RENrXRe/F2ufAjXwezhOFr3lC9mu0/aZOZJ5uF5
	jR3DCFz2ZuVq4xQ0ewz2MFKYJBWXcPodfVkG+E6ysFk1+o6KxLw2Th8GsorpOw6h3E296K/r6RNuD
	NbrmxWGICDZWi5NjEaDYbF4zVGzNQOEEKJSaMyKnqw/EMN0tj72CjRXgXRmVOAq54HB1u61RkrRNa
	j8CGtrVFuToCRqJed2tOMKiNK3C7ojA+myQrMe8SbPW/hzS973bw6Yjp5pzV6LOVPj9abXrAHJx+K
	q5qzFcYQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uJURJ-0090Z1-0j;
	Mon, 26 May 2025 17:48:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 May 2025 17:48:13 +0800
Date: Mon, 26 May 2025 17:48:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	linux-crypto@vger.kernel.org, qat-linux@intel.com, dsterba@suse.com,
	terrelln@fb.com, clabbe.montjoie@gmail.com
Subject: Re: [v2] crypto: zstd - convert to acomp
Message-ID: <aDQ43TnnUtgbzsZa@gondor.apana.org.au>
References: <20250521064111.3339510-1-suman.kumar.chakraborty@intel.com>
 <aC2I0_F2BJbexte4@gondor.apana.org.au>
 <aC7owoGDFl5YVVxP@gcabiddu-mobl.ger.corp.intel.com>
 <aC7pOu_dKhRPN4LD@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC7pOu_dKhRPN4LD@gondor.apana.org.au>

On Thu, May 22, 2025 at 05:07:06PM +0800, Herbert Xu wrote:
> 
> Fair enough.  In that case we should add this optimisation through
> the walker itself because the walker is meant to deal with whether
> the input is linear or not.
> 
> I'll look into it.

I don't we need any additional code, all you need to do is just
add one short-circuit check in the inner loop:

	ret = acomp_walk_virt(&walk, req, true);
	if (ret)
		return ret;

	do {
		unsigned int dcur;

		dcur = acomp_walk_next_dst(&walk);
		if (!dcur)
			return -ENOSPC;

		stream->avail_out = dcur;
		stream->next_out = walk.dst.virt.addr;

		do {
			int flush = Z_FINISH;
			unsigned int scur;

			stream->avail_in = 0;
			stream->next_in = NULL;

			scur = acomp_walk_next_src(&walk);
			if (dcur == req->dlen && scur == req->slen)
				/* handle fully linear case */
			else
				/* normal */

	...

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B88528FFF6;
	Fri, 18 Sep 2026 09:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789722612; cv=none; b=KSUglVUn//4Qhu8Oy6+cVMlsW2P85SZIPikw3HzuKOxXkwOpYr0/45G8Cli+IlKLRHuerx8fs/TGjxn3ZnxDPy3/31yrHME/DuVY29hVEeul58QmFLSfh+0ZK1f+/CzZz83QbaUlcNtJJ0q1hA2+d7vQoLoW8zFUF9pUBOWr4GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789722612; c=relaxed/simple;
	bh=/5NgLKayM23arKQCN2gYLu+Qo0TtgQNF5INSS3vGKAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=USv4xTe7ZliBfYfWeSVEy4CNsazR2QfklJGOkP1rZt8o7UovPQ43uTqs56/ZxYUgLtdOF8ZKRaVN1oCK5f3IU7eryJvDKuqyvHAeDWcAhpHzOkPeu5wthGm5bZnerNgeQgi3dfNFxvQpjgy4SSAXYXxTNGkaKFiM2U6WviBASIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qgStivUQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qgStivUQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=QMwcuxxqHS5dk40dF9QLgyGUS30Gje2MNtQRxv/WLls=; 
	b=qgStivUQ38vMSKD6ha7IkC8SUTQ7w7ZT6wyYI+NxJkdhC+O5xLowhdkKikvHxlREnrAAfBjSsr/
	J1KukZLlgxC4v4DCG9FHv7cL09ik7eq4kcOkg7vvTWS0IJBKb0uGElYkq+TFpJFiavasPDWOgi0Im
	DUG2QT9ufMZrch3sNg9jtm2sELzTmyl0a8p3z98ksuLG98cbaT8QLNPFc9fyWIz+otXCg17Oka902
	KfmIqkEQvt6p6RqdZncNfn1pLkDZ6agebAf+/d0+2f+/TNU6IpGbA7d2n2nA603xjt+VrnPrY2wfa
	t9lAMOkuFpkaQs31gRpvGGL6iV33vyRQkolw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7Ubd-0000000FL0t-0HGL;
	Fri, 18 Sep 2026 17:10:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:10:05 +1000
Date: Fri, 18 Sep 2026 19:10:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Sebin Francis <sebin.francis@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>
Subject: Re: [PATCH v9 0/2] Add support for hashing algorithms in TI DTHE V2
Message-ID: <aqz_7a2MFn0566pN@gondor.apana.org.au>
References: <20260910180424.2131193-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910180424.2131193-1-t-pratham@ti.com>

On Thu, Sep 10, 2026 at 11:34:21PM +0530, T Pratham wrote:
> DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
> features of DTHEv2 were detailed in [1]. Additional hardware details
> available in SoC TRM [2]. DTHEv2 includes, among its various
> sub-components, a hashing engine which is compliant with various IETF
> and NIST standards, including FIPS 180-3 and FIPS PUB 198.

Please send this after the existing algorithms have been fixed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

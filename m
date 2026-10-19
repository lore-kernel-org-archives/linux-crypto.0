Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5544CF461;
	Mon, 19 Oct 2026 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373943; cv=none; b=DdJ7KvGtEyQ1TodnrjSo6U+E+h4sZEMpRbLR+owVtgO3DHf+gkHZW50NPtpATWEQpzrZSY7/CWdv1mu0yrinFHCF2uwHfhmhiHfapcRlxp5HBj1V1yQIp3NZSIHa51i+B36dOO7XgXWfcCTK7XmeProGx2Pm1GvT6SEGDQmZhdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373943; c=relaxed/simple;
	bh=RreUa/+7Oqna8RlPFjAydSh64cclg4SxJjc0aYUjW5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYzoeTqaTw7Y9iwiHyfe3fJx8vIPIGMSUfBCw1rWGB0LQPWlSVVvbPGh7uW0UwEQs5utAmhTjIA6irTQLaPBRAa1rQCUiaQ70xK95XbD25xV+CKjO2iBJdf13UweyFj/jx+wbBNeHEaEqTSSZCRiaW5XwZ1hTUufUISPJJ2ZDqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XS2O2QFf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XS2O2QFf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UYSr5t9Me/2+kseI0M7kxouyDPY24DZfSxw67dym17k=; 
	b=XS2O2QFfMCYvtNTkFYEQ3C/pPZey7mrSbEHTIZJAugCQpIf41Haezhs+L32uXqL57LTD6b+WR42
	XJCgGNCwyPObaLWjfy4JR5Ahi0kUZBjAnfJWHvYwguevy5rDHaDZMdyi3Zu7SfrpMCd9FUsV4eaG3
	l+W0q0A+6JkGm86L0zKQhABbFDSBBUN2HFRsMlnvM1P/X3ZBeRfrwmm7AEO5mCBFGMVDRuO3lOhhq
	Cv0COUuPv4q+l55FerNuuUKtzGSN4hOGuA1t2Hd3/Pf3a7nnfYWa6kl1tlb9i65cSykVaj+1+amBy
	nn5mbkTtgFbJHekYbFybwnXesI01kCI45QMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xIcKd-00000005Ctw-32by;
	Mon, 19 Oct 2026 09:38:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 Oct 2026 09:38:31 +0800
Date: Mon, 19 Oct 2026 09:38:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atV0l54Q43b1KSHF@gondor.apana.org.au>
References: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au>
 <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au>
 <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au>
 <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>

On Sun, Oct 18, 2026 at 06:35:01PM -0700, Kanchana P. Sridhar wrote:
>
> Please let me know if [2] looks good and I can include this in v2, thanks!
> 
> [2]:
> 
> int crypto_acomp_compress(struct acomp_req *req)
> {
> struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> 
> if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
> return -EAGAIN;
> 
> if (likely(req->unit_size && acomp_request_issg(req))) {
> if (likely(!crypto_acomp_req_seg(tfm))) {
> if (likely(req->unit_size == req->slen)) {
> int err = tfm->compress(req);
> 
> req->dst->length = unlikely(err) ? err : req->dlen;
> return err;
> } else {
> return acomp_do_req_chain(req, true);
> }
> }
> 
> return tfm->compress(req);
> }
> 
> if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
> return tfm->compress(req);
> 
> return acomp_do_req_chain(req, true);
> }

This looks good to me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

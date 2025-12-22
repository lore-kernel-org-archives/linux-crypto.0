Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D511E1A3D;
	Mon, 22 Dec 2025 04:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766377386; cv=none; b=lQpNaSUXG4qvgRoeE6IQAQLdCb2anLjYNrq4dyM+vCFP5/G+wfTDMlOoyV2+mSFiOyAKRMmG9a3yW9249+exqSvP849UMbJ0akQF1bdAZC9NAt3KSZBmuWDqdvVtOqqj3kXCKZgLZTmJf7BKzlcwAk0xdvOZLD21oG1zWnLcxWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766377386; c=relaxed/simple;
	bh=btwJHJOXivZhC5TnlaPH1wbfcRIYYKIt3J5tmW4WnTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ju55ZZpLCLa6AyRleuFBOiES+U9xzVTl6sbHR11vgSgrt3cV5Qwa7cdeOd9bFBqZcwfE+/CRg9x1o0UHOhSzakfd7B910NPFlvxKcLLVZa4rTiwDD4EkAv5AnREshCuZs2jQEzJxMHyF+urF1QNv1daLZvxmpAG2fLRKFyXnlcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=W2auS9If; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="W2auS9If"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6oSB9fYvGOmb+G9Aj/vPpBb//p/uepANZynYHtgfinE=; 
	b=W2auS9Ifqw6mgs0Me15UQuNf3moC2PtdF/+82x5mcQDDy21qeby39+ugw7Ws8C73EeM7/K1GKQb
	YHPNTz5gNnyqxCfiY4tdRZgV0MWWlZve2LsDTmYRrkxqnrofs7+pb/QW86q+pxp9xf7MPNzQ0SCs5
	SN/N2JGG5frlS7A4YHnbxVzMYRjvJm9G3U9Xx2rWK8N/1DHgaySsjOJRVl1Z7peI+oYjtGcf+7jlq
	8G7KyW9l1hSuTJc48KHrIBEWyvhHsZWaFfW6dRSvcxb6Ci0q7xVfiH95v/B9Z2k7jaJL5/7mCk7cl
	ucBWyBONIkw5t0DAkI8PKef1gYriRCyH5F0g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vXXRg-00Blv7-27;
	Mon, 22 Dec 2025 12:22:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 22 Dec 2025 12:22:56 +0800
Date: Mon, 22 Dec 2025 12:22:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: huangchenghai <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
	liulongfang@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/qm - fix incorrect judgment in
 qm_get_complete_eqe_num()
Message-ID: <aUjHoK9DoVIJj6oP@gondor.apana.org.au>
References: <20251120132124.1779549-1-huangchenghai2@huawei.com>
 <aUT3IW8vlYKwWDt2@gondor.apana.org.au>
 <9e9b2fc3-7d6b-4ac2-86fe-2d88fbd2ca44@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e9b2fc3-7d6b-4ac2-86fe-2d88fbd2ca44@huawei.com>

On Mon, Dec 22, 2025 at 11:00:28AM +0800, huangchenghai wrote:
> 
> 在 2025/12/19 14:56, Herbert Xu 写道:
> > On Thu, Nov 20, 2025 at 09:21:24PM +0800, Chenghai Huang wrote:
> > > In qm_get_complete_eqe_num(), the function entry has already
> > > checked whether the interrupt is valid, so the interrupt event
> > > can be processed directly. Currently, the interrupt valid bit is
> > > being checked again redundantly, and no interrupt processing is
> > > performed. Therefore, the loop condition should be modified to
> > > directly process the interrupt event, and use do while instead of
> > > the current while loop, because the condition is always satisfied
> > > on the first iteration.
> > > 
> > > Fixes: f5a332980a68 ("crypto: hisilicon/qm - add the save operation of eqe and aeqe")
> > > Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> > > ---
> > >   drivers/crypto/hisilicon/qm.c | 9 ++++-----
> > >   1 file changed, 4 insertions(+), 5 deletions(-)
> > Patch applied.  Thanks.
> 
> This patch addresses an issue specific to version 6.19.
> 
> Could you please help including this patch in the 6.19?

The patch looked like a clean-up rather than a bug fix.

Could you please explain how it makes any difference at all?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

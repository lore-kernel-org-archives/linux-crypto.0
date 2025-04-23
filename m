Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BB2265CAD;
	Wed, 23 Apr 2025 06:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745391296; cv=none; b=a0FfEHbF1vfDTHHupLlly6MVicocIL787kd930m8wStYkZX6JVpqDwoNApcXB+si7QECnQahEiOtVs0B/sraZHUBHhaHR2rINkyLXl2wQgmd0KamnK4eNsdnn0NGkkdrxGYiZWjeAuBjsq+gnb9bWGpr5GfbcyUxkAL+m5e1DK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745391296; c=relaxed/simple;
	bh=Kdmr+UsMCRAF6KPgXs7wiHhE7aN4ZNREetQtJcf94/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMOb1uiqm6vVDg0+E3kwdpgJXvtWZJHkOw/fBaDDC4Jte+Qgo/wVYR0ctu7AjwYYIydlWqQZ567X0BRKLlOkqFHQINWaKJhEJJbu62FWPxq4OZ7/DbUiOFCUkXpH9HGkelalqinrnTRx1nWeSbATEXaogsDLU1aZXxAnSx1XTJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=idSSLvGd; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="idSSLvGd"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 071531F92A;
	Wed, 23 Apr 2025 08:54:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1745391290;
	bh=nvJn++qEslCDu+975uUp2+ZELhS1lD4myoKNsUrA9d8=; h=From:To:Subject;
	b=idSSLvGdfADvbTQf6zMXetjeLjNwH1dUdt1AllEMOtJ/TCs7/T+UqiZEKMVx4nXgL
	 U5mnHLdf8LRGIMBgf7uyET/eathXepq5PfGreHp/Ds463HlJMgRHs8aQHnv9Z1imv+
	 JG4tqCL8zB5UuxA9Opi+omJEMumttf/VrwIforViTnkxxSBv/57rIt8V+VKljbWEDU
	 4Li8cvhJDU+wFdb0OsfbSCG6r/htxiKbpm/bSmaUHJpX5G2uo8NmEqG6ax6Ayz0YpH
	 GBYY6SOVJuivXOY+G88tR8JiOMKy6ztnJC+WkqcZFrFE0+DHGlMKRdJjturJqQPoqD
	 FgeoqVhqZWNdQ==
Date: Wed, 23 Apr 2025 08:54:46 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	Matthew Wilcox <willy@infradead.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Linux 6.15-rc1 regression, folio/ubifs Oops
Message-ID: <20250423065432.GA4811@francesco-nb>
References: <20250408082018.GA23886@francesco-nb>
 <20250422175409.GA877874@francesco-nb>
 <aAhAylotNK_zHl0C@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAhAylotNK_zHl0C@gondor.apana.org.au>

On Wed, Apr 23, 2025 at 09:22:18AM +0800, Herbert Xu wrote:
> On Tue, Apr 22, 2025 at 07:54:09PM +0200, Francesco Dolcini wrote:
> > 
> > On Tue, Apr 08, 2025 at 10:20:18AM +0200, Francesco Dolcini wrote:
> > > I do have the following regression on single core system using UBIFS,
> > > dual core seems not affected, any idea?
> 
> Please try this patch which will go in today:
> 
> https://patchwork.kernel.org/project/linux-crypto/patch/aAW8E9NrKWq1Xk2w@gondor.apana.org.au/

Yes, I fixes the issue, thanks.

Francesco



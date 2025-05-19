Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C091A20E6E2;
	Mon, 19 May 2025 06:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634527; cv=none; b=sVYeupL4i5XZg+2oo5YTv8A1Qdrlm+qlM8yV8gN+0q8rjPm/wuyhrr9SP08cw51ISU9lMA47hS4+StJiedsy9Ej9C9LqRfva27BxZs26Gf5x6qknzUlz+wR27XYogrSR51eqO4/luLh6Yk/HGpG/5YoDUvW3O0BWkv/81MGfT7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634527; c=relaxed/simple;
	bh=zXTSOqzwHTc0tcrinenWMzjqFlc06jxEMbn+TQ+gXtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bt5JDTXhAQnTx6h5rTZNHMHncPs1vkDoLjoPXGwJFoIzhtSOsGJL93ahKX7LPfGfIR6IqwsujVZ5fKmxUGcdX2YSUgWf247lPD8zhXk+F09S7yXhHDd63Pe0o+asfZMITsa0n3LjYpa8cTKdD3uH3bijKBAo0RnpLdAjUIgxa8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=tTnO/3G5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="tTnO/3G5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NRrPcs/epksZvMF+kcFnCNOcD3c2O81u98CLU9KkhTs=; b=tTnO/3G57g2Ylnj7HA38gvYhmk
	/jjmMRHIXJINeLpjWDr3JuzieTRsaDvgQqGWFCMCWeFy/N8q2iX2dURXt1l7ecRCASdlzC9JItxH0
	69WudlIyXXbLvmyhSfkreoCa0+5A9QVCA8N7J5Zjsv45fkTiPxp2A7BUl/vv1QR1taA5qx0mmhoPa
	DghkcTeP4izQV0qbCewRifvDiJENUbENCScM0xWMQzwT0zdTQTtSo5RjbYL5/Yow11nVA9UsGolHU
	HdjDxyCijXKHDVN0M5tc9fxU61YspNWMrRwYdicdNPDPMCh4p0nHQJc3jow57eeQd6AtsDgf+e6Zk
	vK0DjFmg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtZQ-00787y-0P;
	Mon, 19 May 2025 14:01:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:01:52 +0800
Date: Mon, 19 May 2025 14:01:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bharat Bhushan <bbhushan2@marvell.com>
Cc: bbrezillon@kernel.org, schalla@marvell.com, davem@davemloft.net,
	giovanni.cabiddu@intel.com, linux@treblig.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: octeontx2: Changes related to LMTST memory
Message-ID: <aCrJUI8ub2GgOQqe@gondor.apana.org.au>
References: <20250515061336.3348493-1-bbhushan2@marvell.com>
 <aCrJIFS2KBy-kxd7@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCrJIFS2KBy-kxd7@gondor.apana.org.au>

On Mon, May 19, 2025 at 02:01:04PM +0800, Herbert Xu wrote:
> On Thu, May 15, 2025 at 11:43:34AM +0530, Bharat Bhushan wrote:
> > The first patch moves the initialization of cptlfs device info to the early
> > probe stage, also eliminate redundant initialization.
> > 
> > The second patch updates the driver to use a dynamically allocated
> > memory region for LMTST instead of the statically allocated memory
> > from firmware. It also adds myself as a maintainer.
> > 
> > Bharat Bhushan (2):
> >   crypto: octeontx2: Initialize cptlfs device info once
> >   crypto: octeontx2: Use dynamic allocated memory region for lmtst
> > 
> >  MAINTAINERS                                   |  1 +
> >  drivers/crypto/marvell/octeontx2/cn10k_cpt.c  | 89 ++++++++++++++-----
> >  drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  1 +
> >  .../marvell/octeontx2/otx2_cpt_common.h       |  1 +
> >  .../marvell/octeontx2/otx2_cpt_mbox_common.c  | 25 ++++++
> >  drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  5 +-
> >  drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 12 ++-
> >  .../marvell/octeontx2/otx2_cptpf_main.c       | 18 +++-
> >  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  6 +-
> >  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  2 -
> >  .../marvell/octeontx2/otx2_cptvf_main.c       | 19 ++--
> >  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  1 +
> >  drivers/pci/controller/pci-host-common.c      |  4 +
> >  13 files changed, 137 insertions(+), 47 deletions(-)
> > 
> > -- 
> > 2.34.1
> 
> All applied.  Thanks.

Oops, that was meant for v2 of course.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

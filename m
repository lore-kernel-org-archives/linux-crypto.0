Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F313D565E;
	Tue,  3 Mar 2026 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772550871; cv=none; b=q5ESOXvz7msp2npPPd741AEjS4X5ooE+CE3iYzM59OVrg7cUjTM5c/J8OFxIdj8cGQl2ToZp2NH0X4LASRt5WTpWU3E+aZpHnZ0nQ2OgnH217kIHbBeVS9zdgWfUFksJMKewEpeOeQlJF1nx0tpro9Wxq5L4MEKibT5HgbDXxcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772550871; c=relaxed/simple;
	bh=i27tGhGCkluWLCokkpF6ZJMC+DubtBoDpz2Z+DismL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmyqLK2Vn5urGXFEqRAE7XBFrq2R++IbloSHfp1L2pGEe/lgzAINPWG7KmNmk3y/pshMIIOPJi/TmH+eB04ylFdu6XmqtvMhVIo0JtpuqcOFk5ZO3+IhBrv4HtzWezHayFTfMxn+KldhFxnDyZfTt3M4ib7RCZazJbefpl0pZ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4UAFphq6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4UAFphq6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rKGEneEcw53Sf3AVLYcV0KpVJlSUZ1EgLx/uOiwEn5I=; b=4UAFphq6QfiSsWiCg0GBfRm+RH
	F7/Ne4TUtkMLeCUdPmGNw7gCvK7ruHDuz7R1vjFAY/jMAyG7fIqmrzCO/gopNAIt9vCIy+wLxXn2F
	zNmZBlAhBhuBbCbSW5SYlbAk0MI/4f1NEvcWu+ovXknzZhZVM3RwZPDlUJvE2Oz10JcX7wQfl0wTM
	nVvSjzrPcJlRaVDNhaISRTkv85SxSN1kq2/8QrMtESRxsCQGaetXroM7BvBAaRbrElwIfkOUuNWRd
	RrZZ6yJkGWz57Q6r57iFtr6VlcLfP4QjMFvSkqafjewjkIY0F2Pej5UZG1QUihKgu7jA4wgtGInqu
	WHyNkBRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRS8-0000000FPD2-3CY5;
	Tue, 03 Mar 2026 15:14:28 +0000
Date: Tue, 3 Mar 2026 07:14:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Cc: Joachim Vandersmissen <git@jvdsn.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@microsoft.com>
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
Message-ID: <aab61CI7zajzqu5u@infradead.org>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
 <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
 <aaKtujHwV0zDFWxi@gondor.apana.org.au>
 <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>
 <145cfedf-7510-44b7-b1b7-6569144e7b21@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <145cfedf-7510-44b7-b1b7-6569144e7b21@linux.microsoft.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:51:38PM -0500, Jeff Barnes wrote:
> for out-of-tree modules, you're on your own". But that's where the need for
> the service indicator arises. I'm sure that maintaining the out-of-tree
> patch with a service indicator is a royal pain downstream.

And that's a good thing.  Maintaining out of tree stuff should be a
royal pain and not impact the upstream kernel in any way.


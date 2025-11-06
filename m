Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B74E573;
	Thu,  6 Nov 2025 07:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762413797; cv=none; b=TQo3kz0KWzsWmUd/A9rq43nk/9M4RmLjAjK5yTkF7ikwoD+gk/1qBKO+qkm7PMv/6bi6y1GU8E/3VBL5KwxNvH3rPSV/raJ64f7XLNy2Igqh3a43Q3k0juNyUoiPTpDFSS06dJsL+W1ZAIRQlM5583xBgwoNIZVaV4CsJMB/poU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762413797; c=relaxed/simple;
	bh=XKRAh3UCrH1pzA5KjSjzHYS2HAH37Fove7+nyKw29b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dp+bkcrR8dPEAhWXlGUbmdFDrcE2HL8dztuPMSP5e2ftKpt1/28q27wj4XPHlZswy0jCleJ8+1oLc+PVIkcpzOBlKlahvoQGXMPMkRLgKnY7CaUnHJOsbAwS1zNCwY/Cfa4t0PbFf74RVaIpABDbteATbyENHW8+ZHlnyzCMJns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YLKubWYT; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YLKubWYT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gcopwM2ZpkmL25DdUCj+qewRrZmwNCtRgHHDVJH7Pwg=; 
	b=YLKubWYTT2RIhzYNAGG2Zs5RptgZpdckKr3VFIpSfB4W7ZuJ5Irq+PaD6eSg3/gQ4kLgoKLU9ZD
	mpFlX+/mbtLunHdmNIt5myJlXC8gzplulqN5My11FiDcbYoKtNagYbKY67nw1IDNnJT2WKPMSxZ0x
	ZUbxdtZBm9M4LHKPAawhHPTVtxn+juUDSPMbLdK2IxTNETVqaw+ZYg74YijPTWCXsq2GRLcxCwCt6
	cHkmOC7yoYgRZeOPT1qNJLRKvmvbojTUj0OIKxHxcpMstpv0p6dVKne4KT8QQJKF0SsbKYdTxALPv
	cJFxBvOeSzp5gEHnz1wKFZWSpA4TxuV8GxtQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGuKp-000rnm-0k;
	Thu, 06 Nov 2025 15:23:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 15:23:07 +0800
Date: Thu, 6 Nov 2025 15:23:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/4] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
Message-ID: <aQxM2z9kC6sTqBZ5@gondor.apana.org.au>
References: <20251022180302.729728-1-t-pratham@ti.com>
 <20251022180302.729728-3-t-pratham@ti.com>
 <aQSDLpD2LXlqILku@gondor.apana.org.au>
 <f4c339e3-0964-469e-9cec-eeaf2e2f078b@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4c339e3-0964-469e-9cec-eeaf2e2f078b@ti.com>

On Fri, Oct 31, 2025 at 08:11:34PM +0530, T Pratham wrote:
>
> Let me know if this is fine.

Yes I think this should work.

> However, I suppose we similarly cannot do allocations in AEADs as well?
> If that is the case, my current code relies a lot on it (using sg_split
> to separate AAD from {plain, cipher}text and applying padding like CTR
> here, both of which allocate memory).
> 
> I can change padding to avoid kmallocs like CTR easily. But separating
> AAD and plaintext/ciphertext without using sg_split will be a task. Let
> me know if this is correct, so that I'll split the series and send
> ciphers now, and AEADs later.

OK it's not totally forbidden to allocate memory.  However, you
should only use GFP_ATOMIC to avoid dead-lock (GFP_KERNEL can
trigger writes to storage, which can in turn call crypto), and
provide a fallback path to software crypto when the allocation
fails.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

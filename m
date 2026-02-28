Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E2A3E95B6;
	Sat, 28 Feb 2026 08:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268061; cv=none; b=kcBoT+j62OqieDVqVsHo0NYgkga+oTJXZm98sRfACzhXyKb6LRrzuOT41+V81I3vO9xRnTNs73AxtilfyLrFNVbemV3zAyEHDzi1YtgvvmEgRZygKroGkn4S3JTsv/qAPVfFCZc6JRTpJQuxWZYJ3BQ6ChsdDQs1x/m0MTRDatQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268061; c=relaxed/simple;
	bh=quGSjRMx2tRMTwdz3ezRGRPzCpj1qNup1Wd6u6alCgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlQAJMk/eOe4yVTcGArbev/GXvflMoxT/PFVwG/WES8OTg01chot1SFbT99sW4uOnNt1Pq/Q2AfgY3FeMykiysyawsdbC4/udt0gli+UwDlY0VrlVPCy4K/Z59gnLbDdcKRfw1p5QIiJAjc9P50wu+ooOsPvL2W8eiBaYSkWml4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TDIR2nFS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TDIR2nFS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Fcn0dlp+1heLZlW28P8lUkLghKDH2F7/fib/vj27Crw=; 
	b=TDIR2nFSMqvkqEuMb+NfHVh6B5iEGzopWWAVLw27nDiKg4byWHZn51v0p0W3xIBHu5TvsmFH7VC
	GTMAqHzZ1Af/OrbKmlclHxk5+joLk5CE4S3kDSieK1SosMAAFmj0g1SidXkVwFOUAm1NHpyp4ll8z
	/wMy8IxjNEOpLuvHWgGFHkK84Srl5EY8U4/dlu6fqSl8PLvpFWeKtxYdadotZOotQCi2IAuylXOB2
	C8RGVxYojzEPDECXbcMb7yE2K5ZyZiwqCG3OnaVJVgDupdzVuhqS4uJvoIfSUSnmjw8XZM8HMU6rq
	nwQGjWaySZDdX5sgMTN7NkJt3YzO0Nq1S19Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwFsV-00ADl0-2B;
	Sat, 28 Feb 2026 16:40:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:40:47 +0900
Date: Sat, 28 Feb 2026 17:40:47 +0900
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
Subject: Re: [PATCH v8 1/3] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
Message-ID: <aaKqD5FP6w8dp48p@gondor.apana.org.au>
References: <20260120144408.606911-1-t-pratham@ti.com>
 <20260120144408.606911-2-t-pratham@ti.com>
 <aYWsJAmf05EdotTX@gondor.apana.org.au>
 <b3b9f41a-adc3-408f-9fc9-69618c4aa2ba@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3b9f41a-adc3-408f-9fc9-69618c4aa2ba@ti.com>

On Fri, Feb 06, 2026 at 05:07:13PM +0530, T Pratham wrote:
>
> The DMA (at least UDMA in K3 SoCs) sends/receives all the mapped length.
> If I have the dst sg mapped with length (len + x) but write len in
> crypto hardware, the DMA gets stuck waiting for hardware to send the
> extra x len. Similar issue in reverse as well.
> 
> Also, FWIW, I'm restoring the len in SG list correctly at the end.

If that's the case wouldn't it also break if the caller supplied
an SG list that's longer than req->cryptlen? There is no requirement
that the SG list must be exactly as long as req->cryptlen and it
can contain extra data at the end.

Perhaps you should use sg_split like sa2ul.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

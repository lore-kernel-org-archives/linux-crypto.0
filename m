Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D7644C4FB;
	Fri, 16 Oct 2026 12:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153308; cv=none; b=GTJCdy3ijCOI62RzpvTIUtfQD1KyHHtuKMG+lVQmCiqLSvPnT16U66seA5sajbbeHgxNrnbZp0d45e9Xw1LVc2ogaY2C2TRUN3jWuTLsB7xT4oUmt28QyANHmO7uRsZ1Q7WwA7udFARQLKRixibWLmN+Vj72SN08eYHW3Q+yCBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153308; c=relaxed/simple;
	bh=HxtnMKpZHiMByeKjzOwdFZJF2Cc6fNn3qfk/ehSwlV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9s5eBE9lYV6OyOL8SQoZ+bvQdEtrjmB0JnyP0lzfesnsePILEk9oIkWFmss5DUjjSBt3jAoRSBn7sEikGNRwOBsJxnDOG8X2K7Wen5wCw+Yinh8UbsaRYiDQ/yn+t5JG51v0nJi9lplM0nfK5xLUQ0Zdp6YNFXoQPLF7EaO1+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XQ5CXe67; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XQ5CXe67"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fAVKR37Op5c869xb/LHQtZ5GUTNDvUF8xw/fbi6lf6g=; 
	b=XQ5CXe67AwgMknczJnVNO/l4t4lHCJLYGiy/8WRPmmHFhKnHyiXLU3juDm/LWtfrHtsBU1uQ7WA
	3MHAoFPTFAY1beKKLosOl2Z/Q3NDvxXdz89cgnZ3IIzRZCca/1lNR5DlbFUDuZI5pIwD+QUf+ULSm
	6+aCzh8uGRGsqggA6a6NRZWUVArJxTSNMUEh2JiYhpHyPkCynlPAReA469fGqs7MMjTJPhAG4qisq
	fSnIixTyOVVudFVFd+JL0xZv81X9Y+zjuGipJpk5oLQ5gk4EquHtLSXs9N3fRECG/yKDSdtTEPHd6
	i6B4qFpjGZVfDXE9blvXT/eqYp67MxUvtTgw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHgwM-00000004XuF-19DW;
	Fri, 16 Oct 2026 20:21:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Oct 2026 20:21:38 +0800
Date: Fri, 16 Oct 2026 20:21:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Myeonghun Pak <mhun512@gmail.com>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Lukasz Bartosik <lbartosik@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Ijae Kim <ae878000@gmail.com>
Subject: Re: [PATCH v2] crypto: marvell/octeontx - clean up VF resources when
 DOWN fails
Message-ID: <atIW0jxNMR3wxvQU@gondor.apana.org.au>
References: <20261011203456.1879639-1-mhun512@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011203456.1879639-1-mhun512@gmail.com>

On Sun, Oct 11, 2026 at 04:34:56PM -0400, Myeonghun Pak wrote:
> A failed DOWN mailbox notification makes otx_cptvf_remove() skip all
> local cleanup. The driver core still completes unbind and releases the
> devm-allocated cptvf, leaving the raw IRQ handlers registered with that
> object as their argument. The sysfs group, crypto device-table entry,
> software queues and PCI resources also remain uncleaned.
> 
> Keep the notification error diagnostic, but run local cleanup regardless
> of the PF response. The PF only acknowledges DOWN; it does not disable the
> VF queue. Disable the VQ locally and poll its INFLIGHT count for up to one
> second before releasing the DMA command queues. Warn if the queue does
> not become idle, but continue local teardown. Clear PCI bus mastering
> before freeing resources. Remove both IRQ handlers before killing the
> tasklet and releasing its resources.
> 
> This issue was identified during our ongoing static-analysis research
> while reviewing kernel code.
> 
> Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Co-developed-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
> ---
> Changes in v2:
> - Disable the local VQ and poll INFLIGHT for up to one second before
>   freeing DMA command queues.
> - Warn on an idle timeout and continue local cleanup.
> - Clear PCI bus mastering before releasing resources.
> 
> v1: https://lore.kernel.org/r/20261004042634.1130247-1-mhun512@gmail.com
> Review: https://sashiko.dev/#/patchset/20261004042634.1130247-1-mhun512%40gmail.com
> 
>  .../crypto/marvell/octeontx/otx_cptvf_main.c  | 44 ++++++++++++-------
>  1 file changed, 29 insertions(+), 15 deletions(-)

Please address the Sashiko review:

https://sashiko.dev/#/patchset/20261011203456.1879639-1-mhun512%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

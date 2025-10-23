Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AD6248F73;
	Thu, 23 Oct 2025 04:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761195553; cv=none; b=V/G2S3NnFsYqUXmHm2EGDLjH71Sh+sjzr7e7XIsDoWskTRYVkvWX1VSqg4tETe1mOkEqhKDPlQJVBSB6KhWHRT/u5F2E1bQPGN9GYYAdlEdkpOI5103gOZJjmqQPQUVPcgLsAGnSshazVuORRwcaL4n9DxqV58D/Lbd02oWIwec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761195553; c=relaxed/simple;
	bh=rrbEnj3DV0oxTOPLUD0Z/2h2MgfbyEBUcgE/Y8ABUEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c35LkfQqJCBeWylQJ1xcdlYDzEFmUJpPQ4VbbSbXcOGwUKISWwJshP5Jj1NkmFeQ+UGLu/BE5ZZTw5FznNonpdfZDnqB6viItvkm7gkmLb+9qwYjdmLVL4jC4cFYvb2d8YNJxttOtVLpIC4ojeMP2g+G4FDHZ64vO6mojNyV+Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JYFLUg1k; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JYFLUg1k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CIeUsbP3Y4lD2ZSdupW7972wluaAD7FbogIr27LuHjI=; 
	b=JYFLUg1kSBk89ymEx1qXwYEh3Byrw/RctEP8rSXme8rhb/EAsKg9qaK6GdTQeQp15iGwDBPQ7UR
	CXYuHu9aCv+yieCWQDlCqX0Sb0782vZM45QwDIN9uFvul5GCSp4lwADbqfYS5elQS5k/IA9mH9MbY
	mAFF7g3nP7TLTprrrCXK+oBc4gdOkdftMj9r3iNHJCWik8E02PN+HCthpouC+5aGe8UMk5BSC2GLU
	gQFldUYFy23jgvwBq2Xdae3ljuBeTim0T6+caNrOuuglqM2FcS0iEA031ULMLsHOuEL6HtwKOPYVx
	ZU+Ma+s/khLPxM62YC4jbxyvmnpasRWlPTqQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vBnPn-00EsGr-06;
	Thu, 23 Oct 2025 12:59:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Oct 2025 12:59:07 +0800
Date: Thu, 23 Oct 2025 12:59:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	mpatocka@redhat.com
Subject: Re: [PATCH v3] crypto: s390/phmac - Do not modify the req->nbytes
 value
Message-ID: <aPm2G5s0Ali-nVmA@gondor.apana.org.au>
References: <20251017123254.140080-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017123254.140080-1-freude@linux.ibm.com>

On Fri, Oct 17, 2025 at 02:32:54PM +0200, Harald Freudenberger wrote:
> The phmac implementation used the req->nbytes field on combined
> operations (finup, digest) to track the state:
> with req->nbytes > 0 the update needs to be processed,
> while req->nbytes == 0 means to do the final operation. For
> this purpose the req->nbytes field was set to 0 after successful
> update operation. However, aead uses the req->nbytes field after a
> successful hash operation to determine the amount of data to
> en/decrypt. So an implementation must not modify the nbytes field.
> 
> Fixed by a slight rework on the phmac implementation. There is
> now a new field async_op in the request context which tracks
> the (asynch) operation to process. So the 'state' via req->nbytes
> is not needed any more and now this field is untouched and may
> be evaluated even after a request is processed by the phmac
> implementation.
> 
> Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Tested-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
> ---
>  arch/s390/crypto/phmac_s390.c | 52 +++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 18 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

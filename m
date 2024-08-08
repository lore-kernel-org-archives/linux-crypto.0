Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A935184526
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 10:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723112225; cv=none; b=YKVI7vhD28RxDAS/zfUcthc6a+R8GNoU9JOFU0qDjURudMrQaAbJEPS50AUvZUkxT76Ok5IlbTXsp8nHQhEGDLfVnTKI9ipc8uWCNHQLgKhGZ5JR47L1VG6ql2y9YHSM9+qJttyC+T3pC9GxHV8rnOXujTpXXYorhdTHP24kq6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723112225; c=relaxed/simple;
	bh=hXAzDpggmkjabiVOKdhGqH69KWeX38T0Q/c29i5fJYM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNFqzPzmt7VffBr0zV3i2vY7xrI+grPvNEWdTyxfR6RPWXQM++ypIxdEC+Xt7bMcRdAylbGfwCMNDkCPpebFqJJ2H2lYEptaZ3Iv4HvBaH7siueL9y9/0A6nymgpN0B7ofRkQuVm4qH8ITHGIeQd8X7GK0afpAr9TMMWLzqK0b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=YKQJLwIW; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="YKQJLwIW"
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id E2B8220820;
	Thu,  8 Aug 2024 12:16:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IpxsKlMjQdj8; Thu,  8 Aug 2024 12:16:59 +0200 (CEST)
Received: from cas-essen-01.secunet.de (rl1.secunet.de [10.53.40.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 574D320758;
	Thu,  8 Aug 2024 12:16:59 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 574D320758
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1723112219;
	bh=oQhUipE5SwS6toz3/M3K+yIZ1jxlGgxNpF9xYEPiJqQ=;
	h=Date:From:To:CC:Subject:References:In-Reply-To:From;
	b=YKQJLwIWKcibeuV6DuJfqjfn5k5KAr/jH4y331A8+3h1EJzrpZKdTd7dKEA4tTXCA
	 t+ZgyGYVOcjg9ok7KLiN+8CfSBrAoxE+O+1N8X3ftc2ZjWrCO72efxuuqzaqdQjqZD
	 8oLb7g9wjoLOglNe7d7uc9+aQk6aHfqTlmBH4EfOVXfTDljsU9WmCZoaV5VQmaJZoz
	 lJ5DKU8MfUMZzdNBeXwEOz0dstLh4v/mElW/AymG69Abz0mnNcPQlwOT86nUyf/bA8
	 fUePWbq0u7EFBrsXGCiTy7WBpFOmFF3WfQto5S27l6r8J/iA6LI8JUxQbmtUyd/osE
	 +OGmlhhXhtawA==
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 8 Aug 2024 12:16:59 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 Aug
 2024 12:16:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 86D443182514; Thu,  8 Aug 2024 12:16:58 +0200 (CEST)
Date: Thu, 8 Aug 2024 12:16:58 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Yi Yang <yiyang13@huawei.com>, <davem@davemloft.net>,
	<mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
	<lujialin4@huawei.com>, <linux-crypto@vger.kernel.org>, Daniel Jordan
	<daniel.m.jordan@oracle.com>
Subject: Re: [PATCH -next] crypto: testmgr - don't generate WARN for -EAGAIN
Message-ID: <ZrSbGs646zd20TBe@gauss3.secunet.de>
References: <20240802114947.3984577-1-yiyang13@huawei.com>
 <ZrG7zWxeXQn-Mkhn@gondor.apana.org.au>
 <ZrSZdQxeKaXVmi9E@gauss3.secunet.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZrSZdQxeKaXVmi9E@gauss3.secunet.de>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On Thu, Aug 08, 2024 at 12:09:57PM +0200, Steffen Klassert wrote:
> On Tue, Aug 06, 2024 at 01:59:41PM +0800, Herbert Xu wrote:
> > On Fri, Aug 02, 2024 at 11:49:47AM +0000, Yi Yang wrote:
> > > Since commit 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET"),
> > > The encryption and decryption using padata be failed when the CPU goes
> > > online and offline.
> > > We should try to re-encrypt or re-decrypt when -EAGAIN happens rather than
> > > generate WARN. The unnecessary panic will occur when panic_on_warn set 1.
> > > 
> > > Fixes: 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET")
> > > Signed-off-by: Yi Yang <yiyang13@huawei.com>
> > > ---
> > >  crypto/testmgr.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > We should not expect Crypto API users to retry requests in this
> > manner.
> > 
> > If this is a reliability issue, perhaps padata should be performing
> > the retry? Steffen?
> 
> If padata_do_parallel returns an error, it means it can't take the
> parallelization request. That is either because the instance gets
> replaced or it goes down. There is currently no infrastructure
> to queue requests on error, in particular not if it goes down.

Maybe pcrypt can call the crypto layer directly without
parallelization in that case.

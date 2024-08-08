Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD5D528
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 10:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723111813; cv=none; b=DVd/QKIRhje4NyeR2jqgaRq7fR4rd74y7HOHGduRD+ITz3Na3ZsNw/3UaOcgidhPK2NgXZRqKvhges746Q8HLOxb/zNdagKS4YOpvn+ewJR2vwlBClnWnJcbt1ECYTWefjFJR+gtjAbucndCElsQaJppUDKjs6HqXZVboe1XN7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723111813; c=relaxed/simple;
	bh=QVojfJ44sfu/dRfUh96GVSYizxfRBC4zAvMJUR53i8c=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caP9o5JoqzoE/PIOjhUmLHVGkJ8r7Cr6a9qKX52Z9TbOaGzjarInt8iLjPEJFS95rrFriYQNP3rmP1JLs3Y/AYvK4Ed5cX0aR+F6m49BCjvf1OAqUBMMjYzdVmJcBOUodAHprD+N7IwsyfR7cu0j/RRurP64VCKRBD+ng3nCPaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=rtrDXDAb; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="rtrDXDAb"
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id CAEAB2082B;
	Thu,  8 Aug 2024 12:10:00 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LzpuQrJY8a_i; Thu,  8 Aug 2024 12:09:58 +0200 (CEST)
Received: from cas-essen-02.secunet.de (rl2.secunet.de [10.53.40.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 44B4D20539;
	Thu,  8 Aug 2024 12:09:58 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 44B4D20539
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1723111798;
	bh=mNDEiPCs35/IVJlcOBlMRCwQX+1Qqr37SCLhBLpaWMQ=;
	h=Date:From:To:CC:Subject:References:In-Reply-To:From;
	b=rtrDXDAby1Lkov4CJSQDLCL300eVEzt3PZ8aPg7d78fnx/9XIbPpS9+lSLIo/oqrJ
	 r9NW5YdlnSxniFs76epodmTDN0OnWGko1wVwg+GJm8CL30pT1BRPH4POD+jRDpwqop
	 0w/HcoHo4/G9Z3Nw6JWi17KZlfASyNMjckB2NzJj91OKeYW8G4I/6eqV8Q3JSL9eC+
	 pDQPmuvKAELcTFdem7q47/ttNhyD9BeJwXB4Dh3/TDTdtttD2rImdaxcB3KI4xvPJM
	 JLpMt6/0hTUmfRmJz7sFySG3nag+5vc5fSaCc9LeXnDqszkRhz/ZaK+47FOYRBEy35
	 LyDAd8TVNsVMA==
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 8 Aug 2024 12:09:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 Aug
 2024 12:09:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 6672E3180549; Thu,  8 Aug 2024 12:09:57 +0200 (CEST)
Date: Thu, 8 Aug 2024 12:09:57 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Yi Yang <yiyang13@huawei.com>, <davem@davemloft.net>,
	<mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
	<lujialin4@huawei.com>, <linux-crypto@vger.kernel.org>, Daniel Jordan
	<daniel.m.jordan@oracle.com>
Subject: Re: [PATCH -next] crypto: testmgr - don't generate WARN for -EAGAIN
Message-ID: <ZrSZdQxeKaXVmi9E@gauss3.secunet.de>
References: <20240802114947.3984577-1-yiyang13@huawei.com>
 <ZrG7zWxeXQn-Mkhn@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZrG7zWxeXQn-Mkhn@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On Tue, Aug 06, 2024 at 01:59:41PM +0800, Herbert Xu wrote:
> On Fri, Aug 02, 2024 at 11:49:47AM +0000, Yi Yang wrote:
> > Since commit 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET"),
> > The encryption and decryption using padata be failed when the CPU goes
> > online and offline.
> > We should try to re-encrypt or re-decrypt when -EAGAIN happens rather than
> > generate WARN. The unnecessary panic will occur when panic_on_warn set 1.
> > 
> > Fixes: 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET")
> > Signed-off-by: Yi Yang <yiyang13@huawei.com>
> > ---
> >  crypto/testmgr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> We should not expect Crypto API users to retry requests in this
> manner.
> 
> If this is a reliability issue, perhaps padata should be performing
> the retry? Steffen?

If padata_do_parallel returns an error, it means it can't take the
parallelization request. That is either because the instance gets
replaced or it goes down. There is currently no infrastructure
to queue requests on error, in particular not if it goes down.

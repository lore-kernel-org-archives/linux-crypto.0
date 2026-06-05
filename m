Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BA83FA5DD
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2026 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780659650; cv=none; b=EsNoWB8pLPjzrz0v4BlGk75LDZhxOlKuElzCBsTom5DwUJoSWogEBi0+8Y48UfzkOCDAoUu6dsUa/aAZQMKSsym/+dFuA3YRQzGWcITumSAkw7L0MssuW3x4VxDXb6iuYw+dazugzn7fGUs9BYQxjUMUL9KTBtxYL3Us9y+Qszo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780659650; c=relaxed/simple;
	bh=/IA2GhPGcKyKbWYtU5uj8zWUnYHNqAgFTF/iGelYM0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzL1uezOoJG841XpKbDTMPPvP/WJ4tkfbCoRWF7NlbhsV7FTOPvvP4pw87d120Ps3RCMHW8h0AjoMpXqXmQwy6Svmw11ZpmGGJ9jeZaN8lrC4XsbwsPSAdVtfII62BFaRwk/VdpqpxKzxYOZ035XgfRiISKVlU5jezA4f4u55aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Php4Wwle; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Php4Wwle"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GcQZma97cMflM4YVEBJxSBXPm+oi2cPkeKTnkVSao7M=; 
	b=Php4WwleQS6lCJneIOF5VNdWEDlkViSQYBfDJGqMLD3YsuIQTr+VZuul+8LV0ivG7bT8dY3GANZ
	5bCcCNB9Gi/FIuW++HB1WAiI/CAUgX8ZI5XzApdP1SYmcEPR/jaYOa2V9yzTp+XvU6KM5WeF1QJp/
	x7w6X6bhP4jmPp8Qk0h+OBTxSvPe9kuCSr/ft8ecyjEdpxl1qRL68UinKjaBg0Yq2uzG6ZT6X8HYY
	8LQiijtQA7LNjGNU8gbeBWnwFVYCy7kxoeqmqr7f6ePXz1AwUVxqIf0eGGXqLlnUx4hakwLKzelGD
	PX+dqQhYdpOaMCTbCij+pDxd2O8sJ9Q6hNQw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wVSup-002omE-1S;
	Fri, 05 Jun 2026 19:40:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2026 19:40:43 +0800
Date: Fri, 5 Jun 2026 19:40:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	davem@davemloft.net, yiyang13@huawei.com, yuantan098@gmail.com,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, zcliangcn@gmail.com,
	bird@lzu.edu.cn, ruijieli51@gmail.com
Subject: Re: [PATCH crypto 1/1] crypto: pcrypt: restore callback for
 non-parallel fallback
Message-ID: <aiK1u37QHKxarYmm@gondor.apana.org.au>
References: <cover.1779697691.git.ruijieli51@gmail.com>
 <9baedde966f3bcc64b5cde86c2b9c95943572406.1779697691.git.ruijieli51@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9baedde966f3bcc64b5cde86c2b9c95943572406.1779697691.git.ruijieli51@gmail.com>

On Mon, May 25, 2026 at 07:45:21PM +0800, Ren Wei wrote:
> From: Ruijie Li <ruijieli51@gmail.com>
> 
> pcrypt installs pcrypt_aead_done() on the child AEAD request before
> trying to submit it through padata.  If padata_do_parallel() returns
> -EBUSY, pcrypt falls back to calling the child AEAD directly.
> 
> That fallback must not keep the padata completion callback.  Otherwise
> an asynchronous completion runs pcrypt_aead_done() even though the
> request was never enrolled in padata.
> 
> Restore the original request callback and callback data before calling
> the child AEAD directly.  This keeps the fallback path aligned with a
> direct AEAD request while leaving the parallel path unchanged.
> 
> Fixes: 662f2f13e66d ("crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Assisted-by: Codex:gpt-5.4
> Signed-off-by: Ruijie Li <ruijieli51@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  crypto/pcrypt.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

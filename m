Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ED314AD19;
	Mon, 16 Sep 2024 14:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726496076; cv=pass; b=hu88uYgAAKE7FtZIbgoa8N9foUmK1FTlTV+1v4IqylOvK/iISmbq2ALq9dHAKE+GhslxdMEJOk+UeH7bTOTxDjMWj7lWgGZ6fsssOFBYCe+Xc71avtwmYA0pzoYNYS922OtZkVSnIB2SrKCXnG8BGcj4AiqTG/fxddp+Hds540I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726496076; c=relaxed/simple;
	bh=skH25LvHsTqztpm/r8mdNPrTJ1+bQ/eoLeZ3B8TbupM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GA8eiP0me/nD3se7+r1NHYXFQqKk9Tpl8+jTf6anGMOjbjK/7WPf6LJzowncWE7ZeN2VnaXmN4yIfiHQHcDxHC8mlPt+R5ey5Td5DJv2y9xy8VMQwYlD08iHWg2YrdmA1u6MUF9ynkWcNAcY2XsLYjgzRE4+14l1A6qnFETL1yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=A91WpKxz; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=5GaanhQN; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="A91WpKxz";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="5GaanhQN"
ARC-Seal: i=1; a=rsa-sha256; t=1726496061; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=kAaTLva/k5mSlM5MKfxSK63ef33iGzd6jWhN4HM6QnbIQrH5mJtkw50RCqsaSitoZ8
    i48tIIihgmLeKQ+WK4b2vpxJprxF2IyHuznSyKpxqh9ExaKwi5hqtC4DfoM0JmJJ4GWa
    o+4k13HPv/iMwlg3zQmlPp8aYBx/wE2x8R8hNlM9uQKIzracG0nAwLdCj+O46Ottj2b9
    UoXw0UlwBySS3lgC2uYHUNqm3Ini3Ll4QwWI0YhsVhaDKFUPHU0d8hKbh2z1zEMqfmYC
    13mTYNBw9xftnj/WcSSTnsTTj8lTNkidBESUW1Vpe43IWmbJN0qx0M4/5Dp4cl/2l0O7
    w7Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1726496061;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Sxh+iOlD0w2POThuxYJOde+V6I0gj91hpazRapcc3hU=;
    b=d45HjlH1mtlL/LHsaguenoyNX65ZZjH4z3dDsFuYxejEGkC3oa2IQ8a1d3j3wczvO1
    U1SLUUa1Qi8K9+6suGCzGlv4xnlhjzHAuZ5G42ykb3XhWub7NXgyvmLwiZtVcVftBaLN
    lfION95HV8jbUzKO+ROqqyOLLvaKXkSNLj/qJ/R18Vu7k8Tk0eHP+bwtO2h+qJmpxQiG
    G5t9S9/ylfQ2WNq5hiC8IfsL6aPLNZ5KCe5g/ZJFac8GVX3b/w0sJlB/7TK9GZp7RA41
    3JLu6Z6vD++yrSvehAAQ8cTjubExOJwni752TM9Rs3OFkgk7kQlljlH5Rp4xz3aIs3IZ
    z1ug==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1726496061;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Sxh+iOlD0w2POThuxYJOde+V6I0gj91hpazRapcc3hU=;
    b=A91WpKxzdwx+El7mkI7nYHj2q/7lUbT2ECR0uCcRAAgEyyzJFjuFXSk11OS5SLMEtb
    dIjpGPOs/BtSDZbUBNx3qwwYGA5ZgFfJG0wfEizYQGiSpETDfb38sY+M4vzHiSUII/mz
    dbGXMblxUv3Aeas2JOXnqirDyEEkK55/aTdPeeit40y4cNgaid4S6BZzskmmZxRPOEmQ
    f8Su17RRD6F23CSqEyZfz1vjGqM5YjyA8aEk1OAVw+8DKff0KSFH3Mn5LhOXko7YKAlA
    vaPlYCfJt/dCThGfiiq1BCDtCJrIC03YKqfaVIfoxW2t0Dotq/x0/Jo2SJRQaqphOH8D
    K5Fg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1726496061;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Sxh+iOlD0w2POThuxYJOde+V6I0gj91hpazRapcc3hU=;
    b=5GaanhQNL4ohUuMLovC2+syxnMlgg0ld3YrLkRGpNWgiC4J0MJhSvJd/37cefjL2Vo
    DUdFZOYU+2fJOqtCTqBw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9yWodMSN5uOHqK69ZzQ=="
Received: from tauon.atsec.com
    by smtp.strato.de (RZmta 51.2.3 AUTH)
    with ESMTPSA id f958be08GEEHIZk
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 16 Sep 2024 16:14:17 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: George Rurikov <g.ryurikov@securitycode.ru>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: MrRurikov <grurikovsherbakov@yandex.ru>,
 "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] crypto: Fix logical operator in _aead_recvmsg()
Date: Mon, 16 Sep 2024 09:14:13 -0500
Message-ID: <1749031.NF6adcYWfa@tauon.atsec.com>
In-Reply-To: <ZufuoJC8sFi9ETqZ@gondor.apana.org.au>
References:
 <20240916074422.503645-1-g.ryurikov@securitycode.ru>
 <ZufuoJC8sFi9ETqZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Am Montag, 16. September 2024, 03:38:56 GMT-5 schrieb Herbert Xu:

Hi George,

> On Mon, Sep 16, 2024 at 10:44:22AM +0300, George Rurikov wrote:
> > From: MrRurikov <grurikovsherbakov@yandex.ru>
> > 
> > After having been compared to a NULL value at algif_aead.c:191, pointer
> > 'tsgl_src' is passed as 2nd parameter in call to function
> > 'crypto_aead_copy_sgl' at algif_aead.c:244, where it is dereferenced at
> > algif_aead.c:85.
> > 
> > Change logical operator from && to || because pointer 'tsgl_src' is NULL,
> > then 'proccessed' will still be non-null
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
> > Signed-off-by: MrRurikov <grurikovsherbakov@yandex.ru>
> > ---
> > 
> >  crypto/algif_aead.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Cc Stephan.

I am not sure that this is a valid finding. An issue exists when there is 
processed != 0 and TSGL is NULL. Otherwise, the subsequent copy operation for 
this part will simply copy nothing: even if TSGL is NULL, the processed value 
is 0 and this is uses as the length parameter in the copy operation. 
Technically any copy operation is prevented in the following code that is 
invoked by the used crypto_null cipher:

static int skcipher_walk_skcipher(struct skcipher_walk *walk,
                                  struct skcipher_request *req)
{
...
	/* here we have the value of processed */
        walk->total = req->cryptlen;

...
	/* here we stop processing */
        if (unlikely(!walk->total))
                return 0;

	/* here we dereference the TSGL */
	scatterwalk_start(&walk->in, req->src);

You see, the processing stops before the dereferencing.

In any case, the check as it currently is, allows the use of, say, you request 
a tag from just the key without any AAD or input data. Mathematically this is 
a valid operation.

Thus, as of now I do not see (a) a technical issue and (b) a mathematical 
issue.

Could you please help me understand the issue you think you are seeing?

Ciao
Stephan



Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5534721E3A4
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 05:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729056986; cv=none; b=jwgwYqfRZ8YcrsDUE6tq+z42+Mq5wlwBsu7cBhR+iRH2eaL29bjUr698mf4AknFYNm+jF1rsAFAFja4QUlR2EUNwQK/GdqCy8atvEbPSqQw18/GWl8rUDYT0eTLZikW1dIArCuvDP8u3289/UKWMBy2tsPlHf2dcVb8nSEj10vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729056986; c=relaxed/simple;
	bh=YAkcNuc7w+ud53HC8+sEVfFu0Bc9K3din0o/9iVdyAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVQXNq97ee4gDmqlVL4L8aI73vmbDDaiRVqeGQcBG/WX8ZqodDME9FkrNdjOO4rzqBKys3wbuWOmFLHaNh+Tb9xDgl+B4MaNSK+Vx0I0/D7Oro5Hh36jE0EWW0+ESWYpMThun3hpgqBUtMx2q4j+YTmFsQjLOYh0YoDHYQn/gMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nRq8vJvp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nRq8vJvp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=l6KocrtSzSeGXRmVSncMMl+FJxJparTDRq6szRJdFP8=; b=nRq8vJvpptuh2IStxLuT5Rv6e7
	2n5lbe0wEMDWB+eCkPny0cVisHmNMikuTCc9s6036gv+v/SqhWmAHyyW+5ICovsDBRpZqiU8P+1p6
	DL2btsrPBTKW+VEoLmU+qc0gUwAZeiiQdNwftoCFXzH3RauTRWmDMNP+M3TwvBaDmQiGlvlocII3g
	kcwJBmU/WpGQgmzGXVQUPp/Uha5OEqAyqGvRI+s2uRw7domi8Ua9Lza8hwhedF3PLYE89a9zs21U6
	XqJmXw9y6P/5RCeIcFefMyx5GeSpldOkSMRyumgxXIsToGH8MS/HwlFEqwNN9h1cyWq2HlSLjAGM7
	yZShe4dw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t0wXm-009k1o-1I;
	Wed, 16 Oct 2024 13:36:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Oct 2024 13:36:12 +0800
Date: Wed, 16 Oct 2024 13:36:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Erhard Furtner <erhard_f@mailbox.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 81 at crypto/testmgr.c:5931
 alg_test+0x2a4/0x300 (Thinkpad T60, v6.12-rc2)
Message-ID: <Zw9QzDg5StgUflMV@gondor.apana.org.au>
References: <20241010013829.68da351d@yea>
 <20241015200850.6a1d0e2e@yea>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015200850.6a1d0e2e@yea>

On Tue, Oct 15, 2024 at 08:08:50PM +0200, Erhard Furtner wrote:
>
> v6.12-rc3 still affected. So I bisected the issue to the following commit:
> 
>  # git bisect good
> 5a72a244bac3e8663834d88bb0b4f9069203e5e0 is the first bad commit
> commit 5a72a244bac3e8663834d88bb0b4f9069203e5e0
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Sat Aug 10 14:21:02 2024 +0800
> 
>     crypto: rsa - Check MPI allocation errors
>     
>     Fixes: 6637e11e4ad2 ("crypto: rsa - allow only odd e and restrict value in FIPS mode")
>     Fixes: f145d411a67e ("crypto: rsa - implement Chinese Remainder Theorem for faster private key operation")
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
>  crypto/rsa.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> 
> Reverting 5a72a244bac3e8663834d88bb0b4f9069203e5e0 on top of v6.12-rc3 fixes the failure.

Thanks.

This patch should fix the problem and I'll push it into 6.12-rc.

commit 6100da511bd21d3ccb0a350c429579e8995a830e
Author: Qianqiang Liu <qianqiang.liu@163.com>
Date:   Fri Sep 13 22:07:42 2024 +0800

    crypto: lib/mpi - Fix an "Uninitialized scalar variable" issue
    
    The "err" variable may be returned without an initialized value.
    
    Fixes: 8e3a67f2de87 ("crypto: lib/mpi - Add error checks to extension")
    Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/crypto/mpi/mpi-mul.c b/lib/crypto/mpi/mpi-mul.c
index 892a246216b9..7e6ff1ce3e9b 100644
--- a/lib/crypto/mpi/mpi-mul.c
+++ b/lib/crypto/mpi/mpi-mul.c
@@ -21,7 +21,7 @@ int mpi_mul(MPI w, MPI u, MPI v)
 	int usign, vsign, sign_product;
 	int assign_wp = 0;
 	mpi_ptr_t tmp_limb = NULL;
-	int err;
+	int err = 0;
 
 	if (u->nlimbs < v->nlimbs) {
 		/* Swap U and V. */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

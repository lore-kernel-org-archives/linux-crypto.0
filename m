Received: from abb.hmeau.com (unknown [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0068F85931;
	Fri, 25 Apr 2025 10:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745578705; cv=none; b=KGhY1LQlffZzVrw/wLUxXB1/Dhzy5cYcx+iclyWjs0X0Tchsh+Q64LCSqpVDR67C9xM0QAH/pucK9PZSBtQNanGZeoCI/vl+sqERxPzDDcxHdf1hGKcWLwbijD8rOIGO3pEAy/Yjcr63H6Pgu0HN0Al5P5knE7z0AtCXSNVxF8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745578705; c=relaxed/simple;
	bh=kAEmEnORkLHHkbMhXVXOMVYYvukCHLHJvKP7FnbtImo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpEmxh5eBGfYba1N9lD4IJGrV5gp8n8XHeDMGSI3iHW5WIg13VvpBxE/Mmn7Md9GJZSon2ws6e4/qWZA6hZF4qklx/zOp4E+APrPr0JZUq7WtOlwNOp9kJHjO9+a8DeWD2v+q4vsy1GSztlnJgqU4SaunQJ5nu5Gxog4gMB6ans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aWuHx7NZ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aWuHx7NZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nDVNUHBnttDoV4LQjegazbEV6sgc2R3fpi2dDR9anZY=; b=aWuHx7NZ53AE1SUAMa5acl2OM3
	18ZxyH/sioXKNPd9XKV4jXxgE/qb/8gFfrQV96AAS+Rh1kHZPYOBB2mZYSpUQ5acR9t9fsXtidpDL
	5X8GY6tIpSda+60Vsihk/o/dGkFS4Son+izEzWRiI29pk5mzBBQ6QjQqmf+vn5ESlulR+tuhtL+aT
	D3Fg6nhY5yZ4B5B247FNWbSg0eiWAMnRlhwZtYIz4aQu2zG33eEMniDqLx++8dCp6ZKylafqe5Dzz
	/0S9sX32NN4Hm977v7eeApkOPIj6zhk3VOL/hrSHG3N1NPbF6/UTs6qQ9YiCicG0pF/akaEO5GiAo
	DHmF/NmQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8Gl3-000xeQ-1h;
	Fri, 25 Apr 2025 18:58:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 18:58:13 +0800
Date: Fri, 25 Apr 2025 18:58:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: arm64/sha1 - Set finalize for short finup
Message-ID: <aAtqxbkGYWRGX-Yv@gondor.apana.org.au>
References: <aAop_uMhxVh2l5Fy@Red>
 <aApN64n7i15ArnX4@gondor.apana.org.au>
 <aAqhbdiLmkHV350S@Red>
 <aAsCk3jtbAE7dPpJ@gondor.apana.org.au>
 <aAtnCR5jVAnjfR1i@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAtnCR5jVAnjfR1i@Red>

On Fri, Apr 25, 2025 at 12:42:17PM +0200, Corentin Labbe wrote:
>
> No they are still there:
> [    2.022921] alg: shash: sha1-ce test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"

Thanks, I see the problem now.  The zero-length hash doesn't
set sctx->finalize correctly:

---8<---
Always set sctx->finalize before calling finup as it may not have
been set previously on a short final.

Reported-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Fixes: b97d31100e36 ("crypto: arm64/sha1 - Use API partial block handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 1f8c93fe1e64..65b6980817e5 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -79,8 +79,10 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 		data += len - remain;
 		len = remain;
 	}
-	if (!finalized)
+	if (!finalized) {
+		sctx->finalize = 0;
 		sha1_base_do_finup(desc, data, len, sha1_ce_transform);
+	}
 	return sha1_base_finish(desc, out);
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

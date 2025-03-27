Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE30204F7D
	for <linux-crypto@vger.kernel.org>; Thu, 27 Mar 2025 08:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743063825; cv=none; b=bkOdRB8OEJO8ismx0AA2VpO7IMgGhjxbDND7BiX8HzoeYonUEcueSbJDr/xRO7v5Up48gdb/Gpf6uyL6Xed6Vfp5Hqfv73nUoE831ZtgmROFkfu0tRkHdHdtcTOvwhUH1pyPLhbgZMIqLw98lQK02x2vNA1FflceRAazDq6KnOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743063825; c=relaxed/simple;
	bh=opGpfhnvTIHYACpf3jEnc69eyG/vxMJwPzcXhIni6Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iByN9KC6eUjxHZV7a4BE3uxOhUKXE+RR9HEMxza6/VZh4UstB+btaQi/5ycRlueNJ0Kk0D/IILaUCCK2cg8HPYv8LZKLIWi4MbQ1vZwFUcCJTg9Xa73UN2+c91S5A46fvEQUSLlyLXh65xsRbVzJ2UzFpBMPaf1QqmEAXVDiHro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DukPqb3b; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DukPqb3b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/PEeTnFxfIT/Gq9Tz88JED8naTGzLw+SlQe0QNnebaE=; b=DukPqb3bKgwBTSXcrFqoQK6jxw
	oA5Mx3h5W7Hc5Vxawrx7Ir2HjBm8eIRhpksOS5nTjzQzpsIxvotGs1EoUTVc7ChBLqegNPStKmSsE
	bCWslw9gEH1dIjav4wk3jPPCv0t969H2faPKwOW1G0Q9BpZnYnYvXUvGuhixPO61+0cYX9MA+w27f
	OZP50a96Q3nKEjj7jgQxKRm2h+D7AiSmUIggNLFh/3qeAyrCPaM5BhRF1UOJcD8kBuA1rMekxxrxK
	VwYEcvCpcInhRJWromIQ7CJoZA5ckmaHMckcbDlwmVIY8EdQppAzTn/SFd5CNAoosEVSJOEHMPGQ7
	0jtloEpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txiWW-00AUPx-00;
	Thu, 27 Mar 2025 16:23:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Mar 2025 16:23:35 +0800
Date: Thu, 27 Mar 2025 16:23:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, Udit Kumar <u-kumar1@ti.com>,
	Pratham T <t-pratham@ti.com>
Subject: [PATCH] crypto: testmgr - Initialise full_sgl properly
Message-ID: <Z-ULBwaDsgWpYzmU@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <Z-P78_9NKGMBFs3s@gondor.apana.org.au>
 <20250327073427.amcyd4t6qvs7kw35@uda0497581-HP>
 <20250327081555.nhcggnqxetwbnidx@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250327081555.nhcggnqxetwbnidx@uda0497581-HP>

On Thu, Mar 27, 2025 at 01:45:55PM +0530, Manorit Chawdhry wrote:
>
> [   33.040345] sa_run: 1182: req->size: 40187, src: 00000000f1859ae0
> [   33.046426] sa_run: 1183: sgl: 00000000f1859ae0, orig_nents: -22

Thanks for the info! The filler SG initialisation was broken:

---8<---
Initialise the whole full_sgl array rather than the first entry.

Fixes: 8b54e6a8f415 ("crypto: testmgr - Add multibuffer hash testing")
Reported-by: Manorit Chawdhry <m-chawdhry@ti.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 74b3cadc0d40..455ce6e434fd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -689,7 +689,7 @@ static int build_test_sglist(struct test_sglist *tsgl,
 
 	sg_init_table(tsgl->full_sgl, XBUFSIZE);
 	for (i = 0; i < XBUFSIZE; i++)
-		sg_set_buf(tsgl->full_sgl, tsgl->bufs[i], PAGE_SIZE * 2);
+		sg_set_buf(&tsgl->full_sgl[i], tsgl->bufs[i], PAGE_SIZE * 2);
 
 	return 0;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

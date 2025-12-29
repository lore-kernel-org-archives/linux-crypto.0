Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8132AD20
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 00:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766969297; cv=none; b=czsIK3vC4KNbSYrvuBLsHJ38waPXvZR+5xGNR3S9TgePna2A1C6nUgBB+r/UJHGVHhpQZv1TC9IfThXKgFYAHMI7KFmjOSBqFeK1IlNl9+5WxdTUCeDRUqHFm+WUrrj6LeLYWGbGkQh58hq1KRBbwna8qkLal1jvHN2SEW6pCvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766969297; c=relaxed/simple;
	bh=/alkfRv202IYaK6W1P2JLq9smyYJFeOtqOd4B5ACbOs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DULpJPklqRyXQvdCOcYwrgjLU1qgcyiSSbECUGUTeJCe97Igq/lvSYdsolU55hTHCCe1I3MZnzvprvkLy4N+e+qPKUk8SPjG73IvUtOyE2LYXtBC8teMkWmNEXXpUqc+bjpqxJB5oggK/qlbEQVW0vUPy92Tn5f357up00Stt/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=g0TkTen5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="g0TkTen5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=uQ2kM76lsRxba84vR4LlsXETBHtqNJqudJeXA+fpnEc=; b=g0TkT
	en5SiybLiBaI/qo/AkRdvOWX8QhCmGLjzRttMpW7hMqMZBipE9aEZ8l3p0tKGcoYU6H219pw/wmeq
	zFupO+afF8Bt6k4U/DUuHh3zBIf2WvycaqF18HdPk+89HccHx/iYIxCSTLzbFpyf24bON68D5y4k8
	yb6ajjgD8OchXmXkFSxYT8HK1GCyRqIcYovrHDXfimxWln9qjckx7fxvzrRWoZcV3BfdOQ3plGlwq
	nJsgbvZN2gnEbTi8JpSoUnZ2EbUKfmscpbTipXMh1FLrEEF7apS2o4NyvyDun8gqOY7nkrRdiSH0c
	MOYdnibwVH0GWzswD3t/PmZu0P/yg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1va1Qf-00D0BQ-2d;
	Mon, 29 Dec 2025 08:48:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Dec 2025 08:48:09 +0800
Date: Mon, 29 Dec 2025 08:48:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: crypto: ccp - Use NULL instead of plain 0
Message-ID: <aVHPyZIUZFLMdNYU@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use NULL instead of 0 as the null pointer.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index ea29cd5d0ff9..5fd5a8fc60ed 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -241,7 +241,7 @@ static struct pci_tsm *dsm_probe(struct tsm_dev *tsmdev, struct pci_dev *pdev)
 
 	if (is_pci_tsm_pf0(pdev))
 		return tio_pf0_probe(pdev, sev);
-	return 0;
+	return NULL;
 }
 
 static void dsm_remove(struct pci_tsm *tsm)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B9A190660
	for <linux-crypto@vger.kernel.org>; Thu, 12 Sep 2024 09:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726135043; cv=none; b=asePI8vKezh7KdPoVxp0yCSoWkZkyPRh4of3ZiyBZBuTEZD17UHzb3OJ2ryDygaRO6IsFWQgwDKvSy8uLt5GvH9Mc8lcgd0blYClZIdau4ZHaF8YgKREUCqJAZti9fiIZ4OpKnoKoRtmjbA++g7zvBnjWbA672qYECss/xgyKgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726135043; c=relaxed/simple;
	bh=g16VIJZvzVL7Zg0j0pwTmyalD5m025d1F/F9gB1yEiA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kjxU2DE0xoJW5jRMUl7Ol2I8cAYgbRlbJrADACE4ufgwSZpR7GEe82YyFmW3nqbO4ZJHNi0G7Bx1YLbKxYt7qEX4ASzUZJm+N/FHX6xvFCGiSfwhbgv03KKKCi3yXrVNHZcXbkD6yzYWsCoLq+IqrgjlLDJTX3nXSu8aan6/6cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YDLbVtGJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YDLbVtGJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nD9fKtsIFcZKRxvoCH0qaLb+hUqqh62HlFJPcr5Fums=; b=YDLbVtGJ1AkVvv1BdpwOePJ7cd
	fmo0kkXZn2q5rApndzq29w7lt6yt2D3ngRP7oj9qR2buA6/IHkRUF6f4F1oIxC2F8V1Izh1sivf+4
	3ln3UdQDiom1DZe3nPExgQdNZNKMHeQl94EuLOKG67SIdaOlOH53m2doGhafJIq5rGVqkf+H/I0Ic
	EptpiYJhGTLuLx7tpVOVVpIwqbSeMKrCprbA8JSwhp49QgtQBm6P1rzhlBBLMKE8/JDqj3o76lioz
	Qii51MGDGtt3CGpzswU9lMEEhBTEr3SFcbOSC+ZfqpKS1rKnEN/vUIkNCaAc1fiQn6jJsAP5PRoHN
	7A6seeGg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sogPk-001wga-0A;
	Thu, 12 Sep 2024 17:57:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Sep 2024 17:57:13 +0800
Date: Thu, 12 Sep 2024 17:57:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Guangwu Zhang <guazhang@redhat.com>
Subject: [PATCH] crypto: caam - Pad SG length when allocating hash edesc
Message-ID: <ZuK6-TxhWfNU780D@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Because hardware will read in multiples of 4 SG entries, ensure
the allocated length is always padded.  This was already done
by some callers of ahash_edesc_alloc, but ahash_digest was conspicuously
missing.

In any case, doing it in the allocation function ensures that the
memory is always there.

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Fixes: a5e5c13398f3 ("crypto: caam - fix S/G table passing page boundary")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index fdd724228c2f..25c02e267258 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -708,6 +708,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 		       GFP_KERNEL : GFP_ATOMIC;
 	struct ahash_edesc *edesc;
 
+	sg_num = pad_sg_nents(sg_num);
 	edesc = kzalloc(struct_size(edesc, sec4_sg, sg_num), flags);
 	if (!edesc)
 		return NULL;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

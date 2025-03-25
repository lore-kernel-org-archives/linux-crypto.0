Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1B21531E8
	for <linux-crypto@vger.kernel.org>; Tue, 25 Mar 2025 08:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742890882; cv=none; b=L9loWtKjeNA64PfzD4nnuSF6RvjXjAnEsiMnNFRTIPx4X6hSNLn9Nw3wYIM/ttk9339mNYqgEzSp9YveHEBe86F29ihPfgp7dyal+OjbUdK3Cz2mcZXuIRmv+3HCAgt6jjnyaXGzz5fagmizn+53LlnvQCG9Nlw63suvEMMdp6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742890882; c=relaxed/simple;
	bh=LPVw5MYhuzI/eyunQM8EDcg4c2ik5aSJ5jFxabHXtVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wa7JCybiCVgN81oE9YEJRGHPKJhl+cNr6uEsPuvH/ECnDqm9Nx117EHgZOHO5NRcp+kjyBRyCDzkn6+aUYb30PGLAArc6yLmiL0LHLTTKfRkZ3XJ5jYxc0PSiNqfXCxzeoSch5dVZ0W3oAdjNKAqz5awRJfGtPzCfAdTuX6aSZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ENdBhwVo; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ENdBhwVo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NYMv+V5dlAremsVR7LiSqAHMI2OjTNTSWo39sz8EgAk=; b=ENdBhwVoLo3GufCofQq9RZXHxD
	Q9l6KcrYMEDUGvvQj/O2Gszw8TN9Knw6emGTYixTgeW6Xsv5ssgyc7FXgENRcKdjyGUDHdA26EdKb
	dfFqLpYz8i8KjBoIHP5m1L4EUoVOWLv449pN4p3xO0bTxKhxPArQO4+nt9urHSES879wFV1E4gNPA
	AQxDFls2oUtP6XmwCjfoAKReiq1SBormrn06NiHMmjIDMf7mhAHDWvji+4yJr3Dvh9hqC31SdXcpZ
	KyDJF2i/K5VhcXo9zp16JJnoyUQH3iRsoag7q3htU5oqKgyqw/Ivcl7C9anZgXAbJlHRicI5iUQwz
	FPXpf4BA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twzX8-009wNp-14;
	Tue, 25 Mar 2025 16:21:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Mar 2025 16:21:14 +0800
Date: Tue, 25 Mar 2025 16:21:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Srujana Challa <schalla@marvell.com>
Subject: [PATCH] MAINTAINERS: Remove Arnaud Ebalard as the address is bouncing
Message-ID: <Z-JnegwRrihCos3z@gondor.apana.org.au>
References: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
 <20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr>

On Fri, Mar 21, 2025 at 12:18:32PM +0000, EBALARD Arnaud wrote:
> Hi Herbert,
> 
> Natisbad.org mail server is indeed in extended holidays. Your change is fine w/ me but I do not have much spare time to spend on the topic anymore so I guess the best approach would be to remove me from MAINTAINERS file entirely and let the slot to someone else.

Hi Arnaud:

Thanks for your contributions.  I'll apply the following patch instead.

---8<---
Remove the entry for Arnaud Ebalard as requested.

Link: https://lore.kernel.org/linux-crypto/20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/MAINTAINERS b/MAINTAINERS
index f8fb396e6b37..faffa211ed0d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14010,7 +14010,6 @@ F:	include/uapi/drm/armada_drm.h
 
 MARVELL CRYPTO DRIVER
 M:	Boris Brezillon <bbrezillon@kernel.org>
-M:	Arnaud Ebalard <arno@natisbad.org>
 M:	Srujana Challa <schalla@marvell.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

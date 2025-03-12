Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A00F1DB366
	for <linux-crypto@vger.kernel.org>; Wed, 12 Mar 2025 04:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741753807; cv=none; b=cvKa/DMoTDtzFYDb/7DWLMMLXtcEXgpEMh4QrXO2OmxL9Wlre2Dv5sieBUzI4kjA0shmKs+ZN65ONnvRdmxSQdUGBng7RGlfOqkrY5wV0AtjNCUAeN5Nli34gT9MCtjrgNW3kKg0s18QhubFjU/13s495QcD9vsS+nc/1/diO0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741753807; c=relaxed/simple;
	bh=++MpVsVyuiMplNau+auUQXket0z/iwKfcWk0V0Ur0AU=;
	h=Date:Message-Id:From:Subject:To:Cc; b=LzRcpokw0Y1PnOo78WKEfpqQWVOAqiZYJvsddQJcFXnqGmHs8syx7By6bH9HHgl2v+kWmAHytoMgMkt6TFn5ghV0b1L5CUsGX75Idnt7RgyVS2ar3MW6eRyy//jbxpyyxacznodPPy88CFY0PONbNxW73jNgtMFBmUmiXpU9ySI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XKgl5oOA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XKgl5oOA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rgHaTD49hLpWv3Q5PcMWVHPMm9FIa5n4OeQg+lek70I=; b=XKgl5oOAu9phkEgXUFIEq4QgDO
	6LJnaiLZW66KLtstq90YaWh3xydsf0RkVop0BOxB58Md7TsYLvsWZV4Bn3Cv1YsuhtKclJoyJ/Oe3
	x+6V82Y+bETfO+sbrpdDLAaCM2c7j4OYXQ+RFXNPPh+3T/gIO9EBZJdFMV8ElWaT+VBFojSLVBAwl
	jKJpviC5jen3ihFBSNG88H7iwEkfDq+Q7rttukbmhatUt/P06HQa6o8CGHy/Hq+8yj/fcK8N4T1Au
	w0Uujq8/7OFFQ8iW6kbS95qUIS5T+H1nvxPQnI1QaFpt4tmQ2jcJQ4Vpff1jMit4fthcyYxbwdGPK
	FcV6irUw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsDj9-005mXH-1o;
	Wed, 12 Mar 2025 12:29:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Mar 2025 12:29:55 +0800
Date: Wed, 12 Mar 2025 12:29:55 +0800
Message-Id: <cover.1741753576.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/2] crypto: Use nth_page instead of doing it by hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v2 removes the krb5 patch and changes the code so that nth_page is
only called if HIGHMEM is enabled.  Also switch to from page_address
to lowmem_page_address.

This patch series is based on top of:

https://patchwork.kernel.org/project/linux-crypto/patch/20250310172016.153423-1-ebiggers@kernel.org/

Curiously, the Crypto API scatterwalk incremented pages by hand
rather than using nth_page.  Possibly because scatterwalk predates
nth_page (the following commit is from the history tree):
    
        commit 3957f2b34960d85b63e814262a8be7d5ad91444d
        Author: James Morris <jmorris@intercode.com.au>
        Date:   Sun Feb 2 07:35:32 2003 -0800

            [CRYPTO]: in/out scatterlist support for ciphers.

Fix this by using nth_page.

Herbert Xu (2):
  crypto: scatterwalk - Use nth_page instead of doing it by hand
  crypto: hash - Use nth_page instead of doing it by hand

 crypto/ahash.c               | 42 +++++++++++++++++++++++-------------
 include/crypto/scatterwalk.h | 21 +++++++++++-------
 2 files changed, 40 insertions(+), 23 deletions(-)

-- 
2.39.5


Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB302FFDD5
	for <linux-crypto@vger.kernel.org>; Tue,  9 Sep 2025 05:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757396499; cv=none; b=OG4Z8fMKup64VZrn2iXz75cNfBXABUSAyPNNrQoq0kTJdzw4NdmqQasNnAR6E/niUoa0so3qWC/EhXyvFXNQFZvRRP9I0FP3qpLiwwco3O2959jn+G66aNQ8Os6oINkOCuslSmg60TjQkCUntm7f0HnWbSa34X3jcOcY89yVQfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757396499; c=relaxed/simple;
	bh=ttMPb/pL1WSQ3+7D1JFlEK45y9Hf376HPge5ZO29vk8=;
	h=Date:Message-Id:From:Subject:To:Cc; b=bpOkPv1RGVArNr1cEaYTLUocqh9wCkdQLfy0Wj0J/P1KYZJdFTCzCxsJNefEVlFDV7Ze9G02gYRKx3wwudWUZK8PWKDg6sWM9KgL8Sz4gg06N9LETB1ZqQNkyGalm4CW0BW9kbZOsgMXOo7gW9O5wcfKY+uEL8mSPt8T7ZUMkYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=X2mgHKuL; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="X2mgHKuL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Fh5+bs5GvTKP47hZHMTvCZeiDmnBaes1AfgqAEF1D/A=; b=X2mgHKuL6RS3ar0tyXxf9wbuMe
	WNYpP8th31WYy6Yh6hH+u/3Hq5ll4FXW5uHgaxqU+6NtLbN+bcFI8PMHkZ85tloV5o2joIQkVjtXH
	rVmbMZMggygCuLySxn5HDYOAcwsEAKND+oyBkxpucbVNGfA07/ELqTeXiG1GXB01b9LxrOTK7sfE4
	YaX8Md2Eo0qa0dyfjN57fmrkgWZpJ29mezRV58yhTXusgApmlGVonXhvTZz+4KvW2ORsTZSIcBrJc
	NbGuuhM13UfXix8ZqKT1Naejx6dJ9SSrcQ06vLLC0gTPySYgIdNV44j+iYYJ5ctqSRXiu/L1srqqY
	KMX8Ukgw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uvqrH-003qId-0K;
	Tue, 09 Sep 2025 13:41:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 Sep 2025 13:41:31 +0800
Date: Tue, 09 Sep 2025 13:41:31 +0800
Message-Id: <cover.1757396389.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/2] crypto: ahash - Allow async stack requests when specified
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v2 fixes the inverted tests that broke everything.

This patch series adds support for passing stack requests down
to algorithms that do not do DMA on the request context, e.g.,
phmac.

Herbert Xu (2):
  crypto: ahash - Allow async stack requests when specified
  crypto: s390/phmac - Allow stack requests

 arch/s390/crypto/phmac_s390.c  |  1 +
 crypto/ahash.c                 | 22 ++++++++++++++++++----
 include/crypto/internal/hash.h |  3 +++
 3 files changed, 22 insertions(+), 4 deletions(-)

-- 
2.39.5


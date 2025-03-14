Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BFA5223
	for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2025 03:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741922846; cv=none; b=o2qlmf1nSmqv5IuKRYxCEsMWIvCgIXkIiq8QLhFUkH/DTMZhyuwuyFNRcllqyPKoRPydEAVbfzK5VPTu4+QZGWMlSCD2SQCEj97zSNvhaiIxR9M5LoNfb+7D2pYoxomxOejp0Zql1q1wodS27GNGUWrJLu3uF9QxGoPH4yIPXmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741922846; c=relaxed/simple;
	bh=0Afg531DmxMlZBoR5w8rXY0M1RhnNKsZ02VLxnejD3E=;
	h=Date:Message-Id:From:Subject:To:Cc; b=YlD+Wfwa9ZhdGmwFfwaGAAYs4QVYnV+VmE2Bri9G8d+S3BGq2Xec+cKUvU2jXZYDy9xp6UXuhBeOajabjZsBjBWIbEvq+29E8f54KiIBd3fMDmA1UBM6stazvqb0cncQK3meXldQpJFP1TLTXDhlQTTl0MQOCnyQMC5bmjCGutM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Fh64gxfz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Fh64gxfz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MhqZNuPoJP38W3yUM1Pqj8M8k7wlTDJDQm904MkS3Pk=; b=Fh64gxfzYNsL0lGfr7DnZZU8Lv
	Tt/7qnutLPPre7ZHLgw1qAUmQPmZrakaFG/IyswLXlta1Y7cAD80a1xrSm2TXH+/kyPp7AH7+UFUx
	9SpNmiAhrzkeuvwOlH082N1Ivj0g/CZt4kU6plmnEdZ+LgOwI+uwEY4DRDVK00VzuB1CNnVZQK5Td
	BNTXEaWz5exJH8d/QBvK/Zvu80UNVJu7Ayncbibn3vkNfdwrH3wKM10yYiCyNBT4Jbt2zx2BDVb6o
	NkKc8fAmvnKAyqe26e0wddYGMcR3u+ZOyvvpiszAZf6PuAVIsvNrGrCABhtaQPPXU3GZw9BdPQIsZ
	eyYuwhKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsvhe-006S89-1p;
	Fri, 14 Mar 2025 11:27:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Mar 2025 11:27:18 +0800
Date: Fri, 14 Mar 2025 11:27:18 +0800
Message-Id: <cover.1741922689.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 0/2] crypto: Use nth_page instead of doing it by hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v4 removes the unrelated changes and restores nth_page.

This patch series is based on top of:

https://patchwork.kernel.org/project/linux-crypto/patch/b4b00e0fed2fe0e48a0d9b2270bed7e29b119f6a.1741842470.git.herbert@gondor.apana.org.au/

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

 crypto/ahash.c               |  4 ++--
 include/crypto/scatterwalk.h | 30 ++++++++++++++++++++----------
 2 files changed, 22 insertions(+), 12 deletions(-)

-- 
2.39.5


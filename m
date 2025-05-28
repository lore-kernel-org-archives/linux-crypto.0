Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3C6B67F;
	Wed, 28 May 2025 03:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748401412; cv=none; b=RvswoZWoDgzap9uKs73Lul4GdIBVUzU0ugkmh/2sYyHVLQCdKcI7boSUedBhWjYXxPAd/b6hJkULjixGLzKPRQY3e/ffVFLRGFWvMuzxpKju0R9dIKM3ulBJxosI/CUbyJpjE5VW1VLsvaIumYAvFtQcpnsXuzg4lu2vc9XrXQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748401412; c=relaxed/simple;
	bh=vw4tpSyUWZj2lLpNQC+OehFPzLnew3DIc2sffloq36Q=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=div+bmOs8rzKEB+e7+B5SnSbpxdBsZWtNFqFbT02gVDSekG46nIHlHX8Rki61177hq6hPw3aW6Wphs9nUwk2sveoGTVOCTTux8s5rdzzSPZXmww/Q5OyabZDOQhH02uSYygdbbgOMmpvuepHDYU6J9fwIojqIKm7CfqxrYZ1OvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TlRqKbUV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TlRqKbUV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MahgvY8xQ6K2XZOMfAzg24LiOTV+7t/YLOtjWGRZtwI=; b=TlRqKbUV2UlVi0Ndz1rY4G3ZPP
	vCNgtpHNy21ACqKDHCLZA2EVrt9rvqfmJckMYL4z1ArwfZu63mmgt2c9WJHOQB2Y4IyjoGz3AE5TP
	IYD2j9lZbDf5mDRCCF3g1/u7mQ75rf5m3qc5IgijmnzZhQeF8ueAKyTFvnWTDLTQKzPPSYH34qpfp
	4PQA8UUXlW/T5Bf/9hwqFrYiZALKk/qfoMf18JLLNHNXGDXMLlsgez6wZiehVi9h/FHsL39gPrZxi
	h8P31As5YHS6pBNNIYLjKNuW4abNPpA0OT2q6l5HZ8MhtVhrnz648Mm7PUOcS6Ug1R8cPRASYXFMA
	Qoiy3T9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uK74W-009NBL-2R;
	Wed, 28 May 2025 11:03:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 28 May 2025 11:03:16 +0800
Date: Wed, 28 May 2025 11:03:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <aDZ89Fs8Y20_fj2I@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 2297554f01df6d3d4e98a3915c183ce3e491740a:

  x86/fpu: Fix irq_fpu_usable() to return false during CPU onlining (2025-05-26 10:58:50 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p2

for you to fetch changes up to 0a84874c7e7dde5cdddc80a82093120e924a348b:

  crypto: shash - Fix buffer overrun in import function (2025-05-27 13:43:32 +0800)

----------------------------------------------------------------
This push fixes a buffer overflow regression in shash.
----------------------------------------------------------------

Herbert Xu (1):
      crypto: shash - Fix buffer overrun in import function

 crypto/shash.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

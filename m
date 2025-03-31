Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86B8A92E;
	Mon, 31 Mar 2025 04:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743396627; cv=none; b=TVA4p+62GAJ7ZnDN/l/jGKzwnvhsG5uYOAPrjlbxdRN+ivdz5DVwRZG7by4LZmSn+DM39ax4b3jBIUbkFWgZF6u/MTUuIPOyM4l04nG1ytcpzsE92WzfU5T5LCc+14opfE0mTu2jJL7RO0YumjnVihaxgRHgrpDs/USb/1dRyUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743396627; c=relaxed/simple;
	bh=ry5gJkS7iEIufVKl5ogsvvf+80cxgFsbRQeo9flAVCI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzNLxqlfX3Khfk/ESYjXbH3CaLfcuIxtTM35/UMdH7+AK5S5yB0t/xfMurrIR+DBnHNBwqbU91pxIev1+4HCAlX/YIzjsBQXc3HS0Hcrf5ZlVWtKzE1oWPDFxFYTFH1emJ7X36u3G/K8gwsd9hSQWiaGzk2kQBomFajVy5Oo7Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CtWb2iib; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CtWb2iib"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=p2sOsRmcwft9JJsO6ockWj6I8aOHNij3gdh9D514i5w=; b=CtWb2iibP7K12fcSuJq3YQYmCF
	V1p8DeoNqOWhUpNHwntdX2Fvbftd/ZKVEe7QDmXU5nrmaV/eWdOkXnjUkhflSqLZQfrqJPUhh8oob
	EyrXReplJMF35DaGZ5DtKPSTyodIhsgaXmhyf2j91nM9rAlRLrJf7X+hBpBag1lekthiF3dXu1GaT
	mGubUTlhAuAW2SxDtj892TFAFV8iwJdzI6QuuV2oasoeJRxMs9nVPI0ulsJZl8ljgrz+ec/gVNE1N
	kE8437z5qkxs0xTbZbAbuXGBplOHGFmlGBHR3MT8SE9jJnULjwBFHBHdId9LeD5NDQQrV2jdHUL2r
	uLVdHORA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tz768-00BTCI-05;
	Mon, 31 Mar 2025 12:50:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 31 Mar 2025 12:50:08 +0800
Date: Mon, 31 Mar 2025 12:50:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.15
Message-ID: <Z-ofAGzvFfuGucld@gondor.apana.org.au>
References: <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z11ODNgZwlA9vhfx@gondor.apana.org.au>

Hi Linus:

The following changes since commit 99585c2192cb1ce212876e82ef01d1c98c7f4699:

  crypto: testmgr - Add multibuffer acomp testing (2025-03-22 07:25:19 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.15-p2 v6.15-p2

for you to fetch changes up to 9764d5b0cd0ea4846fd46c7d0b4238ea122075a9:

  Revert "crypto: testmgr - Add multibuffer hash testing" (2025-03-30 09:39:57 +0800)

----------------------------------------------------------------
This push fixes reverts the multibuffer hash testing as it is buggy.
----------------------------------------------------------------

Herbert Xu (1):
      Revert "crypto: testmgr - Add multibuffer hash testing"

 crypto/testmgr.c | 157 +++++++++----------------------------------------------
 1 file changed, 24 insertions(+), 133 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

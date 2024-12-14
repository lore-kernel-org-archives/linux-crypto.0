Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FDB17BA0;
	Sat, 14 Dec 2024 09:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734168089; cv=none; b=hTApofoh1js2ljjSEgJWoa/+qwBA0Mwd8+y9gIWcsSTnaDnZ9ZsE/ForBB0rD6m0hUPZsVrOEu/4RsZ0XoUSIwozAsUxUUAdGUy91/MsYGxkEoeHlIPHf0Ti1CkbA813ftTNrzoNZfkQP1aP3s9myfg/44UCux9r0Nf5DkZZ3Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734168089; c=relaxed/simple;
	bh=stomrM7KNWsV/q1Ak3xOQa2fGK8/LKkFPWWxNBq0x6w=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXLOZq5GlZVbf6yymUQobSzyPFxWDoVNqWsbQBC79Dkul89ydI/8CiyiNNtURwr6iGxfuXDJAeo83endIaHuBSuvhMqtsnPTfEZkfr7ztJ0rpsv1UjS5QPuTbdrWQknj8rmkM51Xatr4UmcTQguMthm9HqqSgR1Q0EdlfESXyoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fqt0aRom; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fqt0aRom"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mlP5cwOIgfJSi8cK2LugjBNTBhUeNvibdK00SQ0XqGM=; b=fqt0aRomngsLnweVcvawcDfRpu
	bodglMNvnHSlcwaReRmva3vViQ+Hbe6ZwQsichWQQ0tn8iDQA7WwfYjaRFU5sguHc2rOa7kYGutMN
	VJ0Bjk4VnV91d5L9wOdlfV2iFH+Z9Rx5kqJ56531Vo4AjQadZaPWSc0FnwCla5BxiB0IXh4GH6pdK
	MooIKY6A+laBlvJ8fbeLUw69m36qCLH6TFiqNzjC8T7C09CiHpGszoW/q0tYqxvk8njKVsuFs1UO/
	Pj3DFXs+1MIkpXYd5+2ZjAyFlVkGAN2xNfEcMq9ESP78ErZWUaQR8vQO3U0aUFr2jV6zNt99ue9SW
	kr2pFrSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tMO7v-001TJ7-1d;
	Sat, 14 Dec 2024 17:21:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Dec 2024 17:21:16 +0800
Date: Sat, 14 Dec 2024 17:21:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.13
Message-ID: <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
References: <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>

Hi Linus:

The following changes since commit fac04efc5c793dccbd07e2d59af9f90b7fc0dca4:

  Linux 6.13-rc2 (2024-12-08 14:03:39 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.13-p2 

for you to fetch changes up to cd26cd65476711e2c69e0a049c0eeef4b743f5ac:

  crypto: hisilicon/debugfs - fix the struct pointer incorrectly offset problem (2024-12-10 13:40:25 +0800)

----------------------------------------------------------------
This push fixes a regression in rsassa-pkcs1 as well as a buffer
overrun in hisilicon/debugfs.
----------------------------------------------------------------

Chenghai Huang (1):
      crypto: hisilicon/debugfs - fix the struct pointer incorrectly offset problem

Herbert Xu (1):
      crypto: rsassa-pkcs1 - Copy source data for SG list

 crypto/rsassa-pkcs1.c              | 45 ++++++++++++--------------------------
 drivers/crypto/hisilicon/debugfs.c |  4 ++--
 2 files changed, 16 insertions(+), 33 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

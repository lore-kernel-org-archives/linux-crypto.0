Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4160B18871E;
	Fri, 15 Nov 2024 11:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731671529; cv=none; b=FiW2fraAKmTJMfvgdWS4mZwZiYgi1c9DhP4w240yaKVfpxV76g5eTIHQKn+HAk6o1G5x0WBHVuYFrF8lNCWSH+1+mUa/mkM9g6u/QYclBZbOQwd+F+5YCBlM2tWyQC8Sl6FxfzxAEPBkqKL1tad3dyFK44MF0nP8yntl4JbN9es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731671529; c=relaxed/simple;
	bh=7d07MOtJA5T28dl4jE2qkLrkDhHazd6IdjA9Ok4D52Q=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKVyguBuOCkTqEuT4clgRNhNIHXZYUqgT9tkMm28Yggi/gBVsqF7c8DzXHkSxSfU93+T6hriZ36FYWVUnxpza2PF5Xy8sMFAec7dJm6iNrfdATNXpuDABh8xZSYcGRxerMwCTldguDO7bevT9ceGDM3ZYL1cElHk0ljeQFOgU/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=s+Y20BAD; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="s+Y20BAD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xg2gWNXSG2k2cejhKXt/rqKvl8xor5hlZe+I7Qifmso=; b=s+Y20BADM5B6qEMOlS459kuxMr
	Kb+kTbN4fuaHKlHI9CX1Jik6KOfpebncbPo4VmKsC2Fmg9aizeVmN/TCzWb4rheUflVRWa77gVZNg
	Yj4UUkI6IUn2msbY9Fi82Eh5Xyz9N+wdMBba94pihXtwQSA/4Xe8uky4zL/FVCkb2HaHuasXfylO2
	+GAF/hJ6saLXeP0mCLEi8etwp2gepcMr2LshDL9y5+Ae5iOMCJRCuhGmayW/xdmPC8blnDYo0uG3i
	Vp/COQj20m4Pq9AQnNBKTQ5mxwWF/utXTO9T2dW+edu6V6dHaj7d1WEBZYXBRzK2twpE3jhd59QAF
	TCcQ9Ilg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBurm-00H1sM-1u;
	Fri, 15 Nov 2024 19:51:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 19:51:58 +0800
Date: Fri, 15 Nov 2024 19:51:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.12
Message-ID: <Zzc13mpEUC-BblD4@gondor.apana.org.au>
References: <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Zw9RM_jNu9vqp9T8@gondor.apana.org.au>
 <ZxXqbFAO9VN3ugIR@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxXqbFAO9VN3ugIR@gondor.apana.org.au>

Hi Linus:

The following changes since commit cd843399d706411ff80520fb7883afeeefa76e98:

  crypto: lib/mpi - Fix an "Uninitialized scalar variable" issue (2024-10-16 13:38:16 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p5 

for you to fetch changes up to dd41b283ef2f028e414312706b48f2880b7050b5:

  crypto: mips/crc32 - fix the CRC32C implementation (2024-10-26 14:39:30 +0800)

----------------------------------------------------------------
This push fixes a regression in the MIPS CRC32C code.
----------------------------------------------------------------

Eric Biggers (1):
      crypto: mips/crc32 - fix the CRC32C implementation

 arch/mips/crypto/crc32-mips.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

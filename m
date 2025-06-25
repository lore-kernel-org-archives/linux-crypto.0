Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531A014AD2B;
	Wed, 25 Jun 2025 02:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750819457; cv=none; b=nkPZiHVVRXlj/wMgMr2gCzBN+dS6VIc4PVK13EhDaY2dyEH3lRkN9o5GqjD7o1l3oNL0O1ie2cArbRMWemwkRnjuPGyGgbvb/55HtcmX2O9VM+Ue9MFJv6JZsyhdcV8zLVXUcEoX08PwDk/+Tpf2duaJYDuZd9LaGmBRomDlHKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750819457; c=relaxed/simple;
	bh=Uj6BRmQsqj6LzHkv1+ewCgd6Dwv0jYNnVOUkOfeM/zk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jsJcWRQ1cwjTucxfVvduD5F6ZIGpaZS9pt2VAvsdRT8VLtJU/bqsftuH1yYdwYUvbEr/GGNt9GzSm59TfGMiEfrMQS0MQu/wOmAfiOOGgIMlaZoUvGZPVq3aW1SIq5O70DPw/RcchseKJxv0sUj4rbTEn6aGNjSNZXkHil8vv/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TmxSDD3d; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TmxSDD3d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yip0S/AEqNBtDtVbWCPn0pFQVh4kqKZ7CGXWmDuWay8=; b=TmxSDD3dmVK9Y0z1Ym297mbm+m
	A7k2qc5vqTX0nbbfSh8YdBQIaSp0nELkz4JGv6NS3tjIXE8RHpd+rXOOYYfGyrmL67KP5trFm1Ks5
	J9gqUZfsEK1D3XnxB0pBr0xaNNvf9tQUktIaXy7ZZL8vW/wMhGoeXvzae42YheWM4u3nTeqUJLUWM
	rcDvXqvRripmPznkIGzUAcwOS7AS5upcg6VBtXDD18x/dR7bEgAYCXEbDSVZHtlJTiTrc0x+vt2w/
	cvC0IjgLbXu9JbiYHzhRtPYTlIWYEs5/AuWccRX4bgLZuXTOiXoQQE4VMsV04tBhNpp5VImOv6x2D
	3Q5tQ4Ag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uUFrs-000mXi-1n;
	Wed, 25 Jun 2025 10:44:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 Jun 2025 10:44:04 +0800
Date: Wed, 25 Jun 2025 10:44:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <aFtidDP6MLX1V2A6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit df29f60369ccec0aa17d7eed7e2ae1fcdc9be6d4:

  crypto: ahash - Fix infinite recursion in ahash_def_finup (2025-06-18 17:02:02 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p6

for you to fetch changes up to 20d71750cc72e80859d52548cf5c2a7513983b0d:

  crypto: wp512 - Use API partial block handling (2025-06-23 16:56:56 +0800)

----------------------------------------------------------------
This push fixes a regression where wp512 can no longer be used
with hmac.
----------------------------------------------------------------

Herbert Xu (1):
      crypto: wp512 - Use API partial block handling

 crypto/wp512.c | 125 ++++++++++++++++++++++-----------------------------------
 1 file changed, 47 insertions(+), 78 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

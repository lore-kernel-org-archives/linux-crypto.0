Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2C219A7A;
	Wed, 18 Mar 2026 07:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820238; cv=none; b=cyjDp24aa00ppDG8hiYiFQJQgLdhyZTHXxDdHMdGeNal+95PvvRwFRSQiVaTTZLIJ/cRNuiWoy5Hkjy2bZPTtCd5ll+k1OtVxe7kGvcVHIGQNag4KuJzqZhNSibOc2QXJjm2Qpain00RKdkFg1kvs5h2ztzpWgr0RaqzNK3Ecz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820238; c=relaxed/simple;
	bh=o+QBX1GaYf7eCPekfiertQqywwH+UzRfqsRfO5+Smzk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZuOw7955yZcufCBNTDNwQxwrvzUl2jQ1yrwjuuJSknwWM1s83aYiX5311ZHmwLohrtkm7wO8n8yX/oM8oSBJLVEYA2dPWBDhrUaPHNU/+12Xmu20wIe0JZAaCoST824vJREHoof6k9N0l69G/iMW3bI14h+xAFjrETQpDhcqVeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gFi/9uuU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gFi/9uuU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:To:From:Date:cc:to:subject:message-id:date:from
	:content-type:reply-to; bh=RUX7FE8DpCTKHNgyjfkNhw4NG9hKxFo8Ck79K6dPl4k=; b=gF
	i/9uuUPDXoaarob+AoVsSRBxT61yLTgJci4omp17w5s80FcX+D3y+Q8q94woOH63F4Jv6BdQ12qyL
	jYtEKHTjv4x7Dcr1rxTmmnahA0OKR6yAioFdfbYFWsN8VyjFJ9Av+GUSYKfmNadNnBlPSwzS6/PTa
	+rc55c6s4G+C1QSXs7eO+wMq8zE0gZcnkgtHUTcQvdQ1Mk9Tg1RjS+qRmDSFI0vwlrrUmyvgXBWJv
	4FUcxS5msMQdFAWN206Y1M4qjxI4CbJoZ2oZC7DBvKnQaPc0YH0atsUnALoa9zapqIq5hab0/ApGU
	UwKg2JPKC04mtj4uLDWeJipygsYdGP8g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w2lfh-00FMch-1I;
	Wed, 18 Mar 2026 15:50:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 18 Mar 2026 16:50:29 +0900
Date: Wed, 18 Mar 2026 16:50:29 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.0
Message-ID: <abpZRauhYoKH-f54@gondor.apana.org.au>
References: <aapDn5mYeL861_6n@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aapDn5mYeL861_6n@gondor.apana.org.au>

Hi Linus:

The following changes since commit d240b079a37e90af03fd7dfec94930eb6c83936e:

  crypto: atmel-sha204a - Fix OOM ->tfm_count leak (2026-02-28 12:53:25 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.0-p3

for you to fetch changes up to 5c52607c43c397b79a9852ce33fc61de58c3645c:

  crypto: ccp - Fix leaking the same page twice (2026-03-14 14:01:37 +0900)

----------------------------------------------------------------
This push contains the following changes:

- Remove duplicate snp_leak_pages call in ccp.
----------------------------------------------------------------

Guenter Roeck (1):
      crypto: ccp - Fix leaking the same page twice

 drivers/crypto/ccp/sev-dev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

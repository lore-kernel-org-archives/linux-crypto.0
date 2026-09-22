Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680CA314D05;
	Tue, 22 Sep 2026 03:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790046988; cv=none; b=Vbs/6W1qk9kyoTuu/aasoYERpnTEU4/R3HuE3ysgkni9YTgr900xJC2pyncUHUeBLp1vbALYLSu9P5c3629K+W9+y3CdX0Vk38rqKcGSU0tOvMKFCqCmH5BllO1kXxoouImqNlZkYd9MY2xf5ua8+2/UPF3AYWFtUlp1X1pvskM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790046988; c=relaxed/simple;
	bh=sGnqVDWjj+7WhFEp594i1kozchQ+d/mGUnj1BqT9OcE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJrZTklNO519N//SYAmGsA2kV9nHRo5bJTLGq7VBJQ5RplYOarcX6y6khARHEYH3bpA6j/M1tPwsWyCNMRRUJo32bEwJ1dTcWV0upaF/S8Vtut84awZ6S4RFcogbibiXEXBP9l1wE9CmLpKOGLjI/tbAHIAI3h0pknK729WPH/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=eeERGhMY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="eeERGhMY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:To:From:Date:cc:to:subject:message-id:date:from
	:content-type:reply-to; bh=VeXnwiJ+eGNinja/882snEHMH3LgMWQgE20uTunacLU=; b=ee
	ERGhMYEnXl+rA6FALtSNKgS+1PfpLbmi5i43OdCzgvn5W6hlXoR9nCNehM7znMUqndPHtkCcJn7iQ
	5otEFqCX7DKa6tqRUQ6twr5PvGNGRmKby9jB/IfBCJ403oH+esFPlIAHdHyDfbVwY02y0nhP9tVfN
	x6s0OqIeGwlFtfN9cmSY8kSWySfiXm+0YmZT1k5TntNKesXx6+BzhWOydvEXUsNnQbPMA3MYIcD/c
	WVwbzRiwZCtviYuQCH2rTMCgI1Ye6Mx2ARB+5Nd7hdimKN30+0J6UGed56HAmqDNxG6/4qHFpjQmE
	ijgnkaJQVc5MwNAcCyzhoGv5/nDuDYYg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x8qzL-0000000GURy-1v1E;
	Tue, 22 Sep 2026 11:16:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Sep 2026 13:16:11 +1000
Date: Tue, 22 Sep 2026 13:16:11 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.3
Message-ID: <arHy-64aKoBskSIp@gondor.apana.org.au>
References: <aq0LWN4cVftl8r5p@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0LWN4cVftl8r5p@gondor.apana.org.au>

Hi Linus:

The following changes since commit 53cf0f26eece095a3752642151150404bc3351cc:

  crypto: caam - map job ring registers without claiming region (2026-09-16 19:55:13 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p5

for you to fetch changes up to 10396a2d6d41d594975b6ece712278570c3c970c:

  crypto: s390/hmac - Generate intermediate CV for API partial block handling (2026-09-19 11:52:05 +1000)

----------------------------------------------------------------
This push fixes an hmac hashing bug on s390.
----------------------------------------------------------------

Holger Dengler (1):
      crypto: s390/hmac - Generate intermediate CV for API partial block handling

 arch/s390/crypto/hmac_s390.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

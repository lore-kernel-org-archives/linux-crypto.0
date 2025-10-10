Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D3423D7FC;
	Fri, 10 Oct 2025 12:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760098882; cv=none; b=mhXvlo38va1rCL1GK3+XfQD7OY389LkwujqU8kKIFIIyejIPHWtMgm5KSKy4oXpAYP4HKumdu6kJcLe46QlJqYoTo6Hne0DrYu/8r+8+hWjRNPx2rZqCQwlmawjoj6Qot9q5L56evSAgMzeaKkUODIWiriLysuEUoIP0+XgzelE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760098882; c=relaxed/simple;
	bh=f9L7zhzAnXXfnNNyUZTA1kqF7B9ZiXQDJUpg7Yma138=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Fd/EXa58h7flGC3uMFDBFIEyU0i9S/GKwmvnMuLzLte+FzMspQ4XW6RnRxkaZm46rC0msFD80boJPY2u3SRmzP4gnpFmckpBp2GgAZl7VzLHI6NUIzcqgmT3Cr3W67kz5AXjQv5r9GJAEWCxIEA0N+alskx6irmPOLF+ro+V9Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KZNRGRGf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KZNRGRGf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=UHAG8oD6VlfPwpNIB//e81NoaomE3IWVH+FR9PROA5g=; b=KZNRG
	RGfLb8oFJwAi8J1YdDf6Bg6C+pNxLSjdvbB8YT9Y1X9Dd4k+o2/BXcvUYpPGdSM4Je3zxWTOSvhqq
	0PgjR/nYnZV8gTrytFkHawlihPmNaB2jWuVE+qyaDkS+Cr5LVBslarv/hXQkV8bDC+Bfcdu3sGdlp
	dRxg/9dy64vuLlW5lE0ils1xG/AjoPYtTRxXysfHj8h+63Qs+kTVKMdyPweiqws+2KC44vYkX66Rq
	9M2XFPBkVkakRMqLB1ZJECGm2+uL/k1UgxaLlkj3W06HP+NiHlxi5kcE2W2OGUENosig8u7wHfXG3
	rbQ1ufWOeptxAl4FYzYjAWNyWe22g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v7BSe-00Bisf-0k;
	Fri, 10 Oct 2025 19:39:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Oct 2025 19:39:00 +0800
Date: Fri, 10 Oct 2025 19:39:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.18
Message-ID: <aOjwVEx6xDDRKiAx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit c0d36727bf39bb16ef0a67ed608e279535ebf0da:

  crypto: rng - Ensure set_ent is always present (2025-10-06 10:17:07 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p3

for you to fetch changes up to 6bb73db6948c2de23e407fe1b7ef94bf02b7529f:

  crypto: essiv - Check ssize for decryption and in-place encryption (2025-10-09 15:02:35 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Fix bug in crypto_skcipher that breaks the new ti driver.
- Check for invalid assoclen in essiv.
----------------------------------------------------------------

Herbert Xu (1):
      crypto: essiv - Check ssize for decryption and in-place encryption

T Pratham (1):
      crypto: skcipher - Fix reqsize handling

 crypto/essiv.c    | 14 ++++++--------
 crypto/skcipher.c |  2 ++
 2 files changed, 8 insertions(+), 8 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

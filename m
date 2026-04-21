Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CC238422F;
	Tue, 21 Apr 2026 08:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761620; cv=none; b=MIZB4MiRk+jKDdMbqnBcqVobCfmThnwmtfZIFhERHyLOpbOzKuDKcPN9oqOdVHYeKPQ+VSfNlwbKt5xacmL0Ep9Gf7poVQvWw6eAzMws9cYP2pcLwATxEHhKGDB4pA68eFcC/mavKCoyWet/1CUpbsTnrcA7xWz6GcAz3peCaxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761620; c=relaxed/simple;
	bh=NG7Q+ecprAHHn9ZT3hiAeW4pf8zTiiEzaaQRfpJZhFo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QDu6hQ2w8p2jiRV+TlQMTDyndHAhxYyowDhIjk0h3fchfh7yCFtJUWswIdyByea2OuRJEMzoMIX3olhy5n2CtgwFrIhbySzOAfBJHD718lYA6WLenjKYf0FF4BywTTjH+8rTxYfhUN+hEuvdyjgcWPRDxyV4fp01yis4m5ncDxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Gfays5Y1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Gfays5Y1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=szEtreKuGuHu/ZnlUQcNQc+mZbZS2uGko7eIPegFOM8=; b=Gfays
	5Y1bZiqUpb+/UTy6G8lkb2WF1aDM8vKA4AFScjkqIlYVD6h0KLt9cyEcBZhSFuLTSVK2OdSDcQeVp
	P4FMOndJDRCDxj6C+GARqzIeo1QvfeZMDwiWgCj6wstT1VvUv9vznpdqiX65fNM5hZ9CMfGKyTS3m
	MqRBY/5feBislFkPMFsjzIonrj2Uy+m85NenqhaFr/5062kN/bea/hWVxUK84zV2ANXah0hL/oWK/
	98LEDjo5fmtklqHrM55mva6SfDF+i8y1qxHekVYtoW3eE8pO3Tc1Zl3Kp6TuguuOAD8/sRR04SW7m
	YXDswmIMwrjw60C5XNDDx+DPK85XA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wF6rC-007epE-1Y;
	Tue, 21 Apr 2026 16:53:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Apr 2026 16:53:22 +0800
Date: Tue, 21 Apr 2026 16:53:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.1
Message-ID: <aec7Aj9lhK3YGZjF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit aec2f682d47c54ef434b2d440992626d80b1ebdc:

  Merge tag 'v7.1-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2026-04-15 15:22:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p2

for you to fetch changes up to 3bfbf5f0a99c991769ec562721285df7ab69240b:

  crypto: krb5enc - fix async decrypt skipping hash verification (2026-04-20 16:18:58 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Fix IPsec ESN regression in authencesn.
- Fix hmac setkey failure in eip93.
- Guard against IV changing in algif_aead.
- Fix async completion handling in krb5enc.
- Fix fallback async completion in acomp.
- Fix handling of MAY_BACKLOG requests in pcrypt.
- Fix issues with firmware-returned values in ccp.
----------------------------------------------------------------

Aleksander Jan Bajkowski (1):
      crypto: eip93 - fix hmac setkey algo selection

Douya Le (1):
      crypto: algif_aead - snapshot IV for async AEAD requests

Dudu Lu (1):
      crypto: krb5enc - fix async decrypt skipping hash verification

Giovanni Cabiddu (1):
      crypto: acomp - fix wrong pointer stored by acomp_save_req()

Herbert Xu (2):
      crypto: authencesn - Fix src offset when decrypting in-place
      crypto: pcrypt - Fix handling of MAY_BACKLOG requests

Paul Moses (1):
      crypto: ccp - copy IV using skcipher ivsize

Sean Christopherson (3):
      crypto: ccp: Don't attempt to copy CSR to userspace if PSP command failed
      crypto: ccp: Don't attempt to copy PDH cert to userspace if PSP command failed
      crypto: ccp: Don't attempt to copy ID to userspace if PSP command failed

T Pratham (1):
      crypto: sa2ul - Fix AEAD fallback algorithm names

 crypto/acompress.c                                |  8 ++--
 crypto/algif_aead.c                               | 10 ++++-
 crypto/authencesn.c                               |  6 ++-
 crypto/krb5enc.c                                  | 52 ++++++++++++++---------
 crypto/pcrypt.c                                   |  7 ++-
 drivers/crypto/ccp/ccp-crypto-aes.c               |  7 ++-
 drivers/crypto/ccp/sev-dev.c                      | 19 ++++++++-
 drivers/crypto/inside-secure/eip93/eip93-common.c |  2 +-
 drivers/crypto/sa2ul.c                            |  4 +-
 9 files changed, 76 insertions(+), 39 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

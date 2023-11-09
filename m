Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFAED287
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 04:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEE7269E;
	Wed,  8 Nov 2023 20:30:43 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r0wge-00Fd8s-OA; Thu, 09 Nov 2023 12:30:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Nov 2023 12:30:43 +0800
Date: Thu, 9 Nov 2023 12:30:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.7
Message-ID: <ZUxgc8jIBEgc9CMc@gondor.apana.org.au>
References: <Yr1XPJsAH2l1cx3A@gondor.apana.org.au>
 <Y0zcWCmNmdXnX8RP@gondor.apana.org.au>
 <Y1thZ/+Gh/ONyf7x@gondor.apana.org.au>
 <Y7fmtJHWT1Zx+A1j@gondor.apana.org.au>
 <ZARrt99wJb7IhoY4@gondor.apana.org.au>
 <ZFeldCJcieIlXKJ8@gondor.apana.org.au>
 <ZHQe9A8CC93iCFMG@gondor.apana.org.au>
 <ZKtH5zrS4pR22PGT@gondor.apana.org.au>
 <ZOLcCC523FoBAyv0@gondor.apana.org.au>
 <ZPAiMYaqUslSyZ6+@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPAiMYaqUslSyZ6+@gondor.apana.org.au>

Hi Linus:

The following changes since commit a312e07a65fb598ed239b940434392721385c722:

  crypto: adiantum - flush destination page before unmapping (2023-11-01 12:58:42 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.7-p2 

for you to fetch changes up to 9aedd10fe38418319bd8ed55dc68a40ec04aaa05:

  crypto: ahash - Set using_shash for cloned ahash wrapper over shash (2023-11-07 16:44:36 +0800)

----------------------------------------------------------------
This push fixes a regression in ahash and hides the Kconfig
sub-options for the jitter RNG.
----------------------------------------------------------------

Dmitry Safonov (1):
      crypto: ahash - Set using_shash for cloned ahash wrapper over shash

Herbert Xu (1):
      crypto: jitterentropy - Hide esoteric Kconfig options under FIPS and EXPERT

 crypto/Kconfig | 28 +++++++++++++++++++++++++---
 crypto/ahash.c |  1 +
 2 files changed, 26 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

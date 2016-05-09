From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.6
Date: Mon, 9 May 2016 16:46:37 +0800
Message-ID: <20160509084637.GA6056@gondor.apana.org.au>
References: <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
 <20160330091150.GA17143@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49151 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbcEIIqr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 May 2016 04:46:47 -0400
Content-Disposition: inline
In-Reply-To: <20160330091150.GA17143@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

- Bug in ahash SG list walking that may lead to crashes.
- Resource leak in qat.
- Missing RSA dependency that causes it to fail.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (1):
      crypto: hash - Fix page length clamping in hash walk

Tadeusz Struk (3):
      crypto: qat - fix invalid pf2vf_resp_wq logic
      crypto: qat - fix adf_ctl_drv.c:undefined reference to adf_init_pf_wq
      crypto: rsa - select crypto mgr dependency

 crypto/Kconfig                                 |    1 +
 crypto/ahash.c                                 |    3 ++-
 drivers/crypto/qat/qat_common/adf_common_drv.h |   11 ++++++++++
 drivers/crypto/qat/qat_common/adf_ctl_drv.c    |    6 ++++++
 drivers/crypto/qat/qat_common/adf_sriov.c      |   26 +++++++++++++++---------
 5 files changed, 36 insertions(+), 11 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

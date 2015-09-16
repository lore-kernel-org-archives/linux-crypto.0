From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 0/3] crypto: [sha] Restructure x86 sha trasforms glue code
 to expose all available transform algorithms
Date: Wed, 16 Sep 2015 16:34:32 -0700
Message-ID: <1442446472.6240.1.camel@schen9-desk2.jf.intel.com>
References: <cover.1442451609.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Sean Gulley <sean.m.gulley@intel.com>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34325 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbbIPXed (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2015 19:34:33 -0400
In-Reply-To: <cover.1442451609.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


During the posting of patches of new x86 sha1 and sha256 algorithms based
on new x86 SHA extensions, I got requests to expose all the available
sha transform implementations that are based on SSSE3, AVX and AVX2 as
separate individual crypto driver.  The result is this series of patches.
I've also performed clean up of the glue code to make them easier to
maintain.

Thanks.

Tim

Pre-req patch series:
[1] https://lkml.org/lkml/2015/9/10/554

Tim Chen (3):
  crypto: [sha] Restructure x86 sha1 glue code to expose all the
    available sha1 transforms
  crypto: [sha] Restructure x86 sha256 glue code to expose all the
    available sha256 transforms
  crypto: [sha] Restructure x86 sha512 glue code to expose all the
    available sha512 transforms

 arch/x86/crypto/sha1_ssse3_glue.c   | 324 +++++++++++++++++++++++++++--------
 arch/x86/crypto/sha256_ssse3_glue.c | 331 ++++++++++++++++++++++++++++++------
 arch/x86/crypto/sha512_ssse3_glue.c | 249 ++++++++++++++++++++++-----
 3 files changed, 735 insertions(+), 169 deletions(-)

-- 
1.7.11.7

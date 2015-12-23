From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: KEYS: convert public key to the akcipher
 api
Date: Wed, 23 Dec 2015 10:33:43 +0800
Message-ID: <20151223023343.GA31104@gondor.apana.org.au>
References: <201512200735.x3U85zQL%fengguang.wu@intel.com>
 <5678684F.2020308@gmail.com>
 <20151222120919.GA25163@gondor.apana.org.au>
 <56795CFF.1080106@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tstruk@gmail.com>,
	kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53983 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbbLWCdy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Dec 2015 21:33:54 -0500
Content-Disposition: inline
In-Reply-To: <56795CFF.1080106@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 22, 2015 at 06:23:59AM -0800, Tadeusz Struk wrote:
>
> What about the first two. This one is completely unrelated.
> It only supposed to fix some random configuration issue
> reported by a build robot, which isn't really important now.
> The other two convert the module verifier to the new API.

No this compile breakage was introduced by your first two patches
because you changed crypto/public_key.h which is used by entities
outside of your patch.

So fix your first two patches by not breaking existing users
of it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

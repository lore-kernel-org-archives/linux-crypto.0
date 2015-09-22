From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 10/29]
 arch/x86/crypto/sha256_ssse3_glue.c:172:19: error: 'X86_FEATURE_SHA_NI'
 undeclared
Date: Tue, 22 Sep 2015 11:39:31 +0800
Message-ID: <20150922033931.GB7851@gondor.apana.org.au>
References: <201509182205.JCClhKfv%fengguang.wu@intel.com>
 <20150918151757.GA10835@gondor.apana.org.au>
 <1442592721.6240.15.camel@schen9-desk2.jf.intel.com>
 <20150921140254.GA2141@gondor.apana.org.au>
 <1442869290.6240.17.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40159 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791AbbIVDjj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 23:39:39 -0400
Content-Disposition: inline
In-Reply-To: <1442869290.6240.17.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 21, 2015 at 02:01:30PM -0700, Tim Chen wrote:
>
> Thanks.  Will this patch series go in the 4.3 or 4.4 time frame?

It's for 4.4.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

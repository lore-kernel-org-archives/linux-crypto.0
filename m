From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 10/29]
 arch/x86/crypto/sha256_ssse3_glue.c:172:19: error: 'X86_FEATURE_SHA_NI'
 undeclared
Date: Mon, 21 Sep 2015 22:02:54 +0800
Message-ID: <20150921140254.GA2141@gondor.apana.org.au>
References: <201509182205.JCClhKfv%fengguang.wu@intel.com>
 <20150918151757.GA10835@gondor.apana.org.au>
 <1442592721.6240.15.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36367 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbbIUODC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 10:03:02 -0400
Content-Disposition: inline
In-Reply-To: <1442592721.6240.15.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tim:

On Fri, Sep 18, 2015 at 09:12:01AM -0700, Tim Chen wrote:
>
> It seems like Thomas has already merged the cpu id patch upstream.
> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=488ca7d72d974e3c00ae73ed9f947590680bdf00
> 
> Can you merge that patch into cryptodev and re-apply?

Thanks for the heads up.  I have rebased on rc2 and reapplied your
seven patches.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

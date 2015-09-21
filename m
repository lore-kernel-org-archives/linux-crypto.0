From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [cryptodev:master 10/29]
 arch/x86/crypto/sha256_ssse3_glue.c:172:19: error: 'X86_FEATURE_SHA_NI'
 undeclared
Date: Mon, 21 Sep 2015 14:01:30 -0700
Message-ID: <1442869290.6240.17.camel@schen9-desk2.jf.intel.com>
References: <201509182205.JCClhKfv%fengguang.wu@intel.com>
	 <20150918151757.GA10835@gondor.apana.org.au>
	 <1442592721.6240.15.camel@schen9-desk2.jf.intel.com>
	 <20150921140254.GA2141@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11925 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576AbbIUVCD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 17:02:03 -0400
In-Reply-To: <20150921140254.GA2141@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2015-09-21 at 22:02 +0800, Herbert Xu wrote:
> Hi Tim:
> 
> On Fri, Sep 18, 2015 at 09:12:01AM -0700, Tim Chen wrote:
> >
> > It seems like Thomas has already merged the cpu id patch upstream.
> > http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=488ca7d72d974e3c00ae73ed9f947590680bdf00
> > 
> > Can you merge that patch into cryptodev and re-apply?
> 
> Thanks for the heads up.  I have rebased on rc2 and reapplied your
> seven patches.

Herbert,

Thanks.  Will this patch series go in the 4.3 or 4.4 time frame?

Tim

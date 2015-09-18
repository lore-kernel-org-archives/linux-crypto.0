From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [cryptodev:master 10/29]
 arch/x86/crypto/sha256_ssse3_glue.c:172:19: error: 'X86_FEATURE_SHA_NI'
 undeclared
Date: Fri, 18 Sep 2015 09:12:01 -0700
Message-ID: <1442592721.6240.15.camel@schen9-desk2.jf.intel.com>
References: <201509182205.JCClhKfv%fengguang.wu@intel.com>
	 <20150918151757.GA10835@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1649 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbbIRQMD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 12:12:03 -0400
In-Reply-To: <20150918151757.GA10835@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2015-09-18 at 23:17 +0800, Herbert Xu wrote:
> On Fri, Sep 18, 2015 at 10:36:07PM +0800, kbuild test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> > head:   dcde21287f931b6cee61825306db6a5665566f66
> > commit: a3476db1b524f2e2d869b001c56ba9ce353d860e [10/29] crypto: x86/sha - Add build support for Intel SHA Extensions optimized SHA1 and SHA256
> > config: x86_64-randconfig-x015-09141022 (attached as .config)
> > reproduce:
> >   git checkout a3476db1b524f2e2d869b001c56ba9ce353d860e
> >   # save the attached .config to linux build tree
> >   make ARCH=x86_64 
> 
> Tim, I've rolled back all your patches as they depend on a patch
> that has not yet been merged.
> 
> Please resubmit them when the prerequisite is ready.

Herbert,

It seems like Thomas has already merged the cpu id patch upstream.
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=488ca7d72d974e3c00ae73ed9f947590680bdf00

Can you merge that patch into cryptodev and re-apply?

Thanks.

Tim

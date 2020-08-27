Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6D8C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13B8C20786
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgH0IGX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:06:23 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34294 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgH0IGX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 04:06:23 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kBCv0-0005hu-RK; Thu, 27 Aug 2020 18:06:00 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Aug 2020 18:05:58 +1000
Date:   Thu, 27 Aug 2020 18:05:58 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
Message-ID: <20200827080558.GA3024@gondor.apana.org.au>
References: <202008271145.xE8qIAjp%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008271145.xE8qIAjp%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 11:52:50AM +0800, kernel test robot wrote:
> 
> First bad commit (maybe != root cause):
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   15bc20c6af4ceee97a1f90b43c0e386643c071b4
> commit: 5fb8ef25803ef33e2eb60b626435828b937bed75 crypto: chacha - move existing library code into lib/crypto
> date:   9 months ago
> config: i386-randconfig-r015-20200827 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=1 build):
>         git checkout 5fb8ef25803ef33e2eb60b626435828b937bed75
>         # save the attached .config to linux build tree
>         make W=1 ARCH=i386 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    lib/crypto/chacha.c: In function 'chacha_permute':
> >> lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>       65 | }
>          | ^

This doesn't happen with a normal configuration.  To recreate
this warning, you need to enable both GCOV_KERNEL and UBSAN.

This is the minimal gcc command-line to recreate it:

gcc -Wframe-larger-than=1024 -fprofile-arcs -fsanitize=object-size -c -O2 chacha.c

If you take away either profile-arcs or sanitize=object-size then
the problem goes away.

Any suggestions?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

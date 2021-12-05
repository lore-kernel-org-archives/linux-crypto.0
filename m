Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AD4C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Dec 2021 23:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239942AbhLEXGk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Dec 2021 18:06:40 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57468 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229918AbhLEXGk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Dec 2021 18:06:40 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1mu0X0-0006jU-20; Mon, 06 Dec 2021 10:02:55 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Dec 2021 10:02:53 +1100
Date:   Mon, 6 Dec 2021 10:02:53 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     Peter Gonda <pgonda@google.com>, thomas.lendacky@amd.com,
        kbuild-all@lists.01.org, David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        John Allen <john.allen@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH V5 5/5] crypto: ccp - Add SEV_INIT_EX support
Message-ID: <20211205230253.GA3049@gondor.apana.org.au>
References: <20211203144642.3460447-6-pgonda@google.com>
 <202112040501.zlOm5XQW-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202112040501.zlOm5XQW-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 04, 2021 at 05:25:25AM +0800, kernel test robot wrote:
> Hi Peter,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on herbert-cryptodev-2.6/master]
> [also build test ERROR on herbert-crypto-2.6/master kvm/queue linus/master v5.16-rc3 next-20211203]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]

So this still seems to be broken.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

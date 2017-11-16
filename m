From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] chcr: Add support for Inline IPSec
Date: Thu, 16 Nov 2017 18:06:28 +1100
Message-ID: <20171116070628.GA21071@gondor.apana.org.au>
References: <1510226941-20472-1-git-send-email-atul.gupta@chelsio.com>
 <201711161235.7CcyCmC8%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Atul Gupta <atul.gupta@chelsio.com>, kbuild-all@01.org,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, Harsh Jain <harsh@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:38130 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750814AbdKPHGv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Nov 2017 02:06:51 -0500
Content-Disposition: inline
In-Reply-To: <201711161235.7CcyCmC8%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 16, 2017 at 01:19:52PM +0800, kbuild test robot wrote:
> Hi Atul,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on next-20171115]
> [cannot apply to v4.14]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Atul-Gupta/cxgb4-Add-support-for-Inline-IPSec-Tx/20171112-012558
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: x86_64-randconfig-g0-11160917 (attached as .config)
> compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/crypto/chelsio/chcr_core.o: In function `chcr_uld_tx_handler':
> >> drivers/crypto/chelsio/chcr_core.c:195: undefined reference to `chcr_ipsec_xmit'
>    drivers/crypto/chelsio/chcr_core.o: In function `chcr_uld_add':
> >> drivers/crypto/chelsio/chcr_core.c:169: undefined reference to `chcr_add_xfrmops'

Atul, can you fix this and resubmit your patches please?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

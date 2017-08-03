From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Request for Comments about Chained-IV feature in Linux crypto
 framework
Date: Thu, 3 Aug 2017 11:59:40 +0800
Message-ID: <20170803035940.GA11211@gondor.apana.org.au>
References: <858B57D94E9DE244922C3CF355D7FFD65179BF4C@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "m-crypt@saout.de" <m-crypt@saout.de>,
        Milan Broz <gmazyland@gmail.com>,
        "Keating, Brian A" <brian.a.keating@intel.com>,
        "Will, Brian" <brian.will@intel.com>,
        "Li, Weigang" <weigang.li@intel.com>,
        "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: "Yu, Wenqian" <wenqian.yu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57978 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdHCD7z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Aug 2017 23:59:55 -0400
Content-Disposition: inline
In-Reply-To: <858B57D94E9DE244922C3CF355D7FFD65179BF4C@SHSMSX104.ccr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 03, 2017 at 01:12:32AM +0000, Yu, Wenqian wrote:
> Hi, Herbert and all,
> 
> For saving the offload cost of symmetric cipher to hardware accelerator, we have a proposal (chained-IV) to batch multiple SG with different IV into one skcipher request, which also benefits SW implementation. The existing skcipher with SG list in crypto framework is treating all SG in the SG list as one single buffer to symmetric crypto operation with same IV.  In some use case the IV for each SG is different (e.g. dm-crypt, the IV for each sector is different). Could you please give quick comments on the below proposal before implementation?

We've had this discussion already.  The current plan is to use
explicit IV generators, as seen here

https://patchwork.kernel.org/patch/9803473/

So please help review the existing patches and if there are any
inadequacies, please comment.

Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

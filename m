From: "Yu, Wenqian" <wenqian.yu@intel.com>
Subject: RE: Request for Comments about Chained-IV feature in Linux crypto
 framework
Date: Sun, 6 Aug 2017 22:07:16 +0000
Message-ID: <858B57D94E9DE244922C3CF355D7FFD65179FDA3@SHSMSX104.ccr.corp.intel.com>
References: <858B57D94E9DE244922C3CF355D7FFD65179BF4C@SHSMSX104.ccr.corp.intel.com>
 <20170803035940.GA11211@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "dm-crypt@saout.de" <dm-crypt@saout.de>,
        Milan Broz <gmazyland@gmail.com>,
        "Keating, Brian A" <brian.a.keating@intel.com>,
        "Will, Brian" <brian.will@intel.com>,
        "Li, Weigang" <weigang.li@intel.com>,
        "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "Yu, Wenqian" <wenqian.yu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:13090 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751345AbdHFWHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Aug 2017 18:07:23 -0400
In-Reply-To: <20170803035940.GA11211@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for the information, Herbert.  Let me check see the detail of explicit IV generators.

Thanks,
- Wenqian

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
Sent: Thursday, August 3, 2017 12:00 PM
To: Yu, Wenqian <wenqian.yu@intel.com>
Cc: linux-crypto@vger.kernel.org; dm-devel@redhat.com; m-crypt@saout.de; Milan Broz <gmazyland@gmail.com>; Keating, Brian A <brian.a.keating@intel.com>; Will, Brian <brian.will@intel.com>; Li, Weigang <weigang.li@intel.com>; Cabiddu, Giovanni <giovanni.cabiddu@intel.com>
Subject: Re: Request for Comments about Chained-IV feature in Linux crypto framework

On Thu, Aug 03, 2017 at 01:12:32AM +0000, Yu, Wenqian wrote:
> Hi, Herbert and all,
> 
> For saving the offload cost of symmetric cipher to hardware accelerator, we have a proposal (chained-IV) to batch multiple SG with different IV into one skcipher request, which also benefits SW implementation. The existing skcipher with SG list in crypto framework is treating all SG in the SG list as one single buffer to symmetric crypto operation with same IV.  In some use case the IV for each SG is different (e.g. dm-crypt, the IV for each sector is different). Could you please give quick comments on the below proposal before implementation?

We've had this discussion already.  The current plan is to use explicit IV generators, as seen here

https://patchwork.kernel.org/patch/9803473/

So please help review the existing patches and if there are any inadequacies, please comment.

Thanks.

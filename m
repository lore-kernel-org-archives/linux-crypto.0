From: "Yu, Wenqian" <wenqian.yu@intel.com>
Subject: RE: Request for Comments about Chained-IV feature in Linux crypto
 framework
Date: Thu, 3 Aug 2017 01:24:27 +0000
Message-ID: <858B57D94E9DE244922C3CF355D7FFD65179BFAD@SHSMSX104.ccr.corp.intel.com>
References: <858B57D94E9DE244922C3CF355D7FFD65179BF4C@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "dm-cyrpt@saout.de" <dm-cyrpt@saout.de>,
        "Keating, Brian A" <brian.a.keating@intel.com>,
        "Will, Brian" <brian.will@intel.com>,
        "Li, Weigang" <weigang.li@intel.com>,
        "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "Yu, Wenqian" <wenqian.yu@intel.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27524 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751185AbdHCBYd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Aug 2017 21:24:33 -0400
In-Reply-To: <858B57D94E9DE244922C3CF355D7FFD65179BF4C@SHSMSX104.ccr.corp.intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Format it to plaintext and resend it as HTML subpart is treated as SPAM or Outlook Virus by the system.

Thanks,
- Wenqian


From: Yu, Wenqian 
Sent: Thursday, August 3, 2017 9:13 AM
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au; dm-devel@redhat.com; m-crypt@saout.de; Milan Broz <gmazyland@gmail.com>; Keating, Brian A <brian.a.keating@intel.com>; Will, Brian <brian.will@intel.com>; Li, Weigang <weigang.li@intel.com>; Cabiddu, Giovanni <giovanni.cabiddu@intel.com>; Yu, Wenqian <wenqian.yu@intel.com>
Subject: Request for Comments about Chained-IV feature in Linux crypto framework

Hi, Herbert and all,

For saving the offload cost of symmetric cipher to hardware accelerator, we have a proposal (chained-IV) to batch multiple SG with different IV into one skcipher request, which also benefits SW implementation. The existing skcipher with SG list in crypto framework is treating all SG in the SG list as one single buffer to symmetric crypto operation with same IV.  In some use case the IV for each SG is different (e.g. dm-crypt, the IV for each sector is different). Could you please give quick comments on the below proposal before implementation?

1) Add a new flag CRYPTO_TFM_REQ_CHAINED_IV for chained IV request.

2) Reuse the existing iv in skcipher_request structure to include all the IVs for each different sg with agreement that the first block size length data of IV is for the data in first sg and so on. Same as aead_request.
struct skcipher_request {
        unsigned int cryptlen;
        u8 *iv;

        struct scatterlist *src;
        struct scatterlist *dst;

        struct crypto_async_request base;

        void *__ctx[] CRYPTO_MINALIGN_ATTR;
};

3) No API change but implementation change required inside of skcipher API to handle chained-IV support and API should inforce the same number of IV elements as that of SG elements.

Thanks,
- Wenqian

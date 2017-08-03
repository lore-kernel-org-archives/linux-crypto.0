From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/3] Update support for XTS-AES on AMD CCPs
Date: Thu, 3 Aug 2017 14:27:31 +0800
Message-ID: <20170803062731.GT12039@gondor.apana.org.au>
References: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58566 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdHCG1i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:27:38 -0400
Content-Disposition: inline
In-Reply-To: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 25, 2017 at 02:21:12PM -0500, Gary R Hook wrote:
> The following series adds support for XS-AES on version 5 CCPs, both
> 128- and 256-bit, and enhances/clarifies/simplifies some crypto layer
> code.
> 
> Changes since v2:
>  - Move a CCP v5 fix out of this patch series and submit independently
>  - In the unit-size check patch:
>     - Edit comments
>     - Remove unnecessary variable
>     - Delay a change (that belongs in the CCP v5 patch)
> 
> Changes since v1:
>  - rework the validation of the unit-size; move to a separate patch
>  - expand the key buffer to accommodate 256-bit keys
>  - use xts_check_key() in the crypto layer
> 
> 
> ---
> 
> Gary R Hook (3):
>       crypto: ccp - Add a call to xts_check_key()
>       crypto: ccp - Rework the unit-size check for XTS-AES
>       crypto: ccp - Add XTS-AES-256 support for CCP version 5

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

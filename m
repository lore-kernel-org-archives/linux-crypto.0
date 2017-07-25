From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH v3 0/3] Update support for XTS-AES on AMD CCPs
Date: Tue, 25 Jul 2017 17:43:08 -0500
Message-ID: <e937bd4c-bbf5-88c5-1708-1095a5b825ae@amd.com>
References: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0050.outbound.protection.outlook.com ([104.47.32.50]:16416
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751804AbdGYWnr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 18:43:47 -0400
In-Reply-To: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/25/2017 02:21 PM, Hook, Gary wrote:
> The following series adds support for XS-AES on version 5 CCPs, both
> 128- and 256-bit, and enhances/clarifies/simplifies some crypto layer
> code.

Herbert:

Oops. The last patch in this series depends upon a fix that was sent 
just prior
to this. This series won't fully apply to cryptodev-2.6 without it, and thus
will have to wait until "Fix XTS-AES-128 support on v5 CCPs" is processed.

Sorry about that.

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
>
>
>  drivers/crypto/ccp/ccp-crypto-aes-xts.c |   92
> +++++++++++++++++--------------
>  drivers/crypto/ccp/ccp-crypto.h         |    2 -
>  drivers/crypto/ccp/ccp-ops.c            |    2 +
>  3 files changed, 53 insertions(+), 43 deletions(-)
>
> --

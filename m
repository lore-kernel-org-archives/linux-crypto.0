From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH V3 1/2] crypto: ccp - Use only the relevant interrupt bits
Date: Thu, 20 Apr 2017 16:25:28 -0500
Message-ID: <f7dbfe96-02d1-e8f0-9316-00c87ad69283@amd.com>
References: <20170420202004.4792.47388.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Hook, Gary" <Gary.Hook@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:22848
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1033520AbdDTVZl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 17:25:41 -0400
In-Reply-To: <20170420202004.4792.47388.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/20/2017 03:20 PM, Hook, Gary wrote:
> Each CCP queue can product interrupts for 4 conditions:
> operation complete, queue empty, error, and queue stopped.
> This driver only works with completion and error events.


Apologies for this errant submission. Please ignore one of these (V3 1/2);
the proper pair, with cover letter, is right behind this one.

Not that there's anything wrong with this one, only that it
went out without a cover letter.

...and now I see that there's a typo. Dang it.

>
> Cc: <stable@vger.kernel.org> # 4.9.x-
>
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---

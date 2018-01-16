From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH] crypto: mxs-dcp: Add empty hash export and import
Date: Tue, 16 Jan 2018 18:33:14 +0100
Message-ID: <08646712-9fc0-4f61-3f3d-31fc7cb6cf90@partner.samsung.com>
References: <CGME20180116161641eucas1p1f776ccf0d08da2d3b670e5b2ad550ea6@eucas1p1.samsung.com>
        <4f3389a1-d6aa-b3cc-2299-d638058ddd48@partner.samsung.com>
        <fbdc8a2b-4ed3-cc1c-246f-10c3c05a2ab0@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Marek Vasut <marex@denx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48748 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeAPRdV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 12:33:21 -0500
In-reply-to: <fbdc8a2b-4ed3-cc1c-246f-10c3c05a2ab0@denx.de>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 16.01.2018 17:56, Marek Vasut wrote:
> On 01/16/2018 05:16 PM, Kamil Konieczny wrote:
>> Crypto framework will require async hash export/import, so add empty
>> functions to prevent OOPS.
> 
> Shouldn't this be handled on the subsystem level with some
> 
> if (foo->bar)
>  foo->bar();
> 
> instead?

I am sorry, I should write more elaborate description for patch.

It is handled by subsystem. Most drivers have them, and testmgr is testing for 
export/import and drivers without them fail internal crypto tests,
so I prepared patch which removed these two wrappers from crypto framework.

In summary: export/import are now required, so crypto framework can work properly.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

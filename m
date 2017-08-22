From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: Re: [PATCH 0/6] Add support for ECDSA algorithm
Date: Tue, 22 Aug 2017 19:14:59 +0300
Message-ID: <87fcb3cf-b8ae-47de-550e-c76ae47af431@microchip.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
 <20170123142417.GD19957@gondor.apana.org.au>
 <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com>
 <20170202135721.GA5289@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Nitin Kumbhar <nkumbhar@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:45241 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdHVQPV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 12:15:21 -0400
In-Reply-To: <20170202135721.GA5289@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert,

On 02/02/2017 03:57 PM, Herbert Xu wrote:
> Yes but RSA had an in-kernel user in the form of module signature
> verification.  We don't add algorithms to the kernel without
> actual users.  So this patch-set needs to come with an actual
> in-kernel user of ECDSA.

ECDSA can be used by the kernel module signing facility too. Is there
any interest in using ECDSA by the kernel module signing facility?

Thanks,
ta

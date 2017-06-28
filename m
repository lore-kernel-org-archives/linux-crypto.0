From: David Gstir <david@sigma-star.at>
Subject: Re: [RFC PATCH 1/2] crypto: caam - properly set IV after {en,de}crypt
Date: Wed, 28 Jun 2017 11:03:50 +0200
Message-ID: <75D616EC-B298-4DF2-8991-7CD48E16EF44@sigma-star.at>
References: <20170602122446.2427-1-david@sigma-star.at>
 <20170602122446.2427-2-david@sigma-star.at>
 <VI1PR0401MB2591177E3F43DEFA8AEA3D6D98C40@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <VI1PR0401MB2591CC6A245731D9D53D42A598DD0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Dan Douglass <dan.douglass@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: =?utf-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdF1JDw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 05:03:52 -0400
In-Reply-To: <VI1PR0401MB2591CC6A245731D9D53D42A598DD0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Horia,

> On 28 Jun 2017, at 10:32, Horia Geantă <horia.geanta@nxp.com> wrote:
> 
>>> +	sg_pcopy_to_buffer(req->dst, nents, req->info, ivsize,
>>> +			   req->nbytes - ivsize);
>> 
>> scatterwalk_map_and_copy() should be used instead.
>> 
> David, IIUC this is the only change needed in this patch (applies both
> for encryption and decryption, of course).
> Will you formally resubmit?

Thanks for the reminder. I did not get arround it yet.
Will send the new patch within the next few hours.

Thanks,
David

From: Atul Gupta <atul.gupta@chelsio.com>
Subject: Re: [RFC crypto v3 0/9] Chelsio Inline TLS
Date: Tue, 23 Jan 2018 13:42:00 +0530
Message-ID: <cf066030-2193-6b4f-05ae-afe7ead52ca7@chelsio.com>
References: <1513769582-25786-1-git-send-email-atul.gupta@chelsio.com>
 <20180121221602.GA527@bistromath.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        ganeshgr@chelsio.com, netdev@vger.kernel.org, davem@davemloft.net,
        davejwatson@fb.com
To: Sabrina Dubroca <sd@queasysnail.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:47390 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbeAWIMQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jan 2018 03:12:16 -0500
In-Reply-To: <20180121221602.GA527@bistromath.localdomain>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Monday 22 January 2018 03:46 AM, Sabrina Dubroca wrote:
> 2017-12-20, 17:03:02 +0530, Atul Gupta wrote:
>> RFC series for Chelsio Inline TLS driver (chtls.ko)
>>
>> Driver use the ULP infrastructure to register chtls as Inline TLS ULP.
> I don't think drivers should be registering their own ULP. TLS
> offloading should be transparent to userspace, whatever HW ends up
> being used. If each driver implements its own ULP, the application has
> to be aware of what HW and what driver it's running on.
using different ULP is derived from 
https://patchwork.kernel.org/patch/9746381/
> I think this offload should rely on a generic infrastructure, not
> build its own private interface. Look at the current kTLS code, the
> proposal for an offload infrastructure [0] from Mellanox, and see how
> you can fit your driver into that, and extend what's missing.
>
> [0] https://patchwork.ozlabs.org/patch/849984/
The driver indeed used the proposed offload infrastructure and extended 
for Inline Rx/Tx
>
>
> [...]
>> Atul Gupta (9):
>>    chtls: structure and macro definiton
>>    cxgb4: Inline TLS FW Interface
>>    cxgb4: LLD driver changes to enable TLS
>>    chcr: Key Macro
>>    chtls: Key program
>>    chtls: CPL handler definition
>>    chtls: Inline crypto request Tx/Rx
>>    chtls: Register the ULP
>>    Makefile Kconfig
> That patchset is split so that each patch touches a separate set of
> files, and the description of the contents of each patch is very
> limited.  Can you try to group your changes by feature instead?  That
> should help you come up with descriptive commit messages as well.
Made all attempts to group the contents based on functionality, the set 
is broken into
driver registration, I/O with crypto Inline request, key handling and 
messages exchanged with
hardware.
>
> Thanks,
>

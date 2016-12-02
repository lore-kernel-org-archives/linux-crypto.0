From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell - Don't copy hash operation twice into
 the SRAM
Date: Fri, 2 Dec 2016 16:44:12 +0100
Message-ID: <4e3bb363-5e9f-ef7c-8f8a-0d1efca451c4@free-electrons.com>
References: <20161201162157.14563-1-romain.perier@free-electrons.com>
 <87shq7iph2.fsf@free-electrons.com>
 <064940be-9de0-ed74-a243-e8feb9bc5866@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:37857 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753466AbcLBPpg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2016 10:45:36 -0500
In-Reply-To: <064940be-9de0-ed74-a243-e8feb9bc5866@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Le 02/12/2016 à 09:58, Romain Perier a écrit :
> Hi,
>
> Le 01/12/2016 à 17:27, Gregory CLEMENT a écrit :
>> Hi Romain,
>>
>>  On jeu., déc. 01 2016, Romain Perier
>> <romain.perier@free-electrons.com> wrote:
>>
>>> No need to copy the template of an hash operation twice into the SRAM
>>> from the step function.
>>>
>>
>> Does this patch fix a bug ot it is jsute a cleanup/improvement?
>>
>> If it is a bug you should CC stable and add use the Fixes tag.
>>
>> Gregory
>
>
> No, it just removes a initialization that is done twice. I have checked,
> it cannot overwrite the context of the operation that was previously
> copied (by the for loop), so it does not fix anything.
>
>

Well, I have a second fix that depends on this one. The second fix
will be marked as "Fixes" (to be backported to stable) so it would 
introduce a ordering issue. I think that I will resend a patch series 
with these two patches and tag both as "Fixes". Please ignore this patch 
for now.


Regards,
Romain

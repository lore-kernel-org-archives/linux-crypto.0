From: karthik <karthik@techveda.org>
Subject: Re: [PATCH 0/2] staging: ccree: Fix coding style and remove warnings
Date: Thu, 29 Jun 2017 16:13:38 +0530
Message-ID: <1f681a83-4413-8c9d-ab75-c223b6c8b55b@techveda.org>
References: <1498642633-3260-1-git-send-email-karthik@techveda.org>
 <CAOtvUMdpwFaMDh2qCnB=keZQAc6ssXM+u39GPaf0ASGr002OJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        sunil.m@techveda.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34411 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbdF2Knn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2017 06:43:43 -0400
Received: by mail-pf0-f196.google.com with SMTP id d5so12653000pfe.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jun 2017 03:43:42 -0700 (PDT)
In-Reply-To: <CAOtvUMdpwFaMDh2qCnB=keZQAc6ssXM+u39GPaf0ASGr002OJA@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 28 June 2017 03:15 PM, Gilad Ben-Yossef wrote:
> Thank you Karthik,
> 
> On Wed, Jun 28, 2017 at 12:37 PM,  <karthik@techveda.org> wrote:
>> From: Karthik Tummala <karthik@techveda.org>
>>
>> This patch series fixes coding style and removes the following
>> checkpatch.pl warnings:
>>
>> Prefer using '"%s...", __func__' to using the function's name,
>> in a string.
> 
> This one is good.
>>
>> Braces {} are not necessary for single statement blocks.
> 
> I have already sent a patch addressing this and some other things
> yesterday/
> 
>>
>> Rebased on top of next-20170627.
>> Patches were tested and built on next-20170627
> 
> Can you please check patch 1 still applies after yesterdays patch series?
Hi, I have applied your patch series and then tried to apply patch 1 and 
it failed. Should I wait until the patch series gets accepted and then 
continue my work on the new linux-next release ? or is there any other 
option ?
> 
>>
>> Karthik Tummala (2):
>>    staging: ccree: Use __func__ instead of function name
>>    staging: ccree: Remove braces {} for single statement blocks
>>
>>   drivers/staging/ccree/ssi_aead.c | 48 ++++++++++++++++------------------------
>>   1 file changed, 19 insertions(+), 29 deletions(-)
>>
>> --
>> 1.9.1
>>
> 
> Thanks,
> Gilad
> 
Thanks
karthik

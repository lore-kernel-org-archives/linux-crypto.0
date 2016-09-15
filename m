From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv3 00/11] crypto: omap HW crypto fixes
Date: Thu, 15 Sep 2016 12:12:19 +0300
Message-ID: <6996d5d9-2622-b6c4-3b96-7fd79de86be4@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <20160913123849.GA31890@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <lokeshvutla@ti.com>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:48392 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751070AbcIOJMx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 05:12:53 -0400
In-Reply-To: <20160913123849.GA31890@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13/09/16 15:38, Herbert Xu wrote:
> On Thu, Aug 04, 2016 at 01:28:35PM +0300, Tero Kristo wrote:
>> Hi,
>>
>> This revision took quite a bit time to craft due to the rework needed
>> for sham buffer handling and export/import. I ended up implementing
>> a flush functionality for draining out the sham buffer when doing
>> export/import; just shrinking the buffer to sufficiently small size
>> impacted the performance with small data chunks too much so I dropped
>> this approach.
>>
>> The series also fixes a couple of existing issues with omap2/omap3
>> hardware acceleration, I ran a full boot test / crypto manager
>> test suite on all boards accessible to me now.
>>
>> Based on top of latest mainline, which is somewhere before 4.8-rc1
>> as of writing this, I am unable to rebase the series during the next
>> three weeks so wanted to get this out now. Targeted for 4.9 merge
>> window, some fixes could be picked up earlier though if needed.
>
> I have applied patches 1,4-5,7-11.  Some of them didn't apply
> cleanly so please check the result in my tree.
>
> Thanks,
>

Thanks Herbert,

I just gave a trial for your branch, and seems to be working for me. 
Also checked the patches you applied and they seem fine also.

I have also a new version of the sha buffer handling and export/import 
available now, but need to cleanup it quite a bit, and figure out how to 
split the patch properly.

  drivers/crypto/omap-sham.c | 532 
++++++++++++++++++++++++++-------------------

... It now uses sg for xmitting data where possible, and avoids the need 
for a large internal buffer. The buffer size is also now properly 
configurable, which can be used to overcome the performance issues if 
needed (this however, requires the max statesize hack within the 
crypto/ahash.c file, but thats fine.) I'll hopefully post this out maybe 
tomorrow, but its going to be targeted for 4.10 I believe due to the 
(ahem, rather) intrusive changes.

-Tero

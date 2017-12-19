From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH v2] hwrng: Clean up RNG list when last hwrng is
 unregistered
Date: Tue, 19 Dec 2017 11:52:05 -0600
Message-ID: <a7acdf4b-343d-e8d4-e28c-4167cc8e9035@amd.com>
References: <151336772989.60446.16322941485803241258.stgit@sosxen2.amd.com>
 <CANc+2y6DaMs+GbZT6tWKU5Boyjs_8wU49B+N4kcx-ZJWiFtisQ@mail.gmail.com>
 <CANc+2y4hKW8gdv633GissBKeUm+7m18pGu2tG8NDXqZ+xe6tEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, thomas.lendacky@amd.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0069.outbound.protection.outlook.com ([104.47.42.69]:59796
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751281AbdLSRwM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 12:52:12 -0500
In-Reply-To: <CANc+2y4hKW8gdv633GissBKeUm+7m18pGu2tG8NDXqZ+xe6tEg@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/17/2017 03:49 AM, PrasannaKumar Muralidharan wrote:
> On 17 December 2017 at 14:53, PrasannaKumar Muralidharan
> <prasannatsmkumar@gmail.com> wrote:
>> Hi Gary,
>>
>> Some minor comments below.
>>
>> On 16 December 2017 at 01:25, Gary R Hook <gary.hook@amd.com> wrote:
>>>
>>> Commit 142a27f0a731 added support for a "best" RNG, and in doing so
>>> introduced a hang from rmmod/modprobe -r when the last RNG on the list
>>> was unloaded.
>>
>> Nice catch. Thanks for fixing this.
>>
>>> When the hwrng list is depleted, return the global variables to their
>>> original state and decrement all references to the object.
>>>
>>> Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
>>
>> Please cc the commit author (in this case its me) so that this patch
>> gets noticed easily.

D'oh! I did not do so on this version. My apologies.

>>
>>> Signed-off-by: Gary R Hook <gary.hook@amd.com>
>>> ---
>>>
>>> Changes since v1: fix misspelled word in subject
>>>
>>>   drivers/char/hw_random/core.c |    4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>>> index 657b8770b6b9..91bb98c42a1c 100644
>>> --- a/drivers/char/hw_random/core.c
>>> +++ b/drivers/char/hw_random/core.c
>>> @@ -306,6 +306,10 @@ static int enable_best_rng(void)
>>>                  ret = ((new_rng == current_rng) ? 0 : set_current_rng(new_rng));
>>>                  if (!ret)
>>>                          cur_rng_set_by_user = 0;
>>> +       } else {
>>> +               drop_current_rng();
>>
>> When the hwrng list is empty just set current_rng = NULL instead of
>> calling drop_current_rng().
>>
>>> +               cur_rng_set_by_user = 0;
>>> +               ret = 0;
>>>          }
>>>
>>>          return ret;
>>>
>>
>> Regards,
>> PrasannaKumar
> 
> I am fine with the code as is.
> 
> Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> 
> Regards,
> PrasannaKumar
> 

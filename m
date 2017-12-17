From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2] hwrng: Clean up RNG list when last hwrng is unregistered
Date: Sun, 17 Dec 2017 15:19:37 +0530
Message-ID: <CANc+2y4hKW8gdv633GissBKeUm+7m18pGu2tG8NDXqZ+xe6tEg@mail.gmail.com>
References: <151336772989.60446.16322941485803241258.stgit@sosxen2.amd.com> <CANc+2y6DaMs+GbZT6tWKU5Boyjs_8wU49B+N4kcx-ZJWiFtisQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, thomas.lendacky@amd.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33091 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbdLQJti (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Dec 2017 04:49:38 -0500
Received: by mail-it0-f66.google.com with SMTP id o130so2590225itg.0
        for <linux-crypto@vger.kernel.org>; Sun, 17 Dec 2017 01:49:38 -0800 (PST)
In-Reply-To: <CANc+2y6DaMs+GbZT6tWKU5Boyjs_8wU49B+N4kcx-ZJWiFtisQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 17 December 2017 at 14:53, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
> Hi Gary,
>
> Some minor comments below.
>
> On 16 December 2017 at 01:25, Gary R Hook <gary.hook@amd.com> wrote:
>>
>> Commit 142a27f0a731 added support for a "best" RNG, and in doing so
>> introduced a hang from rmmod/modprobe -r when the last RNG on the list
>> was unloaded.
>
> Nice catch. Thanks for fixing this.
>
>> When the hwrng list is depleted, return the global variables to their
>> original state and decrement all references to the object.
>>
>> Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
>
> Please cc the commit author (in this case its me) so that this patch
> gets noticed easily.
>
>> Signed-off-by: Gary R Hook <gary.hook@amd.com>
>> ---
>>
>> Changes since v1: fix misspelled word in subject
>>
>>  drivers/char/hw_random/core.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>> index 657b8770b6b9..91bb98c42a1c 100644
>> --- a/drivers/char/hw_random/core.c
>> +++ b/drivers/char/hw_random/core.c
>> @@ -306,6 +306,10 @@ static int enable_best_rng(void)
>>                 ret = ((new_rng == current_rng) ? 0 : set_current_rng(new_rng));
>>                 if (!ret)
>>                         cur_rng_set_by_user = 0;
>> +       } else {
>> +               drop_current_rng();
>
> When the hwrng list is empty just set current_rng = NULL instead of
> calling drop_current_rng().
>
>> +               cur_rng_set_by_user = 0;
>> +               ret = 0;
>>         }
>>
>>         return ret;
>>
>
> Regards,
> PrasannaKumar

I am fine with the code as is.

Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Regards,
PrasannaKumar

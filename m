From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] crypto: Make hwrng choose rng source by quality.
Date: Fri, 30 Jun 2017 14:01:37 +0200
Message-ID: <1bcc5fc7-6e6b-9ffd-3378-a0f6a65c5fca@linux.vnet.ibm.com>
References: <1498730623-3741-1-git-send-email-freude@linux.vnet.ibm.com>
 <CANc+2y5QrcEqN6_KDC8C3h6-PJDo8zjFrkkYwj2SG96zeiFGMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>, schwidefsky@de.ibm.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37201 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751679AbdF3MBz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2017 08:01:55 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5UBwhHe009557
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2017 08:01:45 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bdmqsupjr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2017 08:01:44 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
        Fri, 30 Jun 2017 13:01:40 +0100
In-Reply-To: <CANc+2y5QrcEqN6_KDC8C3h6-PJDo8zjFrkkYwj2SG96zeiFGMQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/30/2017 07:27 AM, PrasannaKumar Muralidharan wrote:
> Hi Harald,
>
> Can you split this patch into two? One patch to choose rng based on
> the quality and another for not overriding user decided rng.
>
> Some more minor comments below.
>
> On 29 June 2017 at 15:33, Harald Freudenberger
> <freude@linux.vnet.ibm.com> wrote:
>> The hwrng core implementation currently doesn't consider the
>> quality field of the struct hwrng. So the first registered rng
>> is the winner and further rng sources even with much better
>> quality are ignored.
>>
>> The behavior should be that always the best rng with the highest
>> quality rate should be used as current rng source. Only if the
>> user explicitly chooses a rng source (via writing a rng name
>> to /sys/class/misc/hw_random) the decision for the best quality
>> should be suppressed.
>>
>> This patch makes hwrng always hold a list of registered rng
>> sources sorted decreasing by quality. On registration of a new
>> hwrng source the list is updated and if the current rng source
>> was not chosen by user and the new rng provides better quality
>> set as new current rng source. Similar on unregistration of an
>> rng, if it was the current used rng source the one with the
>> next highest quality is used. If a rng source has been set via
>> sysfs from userland as long as this one doesn't unregister
>> it is kept as current rng regardless of registration of 'better'
>> rng sources.
> Nice to see the patch. This is indeed required.
>
>> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
>> ---
>>  drivers/char/hw_random/core.c | 31 +++++++++++++++++++++++++------
>>  1 file changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>> index 503a41d..7fe47f8 100644
>> --- a/drivers/char/hw_random/core.c
>> +++ b/drivers/char/hw_random/core.c
>> @@ -28,7 +28,10 @@
>>  #define RNG_MODULE_NAME                "hw_random"
>>
>>  static struct hwrng *current_rng;
>> +/* the current rng has been explicitly chosen by user via sysfs */
>> +static int cur_rng_set_by_user;
> Letting the user know that the current rng was selected based on user
> input would be a good option I guess. Any thoughts on this?
>
>>  static struct task_struct *hwrng_fill;
>> +/* list of registered rngs, sorted decending by quality */
>>  static LIST_HEAD(rng_list);
>>  /* Protects rng_list and current_rng */
>>  static DEFINE_MUTEX(rng_mutex);
>> @@ -308,6 +311,8 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
>>                         break;
>>                 }
>>         }
>> +       if (!err)
>> +               cur_rng_set_by_user = 1;
> This can be put inside the loop. The if condition will go away in that case.
>
>>         mutex_unlock(&rng_mutex);
>>
>>         return err ? : len;
>> @@ -417,6 +422,7 @@ int hwrng_register(struct hwrng *rng)
>>  {
>>         int err = -EINVAL;
>>         struct hwrng *old_rng, *tmp;
>> +       struct list_head *ptr;
> Any better name instead of ptr?
>
>>         if (!rng->name || (!rng->data_read && !rng->read))
>>                 goto out;
>> @@ -432,14 +438,26 @@ int hwrng_register(struct hwrng *rng)
>>         init_completion(&rng->cleanup_done);
>>         complete(&rng->cleanup_done);
>>
>> +       /* rng_list is sorted by decreasing quality */
>> +       list_for_each(ptr, &rng_list) {
>> +               tmp = list_entry(ptr, struct hwrng, list);
>> +               if (tmp->quality < rng->quality)
>> +                       break;
>> +       }
>> +       list_add_tail(&rng->list, ptr);
>> +
>>         old_rng = current_rng;
>>         err = 0;
>> -       if (!old_rng) {
>> +       if (!old_rng ||
>> +           (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
>> +               /*
>> +                * Set new rng as current if no current rng or rng was
>> +                * not chosen by user and the new one has better quality.
>> +                */
>>                 err = set_current_rng(rng);
>>                 if (err)
>>                         goto out_unlock;
>>         }
>> -       list_add_tail(&rng->list, &rng_list);
>>
>>         if (old_rng && !rng->init) {
>>                 /*
>> @@ -466,12 +484,13 @@ void hwrng_unregister(struct hwrng *rng)
>>         list_del(&rng->list);
>>         if (current_rng == rng) {
>>                 drop_current_rng();
>> +               cur_rng_set_by_user = 0;
>> +               /* rng_list is sorted by quality, use the best (=first) one */
>>                 if (!list_empty(&rng_list)) {
>> -                       struct hwrng *tail;
>> -
>> -                       tail = list_entry(rng_list.prev, struct hwrng, list);
>> +                       struct hwrng *new_rng;
>>
>> -                       set_current_rng(tail);
>> +                       new_rng = list_entry(rng_list.next, struct hwrng, list);
>> +                       set_current_rng(new_rng);
>>                 }
>>         }
>>
>> --
>> 2.7.4
>>
> This patch looks good. I am fine with this patch as is. Reviewed-by:
> PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>
> If this patch is split into please go ahead and my reviewed-by tag.
>
> Regards,
> PrasannaKumar
>
Thanks for this feedback.
I will split into two and work in some improvements.
regards Harald Freudenberger

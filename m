From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [Outreachy kernel] [PATCH v2] Staging: ccree: Remove unused
 variable monitor_lock
Date: Mon, 11 Sep 2017 21:10:28 +0300
Message-ID: <CAOtvUMfoK3JxwYqXOXo8UEvSM5FPw+_RR2Evy9BfDKEf-StLDA@mail.gmail.com>
References: <1505147317-13411-1-git-send-email-srishtishar@gmail.com> <CAOw6vb+CZWz39-6_dtPzwi4=mxJkp_fQ=saUrLG8TfFORZkSkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Srishti Sharma <srishtishar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
To: Sean Paul <seanpaul@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34597 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdIKSKa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2017 14:10:30 -0400
Received: by mail-io0-f196.google.com with SMTP id g32so3702844ioj.1
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2017 11:10:29 -0700 (PDT)
In-Reply-To: <CAOw6vb+CZWz39-6_dtPzwi4=mxJkp_fQ=saUrLG8TfFORZkSkA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 11, 2017 at 7:36 PM, Sean Paul <seanpaul@chromium.org> wrote:
> On Mon, Sep 11, 2017 at 12:28 PM, Srishti Sharma <srishtishar@gmail.com> wrote:
>> Remove the variable monitor_lock as it is not used anywhere.
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>
> Reviewed-by: Sean Paul <seanpaul@chromium.org>

That variable is a left-over I've missed when I deleted an implementation of
something that was almost, but not quite, entirely unlike perf and is
no longer used.

So, assuming it compiles fine (I'm away from my build infrastructure
at the moment):

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thank you,
Gilad

>
>> ---
>> Changes in v2:
>>  -The variable that was not to be declared as volatile can be
>>   eliminated as it is not being used anywhere.
>>
>>  drivers/staging/ccree/ssi_request_mgr.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
>> index e5c2f92..b94a91f 100644
>> --- a/drivers/staging/ccree/ssi_request_mgr.c
>> +++ b/drivers/staging/ccree/ssi_request_mgr.c
>> @@ -49,7 +49,6 @@ struct ssi_request_mgr_handle {
>>         dma_addr_t dummy_comp_buff_dma;
>>         struct cc_hw_desc monitor_desc;
>>
>> -       volatile unsigned long monitor_lock;
>>  #ifdef COMP_IN_WQ
>>         struct workqueue_struct *workq;
>>         struct delayed_work compwork;
>> --
>> 2.7.4
>>
>> --
>> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
>> To post to this group, send email to outreachy-kernel@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1505147317-13411-1-git-send-email-srishtishar%40gmail.com.
>> For more options, visit https://groups.google.com/d/optout.



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

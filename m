From: Sean Paul <seanpaul@chromium.org>
Subject: Re: [Outreachy kernel] Re: [PATCH] Staging: ccree: Don't use volatile
 for monitor_lock
Date: Mon, 11 Sep 2017 12:10:40 -0400
Message-ID: <CAOw6vbL=fn_wh8hrEVH-01BFkm3mAW=aDHvH_B-t+UgjtnyHjg@mail.gmail.com>
References: <1505145571-11248-1-git-send-email-srishtishar@gmail.com>
 <20170911160449.GA11886@kroah.com> <CAB3L5oxcyhgyy8EuGuPo9QtJQd-W7JTgQQE1PfopZFmSx58P9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:32924 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdIKQLG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2017 12:11:06 -0400
Received: by mail-yw0-f174.google.com with SMTP id s62so22594912ywg.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2017 09:11:06 -0700 (PDT)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com. [209.85.214.44])
        by smtp.gmail.com with ESMTPSA id i206sm3236229ywg.27.2017.09.11.09.11.01
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Sep 2017 09:11:01 -0700 (PDT)
Received: by mail-it0-f44.google.com with SMTP id g142so12355385ita.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2017 09:11:01 -0700 (PDT)
In-Reply-To: <CAB3L5oxcyhgyy8EuGuPo9QtJQd-W7JTgQQE1PfopZFmSx58P9g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 11, 2017 at 12:08 PM, Srishti Sharma <srishtishar@gmail.com> wrote:
> On Mon, Sep 11, 2017 at 9:34 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Mon, Sep 11, 2017 at 09:29:31PM +0530, Srishti Sharma wrote:
>>> The use of volatile for the variable monitor_lock is unnecessary.
>>>
>>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>>> ---
>>>  drivers/staging/ccree/ssi_request_mgr.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
>>> index e5c2f92..7d77941 100644
>>> --- a/drivers/staging/ccree/ssi_request_mgr.c
>>> +++ b/drivers/staging/ccree/ssi_request_mgr.c
>>> @@ -49,7 +49,7 @@ struct ssi_request_mgr_handle {
>>>       dma_addr_t dummy_comp_buff_dma;
>>>       struct cc_hw_desc monitor_desc;
>>>
>>> -     volatile unsigned long monitor_lock;
>>> +     unsigned long monitor_lock;
>>
>> While volatile is not right, odds are, this is still totally wrong as
>> well.  How about using a "real" lock instead?
>
> I tried to find where is this variable being used in the code, but I
> didn't find any usage of it . It might be an important attribute of
> this structure definition but, I don't see it's value being set to
> anything or being used somewhere .
>

AFAICT, it's not used. Your patch should just remove it instead :)

Sean

> Regards,
> Srishti
>>
>> thanks,
>>
>> greg k-h
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/CAB3L5oxcyhgyy8EuGuPo9QtJQd-W7JTgQQE1PfopZFmSx58P9g%40mail.gmail.com.
> For more options, visit https://groups.google.com/d/optout.

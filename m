From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [Outreachy kernel] [PATCH v2] Staging: ccree: ssi_cipher.c: Make
 comment more comprehensible.
Date: Thu, 7 Sep 2017 02:30:00 +0530
Message-ID: <CAB3L5owNmnR5poc9a3pH-fp+m7us4yztzPs9dzNRjzYVEneRgA@mail.gmail.com>
References: <1504731390-9536-1-git-send-email-srishtishar@gmail.com> <alpine.DEB.2.20.1709062258000.2984@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36314 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752891AbdIFVAB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2017 17:00:01 -0400
In-Reply-To: <alpine.DEB.2.20.1709062258000.2984@hadrien>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 7, 2017 at 2:28 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>
>
> On Thu, 7 Sep 2017, Srishti Sharma wrote:
>
>> Edited comment to make it more comprehensible.
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>> Changes in v2:
>>  - Make comment more comprehensible , instead of just correcting typos.
>>  drivers/staging/ccree/ssi_cipher.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
>> index 99232b2..fec2faa 100644
>> --- a/drivers/staging/ccree/ssi_cipher.c
>> +++ b/drivers/staging/ccree/ssi_cipher.c
>> @@ -702,7 +702,9 @@ static int ssi_blkcipher_complete(struct device *dev,
>>
>>       ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>>
>> -     /*Set the inflight counter value to local variable*/
>> +     /*
>> +      * Save inflight_counter in a local variable.
>> +      */
>
> This is the format for multiline comments.  Your comments is only one
> line.  You just need to add spaces around the text, as compared to the
> original version.
>
> julia
>
>>       inflight_counter =  ctx_p->drvdata->inflight_counter;
>>       /*Decrease the inflight counter*/
>>       if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
>> --
>> 2.7.4
>>
>> --
>> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
>> To post to this group, send email to outreachy-kernel@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504731390-9536-1-git-send-email-srishtishar%40gmail.com.
>> For more options, visit https://groups.google.com/d/optout.
>>

Okay, Thanks I'll re-send it .

Regards,
Srishti

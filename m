From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [Outreachy kernel] [PATCH v4] Staging: ccree: ssi_cipher.c:
 Remove unused variable.
Date: Thu, 7 Sep 2017 12:42:16 +0530
Message-ID: <CAB3L5oxbF=Qg8XE2boWM3V+A2m941j9gfaOBcFuCorro+acqBA@mail.gmail.com>
References: <1504735553-13753-1-git-send-email-srishtishar@gmail.com> <alpine.DEB.2.20.1709070852150.3084@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1709070852150.3084@hadrien>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 7, 2017 at 12:24 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> One last detail.  The subject line above is not in the same format as that
> of all of the other subject lines one commits affecting this file.  You
> can use git log --oneline to see what others have done.  It is not really
> possible to guess correctly.  However, one does not generally include the
> extension on a filename.
>

Yes, they have not used the filename in the subject line . So I'll change it to
the required format .

Thanks ,
Srishti

> julia
>
> On Thu, 7 Sep 2017, Srishti Sharma wrote:
>
>> Remove local variable inflight_counter, as it is never used.
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>> Change in v4:
>>  -There is no longer a need to make the comment more comprehensible, as I
>>   have deleted the variable associated with it. The v3 of this patch was
>>   not based on the original patch, hence v4.
>>  drivers/staging/ccree/ssi_cipher.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
>> index 8d31a93..1ff3c8a 100644
>> --- a/drivers/staging/ccree/ssi_cipher.c
>> +++ b/drivers/staging/ccree/ssi_cipher.c
>> @@ -697,13 +697,10 @@ static int ssi_blkcipher_complete(struct device *dev,
>>                                 void __iomem *cc_base)
>>  {
>>       int completion_error = 0;
>> -     u32 inflight_counter;
>>       struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
>>
>>       ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>>
>> -     /*Set the inflight couter value to local variable*/
>> -     inflight_counter =  ctx_p->drvdata->inflight_counter;
>>       /*Decrease the inflight counter*/
>>       if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
>>               ctx_p->drvdata->inflight_counter--;
>> --
>> 2.7.4
>>
>> --
>> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
>> To post to this group, send email to outreachy-kernel@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504735553-13753-1-git-send-email-srishtishar%40gmail.com.
>> For more options, visit https://groups.google.com/d/optout.
>>

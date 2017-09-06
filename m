From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [Outreachy kernel] [PATCH v3] Staging: ccree: ssi_cipher.c:
 Remove unused variable.
Date: Thu, 7 Sep 2017 02:57:35 +0530
Message-ID: <CAB3L5ozix75XLL6nPmV8jQaoz1xa6RuBKXrBBY=mwVmRd_7hOw@mail.gmail.com>
References: <1504732426-9765-1-git-send-email-srishtishar@gmail.com>
 <alpine.DEB.2.20.1709062316450.2984@hadrien> <CAB3L5owYErPk2hh3OnE68eHCyrbgqUY0cHj3TrU6DUL44ZbPgQ@mail.gmail.com>
 <alpine.DEB.2.20.1709062325070.2984@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1709062325070.2984@hadrien>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 7, 2017 at 2:56 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>
>
> On Thu, 7 Sep 2017, Srishti Sharma wrote:
>
>> On Thu, Sep 7, 2017 at 2:47 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>> >
>> >
>> > On Thu, 7 Sep 2017, Srishti Sharma wrote:
>> >
>> >> Remove local variable inflight_counter ,as it is never used.
>> >
>> > "counter ,as" -> "counter, as"
>> >
>> >> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> >> ---
>> >> Changes in v3:
>> >>  - There was no longer a need to make the comment more comprehensible as
>> >>    I have deleted the variable associated with it because it is unused .
>> >>  drivers/staging/ccree/ssi_cipher.c | 5 +----
>> >>  1 file changed, 1 insertion(+), 4 deletions(-)
>> >>
>> >> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
>> >> index fec2faa..609ebe4 100644
>> >> --- a/drivers/staging/ccree/ssi_cipher.c
>> >> +++ b/drivers/staging/ccree/ssi_cipher.c
>> >> @@ -702,10 +702,7 @@ static int ssi_blkcipher_complete(struct device *dev,
>> >>
>> >>       ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>> >>
>> >> -     /*
>> >> -      * Save inflight_counter in a local variable.
>> >> -      */
>> >> -     inflight_counter =  ctx_p->drvdata->inflight_counter;
>> >> +
>> >
>> > This is a patch on your previous patch.  It should be a patch on the
>> > original code.  Also, don't add a new blank line.  Just remove the line
>> > completely.
>>
>>   so , when I resend it should I version it as v3 or send as a new
>> patch as it is now fixing a different problem ?
>
> v3 (or maybe now v4?) would be fine.  It's still the same code that is
> under consideration.  Then it will be clear that he previosu patches are
> not needed.

 Okay , Thanks !
 Regards,
 Srishti
>
> julia
>
>>  Regards,
>>  Srishti
>> >
>> > julia
>> >
>> >>       /*Decrease the inflight counter*/
>> >>       if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
>> >>               ctx_p->drvdata->inflight_counter--;
>> >> --
>> >> 2.7.4
>> >>
>> >> --
>> >> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
>> >> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
>> >> To post to this group, send email to outreachy-kernel@googlegroups.com.
>> >> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504732426-9765-1-git-send-email-srishtishar%40gmail.com.
>> >> For more options, visit https://groups.google.com/d/optout.
>> >>
>>

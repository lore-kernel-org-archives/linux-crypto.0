From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [Outreachy kernel] [PATCH v3] Staging: ccree: ssi_cipher.c:
 Remove unused variable.
Date: Thu, 7 Sep 2017 02:52:17 +0530
Message-ID: <CAB3L5owYErPk2hh3OnE68eHCyrbgqUY0cHj3TrU6DUL44ZbPgQ@mail.gmail.com>
References: <1504732426-9765-1-git-send-email-srishtishar@gmail.com>
 <alpine.DEB.2.20.1709062316450.2984@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, outreachy-kernel@googlegroups.com,
 Greg KH <gregkh@linuxfoundation.org>, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <alpine.DEB.2.20.1709062316450.2984@hadrien>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 7, 2017 at 2:47 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>
>
> On Thu, 7 Sep 2017, Srishti Sharma wrote:
>
>> Remove local variable inflight_counter ,as it is never used.
>
> "counter ,as" -> "counter, as"
>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>> Changes in v3:
>>  - There was no longer a need to make the comment more comprehensible as
>>    I have deleted the variable associated with it because it is unused .
>>  drivers/staging/ccree/ssi_cipher.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
>> index fec2faa..609ebe4 100644
>> --- a/drivers/staging/ccree/ssi_cipher.c
>> +++ b/drivers/staging/ccree/ssi_cipher.c
>> @@ -702,10 +702,7 @@ static int ssi_blkcipher_complete(struct device *dev,
>>
>>       ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>>
>> -     /*
>> -      * Save inflight_counter in a local variable.
>> -      */
>> -     inflight_counter =  ctx_p->drvdata->inflight_counter;
>> +
>
> This is a patch on your previous patch.  It should be a patch on the
> original code.  Also, don't add a new blank line.  Just remove the line
> completely.

  so , when I resend it should I version it as v3 or send as a new
patch as it is now fixing a different problem ?

 Regards,
 Srishti
>
> julia
>
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
>> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504732426-9765-1-git-send-email-srishtishar%40gmail.com.
>> For more options, visit https://groups.google.com/d/optout.
>>

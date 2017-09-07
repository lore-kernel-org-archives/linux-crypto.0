From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [PATCH v5] Staging: ccree: Remove unused variable.
Date: Thu, 7 Sep 2017 15:26:42 +0530
Message-ID: <CAB3L5oyx4Au-BhZCg7Eo2SBD5drFS0OS=NOM3qCtQ4hLumdg1A@mail.gmail.com>
References: <1504770561-5554-1-git-send-email-srishtishar@gmail.com>
 <CAOtvUMc0zxtAnfZhL5M4A7mrYt9z-i58mr2SLtYpXJ5-eEo+QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 outreachy-kernel@googlegroups.com,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <CAOtvUMc0zxtAnfZhL5M4A7mrYt9z-i58mr2SLtYpXJ5-eEo+QQ@mail.gmail.com>
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

On Thu, Sep 7, 2017 at 2:20 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Hi,
>
> On Thu, Sep 7, 2017 at 10:49 AM, Srishti Sharma <srishtishar@gmail.com> wrote:
>> Remove the local variable inflight_counter as it is never used.
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>
> I've been meaning to clean that for some time now and never got around to do it.
> Thank you! :-)

Glad to know :)

>
> Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
>
>
>> Changes in v5:
>>  - Correct the format of the subject.
>>  drivers/staging/ccree/ssi_cipher.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
>> index 8d31a93..1ff3c8a 100644
>> --- a/drivers/staging/ccree/ssi_cipher.c
>> +++ b/drivers/staging/ccree/ssi_cipher.c
>> @@ -697,13 +697,10 @@ static int ssi_blkcipher_complete(struct device *dev,
>>                                   void __iomem *cc_base)
>>  {
>>         int completion_error = 0;
>> -       u32 inflight_counter;
>>         struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
>>
>>         ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>>
>> -       /*Set the inflight couter value to local variable*/
>> -       inflight_counter =  ctx_p->drvdata->inflight_counter;
>>         /*Decrease the inflight counter*/
>>         if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
>>                 ctx_p->drvdata->inflight_counter--;
>> --
>> 2.7.4
>>
>
>
>
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
>
> "If you take a class in large-scale robotics, can you end up in a
> situation where the homework eats your dog?"
>  -- Jean-Baptiste Queru

Regards,
Srishti

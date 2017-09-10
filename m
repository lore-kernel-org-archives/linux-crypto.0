From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [Outreachy kernel] [PATCH] Staging: ccree: Merge assignment with return
Date: Sun, 10 Sep 2017 11:22:13 +0530
Message-ID: <CAB3L5oyw7Mxj63q=mmYEDtNOQHiVy3M-d6dNd5+S7ZA2hKFSwA@mail.gmail.com>
References: <1504953861-3221-1-git-send-email-srishtishar@gmail.com> <alpine.DEB.2.20.1709091858060.2149@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1709091858060.2149@hadrien>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 9, 2017 at 10:29 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>
>
> On Sat, 9 Sep 2017, Srishti Sharma wrote:
>
>> Merge the assignment and return statements to return the value
>> directly. Done using coccinelle.
>
> Coccinelle is not always perfect about pretty printing, so you have to
> watch out for it.
>
>>
>> @@
>> local idexpression ret;
>> expression e;
>> @@
>>
>> -ret =
>> +return
>>      e;
>> -return ret;
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>>  drivers/staging/ccree/ssi_sysfs.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
>> index 0655658..9fa7be0 100644
>> --- a/drivers/staging/ccree/ssi_sysfs.c
>> +++ b/drivers/staging/ccree/ssi_sysfs.c
>> @@ -412,7 +412,6 @@ static void sys_free_dir(struct sys_dir *sys_dir)
>>
>>  int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
>>  {
>> -     int retval;
>>
>
> This is going to leave a single empty line at the top of the function.
> That is not needed.
>
>>  #if defined CC_CYCLE_COUNT
>>       /* Init. statistics */
>> @@ -423,10 +422,9 @@ int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
>>       SSI_LOG_ERR("setup sysfs under %s\n", sys_dev_obj->name);
>>
>>       /* Initialize top directory */
>> -     retval = sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj, "cc_info",
>> +     return sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj, "cc_info",
>>                             ssi_sys_top_level_attrs,
>>                             ARRAY_SIZE(ssi_sys_top_level_attrs));
>
> Previously the arguments were lined up with the right side of the ( but
> now they are not.  So move the above two lines to the left by 2 spaces.

Thanks for this , I have re-sent the patch .

Regards,
Srishti

> julia
>
>> -     return retval;
>>  }
>>
>>  void ssi_sysfs_fini(void)
>> --
>> 2.7.4
>>
>> --
>> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
>> To post to this group, send email to outreachy-kernel@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504953861-3221-1-git-send-email-srishtishar%40gmail.com.
>> For more options, visit https://groups.google.com/d/optout.
>>

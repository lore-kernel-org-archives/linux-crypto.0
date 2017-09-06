From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [PATCH] Staging: ccree: ssi_cipher.c: Correct spelling mistake.
Date: Thu, 7 Sep 2017 02:32:54 +0530
Message-ID: <CAB3L5oz_5hnLPLAMCB46AirDR5XEm6nhhc+PoS-rfDx9tf97KA@mail.gmail.com>
References: <1504725863-8495-1-git-send-email-srishtishar@gmail.com> <20170906205955.s22ssdslev3o4yiq@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        outreachy-kernel@googlegroups.com,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35720 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752354AbdIFVC4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2017 17:02:56 -0400
In-Reply-To: <20170906205955.s22ssdslev3o4yiq@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 7, 2017 at 2:29 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Thu, Sep 07, 2017 at 12:54:23AM +0530, Srishti Sharma wrote:
>> Correct spelling of counter in comment .
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>>  drivers/staging/ccree/ssi_cipher.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
>> index 8d31a93..99232b2 100644
>> --- a/drivers/staging/ccree/ssi_cipher.c
>> +++ b/drivers/staging/ccree/ssi_cipher.c
>> @@ -702,7 +702,7 @@ static int ssi_blkcipher_complete(struct device *dev,
>>
>>       ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>>
>> -     /*Set the inflight couter value to local variable*/
>> +     /*Set the inflight counter value to local variable*/
>>       inflight_counter =  ctx_p->drvdata->inflight_counter;
>
> Sure, but it would be better to just delete the comment.  It's obvious.
> But really just delete the local inflight_counter variable as well
> because that's never used.

  Okay, I'll delete it .
>
> regards,
> dan carpenter
>

Regards,
Srishti

From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [PATCH] Staging: ccree: Don't use volatile for monitor_lock
Date: Tue, 12 Sep 2017 17:35:21 +0530
Message-ID: <CAB3L5oy17gOjA7_HCZZXPqXO9yYh4283+ehruaDUz0pJNDu+EQ@mail.gmail.com>
References: <1505145571-11248-1-git-send-email-srishtishar@gmail.com> <20170912091951.noslc3dlncyxonyg@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, devel@driverdev.osuosl.org,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:32956 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbdILMFW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2017 08:05:22 -0400
In-Reply-To: <20170912091951.noslc3dlncyxonyg@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 12, 2017 at 2:49 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Sep 11, 2017 at 09:29:31PM +0530, Srishti Sharma wrote:
>> The use of volatile for the variable monitor_lock is unnecessary.
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>>  drivers/staging/ccree/ssi_request_mgr.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
>> index e5c2f92..7d77941 100644
>> --- a/drivers/staging/ccree/ssi_request_mgr.c
>> +++ b/drivers/staging/ccree/ssi_request_mgr.c
>> @@ -49,7 +49,7 @@ struct ssi_request_mgr_handle {
>>       dma_addr_t dummy_comp_buff_dma;
>>       struct cc_hw_desc monitor_desc;
>>
>> -     volatile unsigned long monitor_lock;
>> +     unsigned long monitor_lock;
>
> The variable seems unused.  Try deleting it instead.

Had already sent a patch for that as v2.

Thanks
Srishti

> regards,
> dan carpenter
>

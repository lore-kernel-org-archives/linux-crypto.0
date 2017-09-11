From: Srishti Sharma <srishtishar@gmail.com>
Subject: Re: [Outreachy kernel] Re: [PATCH] Staging: ccree: Don't use volatile
 for monitor_lock
Date: Mon, 11 Sep 2017 22:04:38 +0530
Message-ID: <CAB3L5ozXiJLwwjqKVLOTyv6aQoaR9J8gF7u3Z-dyFipcbMr=Cg@mail.gmail.com>
References: <1505145571-11248-1-git-send-email-srishtishar@gmail.com>
 <20170911160449.GA11886@kroah.com> <CAB3L5oxcyhgyy8EuGuPo9QtJQd-W7JTgQQE1PfopZFmSx58P9g@mail.gmail.com>
 <alpine.DEB.2.20.1709111809180.13726@hadrien> <CAB3L5oxwadCBOwir99x=D4Rmby6ZWPfDtFrMNwtFOpv8zhO4iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35865 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbdIKQej (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2017 12:34:39 -0400
In-Reply-To: <CAB3L5oxwadCBOwir99x=D4Rmby6ZWPfDtFrMNwtFOpv8zhO4iQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 11, 2017 at 9:45 PM, Srishti Sharma <srishtishar@gmail.com> wrote:
> On Mon, Sep 11, 2017 at 9:41 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>>
>>
>> On Mon, 11 Sep 2017, Srishti Sharma wrote:
>>
>>> On Mon, Sep 11, 2017 at 9:34 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> > On Mon, Sep 11, 2017 at 09:29:31PM +0530, Srishti Sharma wrote:
>>> >> The use of volatile for the variable monitor_lock is unnecessary.
>>> >>
>>> >> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>>> >> ---
>>> >>  drivers/staging/ccree/ssi_request_mgr.c | 2 +-
>>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >>
>>> >> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
>>> >> index e5c2f92..7d77941 100644
>>> >> --- a/drivers/staging/ccree/ssi_request_mgr.c
>>> >> +++ b/drivers/staging/ccree/ssi_request_mgr.c
>>> >> @@ -49,7 +49,7 @@ struct ssi_request_mgr_handle {
>>> >>       dma_addr_t dummy_comp_buff_dma;
>>> >>       struct cc_hw_desc monitor_desc;
>>> >>
>>> >> -     volatile unsigned long monitor_lock;
>>> >> +     unsigned long monitor_lock;
>>> >
>>> > While volatile is not right, odds are, this is still totally wrong as
>>> > well.  How about using a "real" lock instead?
>>>
>>> I tried to find where is this variable being used in the code, but I
>>> didn't find any usage of it . It might be an important attribute of
>>> this structure definition but, I don't see it's value being set to
>>> anything or being used somewhere .
>>
>> Try removing it and see if the code still compiles.  There is always a
>> danger that a use of something could be constructed using ## in a macro,
>> although given the uses of ## for this driver, it doesn't seem likely
>> here.

It compiles, so I have removed the variable and sent another patch

Thanks,
Srishti

>
> Yes, I'll do that.
>
> Regards,
> Srishti
>>
>> julia

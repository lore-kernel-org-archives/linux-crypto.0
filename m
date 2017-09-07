From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 8/8] staging: ccree: remove BUG macro usage
Date: Thu, 7 Sep 2017 12:00:14 +0300
Message-ID: <CAOtvUMd4XhmVS9xF8gaguD3toGfVhNc00VNPJuyb8wDvjT33+Q@mail.gmail.com>
References: <1504429011-25514-1-git-send-email-gilad@benyossef.com>
 <1504429011-25514-9-git-send-email-gilad@benyossef.com> <20170906192821.4ytcxj436uyug6pr@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33193 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754404AbdIGJAP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 05:00:15 -0400
Received: by mail-oi0-f45.google.com with SMTP id r20so26189962oie.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 Sep 2017 02:00:15 -0700 (PDT)
In-Reply-To: <20170906192821.4ytcxj436uyug6pr@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 6, 2017 at 10:28 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sun, Sep 03, 2017 at 11:56:50AM +0300, Gilad Ben-Yossef wrote:
>> @@ -1154,7 +1150,8 @@ static inline int ssi_buffer_mgr_aead_chain_data(
>>               //if have reached the end of the sgl, then this is unexpected
>>               if (!areq_ctx->src_sgl) {
>>                       SSI_LOG_ERR("reached end of sg list. unexpected\n");
>> -                     BUG();
>> +                     return -EINVAL;
>> +                     goto chain_data_exit;
>
> You've got a direct return followed by a goto.

Yes, that is silly. Thank you for spotting that.

>
> It's a do-nothing goto that just returns rc.  I hate those.  I've tried
> to review locking bugs to see if single returns prevent future
> programmers from introducing new error paths which don't unlock.  They
> don't really help...


I've replaced the error handling from goto to return as you suggested
for the changes
introduced by this patch.

Still need to clean up a lot of the other code doing this though.

Gilad




-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

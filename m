From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 6/8] staging: ccree: simplify pm manager using local var
Date: Thu, 9 Nov 2017 08:27:28 +0200
Message-ID: <CAOtvUMfeMrrpZ2TRHkyL0i1JueczSkCHFxui6z1mPXjaAv2-1w@mail.gmail.com>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
 <1510047606-5589-7-git-send-email-gilad@benyossef.com> <20171107104310.xhdxl3q3bnh7uciw@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:43465 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdKIG13 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Nov 2017 01:27:29 -0500
Received: by mail-oi0-f67.google.com with SMTP id c77so3722177oig.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Nov 2017 22:27:29 -0800 (PST)
In-Reply-To: <20171107104310.xhdxl3q3bnh7uciw@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 7, 2017 at 12:43 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Nov 07, 2017 at 09:40:02AM +0000, Gilad Ben-Yossef wrote:
>> --- a/drivers/staging/ccree/ssi_pm.c
>> +++ b/drivers/staging/ccree/ssi_pm.c
>> @@ -90,20 +90,24 @@ int cc_pm_resume(struct device *dev)
>>  int cc_pm_get(struct device *dev)
>>  {
>>       int rc = 0;
>> +     struct ssi_drvdata *drvdata =
>> +             (struct ssi_drvdata *)dev_get_drvdata(dev);
>
> No need to cast:
>
>         struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
>

The same unneeded cast appears at other places in the file, so I opted
to add a patch addressing all these location rather then change this one.

I hope it's OK.

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

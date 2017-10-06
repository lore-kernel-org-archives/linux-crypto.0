From: Suniel Mahesh <sunil.m@techveda.org>
Subject: Re: [PATCH] staging: ccree: local variable "dev" not required
Date: Fri, 6 Oct 2017 09:37:06 +0530
Message-ID: <f53ea8d6-c31d-cc26-e99c-a7a3f23e6059@techveda.org>
References: <1507144330-1672-1-git-send-email-sunil.m@techveda.org>
 <CAOtvUMc3oVFxpgrj9i26_ETCG1CAr0Kj=77Lc2xVNdEPii-RkQ@mail.gmail.com>
 <1507226431.4434.37.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        karthik@techveda.org
To: Joe Perches <joe@perches.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38844 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdJFEHM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 00:07:12 -0400
Received: by mail-pg0-f65.google.com with SMTP id j3so1543584pga.5
        for <linux-crypto@vger.kernel.org>; Thu, 05 Oct 2017 21:07:11 -0700 (PDT)
In-Reply-To: <1507226431.4434.37.camel@perches.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 05 October 2017 11:30 PM, Joe Perches wrote:
> On Thu, 2017-10-05 at 10:07 +0300, Gilad Ben-Yossef wrote:
>> On Wed, Oct 4, 2017 at 10:12 PM,  <sunil.m@techveda.org> wrote:
>>> There is no need to create a local pointer variable "dev" and
>>> pass it various API's, instead use plat_dev which is enumerated
>>> by platform core on successful probe.
> []
>> I'm sorry but I don't understand what is the problem you are trying to solve or
>> what is the improvement suggested.

Hi Gilad and all,

Actually this patch is not a major improvement nor trying to solve some thing.

As struct device is a member of struct platform_device, I thought why can't we use
plat_dev (pointer to struct platform_device) through out the code. May be I was trying
to make code look compact, may be I am wrong.

>>
>> Why is having a local variable undesirable? I think having it makes
>> the code more readable, not less.
> 
> IMO: The local variable is _not_ undesirable.
>      It does make the code more readable and
>      shortens line lengths too.
> 

Yes, as you guys pointed out, we can use local variables. It is definitely making
the code more readable and shortening line lengths.

Please drop the patch, if this not helping the code look better.

Thanks
Suniel 

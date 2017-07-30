From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 2/3] staging: ccree: Convert to devm_ioremap_resource for
 map, unmap
Date: Sun, 30 Jul 2017 19:19:22 +0300
Message-ID: <CAOtvUMceo7Bw3fCcyai+FxLkaGR1O3z898CtMCDWL-QDZT_+Fg@mail.gmail.com>
References: <CAOtvUMeypygShtn4+nXCsepUrsDhBmZmqXMp60D116P8+2WT4A@mail.gmail.com>
 <1501165654-30601-1-git-send-email-gilad@benyossef.com> <1501165654-30601-2-git-send-email-gilad@benyossef.com>
 <20170727194829.symnl663plxd23uo@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Suniel Mahesh <sunil.m@techveda.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170727194829.symnl663plxd23uo@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 27, 2017 at 10:48 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Thu, Jul 27, 2017 at 05:27:33PM +0300, Gilad Ben-Yossef wrote:
>> +     new_drvdata->cc_base = devm_ioremap_resource(&plat_dev->dev,
>> +                                                  req_mem_cc_regs);
>> +     if (IS_ERR(new_drvdata->cc_base)) {
>> +             rc = PTR_ERR(new_drvdata->cc_base);
>>               goto init_cc_res_err;
>                 ^^^^^^^^^^^^^^^^^^^^
> (This code was in the original and not introduced by the patch.)
>
> Ideally, the goto name should say what the goto does.  In this case it
> does everything.  Unfortunately trying to do everything is very
> complicated so obviously the error handling is going to be full of bugs.

Thank you. This review is most helpful. I've added a patch to address
the specific
issues you've raised.

I also see some additional places that can get similar treatment to
both what you
suggested as well as what Suneil has done. I'll address those in
follow up patches.

Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

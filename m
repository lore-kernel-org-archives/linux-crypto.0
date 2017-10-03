From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 2/4] staging: ccree: simplify access to struct device
Date: Tue, 3 Oct 2017 13:43:53 +0300
Message-ID: <CAOtvUMeAGY352wDerW8Gsdc7jU2B0SNeGgdP0VLzs2Povz_Sbg@mail.gmail.com>
References: <1506935008-14240-1-git-send-email-gilad@benyossef.com>
 <1506935008-14240-3-git-send-email-gilad@benyossef.com>
 <1506938422.2274.11.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ofir Drang <ofir.drang@arm.com>
To: Joe Perches <joe@perches.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1506938422.2274.11.camel@perches.com>
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

On Mon, Oct 2, 2017 at 1:00 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2017-10-02 at 10:03 +0100, Gilad Ben-Yossef wrote:
>> Introduce a DEV macro to retrieve struct device from private
>> data structure in preparation to replacing custom logging
>> macros with proper dev_dbg and friends which require struct
>> device.
> []
>> diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
> []
>> @@ -103,6 +103,8 @@
>>  #define SSI_LOG_DEBUG(format, ...) do {} while (0)
>>  #endif
>>
>> +#define DEV(drvdata) ((&(drvdata)->plat_dev->dev))
>
> The name seems not particularly descriptive.
> It seems a longer name would
> not be too bad.
>
> Perhaps
>
> static inline struct device *drvdata_to_dev(struct ssi_drvdata *drvdata)
> {
>         return &drvdata->plat_dev->dev;
> }
>

Good point.

Fixed in v2.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 2/3] staging: ccree: handle limiting of DMA masks
Date: Thu, 2 Nov 2017 09:28:38 +0200
Message-ID: <CAOtvUMcCOB0uipXhQqCUfdr5OT9hEite7oXoDpDdUFqCg0u-NA@mail.gmail.com>
References: <1509450978-17784-1-git-send-email-gilad@benyossef.com>
 <1509450978-17784-3-git-send-email-gilad@benyossef.com>
 <20171101110918.f6ra2otu22jndjcc@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20171101110918.f6ra2otu22jndjcc@mwanda>
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

Hi,

Thank you for the review.

On Wed, Nov 1, 2017 at 1:09 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Oct 31, 2017 at 11:56:16AM +0000, Gilad Ben-Yossef wrote:
>>
>> -     if (!dev->coherent_dma_mask)
>> -             dev->coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
>> +     if (rc) {
>> +             dev_err(dev, "Error: failed in dma_set_mask, mask=%par\n",
>> +                     &dma_mask);
>> +             goto post_drvdata_err;
>
>
> Also this is not the right goto.  We should be turning the clk off.

Yes, it's wrong. I think a better thing to do though is to check the
DMA mask before turning the clock on, so the goto label
is right, but the code location is wrong...

>
> I don't really care for the naming scheme, and I know you renamed it for
> me already once and I feel bad for not liking it more.  It's still
> really a come-from label name and doesn't say what the goto does...
> Instead of post_clk_err, I wish it had names like "err_clk_off:".
>

> And in this case what it does is print a duplicative error message and
> return.  :/  The goto post_drvdata_err: lines should just print their
> own error messages if needed and return directly.  If there is no
> cleanup then there is no need for a goto.
>

Both good points. I will address them in a later patch.


> Anyway, that's not related to this patch.  Just resend it with
> goto post_clk_err: in the v2.

Will do.

Thanks!

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

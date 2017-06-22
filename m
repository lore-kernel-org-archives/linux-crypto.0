From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 5/7] staging: ccree: add clock management support
Date: Thu, 22 Jun 2017 16:29:01 +0300
Message-ID: <CAOtvUMdrb+KuEAYHF9jpqxtYcjZ=351L-ZQAWL3CU6KVhvgMWQ@mail.gmail.com>
References: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
 <1498115276-1601-6-git-send-email-gilad@benyossef.com>
 <20170622085815.xaw6dn56t2yjrdm4@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170622085815.xaw6dn56t2yjrdm4@mwanda>
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

On Thu, Jun 22, 2017 at 11:58 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Thu, Jun 22, 2017 at 10:07:51AM +0300, Gilad Ben-Yossef wrote:
>> +int cc_clk_on(struct ssi_drvdata *drvdata)
>> +{
>> +     int rc = 0;
>> +     struct clk *clk = drvdata->clk;
>> +
>> +     if (IS_ERR(clk))
>> +     /* No all devices have a clock associated with CCREE */
>> +             goto out;
>
> Ugh...  I hate this.  The "goto out;" here is a waste of time
> do-nothing-goto that returns diretly.  It's equivalent to "return 0;".
> Is that intended?  Even with the comment, it's not clear...
>
> People think do nothing gotos are a great idea but from reviewing tons
> and tons of real life errors, I can assure you that in real life (as
> opposed to theory) they don't prevent any future bugs and only introduce
> "forgot to set the error code" bugs.

I see your point and the code is indeed clearer this way.

Will fix.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

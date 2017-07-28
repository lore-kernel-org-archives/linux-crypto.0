From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] staging: ccree: Convert to devm_ioremap_resource for
 map, unmap
Date: Fri, 28 Jul 2017 11:40:00 +0300
Message-ID: <20170728084000.vrcr7ql6z72dzo4p@mwanda>
References: <CAOtvUMeypygShtn4+nXCsepUrsDhBmZmqXMp60D116P8+2WT4A@mail.gmail.com>
 <1501165654-30601-1-git-send-email-gilad@benyossef.com>
 <1501165654-30601-2-git-send-email-gilad@benyossef.com>
 <20170727194829.symnl663plxd23uo@mwanda>
 <eb2031ea-82c3-c46d-d20a-b872115b75c9@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Suniel Mahesh <sunil.m@techveda.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <eb2031ea-82c3-c46d-d20a-b872115b75c9@techveda.org>
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

On Fri, Jul 28, 2017 at 09:59:41AM +0530, Suniel Mahesh wrote:
> On Friday 28 July 2017 01:18 AM, Dan Carpenter wrote:
> > On Thu, Jul 27, 2017 at 05:27:33PM +0300, Gilad Ben-Yossef wrote:
> >> +	new_drvdata->cc_base = devm_ioremap_resource(&plat_dev->dev,
> >> +						     req_mem_cc_regs);
> >> +	if (IS_ERR(new_drvdata->cc_base)) {
> >> +		rc = PTR_ERR(new_drvdata->cc_base);
> >>  		goto init_cc_res_err;
> >                 ^^^^^^^^^^^^^^^^^^^^
> > (This code was in the original and not introduced by the patch.)
> 
> Hi Dan, the above lines of code were not in the original except 
> "goto init_cc_res_err;" which was doing the error handling at different
> places.
> 

Yes, yes.  I wasn't commenting on the patch just the existing code.

The patch is fine.

regards,
dan carpenter

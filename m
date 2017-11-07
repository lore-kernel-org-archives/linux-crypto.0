From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 6/8] staging: ccree: simplify pm manager using local var
Date: Tue, 7 Nov 2017 13:43:10 +0300
Message-ID: <20171107104310.xhdxl3q3bnh7uciw@mwanda>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
 <1510047606-5589-7-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1510047606-5589-7-git-send-email-gilad@benyossef.com>
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

On Tue, Nov 07, 2017 at 09:40:02AM +0000, Gilad Ben-Yossef wrote:
> --- a/drivers/staging/ccree/ssi_pm.c
> +++ b/drivers/staging/ccree/ssi_pm.c
> @@ -90,20 +90,24 @@ int cc_pm_resume(struct device *dev)
>  int cc_pm_get(struct device *dev)
>  {
>  	int rc = 0;
> +	struct ssi_drvdata *drvdata =
> +		(struct ssi_drvdata *)dev_get_drvdata(dev);

No need to cast:

	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);


regards,
dan carpenter

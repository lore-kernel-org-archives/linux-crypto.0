From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 3/4] PPC4xx: New file with SoC specific functions
Date: Thu, 23 Sep 2010 15:48:43 -0700
Message-ID: <4C9BD94B.8030203@intel.com>
References: <1285279906-16819-1-git-send-email-tmarri@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"yur@emcraft.com" <yur@emcraft.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>
To: "tmarri@apm.com" <tmarri@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33371 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0IWWsp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Sep 2010 18:48:45 -0400
In-Reply-To: <1285279906-16819-1-git-send-email-tmarri@apm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/23/2010 3:11 PM, tmarri@apm.com wrote:
> From: Tirumala Marri<tmarri@apm.com>
>
> This patch creates new file with SoC dependent functions.
>
> Signed-off-by: Tirumala R Marri<tmarri@apm.com>
> ---
> V1:
>    * Remove all 440SPe specific references.

Maybe it renames ppc440spe to ppc4xx but it adds things like...

> +#if defined(CONFIG_440SPe) || defined(CONFIG_440SP)
> +               np = of_find_compatible_node(NULL, NULL, "ibm,i2o-440spe");
> +#endif

...in the code.  Which is 1) not generic and 2) I suspect causes a 
compile warning for using an uninitialized variable.

> +               if (!np) {
> +                       pr_err("%s: can't find I2O device tree node\n",
> +                              __func__);
> +                       ret = -ENODEV;
> +                       goto err_req2;
> +               }

It looks to me like the common code will need to have a few build 
dependent helper routines as it appears one instance of the driver 
cannot simultaneously support 440sp, 440spe, and 460ex.

--
Dan

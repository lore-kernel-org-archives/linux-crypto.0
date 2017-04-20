From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/9] staging: ccree: introduce CryptoCell HW driver
Date: Thu, 20 Apr 2017 15:33:08 +0200
Message-ID: <20170420133308.GB8998@kroah.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
 <1492693983-8175-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, devel@driverdev.osuosl.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Binoy Jayan <binoy.jayan@linaro.org>,
 gilad.benyossef@arm.com, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
 "David S. Miller" <davem@davemloft.net>, Stuart Yoder <stuart.yoder@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1492693983-8175-2-git-send-email-gilad@benyossef.com>
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

On Thu, Apr 20, 2017 at 04:12:55PM +0300, Gilad Ben-Yossef wrote:
> +++ b/drivers/staging/ccree/bsp.h
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (C) 2012-2016 ARM Limited or its affiliates.
> + * 
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.

Oh, I have to ask, do you really mean "any later version" here and
elsewhere?

If so, then your MODULE_LICENSE() marking is wrong, please fix that up,
or fix up the license text, I can't take incompatible ones without
getting angry emails from legal people sent to me...

thanks,

greg k-h

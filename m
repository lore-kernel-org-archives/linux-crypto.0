From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH RFC 06/11] crypto: caam - Enable MXC devices to select
 CAAM driver in Kconfig
Date: Fri, 24 Jul 2015 20:14:31 +0300
Message-ID: <55B27277.2010403@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-7-git-send-email-vicki.milhoan@freescale.com>
 <20150617072734.GK7947@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <ruchika.gupta@freescale.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Victoria Milhoan <vicki.milhoan@freescale.com>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:45469
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752391AbbGXRsP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 13:48:15 -0400
In-Reply-To: <20150617072734.GK7947@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/17/2015 10:27 AM, Steffen Trumtrar wrote:
> On Mon, Jun 15, 2015 at 04:52:54PM -0700, Victoria Milhoan wrote:
>> From: Steve Cornelius <steve.cornelius@freescale.com>
>>
>> Allow CAAM to be selected in the kernel for Freescale i.MX6 devices if
>> ARCH_MXC is enabled.
>>
>> Signed-off-by: Steve Cornelius <steve.cornelius@freescale.com>
>> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
>> ---
>>  drivers/crypto/caam/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
>> index e7555ff..bc9aa07 100644
>> --- a/drivers/crypto/caam/Kconfig
>> +++ b/drivers/crypto/caam/Kconfig
>> @@ -1,6 +1,6 @@
>>  config CRYPTO_DEV_FSL_CAAM
>>  	tristate "Freescale CAAM-Multicore driver backend"
>> -	depends on FSL_SOC
>> +	depends on FSL_SOC || ARCH_MXC
> 
> Is this right? Are there other i.MX that have the CAAM IP core?
> Sounds like it should be SOC_IMX6 instead.

Even more, not all SOC_IMX6 variants have a CAAM block.

Not sure what's better:
-try to exactly indicate the HW that has the IP
-only name the arch / SoC (provided compilation passes), and then depend
on defconfig and/or device tree (and possibly boot loader dynamically
fixing the DT)

For e.g. Sahara crypto driver also depends on ARCH_MXC and it's not
available on all i.MX SoCs.

Thanks,
Horia

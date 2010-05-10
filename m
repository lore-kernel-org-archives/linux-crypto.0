From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 1/1] omap-sham: OMAP macros corrected
Date: Mon, 10 May 2010 15:49:55 +0300
Message-ID: <4BE800F3.2070602@nokia.com>
References: <948fcc79dd3d31f4930d4b62bb7ca7a19949fd9a.1273493232.git.dmitry.kasatkin@nokia.com> <20100510121416.GA12769@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:35755 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0EJMvE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 May 2010 08:51:04 -0400
In-Reply-To: <20100510121416.GA12769@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 10/05/10 15:14, ext Herbert Xu wrote:
> On Mon, May 10, 2010 at 03:07:55PM +0300, Dmitry Kasatkin wrote:
>   
>> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
>> ---
>>  arch/arm/mach-omap2/devices.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
>> index beac46c..79dbf04 100644
>> --- a/arch/arm/mach-omap2/devices.c
>> +++ b/arch/arm/mach-omap2/devices.c
>> @@ -456,7 +456,7 @@ static inline void omap_init_mcspi(void) {}
>>  
>>  #if defined(CONFIG_CRYPTO_DEV_OMAP_SHAM) || defined(CONFIG_CRYPTO_DEV_OMAP_SHAM_MODULE)
>>  
>> -#ifdef CONFIG_ARCH_OMAP24XX
>> +#ifdef CONFIG_ARCH_OMAP2
>>  static struct resource omap2_sham_resources[] = {
>>  	{
>>  		.start	= OMAP24XX_SEC_SHA1MD5_BASE,
>> @@ -474,7 +474,7 @@ static int omap2_sham_resources_sz = ARRAY_SIZE(omap2_sham_resources);
>>  #define omap2_sham_resources_sz		0
>>  #endif
>>  
>> -#ifdef CONFIG_ARCH_OMAP34XX
>> +#ifdef CONFIG_ARCH_OMAP3
>>  static struct resource omap3_sham_resources[] = {
>>  	{
>>  		.start	= OMAP34XX_SEC_SHA1MD5_BASE,
>>     
> Hi Tony:
>
> If I add this patch to cryptodev, is this going to cause any
> problems for you?
>
> Thbanks,
>   
Hi,

I should not be any problem, because it indeed needs to be like that.

- Dmitry


From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] crypto: ccp: Remove forward declaration
Date: Mon, 24 Sep 2018 12:40:40 -0700
Message-ID: <20180924194040.GA17672@flashbox>
References: <20180924172615.25591-1-natechancellor@gmail.com>
 <33c9afa7-ea62-1248-1da4-381f93238627@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <33c9afa7-ea62-1248-1da4-381f93238627@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 24, 2018 at 07:18:23PM +0000, Gary R Hook wrote:
> On 09/24/2018 12:26 PM, Nathan Chancellor wrote:
> > Clang emits a warning about this construct:
> > 
> > drivers/crypto/ccp/sp-platform.c:36:36: warning: tentative array
> > definition assumed to have one element
> > static const struct acpi_device_id sp_acpi_match[];
> >                                     ^
> > 1 warning generated.
> > 
> > Just remove the forward declarations and move the initializations up
> > so that they can be used in sp_get_of_version and sp_get_acpi_version.
> 
> I'm not going to out and out object to this just yet.
> 
> I am not a clang expert. Can you please provide a make command that 
> would explain how you precipitated this complaint?
> 

Hi Gary,

I can produce the warning with Clang 6.0 using the following set of
commands:

make ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- allyesconfig
./scripts/config -d CONFIG_CPU_BIG_ENDIAN
make ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- drivers/crypto/ccp/sp-platform.o

Nathan

> 
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >   drivers/crypto/ccp/sp-platform.c | 53 +++++++++++++++-----------------
> >   1 file changed, 25 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
> > index 71734f254fd1..b75dc7db2d4a 100644
> > --- a/drivers/crypto/ccp/sp-platform.c
> > +++ b/drivers/crypto/ccp/sp-platform.c
> > @@ -33,8 +33,31 @@ struct sp_platform {
> >   	unsigned int irq_count;
> >   };
> >   
> > -static const struct acpi_device_id sp_acpi_match[];
> > -static const struct of_device_id sp_of_match[];
> > +static const struct sp_dev_vdata dev_vdata[] = {
> > +	{
> > +		.bar = 0,
> > +#ifdef CONFIG_CRYPTO_DEV_SP_CCP
> > +		.ccp_vdata = &ccpv3_platform,
> > +#endif
> > +	},
> > +};
> > +
> > +#ifdef CONFIG_ACPI
> > +static const struct acpi_device_id sp_acpi_match[] = {
> > +	{ "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
> > +#endif
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id sp_of_match[] = {
> > +	{ .compatible = "amd,ccp-seattle-v1a",
> > +	  .data = (const void *)&dev_vdata[0] },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, sp_of_match);
> > +#endif
> >   
> >   static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
> >   {
> > @@ -201,32 +224,6 @@ static int sp_platform_resume(struct platform_device *pdev)
> >   }
> >   #endif
> >   
> > -static const struct sp_dev_vdata dev_vdata[] = {
> > -	{
> > -		.bar = 0,
> > -#ifdef CONFIG_CRYPTO_DEV_SP_CCP
> > -		.ccp_vdata = &ccpv3_platform,
> > -#endif
> > -	},
> > -};
> > -
> > -#ifdef CONFIG_ACPI
> > -static const struct acpi_device_id sp_acpi_match[] = {
> > -	{ "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
> > -	{ },
> > -};
> > -MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
> > -#endif
> > -
> > -#ifdef CONFIG_OF
> > -static const struct of_device_id sp_of_match[] = {
> > -	{ .compatible = "amd,ccp-seattle-v1a",
> > -	  .data = (const void *)&dev_vdata[0] },
> > -	{ },
> > -};
> > -MODULE_DEVICE_TABLE(of, sp_of_match);
> > -#endif
> > -
> >   static struct platform_driver sp_platform_driver = {
> >   	.driver = {
> >   		.name = "ccp",
> > 
> 

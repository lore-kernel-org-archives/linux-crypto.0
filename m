From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] crypto: ccp: Remove forward declaration
Date: Mon, 24 Sep 2018 13:24:40 -0700
Message-ID: <CAKwvOdkc=OymUoszBR7+QLiOfV2T_GiQ2Oom_C=Ebz76YU_sPw@mail.gmail.com>
References: <20180924172615.25591-1-natechancellor@gmail.com> <33c9afa7-ea62-1248-1da4-381f93238627@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Nathan Chancellor <natechancellor@gmail.com>,
        Thomas.Lendacky@amd.com, Gary.Hook@amd.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: ghook@amd.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <33c9afa7-ea62-1248-1da4-381f93238627@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 24, 2018 at 12:18 PM Gary R Hook <ghook@amd.com> wrote:
>
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

Tentative array definitions need to have the correct length specified;
it should either be forward declared as the correct length, or as this
patch does, skip the forward declare and move up the definition.
Thanks for this patch Nathan.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> I am not a clang expert. Can you please provide a make command that
> would explain how you precipitated this complaint?
>
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
> >       unsigned int irq_count;
> >   };
> >
> > -static const struct acpi_device_id sp_acpi_match[];
> > -static const struct of_device_id sp_of_match[];
> > +static const struct sp_dev_vdata dev_vdata[] = {
> > +     {
> > +             .bar = 0,
> > +#ifdef CONFIG_CRYPTO_DEV_SP_CCP
> > +             .ccp_vdata = &ccpv3_platform,
> > +#endif
> > +     },
> > +};
> > +
> > +#ifdef CONFIG_ACPI
> > +static const struct acpi_device_id sp_acpi_match[] = {
> > +     { "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
> > +     { },
> > +};
> > +MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
> > +#endif
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id sp_of_match[] = {
> > +     { .compatible = "amd,ccp-seattle-v1a",
> > +       .data = (const void *)&dev_vdata[0] },
> > +     { },
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
> > -     {
> > -             .bar = 0,
> > -#ifdef CONFIG_CRYPTO_DEV_SP_CCP
> > -             .ccp_vdata = &ccpv3_platform,
> > -#endif
> > -     },
> > -};
> > -
> > -#ifdef CONFIG_ACPI
> > -static const struct acpi_device_id sp_acpi_match[] = {
> > -     { "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
> > -     { },
> > -};
> > -MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
> > -#endif
> > -
> > -#ifdef CONFIG_OF
> > -static const struct of_device_id sp_of_match[] = {
> > -     { .compatible = "amd,ccp-seattle-v1a",
> > -       .data = (const void *)&dev_vdata[0] },
> > -     { },
> > -};
> > -MODULE_DEVICE_TABLE(of, sp_of_match);
> > -#endif
> > -
> >   static struct platform_driver sp_platform_driver = {
> >       .driver = {
> >               .name = "ccp",
> >
>


-- 
Thanks,
~Nick Desaulniers

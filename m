From: Rameshwar Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
Subject: Re: [PATCH v1 3/4] Crypto: Add support for APM X-Gene SoC CRC32C h/w
 accelerator driver
Date: Fri, 31 Jul 2015 14:42:23 +0530
Message-ID: <CAFd313xLojXUrAyY5xCFa_rTFzJn9=N=OUsRhBg+iDv25uSh6A@mail.gmail.com>
References: <1438258268-3099-1-git-send-email-rsahu@apm.com>
	<1438258268-3099-4-git-send-email-rsahu@apm.com>
	<20150731071358.GA25228@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	patches-qTEPVZfXA3Y@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150731071358.GA25228-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 31, 2015 at 12:43 PM, Herbert Xu
<herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org> wrote:
> On Thu, Jul 30, 2015 at 05:41:07PM +0530, Rameshwar Prasad Sahu wrote:
>>
>> +             .cra_name               = "xgene(crc32c)",
>> +             .cra_driver_name        = "crc32c-xgene",
>
> This looks wrong.  If you're implementing crc32c then cra_name
> should be just crc32c, i.e., the name of the algorithm that you
> are providing.

Okay, I will change it to crc32c only.
>
>> +MODULE_DESCRIPTION("APM X-Gene SoC CRC32C HW accelerator driver");
>> +MODULE_AUTHOR("Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>");
>> +MODULE_LICENSE("GPL");
>> +MODULE_VERSION("1.0");
>
> You should add a MODULE_ALIAS_CRYPTO too.
Okay
>
> Cheers,
> --
> Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

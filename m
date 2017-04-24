From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 6/9] staging: ccree: add FIPS support
Date: Mon, 24 Apr 2017 08:21:46 +0200
Message-ID: <2100092.9meQszc5SR@tauon.chronox.de>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com> <CAOtvUMdF53Bu65oLtDaUKvnxcMCBY1h=Dq8LaPwTGOwg4YKYVg@mail.gmail.com> <2108964.Kb0ivG6kmD@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Gilad Ben-Yossef <gilad.benyossef-5wv7dgnIgG8@public.gmane.org>,
        Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>,
        Stuart Yoder <stuart.yoder-5wv7dgnIgG8@public.gmane.org>
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2108964.Kb0ivG6kmD-b2PLbiJbNv8ftSvlWXw0+g@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 24. April 2017, 08:16:50 CEST schrieb Stephan Müller:

Hi Gilad,

> > 
> > int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
> > 
> >                       unsigned int keylen)
> > 
> > However, this does not check that k1 == k3. In this case DES3
> > becomes 2DES (2-keys TDEA), the use of which was dropped post 2015
> > by NIST Special Publication 800-131A*.
> 
> It is correct that the RFC wants at least a 2key 3DES. And it is correct
> that SP800-131A mandates 3key 3DES post 2015. All I am saying is that FIPS
> 140-2 does *not* require a technical verification of the 3 keys being not
> identical.

One side note: we had discussed a patch to this function in the past, see [1].

[1] https://patchwork.kernel.org/patch/8293441/

Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

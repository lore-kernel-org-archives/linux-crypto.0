From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 6/9] staging: ccree: add FIPS support
Date: Mon, 24 Apr 2017 08:16:50 +0200
Message-ID: <2108964.Kb0ivG6kmD@tauon.chronox.de>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com> <CAOtvUMcOib2xr=THj1hy_uPtVhRHgJ2-4__mUBb5VwANQ1GA_A@mail.gmail.com> <CAOtvUMdF53Bu65oLtDaUKvnxcMCBY1h=Dq8LaPwTGOwg4YKYVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
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
To: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOtvUMdF53Bu65oLtDaUKvnxcMCBY1h=Dq8LaPwTGOwg4YKYVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 24. April 2017, 08:06:09 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,
> 
> Well, it turns out there is and we do :-)
> 
> This is from crypto/des_generic.c:
> 
> /*
>  * RFC2451:
>  *
>  *   For DES-EDE3, there is no known need to reject weak or
>  *   complementation keys.  Any weakness is obviated by the use of
>  *   multiple keys.
>  *
>  *   However, if the first two or last two independent 64-bit keys are
>  *   equal (k1 == k2 or k2 == k3), then the DES3 operation is simply the
>  *   same as DES.  Implementers MUST reject keys that exhibit this
>  *   property.
>  *
>  */
> int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
>                       unsigned int keylen)
> 
> However, this does not check that k1 == k3. In this case DES3
> becomes 2DES (2-keys TDEA), the use of which was dropped post 2015
> by NIST Special Publication 800-131A*.

It is correct that the RFC wants at least a 2key 3DES. And it is correct that 
SP800-131A mandates 3key 3DES post 2015. All I am saying is that FIPS 140-2 
does *not* require a technical verification of the 3 keys being not identical.

Note, formally, FIPS 140-2 requires that the 3 keys (i.e. all 192 bits) must 
be obtained from *one* call to a DRBG or KDF (separate independent calls to, 
say, obtain one key at a time is *not* permitted). Of course, fixing the 
parity bits is allowed after obtaining the random number.
> 
> Would it be acceptable if I offer a patch adding this check to
> __des3_ede_setkey()
> and use that in the ccree driver?

I am not sure it makes sense as the core requirement is the *one* invocation 
of the DRBG.

Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

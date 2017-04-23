From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 6/9] staging: ccree: add FIPS support
Date: Sun, 23 Apr 2017 20:57:58 +0200
Message-ID: <19392241.HaQDpS1BQU@positron.chronox.de>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com> <6020947.G2hzgUSCE3@positron.chronox.de> <CAOtvUMcOib2xr=THj1hy_uPtVhRHgJ2-4__mUBb5VwANQ1GA_A@mail.gmail.com>
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
In-Reply-To: <CAOtvUMcOib2xr=THj1hy_uPtVhRHgJ2-4__mUBb5VwANQ1GA_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am Sonntag, 23. April 2017, 11:48:58 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,

> I do wonder if there is value in alternate behavior of stopping crypto
> API on FIPS error rather than a panic though. I will try to get an
> explanation why we do it this way.

In FIPS, all crypto function must cease if a self test fails. This can be done 
by instrumenting the crypto API calls with a check to a global flag or by 
simply terminating the entire "FIPS module".

The panic() is the simplest approach to meet that requirement.

Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

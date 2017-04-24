From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 6/9] staging: ccree: add FIPS support
Date: Mon, 24 Apr 2017 09:23:32 +0200
Message-ID: <1965077.Btm8atTi0c@tauon.chronox.de>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com> <2100092.9meQszc5SR@tauon.chronox.de> <CAOtvUMdYtLa10dUQ--5hxeYOAi+vw9OTLZF=WPmDS27cr6KvJg@mail.gmail.com>
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
In-Reply-To: <CAOtvUMdYtLa10dUQ--5hxeYOAi+vw9OTLZF=WPmDS27cr6KvJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 24. April 2017, 09:07:45 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,

> I guess we could change the function to indicate that a key is valid
> for decryption but not encryption
> and have the implementation limiting based on that if there is an
> interest in SP800-131A compliance.

I would be delighted to see and review a patch.

Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

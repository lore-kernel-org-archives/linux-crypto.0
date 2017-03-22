From: Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/3] clk: meson-gxbb: expose clock CLKID_RNG0
Date: Wed, 22 Mar 2017 08:24:08 -0700
Message-ID: <m2lgrxnxlz.fsf@baylibre.com>
References: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
        <20170316100743.GA12137@gondor.apana.org.au>
        <m2mvcl6pwg.fsf@baylibre.com>
        <20170317083032.GA18512@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jerome Brunet <jbrunet-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        Neil Armstrong <narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        linux-amlogic-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
        Michael Turquette <mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        linux-clk-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170317083032.GA18512-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org> (Herbert Xu's
        message of "Fri, 17 Mar 2017 16:30:32 +0800")
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org> writes:

> On Thu, Mar 16, 2017 at 11:24:31AM -0700, Kevin Hilman wrote:
>> Hi Herbert,
>> 
>> Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org> writes:
>> 
>> > On Wed, Feb 22, 2017 at 07:55:24AM +0100, Heiner Kallweit wrote:
>> >> Expose clock CLKID_RNG0 which is needed for the HW random number generator.
>> >> 
>> >> Signed-off-by: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >
>> > All patches applied.  Thanks.
>> 
>> Actually, can you just apply [PATCH 4/4] to your tree?
>> 
>> The clock and DT patches need to go through their respective trees or
>> will otherwise have conflicts with other things going in via those
>> trees.
>
> It's too late now.  Please speak up sooner next time.  These
> patches were posted a month ago.

Because this will be causing conflicts with both the platform (amlogic)
tree and the clk tree, could provide an immutable branch where these are
applied to help us handle these conflicts?

Thanks,

Kevin
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

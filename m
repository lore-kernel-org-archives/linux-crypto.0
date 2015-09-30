From: Maxime Coquelin <maxime.coquelin-qxv4g6HH51o@public.gmane.org>
Subject: Re: [STLinux Kernel] [PATCH v2 0/7] hwrng: Add support for
 STMicroelectronics' RNG IP
Date: Wed, 30 Sep 2015 16:49:55 +0200
Message-ID: <560BF693.2090405@st.com>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <20150918140756.GK9249@gondor.apana.org.au>
 <CAF2Aj3h7Jy=tpYdZTdbxAJwa=147_hAu3reOFrbEh=JdrMFWLQ@mail.gmail.com>
 <20150918151137.GA10763@gondor.apana.org.au> <20150918155112.GE3218@x1>
 <20150929142932.GY27197@x1> <20150930134757.GA18408@gondor.apana.org.au>
 <20150930141539.GD27197@x1> <20150930142812.GA19039@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Peter Korsgaard <peter-+2lRwdCCLRT2eFz/2MeuCQ@public.gmane.org>,
	"kernel-F5mvAk5X5gdBDgjK7y7TUQ@public.gmane.org" <kernel-F5mvAk5X5gdBDgjK7y7TUQ@public.gmane.org>,
	Kieran Bingham <kieranbingham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Fabio Estevam <festevam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150930142812.GA19039-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org



On 09/30/2015 04:28 PM, Herbert Xu wrote:
> On Wed, Sep 30, 2015 at 03:15:39PM +0100, Lee Jones wrote:
>>> I prefer not to merge patches that cannot be tested.  Without
>>> the DT bits in patch 6 the other five patches are useless.  So
>>> I think patch 6 should be applied together with the other five
>>> which add the driver.
>> That's crazy talk.  If all subsystem maintainers abide by this rule
>> there would be chaos.  We'd either need to send pull-requests to each
>> other for every set which crossed a subsystems boundary, or 1000's of
>> merge conflicts would ensue at merge time.
>>
>> The (sensible) rule we normally stick to is; as long as there isn't
>> a _build_ dependency, then the patches should filter though their
>> respective trees; _functional_ dependencies have nothing to do with
>> us as maintainers.  Another chaos preventing rule we abide by is; thou
>> shalt not apply patches belonging to other maintainer's subsystems
>> without the appropriate Ack-by and a subsequent "you may take this
>> though your tree" and/or "please send me an immutable pull-request".
> So you want the series to be merged in two parts via two different
> trees where neither can be tested? That sounds crazy to me.
>

Yes, that's what we want, and that's how people work usually.
I will repeat what Lee was saying, what we have to ensure as maintainer 
is that our tree is building.
We will be able to test it with linux-next.

Regards,
Maxime


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

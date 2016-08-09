From: Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 9 Aug 2016 07:24:58 -0300
Message-ID: <20160809102458.GA20214@khazad-dum.debian.net>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <12791731.pG3fmEhvyp@tauon.atsec.com>
 <20160809095657.GB6618@gondor.apana.org.au>
 <11316081.S4pPZmZMrt@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	"miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	"Valo, Kalle" <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	"Sepehrdad, Pouyan" <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <11316081.S4pPZmZMrt-gNvIQDDl/k7Ia13z/PHSgg@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 09 Aug 2016, Stephan Mueller wrote:
> RHEL 7 and Fedora do not adjust it. So, shall we consider those rng-tools then 
> broken (at least in those large distros)?

Might I humbly suggest that the kernel start providing some metatada
about the quality of the random source that userspace can consume?
Preferably by a new ioctl, so that it will fit naturally if we ever
extend /dev/hwrng to support more than one source?

That would allow for auto tunning to be implemented in userspace...

-- 
  Henrique Holschuh
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

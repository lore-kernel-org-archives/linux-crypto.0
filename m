From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 09 Aug 2016 11:37:39 +0200
Message-ID: <1645997.7cVzaEi3NG@tauon.atsec.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <2569442.q63FVBJjUH@tauon.atsec.com> <20160809091755.GA6370@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	"miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	"Valo, Kalle" <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	"Sepehrdad, Pouyan" <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160809091755.GA6370-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 9. August 2016, 17:17:55 CEST schrieb Herbert Xu:

Hi Herbert,

> On Tue, Aug 09, 2016 at 11:02:58AM +0200, Stephan Mueller wrote:
> > But shouldn't the default of the rngd then be adjusted a bit?
> 
> Please elaborate.

in rngd_linux.c:random_add_entropy(void *buf, size_t size):

        entropy.ent_count = size * 8;
        entropy.size = size;
        memcpy(entropy.data, buf, size);

        if (ioctl(random_fd, RNDADDENTROPY, &entropy) != 0) {

...


in rngd.c:do_loop():

                        retval = iter->xread(buf, sizeof buf, iter);
...
                        rc = update_kernel_random(random_step,
                                             buf, iter->fipsctx);

where update_kernel_random simply invokes random_add_entropy in chunks.

Hence, the rngd reads some bytes from /dev/hwrand and injects it into /dev/
random with an entropy estimate that is equal to the read bytes.

With less than perfect noise sources, entropy.ent_count should be much 
smaller.
> 
> Thanks,



Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

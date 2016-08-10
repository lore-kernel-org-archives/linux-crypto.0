From: "Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 02:35:04 +0000
Message-ID: <1470796501856.53342@qti.qualcomm.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <2569442.q63FVBJjUH@tauon.atsec.com>
 <20160809091755.GA6370@gondor.apana.org.au>,<1645997.7cVzaEi3NG@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	"miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	"Valo, Kalle" <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	"Sepehrdad, Pouyan" <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1645997.7cVzaEi3NG-gNvIQDDl/k7Ia13z/PHSgg@public.gmane.org>
Content-Language: en-US
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

For those less perfect noise source, can't pass the FIPS test.

static int update_kernel_random(int random_step,
        unsigned char *buf, fips_ctx_t *fipsctx_in)
{
        unsigned char *p; 
        int fips;

        fips = fips_run_rng_test(fipsctx_in, buf);
        if (fips)
                return 1;

        for (p = buf; p + random_step <= &buf[FIPS_RNG_BUFFER_SIZE];
                 p += random_step) {
                random_add_entropy(p, random_step);
                random_sleep();
        }
        return 0;
}

--
Miaoqing
________________________________________
From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Sent: Tuesday, August 9, 2016 5:37 PM
To: Herbert Xu
Cc: Pan, Miaoqing; Matt Mackall; miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org; Valo, Kalle; linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ath9k-devel; linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org; Sepehrdad, Pouyan
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default

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

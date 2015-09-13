From: Peter Korsgaard <peter-+2lRwdCCLRT2eFz/2MeuCQ@public.gmane.org>
Subject: Re: [PATCH 2/6] hwrng: core: Simplify RNG switching from sysfs
Date: Sun, 13 Sep 2015 16:24:13 +0200
Message-ID: <87a8sq4ctu.fsf@dell.be.48ers.dk>
References: <1442002110-28733-1-git-send-email-lee.jones@linaro.org>
	<1442002110-28733-3-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, kernel-F5mvAk5X5gdBDgjK7y7TUQ@public.gmane.org
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442002110-28733-3-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> (Lee
	Jones's message of "Fri, 11 Sep 2015 21:08:26 +0100")
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

>>>>> "Lee" == Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

 > If we attempt to use sysfs to change the current RNG in the usual
 > way i.e. issuing something like:

 > `echo 8a8a000.rng > /sys/devices/virtual/misc/hw_random/rng_current`

 > ... it will fail because the code doesn't currently take the '\n'
 > into consideration.  Well, now it does.

 > Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 > ---
 >  drivers/char/hw_random/core.c | 7 ++++++-
 >  1 file changed, 6 insertions(+), 1 deletion(-)

 > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
 > index da8faf7..14dc984 100644
 > --- a/drivers/char/hw_random/core.c
 > +++ b/drivers/char/hw_random/core.c
 > @@ -316,6 +316,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 >  					const char *buf, size_t len)
 >  {
 >  	int err;
 > +	int snip = 0;
 >  	struct hwrng *rng;
 
 >  	err = mutex_lock_interruptible(&rng_mutex);
 > @@ -323,7 +324,11 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 >  		return -ERESTARTSYS;
 >  	err = -ENODEV;
 >  	list_for_each_entry(rng, &rng_list, list) {
 > -		if (strcmp(rng->name, buf) == 0) {
 > +
 > +		if (buf[len-1] == '\n')
 > +			snip = 1; /* Snip one character */
 > +

How about using sysfs_streq() instead, which is what is done elsewhere?

-- 
Bye, Peter Korsgaard
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

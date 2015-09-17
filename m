From: Peter Korsgaard <peter@korsgaard.com>
Subject: Re: [PATCH v2 3/7] hwrng: core: Simplify RNG switching from sysfs
Date: Thu, 17 Sep 2015 16:08:38 +0200
Message-ID: <87fv2dt9y1.fsf@dell.be.48ers.dk>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
	<1442497557-9271-4-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, festevam@gmail.com,
	kieranbingham@gmail.com, kernel@stlinux.com
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34020 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbbIQOIm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2015 10:08:42 -0400
In-Reply-To: <1442497557-9271-4-git-send-email-lee.jones@linaro.org> (Lee
	Jones's message of "Thu, 17 Sep 2015 14:45:53 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>>>> "Lee" == Lee Jones <lee.jones@linaro.org> writes:

 > If we attempt to use sysfs to change the current RNG in the usual
 > way i.e. issuing something like:

 > `echo 8a8a000.rng > /sys/devices/virtual/misc/hw_random/rng_current`

 > ... it will fail because the code doesn't currently take the '\n'
 > into consideration.  Well, now it does.

 > Signed-off-by: Lee Jones <lee.jones@linaro.org>
 > ---
 >  drivers/char/hw_random/core.c | 2 +-
 >  1 file changed, 1 insertion(+), 1 deletion(-)

 > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
 > index da8faf7..2d4a969 100644
 > --- a/drivers/char/hw_random/core.c
 > +++ b/drivers/char/hw_random/core.c
 > @@ -323,7 +323,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 >  		return -ERESTARTSYS;
 >  	err = -ENODEV;
 >  	list_for_each_entry(rng, &rng_list, list) {
 > -		if (strcmp(rng->name, buf) == 0) {
 > +		if (sysfs_streq(rng->name, buf)) {

Looks good.

Acked-by: Peter Korsgaard <peter@korsgaard.com>

-- 
Venlig hilsen,
Peter Korsgaard 

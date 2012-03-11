From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] crypto: fix build failure in mv_cesa.c (missing of header)
Date: Sun, 11 Mar 2012 12:17:29 -0400
Message-ID: <CAP=VYLpm9B7i9MSGTc4ogVPACmC3J1SVtNDugoYop5mJ8gLb9g@mail.gmail.com>
References: <1331323105-21034-1-git-send-email-paul.gortmaker@windriver.com>
	<20120311014226.GU5050@titan.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: michael@walle.cc, linux-crypto@vger.kernel.org,
	linux-next@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120311014226.GU5050@titan.lakedaemon.net>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Mar 10, 2012 at 8:42 PM, Jason Cooper <jason@lakedaemon.net> wr=
ote:
> On Fri, Mar 09, 2012 at 02:58:25PM -0500, Paul Gortmaker wrote:
>> Commit 737b75872487f560397ba34846a19823b1addf88 (linux-next)
>>
>> =A0 =A0 "ARM: kirkwood: mv_cesa devicetree bindings"
>>
>> fails to compile as follows:
>>
>> =A0CC =A0 =A0 =A0drivers/crypto/mv_cesa.o
>> =A0drivers/crypto/mv_cesa.c:1139: error: implicit declaration of fun=
ction 'of_match_ptr'
>> =A0drivers/crypto/mv_cesa.c:1139: error: 'mv_cesa_dt_ids' undeclared=
 here (not in a function)
>> =A0drivers/crypto/mv_cesa.c:1139: error: initializer element is not =
constant
>> =A0drivers/crypto/mv_cesa.c:1139: error: (near initialization for 'm=
arvell_crypto.driver.of_match_table')
>>
>> because it is missing the linux/of.h header file.
>>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>
> Paul,
>
> Thanks for the patch. =A0Unfortunately, I'm not learning fast enough.=
 =A0;-)
> This series has been in a lot of flux lately, as you've experienced.
>
> The good news is, after talking with Olaf and Arnd, I think I have a
> good workflow figured out. =A0Hopefully, failures like this won't hap=
pen
> in the future.

Sounds good -- don't be too hard on yourself wrt. a minor breakage.
=46eel free to just squish the above patch into whatever updates you
have going.  I don't see it needing to exist as a standalone commit.

THanks,
Paul.
--

>
> As an fyi, I'm probably going to take kirkwood_dt_staging down (or, l=
abel
> it broken ;-) ) =A0I intended it as a publicly viewable branch of "wh=
at's
> coming down the pipe", but it's not working out the way I intended.
>
> As for mv_cesa, it's next on my list. =A0As soon as I figure out the =
irq
> stuff.
>
> Thanks for testing.
>
> Jason.
>
>>
>> diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
>> index b7a3d48..093e214 100644
>> --- a/drivers/crypto/mv_cesa.c
>> +++ b/drivers/crypto/mv_cesa.c
>> @@ -10,6 +10,7 @@
>> =A0#include <crypto/algapi.h>
>> =A0#include <linux/crypto.h>
>> =A0#include <linux/interrupt.h>
>> +#include <linux/of.h>
>> =A0#include <linux/io.h>
>> =A0#include <linux/kthread.h>
>> =A0#include <linux/platform_device.h>
>> --
>> 1.7.9.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

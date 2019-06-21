Return-Path: <SRS0=L99/=UU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17756C43613
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Jun 2019 01:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DECC42075E
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Jun 2019 01:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YT9pP8mm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfFUBDU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 21:03:20 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44734 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfFUBDU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 21:03:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id n2so2462038pgp.11
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2019 18:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:to:from:subject:cc:user-agent:date;
        bh=/QNfQWig2oeC5POufHOkxnAuAVkUYpsqHyVQpvyXPFM=;
        b=YT9pP8mmnoLSnibB3gevIC8O4iva3l7WbYe+TvJLiuO8Sl8rGyxguOWdu9Xkz3aMFK
         0JcQpSOWMOO4Ipb2MWZdlgVt1gqKnEVbbl/k08kEf7rdSzKoGFDVsTEq54pldf9AvuOi
         AEJ/VAYyprATMD4PR72B+IkMkBKhPYLYh7Sug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:to:from:subject:cc
         :user-agent:date;
        bh=/QNfQWig2oeC5POufHOkxnAuAVkUYpsqHyVQpvyXPFM=;
        b=OtQNqzoQ3V0Fa2axDXjAtm6lEuc5KgnfDZ6KxjzkAAX0hVLDVyTY041V093FCKtTtQ
         gmz3xjY0bGHPPlHmT6QQXDBjskTTxIM4NAktclC6PQm5FIAyD5d1plqsPIkHLLJbCaNv
         zrLqyxdEKTT4Vw9hmHpCRqmusfdDCmUq8TTyAqyKj9pC0Z/qE/Ov0gGdG1RG9e+e0MBw
         UZ7OQfjwEaSVHe9wxIAsQkVb8WDms5GItX8T4akNG+7HfRQL0WyX9il/J5nqMiQc6KyW
         OuvMvUYK/BeV4WPJiqquuFolDIQWxRCb10Krqz06gmABkRorXzVNKwWYtmCsN5T5SWZ0
         gpIw==
X-Gm-Message-State: APjAAAVNkPokWuPl4jCgBQLP0sW007bszKMuCbD4REUt2RqMWm1rVWgF
        HMGspyvepg9JElTpM2doNlSEZQ==
X-Google-Smtp-Source: APXvYqw5MjR8b5QF1inGOhF3D0ddQ3KFCau26pbHfnEVTRxI5c2/WPbsRNarL55GkCl3Ecm1fJ+H/A==
X-Received: by 2002:a63:3c14:: with SMTP id j20mr3859916pga.169.1561078999454;
        Thu, 20 Jun 2019 18:03:19 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id y185sm634195pfy.110.2019.06.20.18.03.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 18:03:18 -0700 (PDT)
Message-ID: <5d0c2cd6.1c69fb81.e66af.32bf@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190617225134.GA30762@ziepe.ca>
References: <20190613180931.65445-1-swboyd@chromium.org> <20190613180931.65445-2-swboyd@chromium.org> <20190613232613.GH22901@ziepe.ca> <5d03e394.1c69fb81.f028c.bffb@mx.google.com> <20190617225134.GA30762@ziepe.ca>
To:     Jason Gunthorpe <jgg@ziepe.ca>
From:   Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 1/8] tpm: block messages while suspended
Cc:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrey Pronin <apronin@chromium.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, devicetree@vger.kernel.org,
        Duncan Laurie <dlaurie@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>
User-Agent: alot/0.8.1
Date:   Thu, 20 Jun 2019 18:03:17 -0700
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Jason Gunthorpe (2019-06-17 15:51:34)
> On Fri, Jun 14, 2019 at 11:12:36AM -0700, Stephen Boyd wrote:
> > Quoting Jason Gunthorpe (2019-06-13 16:26:13)
> > > On Thu, Jun 13, 2019 at 11:09:24AM -0700, Stephen Boyd wrote:
> > > > From: Andrey Pronin <apronin@chromium.org>
> > > >=20
> > > > Other drivers or userspace may initiate sending a message to the tpm
> > > > while the device itself and the controller of the bus it is on are
> > > > suspended. That may break the bus driver logic.
> > > > Block sending messages while the device is suspended.
> > > >=20
> > > > Signed-off-by: Andrey Pronin <apronin@chromium.org>
> > > > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > > >=20
> > > > I don't think this was ever posted before.
> > >=20
> > > Use a real lock.
> > >=20
> >=20
> > To make sure the bit is tested under a lock so that suspend/resume can't
> > update the bit in parallel?
>=20
> No, just use a real lock, don't make locks out of test bit/set bit
>=20

Ok. I looked back on the history of this change in our kernel (seems it
wasn't attempted upstream for some time) and it looks like the problem
may have been that the khwrng kthread (i.e. hwrng_fill()) isn't frozen
across suspend/resume. This kthread runs concurrently with devices being
resumed, the cr50 hardware is still suspended, and then a tpm command is
sent and it hangs the I2C bus because the device hasn't been properly
resumed yet.

I suspect a better approach than trying to hold of all TPM commands
across suspend/resume would be to fix the caller here to not even try to
read the hwrng during this time. It's a general problem for other hwrngs
that have some suspend/resume hooks too. This kthread is going to be
running while suspend/resume is going on if the random entropy gets too
low, and that probably shouldn't be the case.

What do you think of the attached patch? I haven't tested it, but it
would make sure that the kthread is frozen so that the hardware can be
resumed before the kthread is thawed and tries to go touch the hardware.

----8<-----
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 95be7228f327..3b88af3149a7 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/hw_random.h>
 #include <linux/kernel.h>
@@ -421,7 +422,9 @@ static int hwrng_fillfn(void *unused)
 {
 	long rc;
=20
-	while (!kthread_should_stop()) {
+	set_freezable();
+
+	while (!kthread_freezable_should_stop(NULL)) {
 		struct hwrng *rng;
=20
 		rng =3D get_current_rng();

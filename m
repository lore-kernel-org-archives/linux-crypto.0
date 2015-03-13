From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Fri, 13 Mar 2015 10:08:29 -0400
Message-ID: <CAJUS3Xmv3atWu=-ydYrSVe+5PON7SM22hoXDQ1_5_ULM_zKvbQ@mail.gmail.com>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
	<54F464E4.8080204@freescale.com>
	<54F475A8.6030105@gmail.com>
	<20150302220923.GC30523@darwin.bork.org>
	<54F5D6D5.8070407@freescale.com>
	<CAJUS3Xnw66Eu6tvGPpdcet6KLjhKM=ptj8NRaztAVr0h_r+LqQ@mail.gmail.com>
	<54FD72E4.1060701@freescale.com>
	<CAJUS3XkY0tbYqBbU5HR7NT63UPFi5DO6XWuymbZnQaJEA5kkBw@mail.gmail.com>
	<550063D1.2070105@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
	linuxppc-dev@lists.ozlabs.org, Milan Broz <gmazyland@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36017 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbbCMOIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 10:08:47 -0400
Received: by iegc3 with SMTP id c3so109400552ieg.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2015 07:08:46 -0700 (PDT)
In-Reply-To: <550063D1.2070105@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Horia,

On Wed, Mar 11, 2015 at 11:48 AM, Horia Geant=C4=83
<horia.geanta@freescale.com> wrote:
>
> While here: note that xts-talitos supports only two key lengths - 256
> and 512 bits. There are tcrypt speed tests that check also for 384-bi=
t
> keys (which is out-of-spec, but still...), leading to a "Key Size Err=
or"
> - see below (KSE bit in AESU Interrupt Status Register is set)

Ok.  I've limited the keysize to 32 or 64 bytes for AES-XTS in the
talitos driver.

This was my first experiments with the tcrypt module.  It also brought
up another issue related to the IV limitations of this hardware.  The
latest patch that I have returns an error when there is a non-zero
value in the second 8 bytes of the IV:

+       /*
+        * AES-XTS uses the first two AES Context registers for:
+        *
+        *     Register 1:   Sector Number (Little Endian)
+        *     Register 2:   Sector Size   (Big Endian)
+        *
+        * Whereas AES-CBC uses registers 1/2 as a 16-byte IV.
+        */
+       if ((ctx->desc_hdr_template &
+            (DESC_HDR_SEL0_MASK | DESC_HDR_MODE0_MASK)) =3D=3D
+            (DESC_HDR_SEL0_AESU | DESC_HDR_MODE0_AESU_XTS)) {
+               u64 *aesctx2 =3D (u64 *)areq->info + 1;
+
+               if (*aesctx2 !=3D 0) {
+                       dev_err(ctx->dev,
+                               "IV length limited to the first 8 bytes=
=2E");
+                       return ERR_PTR(-EINVAL);
+               }
+
+               /* Fixed sized sector */
+               *aesctx2 =3D cpu_to_be64(1 << SECTOR_SHIFT);
+       }


This approach causes the tcrypt tests to fail because tcrypt sets all
16 bytes of the IV to 0xff.  I think returning an error is the right
approach for the talitos module, but it would be nice if tcrypt still
worked.  Should tcrypt just set the IV bytes to 0 instead of 0xff?
Isn't one IV just as good as another?  I think adding exceptions to
the tcrypt code would be ugly, but maybe one should be made for XTS
since the standard dictates that the IV should be plain or plain64?

Thanks,
mh

--=20
Martin Hicks P.Eng.      |         mort@bork.org
Bork Consulting Inc.     |   +1 (613) 266-2296

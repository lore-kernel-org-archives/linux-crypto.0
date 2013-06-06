From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH  RESEND/V2] crypto: Ignore validity dates of X.509 certificates
 at loading/parsing time
Date: Thu, 06 Jun 2013 13:17:23 +0200
Message-ID: <51B06FC3.8090405@ahsoftware.de>
References: <1364409710-6458-1-git-send-email-holler@ahsoftware.de> <1367503746-6431-1-git-send-email-holler@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rusty Russell <rusty@rustcorp.com.au>,
	David Howells <dhowells@redhat.com>,
	Josh Boyer <jwboyer@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
To: Alexander Holler <holler@ahsoftware.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:40992 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab3FFLSR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Jun 2013 07:18:17 -0400
In-Reply-To: <1367503746-6431-1-git-send-email-holler@ahsoftware.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am 02.05.2013 16:09, schrieb Alexander Holler:
> I don't see any real use case where checking the validity dates of X.509
> certificates at parsing time adds any security gain. In contrast, doing so
> makes MODSIGN unusable on systems without a RTC (or systems with a possible
> wrong date in a existing RTC, or systems where the RTC is read after the keys
> got loaded).
> 
> If something really cares about the dates, it should check them at the time
> when the certificates are used, not when they are loaded and parsed.
> 
> So just remove the validity check of the dates in the parser.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> Cc: stable@vger.kernel.org

As it just happened to me again and I've recently posted some patches
which do make it possible to experience the problem on x86 systems too,
here is a reminder.

To replay the problem (on x86 or any other arch), apply the 3 patches in
this series:

https://lkml.org/lkml/2013/6/5/430

build a kernel with CONFIG_MODULE_SIG_FORCE=y and start that kernel with
hctosys=none as kernel command line parameter.

This will disable the "persistent" clock (and any RTC), thus the kernel
will refuse to load modules because it doesn't has a valid time when
loading the certificate.

Regards,

Alexander Holler

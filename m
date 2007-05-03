From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: [PATCH] crypto: convert crypto.h to UTF-8
Date: Thu, 3 May 2007 07:17:25 -0400 (EDT)
Message-ID: <alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
 <20070502044345.GA29384@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1875672472-1995079615-1178191047=:17390"
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hammerhead.shentel.net ([204.111.1.228]:54768 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXECLTI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 07:19:08 -0400
In-Reply-To: <20070502044345.GA29384@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1875672472-1995079615-1178191047=:17390
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Convert the encoding of <include/linux/crypto.h> from ISO-8859-1 to UTF-8.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

Did this file individually, per request. Will re-do the whole tree later 
as I'm still working on my handy-dandy testing and patching tools and 
don't have a lot of time outside of work until the summer gets underway.

The patch works in ISO-8859-1 encoding. If I am unsuccessful in getting 
this mail to send as that, or if your viewer reinterprets it from that, 
you'll need to use the file attached as MIME type octet-stream. Thanks for 
your time and interest.

--- linux-2.6.21-rc7-git4.orig/include/linux/crypto.h	2007-04-20 20:22:13.000000000 -0400
+++ linux-2.6.21-rc7-git4.mod/include/linux/crypto.h	2007-05-03 07:09:47.000000000 -0400
@@ -6,7 +6,7 @@
  * Copyright (c) 2005 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * Portions derived from Cryptoapi, by Alexander Kjeldaas <astor@fast.no>
- * and Nettle, by Niels Möller.
+ * and Nettle, by Niels MÃ¶ller.
  * 
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
--1875672472-1995079615-1178191047=:17390
Content-Type: APPLICATION/octet-stream; name=include-linux-crypto-h-to-utf8.patch.bin
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.0.98.0705030717250.17390@sigma.j-a-k-j.com>
Content-Description: 
Content-Disposition: attachment; filename=include-linux-crypto-h-to-utf8.patch.bin

LS0tIGxpbnV4LTIuNi4yMS1yYzctZ2l0NC5vcmlnL2luY2x1ZGUvbGludXgv
Y3J5cHRvLmgJMjAwNy0wNC0yMCAyMDoyMjoxMy4wMDAwMDAwMDAgLTA0MDAK
KysrIGxpbnV4LTIuNi4yMS1yYzctZ2l0NC5tb2QvaW5jbHVkZS9saW51eC9j
cnlwdG8uaAkyMDA3LTA1LTAzIDA3OjA5OjQ3LjAwMDAwMDAwMCAtMDQwMApA
QCAtNiw3ICs2LDcgQEAKICAqIENvcHlyaWdodCAoYykgMjAwNSBIZXJiZXJ0
IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+CiAgKgogICogUG9y
dGlvbnMgZGVyaXZlZCBmcm9tIENyeXB0b2FwaSwgYnkgQWxleGFuZGVyIEtq
ZWxkYWFzIDxhc3RvckBmYXN0Lm5vPgotICogYW5kIE5ldHRsZSwgYnkgTmll
bHMgTfZsbGVyLgorICogYW5kIE5ldHRsZSwgYnkgTmllbHMgTcO2bGxlci4K
ICAqIAogICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBj
YW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkgaXQKICAqIHVuZGVy
IHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2Ug
YXMgcHVibGlzaGVkIGJ5IHRoZSBGcmVlCg==

--1875672472-1995079615-1178191047=:17390--

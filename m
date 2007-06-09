From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for
 i486+
Date: Sat, 9 Jun 2007 09:32:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706090931330.4353@fbirervta.pbzchgretzou.qr>
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1635784504-1181374363=:4353"
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756776AbXFIHdR@vger.kernel.org>
In-Reply-To: <20070608214253.23949.40465.stgit@dev>
Content-ID: <Pine.LNX.4.64.0706090932480.4353@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1635784504-1181374363=:4353
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0706090932481.4353@fbirervta.pbzchgretzou.qr>


On Jun 8 2007 17:42, Benjamin Gilbert wrote:

>@@ -0,0 +1,299 @@
>+/*
>+ * x86-optimized SHA1 hash algorithm (i486 and above)
>+ *
>+ * Originally from Nettle
>+ * Ported from M4 to cpp by Benjamin Gilbert <bgilbert@cs.cmu.edu>
>+ *
>+ * Copyright (C) 2004, Niels M?ller
>+ * Copyright (C) 2006-2007 Carnegie Mellon University

UTF-8 please. Hint: it should most likely be an ö.


	Jan
-- 
---699020219-1635784504-1181374363=:4353--

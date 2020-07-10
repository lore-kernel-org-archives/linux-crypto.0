Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8ACC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 10:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB802077D
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 10:16:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="ksLHS3Er"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGJKQ1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:16:27 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:32190 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJKQ0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 06:16:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594376185;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=cLP9AT05SbkJblktlIZ9pPumNY/vu7KudOIRJfuLm8Y=;
        b=ksLHS3EriIEaWWI3tB+ceePet6qg0EGeR6MJg+jrbplzF1oRuApiKSXNpzuyUFoQKg
        1YCH3z7Pbj+LsSTk6KhGI8JKROkUMJuyddpU4yT1QmP+nWuHE1T4mFvUEXWLNlPQksUA
        zkBerd6sXFjzHZjcuNhjG3239odrev56V77M9m3wkIXM4YNG4/5l6T396tCGAvxj+Ftu
        VNYnsZAenBUJa3KbD1dK4omBOyHYf8oibU0oE1RUAHqqoeTVkh+wc96rOMSBykxbsJF3
        RrEmGMpryaFQ7N24pOVSfNQ9HG5ZLV4yjur+GSPTX4HbCsXcWNOXkI5HLi6aXG7Ttg0L
        88mw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6AAGEZsh
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 10 Jul 2020 12:16:14 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH 2/3] lib/mpi: Add mpi_sub_ui()
Date:   Fri, 10 Jul 2020 12:10:40 +0200
Message-ID: <4577235.31r3eYUQgx@positron.chronox.de>
In-Reply-To: <2543601.mvXUDI8C0e@positron.chronox.de>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add mpi_sub_ui() based on Gnu PG mpz_sub_ui() from mpz/aors_ui.h
adapting the code to the kernel's structures and coding style and also
removing the defines used to produce mpz_sub_ui() and mpz_add_ui()
from the same code.

Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/mpi.h  |  3 +++
 lib/mpi/Makefile     |  1 +
 lib/mpi/mpi-sub-ui.c | 60 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)
 create mode 100644 lib/mpi/mpi-sub-ui.c

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 7bd6d8af0004..5d906dfbf3ed 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -63,6 +63,9 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod);
 int mpi_cmp_ui(MPI u, ulong v);
 int mpi_cmp(MPI u, MPI v);
 
+/*-- mpi-sub-ui.c --*/
+int mpi_sub_ui(MPI w, MPI u, unsigned long vval);
+
 /*-- mpi-bit.c --*/
 void mpi_normalize(MPI a);
 unsigned mpi_get_nbits(MPI a);
diff --git a/lib/mpi/Makefile b/lib/mpi/Makefile
index d5874a7f5ff9..43b8fce14079 100644
--- a/lib/mpi/Makefile
+++ b/lib/mpi/Makefile
@@ -16,6 +16,7 @@ mpi-y = \
 	mpicoder.o			\
 	mpi-bit.o			\
 	mpi-cmp.o			\
+	mpi-sub-ui.o			\
 	mpih-cmp.o			\
 	mpih-div.o			\
 	mpih-mul.o			\
diff --git a/lib/mpi/mpi-sub-ui.c b/lib/mpi/mpi-sub-ui.c
new file mode 100644
index 000000000000..fa6b085bac36
--- /dev/null
+++ b/lib/mpi/mpi-sub-ui.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* mpi-sub-ui.c  -  MPI functions
+ *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2015
+ *      Free Software Foundation, Inc.
+ *
+ * This file is part of GnuPG.
+ *
+ * Note: This code is heavily based on the GNU MP Library.
+ *	 Actually it's the same code with only minor changes in the
+ *	 way the data is stored; this is to support the abstraction
+ *	 of an optional secure memory allocation which may be used
+ *	 to avoid revealing of sensitive data due to paging etc.
+ *	 The GNU MP Library itself is published under the LGPL;
+ *	 however I decided to publish this code under the plain GPL.
+ */
+
+#include "mpi-internal.h"
+
+int mpi_sub_ui(MPI w, MPI u, unsigned long vval)
+{
+	if (u->nlimbs == 0) {
+		if (mpi_resize(w, 1) < 0)
+			return -ENOMEM;
+		w->d[0] = vval;
+		w->nlimbs = (vval != 0);
+		w->sign = (vval != 0);
+		return 0;
+	}
+
+	/* If not space for W (and possible carry), increase space. */
+	if (mpi_resize(w, u->nlimbs + 1))
+		return -ENOMEM;
+
+	if (u->sign) {
+		mpi_limb_t cy;
+
+		cy = mpihelp_add_1(w->d, u->d, u->nlimbs, (mpi_limb_t) vval);
+		w->d[u->nlimbs] = cy;
+		w->nlimbs = u->nlimbs + cy;
+		w->sign = 1;
+	} else {
+		/* The signs are different.  Need exact comparison to determine
+		 * which operand to subtract from which.
+		 */
+		if (u->nlimbs == 1 && u->d[0] < vval) {
+			w->d[0] = vval - u->d[0];
+			w->nlimbs = 1;
+			w->sign = 1;
+		} else {
+			mpihelp_sub_1(w->d, u->d, u->nlimbs, (mpi_limb_t) vval);
+			/* Size can decrease with at most one limb. */
+			w->nlimbs = (u->nlimbs - (w->d[u->nlimbs - 1] == 0));
+			w->sign = 0;
+		}
+	}
+
+	mpi_normalize(w);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_sub_ui);
-- 
2.26.2





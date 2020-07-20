Return-Path: <SRS0=2iMm=A7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25332C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 17:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3FCA2176B
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 17:12:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Bw5gCP/q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgGTRMh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jul 2020 13:12:37 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.168]:24475 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729621AbgGTRMh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jul 2020 13:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1595265154;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=wdmligHdkLrEqkLoRjSHZWa576Vg87I0/kFtCnfKltw=;
        b=Bw5gCP/q7Pd6LORZPAkKrr+VeGF4ktuqx1GASAowJjVhQczzcRXEPDwrTPBgPBlXLc
        T9djIPFiM2h1jKqrzvBx5InsgAD0y0M6P4iUlWMkWuuvOwKDKvxjprrDYmY8fU7oWMNF
        FQDB4sut2BYh0oTAmZV0TuTiZ7+7jxutBVIIJGpOF1WoVFz7jcfNDQOep6YqJYLz1Y6g
        DBMHTTrVsxSzfpCK7tZkcdl1tk4546JmHemuz2/OcfPc0tqmMHtAFumFuQsdeO9RDq3G
        sMd1it5VtN6g1nsh3sDJbNM2lBCdyufbN2u/Mzz4KzYnU53cxpXVmD0SLag1PN6DC05/
        j5pg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJPScHiDh"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6KH9tULM
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 20 Jul 2020 19:09:55 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: [PATCH v3 2/5] lib/mpi: Add mpi_sub_ui()
Date:   Mon, 20 Jul 2020 19:08:09 +0200
Message-ID: <12569375.uLZWGnKmhe@positron.chronox.de>
In-Reply-To: <2544426.mvXUDI8C0e@positron.chronox.de>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de> <2544426.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

Add mpi_sub_ui() based on Gnu MP mpz_sub_ui() function from file
mpz/aors_ui.h[1] from change id 510b83519d1c adapting the code to the
kernel's data structures, helper functions and coding style and also
removing the defines used to produce mpz_sub_ui() and mpz_add_ui()
from the same code.

[1] https://gmplib.org/repo/gmp-6.2/file/510b83519d1c/mpz/aors.h

Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/mpi.h  |  3 ++
 lib/mpi/Makefile     |  1 +
 lib/mpi/mpi-sub-ui.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)
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
index 000000000000..b41b082b5f3e
--- /dev/null
+++ b/lib/mpi/mpi-sub-ui.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* mpi-sub-ui.c - Subtract an unsigned integer from an MPI.
+ *
+ * Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2015
+ * Free Software Foundation, Inc.
+ *
+ * This file was based on the GNU MP Library source file:
+ * https://gmplib.org/repo/gmp-6.2/file/510b83519d1c/mpz/aors_ui.h
+ *
+ * The GNU MP Library is free software; you can redistribute it and/or modify
+ * it under the terms of either:
+ *
+ *   * the GNU Lesser General Public License as published by the Free
+ *     Software Foundation; either version 3 of the License, or (at your
+ *     option) any later version.
+ *
+ * or
+ *
+ *   * the GNU General Public License as published by the Free Software
+ *     Foundation; either version 2 of the License, or (at your option) any
+ *     later version.
+ *
+ * or both in parallel, as here.
+ *
+ * The GNU MP Library is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received copies of the GNU General Public License and the
+ * GNU Lesser General Public License along with the GNU MP Library.  If not,
+ * see https://www.gnu.org/licenses/.
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





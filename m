From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [PATCH 2/2] mpilib: use DIV_ROUND_UP and remove unused macros
Date: Wed, 30 Jan 2013 11:30:06 +0200
Message-ID: <ecbfc41bbf0a3d78e5522f1a37d090803d8f383f.1359538137.git.dmitry.kasatkin@intel.com>
References: <cover.1359538137.git.dmitry.kasatkin@intel.com>
Cc: jmorris@namei.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:31472 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754293Ab3A3Jh3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Jan 2013 04:37:29 -0500
Received: by mail-wg0-f72.google.com with SMTP id fg15so1556783wgb.3
        for <linux-crypto@vger.kernel.org>; Wed, 30 Jan 2013 01:37:24 -0800 (PST)
In-Reply-To: <cover.1359538137.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1359538137.git.dmitry.kasatkin@intel.com>
References: <cover.1359538137.git.dmitry.kasatkin@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Remove MIN, MAX and ABS macros that are duplicates kernel's native
implementation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/mpi/mpi-internal.h |    4 ----
 lib/mpi/mpicoder.c     |    8 ++++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/lib/mpi/mpi-internal.h b/lib/mpi/mpi-internal.h
index 77adcf6..60cf765 100644
--- a/lib/mpi/mpi-internal.h
+++ b/lib/mpi/mpi-internal.h
@@ -65,10 +65,6 @@
 typedef mpi_limb_t *mpi_ptr_t;	/* pointer to a limb */
 typedef int mpi_size_t;		/* (must be a signed type) */
 
-#define ABS(x) (x >= 0 ? x : -x)
-#define MIN(l, o) ((l) < (o) ? (l) : (o))
-#define MAX(h, i) ((h) > (i) ? (h) : (i))
-
 static inline int RESIZE_IF_NEEDED(MPI a, unsigned b)
 {
 	if (a->alloced < b)
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 3962b7f..5f9c44c 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -52,7 +52,7 @@ MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes)
 	else
 		nbits = 0;
 
-	nlimbs = (nbytes + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB;
+	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
 	if (!val)
 		return NULL;
@@ -96,8 +96,8 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 	buffer += 2;
 	nread = 2;
 
-	nbytes = (nbits + 7) / 8;
-	nlimbs = (nbytes + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB;
+	nbytes = DIV_ROUND_UP(nbits, 8);
+	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
 	if (!val)
 		return NULL;
@@ -193,7 +193,7 @@ int mpi_set_buffer(MPI a, const void *xbuffer, unsigned nbytes, int sign)
 	int nlimbs;
 	int i;
 
-	nlimbs = (nbytes + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB;
+	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	if (RESIZE_IF_NEEDED(a, nlimbs) < 0)
 		return -ENOMEM;
 	a->sign = sign;
-- 
1.7.10.4

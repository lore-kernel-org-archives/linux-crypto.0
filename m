From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/14] MPILIB: Export some more symbols
Date: Mon, 28 Nov 2011 15:44:36 +0000
Message-ID: <20111128154436.6009.77586.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, mitry.kasatkin@intel.com,
	zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
	alan.cox@intel.com, David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Export some more symbols for use by the DSA key subtype.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 lib/mpi/mpi-cmp.c  |    2 ++
 lib/mpi/mpi-div.c  |    1 +
 lib/mpi/mpi-inv.c  |    1 +
 lib/mpi/mpi-mpow.c |    1 +
 lib/mpi/mpi-mul.c  |    1 +
 5 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
index 914bc42..1871e7b 100644
--- a/lib/mpi/mpi-cmp.c
+++ b/lib/mpi/mpi-cmp.c
@@ -39,6 +39,7 @@ int mpi_cmp_ui(MPI u, unsigned long v)
 	else
 		return -1;
 }
+EXPORT_SYMBOL_GPL(mpi_cmp_ui);
 
 int mpi_cmp(MPI u, MPI v)
 {
@@ -66,3 +67,4 @@ int mpi_cmp(MPI u, MPI v)
 		return 1;
 	return -1;
 }
+EXPORT_SYMBOL_GPL(mpi_cmp);
diff --git a/lib/mpi/mpi-div.c b/lib/mpi/mpi-div.c
index c3087d1..3da9402 100644
--- a/lib/mpi/mpi-div.c
+++ b/lib/mpi/mpi-div.c
@@ -59,6 +59,7 @@ nomem:
 		mpi_free(temp_divisor);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(mpi_fdiv_r);
 
 /****************
  * Division rounding the quotient towards -infinity.
diff --git a/lib/mpi/mpi-inv.c b/lib/mpi/mpi-inv.c
index 0951f98..bfc5ca1 100644
--- a/lib/mpi/mpi-inv.c
+++ b/lib/mpi/mpi-inv.c
@@ -185,3 +185,4 @@ cleanup:
 	mpi_free(v);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(mpi_invm);
diff --git a/lib/mpi/mpi-mpow.c b/lib/mpi/mpi-mpow.c
index 4cc7593..5752194 100644
--- a/lib/mpi/mpi-mpow.c
+++ b/lib/mpi/mpi-mpow.c
@@ -131,3 +131,4 @@ nomem:
 	kfree(G);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(mpi_mulpowm);
diff --git a/lib/mpi/mpi-mul.c b/lib/mpi/mpi-mul.c
index 1f3219e..3d514b9 100644
--- a/lib/mpi/mpi-mul.c
+++ b/lib/mpi/mpi-mul.c
@@ -192,3 +192,4 @@ int mpi_mulm(MPI w, MPI u, MPI v, MPI m)
 		return -ENOMEM;
 	return mpi_fdiv_r(w, w, m);
 }
+EXPORT_SYMBOL_GPL(mpi_mulm);

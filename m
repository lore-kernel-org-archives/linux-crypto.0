From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6/6] padata: update documentation
Date: Wed, 7 Jul 2010 15:34:03 +0200
Message-ID: <20100707133403.GB10072@secunet.com>
References: <20100707132915.GV10072@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Kruchinin <dkruchinin@acm.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100707132915.GV10072@secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch updates the padata documentation to the changed
API of padata_start/padata_stop and padata_do parallel.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 Documentation/padata.txt |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index 269d7d0..3d77d09 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -22,12 +22,15 @@ actually be done; it should be a multithreaded queue, naturally.
 
 There are functions for enabling and disabling the instance:
 
-    void padata_start(struct padata_instance *pinst);
+    int padata_start(struct padata_instance *pinst);
     void padata_stop(struct padata_instance *pinst);
 
-These functions literally do nothing beyond setting or clearing the
-"padata_start() was called" flag; if that flag is not set, other functions
-will refuse to work.
+These functions are setting or clearing the "PADATA_INIT" flag;
+if that flag is not set, other functions will refuse to work.
+padata_start returns zero on success (flag set) or -EINVAL if the
+padata cpumask contains no active cpu (flag not set).
+padata_stop clears the flag and blocks until the padata instance
+is unused. 
 
 The list of CPUs to be used can be adjusted with these functions:
 
@@ -63,12 +66,10 @@ The submission of work is done with:
 The pinst and padata structures must be set up as described above; cb_cpu
 specifies which CPU will be used for the final callback when the work is
 done; it must be in the current instance's CPU mask.  The return value from
-padata_do_parallel() is a little strange; zero is an error return
-indicating that the caller forgot the padata_start() formalities.  -EBUSY
-means that somebody, somewhere else is messing with the instance's CPU
-mask, while -EINVAL is a complaint about cb_cpu not being in that CPU mask.
-If all goes well, this function will return -EINPROGRESS, indicating that
-the work is in progress.
+padata_do_parallel() is zero on success, indicating that the work is in
+progress. -EBUSY means that somebody, somewhere else is messing with the
+instance's CPU mask, while -EINVAL is a complaint about cb_cpu not being
+in that CPU mask or about a not running instance.
 
 Each task submitted to padata_do_parallel() will, in turn, be passed to
 exactly one call to the above-mentioned parallel() function, on one CPU, so
-- 
1.5.6.5

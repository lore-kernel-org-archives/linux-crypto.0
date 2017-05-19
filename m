From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 26/30] padata.txt: standardize document format
Date: Thu, 18 May 2017 22:24:18 -0300
Message-ID: <05bdf237b3844db429523659bd7965f1abeca660.1495156975.git.mchehab@s-opensource.com>
References: <cover.1495156975.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        linux-mtd@lists.infradead.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1495156975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1495156975.git.mchehab@s-opensource.com>
References: <cover.1495156975.git.mchehab@s-opensource.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Each text file under Documentation follows a different
format. Some doesn't even have titles!

Change its representation to follow the adopted standard,
using ReST markups for it to be parseable by Sphinx:

- mark document title;
- mark literal blocks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/padata.txt | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index 7ddfe216a0aa..b103d0c82000 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -1,5 +1,8 @@
+=======================================
 The padata parallel execution mechanism
-Last updated for 2.6.36
+=======================================
+
+:Last updated: for 2.6.36
 
 Padata is a mechanism by which the kernel can farm work out to be done in
 parallel on multiple CPUs while retaining the ordering of tasks.  It was
@@ -9,7 +12,7 @@ those packets.  The crypto developers made a point of writing padata in a
 sufficiently general fashion that it could be put to other uses as well.
 
 The first step in using padata is to set up a padata_instance structure for
-overall control of how tasks are to be run:
+overall control of how tasks are to be run::
 
     #include <linux/padata.h>
 
@@ -24,7 +27,7 @@ The workqueue wq is where the work will actually be done; it should be
 a multithreaded queue, naturally.
 
 To allocate a padata instance with the cpu_possible_mask for both
-cpumasks this helper function can be used:
+cpumasks this helper function can be used::
 
     struct padata_instance *padata_alloc_possible(struct workqueue_struct *wq);
 
@@ -36,7 +39,7 @@ it is legal to supply a cpumask to padata that contains offline CPUs.
 Once an offline CPU in the user supplied cpumask comes online, padata
 is going to use it.
 
-There are functions for enabling and disabling the instance:
+There are functions for enabling and disabling the instance::
 
     int padata_start(struct padata_instance *pinst);
     void padata_stop(struct padata_instance *pinst);
@@ -48,7 +51,7 @@ padata cpumask contains no active CPU (flag not set).
 padata_stop clears the flag and blocks until the padata instance
 is unused.
 
-The list of CPUs to be used can be adjusted with these functions:
+The list of CPUs to be used can be adjusted with these functions::
 
     int padata_set_cpumasks(struct padata_instance *pinst,
 			    cpumask_var_t pcpumask,
@@ -71,12 +74,12 @@ padata_add_cpu/padata_remove_cpu are used. cpu specifies the CPU to add or
 remove and mask is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL.
 
 If a user is interested in padata cpumask changes, he can register to
-the padata cpumask change notifier:
+the padata cpumask change notifier::
 
     int padata_register_cpumask_notifier(struct padata_instance *pinst,
 					 struct notifier_block *nblock);
 
-To unregister from that notifier:
+To unregister from that notifier::
 
     int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
 					   struct notifier_block *nblock);
@@ -84,7 +87,7 @@ To unregister from that notifier:
 The padata cpumask change notifier notifies about changes of the usable
 cpumasks, i.e. the subset of active CPUs in the user supplied cpumask.
 
-Padata calls the notifier chain with:
+Padata calls the notifier chain with::
 
     blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
 				 notification_mask,
@@ -95,7 +98,7 @@ is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL and cpumask is a pointer
 to a struct padata_cpumask that contains the new cpumask information.
 
 Actually submitting work to the padata instance requires the creation of a
-padata_priv structure:
+padata_priv structure::
 
     struct padata_priv {
         /* Other stuff here... */
@@ -110,7 +113,7 @@ parallel() and serial() functions should be provided.  Those functions will
 be called in the process of getting the work done as we will see
 momentarily.
 
-The submission of work is done with:
+The submission of work is done with::
 
     int padata_do_parallel(struct padata_instance *pinst,
 		           struct padata_priv *padata, int cb_cpu);
@@ -138,7 +141,7 @@ need not be completed during this call, but, if parallel() leaves work
 outstanding, it should be prepared to be called again with a new job before
 the previous one completes.  When a task does complete, parallel() (or
 whatever function actually finishes the job) should inform padata of the
-fact with a call to:
+fact with a call to::
 
     void padata_do_serial(struct padata_priv *padata);
 
@@ -151,7 +154,7 @@ pains to ensure that tasks are completed in the order in which they were
 submitted.
 
 The one remaining function in the padata API should be called to clean up
-when a padata instance is no longer needed:
+when a padata instance is no longer needed::
 
     void padata_free(struct padata_instance *pinst);
 
-- 
2.9.4

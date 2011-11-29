From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/16] MPILIB: Add a missing ENOMEM check [ver #2]
Date: Tue, 29 Nov 2011 23:43:23 +0000
Message-ID: <20111129234323.13625.34554.stgit@warthog.procyon.org.uk>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
	zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
	alan.cox@intel.com, David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063Ab1K3A17 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Nov 2011 19:27:59 -0500
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a missing ENOMEM check.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 lib/mpi/mpicoder.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index fe84bb9..6e225a8 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -255,6 +255,8 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
 	if (!n)
 		n++;		/* avoid zero length allocation */
 	p = buffer = kmalloc(n, GFP_KERNEL);
+	if (p < 0)
+		return NULL;
 
 	for (i = a->nlimbs - 1; i >= 0; i--) {
 		alimb = a->d[i];

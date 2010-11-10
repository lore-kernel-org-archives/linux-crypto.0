From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Linux 2.6.37-rc1 (pcrypt fault)
Date: Wed, 10 Nov 2010 12:21:43 +0100
Message-ID: <20101110112143.GB1868@secunet.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
 <20101103141519.0a6f5906.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:40476 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab0KJLco (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Nov 2010 06:32:44 -0500
Content-Disposition: inline
In-Reply-To: <20101103141519.0a6f5906.randy.dunlap@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 03, 2010 at 02:15:19PM -0700, Randy Dunlap wrote:
> 
> modprobe pcrypt; rmmod pcrypt ==>
> 
> 
> [   76.081639] calling  pcrypt_init+0x0/0x107 [pcrypt] @ 3016
> Nov  3 13:02:15 control kernel: [   76.089883] initcall pcrypt_init+0x0/0x107 [pcrypt] returned 0 after 2476 usecs
> [   76.081639] calling  pcrypt_i
> 
> 
> [   79.940445] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC

Looks like a use after free of the padata instance.
Does the patch below fix it?

Thanks for reporting,

Steffen


Subject: [PATCH] crypto: pcrypt - Fix use after free on padata_free

kobject_put is called from padata_free for the padata kobject.
The kobject's release function frees the padata instance,
so don't call kobject_put for the padata kobject from pcrypt.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index de30782..75586f1 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -504,7 +504,6 @@ err:
 
 static void pcrypt_fini_padata(struct padata_pcrypt *pcrypt)
 {
-	kobject_put(&pcrypt->pinst->kobj);
 	free_cpumask_var(pcrypt->cb_cpumask->mask);
 	kfree(pcrypt->cb_cpumask);
 
-- 
1.7.0.4

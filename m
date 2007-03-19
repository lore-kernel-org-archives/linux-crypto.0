From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: [PATCH] crypto: scatterwalk_copychunks() fails to advance through
	scatterlist
Date: Mon, 19 Mar 2007 19:55:08 -0400
Message-ID: <20070319235508.GH29272@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: nfsv4@linux-nfs.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <nfsv4-bounces@linux-nfs.org>
Content-Disposition: inline
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-crypto.vger.kernel.org

In the loop in scatterwalk_copychunks(), if walk->offset is zero,
then scatterwalk_pagedone rounds that up to the nearest page boundary:

		walk->offset += PAGE_SIZE - 1;
		walk->offset &= PAGE_MASK;

which is a no-op in this case, so we don't advance to the next element
of the scatterlist array:

		if (walk->offset >= walk->sg->offset + walk->sg->length)
			scatterwalk_start(walk, sg_next(walk->sg));

and we end up copying the same data twice.

It appears that other callers of scatterwalk_{page}done first advance
walk->offset, so I believe that's the correct thing to do here.

This caused a bug in NFS when run with krb5p security, which would
cause some writes to fail with permissions errors--for example, writes
of less than 8 bytes (the des blocksize) at the start of a file.

A git-bisect shows the bug was originally introduced by
5c64097aa0f6dc4f27718ef47ca9a12538d62860, first in 2.6.19-rc1.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 crypto/scatterwalk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 35172d3..a664231 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -91,6 +91,8 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 		memcpy_dir(buf, vaddr, len_this_page, out);
 		scatterwalk_unmap(vaddr, out);
 
+		scatterwalk_advance(walk, nbytes);
+
 		if (nbytes == len_this_page)
 			break;
 
@@ -99,7 +101,5 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 
 		scatterwalk_pagedone(walk, out, 1);
 	}
-
-	scatterwalk_advance(walk, nbytes);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_copychunks);
-- 
1.5.0.3.31.ge47c

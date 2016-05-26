From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH 4/5] lib/mpi: mpi_read_from_buffer(): sanitize short buffer printk
Date: Thu, 26 May 2016 23:19:54 +0200
Message-ID: <1464297595-24032-5-git-send-email-nicstange@gmail.com>
References: <1464297595-24032-1-git-send-email-nicstange@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464297595-24032-1-git-send-email-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The first two bytes of the input buffer encode its expected length and
mpi_read_from_buffer() prints a console message if the given buffer is too
short.

However, there are some oddities with how this message is printed:
- It is printed at the default loglevel. This is different from the
  one used in the case that the first two bytes' value is unsupportedly
  large, i.e. KERN_INFO.
- The format specifier '%d' is used for unsigned ints.
- It prints the values of nread and *ret_nread. This is redundant since
  the former is always the latter + 1.

Clean this up as follows:
- Use pr_info() rather than printk() with no loglevel.
- Use the format specifiers '%u' in place if '%d'.
- Do not print the redundant 'nread' but the more helpful 'nbytes' value.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 lib/mpi/mpicoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 869c66c..2f4d039 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -99,8 +99,8 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 
 	nbytes = DIV_ROUND_UP(nbits, 8);
 	if (nbytes + 2 > *ret_nread) {
-		printk("MPI: mpi larger than buffer nread=%d ret_nread=%d\n",
-				*ret_nread + 1, *ret_nread);
+		pr_info("MPI: mpi larger than buffer nbytes=%u ret_nread=%u\n",
+				nbytes, *ret_nread);
 		return ERR_PTR(-EINVAL);
 	}
 
-- 
2.8.2

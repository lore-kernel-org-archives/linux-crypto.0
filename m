From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v2] crypto: don't raise alarm for no ctr(aes) tests
Date: Thu, 30 Apr 2009 17:13:25 -0400
Message-ID: <200904301713.26586.jarod@redhat.com>
References: <200904282118.22823.jarod@redhat.com> <20090429105035.GC7227@hmsreliant.think-freely.org> <200904290846.48267.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45279 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZD3VON (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Apr 2009 17:14:13 -0400
In-Reply-To: <200904290846.48267.jarod@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 29 April 2009 08:46:47 Jarod Wilson wrote:
> On Wednesday 29 April 2009 06:50:35 Neil Horman wrote:
> > On Tue, Apr 28, 2009 at 09:18:22PM -0400, Jarod Wilson wrote:
> > > Per the NIST AESAVS document, Appendix A[1], it isn't possible to
> > > have automated self-tests for counter-mode AES, but people are
> > > misled to believe something is wrong by the message that says there
> > > is no test for ctr(aes). Simply suppress all 'no test for ctr(aes*'
> > > messages if fips_enabled is set to avoid confusion.
> > > 
> > > Dependent on earlier patch 'crypto: catch base cipher self-test
> > > failures in fips mode', which adds the test_done label.
> > > 
> > > [1] http://csrc.nist.gov/groups/STM/cavp/documents/aes/AESAVS.pdf
[...]
> > From the way I read the document, anything operating in a counter mode will have
> > an unpredictable output (given the counter operation isn't specified).  While
> > the above works, I'm not sure that it fully covers the various ccm modes
> > available (ccm_base and rfc4309).
> 
> I believe Appendix A only applies for straight up counter-mode aes,
> ccm_base and rfc4309 actually have well-defined counter operations.
> We've already got self-tests for ccm(aes) and a pending patch for
> rfc4309(ccm(aes), and since they don't start w/'ctr(aes', they
> wouldn't be caught by that (admittedly hacky) check even if we
> didn't have test vectors for them.
> 
> > Perhaps instead it would be better to add a
> > TFM mask flag indicating that the selected transform included a unpredictable
> > component or counter input (marking the alg as being unsuitable for automatic
> > testing without knoweldge of the inner workings of that counter.  Then you could
> > just test for that flag?
> 
> Yeah, I thought about a flag too, but it seemed potentially a lot of
> overhead for what might well be restricted to ctr(aes*). It might've
> been relevant for ctr(des3_ede) or ctr(des), but they're not on the
> fips approved algo/mode list, so I took the easy way out. I'm game to
> go the flag route if need be though.

Neil and I talked a bit more off-list about the best approach to take, and
after a bit of trial and error, we came up with the idea to simply add an
'untestable' flag to the alg_test_desc struct, a corresponding entry for
ctr(aes) in alg_test_descs, and a hook to check for untestable algs in
alg_find_test().

Works well enough in local testing, eliminates the use of strncmp, and
results in far more granular control over marking which algs are
explicitly untestable and shouldn't have warnings printed for. At the
moment, I've gone for suppressing the warnings regardless of whether
we're in fips mode or not, but adding a different warning (er, info)
message in the untestable case works too, if that's preferred. The
errnos used seem appropriate, but I might have missed more appropriate
ones somewhere.

nb: this patch applies atop my earlier '[PATCH v2] crypto: catch base
cipher self-test failures in fips mode'.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f39c148..b78278c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -94,6 +94,7 @@ struct alg_test_desc {
 	const char *alg;
 	int (*test)(const struct alg_test_desc *desc, const char *driver,
 		    u32 type, u32 mask);
+	int untestable;
 
 	union {
 		struct aead_test_suite aead;
@@ -1518,6 +1519,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		/*
+		 * Automated ctr(aes) tests aren't possible per Appendix A of
+		 * http://csrc.nist.gov/groups/STM/cavp/documents/aes/AESAVS.pdf
+		 */
+		.alg = "ctr(aes)",
+		.untestable = 1,
+	}, {
 		.alg = "cts(cbc(aes))",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -2198,10 +2206,13 @@ static int alg_find_test(const char *alg)
 			continue;
 		}
 
+		if (alg_test_descs[i].untestable)
+			return -ENODATA;
+
 		return i;
 	}
 
-	return -1;
+	return -ENOSYS;
 }
 
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
@@ -2237,7 +2248,13 @@ test_done:
 	return rc;
 
 notest:
-	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
+	switch (i) {
+	case -ENODATA:
+		break;
+	case -ENOSYS:
+	default:
+		printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(alg_test);


-- 
Jarod Wilson
jarod@redhat.com

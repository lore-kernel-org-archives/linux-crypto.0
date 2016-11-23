From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH] mpi: Fix NULL ptr dereference in mpi_powm()
Date: Wed, 23 Nov 2016 19:28:04 +0300
Message-ID: <1479918484-31952-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S . Miller" <davem@davemloft.net>,
        Nicolai Stange <nicstange@gmail.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        <stable@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Parsing certain certificates (see [1]) triggers NULL-ptr
dereference in mpi_powm():

	BUG: unable to handle kernel NULL pointer dereference at (null)
	IP: [<ffffffff818eb118>] mpi_powm+0xf8/0x10b0
	...
	Call Trace:
	 [<ffffffff817e06a6>] _rsa_dec.isra.2+0x66/0x80
	 [<ffffffff817e07c3>] rsa_verify+0x103/0x1c0
	 [<ffffffff817e1683>] pkcs1pad_verify+0x1c3/0x220
	 [<ffffffff8184549a>] public_key_verify_signature+0x3fa/0x4d0
	 [<ffffffff818473c7>] x509_check_for_self_signed+0x167/0x1e0
	 [<ffffffff8184607e>] x509_cert_parse+0x27e/0x300
	 [<ffffffff81846cae>] x509_key_preparse+0x3e/0x330
	 [<ffffffff818444cf>] asymmetric_key_preparse+0x6f/0x100
	 [<ffffffff8178bec0>] key_create_or_update+0x260/0x5f0
	 [<ffffffff8178e6d9>] SyS_add_key+0x199/0x2a0
	 [<ffffffff821d823b>] entry_SYSCALL_64_fastpath+0x1e/0xad

This happens because mpi_alloc(0) doesn't allocate the limb space.
Fix this by allocating the result if needed.

Basically, this is a backport of libgcrypt patch [2].

[1] http://seclists.org/fulldisclosure/2016/Nov/76
[2] http://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=patch;h=6e1adb05d290aeeb1c230c763970695f4a538526

Fixes: cdec9cb5167a ("crypto: GnuPG based MPI lib - source files (part 1)")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: <stable@vger.kernel.org>
---
 lib/mpi/mpi-pow.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/mpi/mpi-pow.c b/lib/mpi/mpi-pow.c
index 5464c87..9e28d12 100644
--- a/lib/mpi/mpi-pow.c
+++ b/lib/mpi/mpi-pow.c
@@ -64,8 +64,13 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 	if (!esize) {
 		/* Exponent is zero, result is 1 mod MOD, i.e., 1 or 0
 		 * depending on if MOD equals 1.  */
-		rp[0] = 1;
 		res->nlimbs = (msize == 1 && mod->d[0] == 1) ? 0 : 1;
+		if (res->nlimbs) {
+			if (RESIZE_IF_NEEDED(res, 1) < 0)
+				goto enomem;
+			rp = res->d;
+			rp[0] = 1;
+		}
 		res->sign = 0;
 		goto leave;
 	}
-- 
2.7.3

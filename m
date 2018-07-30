From: Colin King <colin.king@canonical.com>
Subject: [PATCH][RESEND] lib/mpi: remove redundant variable esign
Date: Mon, 30 Jul 2018 09:59:36 +0100
Message-ID: <20180730085936.10050-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable esign is being assigned but is never used hence it is
redundant and can be removed.

Cleans up clang warning:
warning: variable 'esign' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 lib/mpi/mpi-pow.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/mpi/mpi-pow.c b/lib/mpi/mpi-pow.c
index 468fb7cd1221..a5c921e6d667 100644
--- a/lib/mpi/mpi-pow.c
+++ b/lib/mpi/mpi-pow.c
@@ -41,7 +41,7 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 	mpi_ptr_t tspace = NULL;
 	mpi_ptr_t rp, ep, mp, bp;
 	mpi_size_t esize, msize, bsize, rsize;
-	int esign, msign, bsign, rsign;
+	int msign, bsign, rsign;
 	mpi_size_t size;
 	int mod_shift_cnt;
 	int negative_result;
@@ -53,7 +53,6 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 	esize = exp->nlimbs;
 	msize = mod->nlimbs;
 	size = 2 * msize;
-	esign = exp->sign;
 	msign = mod->sign;
 
 	rp = res->d;
-- 
2.17.1

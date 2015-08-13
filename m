From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/2] crypto: qat - Don't move data inside output buffer
Date: Wed, 12 Aug 2015 20:54:45 -0700
Message-ID: <20150813035445.25108.76927.stgit@tstruk-mobl1>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, tadeusz.struk@intel.com, steved@redhat.com,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150813035433.25108.3065.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Don't need to move data inside of the output buffer
because SW doen't need to do this anymore sice the new MPI
mpi_read_buf() has been added. Just set the correct output len.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index fe352a6..6ddb13c 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -144,9 +144,6 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 		ptr++;
 	}
 
-	if (areq->dst_len != req->ctx->key_sz)
-		memcpy(areq->dst, ptr, areq->dst_len);
-
 	akcipher_request_complete(areq, err);
 }
 

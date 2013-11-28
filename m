From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 2/4] crypto: caam - fix aead sglen for case 'dst != src'
Date: Thu, 28 Nov 2013 15:11:16 +0200
Message-ID: <1385644278-14928-2-git-send-email-horia.geanta@freescale.com>
References: <5282A387.1020200@iki.fi>
 <1385644278-14928-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:46593
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867Ab3K1NRq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 08:17:46 -0500
In-Reply-To: <1385644278-14928-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For aead case when source and destination buffers are different,
there is an incorrect assumption that the source length includes the ICV
length. Fix this, since it leads to an oops when using sg_count() to
find the number of nents in the scatterlist:

Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xf91f7634
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=8 P4080 DS
Modules linked in: caamalg(+) caam_jr caam
CPU: 1 PID: 1053 Comm: cryptomgr_test Not tainted 3.11.0 #16
task: eeb24ab0 ti: eeafa000 task.ti: eeafa000
NIP: f91f7634 LR: f91f7f24 CTR: f91f7ef0
REGS: eeafbbc0 TRAP: 0300   Not tainted  (3.11.0)
MSR: 00029002 <CE,EE,ME>  CR: 44044044  XER: 00000000
DEAR: 00000004, ESR: 00000000

GPR00: f91f7f24 eeafbc70 eeb24ab0 00000002 ee8e0900 ee8e0800 00000024 c45c4462
GPR08: 00000010 00000000 00000014 0c0e4000 24044044 00000000 00000000 c0691590
GPR16: eeab0000 eeb23000 00000000 00000000 00000000 00000001 00000001 eeafbcc8
GPR24: 000000d1 00000010 ee2d5000 ee49ea10 ee49ea10 ee46f640 ee46f640 c0691590
NIP [f91f7634] aead_edesc_alloc.constprop.14+0x144/0x780 [caamalg]
LR [f91f7f24] aead_encrypt+0x34/0x288 [caamalg]
Call Trace:
[eeafbc70] [a1004000] 0xa1004000 (unreliable)
[eeafbcc0] [f91f7f24] aead_encrypt+0x34/0x288 [caamalg]
[eeafbcf0] [c020d77c] __test_aead+0x3ec/0xe20
[eeafbe20] [c020f35c] test_aead+0x6c/0xe0
[eeafbe40] [c020f420] alg_test_aead+0x50/0xd0
[eeafbe60] [c020e5e4] alg_test+0x114/0x2e0
[eeafbee0] [c020bd1c] cryptomgr_test+0x4c/0x60
[eeafbef0] [c0047058] kthread+0xa8/0xb0
[eeafbf40] [c000eb0c] ret_from_kernel_thread+0x5c/0x64
Instruction dump:
69084321 7d080034 5508d97e 69080001 0f080000 81290024 552807fe 0f080000
3a600001 5529003a 2f8a0000 40dd0028 <80e90004> 3ab50001 8109000c 70e30002
---[ end trace b3c3e23925c7484e ]---

While here, add a tcrypt mode for making it easy to test authenc
(needed for triggering case above).

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 crypto/tcrypt.c               |    4 +++
 drivers/crypto/caam/caamalg.c |   51 +++++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 25a5934..cc887ae 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1242,6 +1242,10 @@ static int do_test(int m)
 		ret += tcrypt_test("cmac(des3_ede)");
 		break;
 
+	case 155:
+		ret += tcrypt_test("authenc(hmac(sha1),cbc(aes))");
+		break;
+
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 4f44b71..4cf5dec 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -818,7 +818,7 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		       ivsize, 1);
 	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->dst),
-		       req->cryptlen, 1);
+		       req->cryptlen - ctx->authsize, 1);
 #endif
 
 	if (err) {
@@ -972,12 +972,9 @@ static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
 				 (edesc->src_nents ? : 1);
 		in_options = LDST_SGF;
 	}
-	if (encrypt)
-		append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize +
-				  req->cryptlen - authsize, in_options);
-	else
-		append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize +
-				  req->cryptlen, in_options);
+
+	append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize + req->cryptlen,
+			  in_options);
 
 	if (likely(req->src == req->dst)) {
 		if (all_contig) {
@@ -998,7 +995,8 @@ static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
 		}
 	}
 	if (encrypt)
-		append_seq_out_ptr(desc, dst_dma, req->cryptlen, out_options);
+		append_seq_out_ptr(desc, dst_dma, req->cryptlen + authsize,
+				   out_options);
 	else
 		append_seq_out_ptr(desc, dst_dma, req->cryptlen - authsize,
 				   out_options);
@@ -1048,8 +1046,8 @@ static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
 		sec4_sg_index += edesc->assoc_nents + 1 + edesc->src_nents;
 		in_options = LDST_SGF;
 	}
-	append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize +
-			  req->cryptlen - authsize, in_options);
+	append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize + req->cryptlen,
+			  in_options);
 
 	if (contig & GIV_DST_CONTIG) {
 		dst_dma = edesc->iv_dma;
@@ -1066,7 +1064,8 @@ static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
 		}
 	}
 
-	append_seq_out_ptr(desc, dst_dma, ivsize + req->cryptlen, out_options);
+	append_seq_out_ptr(desc, dst_dma, ivsize + req->cryptlen + authsize,
+			   out_options);
 }
 
 /*
@@ -1130,7 +1129,8 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
  * allocate and map the aead extended descriptor
  */
 static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
-					   int desc_bytes, bool *all_contig_ptr)
+					   int desc_bytes, bool *all_contig_ptr,
+					   bool encrypt)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
@@ -1145,12 +1145,22 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	bool assoc_chained = false, src_chained = false, dst_chained = false;
 	int ivsize = crypto_aead_ivsize(aead);
 	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
+	unsigned int authsize = ctx->authsize;
 
 	assoc_nents = sg_count(req->assoc, req->assoclen, &assoc_chained);
-	src_nents = sg_count(req->src, req->cryptlen, &src_chained);
 
-	if (unlikely(req->dst != req->src))
-		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
+	if (unlikely(req->dst != req->src)) {
+		src_nents = sg_count(req->src, req->cryptlen, &src_chained);
+		dst_nents = sg_count(req->dst,
+				     req->cryptlen +
+					(encrypt ? authsize : (-authsize)),
+				     &dst_chained);
+	} else {
+		src_nents = sg_count(req->src,
+				     req->cryptlen +
+					(encrypt ? authsize : 0),
+				     &src_chained);
+	}
 
 	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
 				 DMA_TO_DEVICE, assoc_chained);
@@ -1234,11 +1244,9 @@ static int aead_encrypt(struct aead_request *req)
 	u32 *desc;
 	int ret = 0;
 
-	req->cryptlen += ctx->authsize;
-
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, DESC_JOB_IO_LEN *
-				 CAAM_CMD_SZ, &all_contig);
+				 CAAM_CMD_SZ, &all_contig, true);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1275,7 +1283,7 @@ static int aead_decrypt(struct aead_request *req)
 
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, DESC_JOB_IO_LEN *
-				 CAAM_CMD_SZ, &all_contig);
+				 CAAM_CMD_SZ, &all_contig, false);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1332,7 +1340,8 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 	src_nents = sg_count(req->src, req->cryptlen, &src_chained);
 
 	if (unlikely(req->dst != req->src))
-		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
+		dst_nents = sg_count(req->dst, req->cryptlen + ctx->authsize,
+				     &dst_chained);
 
 	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
 				 DMA_TO_DEVICE, assoc_chained);
@@ -1426,8 +1435,6 @@ static int aead_givencrypt(struct aead_givcrypt_request *areq)
 	u32 *desc;
 	int ret = 0;
 
-	req->cryptlen += ctx->authsize;
-
 	/* allocate extended descriptor */
 	edesc = aead_giv_edesc_alloc(areq, DESC_JOB_IO_LEN *
 				     CAAM_CMD_SZ, &contig);
-- 
1.7.7.6

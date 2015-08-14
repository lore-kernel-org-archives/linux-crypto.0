From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Don't move data inside output buffer
Date: Fri, 14 Aug 2015 07:21:29 -0700
Message-ID: <55CDF969.6070704@intel.com>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1> <20150813035445.25108.76927.stgit@tstruk-mobl1> <20150814051410.GA2370@gondor.apana.org.au> <55CD8733.2000904@intel.com> <20150814062636.GA2799@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62993 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbbHNOYk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2015 10:24:40 -0400
In-Reply-To: <20150814062636.GA2799@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 08/13/2015 11:26 PM, Herbert Xu wrote:
> On Thu, Aug 13, 2015 at 11:14:11PM -0700, Tadeusz Struk wrote:
>>
>> Right, but we don't need that anymore.
> 
> Why not? If you reduce the size without moving the buffer wouldn't
> it begin with a bunch of zeroes and wouldn't you lose the real bytes
> at the end?

Yes, that was wrong, sorry. The reason I wanted to change it is that
the SW implementation can return a number with leading zeros.
This is because mpi_read_buffer() returns the whole thing.

Because the format of the module signature starts with 0x00, 0x01
the two implementations return a different thing.
For instance SW returned a 512 bytes number starting with 0x00, 0x01
and HW returned 511 bytes number without the 0x00 at the beginning.
Technically both are correct, but then the rsa_signture_verify()
needs to check for both cases, which is not ideal.
To make it return the same thing as SW we can do something like this:

---8<---

Allow for leading zeros in output to make it exactly the same as the
SW implementation.
Change memcpy to memmove because the copy is done within the same buffer.

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index fe352a6..cc450fa 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -118,7 +118,13 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 	struct device *dev = &GET_DEV(req->ctx->inst->accel_dev);
 	int err = ICP_QAT_FW_PKE_RESP_PKE_STAT_GET(
 				resp->pke_resp_hdr.comn_resp_flags);
-	char *ptr = areq->dst;
+#if BYTES_PER_MPI_LIMB == 4
+	u32 *ptr = areq->dst;
+#elif BYTES_PER_MPI_LIMB == 8
+	u64 *ptr = areq->dst;
+#else
+#error please implement for this limb size.
+#endif
 
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
@@ -140,12 +146,12 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 	areq->dst_len = req->ctx->key_sz;
 	/* Need to set the corect length of the output */
 	while (!(*ptr) && areq->dst_len) {
-		areq->dst_len--;
+		areq->dst_len -= sizeof(*ptr);
 		ptr++;
 	}
 
 	if (areq->dst_len != req->ctx->key_sz)
-		memcpy(areq->dst, ptr, areq->dst_len);
+		memmove(areq->dst, ptr, areq->dst_len);
 
 	akcipher_request_complete(areq, err);
 }

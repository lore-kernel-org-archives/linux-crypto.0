From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Don't move data inside output buffer
Date: Fri, 14 Aug 2015 07:24:23 -0700
Message-ID: <55CDFA17.3090100@intel.com>
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
Received: from mga02.intel.com ([134.134.136.20]:43799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbbHNO02 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2015 10:26:28 -0400
In-Reply-To: <20150814062636.GA2799@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/13/2015 11:26 PM, Herbert Xu wrote:
> On Thu, Aug 13, 2015 at 11:14:11PM -0700, Tadeusz Struk wrote:
>>
>> Right, but we don't need that anymore.
> 
> Why not? If you reduce the size without moving the buffer wouldn't
> it begin with a bunch of zeroes and wouldn't you lose the real bytes
> at the end?
> 

If you don't like the first option then we still need this, as you pointed out.

---8<---

Change memcpy to memmove because the copy is done within the same buffer.

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index fe352a6..e87f510 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -145,7 +145,7 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 	}
 
 	if (areq->dst_len != req->ctx->key_sz)
-		memcpy(areq->dst, ptr, areq->dst_len);
+		memmove(areq->dst, ptr, areq->dst_len);
 
 	akcipher_request_complete(areq, err);
 }

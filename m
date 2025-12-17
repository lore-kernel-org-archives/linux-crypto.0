Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F6631283B;
	Wed, 17 Dec 2025 06:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765952152; cv=none; b=M50ScfKOw6VOTSkKQKxC86X+j2NSB/r2KA3iGyuLFsR7BfP9XoO/2uKT2ZO6xmXa4lSxbJDT3M69eaTFyWz4x6XYofen7VHSxAISbbNu/PAC0z6yx0nkPrWWPAfdR6M8S/XOT4OL4JoPqTk/aS7KSFRqWSRfCeTIj/crdQdDGcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765952152; c=relaxed/simple;
	bh=iDI+D9GfDFUBd3p6pTaTMBXOWSZHe3zyOZiV+u2mJk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ls/xD+xwFbZ9GkTjbSgpQKOdqWX4fPnihOSNNvOUZzt5Pp9GdSrC79zPmHrWbdITLPEE280Lmee50796N605798bFRpSmMkoLyfcH2XonqdezgFL14BfKnNXur8jVaqIia+hd8tUhDFnj8cmY/LT4LN9aZUZpQgtC3fw6IrNCyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NMqw2tlR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NMqw2tlR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=O+DuHaoHBuMjfOpjQgmTldGBb+1moTzg3u35UYN0pOI=; 
	b=NMqw2tlRdjD82562ezCaP/9iZb7xdgwsmxvlAl3he9Hz3iHIqZJLxfjZSHIeTHu9XCIykgpnMSF
	X2rl7/aTp0wOQ3WZxUkJOXyWUsA81kYdjoutWcY3Oo6xa4yqalqoNLJwpnmz4VRrIwfzVFHfrs+oQ
	qdVYZpKCh5NRdVIwfWsJeMBWOQX7spXyYvRt038lKGbnK7gD9gIYxLTPc/jYzCQaeMrqkjVsO58j9
	qZNu5nRiyLJk8fsGfftSyyQpOOd8aTo+WIu5K67ngrodkekcu/+Abz2VaOe906zU7X9nuvLX8si6O
	r6qIGq3BM7h9eAphj9F7YTWginFEHty9BlgA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vVkp3-00Aifb-1T;
	Wed, 17 Dec 2025 14:15:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 17 Dec 2025 14:15:41 +0800
Date: Wed, 17 Dec 2025 14:15:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Xin Long <lucien.xin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [v2 PATCH] crypto: seqiv - Do not use req->iv after
 crypto_aead_encrypt
Message-ID: <aUJKjXoro9erJgSG@gondor.apana.org.au>
References: <3c52d1ab5bf6f591c4cc04061e6d35b8830599fd.1765748549.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c52d1ab5bf6f591c4cc04061e6d35b8830599fd.1765748549.git.lucien.xin@gmail.com>

On Sun, Dec 14, 2025 at 04:42:29PM -0500, Xin Long wrote:
> Xiumei reported a UAF crash when intel_qat is used in ipsec:
> 
> [] BUG: KASAN: slab-use-after-free in seqiv_aead_encrypt+0x81a/0x8f0
> [] Call Trace:
> []  <TASK>
> []  seqiv_aead_encrypt+0x81a/0x8f0
> []  esp_output_tail+0x706/0x1be0 [esp4]
> []  esp_output+0x4bb/0x9bb [esp4]
> []  xfrm_output_one+0xbac/0x10d0
> []  xfrm_output_resume+0x11e/0xc30
> []  xfrm4_output+0x109/0x460
> []  __ip_queue_xmit+0xc51/0x17f0
> []  __tcp_transmit_skb+0x2555/0x3240
> []  tcp_write_xmit+0x88f/0x3df0
> []  __tcp_push_pending_frames+0x94/0x320
> []  tcp_rcv_established+0x79f/0x3540
> []  tcp_v4_do_rcv+0x4ae/0x8a0
> []  __release_sock+0x29b/0x3b0
> []  release_sock+0x53/0x1d0
> []  tcp_sendmsg+0x35/0x40
> 
> [] Allocated by task 7455:
> []  esp_output_tail+0x151/0x1be0 [esp4]
> []  esp_output+0x4bb/0x9bb [esp4]
> []  xfrm_output_one+0xbac/0x10d0
> []  xfrm_output_resume+0x11e/0xc30
> []  xfrm4_output+0x109/0x460
> []  __ip_queue_xmit+0xc51/0x17f0
> []  __tcp_transmit_skb+0x2555/0x3240
> []  tcp_write_xmit+0x88f/0x3df0
> []  __tcp_push_pending_frames+0x94/0x320
> []  tcp_rcv_established+0x79f/0x3540
> []  tcp_v4_do_rcv+0x4ae/0x8a0
> []  __release_sock+0x29b/0x3b0
> []  release_sock+0x53/0x1d0
> []  tcp_sendmsg+0x35/0x40
> 
> [] Freed by task 0:
> []  kfree+0x1d5/0x640
> []  esp_output_done+0x43d/0x870 [esp4]
> []  qat_alg_callback+0x83/0xc0 [intel_qat]
> []  adf_ring_response_handler+0x377/0x7f0 [intel_qat]
> []  adf_response_handler+0x66/0x170 [intel_qat]
> []  tasklet_action_common+0x2c9/0x460
> []  handle_softirqs+0x1fd/0x860
> []  __irq_exit_rcu+0xfd/0x250
> []  irq_exit_rcu+0xe/0x30
> []  common_interrupt+0xbc/0xe0
> []  asm_common_interrupt+0x26/0x40
> 
> The req allocated in esp_output_tail() may complete asynchronously when
> crypto_aead_encrypt() returns -EINPROGRESS or -EBUSY. In this case, the
> req can be freed in qat_alg_callback() via esp_output_done(), yet
> seqiv_aead_encrypt() still accesses req->iv after the encrypt call
> returns:
> 
>   if (unlikely(info != req->iv))
> 
> There is no guarantee that req remains valid after an asynchronous
> submission, and this access will result in this use-after-free.
> 
> Fix this by checking req->iv only when the encryption completes
> synchronously, and skipping the check for -EINPROGRESS/-EBUSY returns.
> 
> Fixes: 856e3f4092cf ("crypto: seqiv - Add support for new AEAD interface")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  crypto/seqiv.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Thanks for catching this! I'd prefer not using req->iv at all
though, something like:

---8<---
As soon as crypto_aead_encrypt is called, the underlying request
may be freed by an asynchronous completion.  Thus dereferencing
req->iv after it returns is invalid.

Instead of checking req->iv against info, create a new variable
unaligned_info and use it for that purpose instead.

Fixes: 0a270321dbf9 ("[CRYPTO] seqiv: Add Sequence Number IV Generator")
Reported-by: Xiumei Mu <xmu@redhat.com>
Reported-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 2bae99e33526..678bb4145d78 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -50,6 +50,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
 	struct aead_request *subreq = aead_request_ctx(req);
 	crypto_completion_t compl;
+	bool unaligned_info;
 	void *data;
 	u8 *info;
 	unsigned int ivsize = 8;
@@ -68,8 +69,9 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 		memcpy_sglist(req->dst, req->src,
 			      req->assoclen + req->cryptlen);
 
-	if (unlikely(!IS_ALIGNED((unsigned long)info,
-				 crypto_aead_alignmask(geniv) + 1))) {
+	unaligned_info = !IS_ALIGNED((unsigned long)info,
+				     crypto_aead_alignmask(geniv) + 1);
+	if (unlikely(unaligned_info)) {
 		info = kmemdup(req->iv, ivsize, req->base.flags &
 			       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 			       GFP_ATOMIC);
@@ -89,7 +91,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
 
 	err = crypto_aead_encrypt(subreq);
-	if (unlikely(info != req->iv))
+	if (unlikely(unaligned_info))
 		seqiv_aead_encrypt_complete2(req, err);
 	return err;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

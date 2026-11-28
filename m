Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795877474;
	b=DD224q+A5A4HPg2M4J+nIagm0e/YMCjXBw5Za8p23TDX+yI1DZudjUAcJTM1ppm2p9mD
	 lr+ASuCLU+hmiNtitcUPdfXsA/7QfMPrUbU/U/eBSDfZp61/RIPJyT+CmvfC79isYTaZ0
	 lwFmC9/L0FD05lvUpQuFdKjI2lvjIJeVcdcnKpxOFa3oetB1azmN4NYiYewObPvctWQDq
	 wmGTYo+YSvdmQwxwgY83AH59ZfyPvIPktz4+PBKX9gWTjJ4yk7iEpypj6A1EwCQ6CvQ+t
	 qBxRYjpM7CY8OBwkiJNOiamExhMSEifqINDCoI8Tw4XYSQ7E6gQhZgUECalwIMB2FTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795877474;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=F7AAOkPtKyHl14n/1pUH45zuu9Y3FehYVFQHOAjNISw=;
	b=cn3TjV8IdNRq/6OluaLuPck3l88u5jJ+XanMPbyOWXIjEbBbPYjLzsahZrH8gKdQ3FqB
	 TnmPJ7yTwWR6egtjEMWtWZXdRoW0T4M2swOqqbw2tsLwcmfoYtvuhJqWkrR7uZnRsZu2D
	 1PxKULpmUM0vNgav/OBLuHFOJ1VZsFHEJUTiE7V1JPg70LbcCCpvgonM00Q73YoEQHdSq
	 fd1KXfElrVPuDBdb2LGfiIj2NCW/qnCAwFst2tI0UBGmw4HXs5Bt1nCSwWorv8UDzM9Fk
	 wATgJ+10ICFQOkfH2qcqmi6G4XzNMhkPx3iX5LPOUjTf3Yd8f1bMHkggzBLTgjlQHaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=xiaopeng.com;
	spf=pass smtp.mailfrom=xiaopeng.com;
	dkim=pass header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=GpgMYx+r;
	arc=none smtp.remote-ip=115.124.28.197
Received: from out28-197.mail.aliyun.com (out28-197.mail.aliyun.com [115.124.28.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF0B606A31C;
	Sat, 28 Nov 2026 14:51:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EF0B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=GpgMYx+r
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1795877463; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=F7AAOkPtKyHl14n/1pUH45zuu9Y3FehYVFQHOAjNISw=;
	b=GpgMYx+rb15Nv5SnKS22VATPK9TYRkQJRV8k0bgUbS6MXIpCoAoogKINh1pFUuQO/3cxsLuvgrffJ0Mg8mRrUTWxIA3Rlw9ubelBuYA7J+MKA5mt+zsn0zI8qRdMmKtw8u147Kvf8R9bYgycQarTvMofhltF+bsEQrOTtKbBq9s=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04448237|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0179192-0.00131583-0.980765;FP=12576371053077663860|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037026024;MF=fangxy@xiaopeng.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.kCCZ-Vw_1795877462;
Received: from localhost.localdomain(mailfrom:fangxy@xiaopeng.com fp:SMTPD_---.kCCZ-Vw_1795877462 cluster:ay29)
          by smtp.aliyun-inc.com;
          Sat, 28 Nov 2026 22:51:03 +0800
From: Fang Xieyan <fangxy@xiaopeng.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] crypto: scomp - Bound the single-page source scratch buffer
Date: Sat, 28 Nov 2026 22:50:56 +0800
Message-ID: <20261128145056.78807-1-fangxy@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scomp_acomp_comp_decomp() linearises a non-trivial source scatterlist into
a per-CPU scratch buffer that is exactly one page in size, because the buffer
is allocated with alloc_pages_node(..., 0).  The destination side bails out
with -ENOSYS on non-trivial SG lists, but the source side hands slen straight
to memcpy_from_sglist() with no bound at all.

When a request's source spans several SG entries whose total length exceeds
PAGE_SIZE and the source cannot be mapped directly, memcpy_from_sglist()
copies slen bytes into the one-page scratch buffer and writes past its end.
This is an out-of-bounds write into the adjacent direct-mapped page: the
overflow is silent, the compress returns success, and neighbouring kernel
memory is corrupted.

Reject scratch-path requests whose slen exceeds the buffer size with -EINVAL,
and perform the check before taking the per-CPU scratch lock so a request we
can never serve does not take that lock.  Commit 2d3553ecb4e3 shrank the source
scratch to a single page and dropped the old SCOMP_SCRATCH_SIZE bound along
with it; this restores a length check that matches the buffer actually
allocated.  Only requests that genuinely need the scratch buffer are affected:
a directly mappable source, however long, still bypasses the copy as before.

Fixes: 2d3553ecb4e3 ("crypto: scomp - Remove support for some non-trivial SG lists")
Cc: stable@vger.kernel.org
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
---
 Reproduction / validation (evidence, not part of the commit message):
 
   Env: v7.3-rc7 (d998a300b881), CONFIG_KASAN=y (generic),
        QEMU 8.2.2 with KVM.  The scratch buffer is allocated directly from
        the page allocator, which does not add a kmalloc-style
        allocation-boundary redzone; generic KASAN therefore does not
        necessarily detect this overflow.  In our reproduction no KASAN
        reports were observed across runs, so the deterministic evidence is a
        WARN_ON_ONCE(slen > PAGE_SIZE) probe plus a synthetic caller that
        forces the scratch path (non-virt, multi-entry SG, slen > PAGE_SIZE),
        which the real in-tree callers do not hit with an overflow on x86_64
        (IPComp linearises skb->len > PAGE_SIZE into one directly-mappable
        entry and bypasses the copy).
 
   Unpatched baseline (probe build):
     WARNING: crypto/scompress.c:239 at scomp_acomp_comp_decomp+0x66b/0x7f0
     F077PROBE slen=8192 PAGE_SIZE=4096 scratch=ff11000004c92000
     F077TRIG compress ret=0 slen=8192      # overflow "succeeded", silent
     (grep -c 'BUG: KASAN' = 0 -> no sanitizer report)
 
   Fixed (this patch), same synthetic trigger:
     F077TRIG accept slen=4096 ret=0        # scratch path still served
     F077TRIG reject slen=8192 ret=-22      # -EINVAL, checked before the lock
 crypto/scompress.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index de54227203ce..02438d8f1751 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -232,8 +232,16 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	struct crypto_acomp_stream *stream = crypto_acomp_lock_stream_bh(&crypto_scomp_alg(scomp)->streams);
 
 	if (!src_isvirt && !src) {
-		struct scomp_scratch *scratch = scomp_lock_scratch();
-		const u8 *src = scratch->src;
+		struct scomp_scratch *scratch;
+		const u8 *src;
+
+		if (slen > PAGE_SIZE) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		scratch = scomp_lock_scratch();
+		src = scratch->src;
 
 		memcpy_from_sglist(scratch->src, req->src, 0, slen);
 
@@ -252,6 +260,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		ret = crypto_scomp_decompress(scomp, src, slen,
 					      dst, &dlen, stream->ctx);
 
+out:
 	crypto_acomp_unlock_stream_bh(stream);
 
 	req->dlen = dlen;
-- 
2.50.1


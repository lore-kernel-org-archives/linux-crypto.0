Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795116033;
	b=rLtzCQubq3GXIcsNVb+Rnsw1HLi5rQQQsBbcYMkn1dwpbUlqJ+12qDIK7G296oXsWS9n
	 XXgwOYsvdW4/UMtNMdEJl57hE2ovTyTEfVKVA++9i/ncwfDZlD5IHaEnOkA9UByheYWfJ
	 /vShrgWDtPr/p4Jvn+iOeGd7aF6cGJxyVwZ5b8ivxjTNdhy6PUsJHiczgscn+9jF1xJuW
	 tYHbIQaw7f3YlxZqwi4kSCYwF1yZt8+lytIxim+tnX0Tk+z5WAdjSCHIR8OkEbjjbmCkh
	 w9S0SSuKEeHklP0PSyFzCMGF8b/l8aA8Q5X3MbKac8QkAWuV44QN0w34uFAGIk+EM7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795116033;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=RC0vdeOZgxVd7eCmVRzbH0n2/G3tA5ZR8HdgV3u6j3E=;
	b=GPsQSzxKPSzg6PAB7UlL1SSDLRWShWTI2zAnWCnk6/Q/+lO+1qrJv6IhyYAJHJAW/+n3
	 brwNBM+PrZ+zTBenSkwbRn910oF1dL1JhI2WxUEqM/q8F8FwOKv07FUfLFCAnI2tvhrTJ
	 OgE5+vwI3kemHcww4Ttv3f2X5b8fVXXkP6NqlzKAvAXi+bc8MFFUranbDX6XjM54+2U9z
	 f6UAPuyUMIH1ruM/pY2KK9gczpOjXYahysBi4hU2YE3ewmyGUCy1E7iUMnLoblGCnwq09
	 jDaFioZdRdmBdVamMJc5b1x9+t/1yKk3ufNqZ211vaRuHzoRl+SLInD2ZIj+qJso2lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=iumooogl;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B75606A33B;
	Thu, 19 Nov 2026 19:20:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6B75606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=iumooogl
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.corp.microsoft.com (unknown [52.167.112.163])
	by linux.microsoft.com (Postfix) with ESMTPSA id 227A220B7166;
	Thu, 19 Nov 2026 11:20:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 227A220B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795116030;
	bh=RC0vdeOZgxVd7eCmVRzbH0n2/G3tA5ZR8HdgV3u6j3E=;
	h=From:To:Cc:Subject:Date:From;
	b=iumooogl6A2hqfag5PHRYUs1x5fF2rPLtSftSzrk7rPQ9rxzduJkx8jDk2RccYdRN
	 vrj3LIohmC2tYBFwO4WI3ywjYgpvW/aG4CpM+56WgrJZLIyAQVQuP9gX8kZAUCkikf
	 xgN/u69HPnz0wh3SmjL59USz384mH16SaU4NQzhU=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	gaurav.jain@nxp.com,
	meenakshi.aggarwal@nxp.com,
	tudor-dan.ambarus@nxp.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: caam - stop RSA zero scanning at the byte limit
Date: Thu, 19 Nov 2026 14:20:07 -0500
Message-ID: <20261119192007.786827-1-jeffbarnes@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
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

When the requested zero prefix ends at a scatterlist-entry boundary,
caam_rsa_count_leading_zeros() calls sg_miter_next() after consuming
all requested bytes. The iterator releases the current mapping and
can return false because its bounded scatterlist is exhausted.

The scanner then assigns the previous mapping's zero count to
miter.consumed, although miter.length has been cleared. The final
sg_miter_stop() consequently warns that consumed exceeds length.

Stop scanning once the requested byte count has been reached, before
advancing the iterator.

GitHub Copilot assisted with diagnosing the iterator boundary issue,
developing the fix and regression tests, and drafting this message.

Fixes: e30685204711 ("crypto: caam - fix unchecked return value error")
Cc: stable@vger.kernel.org

Signed-off-by: Jeff Barnes <jeffbarnes@linux.microsoft.com>
---
 drivers/crypto/caam/caampkc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 955a5dd450406..e730697678c30 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -302,7 +302,7 @@ static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
 			buff++;
 		}
 
-		if (len && *buff)
+		if (lzeros == nbytes || (len && *buff))
 			break;
 
 		if (!sg_miter_next(&miter))
-- 
2.43.0


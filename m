Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A667521146C
	for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2026 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774452713; cv=none; b=fT7Fr0T46gB8wgrTvM83Prcr6lDh2vii/jeAaQKLbqjvkCct11m0f43R+tGkPmu8u0hJZjTd8iQGSitZjU8p9XxYO6wrugeP53TNS1yxxm7SkoWCoEMmwo2hIjw/CuGkDX+uomWHaXy1wHtXHhKri0ERMcanlVJlcYXMpLkPt2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774452713; c=relaxed/simple;
	bh=rAU7mpdZrJ4Eo6S2jbYg2ERbl/Fmt9gGxZBcEPYFIfA=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=aLI7k7i9BvwE0Pcv/7RSSIb/LLWZzUbJfBzBG03xn8n33dIEuNpJAR7nUiLMCUVL8AEcUxn+uIuxoYfJg+xDtVRubcSG3HIqVFnML7hqn9erJ5jEndG97ojGolsmTM02XAdRFq+M5YX1aloF6xh7oL0ORaBqPnCOdv2z9mqtdYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cmDYYV8d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cmDYYV8d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774452710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hgn5LRIv+4wSW1Ec+npnS4dLubBrEt6pLha/k1rXeec=;
	b=cmDYYV8d1ElK1dLnzkQ4sJSBG58GNNCguH5EaBOcd7X3wWS2AoTSujhJ30n60Ox4SzE9Ye
	U4irClfOebvCfwYbjpFm8A56WUAIHMIiskxtuZ0PqVP7RrxBB9Ijbru9Dfn2r1+262QXkx
	6SyLFTqwIRVawIhaStrGT9MgGQ6uuCI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-rLe7-a8BPvyqcLPaQQEjmQ-1; Wed,
 25 Mar 2026 11:31:49 -0400
X-MC-Unique: rLe7-a8BPvyqcLPaQQEjmQ-1
X-Mimecast-MFC-AGG-ID: rLe7-a8BPvyqcLPaQQEjmQ_1774452708
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 050C31956076;
	Wed, 25 Mar 2026 15:31:48 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 967EB19560B1;
	Wed, 25 Mar 2026 15:31:45 +0000 (UTC)
Date: Wed, 25 Mar 2026 16:31:38 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>
cc: linux-crypto@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] crypto-deflate: fix spurious -ENOSPC
Message-ID: <f6a1465f-c4f1-6847-9e3c-d7225bad4059@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Herbert

I am developing a new device mapper target that compresses data and I 
found a bug in crypto/deflate.c that it sometimes returns -ENOSPC even if 
the decompressed data fits into the destination buffer. I'm submitting 
this patch to fix it.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

The code in deflate_decompress_one may erroneously return -ENOSPC even if
it didn't run out of output space. The error happens under this
condition:

- Suppose that there are two input pages, the compressed data fits into
  the first page and the zlib checksum is placed in the second page.

- The code iterates over the first page, decompresses the data and fully
  fills the destination buffer, zlib_inflate returns Z_OK becuse zlib
  hasn't seen the checksum yet.

- The outer do-while loop is iterated again, acomp_walk_next_src sets the
  input parameters to the second page containing the checksum.

- We go into the inner do-while loop, execute "dcur =
  acomp_walk_next_dst(&walk);". "dcur" is zero, so we break out of the
  loop and return -ENOSPC, despite the fact that the decompressed data
  fit into the destination buffer.

In order to fix this bug, this commit changes the logic when to report
the -ENOSPC error. We report the error if the destination buffer is empty
*and* if zlib_inflate didn't make any progress consuming the input
buffer. If zlib_inflate consumes the trailing checksum, we see that it
made progress and we will not return -ENOSPC.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 crypto/deflate.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6/crypto/deflate.c
===================================================================
--- linux-2.6.orig/crypto/deflate.c	2026-03-25 15:30:28.000000000 +0100
+++ linux-2.6/crypto/deflate.c	2026-03-25 15:33:37.000000000 +0100
@@ -164,18 +164,21 @@ static int deflate_decompress_one(struct
 
 		do {
 			unsigned int dcur;
+			unsigned long avail_in;
 
 			dcur = acomp_walk_next_dst(&walk);
-			if (!dcur) {
-				out_of_space = true;
-				break;
-			}
 
 			stream->avail_out = dcur;
 			stream->next_out = walk.dst.virt.addr;
+			avail_in = stream->avail_in;
 
 			ret = zlib_inflate(stream, Z_NO_FLUSH);
 
+			if (!dcur && avail_in == stream->avail_in) {
+				out_of_space = true;
+				break;
+			}
+
 			dcur -= stream->avail_out;
 			acomp_walk_done_dst(&walk, dcur);
 		} while (ret == Z_OK && stream->avail_in);


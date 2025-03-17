Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605CC235BF5
	for <linux-crypto@vger.kernel.org>; Mon, 17 Mar 2025 10:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742208554; cv=none; b=HjM2l6LgyQ9YlLJ8kQeMFF+PkVZ+6LVxqGxq6ADEbAfj0/eBlBv62uhvq/0RbxZTY8kpJPS4yEDL/1965jF+az5alqF/+dUdf5l0zXtWYEJHrI44nPSnxKxwLrkoGQU6VNlMl6D4CDEcol2y6C+GUjS7lOvMQOE6hoGUNhdTXzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742208554; c=relaxed/simple;
	bh=Kp18ekQ3AfM4qDIYttsL+4agfm89UIpbN5I4b9i+xME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a/QvWR1JyM2dAUwF6nMD43x6TMk9c8khj9KcXS6xEck9L72FCAXG6UToVT2zHFxVFHSqzE9iV90NgdMhbEX1sP4sGYUrkewEMZJHooJgZtjpsyKN8fjJ3xlD7iLIBkNPNwDzbQ8klrcaDAIFBFcEZruLjz1kcHZz0q1sGm3Z95I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BZU7zoAf; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BZU7zoAf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742208538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EIOtecTr1V7gaL+HzDR3DlZXqtP21yGqlv128Jc8x58=;
	b=BZU7zoAfU6RK+MPW7YLHc7etIt6k9f7fHRaHe6saXSWWtlxWvOwLP/bi3TSTrelDLcs816
	oqwq+LOvDmYx9iYyEndZHoyEFCMSK6nZDOiZ3IuKnuNKam9CRaNdE1c2WPLEfs4YHpZARH
	SRMKSFQryMHtP4bAhzH3bQAWU600Tv0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: x509 - Replace kmalloc() + NUL-termination with kzalloc()
Date: Mon, 17 Mar 2025 11:48:41 +0100
Message-ID: <20250317104841.54336-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use kzalloc() to zero out the one-element array instead of using
kmalloc() followed by a manual NUL-termination.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index ee2fdab42334..2ffe4ae90bea 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -372,10 +372,9 @@ static int x509_fabricate_name(struct x509_parse_context *ctx, size_t hdrlen,
 
 	/* Empty name string if no material */
 	if (!ctx->cn_size && !ctx->o_size && !ctx->email_size) {
-		buffer = kmalloc(1, GFP_KERNEL);
+		buffer = kzalloc(1, GFP_KERNEL);
 		if (!buffer)
 			return -ENOMEM;
-		buffer[0] = 0;
 		goto done;
 	}
 
-- 
2.48.1


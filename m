Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9D53A5E95
	for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 23:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778455516; cv=none; b=GYyiG4vyXit6CuBsqHhW18H9G8fiRRV3F0LNEnb82pEvSmF5v/aI7hwLhXFuxMd5JqJ3nFdZ7YZXmCAAtqEbM80DaHFBldOY100FqbdQd0Obvyx/67E4MYGhutvwg3AgULpO7ZPPh8X5g3EPDbBUC2jVWY5PtplaxsSY0Sx5MR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778455516; c=relaxed/simple;
	bh=/8xhVXrz8Q3xpD7n94ZUl2QrHgwje+BwlZ2z4YrUPuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnOc9qwVDzU9QmddBv7h8REtJd65DpuwZ49nXujxsTvyy6Y2KkllgAG+PJYQn5LyPxYJTJTqM7Pt4njHXLse/wAaFO5nuSz921BHpiccT5ylbABsf4IFEy5NsNwHsg8B6QOa9sNBE9KjgToGZJYAtRnRKNxhNHNJbLYMAivF1kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PWSFukBs; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWSFukBs"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7bdaa68cf81so34801707b3.3
        for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 16:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778455513; x=1779060313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZOy80O60KUIlyR9w5AQAgpnG4tbnSWNzRVhKEWyyTiM=;
        b=PWSFukBsuCDiJKYHM2AhTDVXUMY6qTVT+shRweNH6zUcpDuTqUIVWpapzBAhQWCRo5
         DwCRRoz7b+jorgtjI8zNlA4PUXwN331i5g8ugB0YGxEOMtrZkFaK5JXZogEEnXRusL5Y
         s7lTG4zv17VpA93jF8GyWBPa5UAadom+Bfv8AwdT0DazeVXTipShUmf5HmV73JEsfQM8
         cw/ZUBqogbATcUFvoaOKXIU6dBst+hjM9G3sQklRVI55wfRLujCLgoIXeBC4wz0lnvQD
         WeUzquPTwg7qRAmjgn51HEiWB2d7blMUimSfmTu7yS3taiHcEJIT2jzRTtGduiK+KMhS
         FQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778455513; x=1779060313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZOy80O60KUIlyR9w5AQAgpnG4tbnSWNzRVhKEWyyTiM=;
        b=FTUqIo3+aA3VF1NydElNmVEK56n+nt39lKPfARdSC8n0qZOLR5fW+KETCzcoS0a1d4
         HQRbjtJpqxMEk9hB4rCwGV25c9Ct4dSB8qBeKbBPyD7jZRIAPyQppQVEVHpz6wXTiI91
         kcTcFbtGvAXZiZisrdInuvWut0nGCA5D8JrnjC8NlNWQplnjMTVSROoK1cK2zH7vT1Ow
         QT1qCQLZxliWv06igcZYzLi6jX3n4bC59OOFaGVML5WQh5yFd0Dx2y0qKzZ3O/L6CdiK
         PJkaSk1sUl5zc0fPU+RkDD2Qe+oFxxFA7PCqZBsotoq/Wtgf45jOIiHlprUiULSIjDBu
         nK0A==
X-Forwarded-Encrypted: i=1; AFNElJ9e3U0ScS9iLkbu7eWdcB6dUxDb1J7F7Psxh3xAxG87++CNWflVhY+jS8rVWgqwWuJcscdUP6ABRfNfRBg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbJe7bkdCR6tODhwG2H33ENuaY2eFWfxWx961/gNCaleOIYlKs
	BXkHrkW/93uXSSE+TNaXCpt+Ovw3+TUJjfV0hosfdloWUmJf3oPlHz2b
X-Gm-Gg: Acq92OFHe89UuOT+ZXITul4CJ0sXw/G1m1xSqtKYOuo50q6JWTM+ARRg6YQicg/LNb1
	vZAKb7B1pxdcPRM38qFKXgwW856aB6UEDZ0Qwz0+zrZnri6uqng/Ie/VmdbiLukjg+ddE5tuCzQ
	6rzS+8ks2Hah0Nhfah9xV697LhOCc9biDf2VrdPnC865JB2YPeVnbpssJ+wfrdIg1wqb/VKAn49
	Gxu/W0gdMuYauJb8Asx6kvnMudQA4tSLExsJb2feia/+OoZY+cDqnT0dn2FtefesEEoEmn0lwv3
	52Xm9KgYfFk+ENjHfYLAgYpT3WRDAN4KCi2/fBbNuouxYskug3v/1fJ8vyyp8lVUZzBCGVkepTD
	bQsEOOXyN7h20jrPJw0iyBTLQtgUtb1AORWpydoyubN3dpZ+4MpM/FQDrN/8kNtD6kI9MdrVW9+
	gR9ibH5GbhQnQQER1j9YsWj2+rNIImsNpIzFDghuBkEV5Z0EJWKHFGaCoBiZXzBEFfpxd99H/v2
	+/C1g7B3d5GFKPiFAjUgioh8IgyCY98G2QNEm03OHc=
X-Received: by 2002:a05:690c:6f06:b0:79a:7157:879 with SMTP id 00721157ae682-7bdf5f37cf8mr216629967b3.50.1778455513123;
        Sun, 10 May 2026 16:25:13 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6656d218sm137549197b3.22.2026.05.10.16.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 16:25:12 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	ceph-devel@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: krb5 - filter out async aead implementations at alloc
Date: Sun, 10 May 2026 19:24:55 -0400
Message-ID: <20260510232455.2245650-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260502132506.1936358-1-michael.bommarito@gmail.com>
References: <20260502132506.1936358-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

krb5_aead_encrypt(), krb5_aead_decrypt() in rfc3961_simplified.c and
rfc8009_encrypt(), rfc8009_decrypt() in rfc8009_aes2.c set a NULL
completion callback and treat any negative return from
crypto_aead_{encrypt,decrypt}() as terminal, falling through to
kfree_sensitive(buffer).  When the encrypt_name resolves to an
async AEAD instance the request returns -EINPROGRESS, the buffer
is freed while the backend's worker still holds a pointer, and the
worker dereferences the freed slab on completion.

KASAN report under UML+SLUB with a synthetic async aead backend
bound to krb5->encrypt_name:

  BUG: KASAN: slab-use-after-free in t5_stub_complete+0x7d/0xc7

The helpers were written synchronously, so filter the async
instances out at allocation time instead of plumbing
crypto_wait_req() through every call site.

Reachable via net/rxrpc/rxgk.c, fs/afs/cm_security.c and
net/ceph/crypto.c on systems with an async AEAD provider bound to
the krb5 enctype name.

Fixes: 00244da40f78 ("crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt functions")
Fixes: 6c3c0e86c2ac ("crypto/krb5: Implement the AES enctypes from rfc8009")
Cc: stable@vger.kernel.org
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 crypto/krb5/krb5_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/krb5/krb5_api.c b/crypto/krb5/krb5_api.c
index 23026d4206c8..2b20284fa0ab 100644
--- a/crypto/krb5/krb5_api.c
+++ b/crypto/krb5/krb5_api.c
@@ -165,7 +165,7 @@ struct crypto_aead *krb5_prepare_encryption(const struct krb5_enctype *krb5,
 	struct crypto_aead *ci = NULL;
 	int ret = -ENOMEM;
 
-	ci = crypto_alloc_aead(krb5->encrypt_name, 0, 0);
+	ci = crypto_alloc_aead(krb5->encrypt_name, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(ci)) {
 		ret = PTR_ERR(ci);
 		if (ret == -ENOENT)
-- 
2.53.0


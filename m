Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C7A3644BC
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 09:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750283; cv=none; b=n1VXSDRo2n/48UJh1vbBz6MJ8AxKtJn3PUliqcbg69S1u+Jo/OCUmThOn+s3RcRDEkVctCzZowReKmTB3wvkEhWo27edDOz8qfDpU80CSmu9aMwJemJm7np2zghk2v6ugw3AlDoBx9MQ165Ua8/sSGsd9z/KH0QwqAY84b61rIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750283; c=relaxed/simple;
	bh=NCEJ1TbhajvTImCsOQwzDrt/omBBYWmQa4he4fTkTdI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UQhg0Wr8HH3cJCJ7IVcZH/6j3huI72mUsHktQmAL17ctO9h5jiPayoB1MPaeJ3oJGirWXiuPBoIgcc7An009bGWtTrmPomX+V9eoIViKu6BKWSCcHf5/l3wXgL9fP9RHq9dmpbTHIdhuhJnzq3hhI/hGUX5L98Q/xT7eWA0UVc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C9yo6KRQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C9yo6KRQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785750281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YsN8us4QKwlTTXH35Rtp/mjbULCvBbbwZn45ro6nr9c=;
	b=C9yo6KRQFVQQ/gc1nj5xf3Hl3GoM/oUTRDxUR5dGet5xv8UU37nTSZ7NY+TXlKYBSxfkrS
	NZrhTs0Naa6maVt6TluX11XwO32ILuiGkOGyOQZ1SEEm0+sS2aHS8CGJ1OGY6HsHS3hLCC
	E7Hue8bcM+KuCWAId9MFgc7s86Remx4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-gjmYN6l5Mb2I0jMZbGPOWw-1; Mon,
 03 Aug 2026 05:44:39 -0400
X-MC-Unique: gjmYN6l5Mb2I0jMZbGPOWw-1
X-Mimecast-MFC-AGG-ID: gjmYN6l5Mb2I0jMZbGPOWw_1785750278
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A69EC19560A7;
	Mon,  3 Aug 2026 09:44:38 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.213])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A798C1956087;
	Mon,  3 Aug 2026 09:44:34 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 0/9] crypto: Provide a function for zeroizing crypto_aes_ctx
Date: Mon,  3 Aug 2026 11:44:19 +0200
Message-ID: <20260803094432.70505-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Several crypto drivers need to zeroize their local crypto_aes_ctx
structures after use to avoid leaking key material on the stack.
Currently some call sites do this with their own memzero_explicit()
call, which is error-prone since it is easy to miss a return path
(what already happened in some drivers). Some other call sites miss
to clear crypto_aes_ctx completely.

To improve this situation, the first patch introduces an aes_clear_ctx()
helper that can be used with __cleanup() to automatically zeroize the
context when it goes out of scope. The following 6 patches add this
__cleanup() to spots in the code where this has been forgotten so far.
The final two patches change some files to do the zeroization with
the new __cleanup() way instead of calling memzero_explicit() manually.

v2:
- I sent out v1 last week, but I think it never reached the mailing list.
  Either a PEBKAC or a mail server problem... 🤷‍♂️ 
- Rebased onto cryptodev master branch, updated the "qat" patch accordingly

Thomas Huth (9):
  crypto: Provide a wrapper for zeroizing crypto_aes_ctx
  crypto: aspeed - clear the crypto_aes_ctx when done
  crypto: inside-secure/eip93 - clear the crypto_aes_ctx when done
  crypto: padlock-aes - clear the crypto_aes_ctx when done
  crypto: sa2ul - clear the crypto_aes_ctx when done
  crypto: arm/aes-neonbs - clear the crypto_aes_ctx when done
  crypto: arm64/aes-neonbs - clear the crypto_aes_ctx when done
  crypto: safexcel - zeroize crypto_aes_ctx with
    __cleanup(aes_clear_ctx)
  crypto: qat - zeroize crypto_aes_ctx with __cleanup(aes_clear_ctx)

 arch/arm/crypto/aes-neonbs-glue.c                 |  2 +-
 arch/arm64/crypto/aes-neonbs-glue.c               |  2 +-
 drivers/crypto/aspeed/aspeed-hace-crypto.c        |  3 +--
 drivers/crypto/inside-secure/eip93/eip93-aead.c   |  2 +-
 drivers/crypto/inside-secure/eip93/eip93-cipher.c |  2 +-
 drivers/crypto/inside-secure/safexcel_cipher.c    | 15 +++++----------
 drivers/crypto/inside-secure/safexcel_hash.c      |  3 +--
 drivers/crypto/intel/qat/qat_common/qat_algs.c    |  3 +--
 drivers/crypto/padlock-aes.c                      |  2 +-
 drivers/crypto/sa2ul.c                            |  2 +-
 include/crypto/aes.h                              | 13 +++++++++++++
 11 files changed, 27 insertions(+), 22 deletions(-)

-- 
2.55.0


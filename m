Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CAE3822A3;
	Sat, 26 Sep 2026 05:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790402376; cv=none; b=I3D5LO5nPvN4msfwvz8lrwPCT6JVzglZ6tGDEXcBzWx6NJcWspKju+h/OOatlz6IsErYi6edEECy6WOF5i0CKh1CgDsyvxMNF0jpJMVFAbX4SgeLO1DaMGr1I9L6HpCwmfoinZfFDnE7yesquAKN6owAIBkZccAALGeDG3fAtiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790402376; c=relaxed/simple;
	bh=oi1LnliCzoP4uTFsmZVcSENROhWEOkIB9pv9gbtQMQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldlNuNDnT4piS0hPXgf44J0EHaMOGTaXDlAAAdTin+K7UxxB9UkPPxNuk3hmaffbIDJ2pzJHuzP+bvSAAXJtrkz8h9LAo1Hh7KaRvUTJM51S4ML/DvvDNKfRjYzhMIzhxzoc2MwjN9Q5XNzhHr5boClaYH2Qv7a7kNZtpp4iZnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOK94FlR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOK94FlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE8F1F00893;
	Sat, 26 Sep 2026 05:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790402375;
	bh=pD5sa4A6W5qlwy9/E5qHspueNlUl3TGZ17rv7wwjV/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOK94FlRtrW9qWPmMMjgbdZwnmGfQFt49zfzzk6TIR4nbgTVhjywQKWzEFvCbh5r/
	 F4q3sbVBgKIg6EqVbSmRFooDvcn9GJg3Ycux2cuKg/qiLvrE4jqHHQJacnSEcIHH70
	 oODBqZM+jmPkGrcMRMdlpA9eKbKIgElbtkSGSnb0/X8D3RX1Pe1j96iovx0FVV6861
	 rWDkT5ZNgNcAjhxjSIh7OpQ+I5S9uYkMsRxEM3AfEvkJaj4dFtP90+lfhLknFJ9gmA
	 wUybRtlBL6WnpsKcwN6jTacpdOUqKwr7EdzBfmKfAsmTB6IQfHke+9trJ+9mkLEco+
	 h9yGHtbNtunfA==
From: Thorsten Blum <blum@kernel.org>
To: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thorsten Blum <blum@kernel.org>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hwrng: virtio - use snprintf() in probe_common()
Date: Sat, 26 Sep 2026 07:58:55 +0200
Message-ID: <20260926055853.4868-4-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926055853.4868-3-blum@kernel.org>
References: <20260926055853.4868-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=804; i=blum@kernel.org; h=from:subject; bh=oi1LnliCzoP4uTFsmZVcSENROhWEOkIB9pv9gbtQMQw=; b=kA0DAAoWXqtxINjMdS4ByyZiAGq3XymjCUpvRFZn0XDIvYaB0B1Pr6JRPLxctbxJA5+/Z4SUB 4h1BAAWCgAdFiEE4Jr4mE11fHmyNFi5XqtxINjMdS4FAmq3XykACgkQXqtxINjMdS5cgAEApmZL xztYk83911z8dxR/o6GiigZanqnijVWQaQGN3JUA/2CWPAO1qo5gXsLhI9CWRUnngpzMJveyVOt rr501KOsG
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

While the current code works correctly, replace the unbounded sprintf()
with the safer snprintf() to follow secure coding best practices.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 5b1b23b5596a..f9982217247d 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -162,7 +162,7 @@ static int probe_common(struct virtio_device *vdev)
 		err = index;
 		goto err_ida;
 	}
-	sprintf(vi->name, "virtio_rng.%d", index);
+	snprintf(vi->name, sizeof(vi->name), "virtio_rng.%d", vi->index);
 	init_completion(&vi->have_data);
 
 	vi->hwrng = (struct hwrng) {

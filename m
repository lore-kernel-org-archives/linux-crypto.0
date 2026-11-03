Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793724656;
	b=fBVUBdMYQ/tvzV8GGpQbqvMomcwvTsWZTO7+42jrerGbUI8ZCU3pIl9B0U/IZ5BN8OEg
	 7+Et/VVyoDej0ZXmezGxFUS3ntpLmO4uMibvDTRQ6f4Aa/CGsjy4DeoeebMuZgJGUJJyC
	 4oiyDOQYQHpwPOjFtbJa3uPWamNnMFihQIf+HvNOgOrpovFx2T9/5Z62KK6qC5GqE+H+C
	 G8tzDs2NYYrGcTuWbqLxjwVdxp78kDwAMUr3PiMptl8LvP2m3T3M++KSFXjx+MPUd02Xa
	 0898Xo6umpK+SEdR1iVvpP0vFr80c91G/XPY/Gn0Px5UEXeGSDZYu3BEpSqXsohRd/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=HvepMD3bA5aDGNIpfaaW63plOSdqKDU2bYIKQSrUk80=;
	b=VD52NBf585a1GWw01BRSulWqFFvVZTUL9K2Ae9l9sOsNgJmgrEXfvWrHJjarpmb4ethZ
	 fnNh20qv4tAszcyVd7XhoM/vH6TkVzgYiHf2J3HJjhoV4aLIVPJYvEbOmEo25t/R/NM/y
	 tfZ7u/wD3+KcDxfuzh7q05fdDEPAyghsxPNi56me2vTmFUMh6iwZR8/mpqzMit9Rip/UL
	 7TfM57l2pkV/0oKWCXylbLL01m7/cENZDtdkpVD8HWDGDLMInUYAsDEwyMyEw33IR61v4
	 gV5GnyoAcJ5deW9nQmFD3V8d8yaK2uH4SlQGMvbR1n43pndRKMqNUlAePPxew4F7J/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jpA5uBAm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9F9606A336;
	Tue,  3 Nov 2026 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jpA5uBAm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953981F000C1;
	Tue,  3 Nov 2026 16:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724655;
	bh=HvepMD3bA5aDGNIpfaaW63plOSdqKDU2bYIKQSrUk80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpA5uBAm0M8lavM0Yy9jEvsCvpODwogzY029ZQQx02unY8o9Ng3vAi3wrAMpQaSmc
	 IsgFkgEOAoNLVz6giG052wF/QTcjrog10kF1oMaehPi2euvGgv63M07ma/qVKfWlnb
	 gfi+rNwmcb2F6KyTVLB0xQ8CUDe+cuQwbFj40CRrdaiv8T41J7jJgIhreCbYVBL8GN
	 A2uG1vzN+gGC1jvaTMKXvB4YGP/NRFJGiMpde30xaRNKsWtAN7r9ktWjRZ2OeCOnxG
	 SWTYwR3GaKLSuT8AcqY2ra2oe9Nmrmh4tNr2IeNjMRxRxwBPGpnc1fpAh6x+ZP8wHI
	 Tscg02HMqee8w==
From: Thorsten Blum <blum@kernel.org>
To: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thorsten Blum <blum@kernel.org>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hwrng: virtio - simplify virtrng_restore()
Date: Tue,  3 Nov 2026 17:50:28 +0100
Message-ID: <20261103165026.454333-4-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103165026.454333-3-blum@kernel.org>
References: <20261103165026.454333-3-blum@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1486; i=blum@kernel.org; h=from:subject; bh=FVIFUZ5ihpdfeiOOZxwZ1iGDyjPpbrvySLprWVV+LNc=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmvBO6aHzBe/+dAw3Oz01Nd1a//CLs4U1n8wcE9i1XF5 +yrYtrH1VHKwiDGxSArpsjyYNaPGb6lNZWbTCJ2wsxhZQIZwsDFKQATmfeb4X+OiZ9p+26Xt4sm nIvj+6abK+BTv09h3RG+b6r8R0Pnlrxj+MPFaWKttr99m1o/a/aeOdsvK9crng9a/ifNYtmz/5f SbzEBAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Return errors directly to simplify the control flow.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 31 +++++++++++++++--------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index f5e8e6093e27..de1d0113ce6c 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -244,26 +244,27 @@ static int virtrng_freeze(struct virtio_device *vdev)
 
 static int virtrng_restore(struct virtio_device *vdev)
 {
+	struct virtrng_info *vi;
 	int err;
 
 	err = probe_common(vdev);
-	if (!err) {
-		struct virtrng_info *vi = vdev->priv;
+	if (err)
+		return err;
+	vi = vdev->priv;
 
-		/*
-		 * Set hwrng_removed to ensure that virtio_read()
-		 * does not block waiting for data before the
-		 * registration is complete.
-		 */
-		vi->hwrng_removed = true;
-		err = hwrng_register(&vi->hwrng);
-		if (!err) {
-			vi->hwrng_register_done = true;
-			vi->hwrng_removed = false;
-		}
-	}
+	/*
+	 * Set hwrng_removed to ensure that virtio_read()
+	 * does not block waiting for data before the
+	 * registration is complete.
+	 */
+	vi->hwrng_removed = true;
+	err = hwrng_register(&vi->hwrng);
+	if (err)
+		return err;
 
-	return err;
+	vi->hwrng_register_done = true;
+	vi->hwrng_removed = false;
+	return 0;
 }
 
 static const struct virtio_device_id id_table[] = {

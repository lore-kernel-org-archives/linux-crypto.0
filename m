Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792986273;
	b=qAXb0V4iDZWwaRc7MlJQpc0Z2TD2KdWKwZUt9bd9jNT4Mgt4t1fj28v+jOkDY33NZ64A
	 pxBn4ZHPbBAyjzW+SYqk75z1qluziMJEpC9rGFxBOLmpu3IZDJIvBvKioorV2SxJJUym6
	 DvRS16eZNVo/4tJWMDcT4Nz7e5LSf+oudcuSG4SlEn0eKGgquOGdrVnI38lqjB5tpEtd2
	 tR/s1GkKkbOjbEyvuDrtRNTWFp3NH3WukzaSDfYFWuftUbG7QAbPjAupsUloGFD3EfV9g
	 J1quU/vmP0mC5qo6r5jeJH0snY2TQfrC4lBnOzWRly/iXm6Rnjvdw2NMVLIE+m+lQ7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792986273;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ty866em+IDE8Kl/ELzTlqPQgUH5LRJQ9LdrJwbbw3HI=;
	b=x8rCvIUnbWfuBOzbE2I6MrojjMn2gNa6dUqI8EPVHELzHYO/2Q9mkBrq14bnedHGDI6/
	 0m5MxTY8SiHH965PQQMnAuY98eTiVsm8iROhEBiwPrvCxBs82UJWcsRgejARLpPg+JR+M
	 z8eUf3IhY590d/wpudgyY1V2FPa9xc3OgIKLu9nnLaALOTbx0TpAOcww/ngfFq3Ry6l/D
	 aep8uIFkvb1mVxTaU/SaAJ8s1znzLCyCyqEDi/PgvzVMWcxdeTePTWH4OLdjFakY6c6gK
	 TfcdGrsLNarzxIZQJXWVL/TAKzWM/pFe8HwSEr/B7m49UmZB2nQA73oacGIH8q9qQxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=l1RuyX8G;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A4B606A320
	for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 03:44:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3A4B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=l1RuyX8G
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8ab38a051aaso21720627b3.3
        for <linux-crypto@vger.kernel.org>; Sun, 25 Oct 2026 20:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792986272; x=1793591072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ty866em+IDE8Kl/ELzTlqPQgUH5LRJQ9LdrJwbbw3HI=;
        b=l1RuyX8GEV0bCpa61G+o0ylyJeiVQhqDJkrwn60g4MAqXNaC8bUHPU0dsCBy0qKklh
         28hFqb5NnNjtLAbllRO+alo9IpcNzeku8buXRkYUE+et1wj4iQLxr4V6iSEGw+DCVJ0G
         HYBkCTX7JlZDPUkx011n/TdG08LYCjCOF8lsk5Bn6HL6snPP4Vp4Ar6zRNaqvBmJYvcn
         BuEU2qtncHuBU2/9muusyWQfYWl9YlC0aWMkuVTuo5VePsdZwOpLa+zL3RwjZrGf6wO3
         asi+GMBpTpgXt6Vv97acLBoKJVYoWfr8ZUXdRMYs743HedtQgVt00r4C0krmrrbPD5J5
         HHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792986272; x=1793591072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ty866em+IDE8Kl/ELzTlqPQgUH5LRJQ9LdrJwbbw3HI=;
        b=uhIZ/Z7EuHxIAKo0CyeOpmnTO95SAZ+xa4Pb7MkE62ioGRSA2spFdGwd1mKvxvG1ms
         KEDrzhjj9I4EzaeebF9DkYB790ccApAx+uiDBjSTqrm6DhBYc27zfI/fORnJ2UD/noDS
         pHi0aJvBRsY5cVychcHBBK5zsIcIqlw3C8G7ipSlxISQXjb+jDUllxE+xosjlxoF5Ibh
         kjrCEycg/4N51tBdLGAwt7y3ryAfZj3VRTfY9e77QXToXoFNeCQBt9tZlIOumcRc1KOW
         2thT/QWTSatKBEsduswOeA+swYbGN+9U88pP0rBt1jBv1kI/OF3y1q98bIOfvd6f2aZ4
         2Plw==
X-Gm-Message-State: AFq9FYJU93Dno0+vlOiw3gqORhLuFocOhFIZqqKEZQa5SMQTey59eJY1
	S7VPPlAFknEBnRSPub1oggjg0Cq6c8+IAVtZRKgg05C7ZEv2iLsUbyH3
X-Gm-Gg: AYBFou1IEHXsrevpw6rKAN/KRA1p2mzCUJSgEWu+VD+F//U80Bgp7TK2LHb3U35h3KF
	gf2cmSlsDw8Y8HvAykS9GC2J90MJpI5ieSRtF1j/sx4AaDX4TGVQaMPYqQurTL0me3cdyVPwEud
	LcNYvzdvvV+0OxgabYDnlFDSVSGAoEaWyhB7QLrcKUgG6iMcKAqPXN8bKOZFz6NKbFm5TdYruGI
	1S35cJgeVYJCNvZpKmdzJGbMtuTuMDBEm2e70Lr+3TzsI4YbD4HEMBPdF5CxfSgoFy+a7ZLcFYf
	hZqk6fC+PjYifEz6Y5q7ql4A3uILPL0V5gsixayMx5cFc6IW8PppQ4aUA26V/F9wa0shvLK6Rq4
	eL74CfrssoJmTBI0SFt0S2rF2/WkcuJgkRNvfyZNtENhMMSrjHHqNagxgC8vyAojIu6EhioAGlX
	1nLxGv/Ure1eaTVmpiBaam2IpmhxPLtuw+8VRiE6KjYd8gpQahi9pW/Mj8p0yoj146giA4wW7qa
	5q+RhfCz8TI7uKCPu2J29OxFaIopvIp4QgXJlyFLNP4y2s3JWpAdQzK6DLDee5TECe4xlOs4bpY
	jCGQiV7l7gCLMTaTaN7u9nZR2gy4GLA6e+9V04ou25M14y5TnqpSt1D1eeW3WlxEzqt/SKduMVy
	e0bvDMx8PXpI/rtrD58QILbH3Zw==
X-Received: by 2002:a05:690c:a046:b0:8b0:a28d:6450 with SMTP id 00721157ae682-8b166c2b953mr30228437b3.40.1792986271873;
        Sun, 25 Oct 2026 20:44:31 -0700 (PDT)
Received: from thinkpad.tail772c89.ts.net ([2607:fb91:1921:cd8f:7ac5:9c51:25fa:c9a5])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b166c5d619sm26623687b3.2.2026.10.25.20.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 20:44:31 -0700 (PDT)
From: Erwin Pawliczek <pawliczekerwin@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Lukas Wunner <lukas@wunner.de>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH] crypto: ecc - Randomize the initial Z in ecc_make_pub_key()
Date: Sun, 25 Oct 2026 22:44:29 -0500
Message-ID: <20261026034429.742489-1-pawliczekerwin@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928042641.307683-1-pawliczekerwin@gmail.com>
References: <20260928042641.307683-1-pawliczekerwin@gmail.com>
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

ecc_make_pub_key() calls ecc_point_mult() without an initial Z, so the
final Z, and therefore the input to vli_mod_inv(), is a deterministic
function of the private key. vli_mod_inv() is not constant time, so
key generation leaks information about the private key through its
running time.

crypto_ecdh_shared_secret() already passes a random initial Z, which
blinds the inversion input. Do the same in ecc_make_pub_key().

Key generation is used in the kernel by Bluetooth SMP and TPM2 HMAC
sessions, which generate ephemeral P-256 keys.

crypto_kpp_generate_public_key(), KVM guest on an i7-1165G7 (median
over 4 boots of the best of 9 runs of 300 calls):

    P-256:   744.9 us ->  753.2 us (+1.1%; within noise)
    P-384:  1674.2 us -> 1651.6 us (-1.4%; within noise)

Suggested-by: Ignat Korchagin <ignat@linux.win>
Signed-off-by: Erwin Pawliczek <pawliczekerwin@gmail.com>
---
Replaces "crypto: ecc - Use constant-time modular inversion in ecc_point_mult()":
https://lore.kernel.org/all/20260928042641.307683-1-pawliczekerwin@gmail.com/

 crypto/ecc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index c7366eb7ce1f..6696bf0d90a6 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1614,20 +1614,26 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 {
 	int ret = 0;
 	struct ecc_point *pk;
+	u64 rand_z[ECC_MAX_DIGITS];
+	unsigned int nbytes;
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
 
-	if (!private_key) {
+	if (!private_key || ndigits > ARRAY_SIZE(rand_z)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
+	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+
+	get_random_bytes(rand_z, nbytes);
+
 	pk = ecc_alloc_point(ndigits);
 	if (!pk) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	ecc_point_mult(pk, &curve->g, private_key, NULL, curve, ndigits);
+	ecc_point_mult(pk, &curve->g, private_key, rand_z, curve, ndigits);
 
 	/* SP800-56A rev 3 5.6.2.1.3 key check */
 	if (ecc_is_pubkey_valid_full(curve, pk)) {
@@ -1641,6 +1647,7 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 err_free_point:
 	ecc_free_point(pk);
 out:
+	memzero_explicit(rand_z, sizeof(rand_z));
 	return ret;
 }
 EXPORT_SYMBOL(ecc_make_pub_key);
-- 
2.53.0


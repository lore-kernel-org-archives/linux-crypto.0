Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6836A1E1A05;
	Mon, 10 Nov 2025 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790177; cv=none; b=S3FNpOjF8q7l8kJ8PBD7RsAu5JaWjGtSvG6UuY2kPjZ03MXnZ5Uiq3XcPdhNMZcx85ta26s8nUC8XOsgq/Vszdg2iIeA+hBzAhxVWjHpt7i9cb8+2K9bkuRpcM9qrtrdPMq/2KycYnESOPDf58Pgwscue9AjRTGkutrUeBYJkDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790177; c=relaxed/simple;
	bh=Evj+lOVrr01ab8zRTT97Wh3Dmv5xu2JkXAvwKz1JgQI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=cN4h8Yl3r/D1nu/3R5gAyYRPtXUiLpLd/S3URhV05D3daq2VN2c5BUpa4JAg2fzlJo2FDPKfU7Sb19dnb9j97gFcdBTWxv2LSWvSefUZ44ymSkpt0tQlNDNAlVBCwCimpyiz6B/fIzUEqqjyyQE5qZ5kxmAuOdA59L/L2ERg9N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=nlRoKtBs; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="nlRoKtBs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1762790173; x=1763394973; i=markus.elfring@web.de;
	bh=NyoRtKZMt3Y8HN4bgmHM+MGmoizriekNDriW1so/mFQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=nlRoKtBs2qflyusofjSBFQkf2PRupO9XIeTcfI88ZJc/o3PA0j2chqOCXYA7xGjB
	 9Vb8utV5A5vfI3jrnvpHH5qWln33LZhuMpG960R4v9GIv+LzlqKOdka7GlOZnkH4m
	 V76hRtR8dD0PjDEYe5U5HEsGeu7Ou/wb82tzZqHdoo1qbm5zHhlsH60XmHjQ0Q9GV
	 w+GFpTOHg1GK83x5dmkpQFSUuTcNgLDSN4pONLyHnUNOrFONKUYhADJRqrtKCBYep
	 U9tF6cChPE7lipAeNPhvHHBfhQlvaN/4w4UM1Evue2bVP3/gYUFfAQ3XRJH6rdB1l
	 0uA1uaEFq5kNewSxvg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.196]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mpl4z-1vzqLo1LMT-00gBDR; Mon, 10
 Nov 2025 16:56:13 +0100
Message-ID: <d9574f40-8d0f-4f14-bc9f-b29c56069b8b@web.de>
Date: Mon, 10 Nov 2025 16:56:10 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>, Neil Horman <nhorman@tuxdriver.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] crypto: rng - Combine two seq_printf() calls into one in
 crypto_rng_show()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8DsCZLSh6bLsiUFrFP8wn97UVCT9AK6f5n1hWN9Zd5QxNk/dQz2
 w0wdozaMANQl+v0R/ohLtDzAS09chGCiJMDuu+Qo4x3O9pAvq+Pabwqe8S3Zu9Wd/fLbAEl
 P2ksBzh8LXSILFBIpi6BfxXM2L30AW0OFSSveku06BZ+4HSnp5E1LHe0zW2r+Nrlug6gyWJ
 GDvE+n6oGzRfSkHLmFXnQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tl9rr/ktowk=;JNksCw1sDTrTeC0Vk5ej4osDsGd
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 10 Nov 2025 16:45:13 +0100

A bit of data was put into a sequence by two separate function calls.
Print the same data by a single function call instead.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 crypto/rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index ee1768c5a400..479c4ac6fb6c 100644
=2D-- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -81,8 +81,7 @@ static void crypto_rng_show(struct seq_file *m, struct c=
rypto_alg *alg)
 	__maybe_unused;
 static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 {
-	seq_printf(m, "type         : rng\n");
-	seq_printf(m, "seedsize     : %u\n", seedsize(alg));
+	seq_printf(m, "type         : rng\nseedsize     : %u\n", seedsize(alg));
 }
=20
 static const struct crypto_type crypto_rng_type =3D {
=2D-=20
2.51.1


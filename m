Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD2524E4A1;
	Wed, 17 Jun 2026 06:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781676214; cv=none; b=P8c2Ymjyd7N+geJ9Q3mmllumgqqOX47bvPR1NLvxszJlIyiwslw8f6Px3CGx6QSwKJulx5ujSBcZ8GRWHNq1FOD2TEeyA4cgGOhqzVMQKzLAROGC1IkrwGBVOpaAoSogLBQdPjpDbPj+N3b/9VXGzntHHdOUrjm7efJjD512uV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781676214; c=relaxed/simple;
	bh=VRyvh4HEMsjopkEc36whCxHTy8JjlBxCggJtwQCu3g4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=VhBjEepmJYfQedIYOYEUM7XZveqNNZ6umxZaiGbEqcsykcMYL2oFlB9Mg3MJQYNL3h9/nTieUL+zG2HQD9wBV/tKFgOBn/6OgeMR76lD4NUYuy+fRjuG+898jL2b6a7pXX01okjy0ZIGr8Uufb7MYef+dUUciy8CjVb9oevxWKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=vjf3WtqI; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="vjf3WtqI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1781676210; x=1782281010; i=markus.elfring@web.de;
	bh=CfEs8mA62c19rsERwIA2elxLEVbA+aXziSXTRo5lGzE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=vjf3WtqI1nUxmDzVvEST2EqUGA4W5jpihuNFSxX18/k8XOkPgIox3mtuq3eUcNTw
	 LJKXX2joML8gzb2zMDMk5+daDmHN7Fj5DK7Vho4/hWcnO40KyMQl99q/ETLj4OZJw
	 VcUs8eBxsZp6fD978aVWvlYxJcJfBJ7r5bUUsenNLOXZQ+E3fTYealp8+qhFdofKL
	 BfDTXq8tVT1wnZwTqScM608zgy134QyAg+TkG4W+dHSQqtP8F2xo8CEdnKx2pJWRk
	 kvEYGZxkoRfSxYDTaR+gpnzJ+c4eViks/qqsBTLV3p79nNCRwJ1/hlnxsihP4M9px
	 PearLPIIHX6eFLNgvQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N79RG-1xGmIY21fQ-016I54; Wed, 17
 Jun 2026 08:03:30 +0200
Message-ID: <e6aa4d9d-fe05-481c-be31-17033a60dc4c@web.de>
Date: Wed, 17 Jun 2026 08:03:11 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>, John Garry
 <john.garry@huawei.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Kees Cook <kees@kernel.org>, Thomas Fourier <fourier.thomas@gmail.com>,
 Thorsten Blum <thorsten.blum@linux.dev>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] crypto: hisilicon - Use more common code in
 sec_alg_skcipher_crypto()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Q0XNYJE7wI/mNB1lbN24Rhi6X7AL2wscDVkEt++ONz0zQuCcQf3
 JoVNO478Ff1GNofFg3GubSmNLY7Bokuba8rW4OZwD3EzhdBsYDLYguxoOyoAGOvBmA9YS+B
 oAMQ2rTqtrui+w8rND87rjBoSiljCOAVre7MJeOV/xEN5Gt7HXMp+a+xEUXbkBScOhdk3/M
 zzSJVRtWcVnqRRKeYiMDw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:9HVmIF9BHJ0=;z+jwUZGDQ7g/jmg//dDNQLU3idj
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 17 Jun 2026 07:51:26 +0200

Move a label so that a bit of common code can be better reused at the end
of this function implementation.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/crypto/hisilicon/sec/sec_algs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisi=
licon/sec/sec_algs.c
index 85eecbb40e7e..024fe1001875 100644
=2D-- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -833,6 +833,7 @@ static int sec_alg_skcipher_crypto(struct skcipher_req=
uest *skreq,
 	kfree(splits_in);
 	kfree(splits_out_nents);
 	kfree(splits_out);
+err_free_split_sizes:
 	kfree(split_sizes);
 	return ret;
=20
@@ -853,10 +854,7 @@ static int sec_alg_skcipher_crypto(struct skcipher_re=
quest *skreq,
 err_unmap_in_sg:
 	sec_unmap_sg_on_err(skreq->src, steps, splits_in, splits_in_nents,
 			    sec_req->len_in, info->dev);
-err_free_split_sizes:
-	kfree(split_sizes);
-
-	return ret;
+	goto err_free_split_sizes;
 }
=20
 static int sec_alg_skcipher_encrypt(struct skcipher_request *req)
=2D-=20
2.54.0


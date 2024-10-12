Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA7D13B293;
	Sat, 12 Oct 2024 08:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728720476; cv=none; b=UqGsduAp8l0VRnHErgPGFecItopwafpgF5rLsoi8ZwIAa/ov+1jZ7WbTmLmdbifFQZdIkNNQgdLgEF0bCHs5lTrpuZSMgv6MCjePk7f9R8SCB/GsEVzvY9ua6apmDxKcn4jchl6st0jc5egxf9mgY6rajfHxkwvt31SE7+JGWXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728720476; c=relaxed/simple;
	bh=4OUtu+vUuFaklY8yFeTodT21IWQw/RcD0nuI88CgJ/U=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=SddnioeR65lCQQGFgTlgo9IcwsAOjHa4sgo5y37xQkm09oqAw+BrLn84WNtLuz0/OcHNpCHrw3DlCyGiVlBquFElrKetJwIRPX+aUlwGvmYENJs9IqTlQMA0GSa67Mog7rvfXo8PMlBp/Pal+fbZK8rRS2Pwwv86Zvov6F+ANpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=hSiOQwCe; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="hSiOQwCe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728720416; x=1729325216; i=markus.elfring@web.de;
	bh=dwS/0fwcxAGtAx0RykHa0uJRLJTggRpPoKajc9AhU6w=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=hSiOQwCejPDHvmE1YFkYsYsNPlmS+A1tW6uSWS7e8Iq0vqrRWFy1B/kAcNn6fBXG
	 7uFOkOjIFctsFPXBdky4zSHbsJJQKfpwzCe3sBgwrzGN1rwbdEClwx0WcZDYFpyr/
	 tO6gC+yKS4PFK7PcyEGhl8Qurzjwhk87ZoejwTm1fVI2kgguIW7pcpUt9YQHbZz+N
	 wdSUg3TuAgVUlFupwJ38QbhSZm0l2kHrp00yn45XC1mZE4NCGGxHlQmpUz0qmw/EQ
	 5qUhmM7KZ5vyH5mvhNArHCCItJtbNmQOoLcNysD3pn3600TMQSrtd2I0aP2S+/l7w
	 ecRLFXNzO6ygnwt5Ng==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.89.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MMXx5-1tI1NH3M07-00Nmir; Sat, 12
 Oct 2024 10:06:56 +0200
Message-ID: <80b91321-138c-41de-95c7-47c3be07fe76@web.de>
Date: Sat, 12 Oct 2024 10:06:37 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Gonglei <arei.gonglei@huawei.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>,
 lei he <helei.sig11@bytedance.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Nathan Chancellor <nathan@kernel.org>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, zhenwei pi <pizhenwei@bytedance.com>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] crypto: virtio/akcipher - Move a pointer assignment in
 virtio_crypto_rsa_set_key()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:e9XQu3txqQMuk28YeVMcyqRiUe/NNPOYOcQnwtnCHuei9Kr5xRO
 1MyDfaBl8Zqwnf6mw/mIsZ4X2+s+7IMMAmvO2uxRazyGJwblRH5jcf2mLiXmvWiHg0A3K+A
 a9AaiZ6U2F8FLtLNNS0QMtB/BbHXS2HeSHigrX1O29koDpgsE7YeGqk9QbgBWLKVr6mlvdY
 XMj4/KRaM80yAYI0xB+lg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:IOMWIyk3DyY=;rIoHG5fyZ8z5zYh5RR9bCEfM5d6
 TV60ICniC71FnE+95KeOAYnbBZR9oeoLP+ws9hbT/qaVe8yai+dhWgbcEzYr9/rLzu7kmEA8U
 8Lv7DVWtygTmTtJ1nlenjh3FXh3xkv+G5xLwI2zh3PWe+YIDAHUx3l6sU9S5kBt2IXfWz/K1U
 wpMHpoqt8/bV5H4j8ySYCWKvszjdiltqyPmyQCGm6ZYqYiQYfKIHEo38MjAAlLEnUChUDGDqy
 qV9/vrvv6AOoLG2c9wmOCY44w/L6psWJJ2mVeqV3XFISViy+qAF0+4XvuQcrmkg2zSpRD1U+P
 ulLkA3Jr8csXpHDYUObS8RE7eqBoGFwJ60UCVFC0nqTHUMtjgReLaF38UaJjADf6bJpjrnl0F
 sN/bPeyGm1u/ukhwikVGGFLKABsnxQylL2qVO6PWPWi/c4XDT7HVqSkDEzoXRy+OCDEhxgsEl
 IJjGT2IDeu21TyIQLbVDypvszjUxnawPM7e0w/Jyijs8Lp8kAQd/Tm/ZH+7jqIqgMs1oA6Wd0
 hFHV/GcHbHwB/tXhVJLRshPUL9e6pFPcUO0z3gmL4edExFvusYt3ZKymIJbl8zwonnSPk2dQB
 4JoZA2f5K1e11NkDMzLM76TKqdYSU6MeQPaZIpwUI0JNaIM+N10DWy7WNl99KZDvImk6QAL0n
 maY2hIK15Oou5nLAXRpBi78Fc4WPdpFROJSh22mv48B7dMHBMy6DywmfRrLRl7YVjRseGRCJZ
 +YZKbhkYjdjd9qimeUQICwxT4FVDnGgnK4XFowlWTaRE4WaEUSUxH+M+Cuzci5sKWbTZQ1CVS
 YFdI13IS90LB7iH0WIOo1/MA==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 12 Oct 2024 09:51:58 +0200

Move the reset of the data structure member =E2=80=9Cn=E2=80=9D to a null =
pointer
into an if branch so that this assignment will be performed only after
a key parsing failure.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers=
/crypto/virtio/virtio_crypto_akcipher_algs.c
index 48fee07b7e51..56557d4778b0 100644
=2D-- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -355,7 +355,6 @@ static int virtio_crypto_rsa_set_key(struct crypto_akc=
ipher *tfm,

 	/* mpi_free will test n, just free it. */
 	mpi_free(rsa_ctx->n);
-	rsa_ctx->n =3D NULL;

 	if (private) {
 		keytype =3D VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE;
@@ -365,8 +364,10 @@ static int virtio_crypto_rsa_set_key(struct crypto_ak=
cipher *tfm,
 		ret =3D rsa_parse_pub_key(&rsa_key, key, keylen);
 	}

-	if (ret)
+	if (ret) {
+		rsa_ctx->n =3D NULL;
 		return ret;
+	}

 	rsa_ctx->n =3D mpi_read_raw_data(rsa_key.n, rsa_key.n_sz);
 	if (!rsa_ctx->n)
=2D-
2.46.1


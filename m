Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795024324;
	b=3GnljN+KOKtDXt/JXx89G9hV5ZQXt3/4J4hq1Z2IgZRPsbg2eGg1yThs+ge+vqq1b8Sk
	 +yxGNTdCj4ZoLOiVCo1va1k/pyxEsysoWIxHp4CZMafBtFnujBURgrK2LvQLLcC8lzJif
	 VCtJAPXUU1YX6WYICgJ9WwPy7Xf4eP81H0E6K71wrQM11q5KGLiMWTEbZwBxaWBNEByM7
	 aFmzl8w6mlZDeyhQLTQS1CBRgADDHD8yJEaEgdia4ddojxsRz92KfDL2O2Kz3E6jWL/ND
	 +XJYoQEYuiN4+z7p3vM1NTSVbNGL8KJdpeIFGu76biVV9iDk0xOFz1Gu5uKvMJvNYQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024324;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dNzk52VvT+ieD7HHNJgyt12mlMnxt57ONA25ZqvsUgs=;
	b=hJyrM8EKbAyd65Qko7lHRc9eT+J67f5+wHwgSlDmApG/Nih33p01PiQ7ay438Y2qWvd4
	 KwRfA5p0H5ejqcDkjM+VpItfvBh3sjgvMQKFSh5pacx5autl/W0TEXNrz8mPvshhRWUCN
	 0xlAZRCtEv3YyCce+jOoPfKbXexfJqy+RLkm4aOBjp7kujgY+SKQ9Ib3W86J3DA4D6WKp
	 IQ+TkPuGX1XpzszUJ7tJ3sR9lSa52NuZnV3x3INcK/p/ydfUsgEZ2QdZFVb24ODAWdQEV
	 2LhMm9C+l2DEYp4PMw/x8R9gE1VWjeS1uwfkqi5yliI8eBhtjG6cS7644HD0Wkf1rew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cXpYSHKB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AFF60A2610;
	Wed, 18 Nov 2026 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cXpYSHKB
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795024324;
	b=cEE7nXWyfjhdkXwlLTLCewpIlfVbnQBLav8WHjCR/wzjHQYqGDil1ChE2HAPJTsx8RTK
	 +8vgNJ4l7g67Uaprpqu0ZN1q97abZ7Gw01dcT3xmbDwxYDrkMchnPhkpgVSZ2rx3Ki0O5
	 +XnxtGwL521Pl8cRV8Br3tLsi+rMURGYtC59Af9yKEuT5krrsZFZi3KJm5KnzWKQ/xEfD
	 4KVzydq2o0oMzZSkwXbwldRksnhZ4jscz3x1ari59wMBOLjeUeUZ1Ev6LCar+IGN/Wvft
	 PvVYWya9CVC+NYil6VJsekdxHAbw162+W6A6LAPcXPKJcW/qj8/Zh8VZ+F0w1Q/t+kw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795024324;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dNzk52VvT+ieD7HHNJgyt12mlMnxt57ONA25ZqvsUgs=;
	b=L2wQhMjfkf+rv/7BKUfaR9BpvVtk+A+FU17BwjGfG7DWoiQi8TM1Nyd918GkXVqaSWGo
	 mEqRzPJhkaoKqz1jKZAgb5Aver9v5JVYSQh3/vvfNa4mj8z5vU0DslyMfv5XQv5Nq5mGC
	 N/aQpR6MWA86Wip4ebB5cBlM09OS5kH39Cx+ncEd9ZHVZ18CZ1jaDua5snhN0GKEFFFFc
	 W2C7IppUeIoAfRs3ikADamjTtzJrIFctheIxhAFB7WhL0xTEjMY/W+Z5CesqV4MEqldWJ
	 CTCMPJhLpYPbiGfYH8Bp/yaZNXgFTvZWKdtW063xq54SirHzN33O2Mc1so9ktDtO3Bw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9505C1F000C4;
	Wed, 18 Nov 2026 17:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024324;
	bh=dNzk52VvT+ieD7HHNJgyt12mlMnxt57ONA25ZqvsUgs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cXpYSHKBI4173ghw+UBA3l2wr98BLeDcGlLblT2fJfPSDOcOPelrVRrmyDN1YcLvx
	 1qRtvt/Ss7txwoax2+DcuB5w3S+NneFEnEsEn5iCRwXvlQFV4x3GgOrPNPPrBszZfT
	 iMPl81RKSOKWbFcQmhrAiJ5PzwJW4KeSTAUQN/Lzl/tloS+Or1D6NmKG7yR1DDvBTb
	 xIopLyNoTQNupKx8U34h7epEmfA6t17caLUc7X4jiWqDcpFF7jJXhk3pmE8IL/tleg
	 ioNtgRi+9FLH9Rd+cdP/NoFFFYH0Ngp3xdYekzBX7s3ugZTSar2y+7AF1+lgF9+yrF
	 tu2hYisKHfz0A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0FEF04AF19;
	Wed, 18 Nov 2026 17:52:02 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Date: Wed, 18 Nov 2026 09:51:49 -0800
Subject: [PATCH v9 5/5] MAINTAINERS: add Rambus CryptoManager Hub (CMH)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261118-cmh-b4-a-v9-v9-5-70385613fd50@rambus.com>
References: <20261118-cmh-b4-a-v9-v9-0-70385613fd50@rambus.com>
In-Reply-To: <20261118-cmh-b4-a-v9-v9-0-70385613fd50@rambus.com>
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>, 
 Joel Wittenauer <Joel.Wittenauer@cryptography.com>, 
 Thi Nguyen <thin@rambus.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 Alex Ousherovitch <aousherovitch@rambus.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795024320; l=1310;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=Bd9aCgWNbaQADX7NBB116ORW6UoH7r2h1um/oYEgcMw=;
 b=aMkbvYg2CRZOnVRGQj4fqUUprtTxk8fyFbQvY2SxqdwDuDzXvvU1bm6CNjWpvV8mrXCGwNIJa
 x+NxxwmhH94AhK146L69aFyQJG8VfVD+wywgERp5yPzAhLFHr5dXNlR
X-Developer-Key: i=aousherovitch@rambus.com; a=ed25519;
 pk=ECFtTdQUPAolK+qGZ6v7Xm3sRf7rnM7wxpTeFzbqpmA=
X-Endpoint-Received: by B4 Relay for aousherovitch@rambus.com/20261026 with
 auth_id=1330
X-Original-From: Alex Ousherovitch <aousherovitch@rambus.com>
Reply-To: aousherovitch@rambus.com
Content-Transfer-Encoding: 7bit

From: Alex Ousherovitch <aousherovitch@rambus.com>

Add MAINTAINERS entry for the Rambus CryptoManager Hub (CMH) hardware
crypto accelerator driver under drivers/crypto/cmh/.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..0dc921a090ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23305,6 +23305,19 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/ralink/
 
+RAMBUS CRYPTOMANAGER HUB (CMH) HARDWARE CRYPTO ACCELERATOR
+M:	Alex Ousherovitch <aousherovitch@rambus.com>
+M:	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
+R:	Joel Wittenauer <Joel.Wittenauer@cryptography.com>
+R:	Thi Nguyen <thin@rambus.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	Documentation/ABI/testing/debugfs-driver-cmh
+F:	Documentation/ABI/testing/sysfs-driver-cmh
+F:	Documentation/crypto/device_drivers/cmh.rst
+F:	Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
+F:	drivers/crypto/cmh/
+
 RAMDISK RAM BLOCK DEVICE DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
 S:	Maintained

-- 
2.43.7



Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794329562;
	b=wJ5yHW4TZebgXBHt1bEtFu6KnSXbfLu0hIzbLGhkBr7zTU+bz+BkEAWi6xXlVvovzDrB
	 bfJb6V2TsOIEqgNFkTO6nzPk7eYy+Gab3sCEFO3cXwVFOP7AGomODXk44QAtXlPId4Zl2
	 88SwgrcO39/S156WxZNjh8qyTC/MnD42hWdkZw5PjW3LKci3y/+J2NH2CEoRtK+TcCtmT
	 fu7pUQ4xIqDZBfeB/0FPLF09+T34SnN3xvohH1ujvnWedox/aXHPNSWK+adNCiiiu48UM
	 gqdfM1GUSrBQDeS99oUkv+B39COeEemvPc2/D7edlC8kDBiEBqgjuR1auqaLFbpRu6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329562;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dNzk52VvT+ieD7HHNJgyt12mlMnxt57ONA25ZqvsUgs=;
	b=b3lfpJfLoAXk6k/hFDWaOY2sL3IYB1JieZeriPYJQAfBHO9blzFPr92T6uxOkBnF90VA
	 A8n/k0TQBYtwspfpBUgI7MJzF/jzyB2uYCBC2kfgyks3dUSbB1kQkbYj7CL1yGv7wiin7
	 jksOBenc8DB1kJe0nU156rdkDnsCqJ5tVTE/N5+m20uWQ5aYq2TMvTI1i8M+WVYzqomrS
	 kjf1clfT9q+/nrPySR7p885TrzgWY+Ii7ttZvIiRz+ehWsdsg+mJc8Is5BMIlSekheg6f
	 PgOXhB8EwVG3f1sX7cBKJ6G8aXFfN8sKYJoVOkuSh+WFs8MEPlVQxh18tZvQ+pCUdNg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jyTxnwmo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C8060A2612;
	Tue, 10 Nov 2026 16:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jyTxnwmo
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794329561;
	b=yLL8DART/tnNyfrGeUlu12Al1pc07Us0USmp+3wsJ+RLgo2qgX7kk+ShYSWshNLRDdmG
	 fzv14H1nfhEQ8Cw/QeQemHbHDes9jE5ZUI1r+lCpRGIAWTpEJpuMEtmh1wV4vTvsPtUQX
	 g/noSP7iNh6gRp7S7893xOxCDCzgjj+hd6Af/hhZq37lmWZB1wCJ3gnCIebyid2ZVx+Yv
	 P/ymrgImb/+3ZKNIPm1Ooj5wX59vPVxbcBH8liVbM1d9WIVXnyY4mGBHXXmKHDTvk1AUr
	 SasFVjz+gPPakXX24xbm58z52fdB3/gWGdc6oyuv9NSqHqTxKGyWr2cWIvtyCb3sXpw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794329561;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dNzk52VvT+ieD7HHNJgyt12mlMnxt57ONA25ZqvsUgs=;
	b=frLox7nHBOvDceXhsmIY+4p1k8KO/AAOT+XM2MbsnwqBm1o25pWJNA9eE/VZp7yqJOaa
	 g5SDbYdCqe5zpTldl7Ae3V3hz5CrCwU4hLUahxGirVcpej27ajxEq+RiLY3TU2w9gBDsW
	 vmG9g0NBb0LNKqUvTiPLZdgnYr1XA2XO0UD7hzXAeXnf999KGAav8EhprVBjQlgTjZU/F
	 O8G3vX/UwXPkZNY8RlrJ12NJ1fOEP2C5oAzhbFhN6MamR5R/6v3C2M5NW/BCtFvTSzyOk
	 /cWLtjozUgDmswY1lrzFzf9AqJWC+EOPKjQamec4AkLHxPRDayCsk51FZrL3ARIiWBw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F400B1F008A7;
	Tue, 10 Nov 2026 16:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329561;
	bh=dNzk52VvT+ieD7HHNJgyt12mlMnxt57ONA25ZqvsUgs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=jyTxnwmoLlPOuZ9tEDKdLeKoNRIHJXWQ9cPVom8fCVM55O5fsppbA+gafMYW8CJ7u
	 W0O0JemKHxQG6FTfU5IdE3CSdhxUrPmr1BQKu+RsUoxBXobGKUlREzI6qEuqmTSiyl
	 9LhIC0sOR2zUjQ06etCUJqZJmiXQcm9jtXtVm23wnP4hL43ZMwd0vMEEW58LzDT5eP
	 +WfiPohNk+8gtH2WuAPipJcMfgAWngnSMk+DpWjeZ10D7qyC6fKDkxW8/tMAE0l8NV
	 MAYfgV5mCEhyeapnfr+QS9xmf0qkeT8UDbPOWWZnVdBGDEvE1c8rNUBARz1MSdZOCs
	 /Mvt6CnASTwpw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8961648C1E;
	Tue, 10 Nov 2026 16:52:38 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Date: Tue, 10 Nov 2026 08:52:31 -0800
Subject: [PATCH v8 5/5] MAINTAINERS: add Rambus CryptoManager Hub (CMH)
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
Message-Id: <20261110-cmh-b4-a-v8-v8-5-4cea8ebc1d40@rambus.com>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
In-Reply-To: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794329557; l=1310;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=Bd9aCgWNbaQADX7NBB116ORW6UoH7r2h1um/oYEgcMw=;
 b=nO90tJhXY6S1PtQe/PK8Kdy1Wpn5+UM55CWJzXecGinv5ZsAsVrvlzhqXx3EFf476dViQWDkG
 sTztDp6V4e6CkVuz/wgD7JW2J9bZDuiYnjaQl3dYAnIsefR4IqNluMg
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



Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8637351C2F
	for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2026 19:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787081495; cv=none; b=WfljoagyMszAwR8ClkeiZ9oMdxBCmvDXVdW0fVaLnE/9Q1poZ1AnL761/k7rSUmV9e91ngkHilmkMcqUy9L/RFJJSN8oYfYTdo+E517YfB7EYhwo6aQ+PFukrmjqe4XZtqV1MgCJj3a0LF1LdvNslRLSsaLlnRRGyJrqhKz3pGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787081495; c=relaxed/simple;
	bh=KuHVOtgAyVTI30yETpi1bRiv97yNEu22SQQ8ZK98dIo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=T+GLr5eEcigbIZZ59Uzfm9Wyw+b4FPtXpw65pNe0boFlOvJxFTR+ig1X0um+u7B7DDDgO1UCDIxEIm9eOE/Vyeo+zm8ZVc2sqvOddVOjro+NAZHP5GJeOWXoPJfkuohv1RkZgqNWoRKOoWY5dRWGLxfTkOY7CB94xmTGO4lBQOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=JGclCxFE; arc=none smtp.client-ip=95.215.58.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="JGclCxFE"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KuHVOtgAyVTI30yETpi1bRiv97yNEu22SQQ8ZK98dIo=;
 c=simple/simple; d=cknow-tech.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787081488; v=1; x=1787686288;
 b=JGclCxFE7I3H3HH3bc6M2D4nO51BDCeo/9bbvGyocLr4t29kvcs7Z/TDjny8o6Cfkkk3yjUO
 ZWI9E0UQn/w0L/bIwjxskMpOxAKJYNWExW01bJbZGMjzwfA8jx86H0jgSIGGiXMI0KsI6Kez8F8
 yZxfTYCaPqXN0wEQQm6qToCChjgfZC3J/+FWen/oySaBqNZN1rqwuq3bDB4lqOj2Jcc6VNA8MTV
 +y6oxeVHtHXUF/EIMwuDzw3N25BVKuQuoUvNae0XBtfwAtMrs2lE5g4DyNgoRigs0pNycOGdfv9
 1QavuwJlyAEVALKfd45Pc5I+8YLR9h7+7oovUMBGtYvVA==
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (92.254.112.55)
	by smtp.migadu.com with ESMTPS id b14261f1e4059e70;
	Tue, 18 Aug 2026 19:31:18 +0000
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Aug 2026 21:31:17 +0200
Message-Id: <DKSBIH29Z9DE.1OR442P0XUSCS@cknow-tech.com>
Cc: "Dawid Olesinski" <dawidro@gmail.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 "Rob Herring" <robh@kernel.org>, "Krzysztof Kozlowski"
 <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Heiko
 Stuebner" <heiko@sntech.de>, "Corentin Labbe" <clabbe@baylibre.com>,
 <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>,
 <linux-rockchip@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] crypto: rockchip: Add RK356x/RK3588
 cryptographic offloader
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: "Eric Biggers" <ebiggers@kernel.org>, "Diederik de Haas"
 <diederik@cknow-tech.com>
X-Mailer: aerc 0.22.0-9-ge948bb7230f4
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <DKF8V3IHKTL2.1PUA8O5IVIRYC@cknow-tech.com> <20260818185810.GA7030@quark>
In-Reply-To: <20260818185810.GA7030@quark>

On Tue Aug 18, 2026 at 8:58 PM CEST, Eric Biggers wrote:
> On Mon, Aug 03, 2026 at 12:42:03PM +0200, Diederik de Haas wrote:
>> crypto-rk3566-test-no-crypto-module-log.txt:
>> https://paste.sr.ht/~diederik/bb5dbfd59f244a6422b965b30f9796ebbfdb1fcb
>> crypto-rk3566-test-with-crypto-module-log.txt:
>> https://paste.sr.ht/~diederik/ea72297678e19cbbc987de9548f9884382e1d1cc
>> crypto-rk3568-test-no-crypto-module-log.txt:
>> https://paste.sr.ht/~diederik/309e519e6b1c31f4c1c5bcb1ea16cc8569a54830
>> crypto-rk3568-test-with-crypto-module-log.txt:
>> https://paste.sr.ht/~diederik/1e1e938ebbbae75128974fe0a7c240843bce04c8
>> crypto-rk3588-test-no-crypto-module-log.txt:
>> https://paste.sr.ht/~diederik/9a2adc2b2e42131445ce4576589e00ecf51ccb4b
>> crypto-rk3588-test-with-crypto-module-log.txt:
>> https://paste.sr.ht/~diederik/e04c11c8809031ca45662f7d4c227c1ba6162b65
>
> Thanks for running some benchmarks!
>
> Looking at your results for rk3566 for example, SHA-256 on 4096-byte
> blocks is 115 cycles/operation for sha256-lib (i.e. ARMv8 CE) or 3027
> cycles/operation for rk2-sha256.  So the Rockchip driver is 26 times
> slower than simply using the existing well-tested CPU-based code.

I shared the results because:
1) I figured it might be useful to have these numbers
2) I didn't know how to interpret the results.

Because a lower cycles/operations would IMO *logically* be better and
your response above seems to confirm that.

Which makes the following results a 'bit' concerning?
``modprobe tcrypt mode=3D404``

[255753.686837] tcrypt: testing speed of async sha256 (sha256-lib)
[255753.686841] tcrypt: test  0 (   16 byte blocks,   16 bytes per update, =
  1 updates):    703 cycles/operation,   43 cycles/byte
[255753.686848] tcrypt: test  1 (   64 byte blocks,   16 bytes per update, =
  4 updates):   1101 cycles/operation,   17 cycles/byte
[255753.686856] tcrypt: test  2 (   64 byte blocks,   64 bytes per update, =
  1 updates):    869 cycles/operation,   13 cycles/byte
[255753.686861] tcrypt: test  3 (  256 byte blocks,   16 bytes per update, =
 16 updates):   1676 cycles/operation,    6 cycles/byte
[255753.686871] tcrypt: test  4 (  256 byte blocks,   64 bytes per update, =
  4 updates):   1059 cycles/operation,    4 cycles/byte
[255753.686877] tcrypt: test  5 (  256 byte blocks,  256 bytes per update, =
  1 updates):   1249 cycles/operation,    4 cycles/byte
[255753.686884] tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update, =
 64 updates):   4156 cycles/operation,    4 cycles/byte
[255753.686904] tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update, =
  4 updates):   1054 cycles/operation,    1 cycles/byte
[255753.686911] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update, =
  1 updates):   2826 cycles/operation,    2 cycles/byte
[255753.686923] tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, =
128 updates):   7438 cycles/operation,    3 cycles/byte
[255753.686957] tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update, =
  8 updates):   1263 cycles/operation,    0 cycles/byte
[255753.686966] tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update, =
  2 updates):    940 cycles/operation,    0 cycles/byte
[255753.686973] tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update, =
  1 updates):   4887 cycles/operation,    2 cycles/byte
[255753.686991] tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, =
256 updates):  14017 cycles/operation,    3 cycles/byte
[255753.687054] tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update, =
 16 updates):   1681 cycles/operation,    0 cycles/byte
[255753.687065] tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update, =
  4 updates):   1059 cycles/operation,    0 cycles/byte
[255753.687074] tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update, =
  1 updates):   9044 cycles/operation,    2 cycles/byte
[255753.687105] tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, =
512 updates):  27155 cycles/operation,    3 cycles/byte
[255753.687224] tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update, =
 32 updates):   2489 cycles/operation,    0 cycles/byte
[255753.687241] tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update, =
  8 updates):   1268 cycles/operation,    0 cycles/byte
[255753.687253] tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update, =
  2 updates):    959 cycles/operation,    0 cycles/byte
[255753.687263] tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update, =
  1 updates):  17812 cycles/operation,    2 cycles/byte

This is on my AMD Ryzen 7 5800X which I would've expected to blow
a simple RK3566 SBC out of the water ... :-/

> Don't you love "accelerators" that make things 26 times slower?
>
> I guess we'll get the usual argument that this driver is really just for
> "testing" or whatever.

Or someone spend a significant time implementing it trying to improve and
extend SoC support in good faith, but without your insight.=20
Which is 'coincidentally' the exact reason why I suggested the patch series
author to explicitly put you in To or CC.
I would not have used "pushing the driver as a checkbox feature" as argumen=
t.
Especially since, apparently, the numbers show it performs poorly.

My 0.02

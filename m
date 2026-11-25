Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795650211;
	b=guc3bWreY8bk8fHbGs1Kq6GW8Nb9Cueb6Iohjw9xgRpmVllYo1ymPJm2aVd3F1FuyCZd
	 L+E3iE/GwlEku0KSuno2q1nnL9DHN1gFfpATYfkOewr5mQeINrm/8gbDeqsy3OSB/Ctmf
	 POoq2ObBW+2Rw7Zbm0Otpa5zjQqao4QVUzlf8kHyi/pEga9jK2AjNMKx0OIDghNoIGxL9
	 9M6oRaiugOUrEqDa07X6Xu69jc7HfMa24fJDKvgg949Ka3uZdMTBpVLlM1QEJ3EJftNVB
	 hngY2BukGBwfp1Yq1J3zjFyAfie3Ax29+sN+N3rbvHxeJrgSixoWZAll3uoIgDQAcgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795650211;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=oKSnt8gA2Fy+R/UYvUgzl3Tn/GEe05bs1oSii6h9IUM=;
	b=DtkRyFDXH1S/nX2D+ETI/w1CgV1p04mwDNRv6XDXKiY/wP1nY7D1nElBw2y1wOMhHOG5
	 hz+kbZckQX/t67jMzfr6osPXI+fzv5mMqq89aru1CLQ7mZXkopSy31O+xK9AWWwz2mI9I
	 K23p1Iyrw6a1kcOp6SZCAkRZ3huxTZ0y4ApyIsci4IWFwYmk+cbJP2XYsnvu26zrZj7av
	 VGj+9G9HmIjVBbTEY0FJi9WeetTfRZcveZOjhro30jcmTxUziexw7PehVbduCNH64+d7z
	 YNODzUGH8yZWj3pcX/rl+sG07qqlCsoVQlHmbTCKIpUelytwa8vzUy9sR5hSQNQh2pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=IvllxDAl;
	arc=none smtp.remote-ip=109.224.244.123
Received: from mail-244123.protonmail.ch (mail-244123.protonmail.ch [109.224.244.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61628606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 23:43:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61628606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=IvllxDAl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795650209; x=1795909409;
	bh=oKSnt8gA2Fy+R/UYvUgzl3Tn/GEe05bs1oSii6h9IUM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=IvllxDAlLoCqOpxVVj2YInn/EAQH+B2+Ze1U4B8jpnrovnETxgFcKK7LQc+Juyl5e
	 18jT4kesNk76YyoznORIQM2iIBMfejlg5fmQTExSHQa9Kx+YIxgiPUjNED9WHLSaqn
	 hsnE28mmCpnyTjrK86mZmRmI7Ut1DOMInYW9rBecfXQj0cuI5t/VpxPqHbqZ0oDeF9
	 lsqb5wEJkcVl8BNQTEo05SKSfXVdk42BmJ18tOGTDOqzd7+l5T9UQHR4K0RoGqQ13C
	 TJPvATvmPo57EKdzVzBqmSeRWxZTmUddcU4Is1IAZozPRs/5EZyLjdBOb5p+rueYi6
	 IYvziNGbS+eIQ==
Date: Wed, 25 Nov 2026 23:43:23 +0000
To: Zhiqi Song <songzhiqi1@huawei.com>, Longfang Liu <liulongfang@huawei.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] crypto: hisilicon/hpre - fix missing DH/ECDH public key validation
Message-ID: <20261125234311.1860032-1-rc4d5a@protonmail.com>
In-Reply-To: <20261125231929.1857637-1-rc4d5a@protonmail.com>
References: <20261125231929.1857637-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: a7b2ec0eb878d7b75eb8e3b555084c0faea4f59e
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Confirmed -- this is expected, and the fix isn't a code change.

This patch depends on a separately-sent patch, "crypto: dh - add
shared DH public key range check" (Message-ID
<20261125231825.1857253-1-rc4d5a@protonmail.com>), which adds
crypto_dh_pubkey_in_range() to crypto/dh_helper.c and declares it in
dh.h. That patch needs to be applied first; this one was never meant
to build on its own without it, which is exactly the build failure
reported above.

Apologies for not making that dependency something the build tooling
could see -- the commit message notes it in prose, but that doesn't
help an automated check applying this patch in isolation. I'll send
any future multi-patch dependency as a linked series instead.


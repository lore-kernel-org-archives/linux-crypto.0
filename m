Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795449292;
	b=aiFO8qd07IG2S329JUqZz0CSg5fN2AKsE79CqpUKGCbmDgb8Joz5FI172zjvrW/HsK2F
	 gMrdJlVdIzPhlfqiTBHR3Uaekj9l41yeMp5DO7sDGccN4dzLBaLBSHuls3xn5+MoBZHBM
	 cuDFAlTbUcBrUxms2D7DF9M9cDc5foa5RYbgMgqdm1pViVWqmtPya3NWgbQpTWGZX5oSH
	 Au2tkeq+3L2YWyC/Vl61+j4b11v210UaGhc0iBVwbgImNJ4JM3mpwXo4bcYZo/aCft4GF
	 rSpHqCi8YWPWJb6jMR0nBByEFyMUwAzq6zz1+bOmb0kaNPsxl/fXGvKNNCBs3kHbSSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795449292;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XReu0ZKCor2qvQSwwYtS2+JUKrtwYf/w6vLmesHfbts=;
	b=ffEVZn7h8Z9Qal79BRWpcqu31pgUSOayBxWw8DH01gm+g9aQc0NJg+89xBmJwKK0q0rz
	 eq1KBVLLE/XfV7GFAiFm8EJNaHoLuhsfyBoDjjBux5DGbW0hYtZQsj147zfvCPnZIGqnZ
	 2KRFhAorEEtSgXFlTh1ITHk3PTWXwHONxtl350Sq2rWKFqMMxamJpVAM3RIjP+VPXX0T9
	 DEbvARjdvII6nG5zimGXMJNbR+5WkR3bCcpr955rXpQ1y2NGiJC2gShq9q5FUynJBenyc
	 nrFvUfUn9y8eXm6dsz3fZx5bYj6EfEL//4N4Ps483VDE/y7MS60Xgb6ABO538xnVXJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JC5MyreK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B5F5E606A330;
	Mon, 23 Nov 2026 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JC5MyreK
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 64F841F000D3;
	Mon, 23 Nov 2026 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795449292;
	bh=XReu0ZKCor2qvQSwwYtS2+JUKrtwYf/w6vLmesHfbts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JC5MyreK4jS05VjTpRFCWKkJ2PA9aUITrHSukD14GcvyDU9FEEVh9HSwzNqg9mOwH
	 EMqUNYnSWWZiZKxeC8DloK/0Bzk4bzR/YmmgcdyWLuNtCdx05YiJ3/EkyL2xTOVbPH
	 HZISquup7m06NFho+uW62tBi5DaxA0HY1OU+gq0Qo1FeGe0/3zJq2BgSWIGR8Xg2CQ
	 p+sDuhK6RV0SPA4P8NeF8qUxk22oY0CQf3pHKG19Rexna4s0FGtcjHKeytHKLxST7S
	 oTjzNDILA+pPNLpFtsS/Ng7sJVk4ZkbVtlYNIHfaASAhLhggdotLwEIETTtnzoY727
	 FAOzpqedyhF1w==
Date: Mon, 23 Nov 2026 16:54:48 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Subject: Re: [PATCH v12 1/4] crypto: qce - convert to auxiliary bus
Message-ID: <6p6pyrwbf5de3ftiq2dlzbf4lvuzgmyi3p6hd7gtodgckzceae@5rdpvien5bch>
References: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
 <20261120-qce-fix-self-tests-v12-1-b5a2a44bc5ae@oss.qualcomm.com>
 <c26b8002-c246-45cb-bca0-8f596a2a425b@kernel.org>
 <sfsgrwaj6ichkuafqvrpmql67664x6vyxgz7lwjxhywbf5zc3l@edz4qooziklt>
 <755ed314-ac9a-45f4-9403-52e7f0754ca1@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <755ed314-ac9a-45f4-9403-52e7f0754ca1@kernel.org>

On Mon, Nov 23, 2026 at 04:40:15PM +0100, Krzysztof Kozlowski wrote:
> On 23/11/2026 16:29, Bartosz Golaszewski wrote:
> > On Sat, Nov 21, 2026 at 02:05:57PM +0100, Krzysztof Kozlowski wrote:
> >> On 20/11/2026 20:34, Bartosz Golaszewski wrote:
> >>> This driver is disabled in arm64 defconfig but one of its
> >>
> >> That's true for next, but your patch #3 seems to disagree. That's
> >> confusing. Maybe you meant disabled for arm64 platforms or marked as
> >> broken? Because anyway defconfig does not matter here - even if drivers
> >> are not enabled in defconfig (so stay disabled), they should not be
> >> affected with unbisectable changes.
> >>
> > 
> > Keeping this fully bisectable (it is build-time bisectable actually)
> > would mean squashing all 4 patches together. If nobody objects, I can do
> > this of course.
> 
> That's not the point. The message is just confusing. It is not "disabled
> in arm64 defconfig" according to your next patch...
>

Yes, that part is wrong but you also mention retaining bisectability in
that paragraph. In linux-next, this driver is enabled again and the
BROKEN label dropped. Do you prefer a single patch splitting the driver
AND updating defconfigs or keeping this as a series?

Bart

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8732931E9;
	Fri, 24 Jul 2026 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902567; cv=none; b=YphFgsh9tNd5pshZM9fbSEXyuZJu4Zb+F74R1A9kOgoycNMbZM029N+jAboqMKx5OMzKgrIuf/ORByMOdV3AZgw5Xzo8UiHbqRjveeXrJsR9H4s5lv5au+OW0DK2/bhskWEZbwkncnPdH9MWH6CQSiXEz2FRAGQWp+/l8OBggOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902567; c=relaxed/simple;
	bh=zQ1ymgrHjfBQqbnSo/LpVg8CphY3ojkgd3fZHVX1W/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hDu75KuZ+0mAgKV6V+JjVjl/3wloFA3cYe3Bq9HkzHS9XlCtPpYagjPNfuIrZQGw9jYWYsm6o4CMS6WhE5jQYePCAlDeon6/YB/hPHqBfCS+T4pI7nFpADqZ3Nu4GiRzO5ZpldZvozPCt//Jumzm3expvoajpWZjCB35F8XpsmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtBaTWEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtBaTWEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB921F000E9;
	Fri, 24 Jul 2026 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784902566;
	bh=cYZkrkiqIu9xwOG05+WaWrWOYFv6VVQ6YZhJoATWtr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RtBaTWEX6lOVJ34wQyV3FVuL9hL0DpMpAfH1t0GWNbHxgrUNjAHM/qiIp6nEqYHFx
	 XRwgHLo+Q0hFHsnWF+XcaTkURlr/paMdg2Nwc5ZaaTa80iqD2CCTmth4g4ZrBuEU6p
	 bHSFfyTrBIu5dN8Zgw0SlmJW4R2Fsaa61kfS71buwsP36/IIZaU+bIddr7wxMHeRhZ
	 cdQnqlsSBrxyTM2e+5AhbhvRFE24JgdLtl6y08iKeVX22V3BI5xSnKTKMo6UoXdCrs
	 uVQY+YcCqKW/UyQOb5+wqzHq1JbHTFeGn5OxnQ+8Ldg0g8T2Cud+27UOmE2Z3L4TPq
	 Zr6PD3hNDpWJQ==
Date: Fri, 24 Jul 2026 07:14:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <20260724141414.GB1876@sol>
References: <20260724050645.223799-1-ebiggers@kernel.org>
 <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>

On Fri, Jul 24, 2026 at 11:29:30AM +0200, Bartosz Golaszewski wrote:
> It can't be used *accidentally*. It can still be used by in-kernel
> users if you bump its priority via netlink.

dm-verity, fscrypt, fsverity, and blk-crypto-fallback don't support this
driver.  The QCE driver itself has bugs that make it not work with
dm-crypt and IPsec.

That's all regardless of any theoretical tweaking via NETLINK_CRYPTO.

That doesn't leave many upstream kernel features that could even
*theoretically* be using the QCE driver if someone were to do the
NETLINK_CRYPTO thing.  Maybe SMB or kTLS?  (But not with AES-GCM, as the
QCE driver doesn't support AES-GCM.  It would have to be AES-CCM.)

However, over the years it's become extremely clear that virtually no
one actually uses NETLINK_CRYPTO to tweak the algorithm priorities.

It's part of the excessive "flexibility" of the crypto framework that is
just not used in practice.  Users actually just use the defaults.

And with the defaults QCE is *never* used.

So I think the NETLINK_CRYPTO thing is a red herring.  There's just no
credible upstream use case justifying this driver's retention.

- Eric

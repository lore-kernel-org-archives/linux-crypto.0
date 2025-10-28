Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A2A309DCB;
	Tue, 28 Oct 2025 11:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761651551; cv=none; b=AgFYBbacn6ChtzTfAK1zuKWvFspjb4S/ZyU3ucXJmk0OmbwTfaUX+Mi7n7oliYNCZgICxq3UoicwzQoh2AZl6VVnfjKm0dGMXgdDr0OzBB4SmQAbYo52ut8fQh048ZXUSIRO67Er/03yskU3N8gEjPfMA3wCG04boLMaE/u5cuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761651551; c=relaxed/simple;
	bh=UAxLNhoB84hQRN0kOuuikbSKdb0pgZp04mtjcw3gneI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgU+Z2ZginrBt6sgDUXKbp3zMynw9f+HJvBN3MkPB+k00RGrDgKf99WBsaJ8+6V02W1wGU7zpxe3ZCBTZviYOL61KMAmEFOBUa/ksuTrCKujeiPWWCVvsKVW5ggmuDlaaTdn+68OwL9C+SUJ1wjr4Em97rEqBsdqyd+uBO2zVYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net; spf=pass smtp.mailfrom=queasysnail.net; dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b=xYhysw+u; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=lZvHAfsw; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b="xYhysw+u";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lZvHAfsw"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 9BBC9EC02B9;
	Tue, 28 Oct 2025 07:39:07 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 28 Oct 2025 07:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=queasysnail.net;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761651547; x=
	1761737947; bh=6FNvSF4bdDqt8+VEMT250QI+6dV1cBTjXy9CJpJx+OY=; b=x
	Yhysw+uz7P1p7ROv7c5N3pNs9FeTbDUT6hKyoWxonvfhvc6qLfSgSR8hRy4IUUtR
	qS61iQB2JIx+DJ7xg2J0avBYC32ylrUKfIV94ljhQbPwpIQ/m7tR08Su3yhwktox
	n1PFqUEiMTgdGA6Mwa8F75ZMBLAJ8Kovd3lw9yPmY/h0P14TtgGo6DTBHuKvBHyD
	qemBMLW5sMXsTUiKcQOvj9mVnommN/czjzhNFR66S5fUGhUOm4wpb8Dr8kzBKzki
	OkYNo5/ViIr+O8ULAkcThxnvljyEBZd8E3E4joIyavYx1o2uhsEwvbrj3j8hR0Xn
	BcQiVDpTQXa/y3WC0VbKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761651547; x=1761737947; bh=6FNvSF4bdDqt8+VEMT250QI+6dV1cBTjXy9
	CJpJx+OY=; b=lZvHAfswUW8xbsw49HIqDI/XyRbtPdzWwwGkVl3HAUGa2P0pSvU
	01C+HMDHmbhYNLxHNsWCaEOnJS1su0ik3dwUZEwMiIehy+eTSacwFcRQfrpEUP8z
	YPXQCyIO9wX8w8hz5uF5u/FH+otd7FMPsFGIJzUxnsZkpjZPQLygJy565Zso3WWZ
	4RQYojlD1eUaFDuUIIU8oU4S7B/tv180W2qO55tp0RjIIEGbxBfOlvASRNUB+uBN
	G2yeixN2+w6MslZTNA7GuMtBi6DT9Gq9Xrbtcf/hajuoZGsHfUeK0Jx/8g4+3Cf6
	yJwgUFajxqVDoezkLiRhCp+1xhntHZfkRMw==
X-ME-Sender: <xms:WqsAaf4K4jYStqcnN3YLfgqcZxNDBqP1ETWoGsN3EAWSpYCgnXe46g>
    <xme:WqsAaRfJElK_9gado7_GwFdTnt5h7qHY5C4TP0blhedYi6rwxFvGk9KG3TlXw8vNk
    1U0gBLcYz6zvQ4zUzPXxZ3Jg609WUacVTnAWGS-dg48-Vf6bOmxKZE>
X-ME-Received: <xmr:WqsAaa6BhJmomZXtgfYfg8-1dOW3eqkFMzBk1bxqBLKAXdu4aq1gMrzu4wPV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduiedtjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtjeenucfhrhhomhepufgrsghrihhn
    rgcuffhusghrohgtrgcuoehsugesqhhuvggrshihshhnrghilhdrnhgvtheqnecuggftrf
    grthhtvghrnhepuefhhfffgfffhfefueeiudegtdefhfekgeetheegheeifffguedvueff
    fefgudffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epshgusehquhgvrghshihsnhgrihhlrdhnvghtpdhnsggprhgtphhtthhopeelpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehtrghnmhgrhiesmhgrrhhvvghllhdrtghomh
    dprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohep
    hhhorhhmsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhr
    ghdrrghupdhrtghpthhtohepsggshhhushhhrghnvdesmhgrrhhvvghllhdrtghomhdprh
    gtphhtthhopehsghhouhhthhgrmhesmhgrrhhvvghllhdrtghomhdprhgtphhtthhopehl
    ihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:WqsAaW-MygqBWjpGd-m6mCepbeB67YtaxNEtQ2yEPmKy1A0bjXBrmA>
    <xmx:WqsAaUFd26bnFFCKSV_MuQCEWDtkoQ06RQyd78vAaKJuLDMmGdKyLA>
    <xmx:WqsAaTWSHVBKitKOFXXcj8DuRv3g7fe-1gTfVk6ghY3SZZEI0Aj8XA>
    <xmx:WqsAaY9HjwC3aVWHBHLCnb96MqCmm32XOM30tZQ-xCX5nnlwq1_qpg>
    <xmx:W6sAaZ_BVG8u2-e1YtNlN-rLINIc7K7Gmf3OUkLDzeCYtk0ATpC3wO76>
Feedback-ID: i934648bf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Oct 2025 07:39:06 -0400 (EDT)
Date: Tue, 28 Oct 2025 12:39:04 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: davem@davemloft.net, horms@kernel.org, leon@kernel.org,
	herbert@gondor.apana.org.au, bbhushan2@marvell.com,
	sgoutham@marvell.com, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 15/15] octeontx2-pf: ipsec: Add XFRM state
 and policy hooks for inbound flows
Message-ID: <aQCrWAVZh2VlOl54@krikkit>
References: <20251026150916.352061-1-tanmay@marvell.com>
 <20251026150916.352061-16-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251026150916.352061-16-tanmay@marvell.com>

2025-10-26, 20:39:10 +0530, Tanmay Jagdale wrote:
> +static int cn10k_ipsec_policy_add(struct xfrm_policy *x,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct cn10k_inb_sw_ctx_info *inb_ctx_info = NULL, *inb_ctx;
> +	struct net_device *netdev = x->xdo.dev;
> +	bool disable_rule = true;
> +	struct otx2_nic *pf;
> +	int ret = 0;
> +
> +	if (x->xdo.dir != XFRM_DEV_OFFLOAD_IN) {
> +		netdev_err(netdev, "ERR: Can only offload Inbound policies\n");
> +		ret = -EINVAL;

missing goto/return?

> +	}
> +
> +	if (x->xdo.type != XFRM_DEV_OFFLOAD_PACKET) {
> +		netdev_err(netdev, "ERR: Only Packet mode supported\n");
> +		ret = -EINVAL;

missing goto/return?

> +	}
> +
> +	pf = netdev_priv(netdev);
> +
> +	/* If XFRM state was added before policy, then the inb_ctx_info instance
> +	 * would be allocated there.
> +	 */
> +	list_for_each_entry(inb_ctx, &pf->ipsec.inb_sw_ctx_list, list) {
> +		if (inb_ctx->reqid == x->xfrm_vec[0].reqid) {
> +			inb_ctx_info = inb_ctx;
> +			disable_rule = false;
> +			break;
> +		}
> +	}
> +
> +	if (!inb_ctx_info) {
> +		/* Allocate a structure to track SA related info in driver */
> +		inb_ctx_info = devm_kzalloc(pf->dev, sizeof(*inb_ctx_info), GFP_KERNEL);

I'm not so familiar with devm_*, but according to the kdoc for
devm_kmalloc, this will get freed automatically when the driver goes
away (but not earlier). This could take a long time. Shouldn't this be
manually freed in the error path of this function, and somewhere
during the policy_delete/policy_free calls?

I see that you've got a devm_kfree in cn10k_ipsec_inb_add_state, so
something similar here?


[...]
> +static void cn10k_ipsec_policy_free(struct xfrm_policy *x)
> +{
> +	return;
>  }

The stack can handle a NULL .xdo_dev_policy_free, so this empty
implementation is not needed. But I'm not sure releasing all
policy-related resources at delete time (even via WQ) is safe, so
possibly some of the work done in cn10k_ipsec_policy_delete should be
moved here (similar comment for the existing cn10k_ipsec_del_state
code vs adding .xdo_dev_state_free).

-- 
Sabrina

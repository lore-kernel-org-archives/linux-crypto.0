Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFBA14D71D;
	Fri, 30 Aug 2024 06:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724999416; cv=none; b=OjhDRE3ubDIFKEqINxuPvXIqcC3zcR3vEBSLczTmFQr0kMKn0VC9+IiHOAyyF7nHgRlXLtWe5O+3++AoXW7atID0Yi7/9P0TyFqJGWpWJBz+4v809J6UpFpdHwWXObhRYwW35zvtii82UywRi58387wBj5BPYaXay/dgDZBffHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724999416; c=relaxed/simple;
	bh=lPbDnoIYYT+OPMoFM9FRA/Gip0DGARusSAmuTjihBlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMU0zcvYI4uARG//aaL1R0IyI96Ul3a3PlBKq2TLBjLpBLIw4pPeojST6zfcf8a8kQ8kfnKqyxQgu0Ys9iuKm5NwySXyIxAB80RFutLvZjab1ZrDy2KYT2CJ7zqd/RsmpNngDlbqC2HuKGh1AAFTFvsz8lXoO6T/uAKM2FZth6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 9989B3000C785;
	Fri, 30 Aug 2024 08:30:03 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 92D6D357A40; Fri, 30 Aug 2024 08:30:03 +0200 (CEST)
Date: Fri, 30 Aug 2024 08:30:03 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Gonglei <arei.gonglei@huawei.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Baolin Wang <baolin.wang@linaro.org>, longpeng2@huawei.com,
	wu.wubin@huawei.com
Subject: Re: [PATCH] virtio-crypto: support crypto engine framework
Message-ID: <ZtFm60YSk9BsAjYV@wunner.de>
References: <1482821347-47664-1-git-send-email-arei.gonglei@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482821347-47664-1-git-send-email-arei.gonglei@huawei.com>

On Tue, Dec 27, 2016 at 02:49:07PM +0800, Gonglei wrote:
> crypto engine was introduced since 'commit 735d37b5424b ("crypto: engine
> - Introduce the block request crypto engine framework")' which uses work
> queue to realize the asynchronous processing for ablk_cipher and ahash.
> 
> For virtio-crypto device, I register an engine for each
> data virtqueue so that we can use the capability of
> multiple data queues in future.

The above got applied as d79b5d0bbf2e.

What's the benefit of this change?

virtio has its own queue for requests.  Adding a crypto_engine puts
a queue in front of that.  So now there's a queue feeding a queue.
That seems to be a roundabout way of doing things, so I'm wondering
why this change was made?  It seems to introduce complexity and
overhead with no apparent benefit.

The reason I'm asking is that I'm splitting sign/verify out of
virtio_crypto_akcipher_algs.c:

https://lore.kernel.org/all/ZscuLueUKl9rcCGr@wunner.de/

Nowadays sign/verify is no longer asynchronous.  However the
crypto_engine indirection forces me to introduce a sig_request
struct which stores the input/output parameters for a sign/verify
operation, so that the crypto_engine can consume it asynchronously.

I'm tempted to instead remove crypto_engine support from
virtio_crypto_core.c to ease migration to synchronous sign/verify.

Thanks,

Lukas

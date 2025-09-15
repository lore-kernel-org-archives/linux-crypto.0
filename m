Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906D730C347
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757947862; cv=none; b=WN+qPhjykiCYrUpqzVkvtzJ66FCie062Gs8LkRzoprPp+ZmmalPGQUlWzK11tFgbcfxdhtuxZtDN+K6I2XtQTCahNK87A8OuK05Yz9DYkFPy/WZHd3Jy8ZZh1pZ56+O0zeCyQ4s81XzY9Hu+WdZkvFbsUdHFKex84unZeui3odk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757947862; c=relaxed/simple;
	bh=w7XT6KXV2b3t/YfAkMG20cqIO+6Scsi7cT8DDRnQhf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9tgv3H2BjlWHOuTShRXQNrpDteDQpT5pfiYCxsXbn127XAHDPyoWjRigOv2cfVZxJDoqwlEPNgS6aveAj3gnmTjK7QSpONqAuTy+d/MT/yvcnMtocGdoCGtN0STLb79nlz/DbaaqSGVkEa2sufCu/ZK+he4p9zUu9snb8zpcPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUngYzgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUngYzgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D5EC4CEF1;
	Mon, 15 Sep 2025 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757947862;
	bh=w7XT6KXV2b3t/YfAkMG20cqIO+6Scsi7cT8DDRnQhf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XUngYzgXb9w7lqm8ZBdPf/QiofLxWoLS5/+8e+Yv4QpMuY42FyFxRaOXq29801X2W
	 1jz7nkRnBfPe3eZuWeIwPD2VooFHoWVaQ8LBXHn3mkCD+/Hf91g2DPuI8EC1iO4fDN
	 4e07/711XpyDpKg8D5ISYI4RYg1JTR+8thIPVbfroZPyx4JcPiCJ1wJrc5drhsdJnG
	 4dH6Jj8Ivh5kQuKiWuiphXCbRzwv6nKq4oPXh2mPrYJ1wPnbQqy9DADDVT9CneN11A
	 FdUA572huq/tzFlVqCK62dGXamAPKVcvkdHmATEzd1hGQx+Y1BQBFE7SRdTr6LvJr1
	 c90xUlRsnjxtA==
Date: Mon, 15 Sep 2025 09:50:59 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Subject: Re: [V1 0/4] User API for KPP
Message-ID: <20250915145059.GC1993@quark>
References: <20250915084039.2848952-1-giometti@enneenne.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915084039.2848952-1-giometti@enneenne.com>

On Mon, Sep 15, 2025 at 10:40:35AM +0200, Rodolfo Giometti wrote:
> This patchset adds a dedicated user interface for the Key-agreement
> Protocol Primitive (KPP).
> 
> From user applications, we can now use the following specification for
> AF_ALG sockets:
> 
>     struct sockaddr_alg sa = {
>             .salg_family = AF_ALG,
>             .salg_type = "kpp",
>             .salg_name = "ecdh-nist-p256",
>     };
> 
> Once the private key is set with ALG_SET_KEY or (preferably)
> ALG_SET_KEY_BY_KEY_SERIAL, the user program reads its public key from
> the socket and then writes the peer's public key to the socket.
> 
> The shared secret calculated by the selected kernel algorithm is then
> available for reading.
> 
> For example, if we create a trusted key like this:
> 
>     kpriv_id=$(keyctl add trusted kpriv "new 32" @u)
> 
> A simple example code is as follows:
> 
>     key_serial_t key_id;
> 
>     /* Generate the socket for KPP operation */
>     sk_fd = socket(AF_ALG, SOCK_SEQPACKET, 0);
>     bind(sk_fd, (struct sockaddr *)&sa, sizeof(sa));
> 
>     /* kpriv_id holds the trusted key ID */
>     setsockopt(sk_fd, SOL_ALG, ALG_SET_KEY_BY_KEY_SERIAL,
>                &key_id, sizeof(key_id));
> 
>     /* Get the operational socket */
>     op_fd = accept(sk_fd, NULL, 0);
> 
>     /* Read our public key */
>     recv(op_fd, pubkey, pubkey_len, 0);
> 
>     /* Write the peer's public key */
>     send(op_fd, peer_pubkey, peer_pubkey_len, 0);
> 
>     /* Read the shared secret */
>     len = recv(op_fd, secret, secret_len, 0);
> 
> Each time we write a peer's public key, we can read a different shared
> secret.
> 
> Rodolfo Giometti (4):
>   crypto ecdh.h: set key memory region as const
>   crypto kpp.h: add new method set_secret_raw in struct kpp_alg
>   crypto ecdh.c: define the ECDH set_secret_raw method
>   crypto: add user-space interface for KPP algorithms
> 
>  crypto/Kconfig        |   8 ++
>  crypto/Makefile       |   1 +
>  crypto/algif_kpp.c    | 286 ++++++++++++++++++++++++++++++++++++++++++
>  crypto/ecdh.c         |  31 +++++
>  include/crypto/ecdh.h |   2 +-
>  include/crypto/kpp.h  |  29 +++++
>  6 files changed, 356 insertions(+), 1 deletion(-)
>  create mode 100644 crypto/algif_kpp.c

First, this lacks any description of a use case.

Second, *if* this is done at all, then it must give access to hardware
drivers *only*.  We've had way too many problems with userspace software
inappropriately depending on the in-kernel software crypto code via
AF_ALG, when it should just be doing the crypto in userspace.

The asymmetric algorithms are especially bad because the in-kernel
implementations of most of them (all except Curve25519, I think) have
known timing attack vulnerabilities.  Implementing these algorithms is
really hard, and the in-kernel implementations just haven't had the same
level of care applied to them as userspace implementations.

We've seen time and time again that if a UAPI is offered, then userspace
will use it, even when it's not the appropriate solution.  Then it can't
be fixed, and everyone ends up worse off.

- Eric

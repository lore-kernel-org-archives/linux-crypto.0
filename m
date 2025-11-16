Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C4820311
	for <linux-crypto@vger.kernel.org>; Sun, 16 Nov 2025 19:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763322159; cv=none; b=b/labKDrTTmYcbqSYtlMicakzOhKRqvykHQq/6GwlqQogp0uMkFSKzUjld68fCebvzqtM5K8JVGVW19YCcFhU7gYqbtjJXc7q+eLoYVyX+gtZIBYsiWWaAv2+EptGTSJZ/gcjB8p32vGirX1POTbaINEa/i1hN3ZCkPKbXUEzxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763322159; c=relaxed/simple;
	bh=YFm3tcRerMWBfohlAGgz+1loCSxwcyQo6DobfDkeJaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjRNqo2ejsag5Lh1OkzQnSPH6TtykShwLinqpkguxdTu/olc6QEbXuT9TU+qgaNjLE8552q46HN86sCZ4Ikr5TwztDPcXjYlgGIHr+41esiBL7AyvAp62hQPzPhYzDINK0ZhTu2Q5QyrwTCBfO1PVu9qMorHmv2jdh8shXzI4uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KM32k8DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KM32k8DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0EBC4CEF5;
	Sun, 16 Nov 2025 19:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763322159;
	bh=YFm3tcRerMWBfohlAGgz+1loCSxwcyQo6DobfDkeJaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KM32k8DSJmu7vb1r4DQoAkaXN+r1yKG45nzE/l27Rlz6uycgHbpepbh4dhHFfLkJ9
	 WKgjqanAuIFqbQxbw6AaJ4rTyzm/pr8vZLj48krIaT+ETJ/+rXsaRNVRKpIXdA1CGj
	 RmCduilEeePtySuevYK8zahBn6r1SupGyCkee5Efo2KZyk8xrjHCQxW6zRJUgHyGgL
	 9zBwBLs+shuOb440oIm/OcasHyxllHQYF9t/XIarvP2N4PIde27+ZXP/8KXjsqdTej
	 QJIQEijn1+LLQaHAXvxQfY0Q9P9v7G9Sb/pjfBs8rf8XWKyo6JWF45eFaHACFkMOmJ
	 EKUhfwuX61Lcw==
Date: Sun, 16 Nov 2025 11:42:24 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.12] lib/crypto: arm/curve25519: Disable on
 CPU_BIG_ENDIAN
Message-ID: <20251116193423.GA7489@quark>
References: <20251111202936.242896-1-ebiggers@kernel.org>
 <20251116171942.3613128-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251116171942.3613128-1-sashal@kernel.org>

On Sun, Nov 16, 2025 at 12:19:42PM -0500, Sasha Levin wrote:
> Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
> 
> Thanks!

I assume that you meant to write something meaningful in this message.
Also, you forgot to include all the original recipients in Cc.

- Eric

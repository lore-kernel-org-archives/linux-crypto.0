Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622AA3F4840;
	Mon, 15 Jun 2026 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781540157; cv=none; b=q2A4ETxC3+HDz7k6IbVB4Ee415az/Npbu3D4fUSI4mpx+rz5ex7tCt3bZOMgzi8gj3S7UpxsDkG50+6HK1r9ZVW1C0PH7UgmcZERkHNpeE5TTLTKDV6Co2fuIYTck0gibKNz2DKUZQ2glXKcFdJ9U9hrQTj+U3q0WrkFo9WZajM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781540157; c=relaxed/simple;
	bh=ELuhMg5L4/O6P9axI27xSC1eehDCn3+dcYe+GRH9I1g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uy8RWQ095HOj0MqRNaABuVeSi0eDkbPIyNZqEY0+7BXi7MoCgjoebZGuxHJSPidGbaR8j43aluWuODRY6cKrtOpnfZuHxBhPXMP/NJb93vk/5po9kiAMB6afItuirqZXkICyC0dloER0yzU7wJ70rI6iyA+YUreIizdKwx6dqg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBf7qqqM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBf7qqqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89C41F000E9;
	Mon, 15 Jun 2026 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781540156;
	bh=ELuhMg5L4/O6P9axI27xSC1eehDCn3+dcYe+GRH9I1g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iBf7qqqMUjy7kdPxVRh7Lx8De/+AJrRwcVpLga02OpkURzWiUXnmU4cUQCpG+/wJO
	 ijyHMqayhEMxqhL3mca3r9wAdzbLw7LG7vRVlXamKAQ6YAxTTGiWnVojl99kEKk/i+
	 vXVtTfwcQm1zyCS/dTKlTm4JkYrx5xmxn90Y1QP1Ww1FHZwIwMy4Vi7G66kJ9LGare
	 AjEtgfInXwwGqwb9coEUKkvatU7O0p0fDXRD5N2MjgFuFlFe6mCDBQIapZlAI+uwVh
	 EPcgHQZg39S8oNN5QH40UwU74/+T1qzSka8gdxjtA3yhR+yzijL0YEghgi6MRZQIfu
	 TdMoDf3YeQOfw==
Date: Mon, 15 Jun 2026 09:15:55 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH RESEND 1/6] sock: add sock_kzalloc helper
Message-ID: <20260615091555.4af017aa@kernel.org>
In-Reply-To: <ai7JfHTFgFt6YN_K@linux.dev>
References: <20260527082509.1133816-8-thorsten.blum@linux.dev>
	<ai7JfHTFgFt6YN_K@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 14 Jun 2026 17:32:12 +0200 Thorsten Blum wrote:
> Gentle ping? Patch 1/6 still needs an ack from netdev maintainers.

Perhaps other maintainers shared my feeling that this is a waste of
time.

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581700;
	b=pRa5QntsLsiQDWIc9cFshXY0ClgIPjQI1pomWM5PJdPnOViwtZ1KY+fTs7H3IOLl4g/T
	 noryPDoVkGcW2mi37C44j3VOukHPoTup4Df8KCAy/nCEPxDUbATVnyLwHcYizgU95QGI1
	 tNo4BDgX+qHx63GRz7Q4SzXacOUQ0Zqdnzw/xjjUHLtAgtWhLeFHJjt99OQmnK/Mfr6Ik
	 ir3YAHRspBfQy4oLLg/eiM/KEWyFYreRD5YXZBQtWqyN/PhxeTRegpKsA4mJkwQo2JE0A
	 IK0HSg3c8lq1kWNED4zmBTTeBhEMlNWZc8eP3QIpl4eUFSXLdH8quL+hk8dT1nrt5Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581700;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=veR8q9v0OA1Q+QVhyvn39Itk2zf2DJACfdZv5+IibhY=;
	b=G7znGgOebKscp47L6gUnjPM8lNpbfTUxJc5CbJJBWKLYKhmot+Uy94d1sIbt2o467pHA
	 T5N7mJ7s5mPN8POkoV+7sug8T2GGd9qyVylx7H81m0Xsczb6BoOEaPZizJM1YrcFkvU3e
	 4FIZ2sEglr7ncOfr47BVC0myqUcJn/DRBbcv4ZAhvVV5anWaC7j58FLtq9400DT1jDWzP
	 aDaF5q8k11jzwb52GkK5ewhKyIlGouAcKlDL/B5Ti5MCMmDTx4arZwdCBHmQKR40zIOMM
	 +5tW5ZvsfDC6E22ldc9peTuCPoaTLQ8dQBz8wd6q62+okPoUPBLDXvEQHf9LpWmPv3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TWhyC73b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D1655606A326;
	Mon,  2 Nov 2026 01:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TWhyC73b
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D748A1F000C1;
	Mon,  2 Nov 2026 01:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793581699;
	bh=veR8q9v0OA1Q+QVhyvn39Itk2zf2DJACfdZv5+IibhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TWhyC73bKY1y4jAAwZH9MuvbegRenyAHqF4o3GT0HjMTOU0rk8Z4hvYfxKctuMKjH
	 BhZzekKFm5QUEhqXjH9qmLxWszWq3h+FHpG1l/J+F624Vp6VnZMrxNyetEwMc2sG72
	 B8M8aMChgQEXFZeJET0ny182ZQIFxnjQCnOR/21Y17z1wm4QXvTXiWohgXB6/Nm5xJ
	 oxuE+BY2R83st8jlMcNLag1m4C/MS3LvGAN/3iDVX9cXFKvCMrS3eqbJTNebKmby85
	 nTC38KBE7XuDgFgO1w7zm36lWVKL78w5VHeSWTjv60UJCtAEBSuOM3hIciDGPrHzlV
	 q3LHgzmc7WMNw==
Date: Mon, 2 Nov 2026 03:08:15 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"open list:ASYMMETRIC KEYS" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <aufif6uG43-qMFM6@kernel.org>
References: <20261029232437.2581640-1-jarkko@kernel.org>
 <20261029232437.2581640-3-jarkko@kernel.org>
 <20261101232149.GC2689@quark>
 <aufTcqW-DTB9Ofai@kernel.org>
 <aufheZ9mR0rWqicW@kernel.org>
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
In-Reply-To: <aufheZ9mR0rWqicW@kernel.org>

On Mon, Nov 02, 2026 at 03:03:57AM +0200, Jarkko Sakkinen wrote:
> Hmm... and rhashtable_insert_fast() can cause transient -EBUSY, which
> is probably acceptable.

Or actually: is this acceptable or not? A small detail but I guess it
makes sense to address this properly.

Br, Jarkkko

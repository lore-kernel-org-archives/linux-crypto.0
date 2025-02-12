Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BDA1DB154;
	Wed, 12 Feb 2025 03:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739332304; cv=none; b=ECcgYP2DG8v+VS5Cv3YtLI/JZbAGnbR8ZNPtwL2U/4HeDS6aQVDzn5u6hM9yriFTU/abvuOIVRaaaDanO+qkJ1xz4d0dxTyuc6Iar/YjaCgcEwy/4D/vIIDHC/YyBS5xEVHgZOGX/jLlKjCaA43H0hVMGhqc4MdmyIA0NjHOu8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739332304; c=relaxed/simple;
	bh=1kP4IGdQ8x3URBMcWavheEsypemHYZst+2KRCcrwNKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXOHU/9i9fEoYWcwcWLHlLBQ7nv2IVNxp3hkWfizdBMnHtEetlOyNv0rS/JJw4rzVoYDKqN0jhlUba1hV1DAKbKXIA2jefDiu8m7aykbsfQarUbqyT8Z/1OUaMYwcIyLd6PshQ9XpTXxgs1Kh0DKYfJr9mdwQnM14aU0mhS9XMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Z5LoVvQA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Z5LoVvQA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nFemjeCz+svPiqDivRwBTX10UQyG6EeAMs3A599m/to=; b=Z5LoVvQA/zxGFaX61quTDq56Mj
	oNQtaYQvv6Rw2AF8EZygCpYZMQfxJVbIQvhZwRYIbr9LpJoXK/Nc6FG1UMQnen254HH4/KlvnVvw2
	+9MecugkxOSWxuJ46kJCf95Mc4iXYCY5lO4Wpen3f/Mr4kChGXUXjsFg5QnU6lrIPEp9EAHLsWpBS
	ukX4lOUfTJpSVc+ghdWw1+91hZXJvRBAa/t19/5dAdCSd8AhYcuzsITuwTZASvTK0fn6HC28aCdr9
	eHgexquxsna1PjKv3a1HcFUTxvJde0kMg1HehJHW1XDXVXcmXrBT5mQ6bVKPAImifEXX1HEnSo1lC
	A/UBqaCQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ti3ZQ-00HDVT-18;
	Wed, 12 Feb 2025 11:51:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Feb 2025 11:51:13 +0800
Date: Wed, 12 Feb 2025 11:51:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: clabbe@baylibre.com, conor+dt@kernel.org, davem@davemloft.net,
	devicetree@vger.kernel.org, jbrunet@baylibre.com,
	kernel@salutedevices.com, khilman@baylibre.com, krzk+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, martin.blumenstingl@googlemail.com,
	neil.armstrong@linaro.org, robh+dt@kernel.org,
	vadim.fedorenko@linux.dev
Subject: Re: [PATCH v11 11/22] crypto: amlogic - Introduce hasher
Message-ID: <Z6wasftL23_K8vA2@gondor.apana.org.au>
References: <Z2aokzSrAHpJE_PG@gondor.apana.org.au>
 <Z2aokzSrAHpJE_PG@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2aokzSrAHpJE_PG@gondor.apana.org.au>

On Wed, Jan 22, 2025 at 03:41:29PM +0300, Alexey Romanov wrote:
> 
> Why? I couldn't find this explanation anywhere.

Because the digest function can be called from atomic contexts,
such as networking.

> In addition, I found an example of one of the digest functions that is sleeping [1].
> 
> Links:
> 
>   - [1] https://elixir.bootlin.com/linux/v6.12.6/source/drivers/crypto/mxs-dcp.c#L804

That driver is just broken.  If you look through the git history,
you'll find that a similar problem was fixed by replacing the
mutex with a spinlock in the cipher path.  Unfortunately the same
fix hasn't been extended to hashing in mxs-dcp.

Cheeers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

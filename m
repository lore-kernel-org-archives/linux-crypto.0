Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B195533D6D9;
	Tue, 16 Dec 2025 18:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765908167; cv=none; b=KsfkFMqbB9t4Ry7E9IRFxNs/OznfaxMldJe+8txIRD5SeppCde/oVnI9+AMo2GwRGsiwiT80yR7lXAK2uAbK300VKSEghadGIDoccmn1ZfJtBAcqNhIlB/h1Dqtf0pTAt+AXVK7eTZsQWJOC82fySkcCaRt+I9aDXoupCly0RO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765908167; c=relaxed/simple;
	bh=T6gPHTjw/Zx9+KYa1PVLgBTG1KiKarM9imEmVw16l40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zj/c8brpO/w9SJgH3+ATmMSIlq1Ey+0+WixgNU792ht7In8YTsw5I7yjhK16X3YfSHwnwlsINecRBPvv6q+VIXjBX4Ur3CMP10Kux7MAY9bOOF6nBBY1l3qV0VSSz5nQPv9+OAkubt2Y5bBg60PvqRsJNchi4qP8C49gSe52ZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m175OY8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m175OY8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F88C4CEF1;
	Tue, 16 Dec 2025 18:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765908167;
	bh=T6gPHTjw/Zx9+KYa1PVLgBTG1KiKarM9imEmVw16l40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m175OY8uOWKAP+3NifWFKTo6rWIJTvA7rUy/4goI+e9lbbYGYRhRSFgVEjyeMfhML
	 VeQ0UIQRmWZNtV1chxxoeDk0T8kFoggt7oNNchJkLb0KA7x3qgG4abeTwdcc81/WzQ
	 R4kUdE9o21XeBSrdAVbTwR8DiAiDrx2lIVQAvgiD9Y9iqxrQAVTJYwM5zz/Udm028z
	 +i96S5Zpk9m2KlYUOigOV9kyxbTd32giZS5Y76AxqGJZig+rE0zHlTgSWjIamMI/vw
	 oQhTepYoF5yWSo/HMnVVTtM8o2hDLFboUkWDdo/FYl7KKBBVqY47y35H0ipaMBoicw
	 8v9PKkqwlsJzA==
Date: Tue, 16 Dec 2025 18:02:45 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] Implementation of Ascon-Hash256
Message-ID: <20251216180245.GD10539@google.com>
References: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
 <20251215201932.GC10539@google.com>
 <7920c742b3be0723119e19e323dc92bc@kriptograf.id>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7920c742b3be0723119e19e323dc92bc@kriptograf.id>

On Tue, Dec 16, 2025 at 01:27:17PM +0700, Rusydi H. Makarim wrote:
> While no direct in-kernel use as of now

Thanks for confirming.  We only add algorithms when there is a real
user, so it's best to hold off on this for now.

- Eric

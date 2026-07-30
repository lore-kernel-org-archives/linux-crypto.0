Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B593164B7;
	Thu, 30 Jul 2026 07:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397194; cv=none; b=OJjz6tW/ZzHwTsSylKtE1O7Dkf8Pi68LCdJEsV5afi0GeUc3h9TzLBDxRjsNIaRsnZ/5++yiXU+8Un02E28WHTPXjW+zY8ooB0ywVoX3ydn5YFBxNPn/VAKZ8YRAe82cgOr1FbbIrVywpIJo84rAVzTPjZhKY0kka2Bgyy83YU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397194; c=relaxed/simple;
	bh=UADKdDcZrY1i9MlaQA2sRt9gj8LT11KoCnG/YYcweVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mUOQijErkfJo9WK4EopC9Ts5yF5x+/Eq4h0++QR7chfZjrWR0xq7rjwis2t2LToLxQCxO5PerGjhSebjzYIoLU4rWKxMJkEE4wUEM8V6za1kd+Uk8kSzEsC/2WZcLEq1tebfA4MPkqdJq/dWTvSSm5cBig5EF6MsGy7KoNjrPok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=IxY2dqbt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="IxY2dqbt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=QYQq9CuyQrewPgkwFOZuMMY7Kqz6TtbxNH5qWeb6nM0=; 
	b=IxY2dqbte7yB4lJt9HcqpFY4AtcQTUON0LwRlmQhRCdbM4D0u1xzTKj2THuUNs4215Ywx4+nvcq
	A8r7oQfGfetTlLDHb6V00bhPw/GavRQu5Xdxq9tZcfO067C+ZsE+JuEoMsNt1D2guXerUzdkRXLyQ
	cUJWhgClhxWqrhwbvCZdtdI4NFJoybUsVofbokPklRiyxSvaNUdDxHP8YYpQ1S+JoWk14P9dJOE8W
	4BP1EiUhOV1iU+fbe9b5Auvd4/Ht4UlcfaNNo1JMcIqHdrWawbNkXOJVY77sjQ86M8wKY1qdTJom1
	TkLl1kbEmz/GIZifQN5t17SYB3pbSXi150lw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpLMp-00000000RwN-0yTf;
	Thu, 30 Jul 2026 15:39:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:39:47 +1000
Date: Thu, 30 Jul 2026 17:39:47 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: cesa: manage SRAM teardown with devm
Message-ID: <amr_w2X7UamAOE5Y@gondor.apana.org.au>
References: <20260717231742.1174221-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717231742.1174221-1-rosenp@gmail.com>

On Fri, Jul 17, 2026 at 04:17:42PM -0700, Rosen Penev wrote:
> mv_cesa_put_sram() is called explicitly from both the probe error path
> and mv_cesa_remove(). The non-pool ioremap is already devm-managed, but
> dma_map_resource() and gen_pool_dma_alloc() have no devm helpers, so the
> mapping is released by hand. This is error-prone: the error path iterates
> over every engine and can dma_unmap_resource() an uninitialized/zero
> address for engines that were never set up.
> 
> Convert the teardown into a devm_add_action_or_reset() callback registered
> only after a mapping is successfully established. The callback fires
> automatically on probe failure (devres rollback) and on device detach,
> after mv_cesa_remove() has already stopped the engine and freed the IRQ,
> so the unmap still happens in a safe order. This deletes the explicit
> mv_cesa_put_sram() calls and the uninitialized-engine bug at once.
> 
> Add a struct mv_cesa_dev back-pointer to struct mv_cesa_engine so the
> callback can reach cesa->dev and cesa->sram_size from the engine alone.
> 
> Assisted-by: opencode:hy3-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/marvell/cesa/cesa.c | 55 ++++++++++++------------------
>  drivers/crypto/marvell/cesa/cesa.h |  2 ++
>  2 files changed, 24 insertions(+), 33 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

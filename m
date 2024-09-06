Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475E9145B11;
	Fri,  6 Sep 2024 07:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725606562; cv=none; b=rMeJslZQXQYvHJVqZ8f4kZXcmmY+rK3QFU2DsuorXmbjEfRb2hCT6qzD7drl5pdxxpWVdfMt2Y8HZ67L3OAIhGjwpo2FYnI7Gt1QFa/N3u9z1rqtZn1TyOMQquE+wKa06Q584UeRo6lfaUmoWXr01VEBj7XsTRaKXx2Ev7VBkSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725606562; c=relaxed/simple;
	bh=miLOIj3hlzbYQI8mE8L9Ts/s13zX8KLgSUIsm6b9614=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DmeYtke+AKJjs+YJmlB59KxALgmRN2EXxfPYlDqNSjYVbfLXnFHbxpvzjghKT+tISoYn/9DjP3vpZZtKzmin3aXtQTEdBBOJLk+Z2r6NzldGCeEjbYFm84idi/V01f13tT4kPzpYM/SpFs9XccY+8MgWZomEH6bGkMhA+MM5/SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Hr1Pkfqy; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Hr1Pkfqy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+mNZr39It15m+/NdJgL39QrNoCnMyK81/Rg9+WyFqA4=; b=Hr1Pkfqy/wI81H7F4cJdQjsIRh
	xNtkTK6ylYXqClpcnXVBdmdewHsu6j7yikt4shRxcoZ6fKaAKsiVbABv7QfVA+p+WBmUBmaSYpiTR
	HRYuJe1mhAbRtTObwLX+ag26mgJ/2HQ8eu1SfK+2thxBOvr8iifOXj0u9MH1e5REizL7jojcsmpMB
	RwRV/qDYv6tQtV1OOHFXUhZiMw8ODbesn+vzxU8JBZGVBRXw1C9gmRTwHCwdP1tgAw6G9TUinXuBw
	q+s1AcCHzSXDDSz3N95os01X7OIJ2Y97U6vJVd5cYpkGOHyM2jmvw7iGtPSt5QpYmJEPU/hY4q77S
	EIJ/M4iw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1smSvp-000WWB-20;
	Fri, 06 Sep 2024 15:09:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Sep 2024 15:09:11 +0800
Date: Fri, 6 Sep 2024 15:09:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Gonglei <arei.gonglei@huawei.com>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-crypto@vger.kernel.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Baolin Wang <baolin.wang@linaro.org>, longpeng2@huawei.com,
	wu.wubin@huawei.com
Subject: Re: [PATCH] virtio-crypto: support crypto engine framework
Message-ID: <Ztqql_gqgZiMW8zz@gondor.apana.org.au>
References: <1482821347-47664-1-git-send-email-arei.gonglei@huawei.com>
 <ZtFm60YSk9BsAjYV@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtFm60YSk9BsAjYV@wunner.de>

On Fri, Aug 30, 2024 at 08:30:03AM +0200, Lukas Wunner wrote:
>
> I'm tempted to instead remove crypto_engine support from
> virtio_crypto_core.c to ease migration to synchronous sign/verify.

I would remove virtio akcipher support in its entirety.  This API
was never meant to be exposed outside of the kernel.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

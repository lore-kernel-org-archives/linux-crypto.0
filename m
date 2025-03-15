Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F81F4284;
	Sat, 15 Mar 2025 09:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029648; cv=none; b=L+apQmyJB4b/IvlBpaZKfZ2RpO/xr1+NfsWODOOknGTH9ECqDHJ7uUvWlOpWw+0klwpM4zVY6Y+jwzMYHOnfck8oUuO8hQ4Cmwft7t/rpvwDtXG4ExFFnjVC9oKqLIodvlGS4gYZD85pkeudu/Van/v2HrEhbknVkZQ+cC9W2hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029648; c=relaxed/simple;
	bh=KA9FoAr3X6y1QqTfYBdPvKLl5hXk8A9+ar4Z+NuiuPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIZSkrL0BSWIXvSuarn/2mwfD6u17PzQpK3mlrdViRgtZ3Wwo8hCoWPbc40g5SZauBpwyq+/9HQLJ4TmI70PceB1VhwWwaMhxz+0rC8yT+fJvloiALkbL+TxQcu/cfGtc4Lve30y8DvXJWIic5UdiS/2pvXZgKnjh0PQIOW8KdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Tw9ONim0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Tw9ONim0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WTaJq2dr7kQo17UrW45KOR9ii1tHsbKoupP4Nqjp0MQ=; b=Tw9ONim0qWRppwpLzt20xa0shI
	3rBUNxKc9jkOJmDglOJxUkWFdHGeYZ6YJa3icgxzqBoDbwFDYYsKPG5Zh+4k6ZT1sY9PJNX+d4rwb
	jGRqzzjX5EI6XDuCyVbd81Bq24p7fnbVrNV/RS983qpFmEZ56xgi0sUltk+W2uNodT9rcLKoDEpch
	ne8zgW18rGcXfdMQ0aJeonT3TzSA7v+s2GqTTCsfejuveeBxEk++T9WrfkKXv2JLkNeqK5WMJMVJx
	SLG1vgQDW3PqL4CcHKnz8JsIW69BkyQExipP8maQye2RK/LqNcQOljLgKJEPWSkSs1+2jLf4CqHcy
	53X8eRDw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttNU0-006nxY-04;
	Sat, 15 Mar 2025 17:07:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 17:07:04 +0800
Date: Sat, 15 Mar 2025 17:07:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Gonglei <arei.gonglei@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: virtio - Erase some sensitive memory when it is
 freed
Message-ID: <Z9VDOK2c9JAfJZ_i@gondor.apana.org.au>
References: <a18fc6cf356bc338c69b3cc44d7be8bd35c6d7d0.1741028854.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a18fc6cf356bc338c69b3cc44d7be8bd35c6d7d0.1741028854.git.christophe.jaillet@wanadoo.fr>

On Mon, Mar 03, 2025 at 08:08:04PM +0100, Christophe JAILLET wrote:
> virtcrypto_clear_request() does the same as the code here, but uses
> kfree_sensitive() for one of the free operation.
> 
> So, better safe than sorry, use virtcrypto_clear_request() directly to
> save a few lines of code and cleanly free the memory.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> I've no idea if this is needed or not, but it looks not consistent to me.
> 
> If safe as-is, maybe the kfree_sensitive() in virtcrypto_clear_request()
> should be removed instead.
> ---
>  drivers/crypto/virtio/virtio_crypto_core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCCA263F52;
	Mon, 28 Apr 2025 11:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745841250; cv=none; b=suJdIpZnN9WAJPS+C4tTXxIFgWjE+LqpSSIudDjohsvAStMpZdaDrxhgjE9Pe8B1U+VbVqnKYZb1S6h/WUMzj9YB/RqOWX4/HXNkAL2eOqqnjWNs5VwMmdizdMhoYTBLW75QTDzuqfP6itb2Ao98yOtjOjHunM5Y13+30ZkTbwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745841250; c=relaxed/simple;
	bh=0c9vahFH4qHg9shlj9knqpEc566UaaG5cXpe3sFor/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ntyLp+CK1BgM5EX8RrbqPWagV4zsPtacPCwGJczKUmVbWHmHXn2aYXvxN9CweqoyIUPTS1fZs1ljcI5GprYkka1gvGvUWG6Cz7JeZKRl1LhFOE9Of9TYTNGZDnOmbWUjYC1Ao0MB0BG7TW6E8u1q0t9b1nAE+xNmD1J2JV6LsQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=axIUuKFG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="axIUuKFG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Eq5znlCdLNiUk5KYs9bc/Z5L7boBi3pvNQrB5LskcFc=; b=axIUuKFGMlkKc/xAVGR0KIAqhx
	NfM5araC7v5ntk7VQMniRmRFUHiyrPCLf87JQuk8KfWK29SPf8qpKbxFQ0/stAgcIuOpHOF/k45aP
	zjp/DKlvCdeH71+AqKm+yvnXpA464lYcMakIbb5QAVlIZ/ofwjClmV37aAYQec0yiRkQhcjYe17UM
	FB5E9xW1GqQ/6R1JRDlVdUqsXT2Pa9JfT8eogs6nlnuXeFokVFr9cgGefjQexoAvlcrgeya6V2F1/
	Sm9nq1FmQKTXagfZ55FEXHUIpxttaEJQd2yZeTer4GW6zSP/41ICwnSTrn9gwzeQOC4cajOvsy4as
	SDGGSBhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9N3e-001bK8-0O;
	Mon, 28 Apr 2025 19:53:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 19:53:58 +0800
Date: Mon, 28 Apr 2025 19:53:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kees Cook <kees@kernel.org>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa: Adjust workqueue allocation type
Message-ID: <aA9sVtg4dLqBGdg7@gondor.apana.org.au>
References: <20250426061130.work.001-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426061130.work.001-kees@kernel.org>

On Fri, Apr 25, 2025 at 11:11:31PM -0700, Kees Cook wrote:
> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation matches
> the type of the variable being assigned. (Before, the allocator would
> always return "void *", which can be implicitly cast to any pointer type.)
> 
> The assigned type is "struct idxd_wq **", but the returned type will be
> "struct wq **". These are the same size allocation (pointer sized), but
> the types don't match. Adjust the allocation type to match the assignment.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Kristen Accardi <kristen.c.accardi@intel.com>
> Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: <linux-crypto@vger.kernel.org>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

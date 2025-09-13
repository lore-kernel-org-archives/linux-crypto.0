Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C001F4701;
	Sat, 13 Sep 2025 04:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737645; cv=none; b=g8mZWn5nvGzex05fRwr8VOlBGJkLDqtKgqIhlITXL4DmF9TajjbYbPtdvJeGUiXhDEgn9w5ImsUfw0g1vnHA5UPZEesCuEhOpJORpD5f2rgqrIdehEJeTW5whNs8qXedN8IzUrj/UKyVNkUn2mgVRl6puTBmQZejp+CWz/FV/Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737645; c=relaxed/simple;
	bh=xgOUEainzvC/6jIBGZeJxPEY8W5Q0ilxOFYSAg9NfHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeVLMvTbWqGqo9bHV1bHX4ODbqPZxxNmMasSJ0Ul7KINOJaHo1FurLn4MQ0jkXWlSrJ+pEG3mQj0biy8yv68qUM1Wc7QhYHvKVG5Dthv4MNnRhTAx7X3TDZfVsnhYHxZYYp/KjNg6zHInLvpM6JH7q2W03Qk+7NX7Eu5gQDscus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gPvYtsHF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gPvYtsHF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/4+n+CR2UmtKgGxwlDut5ZBPU+ASpzlgAMgEi+Q2bfs=; b=gPvYtsHFVrmPSWlXVslNg/jdMv
	IxQl0ihKRqCny29f4IHt0IaEIK4msTDBcDGxdAEcv0UTnWRqVaM2uzgo8mdSJbDAlGru8T5Z/BLrB
	ethEPggakOSNNfDtPz1XA1OADgRy1fOQwvAcjGbHMJAJ+CgfyiELZnIXSsvs+jgcHVpuAu+7bZ5fr
	mqoXObMrCrLykNnXx+YMqMw6sswXMpoatYUUsdu0s64wZ/HBD4Zm6S0ttxbFL9RtDwSsDr1MlyiAh
	FSEg5Ijl93x7g/obbV1qNTwDVmM3lGJc+aQY8eO2HKBFGxXShHYJZbOVMAUC+TxMFBO0QSuPyubB1
	HxGclHLQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHbU-0053rG-2F;
	Sat, 13 Sep 2025 12:27:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:27:09 +0800
Date: Sat, 13 Sep 2025 12:27:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Fix incorrect payload size calculation in
 psp_poulate_hsti()
Message-ID: <aMTynRWJVA5Oovvs@gondor.apana.org.au>
References: <20250903131642.16798-2-ysk@kzalloc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903131642.16798-2-ysk@kzalloc.com>

On Wed, Sep 03, 2025 at 10:16:43PM +0900, Yunseong Kim wrote:
> payload_size field of the request header is incorrectly calculated using
> sizeof(req). Since 'req' is a pointer (struct hsti_request *), sizeof(req)
> returns the size of the pointer itself (e.g., 8 bytes on a 64-bit system),
> rather than the size of the structure it points to. This leads to an
> incorrect payload size being sent to the Platform Security Processor (PSP),
> potentially causing the HSTI query command to fail.
> 
> Fix this by using sizeof(*req) to correctly calculate the size of the
> struct hsti_request.
> 
> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
> ---
>  drivers/crypto/ccp/hsti.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

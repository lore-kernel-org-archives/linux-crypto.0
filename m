Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EDC2D057;
	Wed, 12 Jun 2024 07:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178432; cv=none; b=cdlYVYa/HLhxW0QtR6I00NmLxa4aivlrskd0+cYfdNny8vWvlrGRTD06VlKW0S3pzbgEJsPRXPvUp/PultN9ZzW1+ASuPMoT9BTp+cVdRDtXg6Zo0f+blSEgxugObbO7rqnS8sLZ86+CGakZ5i71ggKAjBM45AGsgu7Jor+one0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178432; c=relaxed/simple;
	bh=qIhFVGfYbrAWyqFxwk3mP+eTtKX4fdA6gEBiMAtbk38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+3nAEo2eRosCIh44PMWQhCjkZkn+7cmJPxEMndAXu3l0N03Bk48rkcsIrTTue84029wmyN7qhbeersP7BcRr3SPqm1q1EjPcchyWsCKDuHMusgVZ+wP2x9cTM07diqLloXTNiopJNx4FDwMXaHibJUkeDqsr6vsGud60YcDC+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sHIh1-008NgN-13;
	Wed, 12 Jun 2024 15:46:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Jun 2024 15:46:54 +0800
Date: Wed, 12 Jun 2024 15:46:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: JiaJie Ho <jiajie.ho@starfivetech.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: starfive - Align rsa input data to 32-bit
Message-ID: <ZmlSbtYjvz7LAeTn@gondor.apana.org.au>
References: <20240529002553.1372257-1-jiajie.ho@starfivetech.com>
 <ZmLsK9Apy9NwNEQi@gondor.apana.org.au>
 <NT0PR01MB11824BA0DD4F7C638A91E80C8AC02@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NT0PR01MB11824BA0DD4F7C638A91E80C8AC02@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>

On Wed, Jun 12, 2024 at 02:58:18AM +0000, JiaJie Ho wrote:
>
> Can I fix the buffer length of the pre-allocated buffer to 256 bytes instead of
> the current variable length buffer? 
> 
> -        u8 rsa_data[] __aligned(sizeof(u32));
> +       u8 rsa_data[STARFIVE_RSA_MAX_KEYSZ];
> 
> That's the maximum length supported by the hardware and 
> most applications now use rsa2048 and above.

I think that's fine.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

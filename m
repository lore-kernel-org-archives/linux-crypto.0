Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07811B6CEB;
	Fri, 15 Nov 2024 12:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731672849; cv=none; b=M8MfxaZzbSxKEiaPXFSsE88biyK6zEGE4Bx7gOlSjMwRcCfY584Tip6uGD/uMOuDfa0yyc+4yqSblm+oExjK43rYtC9LpUp/FcWMrQLbGv1ZvTanX7y4LH8cBB3nPeYw5dldhac7CZwvbLlsERu/SeuVg8ISQWkR9TjxjtkWc4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731672849; c=relaxed/simple;
	bh=5W10Cmgrtn9Pp9DflyOpxWecK2bzed5ldyBLIUT5CVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZynpI8Dk3ElZ9ek6vl9Kj0POKwRus6N6ONhACSkLT3BvPwHs6eC/Jspc8+SWcVqzSuzuXogKrsPgusz28cCTkuMm3lHlUnLd1qtRR3ku1RPSR/elQSRcrZt5/PQspuBwDT5fMLO59cnRRpv7/XPtuhAy381wugGmZ2TzJ6C60d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Qkg0bGC1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Qkg0bGC1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g3VVt/Brr+8QKmrBXLkiRTjW4xGcF4tDu3WzQ8jSGN0=; b=Qkg0bGC1ijoSHQM5VWwANbK3Ay
	OYe5+fAJ4mf5YccWGenE+Go+H1BvqLycCCNrPpd0ph5B9PBBFeIs5C9MHc7O24F4ufEeJiaojXEO0
	7p6o8GH7AoIgSxcLQAVMOapCPDZq7L6pSnSEG9+mP4NTjPG5rWqnJRsyE7ZwQTwexIGfOachs87U7
	yuBim8gJtzbtCajlfVr1/y9oAW7HtmvqcDDQbY7J+W8LfuP2dKZZIVeyrFembpCZqDZjBEHvm4y6c
	8Csh9GG9lEc6dtNemBIl11Qy0ptxxsbzI7yACUxHaV5CscijJRQaHuBSK1TKu0PHULxw6prNF/iee
	qIU8BYyQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBvD1-00H2AB-15;
	Fri, 15 Nov 2024 20:13:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 20:13:55 +0800
Date: Fri, 15 Nov 2024 20:13:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karol Przybylski <karprzy7@gmail.com>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org
Subject: Re: [PATCH] crypto: marvell/cesa: fix uninit value for struct
 mv_cesa_op_ctx
Message-ID: <Zzc7A2ZoTM2gQyxe@gondor.apana.org.au>
References: <20241110185058.2226730-1-karprzy7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241110185058.2226730-1-karprzy7@gmail.com>

On Sun, Nov 10, 2024 at 07:50:58PM +0100, Karol Przybylski wrote:
> In cesa/cipher.c most declarations of struct mv_cesa_op_ctx are uninitialized.
> This causes one of the values in the struct to be left unitialized in later
> usages.
> 
> This patch fixes it by adding initializations in the same way it is done in
> cesa/hash.c.
> 
> Fixes errors discovered in coverity: 1600942, 1600939, 1600935, 1600934, 1600929, 1600927,
> 1600925, 1600921, 1600920, 1600919, 1600915, 1600914
> 
> Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
> ---
>  drivers/crypto/marvell/cesa/cipher.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

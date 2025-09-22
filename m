Received: from smtpfb1-g21.free.fr (smtpfb1-g21.free.fr [212.27.42.9])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2C1EACD
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 06:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758521985; cv=none; b=Qy7l15WTSl01ISKUad8hXbNyGz5FDUddGkXT4FaBkoHKuLv85blqfJ9MCetaw2X1OTBkMjprNeGk5LNnXdUzwLnGm0z8/ei+1UzrsxYmOsHyQZ7geIcansBKFPdJyWVVTd4HHA6MLYlDKIDvgLCzBPS2z38RFOMFJ1HL4z/1yQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758521985; c=relaxed/simple;
	bh=JKIblEM51Z7G2yJeg1kz+6UanHJ/lGxaFikkIsQVuQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kzJKkXrisaGJWe2nqbF/KGo09vlYhW9/DNI1NZt/r8QWWMw3kYoqhSaHFN5c6LfUAwHqs5EUexughixG1YwkXNAeYRnugXAFTLW3dL/24b5O8sO4CWzC1vMGTvZ6MyV2vdxNs/Njx1eRg3g0h7PZ+3kqQiqgS80RIJv++LwM2r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=droneaud.fr; spf=pass smtp.mailfrom=droneaud.fr; arc=none smtp.client-ip=212.27.42.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=droneaud.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=droneaud.fr
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 59D9EDF8784
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 08:19:32 +0200 (CEST)
Received: from [IPV6:2a01:e0a:263:a640:d1:87bf:b1a6:8517] (unknown [IPv6:2a01:e0a:263:a640:d1:87bf:b1a6:8517])
	(Authenticated sender: ydroneaud@free.fr)
	by smtp6-g21.free.fr (Postfix) with ESMTPSA id 2B061780331;
	Mon, 22 Sep 2025 08:19:17 +0200 (CEST)
Message-ID: <51375fee-f3be-487d-8384-a2f07600d578@droneaud.fr>
Date: Mon, 22 Sep 2025 08:19:16 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: drbg - drop useless check in
 drbg_get_random_bytes()
To: Sergey Shtylyov <s.shtylyov@omp.ru>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller\"" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Cc: Karina Yankevich <k.yankevich@omp.ru>
References: <35bd2eaa-3cb2-481a-a02b-79fa1bc98016@omp.ru>
Content-Language: fr-FR, en-US, en-GB
From: Yann Droneaud <yann@droneaud.fr>
In-Reply-To: <35bd2eaa-3cb2-481a-a02b-79fa1bc98016@omp.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Le 21/09/2025 à 22:33, Sergey Shtylyov a écrit :
> Index: linux/crypto/drbg.c
> ===================================================================
> --- linux.orig/crypto/drbg.c
> +++ linux/crypto/drbg.c
> @@ -1067,8 +1067,6 @@ static inline int drbg_get_random_bytes(
>   	do {
>   		get_random_bytes(entropy, entropylen);
>   		ret = drbg_fips_continuous_test(drbg, entropy);
> -		if (ret && ret != -EAGAIN)
> -			return ret;
>   	} while (ret);

} while (ret == EAGAIN);

return ret;


-- 

Yann Droneaud



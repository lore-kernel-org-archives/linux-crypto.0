Received: from mail.mleia.com (mleia.com [178.79.152.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493BA4207A;
	Thu, 19 Mar 2026 20:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.79.152.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773951101; cv=none; b=RGiBIGUKXp+Sx6YTtGU+9Z6ZzfAT/8e70X+f9jVVwTixFd1/T0DwpM7hehkIT7d71tWFujVHdUMdQaFbaZL0/VYQpI7fBqyVySokwra2c9+N6KAI/p0lnlqs9MHqWGOT40G0YDWGk1HVxyvPAQt+Ucr+SzzxxqYRWHwzGiWWvz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773951101; c=relaxed/simple;
	bh=2ZMfgru5e+oaaVUtTskdQMdWf7MszLERUhG3AuSPlNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SzNpJyEhIi1d2wz7RHaiFuh+gFdn4CrKitFrkBbqX/d9ED5eRfHDrA5m+bvW4VP0cJDBaGMTPUwdM2o0BnlIQnW6loDeYfiRagY0m5ZLJ9zzh4DPFyzywyn/myARCj08Cr1vS+1g/xJLkL+6ppdno5jWjBEvXd6a7mDCCzjILOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mleia.com; spf=none smtp.mailfrom=mleia.com; dkim=pass (2048-bit key) header.d=mleia.com header.i=@mleia.com header.b=sD12KLNB; dkim=pass (2048-bit key) header.d=mleia.com header.i=@mleia.com header.b=YmOmkxvJ; arc=none smtp.client-ip=178.79.152.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mleia.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mleia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mleia.com header.i=@mleia.com header.b="sD12KLNB";
	dkim=pass (2048-bit key) header.d=mleia.com header.i=@mleia.com header.b="YmOmkxvJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mleia.com; s=mail;
	t=1773950562; bh=2ZMfgru5e+oaaVUtTskdQMdWf7MszLERUhG3AuSPlNc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sD12KLNB/moWCavZypcj/p7C/JEM+sHHgLusfDwHVus7ODDdVE/WfxndwBFrxU/7i
	 gxTl19vjz6T0ofPe77MnajxyhOMxFy8disY/6uwxApo4zEPLcoio/qtLlThU050YoA
	 fWdQ36DvLTx7z8wy/EDLUXDXVMoUoeZHPLFNvNI8LqRxybl+Xqkev6ln1n5VWA8f/i
	 Q3/rjercZyO/FO36yyziUOSRpjrZfiASwZgE9+VwL2B+/EI0QqcxgEs6P4nqG+OXqA
	 DLFNc4jhEjYLb9ihgxnIImKsv64QoPn5G1lj+ybMa3UAwRc37EFsEclOH49L7FoVA9
	 ipCYTy47LACVw==
Received: from mail.mleia.com (localhost [127.0.0.1])
	by mail.mleia.com (Postfix) with ESMTP id 1A48F2E;
	Thu, 19 Mar 2026 20:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mleia.com; s=mail;
	t=1773950561; bh=2ZMfgru5e+oaaVUtTskdQMdWf7MszLERUhG3AuSPlNc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YmOmkxvJ42zO7xx/x846/tUjtNrTNcsNjorj2mFKTysfYssaqluQwx5gxPXEPHU/G
	 iFb9D4efRGqMfrd+8zZ080Kme9e3vrSlvuI6osRzqCFb7/szBKGcfxDPJXCOBVGnuV
	 VLrfs7i4OBSTdDuKNjYAl39SpSwXMSR2RaWEsW5mI6N8+sLax6uyg9NSJLaT0jV+hG
	 OrzDVtSurAmin78oL+f09X/c67F7YAAoB6+DHHpL9BKpKSyDr8F/UWOeb4VlC2cycU
	 0cH/e5yoL+dkChCUvSs0gkqYjpZkjWvhndm/fq4Nd5IWZaooqgk8SZFogBqVkYlQMd
	 M+X9CIYnd/Pvg==
Received: from [192.168.1.100] (91-159-24-186.elisa-laajakaista.fi [91.159.24.186])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.mleia.com (Postfix) with ESMTPSA id 9E6FE2B;
	Thu, 19 Mar 2026 20:02:41 +0000 (UTC)
Message-ID: <f0aad48c-3ddf-487e-9514-933851b2368f@mleia.com>
Date: Thu, 19 Mar 2026 22:02:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: s5p-sss - use unregister_{ahashes,skciphers} in
 probe/remove
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, linux-crypto@vger.kernel.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260317080450.1054742-3-thorsten.blum@linux.dev>
From: Vladimir Zapolskiy <vz@mleia.com>
In-Reply-To: <20260317080450.1054742-3-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20260319_200242_123877_E61D40BC 
X-CRM114-Status: UNSURE (   8.42  )
X-CRM114-Notice: Please train this message. 

On 3/17/26 10:04, Thorsten Blum wrote:
> Replace multiple for loops with calls to crypto_unregister_ahashes() and
> crypto_unregister_skciphers().
> 
> If crypto_register_skcipher() fails in s5p_aes_probe(), log the error
> directly instead of checking 'i < ARRAY_SIZE(algs)' later.  Also drop
> now-unused local index variables.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>

-- 
Best wishes,
Vladimir

Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794502257;
	b=EZ/xnalr23p7MeR6hScTccqVZQNpD1IzpLFmmDv4gQT8EKtXZsNbXr5EljFaOdCEOriS
	 TPIZVGt9AeStyv3qq4InKBT+8iDuXcABKuLvQPPdwAm/6ERqg8mwgFLdDmK1+5dadTaso
	 cJ8apxp/Nx59zVjtbgGsHn9WcHRx/5fNVONIOMwliS1xDPz6S+1DfeA4iExkyjyFxtQu7
	 STLaAYmhkL6thOQpfg3uqD5GiOnl+KBrXItovNu9DP+4az5gb8z1LTMI33QPTMuHEXFzf
	 CwaF/28sKQgeM1xJjWco3D6aTCu2cUWOgCIXRmwEUEk/xECaVcIaaW2iCXH0f6bhbMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794502257;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=gHwrDH/ZnFCMtCuW0Bxl8D26GneDkevFTs6MbVw4h4c=;
	b=ZU/abMAXel3KVbueWx7TyqehGn3LKcIK5ogoZByTDPjgxMCaY8PDKR9oB5HDQXrnsQbF
	 x82FZbeJXY6OCxKcyooizcLp12pADaS/VpuIECHaLCMNmPjokFXDRLu9nU/oeE5HIJTrA
	 VF4/U3fvFrNxGWF46+S67XYyt2r9zmxXRUUyE4XB6Vu5sFJ8q0Mqn3WYvC/t1rYbJAF6m
	 P+WJRBHyOBmuag0wqqQNawuKuEwHs1ETmv1pT/qalwTCEKrNnnhW8a/sEy+mne42z3odk
	 PaV0AkW6HLIYCL2JjIZxUIe9Sfh9jzJseCSV/TV7N1yJJx9AWt4MQwO/153zr8Qg2xA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zx2c4.com;
	spf=pass smtp.mailfrom=zx2c4.com;
	dkim=pass header.d=zx2c4.com header.i=@zx2c4.com header.a=rsa-sha256 header.s=20261015.g header.b=XK7VrAMR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB79A606A321
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 16:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB79A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=zx2c4.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zx2c4.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.a=rsa-sha256 header.s=20261015.g header.b=XK7VrAMR
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c50933bdf4bso5218066b.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:50:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794502255; cv=none;
        d=google.com; s=arc-20260327;
        b=r3I5s0shcbeb8mU1JI+tvuPXj2uGtQHUIfQrwF6gMJ86rwPFe6V3HxHPxJfzB1qYnj
         ySwH+4099ZhdZz069Gng/TmDla74zUfE6uYQemndQWZWQErdZtve9QH58LaTQ8hFF+oi
         qsR3p6L/oNXYcjcsdvp613hBOV5pXEmkuCsZes7DQfnscrCykm84qRLaIapQNI43N4CE
         dl6Myj3n09rDNChcjR+fOm1CVYE0c3Zd8xNbkdYBqm7vsIWQXLp4Up+IlH6K3dIvKF6G
         eP6jfivJWMJYIPESGFFngXwUgF0CiLljmzMQLmMUKXeHUl/rRroFT754yWCbQPyFlDY+
         qNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gHwrDH/ZnFCMtCuW0Bxl8D26GneDkevFTs6MbVw4h4c=;
        fh=r/UHqmsHg180jgsU9QPvJBmdsT18JMBkuxpzF5BuA7U=;
        b=Wgs5LmwXXXQJmQHzrk3c61u8HLgSzXFu/V5zuIP35SQyZyfF+wlaKFtGpYRNgr+l24
         rMvV3iRBh7A8DqadfvTr2UV6NftAgoPsvJQ0gwSfJGZA4zac19AfpUmmWu/KRI2Q9Gi/
         d/+qui2mFccPl7xw17TzvgeAdbnnIEGcTF+6IkGf6QlhNGexkrtpnpZscnEjKaG9OC0I
         1km1G7D5pCjyoDaHrx8cdbeuzIfTmpPPuYprIjP+8BY7Ew87ErY81UtFgPzKMQitHUmm
         9j5qXjVni81yP6Rkm1AWXXzQzWDHHat6escGtZlKY/sf8zLNfR451e5ickQh6469gZM+
         v8Sw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zx2c4.com; s=20261015.g; t=1794502255; x=1795107055; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gHwrDH/ZnFCMtCuW0Bxl8D26GneDkevFTs6MbVw4h4c=;
        b=XK7VrAMRGXVygTz26FHuuhKCitQZEZzdSsVj2ff4o/+beSMkdOq8PZIcXFQg/HzxVl
         QLbfvTT70ICD+6583VxuKG6XVNrW5kxGtkfyFTyxfPKU4m3hfwaRGBYqaeD7UvxdMLSL
         C1JCfM4MIt9i0slelVZVmYcitJKGcUm77UhLMeYte//IiKhVhz/fyC29s+ibQAgW16YY
         Vln/nVhs+elGt11mKEP3mTDwXj1iLqQozIoyMAP3a4nv8Cu2me9dZw43Uz3Y3Q5KAghb
         uRCTbydXAED505mbh+e2JqSj2sJdgJR1l2Xs7rrjn6ahQ1W6TfXkd6+7vdtxoD4jvWYu
         Q9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794502255; x=1795107055;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gHwrDH/ZnFCMtCuW0Bxl8D26GneDkevFTs6MbVw4h4c=;
        b=aR8Ajuq94KeHzTBJIBNa4YRUrjI5nbQ/q5tNn9E6LgPCVQE/v95TvUy2KxGAJq3YO0
         K+pfeO/E9hVLctrktltpsbzKKLl1wV6aogLRGYsRusK3nGRZUpA6x6MW9IiX4pNVNDe9
         Ny/wPY3Hb2NaZjCS0uyL6v8aV6KOs0wT37lqp5ivL4bTvU8z9NYu9c3WjoY8H2V0LyiX
         KLY4Ea03zAr02k+je4A/m/usPdsNlDbNYhJyv8BLOuKlDLJc89IUay9Jsy3uuF1X4sRW
         nnzWOn+LVPnCzlKAij51zZYPtDvAlH7lMfiBOBFQ+vhdvuj1BqPjNalrjMDsDwipm9VY
         RuQw==
X-Gm-Message-State: APuU4Z+Mfo7t/T9sSaqUaQYV5C8LU2sQ8NRcQvrikENtzUQ8QWD2mxi6
	hjZrMi7iS2m4d/9IWrqrn3lclcYVTKz3UtQmiWgMbxvh4ky+c92fONjoSMPoU0H+8EwUftB8skD
	6WvDBxJ8BndXiu3MTEXwz6LlziS3UOKcuHDxBGMnAgus=
X-Gm-Gg: AYBFou16TpPtmyr1kK3Lz0YgmI0SRmk1OluyxZfbrXm5wOBU8F2MQsfMWaKTLNcXZE5
	JsVpG8ujJakD+jHuK6mhMqQms9g837wH2OxDVYiS5VdgdOp+nVasvqtnLEKdwxxkx+gwci2YAD1
	TK69I55sKgCAri9tOVPO4dKHQjNkHZxe52kZLInC+E+bfZkXR32E5LUkUp2Tsn5HxtKB0haCmPD
	7Wmr7j+m04PtiGDjhjys4n+u15tPAwoS4xSSfGog/r2fONMxYn4XG20txeALY0hWDksusdhAtYd
	jxBlHkRN5f9h6niR9c8elRTiJNSeElWDuCZ6bXbZtcFhOKmQ895oXbqK5QnRVJdX6JVyB/3Ul65
	MLcuFM0RkHBnzCfWw8wie2TPCiLuf2qVy1E06asDShRTR8XUOsiqxX4Je0nJwdF68WP3uHHanCZ
	TRMR2oFwjImdKoqY1bTNzoZYV3hyKyoV5ZG433+oW53Lv5hHLr7Q==
X-Received: by 2002:a17:907:3f11:b0:c41:825d:ed8c with SMTP id
 a640c23a62f3a-c507c44d1ebmr309601666b.26.1794502255264; Thu, 12 Nov 2026
 08:50:55 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112125432.3064939-1-antonio@openvpn.net>
In-Reply-To: <20261112125432.3064939-1-antonio@openvpn.net>
From: "Jason A. Donenfeld" <jason@zx2c4.com>
Date: Thu, 12 Nov 2026 17:50:44 +0100
X-Gm-Features: AclHuK_GbEckd8o4r-SaoEsceK_OZ_MorUs0cEwJ8GQNa8toyJK78p3Yl1-YlCY
Message-ID: <CAHmME9rvjyPiDTsHKMdy7p5-pkWzgW8U-G+HTN=BNJBh-H1suA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] lib/crypto: Add AEGIS-128X4
To: Antonio Quartulli <antonio@openvpn.net>
Cc: linux-crypto@vger.kernel.org, Antonio Quartulli <antonio@mandelbit.com>, 
	Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 1:54=E2=80=AFPM Antonio Quartulli <antonio@openvpn.=
net> wrote:
> through the crypto API, the sending CPU spent 1266 cycles per packet with
> AEGIS-128X4 against 1448 with AES-GCM over TCP, and 1032 against 1122
> with UDP GSO input. It is posted as an RFC because ovpn can't use it
> yet.

12.5% and 8.7% speedups over AES-GCM are sort of way lower than what I
would have hoped. I suppose it indicates that most of the expense
isn't crypto? Or that the wins aren't really realized on 1.5k packets?

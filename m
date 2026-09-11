Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFD33DDAFB
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 18:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789153026; cv=none; b=sQRL7m0smly/ri7Mv8Tuole94nSw9giG/hQY/hsfeftKzJ7S8xrwikgCC8fFEATP9tqdfjovIc+TuvLw58KAzlA6QuptB1lmPCHUJfIjlZmFDbWLLEAFHtw0Vf5nw+SooYWL27JBk7OgqTA9iqwvZ05BXo265Wb71nlTKw6jcwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789153026; c=relaxed/simple;
	bh=L6rh7PbU0UFjpOX2cNRwoGSW2b55d7SIpmhWyxZe2jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBzMSNcpvALZwHi/UsLRuwbRgkrSL0hrubrU+pk5nC6LY0tZKTlpkZaH+6UwidDFSshJAUt6Xku98OvEe0qAMyh41hvXs5u8RYHiSMz5wJUiqAC1/GvTxdBVC5roZ7Tnx1hiqoaenTwOztEHsmIkDtzoNz3VfJwBEcGu1qFbWJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=jnWmsfDH; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="jnWmsfDH"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-484366874b0so98103f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 11:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1789153022; x=1789757822; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Hh4sVlhxU5dBVP/3K7psJppy2n4LZjrwVn2yp2aqAe0=;
        b=jnWmsfDHjbwFsI/w5LaETScW3g2GoWP8DH3MNQ39LInxEQ45K9gykyqpHXNMDCvNdn
         oK1+M1kU+Dkx8M6mvJydhJqeupXg2bCK/j7tZdrpxAzZwwcefG0mho6WaSD8FKW7OEaI
         5HMu2LlpfcBle6t2IDRZ0q1Qs0bhBXsgxm0OsZzrLanVQgSaNIpAeW3pstCN466taBDI
         faEQp/aYTkWnBarQnFww1JSwnLD8r9dFs59GCVpH4calW7DzRgi5g47aRzOcbKNAG3uB
         8+T+5ArgFk9NgnfiV0XumTkidaW1eDExFDJxSG0qBHLQ6STsymzLfJJc0gK6updgxX1I
         OGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789153022; x=1789757822;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hh4sVlhxU5dBVP/3K7psJppy2n4LZjrwVn2yp2aqAe0=;
        b=I7EdPXtpN9ImaNhE0tX5YRtFylckLsU8TcHDs2OWoEp+Mbi0Tr1Ie+X81maLje4g2v
         9Vs/LDqMoa9nX4FBzzlvlSADa//CPXwqstR71rLU2u/H3tMrJM7GMB1e5Ss/EmSMyG6w
         ogt1VKojqMjjz+fg2SX0T6jh+3Ezfu5kd9QR/rFkmOTbKDsJ4wL550XLxuoDLTdRxTsB
         Nnk1eUdYd6BS72sBddGPMNwpZv2d15hIbPLOJmKx9L14gZBoeNNUIK0if+AF1d6rCF6R
         fDiupRrp0FqVfrvQWVkIwVxegLSc1D8Jv15hJJyYotTAA8cbjsTi1W2HhPd6+Un/NYae
         K9+A==
X-Forwarded-Encrypted: i=1; AKwUvBzO+hZYuyrIeSl9U5czhyLpLh897pdAhi2IsjWTZr4GiJ88pg7RVzj4uY7WJngNKV2sC9KRYuWKnSIUfXA=@vger.kernel.org
X-Gm-Message-State: AFuF++n9erdQqj+zs7UhRxF5LsEf9Hq3n/Mk67FeaySy2zCOxMvc8dTc
	1pDAWkfX7TJSMSUy+thIJPCaNMMoamCz3APPRyXop/AfogGSqb8piI+4d/8hJKAtOIQ=
X-Gm-Gg: AYBFou3H43VF/faOSRw2R7XfX2NlTKuIBVv+hSFuz/s6wW67nncK32bPXdJy6Z1OONZ
	BZ49rbEtOkX3NZjmIb4eVgeEO1bvL9LPD4tQdOLFhmN9ys/p2vzkTILJWthHAyH18vSqaRU4Us3
	Uk8Nc3NrPZNZlUYGrOB5Rr4Lqw+Ir6mZBe7yf1NRIWslUNKnXd3fsJbRsk4kgBFyZRngoru8vvB
	SepcG7CGGrJqIUX8f13WNtmcMWJfHCJRE3SZVaS3Er5eNwlxBSWMLaG+4v4IDYkKWo1SIDjvcUa
	iNxoOoBPhAUqpHWtJhcQ/f7C7s/VZhzdF9unAaIgPIeAOwpDZHB/kvxaEs7zO06D9IDosFvVRpN
	Q9eTxbgtQ9+C6lG04iV4DGS4ttR0ELCgzFcT/iwW2ShUQW9lSMzjquYL0CJ2HXyaRZCzIAlUlyW
	S5VJPTytl0IqqkMB5f+9erqog6aF7aCgc8XNiwhCsedZ5DrhqerNyhatBP+zUrCD8ZAPuP8simu
	VUy
X-Received: by 2002:a5d:5f49:0:b0:485:b169:54fd with SMTP id ffacd0b85a97d-486eb1d388cmr12205373f8f.4.1789153022414;
        Fri, 11 Sep 2026 11:57:02 -0700 (PDT)
Received: from localhost ([2a02:8071:56d1:2de0:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-486eb2ed0fbsm7924090f8f.3.2026.09.11.11.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 11:57:01 -0700 (PDT)
Date: Fri, 11 Sep 2026 20:57:00 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Stanimir Varbanov <svarbanov@mm-sol.com>, Eneas U de Queiroz <cotequeiroz@gmail.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Eric Biggers <ebiggers@kernel.org>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, brgl@kernel.org
Subject: Re: [PATCH v7 11/12] soc: qcom: add core driver for the Qualcomm
 Crypto Engine
Message-ID: <aqRNEJt5Wec4AeH4@monoceros>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
 <20260910-qce-fix-self-tests-v7-11-cdbd2718af14@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="joivlbaqnu5rwgfx"
Content-Disposition: inline
In-Reply-To: <20260910-qce-fix-self-tests-v7-11-cdbd2718af14@oss.qualcomm.com>


--joivlbaqnu5rwgfx
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v7 11/12] soc: qcom: add core driver for the Qualcomm
 Crypto Engine
MIME-Version: 1.0

Hello Bart,

On Thu, Sep 10, 2026 at 03:00:52PM +0200, Bartosz Golaszewski wrote:
> +#include <linux/mod_devicetable.h>
> +#include <linux/platform_device.h>

Please don't add new includes for <linux/mod_devicetable.h>. Either rely
on <linux/platform_device.h> to provide of_device_id (my preference), or
include <linux/device-id/of.h>.

> [...]
> +static const struct of_device_id qce_core_of_match[] = {
> +	{ .compatible = "qcom,crypto-v5.1", },
> +	{ .compatible = "qcom,crypto-v5.4", },
> +	{ .compatible = "qcom,qce", },
> +	{}

Please drop the commas for before the closing }. Also in my cleanups
around these device_id structs I used { } with a space in-between the
braces. Just today I got some opposition to that[1], but in combination
with the spacing in the non-empty initializers I still prefer { } over
{}.

> +};
> +MODULE_DEVICE_TABLE(of, qce_core_of_match);

Best regards
Uwe

[1] https://lore.kernel.org/all/45a04396-c6c1-41f4-ace8-0ee0ccbc50ad@acm.org/

--joivlbaqnu5rwgfx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmqkTvoACgkQj4D7WH0S
/k5B8ggArcjj6bNgFKC+jk74PuEqWNqnxp83hYq4YhCQ4nkN5btdBCTUHpvce57Y
tBLNeoqp+ogRIJDvTqZwBjB+3Gpn7Xaz5G0oW7tfOPbfQYrS02tXJbN4iR5v85Sd
9PrXSAOEjomDiJ5iCToEvNzs/NHzabEZ+IH721yYfCBsiUvd+nLYePUdzq9ICGij
zaKxkNLMiyiV5WtnuF19WfPsemVF8etJYThIiGfQ9vzFWAIRU2fgEW1XghxIC2/C
vVzujCNLI5VkWqgZDuB1UtSlLshJ+ZtT87nGphi1LWV9KVabXtsfPTdTFnHHyx8U
aAQtSnfF0SdPJaeWJMLNMGNHWcvaeg==
=3iTu
-----END PGP SIGNATURE-----

--joivlbaqnu5rwgfx--

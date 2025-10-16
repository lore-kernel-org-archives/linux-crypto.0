Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B227149C6F;
	Thu, 16 Oct 2025 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760640227; cv=none; b=LJ0dbX3HBVFVQXx7i7SZXBf3VF4n+KtDWhTtala7VdUhr8ZaCg90nCfJBdWbsyy9wG2gzkLyg9QKuG9XoLY7dH5eXpirLKbX3zSF2ht5oSykSAhnkqzm4S5LaunxY8z6WqFcFOWxWm6OnxB/GTEXATZcYprZNpUETqEa2TSHg80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760640227; c=relaxed/simple;
	bh=Q8orrl4MLzqCEwAfLl/l6Ptxt8k3EQam4gUEfueVYj8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=jyrcO3MJseNhMDfXXZx7mcBjLfvWH31EtuUZSkX5sTimBIFgRY5ijFtKnlmyuyQrryinfUdHGOf2AqvVXcXNu2AQrZq5MGeDckPBfTKodXK4NlBK0pZVqZbZQ5y3SOA8mKDfZtXrwUe+EyAlhT7LAaaNkvQd3vjfxm99bLof7Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=XJtKcZQL; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="XJtKcZQL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760640206; x=1761245006; i=markus.elfring@web.de;
	bh=CLGVfjGRycUohHijBK/kKmSQZMw+js4xognjhCwizcM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=XJtKcZQLwZxu5QNP2c7huxDgEsQdwE6Wds6U7ZDATeENpqS/93pKcczAUGsExNgi
	 TgCyQoNq13aPDWQBrJGTHxprHnfcQuEda5XqFZKGSBaHuiziaGRYt+yHtlWPmDjHR
	 pEeLWaGVMAqZhU2sLerflF6vMz3IwTOzM9SoQUoBYXr/nBS49gT+LLuE7Hknx9PJR
	 zKr7/ycCmm5hQU1jqXvDyYNMd9RAxt8V3HwkIZlprbvJeUwuRQkGflvi5kJMg7XhZ
	 wmUhJ9HNl8ZcJv5oxe/DNkXoUG4mLwbBKjFAhVkLJrrwWD4SMkZ9PEA1/aG+niKjy
	 Dm72BOMNk1kaBgiccg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.241]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MumJD-1uJ9Xa2ySR-015LwL; Thu, 16
 Oct 2025 20:43:25 +0200
Message-ID: <fe4d7cd9-0566-4d1b-97c0-91cc1f952077@web.de>
Date: Thu, 16 Oct 2025 20:43:22 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>,
 Manjunath Hadli <manjunath.hadli@vayavyalabs.com>,
 Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
 Ruud Derwig <Ruud.Derwig@synopsys.com>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Rob Herring <robh@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Aditya Kulkarni <adityak@vayavyalabs.com>, Conor Dooley
 <conor+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 T Pratham <t-pratham@ti.com>
References: <20251007065020.495008-3-pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v7 2/4] Add SPAcc ahash support
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251007065020.495008-3-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LK4z+ncE5zS8HB1UF5xsMBi3WgBv6O1bqjYXfpMNhAnEoJSZLh7
 OOcD1+tlTwXpELzhkMew3CSKDOaweupeDQHAne5UVlp7Ji+rhXoEoPboKNTJeirTIztREFW
 zh90wuFGAHKUJqcU2LxI837OBagSNFyyzV43iAzSBp++0uZGMVi2aCDP+VGrizbeI3mzR0K
 pHBgAPxtNiRWNB6Pa8gnA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:AcenHJOJSaw=;lD6a9dLOfQeOHc/Gfiri0k5GvF4
 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

=E2=80=A6
> +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
> @@ -0,0 +1,980 @@
=E2=80=A6
> +static int do_shash(struct device *dev, unsigned char *name,
=E2=80=A6
> +{
=E2=80=A6
> +	sdesc =3D kmalloc(size, GFP_KERNEL);
> +	if (!sdesc) {
> +		rc =3D -ENOMEM;
> +		goto do_shash_err;
> +	}
=E2=80=A6
> +do_shash_err:
> +	crypto_free_shash(hash);
> +	kfree(sdesc);
> +
> +	return rc;
> +}
=E2=80=A6

* You may use an additional label for better exception handling.

  Or

* Would you like to benefit more from the attribute =E2=80=9C__free(kfree)=
=E2=80=9D?
  https://elixir.bootlin.com/linux/v6.17.1/source/include/linux/slab.h#L47=
6


=E2=80=A6
> +/* Crypto engine hash operation */
> +static int spacc_hash_do_one_request(struct crypto_engine *engine, void=
 *areq)
> +{
=E2=80=A6
> +	tctx->tmp_sgl =3D kmalloc(sizeof(*tctx->tmp_sgl) * 2, GFP_KERNEL);
> +
> +	if (!tctx->tmp_sgl)

* Please omit a blank line between such statements.

* Can a kmalloc_array() call be helpful here?


=E2=80=A6
> +			kfree(tctx->tmp_sgl);
> +			tctx->tmp_sgl =3D NULL;
> +			local_bh_disable();
> +			crypto_finalize_hash_request(engine, req, rc);
> +			local_bh_enable();
> +			return 0;
> +		}
=E2=80=A6

Please avoid duplicate source code in such a function implementation.

Regards,
Markus

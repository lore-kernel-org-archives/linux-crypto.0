Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B5E296BD6;
	Mon, 30 Mar 2026 11:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774870580; cv=none; b=kh44NoUIFHScmLJSm0gcQVeoy2gXCwikjyuo1bgmjNWgclKFpEO53YaJQUVeiI7iFpZan+hF1PypnJpzHYI8Z0dgQN/R2r9ZWf2+9SsDErJ1kJPe/7tSdnS+6opXQJinftKMNHrpnimd1YU7ZTCoynlW6Elk6UzNzxqB8m3kJ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774870580; c=relaxed/simple;
	bh=m/yypgSy3gvluXK+bM8YRRytv4SNV2rgEUpt2OiVPHw=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=p34aJd+Gaha0a2omk1ayCOXSQpmNmsexvv127klDh3Z3p2fUpYgaqczU94KQzy/XBoVFCwV/0qG7ax76FuiLNHWVlBf8ZfloJOr0u1KjeY5qMPR3XX2talnNeID+fsPz0xb524Z7Vy85+ZcUJVk6t+jgaDZynRHE5av2fqlanko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=bIuSW1AB; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="bIuSW1AB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1774870562; x=1775475362; i=markus.elfring@web.de;
	bh=UR3jtSm0SxVlozfRvG0fs/edI07S6CbStADlAD21ugY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=bIuSW1ABJD0rDXLZ7N1qMmUDDN7jnxajGJORJzy6j0zLlHtWTOiwvjp6oSEbrPcR
	 B1zr+CfoEX6CcHJnYX2ywltv8y9xF7dJ6VakVYpURjO3W81WG46XnuXEts7gqKB5G
	 az0JjDdChqXAGaGrTxAXzDjb0nA+tinBhgvENuHBYCP1nevycMMnvU8gWlZGEPnlV
	 7yb0iTJeETikJZW4501U2fQxzX7mpK7VjOhVMNGi0AWo5X/IIcFsx2vFDhCGL5EOD
	 yb9uMxYWaoqoYs/596/X9yHCv7BAswgmtgHKfZGychZBJ0VP8XS7NC4Ak9eARtFO/
	 g56V4wFdB1OTeHDsfQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mt8kX-1vEX5n2hbt-018ETq; Mon, 30
 Mar 2026 13:36:02 +0200
Message-ID: <7460d990-f4c9-404f-958d-4e0287e7b347@web.de>
Date: Mon, 30 Mar 2026 13:35:58 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Gilad Ben-Yossef <gilad@benyossef.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Felix Gu <ustc.gu@gmail.com>
References: <20260330033402.2758074-1-lihaoxiang@isrc.iscas.ac.cn>
Subject: Re: [PATCH] crypto: ccree: fix a memory leak in cc_mac_digest()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260330033402.2758074-1-lihaoxiang@isrc.iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ENYhTy7Yx72WI7yWaSZ5XY60F3FzIxCJlMUN/6x+Xvywcjf4zSi
 8k8nJUxW1cPQNQ5NmZkeBoV59faCeG/WtnY8H40JQ0snI3rT8bcPM0nIchOxWOM424dBK4z
 2aZ14p+yMlwuipqgxdZEWB+6ih/bP+cMzMMg0pBYw2JY9NCCFsoKaURmTTrriAKoghWE6RX
 EI1ztAl25X+PXAqKn39OQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:J5/ZT/zdF6o=;2H4LgAJnv8FqO9EsjzFK2d+Eoo6
 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

=E2=80=A6
> +++ b/drivers/crypto/ccree/cc_hash.c
> @@ -1448,6 +1448,7 @@ static int cc_mac_digest(struct ahash_request *req=
)
>  	if (cc_map_hash_request_final(ctx->drvdata, state, req->src,
>  				      req->nbytes, 1, flags)) {
>  		dev_err(dev, "map_ahash_request_final() failed\n");
> +		cc_unmap_result(dev, state, digestsize, req->result);
>  		cc_unmap_req(dev, state, ctx);
>  		return -ENOMEM;
>  	}

How do you think about to avoid also a bit of duplicate source code here?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv7.0-rc6#n526

Regards,
Markus

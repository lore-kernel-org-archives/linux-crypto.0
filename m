Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A491524F;
	Thu, 16 Oct 2025 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760638543; cv=none; b=cq3kWtcAzT80A7kP+etBtCq9ZGa8N5kVLtcRNefrAJ1w6z3AibJv3ZfpSuU/HngGpqsw9MFh19oDpVG38/SEsu8tEJZ8UlPGx4M0h7kdZ8tXHsWw26/ZdYBvtjSo3zboJwfQGOA2FvwgiYde6HEXIPWUE2Fvn7+rLDEwYXOJp9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760638543; c=relaxed/simple;
	bh=9ipnBn6R/K5uBS906Sm2qu8jnw0+onBmj79AoAOVhi4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=VWePD7seLoI0VddO/PlyMTTTwTqRI2EFBlBu5+Bf3f4GhUVZjJA2Kkv7KC7SrnALc4DawtqjsTzerlf3y1b401JxOZzi27gKngbiIEwKmJ28CkWdorbtS3FiUHSnmKV+D6flckSS2fcM9dsKUiz4IpgU8NyaZE+l0HV9C2BcqFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=tWrmQdlG; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="tWrmQdlG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760638531; x=1761243331; i=markus.elfring@web.de;
	bh=3Z19zi7XzPzVMwXrlL0Ggjru4mYPU3wqqGDUcroY0UA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=tWrmQdlGYHUH+9aHQjXlF7s7Tylc2PfPVhxBO3ov96YIbSx1jfxd0JonnK3cLlp7
	 OtdjgjmoIITbQc+q69bCK2qJ8sv3aNuspJqIj+BUdupPTOARGfKF4Qpyjh6jp3/7B
	 rvkonyR+tLP6a/l0kJe4YmS6wSAgMNtNImzsZv0Xx28FbsqCo6P7ekFScvbD31EOS
	 oljhUMQnnpMXf7DD4b5geDybsYPbiINJeO0O1pH0woFTCbYlGHvmLZnzBXQ/9bvpN
	 VxLsspHLkXTYvozzvMBTbQxXp+X8eOSTUYq/o9d9nokUgciNQxDmAuOrc78rZ7ynT
	 x/HwtkzvT9C512fLqQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.241]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N1LsV-1uCW8u0CFP-00yjWg; Thu, 16
 Oct 2025 20:15:31 +0200
Message-ID: <9ba77ca2-7b22-44da-beaf-dc66801252b5@web.de>
Date: Thu, 16 Oct 2025 20:15:27 +0200
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
X-Provags-ID: V03:K1:bm7FR+umXNmlGn95lSlFd6DP9EQAIvtnWkD+jNwiJJLaCS61Ewu
 EcM87uEY9/M75EXKeDObpviUy+YHOsqW0R/bN8HEKYGydoiOmdNqrlUbYUmP0Gum00sas7d
 HDTvTyX0c+a6PlacYNn0UBK30+9l2h+09rK6EgAFW1PDH3lWMxrccBbu1KPWvijMu9qbxHp
 lrSyyNhUIsy6lEwlYroHg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:udKbVQ8NAg4=;r4a/TP0N7kwEzExb5OxWEe9S2gB
 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

> Add ahash support to SPAcc driver.
=E2=80=A6

Please choose a corresponding subsystem specification for the patch subjec=
t.


=E2=80=A6
> +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
> @@ -0,0 +1,980 @@
=E2=80=A6
> +static int spacc_register_hash(struct spacc_alg *salg)
> +{
=E2=80=A6
> +	mutex_lock(&spacc_hash_alg_mutex);
> +	list_add(&salg->list, &spacc_hash_alg_list);
> +	mutex_unlock(&spacc_hash_alg_mutex);
> +
> +	return 0;
> +}
=E2=80=A6

Under which circumstances would you become interested to apply a statement
like =E2=80=9Cguard(mutex)(&spacc_hash_alg_mutex);=E2=80=9D?
https://elixir.bootlin.com/linux/v6.17.1/source/include/linux/mutex.h#L228

Regards,
Markus

Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB495452A8;
	Tue, 29 Sep 2026 15:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790695142; cv=none; b=ncjgRhB1fNKPHszPaGETnniP5g5pj3iBDavtuUxDEShf5NKoeX+OKnYXcIR8yBf0OV0BBpMu/OnG710Q0OowB1HB5OgYMH4GPnWU5NZpxd7apmWu7W5m4viVhWIM0mPeaCLBgUzMfPGllfweWkEoH2NHPNpt8KxRbB8P56mlfvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790695142; c=relaxed/simple;
	bh=O930tpeFABHBb4nnHhak27rFPtGIwO/Okzm0IdZsSDc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=EA8tbqs9DWQuE7LRjxEV6mWdJAwSPJgQ/NWPyzD+Ap6X0AR/ebgwFNu6JYSrtPl0YUeENgUvcAaPtVg+gaQgHbhH2ajX2bEYvy8YkxbQn3zEbBfUTLKX6+F6G/1KfBgWbSFpnMQuPibwIkYCJGvMrXdVST0NYUBoDaZ9hrtApnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Z6mBi/Nx; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Z6mBi/Nx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1790695116; x=1791299916; i=markus.elfring@web.de;
	bh=uYv5XvJz5TWF9kjBW5oCopNM5BqPkBiMzKWpwbloe4E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Z6mBi/NxXKfrGd9QoMghx+Ik7bhokTMfafILoPgkP80M7Vipqw94YCs+NdLpwz3J
	 nosp1Kk2E3cUrSrQtnFb7Dy1bM1dXJlPpHl3EW9CfajLAzR7c0qBtzpKoreM/bJgQ
	 CcuZsxbSJAs7lz20tp+TscIJ0Bpv3fMNTzULVdkCNPRaSkCj6kw5Sc/sl2EA81Dh5
	 Z9NGfd+tuKBYGt55AwE3PulNnN/zBolYJvlpuZOcKCS8x3ypvbQJp6mk+vhnrA/be
	 XtYbZJLO7/jfsvM3oN34PcDnPKAnmT3EYPsN48f6M7yjuFqqVLxLpBAYwAKalHkkF
	 PaAIObqllWQsMZh5zA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MW9rM-1xDB5i0zxy-00U7Ww; Tue, 29
 Sep 2026 17:18:36 +0200
Message-ID: <8b4458b0-a3f4-4eb4-8b85-5d4139ac3ae8@web.de>
Date: Tue, 29 Sep 2026 17:18:29 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Fan Wu <fanwu01@zju.edu.cn>, Song Li <songl@zju.edu.cn>,
 linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260929143825.21349-1-fanwu01@zju.edu.cn>
Subject: Re: [PATCH v2] crypto: ccp - Fix use-after-free in backlog cmd
 advancement
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260929143825.21349-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6WTuJhQlJtTB2T4Vk/CEsBN4OvgvFYh3kThzY0esEE0UKEVj17P
 aO3GaWDxfxML8WdQXE7TE2o21WQFzquzZpgd3gqJY61At9bUMfZRDltGv+SiZVhpkNSVSDs
 JhhtUzRgAyyeABRDG8SPsPVrWUZCNR16S1in8YLShaKhYJKdZg4iowMFN/pUyGfRZ0bg94C
 hhHBT4FbaSFw2LEI5EBCw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ooj3BXv8Jfk=;JAtIQNBkolcKNU2jNHhwnpf6hVJ
 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

=E2=80=A6
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -177,6 +177,15 @@ void ccp_del_device(struct ccp_device *ccp)
>  	write_unlock_irqrestore(&ccp_unit_lock, flags);
>  }
> =20
> +/* Prevent promotion from waking an idle queue during teardown. */
> +void ccp_halt_cmds(struct ccp_device *ccp)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ccp->cmd_lock, flags);
> +	ccp->halting =3D true;
> +	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
> +}
=E2=80=A6

May lock guards be applied in affected function implementations?
https://elixir.bootlin.com/linux/v7.3-rc5/source/include/linux/spinlock.h#=
L642-L645

Regards,
Markus

Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901A13A8F7;
	Mon,  4 May 2026 19:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777921326; cv=none; b=hDFWT9fmdw8JXE5/CCasz1uJeOmmM0qlZDqZxnHAa4nxAqrn9K47FnRZR3LrtgH7P0canvwfLTZ5v5AL90ySX5v2lKt26ApGeXl7X+64UtdQKN5fwFqA28aNxf+7QnSacoDmoWtyukA0UrwzcoRSOKoFmA3FMMVfrKCRbn4oh0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777921326; c=relaxed/simple;
	bh=iWe6Y+xyF45vq/FxdmErkqhFwGiMJTev/y2U1X58V5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fdwGML9rikC14X5Uc5H1xcMHLsnxFDi0t9pPtkgRxZC8ymMeuxHaMaAV90EO5jFR008+DE6a0++5XYszntjB9p7AZ5avcrLRGYeLYMrsDCbQynyGWXbfjnr5jxkHxXL9SbKnraRWuw37Xwaigq+hEzdwcq2VhNEFPEtpAeX6aFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [IPV6:2400:2410:b120:f200:9e5c:8eff:fec0:ee40] (unknown [IPv6:2400:2410:b120:f200:9e5c:8eff:fec0:ee40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id 821B53F209;
	Mon,  4 May 2026 21:01:51 +0200 (CEST)
Message-ID: <f3203014-9e0b-45a6-b031-5b7487e82ff2@hogyros.de>
Date: Tue, 5 May 2026 04:01:47 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: AF_ALG hardening
To: Eric Biggers <ebiggers@kernel.org>,
 Demi Marie Obenour <demiobenour@gmail.com>
Cc: Jan Schaumann <jschauma@netmeister.org>, iwd@lists.linux.dev,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
References: <87se8dgicq.fsf@gentoo.org> <afL-QhLfEKqHZqka@eldamar.lan>
 <20260430071917.GB54208@sol> <177abb5d-8ba9-4bb9-8b23-9fbc868ed3cd@gmail.com>
 <20260501180028.GA2260@sol> <19837ef5-e5b6-45f4-8336-3ce07423dfb1@gmail.com>
 <20260501201841.GA2540@quark>
 <c13dd3c5-ddc1-431e-bc7d-2de39c551f8e@gmail.com>
 <20260502033556.GA3872267@google.com>
 <3cc88b2d-fbd6-4e47-b82c-3c685fec0581@gmail.com>
 <20260502191618.GA229884@google.com>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <20260502191618.GA229884@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------q1oQOYyvhcOSm25Vdun1tSMD"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------q1oQOYyvhcOSm25Vdun1tSMD
Content-Type: multipart/mixed; boundary="------------NvQBh5VzbAkqfAvF1Z143Y0b";
 protected-headers="v1"
From: Simon Richter <Simon.Richter@hogyros.de>
To: Eric Biggers <ebiggers@kernel.org>,
 Demi Marie Obenour <demiobenour@gmail.com>
Cc: Jan Schaumann <jschauma@netmeister.org>, iwd@lists.linux.dev,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <f3203014-9e0b-45a6-b031-5b7487e82ff2@hogyros.de>
Subject: Re: AF_ALG hardening
References: <87se8dgicq.fsf@gentoo.org> <afL-QhLfEKqHZqka@eldamar.lan>
 <20260430071917.GB54208@sol> <177abb5d-8ba9-4bb9-8b23-9fbc868ed3cd@gmail.com>
 <20260501180028.GA2260@sol> <19837ef5-e5b6-45f4-8336-3ce07423dfb1@gmail.com>
 <20260501201841.GA2540@quark>
 <c13dd3c5-ddc1-431e-bc7d-2de39c551f8e@gmail.com>
 <20260502033556.GA3872267@google.com>
 <3cc88b2d-fbd6-4e47-b82c-3c685fec0581@gmail.com>
 <20260502191618.GA229884@google.com>
In-Reply-To: <20260502191618.GA229884@google.com>
Autocrypt-Gossip: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT

--------------NvQBh5VzbAkqfAvF1Z143Y0b
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGksDQoNCk9uIDUvMy8yNiAwNDoxNiwgRXJpYyBCaWdnZXJzIHdyb3RlOg0KDQo+IE9uIFNh
dCwgTWF5IDAyLCAyMDI2IGF0IDEyOjUyOjU3QU0gLTA0MDAsIERlbWkgTWFyaWUgT2Jlbm91
ciB3cm90ZToNCg0KPj4gVGhlIHNpbXBsZXN0IGNoYW5nZXMgSSBjYW4gc2VlIGFyZToNCg0K
Pj4gMS4gR2V0IHJpZCBvZiB6ZXJvLWNvcHkgc3VwcG9ydCAoc3BsaWNlKCkpLg0KPj4gMi4g
R2V0IHJpZCBvZiBBSU8gc3VwcG9ydC4NCj4+IDMuIE9ubHkgYWxsb3cgc29mdHdhcmUgaW1w
bGVtZW50YXRpb25zLg0KDQo+IEZvciAoMikgYW5kICgzKSwgeW91IGNhbiBmaW5kIGV4YW1w
bGVzIG9mIGRpc2FibGluZyBhc3luY2hyb25vdXMgY3J5cHRvDQoNCkkgdGhpbmsgd2UgbmVl
ZCB0byBtYWtlIHVwIG91ciBtaW5kcyBoZXJlLg0KDQpUaGlzIHRocmVhZCBpcyBhYm91dCBy
ZW1vdmluZyBhc3luY2hyb25vdXMgaW1wbGVtZW50YXRpb25zIGFuZCANCmFjY2VsZXJhdG9y
IHN1cHBvcnQgZnJvbSBBRl9BTEcsIHNvIGl0IGNhbiBzdXBwb3J0IGxlZ2FjeSBhcHBsaWNh
dGlvbnMgDQp3aXRoIGtub3duLWdvb2QgaW1wbGVtZW50YXRpb25zLCB3aGlsZSB0aGUgb3Ro
ZXIgdGhyZWFkWzFdIGlzIGFib3V0IA0KcmVtb3ZpbmcgZXZlcnl0aGluZyAqYnV0KiBhY2Nl
bGVyYXRvciBzdXBwb3J0IGZyb20gQUZfQUxHIC0tIGFuZCBhcyANCmFjY2VsZXJhdG9ycyBh
cmUgdHlwaWNhbGx5IGFzeW5jaHJvbm91cywgdGhpcyBhc3BlY3QgaGFzIHRvIHN0YXkgYXMg
d2VsbC4NCg0KQXQgbGVhc3Qgd2l0aCB0aGUgb3Bwb3NpdGUgcHJvcG9zYWxzLCBpdCB3b3Vs
ZCBiZSBnb29kIHRvIGtub3cgd2hpY2ggb25lIA0KaXMgb2ZmaWNpYWwgcG9saWN5Lg0KDQpB
dCB0aGUgc2FtZSB0aW1lLCB0aGUgdGhpcmQgdGhyZWFkWzJdIGRlcHJlY2F0ZXMgQUZfQUxH
IGJlY2F1c2Ugb2YgaXRzIA0Kd29ua3kgc2VjdXJpdHkgcG9zdHVyZSwgd2hpbGUgbmV3ZXIg
YWNjZWxlcmF0b3JzIGFyZSBpbXBsZW1lbnRpbmcgdGhlaXIgDQpvd24gdXNlcnNwYWNlIGlu
dGVyZmFjZXMgYmVjYXVzZSBBRl9BTEcgaXMgdG9vIGxpbWl0ZWQsIHNvIHdlJ3JlIGFscmVh
ZHkgDQpyZXBsYWNpbmcgb25lIENWRSBtYWduZXQgd2l0aCBzZXZlcmFsIGluZGVwZW5kZW50
IG9uZXMsIGFuZCBkZXByZWNhdGluZyANCkFGX0FMRyBtZWFucyB0aGF0IGZ1dHVyZSBkcml2
ZXJzIHdpbGwgYWRkIGV2ZW4gbW9yZSBvZiB0aG9zZSBiZWNhdXNlIA0KdGhlcmUgaXMgbm8g
bG9uZ2VyIGEgY29tbW9uIGZyYW1ld29yayB0byBhdHRhY2ggdG8uDQoNCkFsc28sIGlmIEFG
X0FMRyBpcyBkZXByZWNhdGVkIGFuZCB0aGUga2VybmVsIG5vIGxvbmdlciB1c2VzIA0KYWhh
c2gvYWNyeXB0L2Fjb21wIGludGVybmFsbHksIHRoZXJlIGlzIG5vIHBvaW50IGluIGFjY2Vs
ZXJhdG9yIGNhcmRzIA0KZXZlbiByZWdpc3RlcmluZyB3aXRoIHRoZSBjcnlwdG8gc3Vic3lz
dGVtLiBTaG91bGQgdGhhdCBiZSBhbiBleHBsaWNpdCANCnBvbGljeSAiYWNjZWxlcmF0b3Ig
Y2FyZHMgYXJlIG91dHNpZGUgdGhlIHNjb3BlIG9mIHRoZSBjcnlwdG8gc3Vic3lzdGVtLCAN
CmV2ZW4gaWYgdGhleSBpbXBsZW1lbnQgYSBjcnlwdG9ncmFwaGljIGFsZ29yaXRobSI/DQoN
CiAgICBTaW1vbg0KDQpbMV0gDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlw
dG8vMTEyYmYwYWYtMTU1MS00ZDNlLWFiMTUtZTVkZWEzZmMyNDM1QGFwcC5mYXN0bWFpbC5j
b20vDQoNClsyXSANCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNyeXB0by8yMDI2
MDQzMDAxMTU0NC4zMTgyMy0xLWViaWdnZXJzQGtlcm5lbC5vcmcvDQo=

--------------NvQBh5VzbAkqfAvF1Z143Y0b--

--------------q1oQOYyvhcOSm25Vdun1tSMD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEtjuqOJSXmNjSiX3Tfr04e7CZCBEFAmn47RsACgkQfr04e7CZ
CBHSVwf/aL2WHGsvH9sOST1P6VR0/MneU9AhhRktbL1+1Um2wCPQrORk1wAxQu9d
I269sjtcpOe2d3WbrVKtgMLiUkLD230ZnMEs0n6ykBCQN3fK8yPcygJhARXLtJMq
fsGCuvOOl/8LX68SsXjMEpfb1uAWP/0Lgw6coc64K91cZ+VBVHSQKDnrAwrt98VD
ys2vtScyX2qj+6wH9E2oT+p/5IcwvdEHyk3Lsn8Lhaa0Tu8aLk2sMcaIr8c79oPp
YPvok7YQ1D9HzcEnYenJpLQgJ4QXS+7vCGkJ60XAJN6sAbn4KNPqzNmFLeGG3egF
F6mbKwpSmUWG9TBPTnBGOV0lvLzZXg==
=4bcj
-----END PGP SIGNATURE-----

--------------q1oQOYyvhcOSm25Vdun1tSMD--

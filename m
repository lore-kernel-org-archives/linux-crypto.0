Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA50376464;
	Mon,  4 May 2026 11:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.221
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777895602; cv=pass; b=rUJCB4tfrmfHHI6f6/fMl4Pdn6dTtf74VgaAg2MBcDvytEDyOqX6jjPnxeUDf+U3yFY7/JPGkesZNo1cY5rhiHf+N/puptVW8c1l6HAnpVstilqA5/dNFMObi3UY1QXAW22K8Cq59PoVQgMvgi8BRVtTeXscds/9LsEqhF2TCgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777895602; c=relaxed/simple;
	bh=UUGAAtXZfmV+QPq3stLC9sx2szZsDciVfE121Oe1rUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Itp8iF5Rx7n9Z/YCZWKzeilogjDOXdIaSekbRGvNgfScD6CEGUXu6Y366K4DmUcXra2jrO3VTegbELjuLL1L8G3k4Cpnr8Ci7/qRJlokKzDx7UzO7pBekcArDM0sEM2CCT1B5tqy/9LC0TtCKP3vy/ZY2gIfZIj+sph4pl1OCNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=DILJjXPs; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=390QGMnb; arc=pass smtp.client-ip=81.169.146.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="DILJjXPs";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="390QGMnb"
ARC-Seal: i=1; a=rsa-sha256; t=1777895232; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=cOdsCc4xTO6B7An+eORyThIKTd3/TIPXrHdrVMFlPEwI/xjbYudUBlGsj+HtrQF3UV
    zncLDZpH6/P9GsM+mIay0Ro5qbXxs8ZT+ojq1W+zx+yhMwltwQKWIbeKp6mFb7lLqUkZ
    fbqn8/aBwkvYJa8NxEk21SfjReNy+3jpSb3h4BfPuBUSsxwGvjw9+pduKE4ZjaXMYwa4
    0PenZcz61WcSumClqlT1QQW261keEZk0lR60fVuO00LBnAr/B/n/gMhBBU7rcYwzXsRi
    Q9NWpehg2GrP2rl1uXdWhZZTyNkNQSnhOt4f3XnZRUatyBC1us50wTNPUA1sgDu+vNKy
    lB7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1777895232;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=UUGAAtXZfmV+QPq3stLC9sx2szZsDciVfE121Oe1rUA=;
    b=dwEInQOmkiy20QmUfQRF+ZalUNcl7KkIaKVDwd/mAofFNVe6NRbJ1U//SmHBPlq8H4
    zKakk/pRdVYZq84U3ALuvke6AsYmAsdOJaDcPXSSGMVPIbshurENIrnGxcHwhAbDLuBc
    tFn4ZWw0uegZXgW6jeIyaNbuJgFFyXhzQMAamwGQ/1BS3KvFxxrbtLzt+78bGV+sbF/f
    NPz/rwr/nzKzibdkrEndW6XxpMGkUTYAfkMnxkZZr1nB6fPsz2tKHVbUFPa9d3YYz4py
    Z2j+gTs8U1Dtk1LMaZpxHFIc+5ZSof4giq1Z7dVr6uNe4mDIp3Pp4MxIJmRF4an0agYF
    0Vog==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1777895232;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=UUGAAtXZfmV+QPq3stLC9sx2szZsDciVfE121Oe1rUA=;
    b=DILJjXPsRlPMvUlSN4kI4IZXrjcU8A11qkh9CUoy8u2UMaMbr+SSLzXuoso8YI4d1R
    /vS9Tf6uusN5ewSQK0uyTKI9Apkqj4paXfr7TkhoI+nNBd1xgpbn8Z/5+u1hwPGHXhJE
    7jNDPtZi8Pnnaeta1noOLPI2L9mZ9rmUKgBk0NvK5qegUm5179mHMfs2LJ9JOiVtST8M
    iVWtzNpmWLMIsz9VN2RO3l4+5clvCqwVkxhUj0MhspvCuRT/5N91UuMmuWS5Oj5A8HN/
    Ykvktr65O4pA4hN2ov7X2QGBRQ8Kk7C41boW3pV7xlpnI98XPhdduWuIJ/181cVweEGR
    7spw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1777895232;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=UUGAAtXZfmV+QPq3stLC9sx2szZsDciVfE121Oe1rUA=;
    b=390QGMnbPWTfCdD6CsK62GlPKwpq6T3t4ezLa0GHdtJB6t0Y0k2y4k5fLKDLwNTOuV
    V0JWkY6UgEK2q1kh8mAg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zmwdP57PWmc+BP1jdA=="
Received: from graviton.chronox.de
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id f77920244Bl8qt5
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 4 May 2026 13:47:08 +0200 (CEST)
From: Stephan =?UTF-8?B?TcO8bGxlcg==?= <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Thorsten Blum <thorsten.blum@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH 1/2] crypto: jitterentropy - drop redundant delta check in
 jent_entropy_init
Date: Mon, 04 May 2026 13:47:05 +0200
Message-ID: <pMiaWQU2SxaW2HLKYKNkYQ@chronox.de>
In-Reply-To: <20260504082848.7194-4-thorsten.blum@linux.dev>
References: <20260504082848.7194-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 mFIEZZK4/xMIKoZIzj0DAQcCAwTDaDnchhDYEXH6dbfhyHMkiZ0HPYDF5xwHuMB8Z24SuXYdMfh
 pnovdsgwpi6LNAvnI/lGPrvDc/Mv0GQvHDxN0tCVTdGVwaGFuIE3DvGxsZXIgPHNtdWVsbGVyQG
 Nocm9ub3guZGU+iJYEExMIAD4CGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AWIQQ0LE46O
 epfGZCb44quXQ2j/QkjUwUCZZK6YwIZAQAKCRCuXQ2j/QkjU/bVAP9CVqPG0Pu6L0GxryzpRkvj
 uifi4IzEoACd5oUIGmUX7AD8DxesdicM2ugqAxHgEZKl9xhi36Eq7usa/A6c6kFmyHK0HVN0ZXB
 oYW4gTcO8bGxlciA8c21AZXBlcm0uZGU+iJMEExMIADsWIQQ0LE46OepfGZCb44quXQ2j/QkjUw
 UCZZK6QgIbAwULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgAAKCRCuXQ2j/QkjU8HNAQDdTmzs+
 Cls6FMoFrzoWdYtOGCW5im7x1G5M/L0L3VOvgEA6m9edpqCc0irbdNXVjoZwTXkSsLOxs2t7aDX
 2vFX54m0KVN0ZXBoYW4gTcO8bGxlciA8c211ZWxsZXJAbGVhbmNyeXB0by5vcmc+iJMEExMIADs
 WIQQ0LE46OepfGZCb44quXQ2j/QkjUwUCZb+zewIbAwULCQgHAgIiAgYVCgkICwIEFgIDAQIeBw
 IXgAAKCRCuXQ2j/QkjU1pIAQDemuxTaZdMGsJp/7ghbB7gHwV5Rh5d1wghKypI0z/iYgEAxdR7t
 6KrazO07Ia9urxEAQWqi0nf6yKluD0+gmOCmsW4UgRlkrj/EwgqhkjOPQMBBwIDBBo6QjEMU/1V
 DD+tVj9qJ39qtZe5SZKFetDzXtyqRpwL+u8IbdIjv0Pvz/StziFMeomh8chRB7V/Hjz19jajK3C
 IeAQYEwgAIBYhBDQsTjo56l8ZkJvjiq5dDaP9CSNTBQJlkrj/AhsgAAoJEK5dDaP9CSNTLQwA/1
 WxGz4NvAj/icSJu144cMWOhyeIvHfgAkG9sg9HZXGdAPsGzKo4SezAYCwqgFKnyUIAjKYl1EW79
 pSCOFS36heQvbhWBGWSuP8SCCqGSM49AwEHAgMEiEhJatNBgxidg8XJFTy8Ir7EsTCeoVY2vJAN
 rysZeAAmSaUWFD4pvXE5RYQFeCYTWTG419H7ocNGUz5u1dgKhAMBCAeIeAQYEwgAIBYhBDQsTjo
 56l8ZkJvjiq5dDaP9CSNTBQJlkrj/AhsMAAoJEK5dDaP9CSNTGCAA/A2i1CxhQJmYh2MwfeM5Hy
 Wk6EeWruSA1OgSWmaJaoGaAP4mARD2CviJgz8s3Gw07ZTk8SYHOTnv70hUbaziZ3/tjA==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Montag, 4. Mai 2026, 10:28:50 Mitteleurop=C3=A4ische Sommerzeit schrieb =
Thorsten=20
Blum:

Hi Thorsten,

> Since start_time =3D end_time - delta, start_time can only equal end_time
> when delta is 0, making the explicit end_time =3D=3D start_time check
> redundant. Remove it.
>=20
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan



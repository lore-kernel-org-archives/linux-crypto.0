Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118CD31FED6
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.166
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758296998; cv=pass; b=NZTZx/zzPt3QfPaeKC2BEO+kVnvMS0LiVj4Zff34CZxM900vIqOHpzxgTT/+671250IwYiBEPE+Pw0Vq5JKUY6NQurICzKORwwpJaCQZkXk9K6cXjiAvuFL/gyVzlLBZNrigx4JDdwAP1flI6Z12ZWU14kQcl0F1vKNT1Pdz4E8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758296998; c=relaxed/simple;
	bh=T1iw/rf5xGYjSw3c7GSVoCEB81X64Gm+6auowTWe3+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MjUjX/fhn4MNDgS2JQh+E1R54sTLyt8ISQdjWV8fDi4pvTa59BM32CxRIs7gm719ZaYdcJhGDBUCo0HIfITxnlxGRmt9BPULkWwum2m8k2zXk+nUrFsManFSNrgj8u7adykQdzbNscfx+zb/J3YyBXZtyLUnigHvi44YIhul51M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=aRD0dyeg; arc=pass smtp.client-ip=81.169.146.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="aRD0dyeg"
ARC-Seal: i=1; a=rsa-sha256; t=1758296988; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=dHG+Cu9X5FwOV5/l8wma8NN/3k4pMhOZamJzSj12GyaP9udWE+4ehq1x0C7o8INXeq
    Wg8eDC195Qe4F1FJaDhGnGWdERPVQpK3QyTC6Si+lGW7ZYLBfBc1IYRwIWV4EvKlpaWb
    p9q1dfFAD/ANcQKSZTwC+oZ8O1AQnfwWbZafu4K3gZFLgbdegJJkb2/d38Bdow3CkqP2
    zrlB+K/RRil8dMD1gS3UwRWKKdn9okEV4nrY7eVYv1wYdA5hZIcOnlO+ISw6MboLS9xB
    kjr2LmU7bvzGW5/iTTKs/82McHURjOXDLxOsnk6Ra+WjYo/8ElZ1XZxaH0VnHBsGDBau
    cIkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1758296988;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=T1iw/rf5xGYjSw3c7GSVoCEB81X64Gm+6auowTWe3+g=;
    b=hZcIvHZZ0VdJGAU3tXqgAvGjXOgHi7ET8di6w3Q+vMTjZAfKzoJpjAVY1xaxYGWKDV
    js42v+ET5IkHGqDLWsA7tQxPCYwc7E+V0y8K4tJXRP9Ux5a+/c0goPJmGuwxdq1W/9ej
    NgM9F1jEL0UZt3OFOLX0aORlIMAzW963Fgi33a7svQI6mGvxb3iFZ0JmmaIuFsJE0pkt
    /VEq8kyLRdYuUB/blUArnYMgZ50LRShhcO2BSEFHV6Uy+kEpYwSo6V1HwjFFXZsDGGhB
    af/6AL1bQu039UvCuA9uP+4fM6CbBmgI8j5uYReNFQbVMfrToqbiZ8SzmzS5bK7s4MEx
    SSXA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758296988;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=T1iw/rf5xGYjSw3c7GSVoCEB81X64Gm+6auowTWe3+g=;
    b=aRD0dyegqMFy5CMJXknN2B35ZMvH+q8pSblKfzRnsmngg+767fXWKRtKw7QZ19kWq3
    +9tI1B+tKXGshqUn7eNguEypJQC8O4wx0M1vTefrfUj1+4uDzMy8+yQNhO3ubLpkTL5C
    JEG6fO4KuF77kc4ORmRgvac/Heyz2Q7F0cLhcMsMEB0xFlsSqtSS9h7vwxWTzL6OAVUj
    1ag/OUEYRuO053EvFBDR0vZPFZZRSp97QfpB93MLhN1amjokU26WJ0Lerl/7Cefz0hHN
    yCeHUVZC4CQAiENjeKD4Pyhlnv9nJvroYO3EzBHi0exy0vvNT7JdjmxFwzj3MLtqihnZ
    tHEA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zmwdP57PWmc+BP1jdA=="
Received: from graviton.chronox.de
    by smtp.strato.de (RZmta 52.1.2 AUTH)
    with ESMTPSA id f01e6318JFnlL1f
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 19 Sep 2025 17:49:47 +0200 (CEST)
From: Stephan =?UTF-8?B?TcO8bGxlcg==?= <smueller@chronox.de>
To: David Howells <dhowells@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Simo Sorce <simo@redhat.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: Adding SHAKE hash algorithms to SHA-3
Date: Fri, 19 Sep 2025 17:49:46 +0200
Message-ID: <2775306.XAFRqVoOGU@graviton.chronox.de>
In-Reply-To: <31fa6cb0a6b72b9ceed9bd925d86ad92b78b5bdf.camel@redhat.com>
References:
 <aMf_0xkJtcPQlYiI@gondor.apana.org.au>
 <3790489.1758264104@warthog.procyon.org.uk>
 <31fa6cb0a6b72b9ceed9bd925d86ad92b78b5bdf.camel@redhat.com>
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

Am Freitag, 19. September 2025, 15:57:05 Mitteleurop=C3=A4ische Sommerzeit =
schrieb=20
Simo Sorce:

Hi Simo,

> We are probably not interested in the HashML-DSA variant, so you should
> probably ignore that part of the specification for now.
> It is easy to implement on top of Pure ML-DSA if you allow the caller
> to specify and externally composed mu.

The key is to have a dedicated function for the Verify.Internal function wh=
ich=20
is wrapped by the pure/prehash API, for example as done in [1]. This way yo=
u=20
can first have a pure implementation followed, if necessary, by a prehash A=
PI=20
without changing the actual algorithm, e.g with [2] and [3] where those two=
=20
would be the actual API to be exported.

The question on external Mu, however, is a bit more tricky: it requires the=
=20
injection of a variable that is used in one processing step of=20
Verify.Internal. That variable comes from the caller, but somehow needs to =
be=20
transported to the internal - for example by [4].

[1] https://github.com/smuellerDD/leancrypto/blob/master/ml-dsa/src/
dilithium_signature_impl.h#L888

[2] https://github.com/smuellerDD/leancrypto/blob/master/ml-dsa/src/
dilithium_signature_impl.h#L947

[3] https://github.com/smuellerDD/leancrypto/blob/master/ml-dsa/src/
dilithium_signature_impl.h#L906

[4] https://github.com/smuellerDD/leancrypto/blob/master/ml-dsa/src/
dilithium_signature_impl.h#L784

Ciao
Stephan



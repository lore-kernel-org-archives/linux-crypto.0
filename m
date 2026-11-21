Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795256338;
	b=cl0D2I1GDe5isOWZPhMwSJjU0f6F4C8nCQ/LcK5LH6pKjzpyd6H4FJEzN5gkpJ2E9t8+
	 KnoPfyNXROl+BwrCknQK5zYruhaOcN71c5GQdzkhx4ZPrmSDVd90xxAfaIJNsExZPycbi
	 61XXGdCRzM/+I0EUPmMhAm5xcFVtRap8MtAjT8fcAb5pCMDvz498gVKgcSJ0ZJfCZLKVr
	 lXnzMy8n9nM6Tbr2P4KvInqmgPfO8bNU9erFvNP3ZfLUIaEU6WoWyt3V5djBhY1mRWLGI
	 ECRGF/CzWwDWdXGxLZtej6uvip1pYZfCVWFFhzqIAq9o5UyHrAYgBQ3eMGrkfsqByXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795256338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=dzaf2Z9uO/Z26dmJHQt/rzIG6OfXFllTIg41OzeeRLo=;
	b=k+Q0jSUpUZiJBpLRkwdNdj4I26hIgtlJMQkf9Ga64zUFECkIdsThIdnSGWmec4P2DDo8
	 CiYNFZP6rQq3wi6TosY842O58SRgnojJIJKyEqDHSi+SyW6YF1iHg7k14u8LZ5Jnry/go
	 5LpoZo4z6pqnjea5/9NqYsz1sqxjBC0rfpwUy9d51/k2CrUgnpnqE2Tp9utELFZRZkrly
	 wRGCNxHdSR73Dame3ZfcX73OccONhQKouK1n6DbDhn+8WY/Xd2JN8dHc/mc6R31zU0dlz
	 vt3OLhmujh4f0m7Uf7180AiGr5siJRNf1fTnG5EVgLRd7/YrSinlBjZYfpU8oXaPWIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I7SAFHvG;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D06606A32A
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 10:18:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5D06606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I7SAFHvG
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a06e79e152so864710b3a.0
        for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 02:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795256337; x=1795861137; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dzaf2Z9uO/Z26dmJHQt/rzIG6OfXFllTIg41OzeeRLo=;
        b=I7SAFHvGEVCBm0J5+m2y3jr0xvZhrbLgb4JRfF5d3AbR4l4CiID2rJ89wQRPDk+qLQ
         sbfn/BHHtEHxluv7Oiy01POHFJHNfub1xMCy9gqy3cNW/p1yHeeamx02bImhk9EmdlfP
         mYolBA5Z2JOA++5xz640eA6IYLpaP8IGf98w8WCs7s/ZVI4NYEksZ5A+/mtSZURniLIW
         2qHV+msb0HIo0O0wLdQ6Fc0l2XHKnWptHD+bIzDbTheHAyVUpe/vopLup81FlXNrQ/Hc
         9YbijY8H8HakzFA+TxSKVEhce6qnA6g3cymuYVuyN8kataqFn7drgaB7aX4LYWoe9QBd
         qpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795256337; x=1795861137;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dzaf2Z9uO/Z26dmJHQt/rzIG6OfXFllTIg41OzeeRLo=;
        b=iufpRRlDUfhP46EvkiLUsWBmIQ6Xih7cG589CpKVFxhL8jIj8OZiHAMnsHSZ11GHQT
         Aqhl4+jpf5Zina2pE8yy1uXqt3eRKTAqdPJSQxBTSAEjAnm4ahW6YTPdmLWqspgrILrI
         5U6HZCYx3uFTVTNiIzWyVjAX3+effqt8pHPbLyaEdXN2BsOoL5xPj2HgK17bJiLhoH8u
         Gf8lwP48nBY+patOGyVOL5ZWDuuCVwvAeFJy1Z90VgJ9MQkJRwECK8ut9qIMC/5MTcF+
         A/xSnrjvHM7ykxRvSXLcDjb1lO5LvrdqOoFqi3JzySgsFMK584LWzKR2ISvmiiFbkjCT
         ztcA==
X-Gm-Message-State: APuU4Z8Gkr83cDtnHttij0wnlNrrN3fP72lZMJbVZK0Xe572ls6baZGf
	TlR8ZSnr93qpuZR8fHmz/udKkMoTjuYcx20ln3bxF3Bzt7ySIutdwK9G
X-Gm-Gg: AZFdTZfK3Dcc6AadDzdRXn4+/JCBBSKJmnEdgf9d7u/VlnsIFOtnninkWgUXxTeoV76
	scVENXexFINA68EoWtOVb5vG9we3uUVYuPhqHxelvI9P0276PYSPFq6yqEzFecA1e5fdmD6sQ2r
	xdSNF6REMHJiKOcLgjRleSMtqQjFwsXxzQ+6v5IOt8K6jRMyTFOPw7iYhZWQCZjJdO1WQjcuCE6
	pNTrkANL7+pn+p53MJd/MYNa4tP6o37NTSyLg92BsEb1HUlwRaK4YDbPAxtAEak3iOh5Pr2VCPx
	rCCQJp4hki0O/mUnEw7rig6PCXkMnx934lgy0R2e8+ImlG7b8DM1osKwGwvWM1JBE2pzO0lh4Vs
	BZJGfi84PQCZQtgP7cPYhvCDfrpuHhDJiFw03yfs+uwHvLBGtnidrcpJdySp1eMn6IrK6BjlH6Q
	O/lyESBvpD1Noac5N0Vjue+JxX1+VIhPvQsSr2jaJgIRkBO9ErQlxkkjji3ToTsjciKvqqqcrVK
	zP1eFTEB1Awt9771cg7GRgPLDgkoXiSfWu82YTwcyqOwFDq9GLAZKrH1JjWO/KlrD8s8s98HwQs
	UnYeOd/4nD8tAuqq/Jci6Rf2Un/F9OnVTMW1oU/S/Kz0FZiwdmnZQmRPu0gXscLqA9cQzUN5nHr
	M5ALt+m08PzJHTlVzaaMhB0LyCiZBew==
X-Received: by 2002:a05:6a00:2da7:b0:898:e7e7:c0df with SMTP id d2e1a72fcca58-8c87cf2ad15mr4832985b3a.45.1795256336951;
        Sat, 21 Nov 2026 02:18:56 -0800 (PST)
Received: from reply.eml (awork078078.netvigator.com. [203.198.250.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87077bff6sm2701360b3a.3.2026.11.21.02.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 02:18:55 -0800 (PST)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: Ignat Korchagin <ignat@linux.win>
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
 David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org,
 Vega <vega@nebusec.ai>, Ren Wei <weir@nebusec.ai>, xuyq21@lenovo.com
Subject:
 Re: [PATCH v4] KEYS: Account for asymmetric key payload data in the quota
Date: Sat, 21 Nov 2026 18:18:41 +0800
Message-ID: <20261121181841.58673-reply-xuyuqiabc@gmail.com>
In-Reply-To:
 <CAOs+rJWf5JEMD7UC-4YS2ayAX5f2SUgr5s9DCwmWXExBhqaEJA@mail.gmail.com>
References: <20261026024840.23482-1-xuyuqiabc@gmail.com>
 <CAOs+rJWf5JEMD7UC-4YS2ayAX5f2SUgr5s9DCwmWXExBhqaEJA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Ignat,

Thanks for the review.

> SInce we touch PKCS8 as well, missing a relevant "Fixes:"

You are right. v5 adds:

Fixes: 3c58b2362ba8 ("KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]")

> While today indeed only the asymmetric keys hit this I wonder if the
> fix is better to be in key_payload_reserve(). Something like a fail if
> key->quotelen + delta > USHRT_MAX. That fixes all current and future
> key types.

Agreed. v5 adds that guard to key_payload_reserve(), so every key type is
covered. The asymmetric parsers still charge the actual retained payload
and keep their early rejection before the payload is installed.

The common check also covers keyring link accounting and big_key
updates, which use the same field: a charge that would exceed USHRT_MAX
bytes now fails instead of wrapping the counter.

v5 is now sent as a separate patch.

Thanks,
Yuqi


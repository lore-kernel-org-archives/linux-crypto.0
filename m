Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF1936BCCA
	for <linux-crypto@vger.kernel.org>; Thu,  2 Apr 2026 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775149725; cv=none; b=HBlgQ71/t3h9OSOP9E/ujIeUpg+K3XClLmGUK9/DTV/bQvpZeogIGvA0CblGHLCIHzQlrSGn/+kjIdPGiefeDMn+C2dDZRQCMjiOzDsvuLg9UHzce7Mci8jh2Svki8XuBxjBDWfi9Wso0vnxlzk9lL9hWWwZSzJkBfMo/Cf39aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775149725; c=relaxed/simple;
	bh=fmYZLi1lImwg8+a9bcQBLsvrUdTVG73HXeUaVqgBOZU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=RQvIULxMimOljxpQ92eeUJnzufkpRCZ5MKQNqXGxiZ7CfmDDgyiux1GUqx6Xm2r2w4pePApw+9f1gZ/txXdR/CrNxOQGN+u8EDNS1+RCm4TbggLXCc0C1Nh6FHowiwzt4fbql4M6DYYXFHEf0vLWBAhyg/ir6y/1rXQG+ZSfGDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q6t8e5Ah; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q6t8e5Ah"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d7f09aa39fso1444369a34.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 10:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775149713; x=1775754513; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anVZF/hO86rDuA0y2cSK6zli4sip6Rs95gAxI1zYy+s=;
        b=Q6t8e5AhYXwJ4qU8U0xA18VYgYHogX1D7Roos7uvO5DrKTAbemFddYms28berdM17A
         pIMTJeiNn/DzwI7VsFojM3TWM+Gu6ZZ/kgUrcwSf+sffBd9VhLDQBF27ABErCVwAdTDc
         tJXhL/U4S9lAzaB+nCqC623pESCHZBfvMj+u8CCz8ffot0DWawBEN0X9fYOi+JUXK4Co
         nw6X18adDdV3B3djWR7zhWNY5W7QjP3/KVh07WvAP+BavfLVptoZVqvJ2hppiZo5a06Z
         2Rx6U66ggzpB9KFpdswoJH9sf+tBncCBkX5Ol+hSPKzzLmNUuK+1nMfqKkyZu+U1hHAx
         U2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775149713; x=1775754513;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=anVZF/hO86rDuA0y2cSK6zli4sip6Rs95gAxI1zYy+s=;
        b=s89MVQ6qbUxZgyOtL+HHyK+CnInnhRfg9JGWevEYqZM2lXtkb6Fu+MwbPOi/Xzj+44
         dfllphGI9qsqlby/yW6zLH27grU4OayIHujvAwdExiqaGO0c4H8SGFX0o4eBejMOIOPe
         rUtLvXoWNtVEghmNJ7LJ5pVml91emjGyKCdFH1hOo8Eo/uKpLl/OR6pfSDbwbA/CBlMu
         uDQ5INH7eFpbTV8fKpX5b/Bw1BPZXfUWM2zk7IJ52jvGtzs6htujsE9c6G17B4ObqPRh
         QFxldMsTAYUuSwbzh0lnBpHrvgIbndU1uJd7cuf/BFjJX+bdRgNfoCY+YW5l47jCXuGQ
         iD5w==
X-Gm-Message-State: AOJu0YxhFTFsqads2Y907ZkvgJ6wqBCMyIoFrhA/5zr9U5tipdCrf7KQ
	DfMFjjY/9g1TCmb36+Oyj6LH+og7Ncz3TYtvjBGZhkz2lSUYMYL0ztWzGyawIzxq
X-Gm-Gg: ATEYQzwOrdko/GqjpIaaobYvOvWck7AkjNijKt4F/JDpHDDFEofRk3JZcORns13crRQ
	C1MrloZSK2E37PppZ9wUCPRKiUAq36KKFIhvf1uuUpxY7/43dMs5SY59f6KlhSKYz0FJ4WlW838
	cQLTU9CMLiDF3RF4XjYtvW2ecm7dv6nBhUNV/H78lW9fqCrRAVJzRuEsAbhScew7aEqcslY1GZZ
	8fbcpbkz3Gt2nVbR77aiX6DpUXfT2f9/5CQRn0xdMilHOOumrn8hXe2EiNnigkip7LVrUZ2NB0P
	8S2xiprN49Gx3jBPKbvSeUsvW779PVI1Nx8artXc2TkMJTMQYzLiJJ+mSV6kcRisZkWUKgGcwdd
	1d69/8dmqE705NbbBbAli96daOhEhzUBbt1h41raIirIlYyIwPtHPa1KfVeajpuO8vB31uwQ7BH
	z/wheVuHEOq5t9ddKUMApMIONDhPK6Pax/JM2ovCVX5+8mcf2rqjUTNMg=
X-Received: by 2002:a05:6830:621b:b0:7d1:9da9:c6c with SMTP id 46e09a7af769-7dbb70d044fmr87778a34.17.1775149712878;
        Thu, 02 Apr 2026 10:08:32 -0700 (PDT)
Received: from smtpclient.apple ([72.47.112.202])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dbb40b1507sm427083a34.21.2026.04.02.10.08.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2026 10:08:31 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: Kernel ML-KEM implementation plans
From: Ryan Appel <ryan.appel.333@gmail.com>
In-Reply-To: <20260331011133.GB5190@sol>
Date: Thu, 2 Apr 2026 12:08:17 -0500
Cc: linux-crypto@vger.kernel.org,
 wireguard@lists.zx2c4.com,
 "Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8721F1CE-0E84-4A2B-816F-0A4485BA808E@gmail.com>
References: <20260331001358.GA5190@sol>
 <7507DE2E-1507-4D03-B6EF-9C139BBF34F8@gmail.com> <20260331011133.GB5190@sol>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3826.700.81.1.4)

Another potential and likely use case is Wi-Fi.=20

WPA3 supports both SAE-PK (which currently uses ECDSA-P256 and will =
likely migrate to ML-DSA or other,
And WPA3 enterprise supports EAP, which uses the IKE Diffie-Hellman =
groups, which already have added support for (pending finalization) =
ML-KEM groups.

Of course the spec will have to be updated, but it=E2=80=99s highly =
likely that at least ML-KEM-512 will be supported.=20

The actual use of the algorithm is as simple as calling it instead of =
ECDH, but in theory, we typically care very much about the difference =
between key agreement and key exchange.=20

The major difference on a code front is that with ECDH, you input a =
public and private key, and get out a shared key.
But with ML-KEM, you input a public key, and get out a shared key, and a =
cipher text.
Or you input a private key and a cipher text and get out the same shared =
key.

(Encapsulation -> one input, two outputs)
(Decapsulation -> two inputs, one output)

I understand that there is a chicken and egg scenario where there=E2=80=99=
s need to wait for the need before developing, but something at least to =
consider for the roadmap.


> On Mar 30, 2026, at 8:11=E2=80=AFPM, Eric Biggers =
<ebiggers@kernel.org> wrote:
>=20
> On Mon, Mar 30, 2026 at 07:44:55PM -0500, Ryan Appel wrote:
>> WireGuard was my big implementation user.
>=20
> Any more details on this?  Googling for research papers shows that =
there
> have indeed been several proposals for quantum-resistant WireGuard.  =
But
> some use algorithms other than ML-KEM.  Others don't modify the kernel
> code but rather do the key establishment in userspace.  I haven't =
looked
> into the details, but it also sounds like it's not as simple as =
swapping
> out the algorithm, either.
>=20
> I think step 1 is work out some plan with the WireGuard folks.  Which
> may or may not turn out to involve in-kernel ML-KEM.
>=20
>> I also know that VMware uses the kernel crypto space for many of its
>> crypto operations.  I do not know when they will want ML-KEM and if
>> they will want it only within BoringCrypto or OpenSSL, but if there =
is
>> need for it in the market before it can be developed then that makes
>> sense.
>=20
> That code isn't upstream though, right?  So even if hypothetically =
they
> (will?) need ML-KEM in the kernel (for what?), that doesn't count for
> upstream purposes.
>=20
> - Eric


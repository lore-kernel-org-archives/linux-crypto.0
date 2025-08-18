Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AD2322A25;
	Mon, 18 Aug 2025 13:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523196; cv=pass; b=gnbV5ZAKwNCzpVI+YZP8OMjFRrEHabWxTVZD4X4jf9Z+l1uCQeJD8hAvlNgK5HcDRBgRWZlDuyH3YqkbVjybRp7HQnbMbDNmQrgrrQ02YXZeOkwsIopE6WT3NNHVjZl0Ue3m02fyeYXbc5BSnNP3iyUVaRHl91vPSImQlfr1U+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523196; c=relaxed/simple;
	bh=wn8el64YoQiHP7Z0ilqvfhc+uJwkjuW4CfXUttHHKV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mA5SBHj/YEQz3M/AzGHQK8/KpFa9/miTU5Q4dYDFR71k4rY/Uw+FwIsoH8NX2uMMMGW6rPcEPe2Dod4FNfMV2526Xnwo0SSAK2YpbSD+V7MUdBDEjNk6qDcQI7IUJL/GaAa8LTzoo2xaczHj09p8dlGgUujzE/MrdS+zM9LErVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=HDQeo03a; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=q/H9e93p; arc=pass smtp.client-ip=81.169.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="HDQeo03a";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="q/H9e93p"
ARC-Seal: i=1; a=rsa-sha256; t=1755522828; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=FOroSdsWP59IJQ6aW0lXzSTlVX3hzkfglECuNZTrMQu8m/KZIJTmwsFHB1eGFyQMpe
    d+gXbCq6qLJg/32jcNwHlRUd16KK0ZTJkoXKTB6l6ATM8eG1QDzNn2Kgt5RmUy/i5WWF
    ++f3/RLK/CjjzBiwuKp9ekbNkZSrnD7BAyYSsPjga+cwHQu6wZu+AAuxnAO16aZZo/ly
    8eyzHyNwh6Q2nUHAvq+MOu88xj3f6F9+Qg6sWGJPlh4/xO68/9Emh2IpORZK+jppyp98
    fzcf6esKLrZJfnwKiEPDRPcVsSnYkgzXNkYtRlY+gVzOxe7Xvdggtm0jupR9o/7JeHuV
    7esg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1755522828;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=wn8el64YoQiHP7Z0ilqvfhc+uJwkjuW4CfXUttHHKV0=;
    b=GSSaB2Lneb7ojydcoWghB8UJNR6KxWPuEplGDWrgdxj2HWWlMFSbhdgkK7E/JsZD6R
    3CpLt7TBmNKXbZwkMltIawDVOCHDv7F2bnIV5Do8mFQba4LKqZ477f1zkTBVVZVEmgp5
    sj4gfmFLqGplhRUKLx1n+LjGBDIJvCnj2ChF4J98885FCqSTqsegZmUWWAoIkQZFOu9i
    if0T1EYddFLigFZt410wj/ekqwttqVN17NHrkGdtJg8cU9phq35M4t08PWC1W9LhAfOO
    x67covBx+V/mfluckdJ4BGp6mZca8GVgWXqTNQ5aJbj1XTL921AJkXRRR2DKIgZ8H4ZL
    0wZw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1755522828;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=wn8el64YoQiHP7Z0ilqvfhc+uJwkjuW4CfXUttHHKV0=;
    b=HDQeo03aOFyFNrCjLxDj2Z8zlbpMUO7aaVVhNbXkb0N/shSMmbbEVYtsns6dj+lSuQ
    PM8ZJKuDJsHdeAG2yUegYNJA8XtbP21n/4Ivx8Js3KcK8H8QcujRYDq1iMHFuJZYVzk3
    DbSOdkMWIlsjApvmxRqE8mX0MKr3s38sSzXl8xJYChQGxZ4NKvoHFHDGWC8aMphxQ0Z5
    OTca9g90w7Gi3XOxpD7XKEarpu6zScpLOWLxMmg3uvfpGcfxTdmJpvbi8QCUdO1687Wo
    BqUnf6He06JwnWKfDOadPjsxk9j5InMgz3ntKpvBOdeuVOkyjqsSN+Ms84uC0yy8JacL
    SwKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1755522828;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=wn8el64YoQiHP7Z0ilqvfhc+uJwkjuW4CfXUttHHKV0=;
    b=q/H9e93pYIsi8QrL7eLi/sO+MugFn4MT0iuDk8JTANc2+flHSlKNNXFTvQ/OdvKegr
    QbbzWLygYXsi+VWW/LDQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYJPSciIGX"
Received: from tauon.localnet
    by smtp.strato.de (RZmta 52.1.2 DYNA|AUTH)
    with ESMTPSA id f5f78e17IDDmyM4
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 18 Aug 2025 15:13:48 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: Edward Adam Davis <eadavis@qq.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, eadavis@qq.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V2] crypto: Mark intermediary memory as clean
Date: Mon, 18 Aug 2025 15:13:47 +0200
Message-ID: <7740195.jRhZ6ZUK3Y@tauon>
In-Reply-To: <tencent_F8BAB8BB23338A9E2C1B4F4BD11BD9252E08@qq.com>
References:
 <aKMc5amKH9CLbKL8@gondor.apana.org.au>
 <tencent_F8BAB8BB23338A9E2C1B4F4BD11BD9252E08@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Montag, 18. August 2025, 14:43:36 Mitteleurop=C3=A4ische Sommerzeit schr=
ieb=20
Edward Adam Davis:

Hi Edward,

> On Mon, 18 Aug 2025 20:30:29 +0800, Herbert Xu wrote:
> > Their values are equal, so why use sizeof to calculate?
> > Similarly, "if (sizeof(intermediary) !=3D
> > crypto_shash_digestsize(desc->tfm)) {", why not just use
> > SHA3_256_DIGEST_SIZE?
>=20
> Hi Stephan Mueller, can you explain it?

If the question is why using sizeof(intermediary) instead of=20
SHA3_256_DIGEST_SIZE, then it is very trivial: I always want to avoid any k=
ind=20
of double work. If for any reason the buffer size of intermediary changes, =
the=20
current code only requires *one* location to fix it.

When changing the branching condition to use SHA3_256_DIGEST_SIZE, we would=
=20
have to change *two* locations which is more error-prone than to change one=
=2E=20
This approach is my common coding style to try to minimize the possibilitie=
s=20
where inconsistencies can occur.

Ciao
Stephan



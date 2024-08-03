Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EB867A0D
	for <linux-crypto@vger.kernel.org>; Sat,  3 Aug 2024 09:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722678838; cv=none; b=tG5x6/5SnL64BD1iVzTuwEJgAYhS4BFLP+UnU72UM9cFAP3oVhrxEOyjMy41lVXnmyFVK1tBSMc2Fj4j1OkllcwW98PPjfX0/ezMrV4lyI4AcWEg+50Si+uet9tI7pC0v93ckdrf1V3cey2s+aD0oYYMJ80H1qIyA+FQBMhZfDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722678838; c=relaxed/simple;
	bh=ymWPdCs1+qadU1Yr764y0/w0c4uGJgAiszgAJgK9nhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AJIfyQ3MJlG/IwVrrYigcUB1xcczXhjP+5Z3AMZlPMnvNmtKO18qkTW3B6P2rwQg4RtLaGqTrqYbmTa7RGsx9UXIdtyYHEX6kT36stiZvNhH2iQRLhQbMy+d5T1nm5/QzqV5aaPnzEYqHizcGBVvsUih2qdokQhI7daBS9+Ke2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=wahrenst@gmx.net header.b=AbB4aZ73; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=wahrenst@gmx.net header.b="AbB4aZ73"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1722678803; x=1723283603; i=wahrenst@gmx.net;
	bh=ymWPdCs1+qadU1Yr764y0/w0c4uGJgAiszgAJgK9nhY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=AbB4aZ73EvKnTBiLETpu8MzLKSaSbiv0LzF/yHNnSrfw9MyT+PzHZoPPAQNHdhxR
	 bePR9v+F2yIHTOnZDIKa0js75AWSMYWeyaDTn8au2PewK3e5NOqg1H0UWuiFnTtX5
	 6/CTw9yl0UaijibFUIYrp2nzAaQsSO3qYIw4RH8AgKh4MYG8irD/mOIGsgCKNZp1d
	 yBMswJeUONeZqRDqUKPdbGyxhXh6nXWOHptrbwAAcpb5seqvJHdhrUQ28BORIKyXo
	 z4eUoTI2LQrp3c92ge//4i7/EPl7EMqJCpD3Rx2vBNo+v87mKqcuulMJd7VxHK5WS
	 Lw04rwBSbMlNQbLbow==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.1.127] ([37.4.248.43]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MG9kM-1sSQ5n11Po-009jsn; Sat, 03
 Aug 2024 11:53:23 +0200
Message-ID: <6fafde5a-e532-4a1b-9a02-a5394577f3aa@gmx.net>
Date: Sat, 3 Aug 2024 11:53:18 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 1/2] hwrng: bcm2835 - Add missing
 clk_disable_unprepare in bcm2835_rng_init
To: Gaosheng Cui <cuigaosheng1@huawei.com>, olivia@selenic.com,
 herbert@gondor.apana.org.au, florian.fainelli@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, rjui@broadcom.com,
 sbranden@broadcom.com, hadar.gat@arm.com, alex@shruggie.ro,
 aboutphysycs@gmail.com, robh@kernel.org
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org
References: <20240803064923.337696-1-cuigaosheng1@huawei.com>
 <20240803064923.337696-2-cuigaosheng1@huawei.com>
Content-Language: en-US
From: Stefan Wahren <wahrenst@gmx.net>
In-Reply-To: <20240803064923.337696-2-cuigaosheng1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7GVyv+JJmSn+gXGU8XK2L/rbcxXMHKRGZsJn7wEyCdQBYpSyrZu
 QiErn9zJwyRGsn+BS+BBROuJfzjxJxEwB6/45pm1Y1ZKMdSku9lmhiH8T6sa+lYW3N8glLt
 nT+eYxdgQleN7MwCeg1IJZzMgRW/ylCAcsVoBS9Nqfg0kwW+Rs7tO1Acj7SiXQeeCve8zpK
 6m8+5d8olGYIJctevTrEg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:d1SLJ6J6NjI=;Pe7thD5kq7wGSfxKIsPX04l7XaG
 uXnWM64UEM8nqsC/S8e1sOEkdMoOJ/+VxHp2JBnIKt0/zjonSyqaGAv8rmjpcEEvpY4Ef6Fcu
 TeAt8LcqHiyDZSWaM6h4JvGpqxWRrxsPPV9B8zzCY9myVMeol1tskIOpaMsH5KGlK1XjUL8YM
 zFo//nLQxfK6eiKHY01Vkn4CzthEsRRpCJpNhGCVbepFr57bLYTUGiph9mNtuC6jO+Hw5n/Yc
 beVv1/DNC5o/xlmspiRBB0fZljmYr5xrHm5snznHVOc8K5dpvVFBZboBy/e73mXXm0NxuKawE
 EoX9DnqrZSQjZwkclrv5GgzWZXwOGdJ/HmiSQiwGRCEuJBtqIfienG8LqQaUe5CsWjsfgT1EG
 gGW4FKFyUZEuMDjyCTrxLHBcdWjkmFGPJ2qSiF9BXEX6ipyOzEbWNvpgD0mOiQBu0ZG40HkRm
 AMkTZASI73KhdHwMmG/EVNhl4krybvj7f4HFhCki2Y/T94qOEWhcEHy5SLa0XkqGBMpAA30op
 m9Ew+zXbyzqS9EXnhSIIDEzwy/3avixG8z+R814rIohYacKsXlsm5ym5kzHmE+Eohylj9TCLe
 2lxeP8WMeWC/FQj05biC4+AGqzv4HiLlSyZz1acxPmGC6+9nncWBA+26uxRm4Qn2LvNQ8gAk7
 WSwO1Gp1YyePDj2rG2YK6DqOlsAuWefKd6pbc8gAeLKLF08EmsXZIDjvicE75Ndj4SWv7SLQn
 kmkC0kVzomsQfeQ9nJNk1ZMUBc0+pXje7zMOR69+lGHfroHmUQXeGh5W3l0G2bD8DxXBfykln
 Riu2UooHvyikDGCiMtIhqkdw==

Am 03.08.24 um 08:49 schrieb Gaosheng Cui:
> Add the missing clk_disable_unprepare() before return in
> bcm2835_rng_init().
>
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
Thanks

This was introduced by e5f9f41d5e62 ("hwrng: bcm2835 - add reset
support"), but i'm not sure if this needs a fixes tag.

Best regards

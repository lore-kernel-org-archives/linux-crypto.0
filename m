Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8D828C869;
	Thu,  8 Jan 2026 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767892029; cv=none; b=dLaBiRbZ0DY1xDpPtgSsOV6wAaElpZcfWPKWxf5M913OVjPQFAVaATZyTVHmHcjJqaaVTfyF1gzcNahJ8yFIfU+tSSlCUjUW3PdkZNmfl+RTU1wu/AQ4oJ6cFbkuumoNb0/riRlAeZN4RqxKkKA/GSPiPbiHi1RaevqiaQNSYM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767892029; c=relaxed/simple;
	bh=eLNi6VoH0XveA9Y2VAjUnN8Q7ykIJ6eFIDNateU3i2s=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=FBQWTf07XKm6fUmj6SU2aK5WtgjHecmriCMBlASoDlj+UQWyO3SSCYOGiGW6ETEKoBBTQrNYWdp7Y5SzAlQAIP+Sk3TvIXkNBl805yPQSpuUabYzJkx1MYPjDNs9JNwoK18TVIzjp2ly8CamDGhy+X4sV7APuWxRmiiw1bh0Ink=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=VA7/lBnR; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="VA7/lBnR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767892004; x=1768496804; i=markus.elfring@web.de;
	bh=eLNi6VoH0XveA9Y2VAjUnN8Q7ykIJ6eFIDNateU3i2s=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=VA7/lBnRbU0Nn9XJNB+/k0ZOfapYVkrs4bf18/T9oKs2TLPSR3vrsxOt6sdKi6Jd
	 V3cadSDlQjdTjCjaFGFsB91U+OZxtP0L9wmPKWIOlBm0Dbw3emtHEusgnOnnQGY2f
	 TxqAe2gMjGX16QtG2VqVMZvcgWPHsXf7NtmV+rLRJhzHtc2UXx0SsCkseDSa9fFxy
	 myqKgIN/uN8DRb1PCwiW3CBTUVtROs6nfucRAOH5RPOsZQcqahv02IRanwep9zyPB
	 d+CoEFJQem4MxE9Jauyc1G+i8lM1tMMgTwdKvg7rAB+qLHT6+1xZAFDhbv9h+xdKr
	 ETCKyyuv7dip2/7zVA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.225]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MgiXO-1w5HCq2Ox2-00pgvN; Thu, 08
 Jan 2026 18:06:44 +0100
Message-ID: <9e6ce015-5bd1-435f-ad07-d634326a9335@web.de>
Date: Thu, 8 Jan 2026 18:06:33 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Ella Ma <alansnape3058@gmail.com>, linux-crypto@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>, John Allen <john.allen@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@inria.fr>
References: <20260108152906.56497-1-alansnape3058@gmail.com>
Subject: Re: [PATCH] drivers/crypto/ccp/ccp-ops.c: Fix a crash due to
 incorrect cleanup usage of kfree
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260108152906.56497-1-alansnape3058@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:bKveQ57k6QBqPhRTiLhMwrF3z788pqho13oy4xu8ybxfgOQVP0z
 yXj9ihzYQZ9pERxbEwBqaqhH2oLbIA297h6i2Op7XzV3yEeQb27pCxXkTi1LYbtBLagVBOH
 MEfsZX8qtUShhI2IwXhZ3aDgRqytnIono1M67cPken++dZ5iAjakJ/y3kCTdLwHXX946Xhy
 5bqiTvn6BRmWOC440FOyg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:m0qTuHO064A=;BaBiW0cKPJUk6r3nExadn8M8agv
 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
 7n3yQ3YIozvekyqtHLfraItfW9PxW6MOsBNo2g

> Annotating a local pointer variable, which will be assigned with the
> kmalloc-family functions, with the `__cleanup(kfree)` attribute will
=E2=80=A6

Would an other subsystem specification be preferred for the patch subject?
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/dr=
ivers/crypto/ccp/ccp-ops.c

Regards,
Markus

Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF87619F48D;
	Thu, 10 Oct 2024 08:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550728; cv=none; b=MkNO1COV5NS8qYcyt+nYN2m6RR3uLTS+LaZ99Sm6gKcoW9OMg2as5mAyt4/LdGIAjgNqqO/lJRIGwmAc+vFfnD93Vi7AjyQ/Vno2NdRY3gQjxpdlIVZJXFHANUruDAaOp3U8R7Baqp2EXwh5ZWSQcYqSKNdgRc+mE0w+OoCOvTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550728; c=relaxed/simple;
	bh=DKX8Eio3Vlym5lgP01O0RN/I0shobykbkZHjrRC4aD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NRe84noUzvEdUbsXAKXr2blz3WbOkDbUBBQf/tIqoE8GQ9gAET0LDhdRszlFnb5kF9fmiVwvS8OkNhARivwHDTrd5zKqanWFvTWMtczvuv8zp9UDzMO6XF0POEjDK/3L6zODnIP2SSUIRr07Is/K5YdZYkCrsCtcjGe/bS1V+Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ZzYVsFb2; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ZzYVsFb2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728550708; x=1729155508; i=markus.elfring@web.de;
	bh=DKX8Eio3Vlym5lgP01O0RN/I0shobykbkZHjrRC4aD8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ZzYVsFb20MhFKxItyxl3EIWok+AfQwn+m/bMbnL3U93MVcih1T5fGN4sgFxIDB9b
	 1esI9egUlOog2pMR2FcbOU8KoMAAwkQxqJPBxhQqRRoWYKjBxgFaNM1YtB1qGcUYA
	 VVpbrEXOEUEPKkSFgRoTT/dTQT5eKhaYc+Omlm65h8mC2iDM8t+mYCZu80078QuLJ
	 efeWh5Ayq/u3eFlfFhc5mOy9CK+2qzwQxvPkOgtv4tYwW7sl55mHkApgLbZoXA4XQ
	 LzoCTzmHQFNJcR+QVUv5Gi85P6lxcrlaxfnfD/qa/ryDqmCgr0V00d9/qnkGTjPtq
	 cxs9b37i/MU0KKHCog==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.81.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MMp8Y-1tFNwt3MCS-00KSJL; Thu, 10
 Oct 2024 10:58:27 +0200
Message-ID: <4aef34ca-4665-4e92-8ce8-8a8a2fb472c9@web.de>
Date: Thu, 10 Oct 2024 10:58:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2] crypto: lib/mpi - Extend support for scope-based resource
 management
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>,
 oe-kbuild-all@lists.linux.dev
References: <bc5ce9ad-acbd-4f3b-91d6-10cf62bf5afc@web.de>
 <202409180725.ZV8DCvII-lkp@intel.com>
 <91d10516-4ba9-4fe0-8f63-86205cc4f88c@web.de>
 <ZwDPp4bU1J5uEgQe@gondor.apana.org.au>
 <9ddc71e7-e98a-4fa8-b140-4035dd2874b6@web.de>
 <ZweTCO8cFtP_pvOu@gondor.apana.org.au>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ZweTCO8cFtP_pvOu@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YQVB1Yo4RGfb4R4yn1VvgVcmw/WbNgJc9bz4YraZAZtb0cYncP4
 c6in7TqKMvC2PbGlwVbMS9UCOazUZ2W/0GW6ZfLYnSToW2FMPdVl0XANPd1m8t0MrgnfpBh
 N5hATF6DqrmKZkxdwg6P00D0vxtRZmhwQzF2077lD1L9Wc/wW9wdwIbdXMLMRYqi44JhNOf
 +LZS0qvPX06RxxZzFpEKg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:WDZCk/GeMHM=;GgLY1dKjSUGJM+NIJQEKR7nuPk/
 GkP0L/zrG9RXyem7DgcqeZsXAhqY84XfF7x8yX23P5CGcvXXdNvxUPE+ItQPYHMLwxZCW3Ocu
 wWfIWjtQ2wIcmNXyvJtv9os59c+2RPdl320lziRrnLrzziAJKTS0N5cSeM412Ii5ArZ6bTpuR
 mF7XTEfW9snFnfMZ31LfDrWp4JiWV3mj4zbwcIpMV0qNIkwxrWurQfXP2LB5BRJIwzBxnNFSU
 72OeTuwlBomHePcJfT8RDMgaLcdiC24kY08G6zX5Bnlq1DAU7cN1A8WQBtrmnwMoPmrenVXZ+
 ossmSvkmT8Ee6cZr3iU5Xz+avk0O4ncBPv7vu8PgVjfudpJF+kEXcjGf87/HPeJEks9avOg2V
 wnSB2vMY0eu5phQ0seSXOuAqqaPU3HmQwXLEZc1qp/Bv+k/iE0RZtugWjeFZt0+U5J4+VTs/U
 7vKFsaSNt3fODAZsoZHKinwJkl7Kg2HNSxficSaXUvYUud62izBSNd/S/BrsKFj4y+a1713q9
 gKgxRgQZpywQ9H0uhpGdxMzXw+/CtUML8JaUWNacTE6e4anzOeocBPzlC7Oy4vvggFb/pPyJG
 MZ2UYOAdXzcAKXMc1sTMfxUOkZnhzKncRJlsIp5/xOrH9zRTI0jXU5b10KGZNE5G/AuM/+XpW
 Zs8joFrSy9s1/ogkrAwfGJUdwLRYx8DP8/B6vLDa17qLG9xujHvsQ47AmthUUfhiRqsHymg6Y
 Wu/scGRQ1GCuy8hvW0ZFjP5q5Jc9QO/DlIEiQfKp+3QimvWtQejXibTnEIFFQdJVrPZj8K7vn
 GeIGJH0RDxHB7O8VzQugv3GQ==

>> Scope-based resource management became supported for some
>> programming interfaces by contributions of Peter Zijlstra on 2023-05-26=
.
>> See also the commit 54da6a0924311c7cf5015533991e44fb8eb12773 ("locking:
>> Introduce __cleanup() based infrastructure").
>>
>> Thus add a macro call so that the attribute =E2=80=9C__free(mpi_free)=
=E2=80=9D can be
>> applied accordingly.
>
> So where are the users of this?
Do you find the proposed software extension generally reasonable?

Can any more source code places benefit from such a programming interface =
adjustment?
https://elixir.bootlin.com/linux/v6.12-rc2/A/ident/mpi_free

Regards,
Markus

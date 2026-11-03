Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793673555;
	b=q0Sy7ODfkgQCroFNoLsPOFieLI9RODdLCLqoBtQkbVZYpd7WURJdTekwZ23nd0SoZiTS
	 0g5sySsaRpafhWcTcipFEGPSmfflydoo5y0h05WsbuJJuOMyZJMOkqQTWd9LCzV00z1fP
	 PfNwGCy2m5OEPV/kz+kTv5rII6x4QtBOOLHy9d0jT5F/0GVCKM7hoBqWgs1rPEGx7ADkS
	 0MicEPRQU4FFah+vHX5IEwweVpLdSw9uFtBcrM+4+0J7atooG/qoOpJFqix3q00UmqrH9
	 t/CBrr4dmLPLCMvwXn9v//JqjS0AzVLSG0+EPV0h/wb8b1Nn2BMEZyDKNkRkPJH9EVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793673555;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=1obNmdeiGvgYu4SrZA7IW2/sLeP9/qhwDqzFhh7JYAU=;
	b=hsJXYZDWC/k3H24l/qNX76ZUSblAsz/83khkaELvCjMBYF/7ejqd7+/L3gHYfwZ6mczV
	 8bm/zVbEEgytqHNS8L4B6mS2kJ96lE2ZZi+NGIN4kpEnszW0dX+wpilZoK8ODt9VQKtXD
	 J5KGTWYg+9ZTOZYvpFSTvBmEygZPIzKX8u0nvFvEei4e5ZJBVF/ex+tQPgnOje1ibX2Oc
	 Dg8dqtkbHaaGSHi2cFaXjC39YjQ4Hy8odI/BquiQHYqKGcPpaSz4i8Zx7a+wl7OiQNeH3
	 zT6RO/kqU3DJ3gDwkftb8coZHXtS1dYcFTG/zE1fUuyCHFcFTisYIrCDA5JJgqVVl2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Vd+3z769;
	arc=none smtp.remote-ip=113.46.200.219
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F236606A324;
	Tue,  3 Nov 2026 02:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F236606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Vd+3z769
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1obNmdeiGvgYu4SrZA7IW2/sLeP9/qhwDqzFhh7JYAU=;
	b=Vd+3z769FE2AdKqFFVuIOFI6gUYwT/dCQ9ZA6062sBZuqZKGctrvZW3aefJ7nHvSfYXaYcLxS
	TkC710+MiEdJryQUzEyLuUH6qs/riSOHQKzwbe3plG0hcrYHQj3zkV7aygFUcWkE84Dh7JEljCz
	9Dxow00Cls7ZuHhrX0N7aHU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jJXp13TtHz1prKx;
	Tue,  3 Nov 2026 10:39:05 +0800 (CST)
Received: from whupemk300004.china.huawei.com (unknown [7.152.185.168])
	by mail.maildlp.com (Postfix) with ESMTPS id 5049B40579;
	Tue,  3 Nov 2026 10:39:09 +0800 (CST)
Received: from [10.67.109.77] (10.67.109.77) by whupemk300004.china.huawei.com
 (7.152.185.168) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 10:39:08 +0800
Message-ID: <0ea46638-1d62-491c-8364-8a2d16837f88@huawei.com>
Date: Tue, 3 Nov 2026 10:39:07 +0800
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] crypto: asymmetric_keys: verify_pefile: fix integer
 underflow in pefile_strip_sig_wrapper
To: Ignat Korchagin <ignat@linux.win>
CC: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, <keyrings@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kexec@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
	<lujialin4@huawei.com>
References: <20261102074934.2925339-1-gubowen5@huawei.com>
 <CAOs+rJWjCTUwuYQMcBcbiUk8K_NQQtYGVFEBDEMZAKHWCLv98A@mail.gmail.com>
Content-Language: en-US
From: Gu Bowen <gubowen5@huawei.com>
In-Reply-To: <CAOs+rJWjCTUwuYQMcBcbiUk8K_NQQtYGVFEBDEMZAKHWCLv98A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk300004.china.huawei.com (7.152.185.168)


On 11/3/2026 4:49 AM, Ignat Korchagin wrote:
> 
> nit: the subject line looks malformed: weird "-next" suffix pointing
> nowhere. Otherwise:
> 

Thanks for the review! You're right, the "-next" suffix was a mistake. 
Will drop "-next" in the subject.

Best Regards,
Guber


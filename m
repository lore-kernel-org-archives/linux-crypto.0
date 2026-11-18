Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.76.10.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042928;
	b=S4XSbVUSzYLwHMePDL6T6wWMECmO3Vt6orjRkEeeDBjMomwiEleZ+qvvRfrkArlKguXX
	 Ex9MYvVhbvvEh+v13oZrptevBro0w1G3viYIDsxu1RsoWQHRtHLWH3Lc8fueOMnRjTIsx
	 vHAu/2pxm4RJcLz7Oeagy+eHM5R4seNjYabehckqkXQ0u5By3k4056fDS6t3GtBIovnpy
	 c2WzTh4tKOcrBRvF02dWEPBUykp3fajimgVpYJLJNAVysPP3QwGGsz7/sHoeYJH2FdvHu
	 2FU6e+DbIKmBiHzrGqxTjVlKx1d9qRxFNmPoS/gALFQzhDsqAV9O6seUUxqhHhT706Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042928;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-Virus-Scanned:X-Spam-Level;
	bh=X3maKqnYdaEm9n614F6elzN2A+NycPJ175S/7AVqG8E=;
	b=oPbln6MiqELDFxjdrD1lUfT5bzwNKg0L+kWEV8WVB9Z8ptk8s9T/wYeDJ+qjizOwlmR+
	 1+9sADIvv9kxY3PU3kiCSiKgZncgsEPhvOE3VYwmX2Oni/OPy9ZzpXZUU35tUkJYDX3QJ
	 iN6MYvKdJHvCmd2kgU3FNtfXi4Yb5A3NOpHhNxdAjfECtQikgm9vXjHxQjc8ZBVQaTGm4
	 A2FUatblBCfBP1PgcVow8hVfNz2Bz/ZPoNh2ru+EHsAYQ/ydxLj/ojL4A3p/Owq12x+Y5
	 zPVCHhKnOH2iroZHt7dpwXnVuqXgKVNbZKfLZ1+f8FxOna1dF81BiJxA/QOe71OS+Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cispa.de;
	spf=pass smtp.mailfrom=cispa.de;
	dkim=pass header.d=cispa.de header.i=@cispa.de header.a=rsa-sha256 header.s=2023-rsa header.b=QqrCcce7;
	arc=none smtp.remote-ip=134.76.10.21
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90D1606A32C;
	Wed, 18 Nov 2026 23:02:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B90D1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cispa.de header.i=@cispa.de header.a=rsa-sha256 header.s=2023-rsa header.b=QqrCcce7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:CC:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=X3maKqnYdaEm9n614F6elzN2A+NycPJ175S/7AVqG8E=; b=QqrCcce7/ZtqJ96qzrymjyPUfx
	m23rRr113aOGL0hLHDCQuOxOLJTkpVmrF8Cx7sQRW0agYz3L/XyVZVsDO2DtoThU2mVJ4M157vaG4
	5rd8zZoALzDjJYBCFe5JikGKuBwBbI+0aZCKEYbr6gbWFFLDZY080jvpoFErE05P7MIu+zwIur+bR
	WmBwfrsaJBoibBcS6VtRNNKISynX0qu5QueDEZS5jNaD7T8YGFXcj9HRf+4nGKB5rTKq+DrxBjtAX
	uvPNX2q3KWf5Fy/l2bYIEWSxqjcUkQz/vTzE7K3+FP5SDIFcGncvIgTrhXO1qDPhm9Pzb62hlkhwD
	amK4jOGA==;
Received: from mailer.gwdg.de ([134.76.10.26]:59524)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <florian.bauckholt@cispa.de>)
	id 1xToes-008jo8-1e;
	Thu, 19 Nov 2026 00:01:42 +0100
Received: from mbx19-sub-11.um.gwdg.de ([10.108.142.88] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	(GWDG Mailer)
	(envelope-from <florian.bauckholt@cispa.de>)
	id 1xToes-00050j-2B;
	Thu, 19 Nov 2026 00:01:42 +0100
Received: from [192.168.0.168] (10.250.9.200) by mbx19-sub-11.um.gwdg.de
 (10.108.142.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.57; Thu, 19 Nov
 2026 00:01:42 +0100
Message-ID: <e33d2059-0b63-40fc-996f-c962509c9c63@cispa.de>
Date: Thu, 19 Nov 2026 00:01:41 +0100
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
Subject: Re: [PATCH 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
To: Jarkko Sakkinen <jarkko@kernel.org>, Stefan Berger <stefanb@linux.ibm.com>
CC: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, Ignat
 Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Paul Moore <paul@paul-moore.com>, James
 Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Hui Peng
	<benquike@gmail.com>, <keyrings@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
 <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>
 <f38f6d32-16d3-4986-8d6a-9d65517f5317@linux.ibm.com>
 <av4KYKy7pZHyErVs@kernel.org>
Content-Language: en-US
From: Florian Bauckholt <florian.bauckholt@cispa.de>
Autocrypt: addr=florian.bauckholt@cispa.de; keydata=
 xjMEav3GRRYJKwYBBAHaRw8BAQdAnELDrQj5frnVfDEzfgTLq+dYQyGwNlrF4RK4Lnh0EtLN
 LkZsb3JpYW4gQmF1Y2tob2x0IDxmbG9yaWFuLmJhdWNraG9sdEBjaXNwYS5kZT7CjwQTFggA
 NxYhBCzYgazhZyFPZBJ6GB4ZurGrnfo1BQJq/cZFBQkFo5qAAhsDBAsJCAcFFQgJCgsFFgID
 AQAACgkQHhm6saud+jWpqAEAvdY72AqnlDNhbzgaDPghigkZxQsXy0SguVI4rIFdkYoA/RRN
 yQMEpqS/x1bseRnNFeLmtDviMLMoLUrKGY23VuUPzjgEav3GRhIKKwYBBAGXVQEFAQEHQElQ
 tDrQlEp5XdrAZUWzYVj26t0q0BhMLOqKLXSMmA5xAwEIB8J+BBgWCAAmFiEELNiBrOFnIU9k
 EnoYHhm6saud+jUFAmr9xkYFCQWjmoACGwwACgkQHhm6saud+jUl5AD/S78nLqAgIn53lOzT
 A8NTSByrtVvDBb9G9heETfLzVBIBANDFhjZQpssjUeVZ7QV/1GDL9ZhGssjnTQmzHKavboEK
In-Reply-To: <av4KYKy7pZHyErVs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MBX19-SUB-05.um.gwdg.de (10.108.142.70) To
 mbx19-sub-11.um.gwdg.de (10.108.142.88)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -

On 11/18/26 21:28, Jarkko Sakkinen wrote:
> Can these patches be rebased? They don't apply.

Sure, I'll rebase and send a v2.

I'll keep 2/2 in v2 in case you take it. Let me know if I should send it
separately to linux-crypto instead.

Thanks,
Florian

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.76.10.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043925;
	b=4iAdF++B665jP8Sav+I9rnoIa6jOeJEdFiFXTduwPaF4rMgKGRVB2eJuNxfmvAWXg3kY
	 pJN2nAz7fiBU05DtSvcOAVCt3uP610/bWGjEuYznKMmAzWuBVJz/cz95tIP1Pazv3jncv
	 Iz74Xkg8U3mwouqwgMxOMxKQ780h2/boO36DBmjKjVuYjQAdJXOBjuw9/aCUhtHTgdGfh
	 2LhpfFnOlKxg2dp4NM72OfscZAm397uDAMqgqdDzUIBH0AsYZFNClAEt7Z1aVBKbsGfVg
	 iHMwyRF6o0q2PTnXVtL3tuPM2mS+I1UpX21zGOtygwNBI0lpHxRkJqaB01e07oHjDwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043925;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-Virus-Scanned:X-Spam-Level;
	bh=JDoxYPpMuMBE75pF/Op+Adyf6/VS3J3TnGd9XMcVHtg=;
	b=D/6CE638MkNscUSymTk/WWjhNZ7CJD4fPA2LJh0bl+cxdNyt727FAGsBzelgUVTVQZrx
	 W031bxftVnikARJaHQruRRY6bw3lSQqAtnUfpRIRX7iNiGMl/Shu+hyBZEIjEsNfsWlPN
	 f9zbdIAPZDrRZqKnS7zH4u9htz3cU3GPga90ILS2y9YtvXbU09eBG78xsJNx1lcTmHADc
	 IW/1yNbH6JrSZ3cPIUro2S5whyo6e3hwOwaz7sqx64vLYVYD5qghcwTrJr2owb/LDaLEn
	 /57enf/cRs4wll6t7Z3FR/y8fcMSeFU0/CbIi6z7sZNgDtHeLZYfWkig8VijnpIIrQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cispa.de;
	spf=pass smtp.mailfrom=cispa.de;
	dkim=pass header.d=cispa.de header.i=@cispa.de header.a=rsa-sha256 header.s=2023-rsa header.b=YEBh6Uc+;
	arc=none smtp.remote-ip=134.76.10.21
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32460606A31C;
	Wed, 18 Nov 2026 23:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32460606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.a=rsa-sha256 header.s=2023-rsa header.b=YEBh6Uc+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:CC:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JDoxYPpMuMBE75pF/Op+Adyf6/VS3J3TnGd9XMcVHtg=; b=YEBh6Uc+Fs1XK1Yl0qcX4Zeyix
	6zjDCC+x569jxsg0+bW78XiDg0PyvCTLuGO/WkBCPqpRDvrTCX7j7JvNparhMwKI0IJghR10/hFV1
	7plvNq4OlPCeH1SUeADdyFj+FNBvuEPrV54xm2Q1lYGB232paeo2V/tW+JqGlkdC7NnzvMqEnjz67
	I/RZ9vopvM/uhUtcYjz9FEbl7X7Y+EqxlexW947xyObD79W5KFAInY+keI99+82SaTdxNWth+y73P
	a1OF/wGKISwqVzijHJqO0hWC+foDuG/M54V9MWWX6Z9KgQ9mKu465aOw6+JlsochB0iDHBrfZYZ1X
	d0lAQwCw==;
Received: from mailer.gwdg.de ([134.76.10.26]:37272)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <florian.bauckholt@cispa.de>)
	id 1xTovI-008jxB-2Y;
	Thu, 19 Nov 2026 00:18:41 +0100
Received: from mbx19-sub-11.um.gwdg.de ([10.108.142.88] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	(GWDG Mailer)
	(envelope-from <florian.bauckholt@cispa.de>)
	id 1xTovI-000AB3-36;
	Thu, 19 Nov 2026 00:18:40 +0100
Received: from [192.168.0.168] (10.250.9.200) by mbx19-sub-11.um.gwdg.de
 (10.108.142.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.57; Thu, 19 Nov
 2026 00:18:40 +0100
Message-ID: <db5a384d-e833-4ab0-baf3-619717b39f60@cispa.de>
Date: Thu, 19 Nov 2026 00:18:39 +0100
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
To: Rodolfo Giometti <giometti@enneenne.com>, David Howells
	<dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, Lukas Wunner
	<lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
CC: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>, Stefan Berger
	<stefanb@linux.ibm.com>, <keyrings@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
 <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>
 <0e20f799-e389-40d2-aaee-2f174748faae@enneenne.com>
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
In-Reply-To: <0e20f799-e389-40d2-aaee-2f174748faae@enneenne.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MBX19-SUB-07.um.gwdg.de (10.108.142.72) To
 mbx19-sub-11.um.gwdg.de (10.108.142.88)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -

On 11/17/26 14:21, Rodolfo Giometti wrote:
> The test suite of craf (https://github.com/giometti/crypto-afalg,
> test3008) hits this with RSA too: it cuts a genuine 256-byte RSA-2048
> PKCS#1 signature to 255 bytes and expects the verify to fail.
> 
> Maybe it is worth saying so in the commit message, since this is going
> to stable?


Yes, I'll add it to v2 and link to your report.

> I'll send my Tested-by once test3008 has run 2000 times on a kernel
> with your patch applied.

Thanks. v2 is rebased but the code change is the same.

Florian

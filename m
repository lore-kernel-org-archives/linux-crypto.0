Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.76.10.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795535671;
	b=p6iVNTGjmvOiw7dxHGbDGorGP3rhpCakHllB1fdOL7kxEZOKvFI3EkrKTkvHq9k4fRQa
	 V4c2xl7GLkx1xItQRYhw71YPsMwn7cWaOJTrj8AHXThULS4SKppUSo6ETxhjqlU1TflrX
	 g2TsIdpCCK0fDjwlkwQupfMZNxeMcHXlji2tUtTRwZf0PUJZ1FwxpeKP/RM+cQRSaG66F
	 6EWn27Oo3pUecU7uO7PcLLV644YRHYKjgG/kxjFxY+tGLH+Twmx/IElcXPtHA60SEz5Ed
	 rrw+5FpC5YdxgtA3mvYXrGnHV5MIRH/knzoiUUeDXuxra4FsqDv4Yqt2HX4e6JD2QkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535671;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-Virus-Scanned:X-Spam-Level;
	bh=hSy+H+hShpXfVAx28ypP7A4wHZge7gvgNn4QOg2Gqzo=;
	b=n9h0CYuoGKrrFmYDEkYKJExDnJPQnhgrlqsqGIZS6DgGLpnLplvDUYZoQQBrxUI222rM
	 AAQEhzbn1hSKQOfEJEETbgTt8GtdH7+XiO+ShM9eTvtJCjSy5WKOeqy2de+NW0WANMcgE
	 t7ySFJ2x7RsFDhmebbc23L8FGk3CHpY0xo49rW8hyEqtZojXaSM4Eui1ZxchF8RI+wGpW
	 PZW2/gECLz6ao4U0qR6UuK+GRS1Nmc3GgGzOx8+mZqfUCcc2RQvMeNgt0jzyQWSJQoHs5
	 92maFD8hMkmENkq70cN3ivwt5J7NdvnlePsjG3eRhNcKsG+tyoBrVDbuZe3OIGea5qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cispa.de;
	spf=pass smtp.mailfrom=cispa.de;
	dkim=pass header.d=cispa.de header.i=@cispa.de header.a=rsa-sha256 header.s=2023-rsa header.b=sDLOnWzf;
	arc=none smtp.remote-ip=134.76.10.21
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E52D606A699;
	Tue, 24 Nov 2026 15:54:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E52D606A699
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cispa.de header.i=@cispa.de header.a=rsa-sha256 header.s=2023-rsa header.b=sDLOnWzf
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:CC:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hSy+H+hShpXfVAx28ypP7A4wHZge7gvgNn4QOg2Gqzo=; b=sDLOnWzfkw17DBTLsqtuUDih7F
	S7xbEZP3p29/Udy9/Rq23ZEluJQM5Gocg/zi0sT9qo3Q4mZC+tVrK1dXi1dnqlsdGyyW75jvp/6/n
	oSYpA5DhCLer9AG+FMH6ZCg4Z/NPIPQPsmQ2AQ3FjCMtI9XPhJVSYFt+v517bV4MNl9TixbaAea5h
	y4oKub/Tm2Q+BZDS9qEl9/sHlOmYvkeNAOyNlXEaczGSEPIUg/xz1ALoWGxAiurkvfzUefV3/tnKU
	BzrrA5QdZAyJx1UoqlgjJWnEA69OAkH7PpQpvNB8BWz9VTROWzHfLj96eALBpDCKi1q3Jh0RKTZ1J
	EwxpCf5Q==;
Received: from mailer.gwdg.de ([134.76.10.26]:43056)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <florian.bauckholt@cispa.de>)
	id 1xVsqV-00BiEy-2u;
	Tue, 24 Nov 2026 16:54:16 +0100
Received: from mbx19-sub-11.um.gwdg.de ([10.108.142.88] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	(GWDG Mailer)
	(envelope-from <florian.bauckholt@cispa.de>)
	id 1xVsqV-000RMN-2l;
	Tue, 24 Nov 2026 16:54:16 +0100
Received: from [10.100.202.21] (10.250.9.200) by mbx19-sub-11.um.gwdg.de
 (10.108.142.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 16:54:15 +0100
Message-ID: <5d833d4c-bf8b-4ffb-a214-126de4403d4e@cispa.de>
Date: Tue, 24 Nov 2026 16:54:15 +0100
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
Subject: Re: [PATCH v2 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
To: Jarkko Sakkinen <jarkko@kernel.org>, Rodolfo Giometti
	<giometti@enneenne.com>
CC: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, Ignat
 Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Paul Moore <paul@paul-moore.com>, James
 Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Hui Peng
	<benquike@gmail.com>, Stefan Berger <stefanb@linux.ibm.com>,
	<keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Guicai Ma <maguicai@kylinos.cn>
References: <20261119-keyctl-pkey-fixes-v2-0-9e2d1c7db7ec@cispa.de>
 <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
 <80ded1ae-51a7-46d1-bb67-02b4b06de71b@enneenne.com>
 <av7x53CigERu-cf2@kernel.org>
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
In-Reply-To: <av7x53CigERu-cf2@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MBX19-GWD-07.um.gwdg.de (10.108.142.60) To
 mbx19-sub-11.um.gwdg.de (10.108.142.88)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -

On 11/19/26 13:56, Jarkko Sakkinen wrote:
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Hi,

I saw that for-next-keys now has 94cd21592349 ("KEYS: Fix asym key
overflow in keyctl_pkey_verify()") with the same (trivial) patch.
I'm not sure how this goes, but if you'd like to add some context, a
link to this thread and these tags can probably be moved over:

https://lore.kernel.org/all/20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de/

  Tested-by: Stefan Berger <stefanb@linux.ibm.com>
  Reviewed-by: Guicai Ma <maguicai@kylinos.cn>
  Tested-by: Guicai Ma <maguicai@kylinos.cn>
  Tested-by: Rodolfo Giometti <giometti@enneenne.com>

Thanks,
Florian

Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E26819AD70;
	Tue, 22 Apr 2025 06:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745304429; cv=none; b=XQcIQ+u+sTu3cXkeQkQgWvE39p7uT+SJfD7wdokLEHkLUrM3HvNiyDCdCFHulRIg4FO67r3nrQSap7kRS+zjhNFNNKJaW91mRcsk3+pk4jKZO+eoFefvy5jLzZAwSKswH6Pm4mzXKCiWs7Wxf3uJw+umDUrhLZt3Ci5e7o2cJoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745304429; c=relaxed/simple;
	bh=YVZluO1X3RBFmIJW0IpbWqo0OTOkQjv8Y327GQmpQS0=;
	h=Message-ID:Date:MIME-Version:To:From:CC:Subject:Content-Type; b=tePCemb5bCTMbpG12jdjXbk+eczn1XZKD+R0qa799LK0P2c4Kw9TfNaJAOzBhUMVHgLZjQ6eFDeW4F1kPmVrnVA2bLIbvsA2qBZ7cuHn9NRkLWejukoD6tt06UngjxZ8q45uSP3pNk3dNjcAzwB8a7jaYJqxjfF2v5sHKHpxlso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=bfKSwHP7; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="bfKSwHP7"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 53M6kx6Z1141738
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1745304419;
	bh=tq8l23R0jEoqSUhgWC0+5q6sVhIPkeqX4nI2eOWLTYg=;
	h=Date:To:From:CC:Subject;
	b=bfKSwHP7sQ6xW8FH9BIRMw9liA1CyRiuNHfh7oia/nQNjWvL8ugxiemPRm188sASv
	 TwqPmoKtXUmNkNGi1IZcZwWIYeBrHXIZ9WPlZnoHtu6AJb+4ZrPuY+I/XRrQOE7q06
	 G7kOAoOgVJK4eOXpglVCkcUweB3nQ/zyXGW54uJQ=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 53M6kxDO058966
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 22 Apr 2025 01:46:59 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 22
 Apr 2025 01:46:58 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 22 Apr 2025 01:46:58 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 53M6ktRQ109701;
	Tue, 22 Apr 2025 01:46:56 -0500
Message-ID: <01aad6ee-3885-486d-b7b6-2f78b61373bf@ti.com>
Date: Tue, 22 Apr 2025 12:16:55 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>
From: T Pratham <t-pratham@ti.com>
CC: <linux-crypto@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Vignesh
 Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>
Subject: Usage of crypto_engine APIs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi

I was reading into crypto engine APIs from the kernel documentation as well as other crypto drivers using them, for their proper usage. I found some seemingly contradictory stuff from both sources.

[1] says the following:
> You must put, at the start of your transform context your_tfm_ctx, the structure crypto_engine:

whereas, in already existing implementations inside the kernel I found them not using the same. Eg.:
[2]> 
> struct rk_crypto_info {
> 	struct list_head		list;
> 	struct device			*dev;
> 	[...]
> 	struct crypto_engine *engine;
> 	[...]
> };

and [3]
> struct starfive_cryp_dev {
> 	struct list_head			list;
> 	struct device				*dev;
> 	[...]
> 	struct crypto_engine			*engine;
> 	[...]
> };

In both these drivers, this is the only struct where crypt_engine object is included.

Another thing I found intriguing is that [1] specifies to put the crypto engine struct object in the tfm_ctx structure, which doesn't make sense to me as it is a per tfm object. Now, I have not explored the internal workings of the crypto_engine API completely, but it makes logical sense to me that the queue provided by the engine should be for across all the tfms. Which makes its inclusion in the device struct in [2] and [3] as above intuitive to me.

I have looked for any recent changes in either the doc or crypto_engine API to see if any such scenario caused a mismatch here, found probable commit [4] after which the docs are probably not updated. [5] also seems to remove all prepare/unprepare functions but these are still in [1].

I would be glad if I am guided for the correct usage of the crypto_engine API. And, probably, also if the documentation is corrected.

Thanks and regards
T Pratham <t-pratham@ti.com>

---
[1] Docs - Crypto Engine: https://github.com/torvalds/linux/blob/master/Documentation/crypto/crypto_engine.rst
[2] Rockchip rk3288 crypto driver: https://github.com/torvalds/linux/blob/master/drivers/crypto/rockchip/rk3288_crypto.h
[3] Starfive jh7110 crypto driver: https://github.com/torvalds/linux/blob/master/drivers/crypto/starfive/jh7110-cryp.h
[4] https://github.com/torvalds/linux/commit/e5e7eb023f24653b07329162b6359283b3a03a20
[5] https://lore.kernel.org/all/ZNh94a7YYnvx0l8C@gondor.apana.org.au/

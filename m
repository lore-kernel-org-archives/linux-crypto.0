Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1626B2397BE;
	Wed,  2 Apr 2025 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743603677; cv=none; b=uckLyZ8/oc24upm+t9hmvA8gTQO1bez6rMTz+77gZ0pU05sgoQ7y3QcuRuxbrY6fcl1w54YUagM/U5wkUkMm5u+DNdSP57pcUix86wKupkH6LUNW6tkeQUwY9xv9Ct5O58wXB4muVTaA8Nal4S2iWOWowH1W/wUsarE5uBxSRfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743603677; c=relaxed/simple;
	bh=7BuJdyTCmoO37hN9Quka69k520Yj1orAtR7/rp3+9V0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BqENczQ84aarDbYYnbR6ib+fvPb6rFlZmnsPF63De+vu85PrFqfvBSUEWwLLoOmYt+AEvpwvK4mjT5ppUAc2OcV+VFJ/VOXu4vH3B+tiN4kMEef5TSL/xFJO3GxW25qj+3kZmg6HcOSXEkMVlKwEwK50gF+mV9R/KmSLmN+wyxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=G6ZWEq1R; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="G6ZWEq1R"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 532EL4Wa3949008
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Apr 2025 09:21:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743603664;
	bh=7BuJdyTCmoO37hN9Quka69k520Yj1orAtR7/rp3+9V0=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=G6ZWEq1RJKpNknOj4U1ySK2yyMYp3vc58JC4ZeMgPFoRp1fKcJj+W04ZCa66SgiY+
	 jZr03U2e3sjUfsj6h1zVxRbjRfYq0j7nQjP4MzHJlhaLQIjgc5V2EMTGURwYYdzpKu
	 fOLtO+Qa49UgnImCAov9wn9Wxh5GAJrsqRUssdZM=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 532EL4Ow025430
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Apr 2025 09:21:04 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 2
 Apr 2025 09:21:04 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 2 Apr 2025 09:21:04 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 532EL13d100831;
	Wed, 2 Apr 2025 09:21:02 -0500
Message-ID: <0ccfcebd-db24-4186-820a-edb14d0d2caa@ti.com>
Date: Wed, 2 Apr 2025 19:51:01 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/2] crypto: ti: Add support for MD5 in DTHE V2
 Hashing Engine driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-3-t-pratham@ti.com>
 <Z-1AnemlJ1k8GeLp@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <Z-1AnemlJ1k8GeLp@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea


On 02/04/25 19:20, Herbert Xu wrote:
> On Tue, Feb 18, 2025 at 04:19:43PM +0530, T Pratham wrote:
>> +static int dthe_md5_cra_init(struct crypto_tfm *tfm)
> Please stop using the obsolete cra_init/cra_exit interface.
> Use the typed init_tfm/exit_tfm interface instead.
>
> Thanks,

Ok. Will update this.

Just my 2 cents: this would be more streamlined if there is some
documentation indicating the proper usage or code comments indicating
obsolete/planned to be removed APIs.

Regards
T Pratham <t-pratham@ti.com>


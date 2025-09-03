Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9714213E90;
	Wed,  3 Sep 2025 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756910735; cv=none; b=S33sGP6hxdcWlefjhqyVtbrihCkxsKd6Q+ti4cdlytvIqVU14dSPuSpdkGorIsXk/qpVuObmxRxYtLtUGWoURgeQTL2YSOEAcc7kNgsYGb2JDZ+d93v6MuX2LTE+7Sy0KfJv+9fKkvcErjIYt0CCqo1UlCqVzZZLg0wGOVYcj3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756910735; c=relaxed/simple;
	bh=7+gB4wClHZLbOPv8Ga3IIMlxYPUuhv8wxQJ/4mVAIN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XutQFxKi1ukPRL3MAWQG78w/xjod555hgT+tgRH1gY6nGYK6Dq8b8ohe/j3lW3jjl6f2r84titEa2OfV6nYZMX67G7VxYXAjK+Y2JrabP2KUz4x6+0IWyyjjhVZmPZ6vNXGFi/Wc+0LyOqpsBUIzxuZ5EfrCiL0op9xIRas54F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=chLVbEXB; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="chLVbEXB"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 583EjQ0h2853536;
	Wed, 3 Sep 2025 09:45:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1756910726;
	bh=TfPaCBrR2tmIHJVvAad4MWUXwXE/O4PmaW4tn4Elrow=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=chLVbEXBKAXHKbMs+9MjMrL03jucvt1pGrGOOfxfKtp4VgAocT61sIveT2rZ8q98L
	 3QRMm95QGE3rQ7JlTS9FSdEfW+IPj2BQRYp+c34IWykCUOF/5ClfzroVeU97v/00D0
	 EHTMk+FzEGv3gFMH7bHP5QqXAb15U1GCn6c1F81M=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 583EjP8J3673568
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Wed, 3 Sep 2025 09:45:25 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Wed, 3
 Sep 2025 09:45:25 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Wed, 3 Sep 2025 09:45:25 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 583EjLpE1727136;
	Wed, 3 Sep 2025 09:45:21 -0500
Message-ID: <8de87cc4-c46b-4039-bcdd-48133fe3c694@ti.com>
Date: Wed, 3 Sep 2025 20:15:20 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ti - Enable compile testing for dthev2
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Manorit
 Chawdhry <m-chawdhry@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth
 Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Kavitha
 Malarvizhi <k-malarvizhi@ti.com>
References: <20250820092710.3510788-1-t-pratham@ti.com>
 <aLK7vIQktZuJFAQd@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aLK7vIQktZuJFAQd@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 30/08/25 14:22, Herbert Xu wrote:
> Allow ti dthev2 driver to be compile-tested.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

Acked-by: T Pratham <t-pratham@ti.com>

-- 
Regards
T Pratham <t-pratham@ti.com>

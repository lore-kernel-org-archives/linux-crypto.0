Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24565340A5D;
	Tue, 21 Oct 2025 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761059459; cv=none; b=G/BiXzRaf1aMhGw2A790gZ1xKojsJu97DVqdIhTGrbz7gtKt6y2g2kJQ/h1shAD941d6LZUNc6vE3WmBEX7rQouPV4eceL+K9yJ4gpzl7aNwDcun/74mBjT4kqvyukdOeJNv7IGxFFDYKSm8OGiQUsm7TYLGYkcL/NfV42IEXZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761059459; c=relaxed/simple;
	bh=8UX2AOYcc1pJvShjqCkumWUTvtIN49sR3TGCRj1P9TQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=itv5SrPllFK8g1vU8VQPqst9/2yFV+XSVQ1zVpemXjyOzLqxHaulRzen73OiyNhh0mDBxUlIAGPLdl148xj8TBLL0mwwZeJBph5vAYQT3AkYjo8hnpw9lvJU27n1QbA2Ymi3V/e6y8T4BFczABY7kznIq0aA/F15FMcxas/hU+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=qHs96uoW; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="qHs96uoW"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 59LFAmIT1185633;
	Tue, 21 Oct 2025 10:10:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1761059448;
	bh=THUgBVvFZqvoUFLNnGVZTqBXS6eet/3dT4lK761pWwk=;
	h=Date:Subject:From:To:CC:References:In-Reply-To;
	b=qHs96uoWj/odh6QDja+Otn5aKic8lwd/12QMeCs6vKkskiNvhiNzM4Kyks1OT442h
	 I+H5FlQb9nI/sBaHcKbF7ALAEdwE0gRWl3OVyp5LMa/0VVVVpzMr6XwuOCywk25pNk
	 mJYHgaoalq5C/vDxaEZGaR13caJ8bB5UYvaco/H8=
Received: from DFLE208.ent.ti.com (dfle208.ent.ti.com [10.64.6.66])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 59LFAm1n1653813
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 21 Oct 2025 10:10:48 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 21 Oct
 2025 10:10:48 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 21 Oct 2025 10:10:48 -0500
Received: from [10.249.129.179] ([10.249.129.179])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 59LFAfcC3922619;
	Tue, 21 Oct 2025 10:10:43 -0500
Message-ID: <c76843e9-e644-4b9b-803f-b9eb9a31b89c@ti.com>
Date: Tue, 21 Oct 2025 20:40:40 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] crypto: ti - Add support for AES-XTS in DTHEv2
 driver
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Shiva Tripathi
	<s-tripathi1@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>,
        Vishal
 Mahaveer <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251009111727.911738-1-t-pratham@ti.com>
 <20251009111727.911738-2-t-pratham@ti.com>
 <aPHW_zyWwA36Usy1@gondor.apana.org.au>
 <07032efd-52a2-44e1-89bd-81602be9eb32@ti.com>
Content-Language: en-US
In-Reply-To: <07032efd-52a2-44e1-89bd-81602be9eb32@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,
On 17-10-2025 22:13, T Pratham wrote:
> On 17-10-2025 11:11, Herbert Xu wrote:
>> On Thu, Oct 09, 2025 at 04:11:31PM +0530, T Pratham wrote:
>>>
>>
>> You should allocate a fallback that is synchronous only.  Then you
>> can store the sub-request on the stack with SYNC_SKCIPHER_REQUEST_ON_STACK.
>> Otherwise the sub-request reqsize may overflow your request object.
> 
> Understood. Will correct this.

Since a similar mechanism is not available for AEADs, I was wondering if
doing the following in the tfm_init functions of AEAD algs (PATCH 3/4
and 4/4 of this series) is acceptable, esp. since setting reqsize is
moved to the algorithm struct field cra_reqsize.

+       unsigned int reqsize = crypto_aead_reqsize(tfm);
+       crypto_aead_set_reqsize(tfm, reqsize +
crypto_aead_reqsize(ctx->aead_fb));


I noticed all older existing drivers using a fallback do something
similar, and was wondering if you'll still accept new drivers which use
crypto_*_set_reqsize() to modify reqsize for fallback use-cases?

-- 
Regards
T Prathm <t-pratham@ti.com>

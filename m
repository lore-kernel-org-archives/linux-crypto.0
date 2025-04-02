Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E77A23E353;
	Wed,  2 Apr 2025 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743603140; cv=none; b=oxxkqOLjJPhZvGZTWgCLKx331V7gJv0CZnKGl48li19jUVxpQ3M0k1O8zAVfPEjuLDVo0XoP/Dl6a7gcpT9ea30Yb398mdqW0U8i9996OX+Gepiqs4luExmUnihjDqDKOPJbKXGII7YcqeiT/VdpNChRpk/Gch+vzvIw9Ykc2i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743603140; c=relaxed/simple;
	bh=8pobs8kkVx5NrgVJv8sO1zgsqGx5B98jV6dE3pZbOvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZF+j4CH7Rj+HBKxk+WgbBSsr7E8dPxzoOhXlKHE171Tcs8DCtui8dX8Y0uMOyr8UBGJOIwfZy+A/zJUoCp5L8iJZBLpasDV56zy0x35At3pXYEcUtmxcHUMxYmbmznQh+/lMWcPqsxiuNgsZUDAbfRCN0njypsD+f22m17LoXCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=miYnPYII; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="miYnPYII"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 532ECCxH3982460
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Apr 2025 09:12:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743603132;
	bh=kenBoeloxYsujPtfJZxqmcFSGl2ijQbloYkE6+412Dw=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=miYnPYIIa2dG2izACaJVukBom5N/pZyv4y0h6HKrwpZHfs2RMKaUpe6S9fzqi3BNu
	 ABDbsWrULj2XTYbp+/9Q36MyxgZ4grZngATXB8E9MgEYfLAvTib2kepHJfhuOnhqJU
	 QLz9ukHvqaMmGBU7CVVsC3Hxr2YtjaatuA4q/N6c=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 532ECCZb020524
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Apr 2025 09:12:12 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 2
 Apr 2025 09:12:12 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 2 Apr 2025 09:12:12 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 532EC9we090321;
	Wed, 2 Apr 2025 09:12:10 -0500
Message-ID: <c86a5251-a165-41be-9238-53fb133206a4@ti.com>
Date: Wed, 2 Apr 2025 19:42:08 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512 in
 DTHE V2 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
 <Z-1BnSGNab34W6eU@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <Z-1BnSGNab34W6eU@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea


On 02/04/25 19:24, Herbert Xu wrote:
> On Wed, Apr 02, 2025 at 07:01:25PM +0530, T Pratham wrote:
>> How are you planning to restore such states in import if the export is
>> to be made compatible with sha512_state? Do you have any pointers for me
>> on how to change the import/export before sending the next revision of
>> my driver?
> In struct sha512_state buflen is simply stored in the lower bits of
> count[0].  So when you import count[0] you can derive buflen from it
> as
>
> 	buflen = count[0] & (SHA512_BLOCK_SIZE - 1);

Thanks! I'm assuming then count[1] will store the digest count in sha512
here.

Is this the same for SHA256? Since there the count is not an array, so
is it then count = (digestcnt << 32) & buflen? 

>
> Of course when you're exporting don't forget to put buflen into
> the lower bits of count[0] before you write it out.
>
> Cheers,

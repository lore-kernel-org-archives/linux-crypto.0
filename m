Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4442E69DFC
	for <linux-crypto@vger.kernel.org>; Tue, 30 Jan 2024 18:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706639753; cv=none; b=F6HaViWFfEue0JKLPIRdJa2YTgxkr1f6goF9b0TbpnE65ntd31VofOpuWTvEbjU9Ide+u6ye3ervzXagVnXspyO/k+hG4Et3Dni0DjmlwDmSYxlJM4+paHJYi8mWwgn1suPxc0lFsWgOxexb6AVOt8+ZhmPfwvd8Z4eP4L/8Tpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706639753; c=relaxed/simple;
	bh=ljrTZE5AmzIYm4c77wtw2sTbgaocYOzftgKfOXOUR7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fOcJV95NjYLsaUt0rw5bLPRFqcMObGOC3gf68Wmf86PxZfjL2gxPUCWqGtcAcEppzNLVGo1N2NwOy35AJJZNhrjaEvU5I2cPyT9I9PwXIBX487s8K/hQBv7Etd3dyIhmQXoxMY8C5Do8GZ2DF0g+Ppg92+ftNygCCxhD3qsGsJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=luNCQkVg; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="luNCQkVg"
Received: from eig-obgw-6010a.ext.cloudfilter.net ([10.0.30.248])
	by cmsmtp with ESMTPS
	id UsajreM1a80oiUsxbrkPOP; Tue, 30 Jan 2024 18:35:51 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id UsxarXUBRfPByUsxbrBeC8; Tue, 30 Jan 2024 18:35:51 +0000
X-Authority-Analysis: v=2.4 cv=T+af8tGQ c=1 sm=1 tr=0 ts=65b94187
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=WzbPXH4gqzPVN0x6HrNMNA==:17
 a=IkcTkHD0fZMA:10 a=dEuoMetlWLkA:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=_McAEue1L0tuIqTs_I4A:9 a=QEXdDO2ut3YA:10
 a=9cHFzqQdt-sA:10 a=PUnBvhIW4WwA:10 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HeXgS6V1eXcqJmrlxF09S/iG95SP1OD907y8w1At448=; b=luNCQkVg23fduAzTeH1EX1W3Fw
	6jGZnpHa10iChrPqw0lKPgraFjs6cZKIEP3VfWqkFhdwU9G7la6FGBNM5fqYRQ9CpQGKGkL4M5sX+
	aN4nb7Sub9nFixAxIvtUwC/EQgxKLOXCuQRzljufe+TVBG1zeYZmFe1GVqxu12uCSUB3WMnDoNWoR
	mzKRdGb75g1LICkxzbMbAoOUSBx4mgurlJJbkkw9u6QU2NVrkSia26qGNWzpfy2PYmQIGAMtIQjR8
	lyCYZnppQd3HffDm9xDx+DHLhrF17kgyRjWlqXv7xqCQCKAyjAi/sjW/+uU4poGLzHzX9cubEpHMO
	XtnJhH3w==;
Received: from 187-162-21-192.static.axtel.net ([187.162.21.192]:58618 helo=[192.168.15.10])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1rUsxa-00320p-0B;
	Tue, 30 Jan 2024 12:35:50 -0600
Message-ID: <4fc7ea97-f732-495f-a728-ecebc0451c85@embeddedor.com>
Date: Tue, 30 Jan 2024 12:35:48 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qat - use kcalloc() instead of kzalloc()
Content-Language: en-US
To: Lenko Donchev <lenko.donchev@gmail.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <ZbeguDTmVrP9SnDr@nixos>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <ZbeguDTmVrP9SnDr@nixos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.21.192
X-Source-L: No
X-Exim-ID: 1rUsxa-00320p-0B
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-21-192.static.axtel.net ([192.168.15.10]) [187.162.21.192]:58618
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJLWADYxOQMP+xXFvjGy4Z1c1a27uxcyWL85w25jipdLyBp0rySTgmBG0yrnfqKiriGjqhbZxXNiTR3B8I2nSW3C3zgpuFuxwJoQja7nmHhkrr1DWBc0
 l5hluF6J73NvwUvWSD9iDalsD8m874tVrUtqdiUdq9tXMYNsIlWOLzDHRmpV86PQLEVvkWM0888Mn1SlSijodlfyMqNN1cY/wkqpuklfn/BEOCsvG4T38275



On 1/29/24 06:57, Lenko Donchev wrote:
> We are trying to get rid of all multiplications from allocation
> functions to prevent integer overflows[1]. Here the multiplication is
> obviously safe, but using kcalloc() is more appropriate and improves
> readability. This patch has no effect on runtime behavior.
> 
> Link: https://github.com/KSPP/linux/issues/162 [1]
> Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments [2]
> 
> Signed-off-by: Lenko Donchev <lenko.donchev@gmail.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
-- 
Gustavo

> ---
>   drivers/crypto/intel/qat/qat_common/adf_isr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
> index 3557a0d6dea2..a13d9885d60f 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
> @@ -272,7 +272,7 @@ static int adf_isr_alloc_msix_vectors_data(struct adf_accel_dev *accel_dev)
>   	if (!accel_dev->pf.vf_info)
>   		msix_num_entries += hw_data->num_banks;
>   
> -	irqs = kzalloc_node(msix_num_entries * sizeof(*irqs),
> +	irqs = kcalloc_node(msix_num_entries, sizeof(*irqs),
>   			    GFP_KERNEL, dev_to_node(&GET_DEV(accel_dev)));
>   	if (!irqs)
>   		return -ENOMEM;

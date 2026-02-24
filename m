Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D58329E62;
	Tue, 24 Feb 2026 07:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917196; cv=none; b=A1VSqkdGrj3jj/P9fEp7Mau3ECMStu3Qpd+z0y9Ktb7NvtT88w8any7awMoo7TUOVjqKaozt0FPb9BPJnXORKKeP1B2r7vn4gWas+oGUcahbTEMHi2+DeSAsiEjzPBvRnwreNTgnmvNEuKT6O6aigN9cC7rjq8cEnmE8HlIe9mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917196; c=relaxed/simple;
	bh=gT3Z9VwacZLiPojVKV1a555VltfgJdVLIdkkGbn0zUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aauMHT2UDM06N0BZubk1G+gc6OFENv060bTst/Lywgi0RWomJs1hJhgwBb9P4pQypSuBPoe99rYGrePx1HEjyIrJ8E1wzmUqM417oi3jbaGNxhlBu4ZMi9rge6TIumSKvQVtam9VzaZb/L3DXMVNfXrLGp9Q5BwuEAR9Bm+Bh4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=to8P4uko; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="to8P4uko"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=iiGyVPiVaNs3lC363rqu96E2n22OG530jrIJC4IgC24=; b=to8P4ukoTLZi9W5jUBXQeG5TwC
	T7Njbi6xQr8t7OeusqPNE7WdZejtJ14bXPwGJ5r124xHTuWnYnwM2dAyDDOpIo3v8btZ1OmeHg1O9
	Lt6ibXFGVU94Cq9nRH2HWZY4ZTxzuqXsbRDTFYtBp2txHmQ0DS3fPSKYNWt9PwB7+GE3s4qIY0uOz
	0JIwm+GxpmMeo7lCrZTRLgxwwC1fQK/gv45khcdCQ1zBG0xC+EAIeZ+bbDjpdPt9FlrgwK6vrkcUG
	XvZBeg6nROoinU48VoM5Rk3yrbEjZJlmC36N12f3AAeWC8t6rjQMrlncbbO7tK3J9VZFAihikDIF7
	s6/mInnw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vumbV-00000001Z9Y-3GhX;
	Tue, 24 Feb 2026 07:13:09 +0000
Message-ID: <baa318b3-e3b5-4320-828f-dc41c3a5f9da@infradead.org>
Date: Mon, 23 Feb 2026 23:13:06 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] treewide: fix duplicated word "the" in comments
To: Yousef El Bouzidi <elbouzidyyousef@gmail.com>,
 linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 tglx@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net,
 lee@kernel.org, hansg@kernel.org, ilpo.jarvinen@linux.intel.com,
 ansuelsmth@gmail.com, atenart@kernel.org, wens@kernel.org, hauke@hauke-m.de,
 andrew+netdev@lunn.ch, kuba@kernel.org, david.e.box@linux.intel.com,
 akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
 hca@linux.ibm.com, driver-core@lists.linux.dev,
 linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260224065300.454633-1-elbouzidyyousef@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260224065300.454633-1-elbouzidyyousef@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/23/26 10:52 PM, Yousef El Bouzidi wrote:
> Remove duplicated word "the" from comments across various subsystems.
> All instances are clear typos where "the" appeared twice in
> succession, often merged with the following word (e.g. "the they",
> "the there", "the these", "the them").
> 
> Files fixed:
>   - drivers/base/platform.c
>   - drivers/crypto/inside-secure/eip93/eip93-hash.c
>   - drivers/mfd/axp20x.c
>   - drivers/net/ethernet/lantiq_xrx200.c
>   - drivers/platform/x86/intel/chtwc_int33fe.c
>   - drivers/platform/x86/intel/pmt/class.c
>   - drivers/s390/crypto/vfio_ap_ops.c
>   - kernel/irq/migration.c
> 
> Signed-off-by: Yousef El Bouzidi <elbouzidyyousef@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/base/platform.c                         | 2 +-
>  drivers/crypto/inside-secure/eip93/eip93-hash.c | 2 +-
>  drivers/mfd/axp20x.c                            | 2 +-
>  drivers/net/ethernet/lantiq_xrx200.c            | 2 +-
>  drivers/platform/x86/intel/chtwc_int33fe.c      | 2 +-
>  drivers/platform/x86/intel/pmt/class.c          | 2 +-
>  drivers/s390/crypto/vfio_ap_ops.c               | 2 +-
>  kernel/irq/migration.c                          | 2 +-
>  8 files changed, 8 insertions(+), 8 deletions(-)
> 

-- 
~Randy

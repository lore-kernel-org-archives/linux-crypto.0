Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C31B35DA71
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 22:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577315; cv=none; b=Tva88RPS/5utc16iellJcn7S+t8UiUF0pZj9deDvie8I8S4TJAvE8LDfPnNSsTlbuHaabE5mTxZ8PQVPqpMvxmGKqWiIOOqscUBNUtY2vDWwJlZ61BsRzqCd09lLkVK1MMNMbUj9AzvtXJv15kN1q9VY+wVy7f8FEZEbjdQCaP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577315; c=relaxed/simple;
	bh=Rfm52zSu2HGUSdIiLKfU3zTtTYX02jGA3AsNVafekYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0CBJZ7ydG2LyRC5DqDaJE2KurtQf/Wdd26x11OMb/eDezGEZAYPWFJ7J3R12IpHxtU88h+ygkPwJ4khDwwefbjoOiLe6GKRKVQQnDb4d/YLGd4wpqJym2c4Hk+4kqUNbVT3Th5oeC/GvjIcbSvoWXf35dV0jQWmK4eyH5ph0eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gL3fr+rx; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gL3fr+rx"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2bdecd00ebdso583159eec.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2026 14:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772577312; x=1773182112; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jMrDJNCgdkeQkoqQI6cQjxkbEQKVW+efRqHQbomqEkE=;
        b=gL3fr+rxuT5aZReb5zZhVNWk72btq09dNBQJMguQXF58SY/W+RvIU6WLiyptihv4TD
         gGC/TIf4SgRYNWqid2mrreHNNHFAd5q34ebK8PyPNcgb5A0rwO0UR7PQexsfU13UraZy
         cFLivSem53/C681gu7BPEGhrLDRzJzVtWgdGUZHlEuSi0Runy3Jy2239ygMeu8Xos7iC
         tG6b0bTEYaBDSjGxSUXpKzWRQUOMuXVif/8aSzlU+hHIT7HpCO2rkEyTTdJK6S6sTjLN
         KaRhaVoOYucr0eJG0lZYR58bZ8il2l1NKpO7M4oHIsDCnCfMYnlThcZtYehafI34AXEL
         SUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772577312; x=1773182112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jMrDJNCgdkeQkoqQI6cQjxkbEQKVW+efRqHQbomqEkE=;
        b=ZyJV5vtLE0db8lLgAXxm85ZZw9i8el9GCsUb6hXOsS10j3YHE2CayqTlVj43984cb5
         fbw5XjDxatlErkl07qqNfHICa/sG8++sLCuN6V94Yt9Je9s9MVPgZqnM25LkKfh8SB7E
         tIxJBElU+XqXKP/fk0H8itBdPoRAU9d8XZ3L2b2ooyUaOcQ8fcmSTQ+nbhyggRJimeA9
         slhdbAn2wvNezY701Z/6+6DsFnVDPb7vi5wxwzNuidMBPkdF133W+dWKorUXvy6DgN+m
         BE1PMAbg49YwtEuoBYuOB7DgYf7HOwD8YWngZlCGdAeRuDoBMTBZ04/rWRyCBo7fPhUm
         0YwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEh6THaAgvs9W8+p5LyBnaJzg5o9oP7MKizVOeClOWf9jISzjZCWKUeWIO307nMB0POBHM9i5JZp8lhxM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3+iySruY7U9KwDXzLPxfb4Ru6o6k51lOUWmcvqAfhXm8iM1KO
	2HVjaDWthDrL6tuk8o6+vd1YWkimssFLwboQ0y76lmxURkWu+5SGEjJH
X-Gm-Gg: ATEYQzwUZp1sZILvAsrvB+TH2ZWzrSUJqGWuSSZjRHWkYAwbjILywc5h8y2nBPZlRYY
	THZ90Dw7xB9rVeqa8JqRH3oeOO+LlCf7uT/82WzwRZToSVsoUrM4cBxGM92WIbkKVUH6kFkn1Mv
	FnVmD2Ji5qQ0Z1Jl4a/55ADqBn628j4sxAieoujn7O0lBk1Vuiqk4A/U2kChuMlktBiCLjUfmjd
	NQlFIH8Vh11fQNkqCXE0zDhEt0Gn3YsG3pk++lS06HDq6tnwIFRh9Z2qMbBDoHWjJvbb9iS2vir
	5PvqLDuMuFLGI2udM5+NeKLfrYoGTwPcVKD5h6A48saae3YqNssrTgaYP2wWZyOVj9SW4sGrgqY
	qbmKuq6+RuaDQBbDoS121Qm3coka/VbWXmBRZapI6qR3XA68yHjJJ71yvol2MsEPEWmy9yIpzms
	z0kGM3yuldoSpG6xAF5l5rzYPm9DnjEbR07roG
X-Received: by 2002:a05:7301:5792:b0:2be:26d9:da9b with SMTP id 5a478bee46e88-2be26d9dfc4mr1145572eec.35.1772577312277;
        Tue, 03 Mar 2026 14:35:12 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be249ed6a4sm1879476eec.11.2026.03.03.14.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 14:35:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 3 Mar 2026 14:35:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH 1/2] crypto: ccp - Fix a case where SNP_SHUTDOWN is missed
Message-ID: <0182578a-424d-454f-8a38-57b885eb966b@roeck-us.net>
References: <20260105172218.39993-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105172218.39993-1-tycho@kernel.org>

Hi,

On Mon, Jan 05, 2026 at 10:22:17AM -0700, Tycho Andersen wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> If page reclaim fails in sev_ioctl_do_snp_platform_status() and SNP was
> moved from UNINIT to INIT for the function, SNP is not moved back to
> UNINIT state. Additionally, SNP is not required to be initialized in order
> to execute the SNP_PLATFORM_STATUS command, so don't attempt to move to
> INIT state and let SNP_PLATFORM_STATUS report the status as is.
> 
> Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reviewed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 46 ++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> -	if (snp_reclaim_pages(__pa(data), 1, true))
> -		return -EFAULT;
> +	if (sev->snp_initialized) {
> +		/*
> +		 * The status page will be in Reclaim state on success, or left
> +		 * in Firmware state on failure. Use snp_reclaim_pages() to
> +		 * transition either case back to Hypervisor-owned state.
> +		 */
> +		if (snp_reclaim_pages(__pa(data), 1, true)) {
> +			snp_leak_pages(__page_to_pfn(status_page), 1);

This change got flagged by an experimental AI agent:

  If `snp_reclaim_pages()` fails, it already internally calls
  `snp_leak_pages()`. Does calling `snp_leak_pages()` a second time
  on the exact same page corrupt the `snp_leaked_pages_list` because
  `list_add_tail(&page->buddy_list, &snp_leaked_pages_list)` is
  executed again?

I don't claim to understand the code, but it does look like snp_leak_pages()
is indeed called twice on the same page, which does suggest that it is added
twice to the leaked pages list if it is not a compound page.

Does this make sense, or is the AI missing something ?

Thanks,
Guenter

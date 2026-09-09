Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B025397E81;
	Wed,  9 Sep 2026 18:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788977982; cv=none; b=QM8U5MOImVOmIIpdjJpV+c41XrDHg+o+7mL/dX8ponV3GRY+dMNMFWD7aHLKrA4PbYQ85HpYkrJ8c8XBmEbQX45gQkYTrUmXCNoegGmqCZ6o2zcclYQQyBbensC+U6HnxTa6xvXy1PK8M/S4i5NFV0jsynAe3NGnMyS6i2lKmRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788977982; c=relaxed/simple;
	bh=AMkeSrv3TNLA0b+ae2lEt0abnfG1Cy6UjYmZ9+sAtxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y8fLFZymReJAI4ge6hpiTmxpUzfNdUc6s63WhammiaYJ5wat6c67vhZ7OoZ/PaL9G2H13xj+1lvfj+oSl+HDsb0I+fruGfMW9lP7IXzaqz7QRhs+8Xi1AfYLpMBNtyOBPkH+WYmmkgzdLpATMfmyY45pznG9E/i+IU7vgndYSc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xsYkv6BW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xsYkv6BW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=sHkG4QaVjAsEhbqxdpXlyCIOoCdEDOiGYyMAIZ1BJKw=; b=xsYkv6BWSKHLtKIqtHPX7jXkf6
	e65d4qmHcjot8l99XCZniRbuVU7UD8Xy0QhzX+D+BT9OwrsAYxPuCmgJpJMSkn0tVAwih/NH7Mcyd
	BavxwHXmXEXmNQonpQJ6kR+e4tPIqkWvlunBqMNDTMPwbJ8igwmgoWmzyqeHgtSRLjChsr0+qJDAY
	O8T6TKbnPGo6O44/lYEgKGUCgkUwee6r0jzzx/4YjGkBH8lO5fc30/xtQNFlhFSzKUYUWmlcFtSS8
	lktyXnrwoLbdLNdXjJK4pqdja7R8i50No9d+XFQZc+9eRKXJIQZZrjsDek3GYyaCmSgAKOvBMAE8S
	3d9m6o1A==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4MtU-0000000CbKB-3S1A;
	Wed, 09 Sep 2026 18:19:36 +0000
Message-ID: <047e260e-badc-4fee-ab98-79a946132c40@infradead.org>
Date: Wed, 9 Sep 2026 11:19:36 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: psp-sev.h: clean up kernel-doc warnings
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org
Cc: Ashish Kalra <ashish.kalra@amd.com>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
References: <20260901001438.3917854-1-rdunlap@infradead.org>
 <108bb0a4-d6a0-4a6a-8fae-33d3d9484b57@amd.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <108bb0a4-d6a0-4a6a-8fae-33d3d9484b57@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Tom,

On 9/9/26 7:57 AM, Tom Lendacky wrote:
>> -/**
>> +/*
>>   * SEV platform and guest management commands
>>   */
>>  enum sev_cmd {
>> @@ -162,7 +162,9 @@ enum sev_cmd {
>>   */
>>  struct sev_data_init {
>>  	u32 flags;			/* In */
>> +	/* private: */
>>  	u32 reserved;			/* In */
> I noticed that, for example, struct sev_snp_tcb_version_genoa_milan has
> the reserved field as part of the kernel-doc, which seems to eliminate
> the need for the "/* private: */" and "/* public: */" comments. Would it
> be better to instead just add the reserved fields to the kernel doc?

Is that your preference? I can do it either way; I don't have
a strong preference for either.

thanks.
-- 
~Randy


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793091111;
	b=gXog56bxFxIgr23msS704QxYVvbfXtmBLmD3caxRHAM+vt2undk5i33ZKzsL2k6qZ8iC
	 IocT8EmgqPKPVzbrjGDmOY/DezBS62x3GR2OF6nfYglRO2mUb3yaUZozYdF52GXB8LQMM
	 waF0MHMMW4t3iq8j/0mUt+blu8mU/DwCRWOXLdFIUCmGyNBASwolbGU+d0FztL79mBukI
	 F/Cywn+9e9YM/cwea96XTVs4Q8/KL1ddcWWG8GWtj4iniB0IkEFktbSW4hIekLMp35hLb
	 fmSfcjXf10HLgPA4KYJE6uQPizuRrj3MnrWdw+1o8WhPpMPbMWZ9/Dh+egDjoxy+oOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793091111;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=Oevbdiblvp054dFoiv0TL11EmhqYMJMO42rw2p6kvvM=;
	b=JZS/U7CDREFCHcjytSiHKLA9L3N73OjTSk/VDeJQYZjLNfRHVDsSPGprAP4CufDXMO2K
	 0KE3hZTJUnjmrntGyxA8Rl+fIQz0emyRmRBrpsPyTc+JC1JDttzw46s7nl+Cuipdko0WY
	 1uI+p6+jv+OJNmLw/XTL9nrxXhTkdo5i11QIBtdalNHR72QPe9q9A8GCacpwx0/8Adra8
	 vf3IFzOj3rnU3GkLB/smSKPEwpdCacIWr6rEmHDpbt6GXPB2dBtNpu4i8FBOeuTKtnAO9
	 utc94AuUShC+9qHY6u4vEugWaQXz3+dA6kMEhe+Yb0vRP0k4ESBjlOmXOFbLYjZsx1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=1cUYacTP;
	arc=none smtp.remote-ip=195.10.208.51
Received: from mout-b-206.mailbox.org (mout-b-206.mailbox.org [195.10.208.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BF9606A31B;
	Tue, 27 Oct 2026 08:51:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1BF9606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=1cUYacTP
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-206.mailbox.org (Postfix) with ESMTPS id 4jDPP83jG8zB9;
	Tue, 27 Oct 2026 09:51:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793091100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oevbdiblvp054dFoiv0TL11EmhqYMJMO42rw2p6kvvM=;
	b=1cUYacTP0JB2PPGpyqcRFlCX2wR2AypXVf15lqHERELnf6V/lZxn8nv0jMZ4t/6+GEgmw6
	V514OrfWVTnagrTsD7sDpzu4TGC781FHqOu3yilQZSNo27vHieOBL8HejUSj98XN5nSoGz
	Uxhe8CflxCG3l2UtJMccxVMEFMUt03OeE9NKR0pPzZTyTDq0qWCZIEKLXVlz60Rst8vjlk
	okUlTCW6YutVPsigY8Er45BN72cW5veltlZ8fpLD6wBoJ/13u6S5Ezjfk+vtoq7MXOOXD7
	ejGDfCxUhquVlnAjt1mOz4PjJKgBAiboRRCO6YY+J+rEkQApGF5c0z4Hm9wRsA==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <bf6f90a3-7f47-4b39-a746-533da0913a2c@mandelbit.com>
Date: Tue, 27 Oct 2026 09:51:36 +0100
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
Subject: Re: [PATCH 1/2] lib/crypto: tests: Add KUnit tests and benchmark for
 ChaCha
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
 <ardb@kernel.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261025234758.3219829-1-antonio@mandelbit.com>
 <20261025234758.3219829-2-antonio@mandelbit.com>
 <20261027015313.GD2395@quark>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261027015313.GD2395@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jDPP83jG8zB9

On 27/10/2026 02:53, Eric Biggers wrote:
> On Mon, Oct 26, 2026 at 12:47:54AM +0100, Antonio Quartulli wrote:
>> +	for (size_t i = 0; i < 10000000; i += max_len)
>> +		chacha_crypt(&st, data, data, max_len, 20);
> 
> The calls to chacha_crypt() with constant 20 argument should be
> chacha20_crypt().  Mainly so that if people copy-and-paste this outside
> of test code, they use the right one.
> 
> Otherwise this test looks fine.  I'll apply it once the merge window
> closes.

ACK

I'll send v2 with chacha20_crypt().

Regards,

> 
> - Eric

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com


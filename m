Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAB73D386
	for <linux-crypto@vger.kernel.org>; Wed, 21 Feb 2024 09:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708507204; cv=none; b=GLxbCEPCGI5IdYA7ekPDRzsPdl9tG6Br4ovSTC4GrSDidhQnfSnwwuWRhYQum+IMqPlrKcUtq33CdEoePqYTZqKsc9+gUMYDIdlKVtxOl+7Gcw3fiaYGdsw6z28gLizhXtxgtjtoMtF/zO3hNW1yHHIRTrW1X4EyvZUrCJZ/VQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708507204; c=relaxed/simple;
	bh=4XKCRgUfql1oqSuMEzciwfrGkQGpXj7xWamweMtvSpI=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=LeyM5mqmG6xC4yBw9eEzpmWE+17gidzhe1iDPhFUrjapHs6qF9W7ie07Ldo0iHe/VZCHadLroTqGpHcFj1426Cx6omP9t7g5SmMsaLgk1rCmC4pitb2s3vfBTQwRZovXhe6vfJ10zweuTwXIvt5HESy1TzBHrk3+0+ofVniO2ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=JMKOfvPE; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="JMKOfvPE"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3f1bf03722so134127366b.1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Feb 2024 01:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1708507201; x=1709112001; darn=vger.kernel.org;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=rCRVDVCLmJfFciYW4Erv9msTdo2+veeqDEBTOdxyHoo=;
        b=JMKOfvPEJs+JnftpENEfGIkeOxQtuH130EhAGgTO2GEFzFlOc4Z3dWdvWpjRZ1eWO8
         6oze6QC+IMwl919hh2CsCUTDwFJPFrvniNBEULYrDmCujnqXdYpnqbi3Xe9hcV8mHA7G
         ek3p9nIVtjT3JZTqHJYy/nz7OEFt6Nhvews37K2pGYxHNmbOIpgHGcpTc8SFDHFWGW75
         4TWrjH6tQZ7dl8DvDwNBtVcaMiirAFEQGiBTG2FmIE7ezPWv9N+hEiGLoON7p7oD3Hjf
         OwFRSSk+zAdl1dZiHpUN1wyurVWqqRkoMLb+bnr1gGETmim5MyweCbowEhjNbV1ylWOI
         Zgzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708507201; x=1709112001;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rCRVDVCLmJfFciYW4Erv9msTdo2+veeqDEBTOdxyHoo=;
        b=N3Yw6FSuWdPvbXOmb5CJei+KYfPQWdeH+Ka5cv8ipn8vkdYiXkXWM7DJWPmH8YsIaF
         gReR70MhCa5Dqx5VitjeR15yi5N4MRYKFrIS06LX7F5nRlaZ+egvpAEewPJiwMRev+/A
         9/4ZxjWrV8Sfxi+sqc6Ke7Iqbz1m6puPINgyOr9jJfNl6ZQYIX7c3Y06Pl4jTJdjrYFS
         GkLOYPimqShABD2yOWoLR5zyTPt+iCThwokK3qQPLsIBPtCjrlabb2i8WrbNvDOAjunv
         vEKTq858E+W8HCMjH8BhrsbGu1ZuCDtAk+xI068oErS2jOL0iq9NH2WvfTbRVfo11P41
         yVpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUz5pmaroYIOa9Cm5lXBCC9wmSbipoU+Zg4DZ79+TfPffL7fwnBnX0VXiQOBgty8Dc4NMVW2UBXjJry9XXgmC1MIKRjwLC6R5jwAvI2
X-Gm-Message-State: AOJu0YxtvEh6ufU32Y+bAh18NvAtb1rTiBV939N41RPY8ob0FvI0ZC3/
	L7whaVhvs9dhIBIjq8WFLku2C4/sUPT65i2yVwpRo/s2sob5AsBeswkiLT+RAWU=
X-Google-Smtp-Source: AGHT+IHc93EonCQYXHRQASAv9tZM3yEJ5V7LFqiM5p0TzdSVqsAegne55+3xR6hpv3gdYC4FnMCD2g==
X-Received: by 2002:a17:906:81d3:b0:a3e:c9f5:fbaa with SMTP id e19-20020a17090681d300b00a3ec9f5fbaamr5180374ejx.68.1708507200808;
        Wed, 21 Feb 2024 01:20:00 -0800 (PST)
Received: from cloudflare.com ([2a09:bac5:5064:2dc::49:d4])
        by smtp.gmail.com with ESMTPSA id jw2-20020a170906e94200b00a3f0d98c125sm1199602ejb.155.2024.02.21.01.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 01:20:00 -0800 (PST)
References: <20240115220803.1973440-1-vadfed@meta.com>
 <20240115220803.1973440-3-vadfed@meta.com> <87frxmmci7.fsf@cloudflare.com>
User-agent: mu4e 1.6.10; emacs 29.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>, Jakub Kicinski
 <kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Andrii
 Nakryiko <andrii@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Mykola
 Lysenko <mykolal@fb.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 netdev@vger.kernel.org, linux-crypto@vger.kernel.org, bpf@vger.kernel.org,
 Victor Stewart <v@nametag.social>
Subject: Re: [PATCH bpf-next v8 3/3] selftests: bpf: crypto skcipher algo
 selftests
Date: Wed, 21 Feb 2024 10:19:34 +0100
In-reply-to: <87frxmmci7.fsf@cloudflare.com>
Message-ID: <87bk8amawx.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 21, 2024 at 09:43 AM +01, Jakub Sitnicki wrote:
> On Mon, Jan 15, 2024 at 02:08 PM -08, Vadim Fedorenko wrote:
>> Add simple tc hook selftests to show the way to work with new crypto
>> BPF API. Some tricky dynptr initialization is used to provide empty iv
>> dynptr. Simple AES-ECB algo is used to demonstrate encryption and
>> decryption of fixed size buffers.
>>
>> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
>> ---
>
> [...]
>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/crypto_sanity.c
>> b/tools/testing/selftests/bpf/prog_tests/crypto_sanity.c
>> new file mode 100644
>> index 000000000000..70bde9640651
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/crypto_sanity.c
>> @@ -0,0 +1,217 @@
>
> [...]
>
>> +static void deinit_afalg(void)
>> +{
>> +	if (tfmfd)
>> +		close(tfmfd);
>> +	if (opfd)
>> +		close(opfd);
>> +}
>
> Did you mean tfmfd/opfd != -1?
>
> [...]

Nevermind. I missed Martin's earlier feedback.

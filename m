Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922C92206BF
	for <linux-crypto@vger.kernel.org>; Thu, 19 Jun 2025 21:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750367898; cv=none; b=m8Eh1lTaQ4B9t5eWA8xUUijiWIk51Fj2z5dNXVUcfN/i5nhq7WcQ/xE9NNoNnYURjtp6aOuBmjD7+ouBqAM+JcgwO6o+HfjVC4FWxMfDi9n60m2YyHzZW5FWHObSNhOvDCC/tuzfCN3soYGOegHm6SfL3vn8WaNhQ45JmtYE5yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750367898; c=relaxed/simple;
	bh=XveJvn6E0Tafip4AuV0cCBSlRtYRGAYa66CoA6uodhM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=QB4pxkjhtubM8umEWWExRc+2hZFfTSLfZ9itNf4hGnK5r6YmYLXN5xaodYAQdueNkDbicFLVzA3lG00UcAI2Dd5jb41IRCGubdWJ+lVJjmthDjXP7TTQk8mQHnvHa9OPYc2zwCJ9LaM8kxXzVNBU8xFyYIJ+VvUapcctpyx4fLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NLcqnfNF; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLcqnfNF"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-606ddbda275so2351549a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jun 2025 14:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750367895; x=1750972695; darn=vger.kernel.org;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+GBIhcGUInxxcjU4QhonWLGcwxR59qY65tTYVWtE4q4=;
        b=NLcqnfNFfI+SdzQDXAObTEpmImAbGK6xXCaiozFTedLGx7pekEr6dDBSKY8rTQ/bK1
         1BtoWZ2rsepIppOnuWHlpy34XvUgI/NZDXBUQnuXVysigTehqFno5NBIEXfUa47Wk4pv
         AShs5zZLL9otvFlO37OZWxUBqyiOQK4bBcumf2Qr+1DPcDh8beOtmrmvBDQ8oYoQVhPB
         5H2qvPTSBp3lQ4vQQysK/9kmbO5SqLLSuT0ZTzOIKL0cbNu4jvFGA84aUvZBTDP5cpfq
         EbE7BC65PHYoh/MmMbvl0PivH1SezZ80olDXP5veqg47is1zLP84jrr5R3G6XJ85/r5+
         00/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750367895; x=1750972695;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+GBIhcGUInxxcjU4QhonWLGcwxR59qY65tTYVWtE4q4=;
        b=GskP+JC/axIjxs59eqBaQ+AUxPcrGKHzyjgk99F5SxyRmW1rr52em5fcvm4C5nuZGr
         Pe4MUzQEZvWQS5v2NzR+9ga5GC+MVjSdXCv7WMsio+xYfbStetb1Qlu6EafPE/KJiApi
         vkBaEPkEuoPpUnC2ZWQQhmWW1echuAxZoOTq2XwkegmRyl0CqGSlvcoDKloKzd3yhYUl
         cvvfM89M0+KZSHsSxSeGO6sqdZDPlZdVj3vo72JbLhl04nkCX1l3fvIMhhcSmyPrvub6
         +cSA0BNVI8NkFCJdbpFZfibhQIWz+Ve159otwPA8xSQhKVN39iQMp4sFL5m2ubB9gVSc
         gacA==
X-Gm-Message-State: AOJu0Yw7Vv7EftzAzDdFeVgcnJ1vNai+6nPPrkZ9GUX9LowGIwX97iGH
	4BH28Bz2wHuOl9bj37XRM7SsPbRxk/fW7XurwlA+kZeKKL6q+/O0BgAK
X-Gm-Gg: ASbGncs67aG0CTI3YS169htp/OaUVPTTYo3KKOdPwIDpjP5KwXR+uZ8PezgiWyS4u2I
	SHZR2Yzkg8DnHlaothZWARPPh+EHnJq+xotJa3R1+0KkcpoRMxX8qxpGA42NDByxOcZrJdnP3Fl
	zETFB3ppqqm6ZnbrmNFiU0hz5BkOaBZb73ais+3bWVL6q3QabUGPR3DCJvgh2Ygys0zd18BMDrE
	v3dbfyO1QLvVeSl8dIMoo+VcyzND7v5m5Uoq7hf1QN8YOkXM8OAGiXQ9J+TGRszPwbdoPOFyAWH
	rucOcLsM1w26s9nxn45RwLg/H3+ggJuehuCYk3xocfIpHg1lv8rJYjJOzqi+5TRJEASan2LH2GF
	O2kss38j6KoTF2N/uW6xH71tlOnB2UX8=
X-Google-Smtp-Source: AGHT+IFR4FzGOeJzjRYUI5GbjzTJWSdF9YzCRm3n/Y5I7580wV6YG5D1ci/8wRLyBTqKk97M3+R7jg==
X-Received: by 2002:a17:907:1c9f:b0:ae0:54b9:dc17 with SMTP id a640c23a62f3a-ae0579533a8mr38286466b.11.1750367894711;
        Thu, 19 Jun 2025 14:18:14 -0700 (PDT)
Received: from [192.168.8.101] (78-80-16-228.customers.tmcz.cz. [78.80.16.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae054084c01sm46754566b.80.2025.06.19.14.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jun 2025 14:18:14 -0700 (PDT)
Message-ID: <8be28417-2733-4494-8a09-b4343a3bcf3d@gmail.com>
Date: Thu, 19 Jun 2025 23:18:13 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Milan Broz <gmazyland@gmail.com>
Subject: Failure in HMAC with Whirlpool hash in 6.16-rc2
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Herbert,

another regression in kernel 6.16-rc2, this time in AF_ALF for Whirlpool hash.

Cryptsetup can use kernel userspace API instead of userspace crypto lib and we
have some testvectors to detect breakage of crypto.

It now fails with PBKDF with Whirlpool hash (HMAC).

You can reproduce it compiling cryptsetup with kernel API backend and run vector test:
./autogen.sh
./configure --with-crypto_backend=kernel
make check-programs
tests/vectors-test
...

PBKDF vector 17 pbkdf2-sha1 [OK]
PBKDF vector 18 pbkdf2-sha256 [OK]
PBKDF vector 19 pbkdf2-sha512 [OK]
PBKDF vector 20 pbkdf2-whirlpool [API FAILED]
PBKDF test failed.

The bisect points to

Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu May 15 13:54:42 2025 +0800

     crypto: hmac - Add export_core and import_core

     Add export_import and import_core so that hmac can be used as a
     fallback by block-only drivers.

Please let me know if you need more info.
Milan


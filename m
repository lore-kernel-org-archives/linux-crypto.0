Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E181E412A
	for <linux-crypto@vger.kernel.org>; Thu, 19 Jun 2025 21:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750367863; cv=none; b=iRgkai54ts0YC3r6ZkZrKa64IkzvE/ey7Hi0Pblg3omKJahESaID1J7WmX5EgPJhz2LGYrlQ5pohOEWkgoZZkABU1XgQdScIvmRbZmLBtWn3bMQuQ1C1Py+vm1hWIpnchKePmZXLtENMouYtwuvUqrUjTwRH/KLGboSjamoQa6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750367863; c=relaxed/simple;
	bh=dwgPbWkY90gjO6t7tMDzEltEqrI7ZZMpSWRqdn/V80s=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=b45cYf7LHhpqFtg5vI0TbJrsLJEkHEY0lrnjAchflyU7Z6LQCCeB4Da1BOfRoWrSA1oExiX3JRiav6+87xj65tl1E3HWT/c+imzQ5iOB3jyb9EkOmwP4i2aMwmrPxjzZH+b1SjBgaef116NzuaKxOx7/DEjb5tB8jnmooAtbSfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wn/RlATN; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wn/RlATN"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-acbb85ce788so214372566b.3
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jun 2025 14:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750367860; x=1750972660; darn=vger.kernel.org;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8uxhuPsE+Gmb1nyywGbEH71TKlUhTY099WUmaO71RU=;
        b=Wn/RlATNqYbq4onpAE7W+SVVzXS+RNWaE4ao2MH3KrAJNoOIqePusEv3LOIqyhUyXy
         y+aUAyy9E9oyZC8CT3gaeWh05TfKoZO/oYpYq6wgMOrydSxK/gcwePoMMCk6pBxpxuHp
         /2BWmuxYl3KLunhODw/LWKP9m2Vglw7bkEDJpzxh3i4JVieL0it8WJR9nwBb7+UlrVhf
         bwTRrlyMVxgNz8fRnEg+ZamrMxN0KWNRm+BsOH7RlLv792kpbgQtc5J9V3SEZpS/ulOK
         hO2Gg+/4SPfYRVLmvUDU1e8VOdseCI56DoH9C3MKPNyFpVGYTEjyK0kosCACCFJIY2oe
         OAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750367860; x=1750972660;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w8uxhuPsE+Gmb1nyywGbEH71TKlUhTY099WUmaO71RU=;
        b=NvXgwoXle4rILFeihXidYI0SwvN3Y2MHeVwgsJeDMG3yMmzlLHOCuKT7wXFlKFDGal
         6WZxgiPdu1AccNN4DgQBqseofsiXlgl4spj5bpNVyavTi1ACwamfNzUAK3KEdm+8PpvW
         4O//qVnMNkskAyD1bDpH1tSIaTIjeUQHwz/n6yWBDj//3FkDY26cLKTerADRqTeP4xU1
         GRX32c63248NFsKbAin7SjNsjNj+6FYAE2qPcqblZ7NmoQuEI3qCbSVVzqLrUt1QXPeB
         FMZ5N9M618nMS+JJQTVHpiEnT87WuuoKhIEK094jtrsbok87CpuN/dEQMYus/t5Xg427
         GWWg==
X-Gm-Message-State: AOJu0Yz2wljSBLiaMODY+eDBVW1ZVsMg/T2uulp+m7Stgmpce/HvMIDL
	Z+2HLF7bnFiAMbtPoAL6OAsUtuEtm3rXI12rO0mdzHPagX6kUAnt1BRiaxZNhA==
X-Gm-Gg: ASbGncvDQFoInHzg7L4sDUQuD9CttJatwMXw0VdQ06w6YmVyZ6TiN9BSmFK1K5V34+Q
	llxTM1Yyh/s1ONww3BPGXJJaYDIH+FnfR1gEJO+NissO2WlFLWs007HNCZJ0djUuKwjoVNmxVxv
	eH9KHELJ3AWtdinmsXd4O7PRNi90HACF3sHxne2acuN+9MiUsewmxD0JPW3eyzdpmsvhpeJV1sE
	Tf4r6CAUyJrrvpCOHxrwNqCJNZSLIvkb6dUmahhkuInFl1FowIXSDUb6uaXGOUwWRD7O6RyBwly
	O3tcNuAeqlJKKe5rUIEeom8Ecea7qUHbrFGU3c6oejrmFQQk0R848jz5Nr86c9dU21co2BLJIpV
	WSnUVt94ZUMZ7hySn/ACL
X-Google-Smtp-Source: AGHT+IGjIkW8rGaCREcplNmag94dOCwZ4Tp+WQ3mOtUuEP6gN1w7dR1p28bm+eNYXEjlOf7D8I1sZg==
X-Received: by 2002:a17:907:2d27:b0:ad5:749b:a735 with SMTP id a640c23a62f3a-ae057a2859cmr37862866b.27.1750367859801;
        Thu, 19 Jun 2025 14:17:39 -0700 (PDT)
Received: from [192.168.8.101] (78-80-16-228.customers.tmcz.cz. [78.80.16.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae053e7f25csm48845666b.36.2025.06.19.14.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jun 2025 14:17:39 -0700 (PDT)
Message-ID: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com>
Date: Thu, 19 Jun 2025 23:17:37 +0200
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
Subject: OOPs in 6.16-rc2 crypto_shash_export due to partial block handling
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Herbert,

there is an apparent regression in recent 6.16-rc2.

I can easily crash the kernel on 32bit machine with this OOPS:

: Oops: Oops: 0000 [#1] SMP
: CPU: 1 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.16.0-rc2+ #993 PREEMPT(full)
: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
: Workqueue: kcryptd-254:0-1 kcryptd_crypt [dm_crypt]
: EIP: __crypto_shash_export+0xf/0x90
: Code: 4a c1 c7 40 20 a0 b4 4a c1 81 cf 0e 00 04 08 89 78 50 e9 2b ff ff ff 8d 74 26 00 55 89 e5 57 56 53 89 c3 89 d6 8b 00 8b 40 14 <8b> 50 fc f6 40 13 01 74 04 4a 2b 50 14 85 c9 74 10 89 f2 89 d8 ff
: EAX: 303a3435 EBX: c3007c90 ECX: 00000000 EDX: c3007c38
: ESI: c3007c38 EDI: c3007c90 EBP: c3007bfc ESP: c3007bf0
: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010216
: CR0: 80050033 CR2: 303a3431 CR3: 04fbe000 CR4: 00350e90
: Call Trace:
:  crypto_shash_export+0x65/0xc0
:  crypt_iv_lmk_one+0x106/0x1a0 [dm_crypt]
...

The bisect points to

commit 8cf4c341f1931c20c564ab2ee0f9eb990a606cac
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Apr 18 10:59:04 2025 +0800

     crypto: md5-generic - Use API partial block handling

     Use the Crypto API partial block handling.

I think there is a buffer overflow in crypto_shash_export, it does not crash on 64bit perhaps
because of different alignment, but I can be mistaken.

As plen is blocksize + 1, this line in crypto_shash_export seems write out of m5 state:

   unsigned int plen = crypto_shash_blocksize(tfm) + 1;
   ...
   memcpy(out + ss - plen, buf + descsize - plen, plen);

It is easily reproducible with cryptsetup testuite script tests/loopaes-test (on 32bit system).

Let me know if you need more info.

Milan


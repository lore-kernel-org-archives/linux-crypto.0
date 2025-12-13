Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCF4288D6
	for <linux-crypto@vger.kernel.org>; Sat, 13 Dec 2025 00:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765584429; cv=none; b=lK/T42gt9uHIdY+pEOsyaHAh+Uh9aYoRxV3JdTg4GBg4sK2A10tI968JXB4YQIMJ99qY8MbdkG7VZ4sp2P2O9D8gRvC9ke8LnH48faVasyu2EFVM6/ezj38BIWmcQ78qLXf10d9mjE33E4nzh9fpKjLLWJfGE4PG64jvZtX4WWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765584429; c=relaxed/simple;
	bh=CYzsIK5ehWaCiEyz8wVTqO8VDV8S9Om3ktgrb8oXKvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jiC9R5RDYlqHjCi9mKuKVWJmUtVPGI196R8pBkfeRA4dz/MyALlGtyL9NfcJqgX35Wi5UV6TGyYr/IErPqZfkLJ/RpKrkGuzA5rz4wp/xL/o/BcZ8+aJqsIChdGxTM89tBRJcHQNTlAkOobYAC2edbqsZ0ytqkqxQJ8a33ZPXiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TICJz4Ul; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TICJz4Ul"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29d7b8bd6b0so11415445ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 16:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1765584427; x=1766189227; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c459pZsavFBd2omsdsKSsvXiCamORAaW3VGkhGRV9lw=;
        b=TICJz4UlCXmbAWkOPl9roRQzPHIziYSSNt+HPDUU/725wnJBxPjwvx2A9yGAv/tO/7
         JM+/1twqPsDhpBzpx7juSAMPtJzFi0ApGdNj5DH2ltimlUGDQ8YLeUpM2aSnzhZhv+3t
         CDQfSnRyJUEu1tw3RA5LaDs7quQbavVQYAH9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765584427; x=1766189227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c459pZsavFBd2omsdsKSsvXiCamORAaW3VGkhGRV9lw=;
        b=fAlTKeHtcmYA2FWF4N+EAkpPbTEDoeWp/0rFOivXJyQ41wDeQgun7tkySnnFiFxo6d
         HZ5A7Y21s6w1Sndg2HkNDA/nj78D6slOeaxIkZVehruPLZZRUe48GCmz313t/xhkS7h5
         yhZVHMS0FJw97twRaQBolqSSgHgCtGDmDcvA+EJ4HJp76CJTZt/YxQ9QQC3VxnwsBdJs
         J2m4vRy+h2fJeBgaqTrq60Jd7YuwsopzDFjlz5bC8d9YOEr5UCgcVOyCIc0WQPBSZ+ap
         ufdgV6vf+6vUE55Y1EXfHWIHfVsWy/5aSvDgr0PJhFHzVijRhxfK7SRU8XhQGDfaQ4AA
         O4nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVU+UGfpNsbnvVH7EXxCfY2vlwc+/u2MOTKqkVoG40pIYrFvz46fUt6TXjbQjNAwv2PpY3NgK2V/4qyV/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzqutr5gz8pzyV3QwXVrhJpFPJ1vu1D1j7oEHpBwqoOhcz8+aYX
	g6+iofvzdiJ2BzirzRs9zykOvltQ+VjMG2U49B1+e4307EamQptnezHBwfGddViBdFs=
X-Gm-Gg: AY/fxX7SvR9ZKukQt0MYgSJ11VxT882YPuFK2zmHh3V2kYZLw7USw+KavpiF8fsbGJL
	ynp1WN1e3x9WFd19KOwa5EgotMh+nSrhG7X2sMka6Td2WXN9KhHhb2JgVJRiHW828xl5YvK56ZM
	LXrINNNvVhMIb8SQtiJKC8H6Omw9yIND69o7z1IJqKskqrIPM4fJncxj5nytJ1+5Dm+6q9Tvcdi
	PI+QRDpdivLu8lMlk5ylgyi+AIIEDNQ4U5+aMXI0M01BeQJmEBcNUVTRz7B4llDCTp/wuphM1GL
	cV4zTypRDRAUY7iXEpBMXo+fFg2luaSPCwWZ/rks0BMjfrHNYg1vQSdD75Kjpi7yMCjdWKwbqcz
	hWdtBfPzL5+Xgj879hRkFsCKnEBA8A6APH0t+uOUIxD5G6E9rxVwMUrad2LvJdZznG7Ow6ovJyw
	s2Nx0/HcMH3wQV0uKTpwWfUJVh33YvG7gkt87ULNabqKPB4VuK16/I3iShTWcwFB7L
X-Google-Smtp-Source: AGHT+IGD3neeAc46I6IPze60uchqAciCUw5+KPUso/H/AkJuBiPK5VpYZ9xQ7twLPULbQfBALpgYhw==
X-Received: by 2002:a17:902:c94d:b0:295:6117:c597 with SMTP id d9443c01a7336-29eee9f1eb6mr75179915ad.5.1765584427334;
        Fri, 12 Dec 2025 16:07:07 -0800 (PST)
Received: from ?IPV6:2001:f70:700:2400:3248:8d01:1cd9:d123? ([2001:f70:700:2400:3248:8d01:1cd9:d123])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f2ebc340csm25064615ad.28.2025.12.12.16.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 16:07:06 -0800 (PST)
Message-ID: <cbc99cb2-4415-4757-8808-67bf7926fed4@linuxfoundation.org>
Date: Fri, 12 Dec 2025 17:06:59 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: andreyknvl@gmail.com, andy@kernel.org, andy.shevchenko@gmail.com,
 brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net,
 davidgow@google.com, dhowells@redhat.com, dvyukov@google.com,
 elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com,
 jack@suse.cz, jannh@google.com, johannes@sipsolutions.net,
 kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org,
 sj@kernel.org, tarasmadan@google.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/25 07:12, Ethan Graham wrote:
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
> 
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out. Using a simple macro-based API, developers
> can add a new fuzz target with minimal boilerplate code.
> 
> The core design consists of three main parts:
> 1. The `FUZZ_TEST(name, struct_type)` and `FUZZ_TEST_SIMPLE(name)`
>     macros that allow developers to easily define a fuzz test.
> 2. A binary input format that allows a userspace fuzzer to serialize
>     complex, pointer-rich C structures into a single buffer.
> 3. Metadata for test targets, constraints, and annotations, which is
>     emitted into dedicated ELF sections to allow for discovery and
>     inspection by userspace tools. These are found in
>     ".kfuzztest_{targets, constraints, annotations}".
> 
> As of September 2025, syzkaller supports KFuzzTest targets out of the
> box, and without requiring any hand-written descriptions - the fuzz
> target and its constraints + annotations are the sole source of truth.
> 
> To validate the framework's end-to-end effectiveness, we performed an
> experiment by manually introducing an off-by-one buffer over-read into
> pkcs7_parse_message, like so:
> 
> - ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> + ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
> 
> A syzkaller instance fuzzing the new test_pkcs7_parse_message target
> introduced in patch 7 successfully triggered the bug inside of
> asn1_ber_decoder in under 30 seconds from a cold start. Similar
> experiments on the other new fuzz targets (patches 8-9) also
> successfully identified injected bugs, proving that KFuzzTest is
> effective when paired with a coverage-guided fuzzing engine.
> 

As discussed at LPC, the tight tie between one single external user-space
tool isn't something I am in favor of. The reason being, if the userspace
app disappears all this kernel code stays with no way to trigger.

Ethan and I discussed at LPC and I asked Ethan to come up with a generic way
to trigger the fuzz code that doesn't solely depend on a single users-space
application.

Until such time, we can hold off on merging this code as is.
  
thanks,
-- Shuah

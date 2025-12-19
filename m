Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5A222173A
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 21:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766180065; cv=none; b=IGVL124Fvs8oXtXLbGdbXsEUXOK1y6AD+tKJCOjWJIJRvcPwB/Sz22yl9+O8lBScW6cTwa4SrOvCwGEdFYXmicQjOqK6QxVVXsQvUiEZ6owy6Rl7gT3LLrSRuSzi+Zxq9Os9joN2aL1WI+f90C5JP7siTgB09386PP/Bb3L+i78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766180065; c=relaxed/simple;
	bh=nyd1g6CvIGlrKzYvOsHmwPnVPCn93E0wfS69PVJVpBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SU2YBI0fW8o5tiU0EezEd72uwqifrK69OQ+YRz8AWnrZ25kR0nDdlpZ28qJW1bbAMvxF08JUWFxFXQnDL/H0EcuEmzBRGlrpSmqxllTef82H6Z/rVONU6QW5nyQLr/YLTavj5xVy6OJbaE/4PDuPwK+mJogUrItK19o0/5wRbOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gRelEwD4; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gRelEwD4"
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-c03ec27c42eso1251987a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 13:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766180063; x=1766784863; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t32XLNtILrSHOTsv1yzEwE7SsXS6lnNnHJdt9fn7tL4=;
        b=gRelEwD4GoWlWOkPaG7BOmN8aT/9HPaC9ND1AqE2rqeR1LSEmj1uB4CPOgI2wL5rRJ
         W52vtmHxEcCK5ZC1IrQSt+k9jGxVvMAgUVGgBNBePo3Iw2kwPnrxSn0ICFyGEhlqpLk/
         7Ly56ZOn3LFbs/0GivqzTKiUjLXNInfOHUmUyIztg5z/ezsSNpeeQnD3xe9GcpJerOLj
         D/ehegZSV5Q0SBO1XajgZ2bYxvu9VhcPJXXXr42VWTOC1p79kzIkdlv7SC3Qn8XrShJQ
         7jEcSXVWh3lP3lGg91nqkOJaGDvW6VpJln9PYYRhufqtxdqJGnmlRuO05cQAuReP8LQD
         i5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180063; x=1766784863;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t32XLNtILrSHOTsv1yzEwE7SsXS6lnNnHJdt9fn7tL4=;
        b=UUPTltNxnr15w3BHbReLy9Fv30lcFwU3KJQ5xPcXEDJ+zEVf2KJTcuEYxuAVg1Zvbw
         wXjE5o7birD0fejDz1djbHgsUjX09FOBLi17Dv1rbXdpySFNrBz9cMGLmROippXrx5hR
         JPr+qrvJ8PwX04gCa0UCrgKDzthuysLhm0d+TLHEwteUrgRtWeFnVzLtjoxMSRmiU1Yq
         EHG3e0IywGnbSbouws1kpPorvX/hN8mJpTklBf0ZWS5v14+obSTzN41h5p5I5V86GVjv
         X1v7YLZtMHhyNor8DFotG+vQ63IwPPXfRb5xfbM43RZEC9utaeemVV8+PK/GeHkBbIiN
         bAZw==
X-Forwarded-Encrypted: i=1; AJvYcCVwUeRwMT/BKPegY3/K8hBWf2uKq38DvjkYVmNX1EBmInXXdvdx494ht2JzDdePQfIh6/hEJUG52wcWV0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvTQvYVc/9gm6ZqZoNfLP8kAC3b1f6ptQpxBM5XLOSgK9gEevy
	g7xMlo04MyNFOaoByvpIGXEv90QyeemM1Pp2EBOkH4XSdMCXcWQArFEg
X-Gm-Gg: AY/fxX7F6rshEQQfsLDSeT2q7hOWL1TW7r2uTNpwWcp+Bog60F/D15y5H8vh5d4HBpZ
	dm0ZR2OZtlfFg5BxDSZ/8i1nPkiL5R6nOIPWNAyFRBiVqkEPSiYqgNFCMrIy98F6H6pknt0S3oi
	LwFyskU7hCA7oW5Cz3yuOG650txjCzaL2D9TjbmKTNtkIH/fx15/aWTp8wGk0QTDYD81j9UeTQx
	Rk21a47w0Y0TRnfpdjCP8Vo7djs2Pb/mLsv9FbY3HKF+jljusCg81A6gISiiLHZtZJ0bMQN3jiO
	HBl272JbCM8VqOshtJ/b5L97gofvkMpv/xaI/tCTtfBQqecW7APMMkgp8qIj5PugYhZYIY7jbJH
	R9NIaU8hw51jcH+TvVCvQKXhnNGaQbDHwebJHxKFWZWPNbNsAUJlpsC3+A2INkLfSaEaiyrqaQP
	yGoDsfk+vsnw8q0C85AVappmmifxkjr2ekZJOrDSo8wlKHKej/o97CV/yxX/7vTSP1JWpUHds8L
	f4n1kSMGu0kU/MyOjSEXAQTp3ktYZ2B3DSXEmAXcUljNvjo1vKlC/cOdooz51rLmJMmtYCNgGYz
	Y7M=
X-Google-Smtp-Source: AGHT+IH/ZQYDLQv8GePcj2Vm99oLZ3hFWnPTlzcp7/sSDr5k1uCEDV2wgPs8dBIcnq4Eb4hflvIUSg==
X-Received: by 2002:a05:7300:b54b:b0:2b0:57ec:d1a1 with SMTP id 5a478bee46e88-2b05ec745e9mr4652797eec.25.1766180062475;
        Fri, 19 Dec 2025 13:34:22 -0800 (PST)
Received: from ?IPV6:2a00:79e0:2e7c:8:5874:79f3:80da:a7a3? ([2a00:79e0:2e7c:8:5874:79f3:80da:a7a3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05fe99410sm10155463eec.2.2025.12.19.13.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 13:34:21 -0800 (PST)
Message-ID: <0088cc8c-b395-4659-854f-a6cc5df626ed@gmail.com>
Date: Fri, 19 Dec 2025 14:34:19 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/36] locking/rwlock, spinlock: Support Clang's
 context analysis
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-9-elver@google.com>
 <17723ae6-9611-4731-905c-60dab9fb7102@acm.org>
 <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/25 2:02 PM, Marco Elver wrote:
> On Fri, 19 Dec 2025 at 21:26, Bart Van Assche <bvanassche@acm.org> wrote:
>> On 12/19/25 7:39 AM, Marco Elver wrote:
>>> - extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
>>> + extern void do_raw_read_lock(rwlock_t *lock) __acquires_shared(lock);
>>
>> Given the "one change per patch" rule, shouldn't the annotation fixes
>> for rwlock operations be moved into a separate patch?
>>
>>> -typedef struct {
>>> +context_lock_struct(rwlock) {
>>>        arch_rwlock_t raw_lock;
>>>    #ifdef CONFIG_DEBUG_SPINLOCK
>>>        unsigned int magic, owner_cpu;
>>> @@ -31,7 +31,8 @@ typedef struct {
>>>    #ifdef CONFIG_DEBUG_LOCK_ALLOC
>>>        struct lockdep_map dep_map;
>>>    #endif
>>> -} rwlock_t;
>>> +};
>>> +typedef struct rwlock rwlock_t;
>>
>> This change introduces a new globally visible "struct rwlock". Although
>> I haven't found any existing "struct rwlock" definitions, maybe it's a
>> good idea to use a more unique name instead.
> 
> This doesn't actually introduce a new globally visible "struct
> rwlock", it's already the case before.
> An inlined struct definition in a typedef is available by its struct
> name, so this is not introducing a new name
> (https://godbolt.org/z/Y1jf66e1M).

Please take another look. The godbolt example follows the pattern
"typedef struct name { ... } name_t;". The "name" part is missing from
the rwlock_t definition. This is why I wrote that the above code
introduces a new global struct name.

Bart.

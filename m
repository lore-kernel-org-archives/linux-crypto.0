Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD8B1E230E
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 23:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766186967; cv=none; b=LCVtBOwt/njDsfudRSOxu/pS1PmhaN7V2JSv/dxP8boBBg3dxl3BMkAgpkB1mzkc4vmZArGyNTOTpp/1jpppzUMTZibt8N/SKuVKfl9K+zf6J3wU7WvM8bJ8aQQSGr24j+1/KHTDV0T9iGLVmITISiGQ/KWqSxdHFm4acpigMbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766186967; c=relaxed/simple;
	bh=kqYAQZ609rJygFWC7CbHOEHNatKsPADzGjHUdHPU3XE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=IhuO7D5eqgc+RdgN1gRW8kOYXW6K/pXSIahSrMFx7bL4oSInuwc7QxG6aXNTrwaMCpjeuIkLPX6mZWu8UohkPUvGAsOg0eVlwV/OkXGbTZDPBZa70hX+IaUWl5hP7OLCMCCmFzgthMhUWxddkSkUb+4Wayilz94f/851+qpTltg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eL5fU+6y; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eL5fU+6y"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2a0d06ffa2aso26415985ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 15:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766186965; x=1766791765; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xjhz9NvSIj1nkwStS3EsBbpnWvjG3hzX9yFNjSmaNpQ=;
        b=eL5fU+6yxEHm/2Yt2SA/55tDS1pxGGcr6SFGmcOod5ncuR5v8n8mT1abjz2WnVUGto
         IUd6146cf/d5FFFUlYSbxhaUyzio8lReHLJNjT6mTeJyGvcOKLQEphg4gW0afatTmYJs
         PQsRynQrq0JFsNE/i6qpFrjLPDYQUewoQZ1FI96ruiSQRp+sp/oSMgvWcx2mLXjer6cd
         7gHKDqwTU0SgEeQ19QDu33ePwdbzE9379QVY01cQPpY+7YEz25XIRbnE5F+iawYXmKWm
         ZSDEh8NaBSbTpX9CnjqpkonCCvCcm5gQSFDrzdzDaAWMUWlUb9ke3TH0ohiVm/4/2DDO
         RcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766186965; x=1766791765;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xjhz9NvSIj1nkwStS3EsBbpnWvjG3hzX9yFNjSmaNpQ=;
        b=TvTEI32hOMIs0cO0WYT4rBAVpeRq8sUyLX0MuZLLkv7qFlUzFD1ty/CB1C40BjeIhb
         OzLRU9Rnsf5dV8OGZCy+4nODy7I2yu0rspj6r/Io+l26InSURO94jvlcHShD5MtNiYVf
         i05Gip2dl79cux79Ck0VVCT0IZT2LF0MgsZlT5BhxjlD6n++ZbKkb61iY2IK3kIgLeHM
         0jqeJhDFbvN1al7q03+sVL6NqY5pnhdnpmKcy+K46XOYrIMel/U+NV3f8CjWkXOugw7M
         4/XRvGTXwf3bsNdEYJirKwJNurmkwgl8xURzBqUMsCRErZx6cWVSAu8SXUDQNBWiUL8b
         rcDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSpwD4u/woTja3dLbPsz4EpZLHtITOXWMdatM2Ilp2TEcF5+6jJjQxNGyyar6iNyllfI65ATRaDSA1tvk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywoye3jaF1Q32OyrCz6d3U7y/4/jrlZQ+3rCa1U0IK1aclRrj9Z
	hILNldyreNHJzgBnlb8EfASldhO0zYRjbzPF7xE/QSP4gHWsOOVzEAvDlLldOm73bUY=
X-Gm-Gg: AY/fxX6iSsm4rCCtWAT5r9b7fkpkX2o/wlFHHoggpKrFQm75bjrb+IsP4egeS6eXfI6
	bI3Noi62St6kYR8pAtp9CwdQ6DENWqwNLSVDcT5Jtam+fTJOoPNVygCTzn4jjrWKU6bXDn4Rxs1
	vEi6TKkBw+QUUYzX6nnl/mQfhbZOqiiqfD6YA0KReop0hVX5XzjydP5JZTICkS14dwbBkil2FFy
	nIPRmT91r0mPqUCiHL4Rq5Jry7SGPApyp9MS51vWYRUNDKGIO1rvuNTEXbXkREtVlQxf9G1AJOq
	8bX9xWVIObG0TSymERbglHz46V/fA3IQA4gsbnY+EhtMopRj9qeEis0IuDrX6oXaonNUywND9qq
	+xMPNeRR54Boj2b2m8IibB92mj0aSZmE/dDiv3lzjiJyIrVfRaflz192uH2vm8FTQx2gl157ZC+
	WeufqEYL300m3qfS/L/ag9LKQOs7l8FR8zjclAyi8GBJPJVB8yuClxyR1peXtfFAl5E0STV8CDP
	YYzUDN91cShKFELa1ac8CBenOzfQR3jHoVt9iklltoIzU1zuaysFc67EkoyIv25umxIiVKcoy1g
	n0w=
X-Google-Smtp-Source: AGHT+IFD9VEfhTkWGAUJ+KrkgUpiheofAxrSZVwNtEffu0+8gx+hrdlGu9tKXSDKwQO+mDr4xt9mXg==
X-Received: by 2002:a05:7022:3a83:b0:11c:b397:2657 with SMTP id a92af1059eb24-121722be81emr4954809c88.22.1766180747284;
        Fri, 19 Dec 2025 13:45:47 -0800 (PST)
Received: from ?IPV6:2a00:79e0:2e7c:8:5874:79f3:80da:a7a3? ([2a00:79e0:2e7c:8:5874:79f3:80da:a7a3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05fe99410sm10260116eec.2.2025.12.19.13.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 13:45:46 -0800 (PST)
Message-ID: <ae957ee5-cb47-433f-b0b3-f4ac8ec7116b@gmail.com>
Date: Fri, 19 Dec 2025 14:45:45 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH v5 08/36] locking/rwlock, spinlock: Support Clang's
 context analysis
To: Peter Zijlstra <peterz@infradead.org>, Marco Elver <elver@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>,
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
In-Reply-To: <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/25 1:02 PM, Marco Elver wrote:
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

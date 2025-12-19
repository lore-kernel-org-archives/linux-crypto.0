Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3D02FF653
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 21:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766180301; cv=none; b=jsYFhZonTFbOkHxl2lST7TTBaC6wlDX4f//HkQ8LmSfnrPKAtv8Ypqn/jJOFT08AlqINRHI5knjcesWoVy98lakXNQ2BveGbUl/Ylm7DcfPMbIwiQfHpWmWgk14blFhQMBiDi/c1kuRWBS4xR504cLw4/ggcXXwmktxZ+yamrYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766180301; c=relaxed/simple;
	bh=SBHXkRgMesGUJGSlI+YkckhHJhyJOUbeeY6s/H5FeUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oQkuEk+pWtrS0KhQCRFir7on10bCZyhPc5slPg0jamQSLOEBvubCpQsucwsGEEMe4xo7kBsgupQbS42mRX/4uhVacWMFagL1FwYvUbqM+rkeQyrek+wtWmUoYgfnLPOjgaB2au1+WssuoFCk4/tIaqPj9myqJMRAY/Kri6IrBGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PZXXDITX; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZXXDITX"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so2454866b3a.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 13:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766180296; x=1766785096; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SBHXkRgMesGUJGSlI+YkckhHJhyJOUbeeY6s/H5FeUc=;
        b=PZXXDITX8O2pITtu53MVdLOAN8xLa+E4T8O59SLKUmlhw5IGVuOVSaPVKr3RLgyRi9
         FFkrGh/mG35OypARILyigj6YN0GxLJ3X3MOyK+Jvg6PjLDf3Dq2LmoZ2Sj9s/vukVIFq
         LzzBAqPmENgXRvU7eSOKxVcijftEUHTO1jAq7CC7D0kpCfHRoPh2jBjS30aoCTlf+rtk
         nw9MA21zYZJBvVw3CEwwUHEc5WUM5bMNKamyH44/Jthx3UNRJwNqNDyGqhB/ZUDiPjj8
         /SJ5Mj3VpKOHOujtfOTulYT13laYJWXVJsjSmabdQezKKZkPMS3oWx9RPm6XWm7dEXsO
         n3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180296; x=1766785096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SBHXkRgMesGUJGSlI+YkckhHJhyJOUbeeY6s/H5FeUc=;
        b=XU3CjjgM8Hu8GNjT0f+xQLm7n0yCAsXJofavlVI4n2q+66jCXVM25KjSG4TNnuEdfO
         DxboS/r6jABjhJM1EUnpwrl/erhux+uDxCP8Rdcyq22yFCFxEh+GNnEFKdo0DvOnwRdV
         tX1W07ZHUZRFYNej6aOcwI4wDoUUGFrx+mUKbKz7yvVONCkrzUr9qCOh9lTWhkSMJklN
         T38JKURAM+hxEHiBNEhABvcst59ddlQdLh2lkhZr1mw+qSQPfVus+gsPx3Y4qT9EDPwZ
         GmZ41cvqCGnH+2wZsQGeKVNFVgj2VRxMznsQ2fPh0kSsalApXzDFMmiDUtVNykwUQ59E
         ebQw==
X-Forwarded-Encrypted: i=1; AJvYcCVlQcNj8UTCnXoG7bvfSbrVxdYpn7OpDHOirfSlDKO8Mg5wzpFMG+uCy5p4vKPx7eCmH5hspiCtT9fOl4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRZjkd4kt0kj8v6X7vKcvf0/WBx5ZLz7TOthhduVx0RHRumHh1
	j2SZmifsp0ujAENtkKEjdsAFJN0Sn0h1ESpYWgUNTN0PQSaNv0Fqh4Tx
X-Gm-Gg: AY/fxX6lefE5JqgpBCziPlpPohWQilkaP3npgcnkwxCDqJy0w+0V1vteSpbC5bHuwdQ
	fD0DwMO6ySZ9xSjlkDkcTDf0jHhnflt0gT9OrHCzmtH8RkcwhTit0Wz2rpbTCP3az9Yf7dbUKGj
	+gVDiVY3LdeAGSVHYkmwmyR9Zj81Ej+X7Bi9CGHAP3nhy6fWdoIimeDivgH8+RwRFIKeLZRZIwy
	yrW78Q3+BVeK+HXEMYtgOlTmp66odl9i9DPDBFKIBBNeaJsYkeV/L1DL7wd/riH7KCQFcjRMMjj
	pUAlpxWUyhaN6i48ay8Q6zu/ebvqdum7GVjRICWeNgsOwsm9/TG1nXrQDMguW4oYxrinJv9sbDv
	q5VU61jVYKLyA0XF09Dcf4Bma0KC2KkwPhTAzm9ifAb7kRaYf9mFZWgXbUlov0YQK+lm3zQmb5b
	CVCF+hBXGVQzxpmcAdCfzOnqv1qSIgD7DZTh85hiUef7tq5tdsPCmJLpO6ZcYI1JcorCV8JH/LQ
	X0foHbkPOIo69424xGQq54k683vS6UCtTwXli5FvD1TfcyFb0cCIGOW49DS/phSMmVg/t6mZxsp
	JVs=
X-Google-Smtp-Source: AGHT+IGivulZwqOvq9TkwT/0JBobQprm3JRJ6VtJUw4ydSXEmlT/iKTWxEeMw8/Q4ZWRYLdEwZEKQQ==
X-Received: by 2002:a05:7022:e0c:b0:11a:f5e0:dc8 with SMTP id a92af1059eb24-121722f462emr3455845c88.28.1766180295388;
        Fri, 19 Dec 2025 13:38:15 -0800 (PST)
Received: from ?IPV6:2a00:79e0:2e7c:8:5874:79f3:80da:a7a3? ([2a00:79e0:2e7c:8:5874:79f3:80da:a7a3])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfd95sm12051531c88.1.2025.12.19.13.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 13:38:14 -0800 (PST)
Message-ID: <34cda24f-acdc-4049-9869-b666b08897d9@gmail.com>
Date: Fri, 19 Dec 2025 14:38:12 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 23/36] compiler-context-analysis: Remove Sparse support
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
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
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-24-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <20251219154418.3592607-24-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/25 8:40 AM, Marco Elver wrote:
> Remove Sparse support as discussed at [1].

Kernel patch descriptions should be self-contained. In other words, the
conclusion from [1] should be summarized in the patch description
instead of only referring to that discussion with a hyperlink.

Thanks,

Bart.

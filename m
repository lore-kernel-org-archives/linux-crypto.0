Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3CD15C5
	for <linux-crypto@vger.kernel.org>; Fri, 10 Nov 2023 06:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ieQ0H1el"
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C62D7D8B
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 22:44:38 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id 006d021491bc7-5844bc378feso937540eaf.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Nov 2023 22:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1699598677; x=1700203477; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGF1v/gqhKIfK3lN8tg1lEaaH/f3W7AggG6onMYyyAU=;
        b=ieQ0H1elL7Gb/RhajHK9aMhhQrzku8gILgdGaDiNQol+nuzYrtr/HiLHy5a8/lwoIF
         YQJtaukqEkPjXEPkpcn+G9HSK7JMiDw0Dfnz78vs/qg+bJWvJ3f7Sa/N6j5zigRdpAwW
         US9p2+U0bEBAaJdKHVnex3byDHgXKgnk//s+rYm3MjdblPgTTLOz1fjIIsyMZAFzPavg
         /yotpT/PLQOXdw0KQGNkEopweHg8gm8EjQJ9xYEkFPYfzUUgF/GqwHbDoK4cJaq9qI01
         6F7thaaQ52PVo4hkt1LOr65kAy3x0GS712S7q/Ttx8+6779enDhtdRWk4VU667HIGTW+
         gPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699598677; x=1700203477;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGF1v/gqhKIfK3lN8tg1lEaaH/f3W7AggG6onMYyyAU=;
        b=TEwHiJEaXf/fp0VAa/whamKafUtiNbR4tUmkLyM8TKefi4rCX576tUHkqm7YlZb4NK
         rtTGaO73Nsi7Bl9zdSBMsXwLLl9MryB3XtXIcVdK6lsTGO0omA1z/cCSfMZrTaTbDHq1
         0bE121NBjq9aeVVbDobY7uPOGAX/cZimaXIYUyHuAdO16M0pOXURrw1/UhILsfR/rKhr
         q5QupTWKmbmFBymItoL39O1fO7Fk/SnQqvPlH8rmWWNsv88I+kEoc5k9XRCAZy/6C0U1
         Ja3D1ByUU8lmt1ivy35qd7njredseB7Kul0dfHWYNjqpKjEkAjqfBhPY2xcGB2K+G6E3
         fsrA==
X-Gm-Message-State: AOJu0Yxz4BfqXOOlnW5ReuXbECMwD8a18AONKVYZOGyxhgII2WBjKEga
	jYnM7jC8hZ1cinb1TjhaIOnOPK6zEhYyMjyAbuN2Sg==
X-Google-Smtp-Source: AGHT+IH9dKkq1F5Ww/wHqKo0Olzi4faKaa+VUqagiGOI3qwKWLaQqIZvl/khSG+4iZp6x2Dc6RGO1Q==
X-Received: by 2002:a67:ef49:0:b0:452:6178:642c with SMTP id k9-20020a67ef49000000b004526178642cmr6819492vsr.1.1699588687911;
        Thu, 09 Nov 2023 19:58:07 -0800 (PST)
Received: from ?IPv6:2402:7500:4ce:aeef:99fc:78aa:eebe:b7e0? ([2402:7500:4ce:aeef:99fc:78aa:eebe:b7e0])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b001cc307bcdbdsm4303356plg.211.2023.11.09.19.58.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Nov 2023 19:58:07 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH 06/12] RISC-V: crypto: add accelerated AES-CBC/CTR/ECB/XTS
 implementations
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231109071623.GB1245@sol.localdomain>
Date: Fri, 10 Nov 2023 11:58:02 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 palmer@dabbelt.com,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 andy.chiu@sifive.com,
 greentime.hu@sifive.com,
 conor.dooley@microchip.com,
 guoren@kernel.org,
 bjorn@rivosinc.com,
 heiko@sntech.de,
 ardb@kernel.org,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <659DE1CF-4F42-4935-9DFD-E127269CEC54@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-7-jerry.shih@sifive.com>
 <20231102051639.GF1498@sol.localdomain>
 <39126F19-8FEB-4E18-B61D-4494B59C43A1@sifive.com>
 <20231109071623.GB1245@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Nov 9, 2023, at 15:16, Eric Biggers <ebiggers@kernel.org> wrote:
> On Tue, Nov 07, 2023 at 04:53:13PM +0800, Jerry Shih wrote:
>> On Nov 2, 2023, at 13:16, Eric Biggers <ebiggers@kernel.org> wrote:
>>> On Thu, Oct 26, 2023 at 02:36:38AM +0800, Jerry Shih wrote:
>>>> +static int ecb_encrypt(struct skcipher_request *req)
>>>> +{
>>>=20
>>> There's no fallback for !crypto_simd_usable() here.  I really like =
it this way.
>>> However, for it to work (for skciphers and aeads), RISC-V needs to =
allow the
>>> vector registers to be used in softirq context.  Is that already the =
case?
>>=20
>> The kernel-mode-vector could be enabled in softirq, but we don't have =
nesting
>> vector contexts. Will we have the case that kernel needs to jump to =
softirq for
>> encryptions during the regular crypto function? If yes, we need to =
have fallbacks
>> for all algorithms.
>=20
> Are you asking what happens if a softirq is taken while the CPU is =
between
> kernel_vector_begin() and kernel_vector_end()?  I think that needs to =
be
> prevented by making kernel_vector_begin() and kernel_vector_end() =
disable and
> re-enable softirqs, like what kernel_neon_begin() and =
kernel_neon_end() do on
> arm64.  Refer to commit 13150149aa6ded which implemented that behavior =
on arm64.
>=20
> - Eric

The current kernel-mode-vector implementation, it only calls =
`preempt_disable()` during
vector context. So, we will hit nesting vector context issue from =
softirq which also use
kernel-vector.
https://lore.kernel.org/all/20230721112855.1006-1-andy.chiu@sifive.com/

Maybe we could use the `simd_register_aeads_compat()` wrapping as x86 =
platform
first in a simpler way first.

-Jerry=

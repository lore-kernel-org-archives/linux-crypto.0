Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D84ED4
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jan 2024 05:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="d57lkx+u"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5cda3e35b26so2155551a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jan 2024 21:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1704172620; x=1704777420; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0+e9jXb1APHsr8+SSFKuSYagZvt9QzyAw+8MedzV9k=;
        b=d57lkx+u8DPZTyQ8PYYKSW17kBEU23T7rg/NVa/PDzZIMyd1RDdGBPdUtwBm5TB8XR
         jcoupajoOZ4YxxgqIEJ7XAtticgg/EDWSGhKR3NzXLmc4ao/zBzFb479qS6AuJZOAZWi
         /XWrqEb2g14EzpthImr8Wxd0V8m32mhfEJ8bcQKi9rcZWw5uI39EVkm6WRBjesGuIy4i
         ewrVZeWqTZCaSOfj/HMfI1EvxCwOkuaZWtMc9AfglGuFy4MRBZHmIchpWdjdGqryONro
         2NJMd1bgWayHKHpWzUn393LTPgKLGBENxKACeWjJOFY6T7S/lVT4L5JRSoLXVCMEs9/Q
         dO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704172620; x=1704777420;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y0+e9jXb1APHsr8+SSFKuSYagZvt9QzyAw+8MedzV9k=;
        b=EDi/0JHfpzYB1YFuDSC8ZbdMDlVPdTBDuk5X+83jCYAj6KcmMIl3Zd1apT1Uciy/yb
         Uf5nNfeJziY8W2zTikM3JYJcCcTifLiqOvb2QUaFto+9Hw3Z9tbWgkkTkBt2VDSYwa8H
         3xyy/ilsV5HKGFnYVpCqcN4psJcOQwYG0XhENx7aY9EUS4kvk/cXscfDNowRtIczENIw
         JsOgT16JF/c1rl0kTWEpTTZ4ITXsdTLCIQmKyCpm2ArT1GSTAUrcOjCH5KcqjS19Bfvz
         FfmqwypaevOxPTlEontZvxgrbEdGqRDRzd3jdhZ2SehhuXeZUmaRZrg3qTZ9+xpKrUZE
         2fRA==
X-Gm-Message-State: AOJu0Yx1f+YfEMhV5vL0CXp0CtGCnkeFCmxjSqN1iopyep1g5kDx6cI2
	OF4eAtvsZJubnqd4KV3b0vuxrI7OoFpXog==
X-Google-Smtp-Source: AGHT+IG1JRqn+7/ZW5uKjjHFyDuCLIb0RjG51YBmpY/IphE+PQuOa/LY7hCZn9t+tAnGTUHZvtHBUw==
X-Received: by 2002:a17:902:f814:b0:1d4:58eb:d901 with SMTP id ix20-20020a170902f81400b001d458ebd901mr5578770plb.41.1704172620140;
        Mon, 01 Jan 2024 21:17:00 -0800 (PST)
Received: from ?IPv6:2402:7500:5d5:d389:6cac:304c:13db:9f1b? ([2402:7500:5d5:d389:6cac:304c:13db:9f1b])
        by smtp.gmail.com with ESMTPSA id iw19-20020a170903045300b001d077da4ac4sm21114907plb.212.2024.01.01.21.16.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jan 2024 21:16:59 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v3 00/12] RISC-V: provide some accelerated cryptography
 implementations using vector extensions
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231230035112.GC770@quark.localdomain>
Date: Tue, 2 Jan 2024 13:16:54 +0800
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 herbert@gondor.apana.org.au,
 davem@davemloft.net,
 conor.dooley@microchip.com,
 ardb@kernel.org,
 conor@kernel.org,
 heiko@sntech.de,
 phoebe.chen@sifive.com,
 hongrong.hsu@sifive.com,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org,
 Andy Chiu <andy.chiu@sifive.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EED7F0DA-5619-411B-82A2-7926155E9B73@sifive.com>
References: <20231205092801.1335-1-jerry.shih@sifive.com>
 <20231222054827.GE52600@quark.localdomain>
 <20231230035112.GC770@quark.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Dec 30, 2023, at 11:51, Eric Biggers <ebiggers@kernel.org> wrote:
> Hi Jerry,
> On Thu, Dec 21, 2023 at 11:48:27PM -0600, Eric Biggers wrote:
>> Hi Jerry,
>>=20
>> On Tue, Dec 05, 2023 at 05:27:49PM +0800, Jerry Shih wrote:
>>> Changelog v2:
>>> - Turn to use simd skcipher interface for AES-CBC/CTR/ECB/XTS and
>>>   Chacha20.
>>=20
>> If I understand correctly, the RISC-V kernel-mode vector support now =
seems to be
>> heading down the path of supporting softirq context, as I had =
suggested
>> originally.  With patches 1-2 of Andy Chiu's latest patchset
>> "[v7, 00/10] riscv: support kernel-mode Vector"
>> =
(https://lore.kernel.org/linux-riscv/20231221134318.28105-1-andy.chiu@sifi=
ve.com).
>> applied, the kernel has basic support for kernel-mode vector, =
including in
>> softirq context.
>>=20
>> With that being the case, "skcipher" algorithms can just use the =
RISC-V vector
>> unit unconditionally, given that skcipher only supports task and =
softirq
>> context.  Therefore, can you consider undoing your change that added =
fallbacks
>> using the simd helper (crypto/simd.c)?  Thanks!
>>=20
>=20
> I had a go at incorporating my suggestions into your patchset, and =
rebasing the
> patchset onto riscv/for-next plus the first two patches of "[v9, =
00/10] riscv:
> support kernel-mode Vector".  You can get the result from branch =
"riscv-crypto"
> of https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git.
> Everything seems to work (tested in QEMU, as usual).
>=20
> Please consider using it when you send out v4; thanks!  I can even =
send it out
> myself, if you want, but I assume you're still "owning" the patchset.
>=20
> - Eric

Thank you. I sent the v4 patch.
Link: =
https://lore.kernel.org/all/20231231152743.6304-1-jerry.shih@sifive.com/

-Jerry=

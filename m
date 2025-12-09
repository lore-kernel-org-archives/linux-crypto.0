Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6A6259CBF
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 05:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765257840; cv=none; b=ajp9OWn+HC+WCO4HNThlu6oO8lQJVs8qB3trQ95NiUmOrjWvhoE+r7pYaS9OQFtlaTBA/LN0kDLg713XUBMda71drs/BnNKn/p8RuQYoiHLA92uSrIl4CPaqcngZvF/tm8JfMKemPe+0nwFdbEnj1QPg08OMBGWSkr3bCraA2PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765257840; c=relaxed/simple;
	bh=y4EF+qcLIRWtT0V7HkRMBBU4mpoPnoTvEUNwYrA4utQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rU10fhd1HM7JEiR257rwu2v9IdpHCbPCGSGJzNW6HkIlriUE8qfoQShNwE2wU3bFK8UBAwKyaBmUPKPtrANeV7qS9Y6a2TUzlQX03fBQ901n7IPOpwyIDuLy53zvtT5yUUC9o3dqLW3Km2jPiXi34CYCI1FehWNoDDW9tPWYdf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=bLKi2XIq; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="bLKi2XIq"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34a4079cfaeso769004a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 08 Dec 2025 21:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1765257838; x=1765862638; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3eSPmbLWyLBcQiX4FuCahKZ0aMEL39arsdfnAYJUHkQ=;
        b=bLKi2XIqtm5XVF0f+WfYgiUUZ7f19NLKE37Thtn7vxqRogvMDjPxaKvRMpDg1BQDYg
         O3NCCKkRboEsvis1sJdSErz6Gm91l+3B9nEe33FUj1U5v+m8d5rPvdaA7ypztAvyeZWg
         VK986xFRFB/hRWdslcKu2OWe2x0qBpf8yunw8HMlTtiUZ+cAZaRESNxGLInjTrvJHyIC
         TennZ7sDRdGurwtGeQpkYSLIqqqwx7YfP7gNuXR1eqnYq8l8HFjgmsl6nGKSx/FClxrV
         fsC6P9wzXgWp11lcvptft8TPfIyqZPanr7aivEyEo0uNWps1GUxESvH5yRTuE67Wa62T
         SFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765257838; x=1765862638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3eSPmbLWyLBcQiX4FuCahKZ0aMEL39arsdfnAYJUHkQ=;
        b=hVeQqO42PSWBknf/iwLz/U0LbbblhjdkoCjTKh++VonO//jO9mtHUI3+EumXv2y0Ij
         l5nqsIh+Y9QzAQPKx5DOiwtrW0pz1ZIZcWfcjVGB6+q4CcorhZnswAL38HJioU5LruZq
         cw9o0IMj3O60jTkEnpx1yxGoyMBL3aylej08f3NahjuB5q43VTlG/XpBa1KZ/7iYeeGf
         k7G7uMwp515HUV36CAb5bs+Mk4wwkFBOBQdNERXk2YDGw2yEjSgWbwdUpeEZAboJy+/E
         Bs66TzbHbvr0Qm28OP8sJ+v1ZOyPVUYX5YqJO4oLNDGBXbaHncmyN5lADkOY4cgWP9OD
         435w==
X-Forwarded-Encrypted: i=1; AJvYcCUnsyOJWiwRiuYmZi+6cqxzRBzzBrPmwaw9wiImOe8Ezy+qnjRSeiGBwu6/CwfCFtkMj8GXxCTp2uFLaiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnF6sxmosLc+nlIikJ/czmTS/SOyb5L3GSZIyXQh5PCE2PZFwb
	qif9BMdu+Ry3SS7QKTcuvTvl111vw9CEGbI1arCjGc6BCaJvLrHTu8nzshiTaiNnGUg=
X-Gm-Gg: ASbGncuQGxrR7HBawxgFxeK7EbTkXrg4HixeAdS2RN+PqFPGtoKlDnaZHW25OBePXnp
	qsAwEP0X8zVYiaj0nicauwnnETWlccU0Ze3JAKbCl6tDzjStiOpdoho55icUEo/uzInvuYCu4/h
	kQlkPdfDJKnWcCEhRQ+yTOXVnjZ8zFOYfDzwRgyQ7VCcSjjSqK8guUKzgW98LS5myA2pnceRLc5
	ilSOpQv496jeJy90PYbr7GHMWzTV3yLfPE5pmVd+Zis1eIZQJN+IHakSdiP/nxOWsru7u6mqEC9
	3lFZerSoTEcvqHjlnn6YNcpeAhac6+Vn9T6VeKtOvbIzL7uEdTBO4wKikl+42rcjkvdxqSSmZ60
	O4k+AvsJZRPBZyeM/C/INRkDrarzrWfxSXtXCQIqK+j5fk0kmyIPPYOLTZodx13Rkc4V19W3aud
	1WSriocZtxImQRO1SDHNpVbFyTBrL9DQo=
X-Google-Smtp-Source: AGHT+IEgRj8k/NUy8lgVpyEQCJU09GRONGLpSBp5S4EGiMvTHzEYpgp5Tbqw7st/J1fN/hxgbt03xw==
X-Received: by 2002:a17:90b:562d:b0:340:c4dc:4b8b with SMTP id 98e67ed59e1d1-349a24f21f1mr8022838a91.10.1765257838492;
        Mon, 08 Dec 2025 21:23:58 -0800 (PST)
Received: from [100.64.0.1] ([165.225.110.109])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a49b9178csm949702a91.12.2025.12.08.21.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Dec 2025 21:23:58 -0800 (PST)
Message-ID: <d8df2603-b5f7-408d-b2cb-515ddfff126e@sifive.com>
Date: Tue, 9 Dec 2025 14:23:52 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] lib/crypto: riscv/chacha: Avoid s0/fp register
To: Eric Biggers <ebiggers@kernel.org>
Cc: Vivian Wang <wangruikang@iscas.ac.cn>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, Jerry Shih <jerry.shih@sifive.com>
References: <20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn>
 <20251202053119.GA1416@sol>
 <80cb6553-af8f-4fce-a010-dff3a33c3779@iscas.ac.cn>
 <20251202063103.GA100366@sol>
 <CABO+C-DAuguO4svhi4o5ZgybizzgnADRbzJWZNBTb4-096c10g@mail.gmail.com>
Content-Language: en-US
From: Samuel Holland <samuel.holland@sifive.com>
In-Reply-To: <CABO+C-DAuguO4svhi4o5ZgybizzgnADRbzJWZNBTb4-096c10g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-12-09 12:58 PM, Jerry Shih wrote:
> On Tue, Dec 2, 2025 at 2:32 PM Eric Biggers <ebiggers@kernel.org> wrote:
>>
>> On Tue, Dec 02, 2025 at 02:24:46PM +0800, Vivian Wang wrote:
>>> On 12/2/25 13:31, Eric Biggers wrote:
>>>> On Tue, Dec 02, 2025 at 01:25:07PM +0800, Vivian Wang wrote:
>>>>> In chacha_zvkb, avoid using the s0 register, which is the frame pointer,
>>>>> by reallocating KEY0 to t5. This makes stack traces available if e.g. a
>>>>> crash happens in chacha_zvkb.
>>>>>
>>>>> No frame pointer maintenence is otherwise required since this is a leaf
>>>>> function.
>>>> maintenence => maintenance
>>>>
>>> Ouch... I swear I specifically checked this before sending, but
>>> apparently didn't see this. Thanks for the catch.
>>>
>>>>>  SYM_FUNC_START(chacha_zvkb)
>>>>>    addi            sp, sp, -96
>>>>> -  sd              s0, 0(sp)
>>>> I know it's annoying, but would you mind also changing the 96 to 88, and
>>>> decreasing all the offsets by 8, so that we don't leave a hole in the
>>>> stack where s0 used to be?  Likewise at the end of the function.
>>>
>>> No can do. Stack alignment on RISC-V is 16 bytes, and 80 won't fit.
>>>
>>
>> Hmm, interesting.  It shouldn't actually matter, since this doesn't call
>> any other function, but we might as well leave it at 96 then.  I don't
>> think this was considered when any of the RISC-V crypto code was
>> written, but fortunately this is the only one that uses the stack.
>>
>> Anyway, I guess I'll apply this as-is then.
>>
>> - Eric
> 
> The 16-byte stack alignment is in RISC-V calling convention:
> https://riscv.org/wp-content/uploads/2024/12/riscv-calling.pdf
> It says:
> In the standard RISC-V calling convention, the stack grows downward
> and the stack pointer is always kept 16-byte aligned.

Indeed, and this does matter if the code runs with IRQs enabled, as the RISC-V
entry assembly assumes the kernel stack is already properly aligned.

Regards,
Samuel


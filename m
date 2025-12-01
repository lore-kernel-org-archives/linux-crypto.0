Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCE781AA8;
	Mon,  1 Dec 2025 01:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764553871; cv=none; b=nLJryYZJxOZAZWxRF/MZzkRImsKRSXCE5oszLDFTNKn3O7p53H/3U6PMmCnDTSewtf4cQZOBe6QUfiKzUcIbtozcSJ3tGaEuDQdyqaCiFmC2NGeZTYs6gJ5INL9uJSApWX1ikLJ3RplEKIV+Iwsg7WJU/X3QEI8N51t7qB4orC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764553871; c=relaxed/simple;
	bh=ydpxYdtPlRbPFg5Dy8isLBpfWRko3ZXtiZyn2Fck67c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CbITKJZX3MUA6NTafZ227e/lgTWjygK/OQTsoh/TgX6VjkS+Rg4flEl8/rABrZHn2QMSYs2bDkbi5gTna+Lo+Qj7wJE4tlQyX3Myd5jno7n3MdBe2y5tErGh//t+44M7QsYxkfTsEuBVBAbwhtTvB+pMCmkvMzrBhYPfyGWuAsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.0.107] (unknown [114.241.82.59])
	by APP-01 (Coremail) with SMTP id qwCowACXMNBm9CxpvfSvAg--.20391S2;
	Mon, 01 Dec 2025 09:50:31 +0800 (CST)
Message-ID: <c04ad49c-598d-4183-a9dd-00a7883e727a@iscas.ac.cn>
Date: Mon, 1 Dec 2025 09:50:30 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: riscv/chacha: Maintain a frame pointer
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jerry Shih <jerry.shih@sifive.com>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20251130-riscv-chacha_zvkb-fp-v1-1-68ef7a6d477a@iscas.ac.cn>
 <20251130182914.GA1395@sol>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <20251130182914.GA1395@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowACXMNBm9CxpvfSvAg--.20391S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ur13WFyruFWrKrWDuFy5XFb_yoW8Ar4fpa
	yfCFnYgr4DtrW7C3yxAF4rZF1fXr9a9Fy5CrWftw1rA34UJFy2vF17Kryruw1vkrW8Aw1j
	yF45A3WDZrZ8ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvCb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjc
	xK6I8E87Iv6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr
	0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY
	04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7IU56yI5UUUUU==
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/

On 12/1/25 02:29, Eric Biggers wrote:
> On Sun, Nov 30, 2025 at 06:23:50PM +0800, Vivian Wang wrote:
>> crypto_zvkb doesn't maintain a frame pointer and also uses s0, which
>> means that if it crashes we don't get a stack trace. Modify prologue and
>> epilogue to maintain a frame pointer as -fno-omit-frame-pointer would.
>> Also reallocate registers to match.
>>
>> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
>> ---
>> Found while diagnosing a crypto_zvkb "load address misaligned" crash [1]
>>
>> [1]: https://lore.kernel.org/r/b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn/
>> ---
>>  lib/crypto/riscv/chacha-riscv64-zvkb.S | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
> Do I understand correctly that the problem isn't so much that
> crypto_zvkb() doesn't set up its own frame pointer, but rather it reuses
> the frame pointer register (s0 i.e. fp) for other data?
>
> That's what we've seen on other architectures, like x86_64 with %rbp.
> Assembly functions need to set their own frame pointer only if they call
> other functions.  Otherwise, they can just run with their parent's frame
> pointer.  However, in either case, they must not store other data in the
> frame pointer register.
>
> Is that the case on RISC-V too?  If so, the appropriate fix is to just
> stop using s0 for other data; we don't actually need to set up a frame
> pointer.  (Note that none of the RISC-V crypto assembly code sets up
> frame pointers.  So if that was an issue, it would affect every file.)

Thanks for the hint, I can confirm that indeed simply avoiding s0 also
fixes the stack trace problem.

I'll drop the rest of the patch for the next version.

Vivian "dramforever" Wang


Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292692FFF89;
	Tue,  2 Dec 2025 06:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656705; cv=none; b=qTI0HSmd0Js+VkHNNV6IplH6f4hEA0KOWzpYsY6LroRHxToF2tArvUgg/U7OC23krL3wjc+ELfQSjl9CWnW3GukwI+XORWy/W1VDzKinIPZUcpYHgj7APBJ/H+YES6qEyNHGKCyOnefwzPwLB5H5qcqfjyxOk3MXPGLBHhiNRys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656705; c=relaxed/simple;
	bh=ckppSMB/ShTOuB5lgJCSTFQ7jzN/2iHVYT3QpUlK7vg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pW3EUZYroDdivynFmKNiH/z6Pq0lbNGJuwCZd+kwzNy0nrMZwfnO+v2dMWRrtyzKM8fdcCzvE6tqi0awrjbIexOyMPneSTjZaGWGenkvj10obSo/ArwFrDPjiyvdekHY9K9QHr2GT/JkS/l0oS2V0esxMzgPEbZaiC6WwJPJWLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.0.107] (unknown [114.241.82.59])
	by APP-01 (Coremail) with SMTP id qwCowABn_cwuhi5pmijUAg--.285S2;
	Tue, 02 Dec 2025 14:24:46 +0800 (CST)
Message-ID: <80cb6553-af8f-4fce-a010-dff3a33c3779@iscas.ac.cn>
Date: Tue, 2 Dec 2025 14:24:46 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] lib/crypto: riscv/chacha: Avoid s0/fp register
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jerry Shih <jerry.shih@sifive.com>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn>
 <20251202053119.GA1416@sol>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <20251202053119.GA1416@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowABn_cwuhi5pmijUAg--.285S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZFWDKr1xJw15tr1kGry3Arb_yoWfGrbEvr
	WYyrn7Cwn8WFnrtFyjkr4UtrWDGw1fWFyIgryrXwsrKrW8Zan5Zr1kZrn5Aw1Sqw42yF9F
	kr98Jay3W34a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbskYjsxI4VWkCwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
	8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
	cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l
	c7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
	1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
	14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
	IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
	IFyTuYvjxU2VbyDUUUU
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/

On 12/2/25 13:31, Eric Biggers wrote:
> On Tue, Dec 02, 2025 at 01:25:07PM +0800, Vivian Wang wrote:
>> In chacha_zvkb, avoid using the s0 register, which is the frame pointer,
>> by reallocating KEY0 to t5. This makes stack traces available if e.g. a
>> crash happens in chacha_zvkb.
>>
>> No frame pointer maintenence is otherwise required since this is a leaf
>> function.
> maintenence => maintenance
>
Ouch... I swear I specifically checked this before sending, but
apparently didn't see this. Thanks for the catch.

>>  SYM_FUNC_START(chacha_zvkb)
>>  	addi		sp, sp, -96
>> -	sd		s0, 0(sp)
> I know it's annoying, but would you mind also changing the 96 to 88, and
> decreasing all the offsets by 8, so that we don't leave a hole in the
> stack where s0 used to be?  Likewise at the end of the function.

No can do. Stack alignment on RISC-V is 16 bytes, and 80 won't fit.


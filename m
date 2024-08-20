Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18393DDA1
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 00:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724115138; cv=none; b=qJv59h551p9sG/Veyp/au6zhkV/Km0oilsFskXeAd3H0xPC914cb73PtmE2X33mnlaUPMASzQ9kFFcTYqGoSjcVmteSPCG75ag4fkcwfNcTsijwLioZb2U90GImxWhTr9lc9K9/4KMhqEJtwMMhJP0JEdf7dJwLLnMmKuxa/bMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724115138; c=relaxed/simple;
	bh=2ioYGP+M8IHViOUOeVxEe4+PE+2PfXR1I4ooDHkhex0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TXB8DrEr4DdBWIhVYIhNo8zwsnrUnlt82s3uZ2/KFaPbWkBELItfJI+EvCkJtG86sFC5pMa0cAz3uPYucNdSonTX9cQFCcbgTeFe3rGP2bUquJurfOV6MckIY9TXVtNzegr3VzyViflrypn7Ots9gLVrwjn7oFAam+ZNmxMvvUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [111.9.175.10])
	by gateway (Coremail) with SMTP id _____8AxSZpC6MNmDrUZAA--.19315S3;
	Tue, 20 Aug 2024 08:50:10 +0800 (CST)
Received: from [10.136.12.26] (unknown [111.9.175.10])
	by front1 (Coremail) with SMTP id qMiowMDxnWdA6MNm0wMbAA--.25858S3;
	Tue, 20 Aug 2024 08:50:09 +0800 (CST)
Subject: Re: [PATCH v3 1/3] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
To: Xi Ruoyao <xry111@xry111.site>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org,
 loongarch@lists.linux.dev, Tiezhu Yang <yangtiezhu@loongson.cn>,
 Arnd Bergmann <arnd@arndb.de>
References: <20240816110717.10249-1-xry111@xry111.site>
 <20240816110717.10249-2-xry111@xry111.site>
 <CAAhV-H7TKg98QXtrv9UmzZd9O=pxERvzCsz83Y+m+kf0zbeCkA@mail.gmail.com>
 <ZsNClVFzfi3djXDz@zx2c4.com>
 <9d6850dd52989ad72238903187377cbaa59f7e62.camel@xry111.site>
From: Jinyang He <hejinyang@loongson.cn>
Message-ID: <a29807b5-d0ce-f04e-a7d1-024d29f398be@loongson.cn>
Date: Tue, 20 Aug 2024 08:50:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <9d6850dd52989ad72238903187377cbaa59f7e62.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowMDxnWdA6MNm0wMbAA--.25858S3
X-CM-SenderInfo: pkhmx0p1dqwqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj9xXoW7XFWfCryktF4fAr1rGrWfJFc_yoWxZwb_ur
	1kuF48CanI9r4DJFWvk3WrA3sFq392qw13AF1vvr13X343J3y5CFWq9rWF9w48XF18XFsF
	9Fs0q3Z3ury2gosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbx8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267AKxVWU
	JVW8JwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F4
	0EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_
	Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbI
	xvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkUUUUU
	=

On 2024-08-19 23:36, Xi Ruoyao wrote:

> On Mon, 2024-08-19 at 13:03 +0000, Jason A. Donenfeld wrote:
>>>> The compiler (GCC 14.2) calls memset() for initializing a "large" struct
>>>> in a cold path of the generic vDSO getrandom() code.  There seems no way
>>>> to prevent it from calling memset(), and it's a cold path so the
>>>> performance does not matter, so just provide a naive memset()
>>>> implementation for vDSO.
>>> Why x86 doesn't need to provide a naive memset()?
> I'm not sure.  Maybe it's because x86_64 has SSE2 enabled so by default
> the maximum buffer length to inline memset is larger.
>
I suspect the loongarch gcc has issue with -fno-builtin(-memset).


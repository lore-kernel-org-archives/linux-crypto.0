Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007344;
	b=P150GkzAIaa7e8FuMmdK9TE/xJ8h0sohtsKMgYMZMA+rYPRJWITMX3VFnJUPouhkgj8A
	 zHK5hkVdnskebnVp4QUoYn+LbLSqYnH6+/QIT/5BbkgxzZDYrH9s96WLgEk7+szj1vqXg
	 2HxUA1WRkAhlgc+1uyzqeNmc92thIBuM4oelypNhz8rbJ8m0zqG4yUyup421TSVXZZguk
	 mt3fL1+kQppzrKuMmatdzThCcXSzr0DTbnq7AKwIvjMOzGbjxRA4+AAAFXyyxSEFkx8we
	 utgxoJxooLM8pcI0XLA7l/BHY/RXiMHvdtMlbTfhsQsOj8cfn3b+3C/gk+Aho8KOyGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007344;
	h=DMARC-Filter:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=IktkEx4zX4zWwoAqU3vLL+1o7cLskiaczwDJ/WCeiYI=;
	b=cp6SgOlXFPJ5CFiJBl/2cOLOH3zRafY3COZaW1DPly34hhW9r4Pk4JDXMArTSj6gKnKZ
	 hjNqrVCSJet25m7w/A0CmMGCono9UDppRvp6Jk/nD0R4j0NX/PNuXbU1WrhWb1MVk2Apk
	 H26VrTGOlnldROiHI4sQULuEt4Xc/HUilhP4cqaNFHwK0WHTi8bhk/4xRLdB8GTDHAMJB
	 XYfHZCBRIY+pEm/+Hz9/qEmk/QrkYh7C5RUDVyKOvnakxr1m8/DLRe9PrEFWdFS1qbbnt
	 mg+bwZaSjChdbWahapqFjefL2xzplIjY5ljON6gukw1WQVEEcqOsRpwx/LGXSZl0B3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C0C606A31F;
	Mon, 26 Oct 2026 09:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99C0C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.102])
	by gateway (Coremail) with SMTP id _____8Bx79LtHt9qV24ZAA--.8897S3;
	Mon, 26 Oct 2026 17:35:41 +0800 (CST)
Received: from [127.0.0.1] (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJAx3c7qHt9qlEwwAA--.35470S2;
	Mon, 26 Oct 2026 17:35:40 +0800 (CST)
Message-ID: <15af8b62-9461-46b0-8359-4db597b96d66@loongson.cn>
Date: Mon, 26 Oct 2026 17:32:53 +0800
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/28] mfd: loongson-se: Zero-initialise controller
 command structures
To: Lee Jones <lee@kernel.org>
Cc: stable@vger.kernel.org, Yinggang Gu <guyinggang@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, linux-crypto@vger.kernel.org,
 mfd@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261021121245.3111563-1-lee@kernel.org>
 <20261021121245.3111563-16-lee@kernel.org>
Content-Language: en-US
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
In-Reply-To: <20261021121245.3111563-16-lee@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAx3c7qHt9qlEwwAA--.35470S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj9xXoWruFW5AF13GFWUJFW3XryxJFc_yoWfJFX_Aa
	y3KF95C34kCr4vk3sYqF1fZFZI9a48J3WIk3WDtr4rW3ZYqw4FvryIk3yI93W3Krs8ArnI
	9w18u3yvkr4UZosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUb78YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1QVy3UUUUU==


在 2026/10/21 20:09, Lee Jones 写道:
> loongson_se_init() and loongson_se_init_engine() declare struct
> loongson_se_controller_cmd on the stack without zero-initialising it
> and only populate a subset of its fields before
> loongson_se_send_controller_cmd() writes all eight 32-bit words to the
> controller MMIO registers.  Zero-initialise the stack command structures
> so that unused words do not leak residual kernel stack contents to the
> hardware.
>
> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
> Closes: https://sashiko.dev/#/bug/linux-b81dca3d-6812-43b6-9ad9-912727674154
> Cc: stable@vger.kernel.org
> Signed-off-by: Lee Jones <lee@kernel.org>

Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>

Thanks for fixing this!


Best Regards,

Qunqin.


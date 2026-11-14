Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794629818;
	b=00lFJ7cBWFtRRW93RimQgyil3ehgM+mu0Gwq9lNi8vDS/xmq1J3E501gPo3Mq/f/xYWF
	 RJEsNPeXS5W6n+WvVjNNuiwnILb8Fx66wDmF7kixIjDo4OaFLQ91WEJhJ1ELLoDVp0bxM
	 mC3bBf+o4uL958Pve1ZpQU/YJhl8Uv3cXKzVVf19vnrLxxacTlF6Y0fNzcaXPfcFLXgyp
	 SzWOCnCJ69WCLcvi4/iNCKwG6c5oCeB2U01urw8Z0OPBqZYw5sYrNUGW3Ty9nZayAqMF3
	 3MOphoiJaReQjsNpOVrQJ0LgX6ly0bFHQp3W3BenSe5gqpb8EuSGs2YUaUKjqG4EPIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794629818;
	h=DMARC-Filter:Received:From:To:Cc:Subject:In-Reply-To:References:Date:
	 Message-ID:Content-Type:Content-Transfer-Encoding:MIME-Version:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=S6kiqdVKMkVNYTChARUpKHlGdEeOPXN5Ha+0Av6nzJ8=;
	b=qhYHnYgA+zDLEQktpOh1+/bKzUgajUWVHOA6e2qJVaqSEx43CPY/oBXHyCGrjw6rErcH
	 JvBRCxZpc4WvtLQjC/i6+PIFDvsye63CPoQa9pUR+UKri7IotnWbOprV7PCR17cKnhEk9
	 WJ9aiA+UXSRlaU18hoCDoZ/k6ptCYmbNQC18kgip2apIA9gBomJAFVoGUQ/uDyvDxfQZY
	 CuXXyp01p7GroBFhH05LfvjxInV0O/SundoDlHhPrrs7bUMJ/Yn9LVcu+E2O02Gu3r1nF
	 9Y/Y9L6FT/V+4s3NwGnm0SmDbNQQuExj8Q60RfzdG6sJ84EYbqTDauuiA2kSpfu7Ddw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8130606A32E;
	Sat, 14 Nov 2026 04:16:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8130606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [172.100.0.8] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowACHl5iu4Pdqpa7+AA--.17162S2;
	Sat, 14 Nov 2026 12:16:46 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, ayush.sawal@chelsio.com,
 davem@davemloft.net, harsh@chelsio.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: chelsio - Fix wrcount leak in chcr_aes_decrypt()
In-Reply-To: <e34e5630-2f3e-4f7f-9f47-4fec11c1a61e@kernel.org>
References: <20260916092359.2001753-1-vulab@iscas.ac.cn>
 <arNk6ujyrvTsFBfS@gondor.apana.org.au>
 <e34e5630-2f3e-4f7f-9f47-4fec11c1a61e@kernel.org>
Date: Sat, 14 Nov 2026 04:16:58 -0000
Message-ID: <179462981823.3213356.6963922528052260032@iscas.ac.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-CM-TRANSID:rQCowACHl5iu4Pdqpa7+AA--.17162S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtw4fGFW7WFWxKrW5GFy5CFg_yoW8Jr4rpF
	Z3G3WfKw1Utr4jyFW8C3y7JF15Ww4rAa4DGrySq3yvkayYva47Zw109r4Uur43uFs8W3W3
	ArWavrWqkF98AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxV
	WxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7
	v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_
	Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU5
	7rcDUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRULA2r3wMY6pQAAsQ

Hi Krzysztof,

My goal is to contribute to the Linux kernel and to study how to
effectively detect bugs in it.

I have never intended to introduce bugs or to use a large batch of
patches to hide a harmful change. I ask that you stop suggesting
that this was my intent.

I have personally replied to all the concerns raised so far. For
example, I explained to Jeff why I had used a shared address and
how I would handle the remaining feedback. I answered Laurent's
question about why I submitted the patches. I also apologized for
submitting too many patches, for not validating them well enough,
and for taking too long to reply:

https://lore.kernel.org/all/179385786361.1679257.11036002925458972121@iscas.a=
c.cn/
https://lore.kernel.org/all/179430684554.3011466.3431045638041318447@iscas.ac=
.cn/
https://lore.kernel.org/all/179436839700.3055208.16759622808608708086@iscas.a=
c.cn/

I wrote the first draft of each reply myself. English is not my
first language, so I used AI only to help with grammar and wording.
I checked the final text before sending it to make sure it said
what I meant.

I'd be grateful if you'd give me a chance to make up for my mistakes
and earn back your trust.

Thanks,
Wentao


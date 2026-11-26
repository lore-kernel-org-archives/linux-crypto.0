Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795697997;
	b=YbSoy86Kg6iyQK9Iw+Mq6qtAWfKHkhsdg7LFrEu0qyaDYsxPXWRZle0lJg4EUe+LRcJG
	 cB5sIDx79uXOzpe2oHyb1knAKWxVzFl0lYhQ0RleSgXmZWzBBTaHsgTJ5kds9f9iNK77I
	 epGvj0/Lw/H3bOgMGqmAcz7l3us1KmqD7v837gdaJ45h7IQPhxoXqHRcryf19CBK9eMeb
	 /GOJwcqUMUSidgPja1bvyvnXQaQAAKoCRIb0VNk042+JSlzWY+BXjMsSyyz8sOUDZlDMt
	 B2mlNXugHaD5IAzRvk6hqJ+d+tIMy59FmD8yEDmTp4KT9DiwSSe3ewU7BI240llABuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795697997;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=8UAW2bnPQY5CEkCAKoQY6aTjM1SqiXcvoTAgeEUIs6Y=;
	b=2FJAk/AiEe/WTnwvAGRXHb0f+7YuAO71oMkIpe4hHt5Zi5cEMnYNnOseyNv/T+24UP4U
	 NtChtqxRXq8enAmb16c9oXS9+9eTWZJYx/9o4csnL1J+g2OUfjcAodSGjE6pSDYjzHhnt
	 5WpO1kVKZhNt04ZSACZg6wPivYyjrUeMF46bpUsX6wGEugddCIHa1nmAhy5WlJUYIzbeB
	 sleBnWu3aWa6pUxfcvvHjuKhhuf1sxjjNms9Hhwb3uFquJxlHRMJpgoju9IBHJb7/0f2u
	 VirgC1yYMdMrHEpBOqQJD3PJtKipCwADL/b6yuULMP86IQ1mSoLSejS58f9fkc8KcJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVwsLcF4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7203606A321;
	Thu, 26 Nov 2026 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVwsLcF4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6611F000C0;
	Thu, 26 Nov 2026 12:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795697997;
	bh=8UAW2bnPQY5CEkCAKoQY6aTjM1SqiXcvoTAgeEUIs6Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XVwsLcF4pFvZhe0qU8nHWGH0bZDZoYgt9cNp/k6zaYDPeJG1myh0wm+pRyIim1yIR
	 V8E+kl2dO6NLQz7w2onrx/Dj6e5qi686EBZpy1rVIor5LGJ1Gl7Ns9Cht2efPSmEZZ
	 dIF2bFy2VUF8rNzfU3Hrovx77D1qGK3EcektNhiDUBfZCgytqsdlr5S8J8D/SPsgDF
	 CemvpIERdp4jnDSa+nxqU71T/M/oIYrH4fbrlir9uoYwCUawdwX1ImmMrdzWaswU0h
	 1EK6F1BV4386UR4HdfpdOEO+TH3vOpK0TTTH+AZdZBim2YO179yjrd/HDcNU5jWFU6
	 bOs7g69PtOWdA==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org, Qunqin Zhao <zhaoqunqin@163.com>
Cc: chenhuacai@kernel.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-crypto@vger.kernel.org, 
 mfd@lists.linux.dev, Qunqin Zhao <zhaoqunqin@loongson.cn>, 
 Huacai Chen <chenhuacai@kernel.org>
In-Reply-To: <20261116095307.21990-1-zhaoqunqin@163.com>
References: <20261116095307.21990-1-zhaoqunqin@163.com>
Subject: Re: (subset) [PATCH v10] mfd: loongson-se: Add multi-node support
Message-Id: <179569799566.72332.6714066319506489934.b4-ty@b4>
Date: Thu, 26 Nov 2026 12:59:55 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16-dev-ad80c

On Mon, 16 Nov 2026 17:53:07 +0800, Qunqin Zhao wrote:
> On the Loongson platform, each node is equipped with a security engine
> device. However, due to a hardware flaw, only the device on node 0 can
> trigger interrupts. Therefore, interrupts from other nodes are forwarded
> by node 0. We need to check in the interrupt handler of node 0 whether
> this interrupt is intended for other nodes, this can be accomplished via
> shared interrupt handling.
> 
> [...]

Applied, thanks!

[1/1] mfd: loongson-se: Add multi-node support
      commit: 5a8fc2b762fdd22698dc10449a960a892e43192e

--
Lee Jones [李琼斯]


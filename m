Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068997;
	b=hoj6Xn0JdmAWFy0lBtQidAaKFYSMn0GfKy8FhQckbmFkF5c/PGZOPiq5NbOMUYGFveCh
	 hjO0HKplL2aZ1n9VjnQDWWg4HOpLXqvMSNDntx+u8+NA5DqbBwaOYJZnhxvQ8SyiwATJi
	 H8vjpS1cjwLz+LLGM3B5v4QXxLaDX07kgFynYXdAQlGjzHuMMTqYvDexxwpWnikHUPsTI
	 82bpSCukFxLp5jQpiELNcoOwj834qmHRgLBPdWaIMVNPcHa+aT0tbGd5zgMBb0fCFziwE
	 3nJk5hFDmX0HdHGPJSKKUKCgXqLBYCb6HbVHwWxZmbgovg9rGvhlo5xvOhcIQ00hZ9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068997;
	h=DMARC-Filter:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=IKs4C9V2Krahgn2sw/njHCKySJqkCP+QuXj+XB+M/hY=;
	b=H3oA4EuEfcK+ZefxAslSYjERjUxW25rEeFd3lcgyZhMayHqj/JpyLAertvq/xdtgw4ZV
	 ID0gKKI2cbXPSQxsMstsXmWxO6PlQSsRymf4ykSsuRzOaqwKUkMPznFsBKxlEFtkxclYz
	 TfTh+VOO2hMkRqDE0gcPQoyp7BH3fioWEH1DyYsRHRUir23uC9f4i3lvjvCvoBwlhfFIr
	 mKQtTt9a2wFqv33MefzzVFEaX6CMievqjo5XLkd5J054URsjI+Cvd1jXLLlR6ZEB0Zvl3
	 nF1/AfJ6M2hILnwXPxtmUNx4voBg1U12Vw8eg+wRfoZg5CCPF0y5/H/XNBuaVMfV7hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C907606A31A;
	Tue, 27 Oct 2026 02:43:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C907606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.102])
	by gateway (Coremail) with SMTP id _____8Bxb9PAD+Bqo60ZAA--.8914S3;
	Tue, 27 Oct 2026 10:43:12 +0800 (CST)
Received: from [127.0.0.1] (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJAx3c68D+BqmocwAA--.35858S2;
	Tue, 27 Oct 2026 10:43:11 +0800 (CST)
Message-ID: <05420c73-2f4d-423c-86fc-e8053edab415@loongson.cn>
Date: Tue, 27 Oct 2026 10:40:23 +0800
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
Subject: Re: [PATCH 17/28] mfd: loongson-se: Reinitialise completions and wait
 uninterruptibly for commands
To: Lee Jones <lee@kernel.org>
Cc: stable@vger.kernel.org, Yinggang Gu <guyinggang@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, linux-crypto@vger.kernel.org,
 mfd@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261021121245.3111563-1-lee@kernel.org>
 <20261021121245.3111563-17-lee@kernel.org>
Content-Language: en-US
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
In-Reply-To: <20261021121245.3111563-17-lee@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAx3c68D+BqmocwAA--.35858S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Cr45Kr4rWr13Cw4rXw43Arc_yoW8Xr1xpF
	43uw4UKF4DtF1kt3Z0q34j9a45urZ3JrZrCanrtryUAr4qyFyvgFy5tF4kA398u39Yqry2
	qFWDGFWF9a15JFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jUsqXUUUUU=


在 2026/10/21 20:09, Lee Jones 写道:
> loongson_se_send_controller_cmd() and loongson_se_send_engine_cmd() wait
> on se->cmd_completion and engine->completion using
> wait_for_completion_interruptible() without reinitialising the
> completion before issuing a new command.  Because the hardware has no
> mechanism to abort an in-flight command once accepted by
> loongson_se_poll(), returning early on a signal leaves the controller or
> engine actively processing the shared command registers and DMA buffers
> in the background, and its subsequent completion interrupt leaves a
> stale completion token that causes the next command to return
> prematurely.
>
> Clear any stale pending interrupt status and reinitialise the target
> completion inside loongson_se_poll() while holding se->dev_lock
> immediately before notifying the controller, and wait uninterruptibly
> via wait_for_completion() once loongson_se_poll() confirms the command
> has been accepted by the hardware.
>
> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
> Closes: https://sashiko.dev/#/bug/linux-4661fb0d-d936-4168-89cd-2f6dec31a7b5
> Cc: stable@vger.kernel.org
> Signed-off-by: Lee Jones <lee@kernel.org>

Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Tested-by: Qunqin Zhao <zhaoqunqin@loongson.cn>

Thanks for fixing this!


Best Regards,

Qunqin.


Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB3439479C;
	Wed, 30 Sep 2026 07:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754527; cv=none; b=VCP+bqRIEVVUAi8UDHM8MRA6hp5MoxfrSKAQ4wEEaFV7A6HUIsIOhifXXOXDi5UYLuEnF2rS622GkO4sAFnLKBfaZMEY+OI/s6U9ndgszNCCYbtvqqo5oHqddInroU/kcAZAQ3bBezZ/tKT2QjvXnWrm5k08xA1azA37EsDXlz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754527; c=relaxed/simple;
	bh=vtpfHdYuEtUZjn4p9ZCCdv1s6a9BQG6VtoJEKOZerGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1QfwQUgU5aXEE7b9F4/kUSeg+3K1nkm11cdrL0mxeANe5xeiqhgv5TFeF4AaejF03LeLWFXLWooK/VjHNeD+0SGV5qgB1DkZprLBku2dAmBe+yXibVwhp/PgATuFehzFXOsqdaJEdVFsxwFk0K1CSNwsrUXSdNxoQRE0plq7Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wCnQzzUvrxqm5hJAQ--.125S3;
	Wed, 30 Sep 2026 15:48:37 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app2 (Coremail) with UTF8SMTPA id zC_KCgCX733Rvrxqv5wZAA--.24898S2;
	Wed, 30 Sep 2026 15:48:33 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: Markus.Elfring@web.de
Cc: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	john.allen@amd.com,
	thomas.lendacky@amd.com,
	davem@davemloft.net,
	songl@zju.edu.cn,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: Re: [PATCH v2] crypto: ccp - Fix use-after-free in backlog cmd advancement
Date: Wed, 30 Sep 2026 07:47:36 +0000
Message-Id: <20260930074736.40710-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <8b4458b0-a3f4-4eb4-8b85-5d4139ac3ae8@web.de>
References: <20260929143825.21349-1-fanwu01@zju.edu.cn> <8b4458b0-a3f4-4eb4-8b85-5d4139ac3ae8@web.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zC_KCgCX733Rvrxqv5wZAA--.24898S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?culGLwXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnVvLbuoOKy0xUR2OEh/LyhkSL9jUxBlzHNHbi3nVuMEDB4IGqZJ+tcM0Mhfd2q4axICe
	VteTbZidzXXs8+RP7dbN5RPxYw6l01w8CbPzC/8w
X-Coremail-Antispam: 1Uk129KBj9xXoW7JryDuFWfXw48uF15uw4xXwc_yoW3tFX_A3
	4fAFyUCw18CF43Ca1fKF4jyF1rKrW8Cw1ruF1rJF13KryfXan8G3s7JF9xC3Wj9ay293Zx
	Gas8X345Ww47KosvyTuYvTs0mTUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUb-AYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
	kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
	6r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
	Ij64vIr41lF7xvr2IYc2Ij64vIr40E4x8a64kEw24l42xK82IYc2Ij64vIr41l4I8I3I0E
	4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
	WUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
	Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4U
	YxBIdaVFxhVjvjDU0xZFpf9x07jbo7NUUUUU=

On Tue, 29 Sep 2026 17:18:29 +0200, Markus Elfring wrote:
> May lock guards be applied in affected function implementations?
> https://elixir.bootlin.com/linux/v7.3-rc5/source/include/linux/spinlock.h#L642-L645

I considered using lock guards, but kept the manual locking here.

ccp_dequeue_cmd() deliberately has two separate cmd_lock sections, with
the -EINPROGRESS callback between them. The callback must run outside
cmd_lock, so the explicit unlock makes that boundary clear.

This is also a stable fix for code dating back to 2013. Stable branches
such as v6.1 do not have the cleanup/guard helpers, while the manual
form backports unchanged.

I can use a guard for the one-statement ccp_halt_cmds() helper if you
prefer, but would keep the two promotion sections explicit.

Thanks,
Fan Wu


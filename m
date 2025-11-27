Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D3F1F4CA9;
	Thu, 27 Nov 2025 01:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207948; cv=none; b=Nvt1OW+jpyTLV+uAZUCKNR6TOrpn1U9iWe17m0QEwBMUgUX6Zp5m15Ge4jDY6Tdx+xrAj6FK8EkV0BSPGirflpIy/qiS5F+h5sx9q23i1C+17El58GiDQeURffFsETHWTe+u8e/L3bi9dazkJnqoNIJb7/tH8JdWHnQFrNszRKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207948; c=relaxed/simple;
	bh=7zmgDxz3BNsU8+CzY8b8wvYlKheGihwr1LJC5MJWTNA=;
	h=To:Cc:From:Subject:Message-ID:Date:MIME-Version:Content-Type; b=uj6+vLYr40iuQOFCBX2qr/s3JXxRJ8OSKcPRt4vKSb+NcUu6GGjsH8vAQ7ShWI7VtDNN0YCeaUb+3rRWEy9a9qOLfsyQ1qkkQqaqQdfMpdelIvzdCRKKNFva23ttaOrOAmywEtwvvj9O0jw3t2IQblkpvX/Rfy7/iQA1BujV5Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxJ9FBrSdp3pEoAA--.21115S3;
	Thu, 27 Nov 2025 09:45:37 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxVOQ9rSdpJo9AAQ--.50365S3;
	Thu, 27 Nov 2025 09:45:35 +0800 (CST)
To: arei.gonglei@huawei.com
Cc: linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kernel <linux-kernel@vger.kernel.org>,
 QEMU devel <qemu-devel@nongnu.org>
From: Bibo Mao <maobibo@loongson.cn>
Subject: virtio-crypto: Inquiry about virtio crypto
Message-ID: <d4258604-e678-f975-0733-71190cf4067d@loongson.cn>
Date: Thu, 27 Nov 2025 09:43:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qMiowJAxVOQ9rSdpJo9AAQ--.50365S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29K
	BjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26c
	xKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vE
	j48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zw
	Z7UUUUU==

Hi gonglei,

    I am investigating how to use HW crypto accelerator in VM. It seems 
that virtio-crypto is one option, however only aes skcipher algo is 
supported and virtio-crypto device is not suggested by RHEL 10.
 
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10/html/configuring_and_managing_linux_virtual_machines/feature-support-and-limitations-in-rhel-10-virtualization

   I want to know what is the potential issued with virtio-crypto.

Regards
Bibo Mao


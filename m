Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E7519F429
	for <linux-crypto@vger.kernel.org>; Tue,  1 Oct 2024 10:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727779361; cv=none; b=edlNEZLQH0jqUdWewd8mPE3D2d07+JJyl5w5dqvmkV11jYebZ9DjfbjLv7U4cf5k2o69Q1pdvEr7AiBr6jodyn2m4HRVgWDX1Ozy94yBx+PVBo7/eb32860SAMevVzZsBwh5o/BX754I9zobPj2WZPuJEsCoFD+v85YqU75Wk3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727779361; c=relaxed/simple;
	bh=VvfFsYcWmy08K83MkxWEZhNUI9bL28AX1RnBeR/0Ubg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o/aqQBo8KxGy5cHhK9QNPyMkorAh2KVhMGXvfI+bFCWW3G0z+mRvg8Ot7TBF2S6RnzbgUC50j5xW8Rc5IjAnE/vmWMtnZmINgi/PcGUiukqQE4APQ0xeADe7GnLpks0ZXH8vFE6clGdLtt/eLinDFo29DcFC7rJ56pIMJ+IiCOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 4C31DE0008;
	Tue,  1 Oct 2024 10:42:36 +0000 (UTC)
Message-ID: <2f8913ab-b9e7-4fa8-ac9c-67d05b9e8beb@ghiti.fr>
Date: Tue, 1 Oct 2024 12:42:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: crypto: starfive: kernel oops when unloading jh7110_crypto module
 and loading it again
Content-Language: en-US
To: JiaJie Ho <jiajie.ho@starfivetech.com>,
 Aurelien Jarno <aurelien@aurel32.net>,
 William Qiu <william.qiu@starfivetech.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 E Shattow <lucent@gmail.com>
References: <ZspDyIZiG8kvXaoS@aurel32.net>
 <NT0PR01MB11822312703A78C4F17C302B8A8B2@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <NT0PR01MB11822312703A78C4F17C302B8A8B2@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

Hi Jia Jie,

On 26/08/2024 04:04, JiaJie Ho wrote:
>> I have been testing the jh7110_crypto module on a VisionFive 1.2a board,
>> running a 6.11-rc4 kernel. To benchmark the crypto with and without
>> acceleration, I have unloaded the module, and later on I loaded it again.
>> Unloading it works fine, but when loading it again, I get the following kernel
>> oops:
>>
> Hi, I'll investigate it. Thanks for reporting this.


Did you have time to look into this?

Thanks,

Alex


>
> Best regards,
> Jia Jie
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

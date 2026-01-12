Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32629330D36;
	Mon, 12 Jan 2026 21:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768253113; cv=none; b=rl799A5VCk1SayVU467MFjYIaVeU02Ho6uRORqTpRy2vnA7XaB7v8PuPsSWldaWTXtTYUDfL0CdSh47gyokX6R1DgXMB3hky3a7O/qUZucuXIBIMgOtYyT6KwOpcbW92X4I/Q8ElIhEdDoGxkv3YmhW3rMpar0uCDcGepqps50I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768253113; c=relaxed/simple;
	bh=dDRp4mpGxN5nvZCGUaMGXAHlBrsATVpfcDiYMNE6F3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Emb0h3ImMZ80OH6a62/UuYdD7PxC/2IS/WxC+z9qNuvfxHyVkLMszT/xe/G6joQnMMIDiAVn+4CQ68tTX6xknMp0hybWXZ0omEVSE2tgZHnK6acbVtOqpqhQulZFTCA3siGUrjyn8ONSEQGDVcanGNfCBLkC+1nUlk7kxJwiaPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qMNp0vFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qMNp0vFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA35EC116D0;
	Mon, 12 Jan 2026 21:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768253112;
	bh=dDRp4mpGxN5nvZCGUaMGXAHlBrsATVpfcDiYMNE6F3s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qMNp0vFGrp1Sn47Cz0jA2vNZ8Sgrog7ptBfrpVdhblROMamHUQnKLEqoLgC/CSBqh
	 ClUF4v2rVs3oHgU72/At/00RnIQ1MrhZe7I2WVlLubNJwnV/1HqkmqCJwE30wBXVQu
	 LSxEb8ZdqO3yCk/XOOOl+Lxh8PgSkAFn+i5GeJlwNM52QNNZQXz62bSzmOdSWaxaWA
	 tuMswyPGX+4gumGMOo6kr177iFAzPRhs21bEMA6JrwN3ZkrYJFlipwoQLpNXlHa6la
	 kvpDNCqVNwSioeVRXaSg6xCwAE6aMGaIy85BnbiAEmgOPH3/B2MYn2SnGhS2SgzIg4
	 htTe1NZAVtlQQ==
Message-ID: <20acfb14-02a0-4f7a-9924-fa70fb485418@kernel.org>
Date: Mon, 12 Jan 2026 15:25:11 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] crypto: ccp - Add an S4 restore flow
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>,
 Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
References: <20260112053610.2566943-1-superm1@kernel.org>
 <20260112053610.2566943-4-superm1@kernel.org>
 <69f9b4eb-02a7-4a8f-8e77-903dee9e2de5@amd.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <69f9b4eb-02a7-4a8f-8e77-903dee9e2de5@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/26 10:33 AM, Tom Lendacky wrote:
> On 1/11/26 23:36, Mario Limonciello (AMD) wrote:
>> The system will have lost power during S4.  The ring used for TEE
>> communications needs to be initialized before use.
>>
>> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
>> Reported-by: Lars Francke <lars.francke@gmail.com>
>> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
>> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
>> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
>> ---
>> v5:
>>   * Fix return for psp_restore() (LKP robot, Shyam)
>> v4:
>>   * Add tag (Yijun)
>>   * Remove blank line (Ilpo)
>>   * Adjust whitespace in psp_restore() (Ilpo)
>> ---
>>   drivers/crypto/ccp/psp-dev.c | 11 +++++++++++
>>   drivers/crypto/ccp/sp-dev.h  |  2 ++
>>   drivers/crypto/ccp/sp-pci.c  | 24 +++++++++++++++++++++++-
>>   drivers/crypto/ccp/tee-dev.c |  5 +++++
>>   drivers/crypto/ccp/tee-dev.h |  1 +
>>   5 files changed, 42 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>> index 9e21da0e298ad..5c7f7e02a7d8a 100644
>> --- a/drivers/crypto/ccp/psp-dev.c
>> +++ b/drivers/crypto/ccp/psp-dev.c
>> @@ -351,6 +351,17 @@ struct psp_device *psp_get_master_device(void)
>>   	return sp ? sp->psp_data : NULL;
>>   }
>>   
>> +int psp_restore(struct sp_device *sp)
>> +{
>> +	struct psp_device *psp = sp->psp_data;
>> +	int ret = 0;
>> +
>> +	if (psp->tee_data)
>> +		ret = tee_restore(psp);
>> +
>> +	return ret;
>> +}
>> +
>>   void psp_pci_init(void)
>>   {
>>   	psp_master = psp_get_master_device();
>> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
>> index 1335a83fe052e..0deea1a399e47 100644
>> --- a/drivers/crypto/ccp/sp-dev.h
>> +++ b/drivers/crypto/ccp/sp-dev.h
>> @@ -174,6 +174,7 @@ int psp_dev_init(struct sp_device *sp);
>>   void psp_pci_init(void);
>>   void psp_dev_destroy(struct sp_device *sp);
>>   void psp_pci_exit(void);
>> +int psp_restore(struct sp_device *sp);
>>   
>>   #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>   
>> @@ -181,6 +182,7 @@ static inline int psp_dev_init(struct sp_device *sp) { return 0; }
>>   static inline void psp_pci_init(void) { }
>>   static inline void psp_dev_destroy(struct sp_device *sp) { }
>>   static inline void psp_pci_exit(void) { }
>> +static inline int psp_restore(struct sp_device *sp) { return 0; }
>>   
>>   #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>>   
>> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
>> index 8891ceee1d7d0..931ec6bf2cec6 100644
>> --- a/drivers/crypto/ccp/sp-pci.c
>> +++ b/drivers/crypto/ccp/sp-pci.c
>> @@ -353,6 +353,21 @@ static int __maybe_unused sp_pci_resume(struct device *dev)
>>   	return sp_resume(sp);
>>   }
>>   
>> +static int __maybe_unused sp_pci_restore(struct device *dev)
>> +{
>> +	struct sp_device *sp = dev_get_drvdata(dev);
>> +
>> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
> 
> This isn't needed since you have the "#else" definition in sp-dev.h.

Ack.

> 
>> +	if (sp->psp_data) {
>> +		int ret = psp_restore(sp);
>> +
> 
> Remove blank line.

Then checkpatch complains:

Missing a blank line after declarations

> 
>> +		if (ret)
>> +			return ret;
>> +	}
>> +#endif
> 
> This isn't the way the other functions work. This function should just
> be calling to sp_resume() and then sp_resume() should call psp_restore()
> (or psp_dev_restore() ?) if the psp_data is present.
> 
> And if you need to distinguish between the resume and restore case in
> sp_resume(), then it sounds like you need an sp_restore().

We do need a different path for resume and restore.

I guess the call path you're looking for is:

sp_pci_restore()
-> sp_restore()
->-> psp_restore()
->-> sp_resume()

Basically move the contents of sp_pci_restore() into a new sp_restore().

> 
> Thanks,
> Tom
> 
>> +	return sp_resume(sp);
>> +}
>> +
>>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>   static const struct sev_vdata sevv1 = {
>>   	.cmdresp_reg		= 0x10580,	/* C2PMSG_32 */
>> @@ -563,7 +578,14 @@ static const struct pci_device_id sp_pci_table[] = {
>>   };
>>   MODULE_DEVICE_TABLE(pci, sp_pci_table);
>>   
>> -static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
>> +static const struct dev_pm_ops sp_pci_pm_ops = {
>> +	.suspend = pm_sleep_ptr(sp_pci_suspend),
>> +	.resume = pm_sleep_ptr(sp_pci_resume),
>> +	.freeze = pm_sleep_ptr(sp_pci_suspend),
>> +	.thaw = pm_sleep_ptr(sp_pci_resume),
>> +	.poweroff = pm_sleep_ptr(sp_pci_suspend),
>> +	.restore_early = pm_sleep_ptr(sp_pci_restore),
>> +};
>>   
>>   static struct pci_driver sp_pci_driver = {
>>   	.name = "ccp",
>> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>> index af881daa5855b..11c4b05e2f3a2 100644
>> --- a/drivers/crypto/ccp/tee-dev.c
>> +++ b/drivers/crypto/ccp/tee-dev.c
>> @@ -366,3 +366,8 @@ int psp_check_tee_status(void)
>>   	return 0;
>>   }
>>   EXPORT_SYMBOL(psp_check_tee_status);
>> +
>> +int tee_restore(struct psp_device *psp)
>> +{
>> +	return tee_init_ring(psp->tee_data);
>> +}
>> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
>> index ea9a2b7c05f57..c23416cb7bb37 100644
>> --- a/drivers/crypto/ccp/tee-dev.h
>> +++ b/drivers/crypto/ccp/tee-dev.h
>> @@ -111,5 +111,6 @@ struct tee_ring_cmd {
>>   
>>   int tee_dev_init(struct psp_device *psp);
>>   void tee_dev_destroy(struct psp_device *psp);
>> +int tee_restore(struct psp_device *psp);
>>   
>>   #endif /* __TEE_DEV_H__ */
> 
> 


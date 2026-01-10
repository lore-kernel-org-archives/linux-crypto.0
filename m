Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F32500948;
	Sat, 10 Jan 2026 21:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768080849; cv=none; b=FbcLCV+rqB18As/DGWKHKMoZx6+5s/DFd1ZQWjdA6VkGh9NJbwKR1uuI4Tz0T0Zq5ySeTp92DZYtabTM0p5AeZS6tPC6TmVUTDmMFqarPyi+PxcMZwAK4DG3MqF/D79a3rsEOtmtprZbl0MjpElckR+VaRFCWaY1OHUp3EVERjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768080849; c=relaxed/simple;
	bh=S2tmH5kwdYN7zYODDAQw5p3/8Qk0RhW6jRtTaQ1iw44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LvyB+Id5ZJnczxcKP5a63G/ACXiYgnXGQgkqsDUJCK4A3Bv9woreawGlSqvn8Y1m6Pp6Iuo/6YXgYMQf++LwKYaACqEfhKs19UdypwcLcydtrVM0biC01QNhf8r9exPByrvM0l8NQzGduWkkgj1yTpDItzImxJ1ibnizcxAvnsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6lp8EEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6lp8EEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1781AC4CEF1;
	Sat, 10 Jan 2026 21:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768080849;
	bh=S2tmH5kwdYN7zYODDAQw5p3/8Qk0RhW6jRtTaQ1iw44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T6lp8EEwuGgBNv42eymwm+arM4meyg61AiKhI7yq7CghRwXJyTCCQqas9NRUl5cbv
	 ocHpkjTmfIRu8C/NFZwcMusMH3RVBrPheMs/KAy8wboNbYJzljesvWnZjR2/i/qdM5
	 i8BnfipdA+IzriTA3t/Ia2obQ+AoFaJHO75DQnflawlDxLknk/YtD/am/OY+h57kyX
	 k29SkeBDgrifFCgbNy5CXz8yYYSrPkD4AwLiJF5AHZcPr+yuPKCktykBSWvf2SpOEP
	 UkeTI4W65Z4ECsX2RUU61gdhWspEiPzxgAxZFpSnp0ADy88qnZzOVMrcB5P+saHkQz
	 eUihywtsQNa6w==
Message-ID: <a8dcc943-3a96-4654-97a3-0adf55f6d4e1@kernel.org>
Date: Sat, 10 Jan 2026 15:34:05 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
 PSP_CMD_TEE_RING_INIT fails
To: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Cc: "Allen, John" <John.Allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>
References: <20260106045423.55190-1-superm1@kernel.org>
 <20260106045423.55190-6-superm1@kernel.org>
 <f1cb81b7-5aab-48d0-99ce-5f971f5d2fa7@amd.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <f1cb81b7-5aab-48d0-99ce-5f971f5d2fa7@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/7/26 3:04 AM, Shyam Sundar S K wrote:
> 
> 
> On 1/6/2026 10:24, Mario Limonciello (AMD) wrote:
>> The hibernate resume sequence involves loading a resume kernel that is just
>> used for loading the hibernate image before shifting back to the existing
>> kernel.
>>
>> During that hibernate resume sequence the resume kernel may have loaded
>> the ccp driver.  If this happens the resume kernel will also have called
>> PSP_CMD_TEE_RING_INIT but it will never have called
>> PSP_CMD_TEE_RING_DESTROY.
>>
>> This is problematic because the existing kernel needs to re-initialize the
>> ring.  One could argue that the existing kernel should call destroy
>> as part of restore() but there is no guarantee that the resume kernel did
>> or didn't load the ccp driver.  There is also no callback opportunity for
>> the resume kernel to destroy before handing back control to the existing
>> kernel.
>>
>> Similar problems could potentially exist with the use of kdump and
>> crash handling. I actually reproduced this issue like this:
>>
>> 1) rmmod ccp
>> 2) hibernate the system
>> 3) resume the system
>> 4) modprobe ccp
>>
>> The resume kernel will have loaded ccp but never destroyed and then when
>> I try to modprobe it fails.
>>
>> Because of these possible cases add a flow that checks the error code from
>> the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DESTROY
>> if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again.
>>
>> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
>> Reported-by: Lars Francke <lars.francke@gmail.com>
>> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
>> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
>> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
>> ---
>> v4:
>>   * Add tag (Yijun)
>>   * Move and rename PSP_TEE_STS_RING_BUSY (Ilpo)
>> v3:
>>   * Add a comment (Tom)
>>   * Add a define for busy condition (Shyam)
>>   * Rename label (Shyam)
>>   * Upgrade message to info (Shyam)
>>   * Use a helper that validates result for destroy command (Shyam)
>> ---
>>   drivers/crypto/ccp/tee-dev.c | 12 ++++++++++++
>>   include/linux/psp.h          |  1 +
>>   2 files changed, 13 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>> index ef1430f86ad62..ea9b94d5b10ba 100644
>> --- a/drivers/crypto/ccp/tee-dev.c
>> +++ b/drivers/crypto/ccp/tee-dev.c
>> @@ -113,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>   {
>>   	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>>   	struct tee_init_ring_cmd *cmd;
>> +	bool retry = false;
>>   	unsigned int reg;
>>   	int ret;
>>   
>> @@ -135,6 +136,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>   	/* Send command buffer details to Trusted OS by writing to
>>   	 * CPU-PSP message registers
>>   	 */
>> +retry_init:
>>   	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
>>   				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
>>   	if (ret) {
>> @@ -145,6 +147,16 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>   	}
>>   
>>   	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
>> +		/*
>> +		 * During the hibernate resume sequence driver may have gotten loaded
>> +		 * but the ring not properly destroyed. If the ring doesn't work, try
>> +		 * to destroy and re-init once.
>> +		 */
>> +		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == PSP_TEE_STS_RING_BUSY) {
>> +			dev_info(tee->dev, "tee: ring init command failed with busy status, retrying\n");
>> +			if (tee_send_destroy_cmd(tee))
> 
> so it becomes infinite retry? I think we need to set the retry flag to
> true to indicate that ring busy.

Great catch, thanks.  I'll add the retry=true for this case.

> 
>> +				goto retry_init;
>> +		}
>>   		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>>   			FIELD_GET(PSP_CMDRESP_STS, reg));
>>   		tee_free_ring(tee);
>> diff --git a/include/linux/psp.h b/include/linux/psp.h
>> index 92e60aeef21e1..b337dcce1e991 100644
>> --- a/include/linux/psp.h
>> +++ b/include/linux/psp.h
>> @@ -18,6 +18,7 @@
>>    * and should include an appropriate local definition in their source file.
>>    */
>>   #define PSP_CMDRESP_STS		GENMASK(15, 0)
>> +#define  PSP_TEE_STS_RING_BUSY 0x0000000d  /* Ring already initialized */
> 
> additional spaces between the macro names.

This was actually intended.  I wanted to make it obvious that 
PSP_TEE_STS_RING_BUSY reflects a value used for PSP_CMDRESP_STS.

> 
> Thanks,
> Shyam
> 
>>   #define PSP_CMDRESP_CMD		GENMASK(23, 16)
>>   #define PSP_CMDRESP_RESERVED	GENMASK(29, 24)
>>   #define PSP_CMDRESP_RECOVERY	BIT(30)
> 
> 


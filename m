Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE9830BB93;
	Mon, 15 Dec 2025 14:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765810634; cv=none; b=rGVfDrcduJPPO6ZXuf6J+YqiAtqs3VaSROgiMoBdXbmGdHLVe1eCQpyTo3ZnYmeV+OA8LOdjrxKPFBDZE6DSZ6OX+wcgb2yLj8BthOOq7gWe5ZsvjRVxMX/PPE/rjYmT1rGwtT6aSs3a/Q0c325nToK4CPpv6HNWfPPrr/aHhlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765810634; c=relaxed/simple;
	bh=Kt88zhRCNvKhnHZ6We6BuoYnSr4Gk584iz2cd6VF5uQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DxTjeT9w9j/xJ+F0yVD8A6HDXBAMZht95bnD/oue6Xgd8AA/E1Y/AYrwQi78d6ZiNn8UZSO8pEG65GoXRYnW3X7/NShdCP1y+77T5OTLTOXJ6KHvRzZs+joANYAcXrf/NusZn02xO6idxqxLmkY3eIiX67FpKfajumn7Yodkg3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K88WwpD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K88WwpD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6013EC4CEF5;
	Mon, 15 Dec 2025 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765810634;
	bh=Kt88zhRCNvKhnHZ6We6BuoYnSr4Gk584iz2cd6VF5uQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K88WwpD0wRLQeqVwyfD+kVA+3i4pDK/G9ax2o6KgYXcjVTZdgBib3RND7kxspv2x/
	 NdORB7gNumsqaYtGymequ/z3C614njL2fllWG4byTddAk9vH/sJAyQnJ3hz/+atA29
	 LKiVraA+9n9Q32kcXQYGgICTxYGJPEsZPVEu/lbnZm1E+zax4ttg/G3EhJ4D29Tkix
	 3rdVt4q+V+2Lg2QEdWVeUzbTuqtaBkfe5wLVCn3ab3YhiONTbvcp+vBqDE6kbLqEW8
	 EJr5SV/oihmd7DKM3S+zdk6MxPiA94UmagZsGxRKyFlGh3X1X9QbX2Fyzr8SoMWKt7
	 W2Ix5BFLqi6kw==
Message-ID: <583f8d99-22b4-45cf-a5a3-b63e99cc966e@kernel.org>
Date: Mon, 15 Dec 2025 08:57:12 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
 PSP_CMD_TEE_RING_INIT fails
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>, John Allen <john.allen@amd.com>,
 "David S . Miller" <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>
References: <20251214191213.154021-1-superm1@kernel.org>
 <20251214191213.154021-6-superm1@kernel.org>
 <53f2736f-39b7-b041-ea02-372618df5de3@linux.intel.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <53f2736f-39b7-b041-ea02-372618df5de3@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/15/25 6:01 AM, Ilpo Järvinen wrote:
> On Sun, 14 Dec 2025, Mario Limonciello (AMD) wrote:
> 
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
>> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
>> ---
>> v3:
>>   * Add a comment (Tom)
>>   * Add a define for busy condition (Shyam)
>>   * Rename label (Shyam)
>>   * Upgrade message to info (Shyam)
>>   * Use a helper that validates result for destroy command (Shyam)
>> ---
>>   drivers/crypto/ccp/tee-dev.c | 12 ++++++++++++
>>   include/linux/psp.h          |  2 ++
>>   2 files changed, 14 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>> index ef1430f86ad62..9edb220abbc1a 100644
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
>> +		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == PSP_TEE_STATUS_RING_BUSY) {
>> +			dev_info(tee->dev, "tee: ring init command failed with busy status, retrying\n");
>> +			if (tee_send_destroy_cmd(tee))
>> +				goto retry_init;
>> +		}
>>   		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>>   			FIELD_GET(PSP_CMDRESP_STS, reg));
>>   		tee_free_ring(tee);
>> diff --git a/include/linux/psp.h b/include/linux/psp.h
>> index 92e60aeef21e1..a329148e3684b 100644
>> --- a/include/linux/psp.h
>> +++ b/include/linux/psp.h
>> @@ -23,6 +23,8 @@
>>   #define PSP_CMDRESP_RECOVERY	BIT(30)
>>   #define PSP_CMDRESP_RESP	BIT(31)
>>   
>> +#define PSP_TEE_STATUS_RING_BUSY 0x0000000d  /* Ring already initialized */
> 
> It would be better to have this right underneath PSP_CMDRESP_STS (you
> can use one extra space to indent different from the mask and bits).
> 
> Also, there's inconsistency in STS vs STATUS in the naming.

OK - to make sure I get it like you are suggesting for next spin, you 
mean like this right?

diff --git a/include/linux/psp.h b/include/linux/psp.h
index 92e60aeef21e..b337dcce1e99 100644
--- a/include/linux/psp.h
+++ b/include/linux/psp.h
@@ -18,6 +18,7 @@
   * and should include an appropriate local definition in their source 
file.
   */
  #define PSP_CMDRESP_STS                GENMASK(15, 0)
+#define  PSP_TEE_STS_RING_BUSY 0x0000000d  /* Ring already initialized */
  #define PSP_CMDRESP_CMD                GENMASK(23, 16)
  #define PSP_CMDRESP_RESERVED   GENMASK(29, 24)
  #define PSP_CMDRESP_RECOVERY   BIT(30)

> 
>> +
>>   #define PSP_DRBL_MSG		PSP_CMDRESP_CMD
>>   #define PSP_DRBL_RING		BIT(0)
>>   
>>
> 


From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] crypto: vmx - Fix sleep-in-atomic bugs
Date: Fri, 24 Aug 2018 16:47:14 -0300
Message-ID: <fd3caaa4fe25a456c94bbeab6365a82b@linux.vnet.ibm.com>
References: <CAAUqJDt_y04ts7Aq0U0fhXYRus2ckkEohBTkga0pjqfoQaBOCA@mail.gmail.com>
 <20180822062631.5664-1-omosnace@redhat.com>
 <20180823000446.GA26297@gallifrey>
 <11128af3ef7474136485261b5d53b679@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Leonidas S . Barbosa" <leo.barbosa@canonical.com>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
To: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <11128af3ef7474136485261b5d53b679@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2018-08-23 17:34, Paulo Flabiano Smorigo wrote:
> On 2018-08-22 21:04, Marcelo Henrique Cerri wrote:
>> That looks good to me. Maybe Paulo can help testing it.
>> 
>> --
>> Regards,
>> Marcelo
>> 
>> On Wed, Aug 22, 2018 at 08:26:31AM +0200, Ondrej Mosnacek wrote:
>>> This patch fixes sleep-in-atomic bugs in AES-CBC and AES-XTS VMX
>>> implementations. The problem is that the blkcipher_* functions should
>>> not be called in atomic context.
>>> 
>>> The bugs can be reproduced via the AF_ALG interface by trying to
>>> encrypt/decrypt sufficiently large buffers (at least 64 KiB) using 
>>> the
>>> VMX implementations of 'cbc(aes)' or 'xts(aes)'. Such operations then
>>> trigger BUG in crypto_yield():
>>> 
>>> [  891.863680] BUG: sleeping function called from invalid context at 
>>> include/crypto/algapi.h:424
>>> [  891.864622] in_atomic(): 1, irqs_disabled(): 0, pid: 12347, name: 
>>> kcapi-enc
>>> [  891.864739] 1 lock held by kcapi-enc/12347:
>>> [  891.864811]  #0: 00000000f5d42c46 (sk_lock-AF_ALG){+.+.}, at: 
>>> skcipher_recvmsg+0x50/0x530
>>> [  891.865076] CPU: 5 PID: 12347 Comm: kcapi-enc Not tainted 
>>> 4.19.0-0.rc0.git3.1.fc30.ppc64le #1
>>> [  891.865251] Call Trace:
>>> [  891.865340] [c0000003387578c0] [c000000000d67ea4] 
>>> dump_stack+0xe8/0x164 (unreliable)
>>> [  891.865511] [c000000338757910] [c000000000172a58] 
>>> ___might_sleep+0x2f8/0x310
>>> [  891.865679] [c000000338757990] [c0000000006bff74] 
>>> blkcipher_walk_done+0x374/0x4a0
>>> [  891.865825] [c0000003387579e0] [d000000007e73e70] 
>>> p8_aes_cbc_encrypt+0x1c8/0x260 [vmx_crypto]
>>> [  891.865993] [c000000338757ad0] [c0000000006c0ee0] 
>>> skcipher_encrypt_blkcipher+0x60/0x80
>>> [  891.866128] [c000000338757b10] [c0000000006ec504] 
>>> skcipher_recvmsg+0x424/0x530
>>> [  891.866283] [c000000338757bd0] [c000000000b00654] 
>>> sock_recvmsg+0x74/0xa0
>>> [  891.866403] [c000000338757c10] [c000000000b00f64] 
>>> ___sys_recvmsg+0xf4/0x2f0
>>> [  891.866515] [c000000338757d90] [c000000000b02bb8] 
>>> __sys_recvmsg+0x68/0xe0
>>> [  891.866631] [c000000338757e30] [c00000000000bbe4] 
>>> system_call+0x5c/0x70
>>> 
>>> Fixes: 8c755ace357c ("crypto: vmx - Adding CBC routines for VMX 
>>> module")
>>> Fixes: c07f5d3da643 ("crypto: vmx - Adding support for XTS")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
>>> ---
>>> Still untested, please test and review if possible.
>>> 
>>> Changes in v2:
>>> - fix leaving preemtption, etc. disabled when leaving the function
>>>   (I switched to the more obvious and less efficient variant for the
>>>   sake of clarity.)
>>> 
>>>  drivers/crypto/vmx/aes_cbc.c | 30 ++++++++++++++----------------
>>>  drivers/crypto/vmx/aes_xts.c | 21 ++++++++++++++-------
>>>  2 files changed, 28 insertions(+), 23 deletions(-)
>>> 
>>> diff --git a/drivers/crypto/vmx/aes_cbc.c 
>>> b/drivers/crypto/vmx/aes_cbc.c
>>> index 5285ece4f33a..b71895871be3 100644
>>> --- a/drivers/crypto/vmx/aes_cbc.c
>>> +++ b/drivers/crypto/vmx/aes_cbc.c
>>> @@ -107,24 +107,23 @@ static int p8_aes_cbc_encrypt(struct 
>>> blkcipher_desc *desc,
>>>  		ret = crypto_skcipher_encrypt(req);
>>>  		skcipher_request_zero(req);
>>>  	} else {
>>> -		preempt_disable();
>>> -		pagefault_disable();
>>> -		enable_kernel_vsx();
>>> -
>>>  		blkcipher_walk_init(&walk, dst, src, nbytes);
>>>  		ret = blkcipher_walk_virt(desc, &walk);
>>>  		while ((nbytes = walk.nbytes)) {
>>> +			preempt_disable();
>>> +			pagefault_disable();
>>> +			enable_kernel_vsx();
>>>  			aes_p8_cbc_encrypt(walk.src.virt.addr,
>>>  					   walk.dst.virt.addr,
>>>  					   nbytes & AES_BLOCK_MASK,
>>>  					   &ctx->enc_key, walk.iv, 1);
>>> +			disable_kernel_vsx();
>>> +			pagefault_enable();
>>> +			preempt_enable();
>>> +
>>>  			nbytes &= AES_BLOCK_SIZE - 1;
>>>  			ret = blkcipher_walk_done(desc, &walk, nbytes);
>>>  		}
>>> -
>>> -		disable_kernel_vsx();
>>> -		pagefault_enable();
>>> -		preempt_enable();
>>>  	}
>>> 
>>>  	return ret;
>>> @@ -147,24 +146,23 @@ static int p8_aes_cbc_decrypt(struct 
>>> blkcipher_desc *desc,
>>>  		ret = crypto_skcipher_decrypt(req);
>>>  		skcipher_request_zero(req);
>>>  	} else {
>>> -		preempt_disable();
>>> -		pagefault_disable();
>>> -		enable_kernel_vsx();
>>> -
>>>  		blkcipher_walk_init(&walk, dst, src, nbytes);
>>>  		ret = blkcipher_walk_virt(desc, &walk);
>>>  		while ((nbytes = walk.nbytes)) {
>>> +			preempt_disable();
>>> +			pagefault_disable();
>>> +			enable_kernel_vsx();
>>>  			aes_p8_cbc_encrypt(walk.src.virt.addr,
>>>  					   walk.dst.virt.addr,
>>>  					   nbytes & AES_BLOCK_MASK,
>>>  					   &ctx->dec_key, walk.iv, 0);
>>> +			disable_kernel_vsx();
>>> +			pagefault_enable();
>>> +			preempt_enable();
>>> +
>>>  			nbytes &= AES_BLOCK_SIZE - 1;
>>>  			ret = blkcipher_walk_done(desc, &walk, nbytes);
>>>  		}
>>> -
>>> -		disable_kernel_vsx();
>>> -		pagefault_enable();
>>> -		preempt_enable();
>>>  	}
>>> 
>>>  	return ret;
>>> diff --git a/drivers/crypto/vmx/aes_xts.c 
>>> b/drivers/crypto/vmx/aes_xts.c
>>> index 8bd9aff0f55f..e9954a7d4694 100644
>>> --- a/drivers/crypto/vmx/aes_xts.c
>>> +++ b/drivers/crypto/vmx/aes_xts.c
>>> @@ -116,32 +116,39 @@ static int p8_aes_xts_crypt(struct 
>>> blkcipher_desc *desc,
>>>  		ret = enc? crypto_skcipher_encrypt(req) : 
>>> crypto_skcipher_decrypt(req);
>>>  		skcipher_request_zero(req);
>>>  	} else {
>>> +		blkcipher_walk_init(&walk, dst, src, nbytes);
>>> +
>>> +		ret = blkcipher_walk_virt(desc, &walk);
>>> +
>>>  		preempt_disable();
>>>  		pagefault_disable();
>>>  		enable_kernel_vsx();
>>> 
>>> -		blkcipher_walk_init(&walk, dst, src, nbytes);
>>> -
>>> -		ret = blkcipher_walk_virt(desc, &walk);
>>>  		iv = walk.iv;
>>>  		memset(tweak, 0, AES_BLOCK_SIZE);
>>>  		aes_p8_encrypt(iv, tweak, &ctx->tweak_key);
>>> 
>>> +		disable_kernel_vsx();
>>> +		pagefault_enable();
>>> +		preempt_enable();
>>> +
>>>  		while ((nbytes = walk.nbytes)) {
>>> +			preempt_disable();
>>> +			pagefault_disable();
>>> +			enable_kernel_vsx();
>>>  			if (enc)
>>>  				aes_p8_xts_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
>>>  						nbytes & AES_BLOCK_MASK, &ctx->enc_key, NULL, tweak);
>>>  			else
>>>  				aes_p8_xts_decrypt(walk.src.virt.addr, walk.dst.virt.addr,
>>>  						nbytes & AES_BLOCK_MASK, &ctx->dec_key, NULL, tweak);
>>> +			disable_kernel_vsx();
>>> +			pagefault_enable();
>>> +			preempt_enable();
>>> 
>>>  			nbytes &= AES_BLOCK_SIZE - 1;
>>>  			ret = blkcipher_walk_done(desc, &walk, nbytes);
>>>  		}
>>> -
>>> -		disable_kernel_vsx();
>>> -		pagefault_enable();
>>> -		preempt_enable();
>>>  	}
>>>  	return ret;
>>>  }
>>> --
>>> 2.17.1
>>> 
> 
> Sure thing. I'll test it later today. Thanks Ondrej for the fix.

Looks good to me. I made some tests here and no problem was found.

-- 
Paulo Flabiano Smorigo
IBM Linux Technology Center

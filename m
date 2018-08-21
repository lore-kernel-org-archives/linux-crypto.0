From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: BUG: libkcapi tests trigger sleep-in-atomic bug in VMX code
 (ppc64)
Date: Tue, 21 Aug 2018 17:03:50 +0200
Message-ID: <708f0ba5-6ce2-19e6-1269-ea9a14090694@c-s.fr>
References: <CAAUqJDvErj0Y4=GBtXgvBRON7MEic7_-jBZNvjacwcOd0TF_2g@mail.gmail.com>
 <3627129.cWTIy1uDMC@tauon.chronox.de>
 <CAAUqJDt_y04ts7Aq0U0fhXYRus2ckkEohBTkga0pjqfoQaBOCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Paul Mackerras <paulus@samba.org>,
 linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 Stephan Mueller <smueller@chronox.de>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAAUqJDt_y04ts7Aq0U0fhXYRus2ckkEohBTkga0pjqfoQaBOCA@mail.gmail.com>
Content-Language: fr
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org



Le 21/08/2018 à 16:38, Ondrej Mosnáček a écrit :
> ut 21. 8. 2018 o 16:18 Stephan Mueller <smueller@chronox.de> napísal(a):
>> Am Dienstag, 21. August 2018, 14:48:11 CEST schrieb Ondrej Mosnáček:
>>
>> Hi Ondrej, Marcelo,
>>
>> (+Marcelo)
>>
>>> Looking at crypto/algif_skcipher.c, I can see that skcipher_recvmsg()
>>> holds the socket lock the whole time and yet passes
>>> CRYPTO_TFM_REQ_MAY_SLEEP to the cipher implementation. Isn't that
>>> wrong?
>>
>> I think you are referring to lock_sock(sk)?
>>
>> If so, this should not be the culprit: the socket lock is in essence a mutex-
>> like operation with its own wait queue that it allowed to sleep. In
>> lock_sock_nested that is called by lock_sock it even has the call of
>> might_sleep which indicates that the caller may be put to sleep.
>>
>> Looking into the code (without too much debugging) I see in the function
>> p8_aes_cbc_encrypt that is part of the stack trace the call to
>> preempt_disable() which starts an atomic context. The preempt_enable() is
>> invoked after the walk operation.
>>
>> The preempt_disable increases the preempt_count. That counter is used by
>> in_atomic() to check whether we are in atomic context.
>>
>> The issue is that blkcipher_walk_done may call crypto_yield() which then
>> invokes cond_resched if the implementation is allowed to sleep.
> 
> Indeed, you're right, the issue is actually in the vmx_crypto code. I
> remember having looked at the 'ctr(aes)' implementation in there a few
> days ago (I think I was trying to debug this very issue, but for some
> reason I only looked at ctr(aes)...) and I didn't find any bug, so
> that's why I jumped to suspecting the algif_skcipher code... I should
> have double-checked :)
> 
> It turns out the 'cbc(aes)' (and actually also 'xts(aes)')
> implementation is coded a bit differently and they both *do* contain
> the sleep-in-atomic bug. I will try to fix them according to the
> correct CTR implementation and send a patch.

CC: linuxppc-dev@lists.ozlabs.org <linuxppc-dev@lists.ozlabs.org>

> 
> Thanks,
> Ondrej
> 
>> @Marcelo: shouldn't be the sleep flag be cleared when entering the
>> preempt_disable section?
>>
>> Ciao
>> Stephan
>>
>>

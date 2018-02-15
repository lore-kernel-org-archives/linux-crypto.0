From: Harsh Jain <harsh@chelsio.com>
Subject: Re: [PATCH v3 1/4] crypto: AF_ALG AIO - lock context IV
Date: Thu, 15 Feb 2018 18:15:53 +0530
Message-ID: <a4a6d87e-4910-1718-a2a4-e7a5a4d12177@chelsio.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
 <2417115.3KYcYg1eVS@tauon.chronox.de>
 <558ccbb2-040d-232e-179b-92f0522f4bc2@chelsio.com>
 <1927702.eDKbX5ILji@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:24346 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030245AbeBOMqO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 07:46:14 -0500
In-Reply-To: <1927702.eDKbX5ILji@tauon.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 15-02-2018 17:15, Stephan Mueller wrote:
> Am Donnerstag, 15. Februar 2018, 12:38:12 CET schrieb Harsh Jain:
>
> Hi Harsh,
>
>> On 15-02-2018 12:47, Stephan Mueller wrote:
>>> Am Donnerstag, 15. Februar 2018, 08:03:20 CET schrieb Harsh Jain:
>>>
>>> Hi Harsh,
>>>
>>>> Even after guarantee of serialization, In the end we will get wrong
>>>> result
>>>> as mentioned above. which destination side cannot decrypt it. What I feel
>>>> is scenario of sending 2 of more IOCB in case of AEAD itself is wrong.
>>> Without the inline IV handling, I would concur.
>> Even with Inline IV, We will have 2 Auth Tag. can we authenticate the data
>> with 2 Auth Tags?
> The AAD and the tag are both sent to the kernel like in the inline IV case as 
> part of the data via sendmsg.
>
> Thus, when you use inline IV support, an entire self-contained AEAD cipher 
> operation can be defined with one IOCB. Thus, if you have multiple IOCBs, 
> inline IV allow fully parallel execution of different AEAD requests.
>
> See the following kernel comment:
>
>                 /*
>                  * Encryption operation - The in-place cipher operation is
>                  * achieved by the following operation:
>                  *
>                  * TX SGL: AAD || PT
>                  *          |      |
>                  *          | copy |
>                  *          v      v
>                  * RX SGL: AAD || PT || Tag
>
>                 /*
>                  * Decryption operation - To achieve an in-place cipher
>                  * operation, the following  SGL structure is used:
>                  *
>                  * TX SGL: AAD || CT || Tag
>                  *          |      |     ^
>                  *          | copy |     | Create SGL link.
>                  *          v      v     |
>                  * RX SGL: AAD || CT ----+
>                  */
>
> Note, the TX SGL is what the caller submitted via sendmsg and the RX SGL is 
> the data the caller obtains via recvmsg.
>
> Hence, in inline IV support, the caller sends the following:
>
> encryption: IV || AAD || PT
>
> decryption: IV || AAD || CT || Tag
>
>>>> We
>>>> should not allow this type of requests for AEAD.
>>> "Not allow" as in "technically block"? As a user would only shoot itself
>>> when he does that not knowing the consequences, I am not in favor of such
>>> an artificial block.
>> Agreed, It may not be right thing to do, but if we allowed it, What he will
>> do with Auth( each processed with final Block) tags received in each
>> request.
> Each tag is returned as part of the recvmsg data. Thus, AEAD cipher operations 
> can commence fully parallel if inline IV handling is used.
>> I personally feels AEAD IV serialization logic is incomplete without partial
>> tag support.
> Could you please elaborate what you mean with "partial tag" support?
Here is the catch, Calculation of tag depends on total payload length atleast for shaX, gcm,ccm mode on which I have worked.

If we take an example of shaX. It appends 1 special block at the end of user data which includes total input length in bit. Refer "sha1_base_do_finalize"
Suppose we have 32 byte and we break this in 2 IOCB of 16 bytes each.
Expected result : 32 encrypted bytes + sha auth tag considering length 32 bytes.
What we will  get : 16 bytes + sha auth tag considering length 16 bytes + 16 encrypted bytes + another sha tag considering 16 bytes.



>
> Ciao
> Stephan
>
>

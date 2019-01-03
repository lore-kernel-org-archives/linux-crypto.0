Return-Path: <SRS0=pN5v=PL=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:1680 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfACKr1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 05:47:27 -0500
Subject: Re: IPSec ESN: Packets decryption fail with ESN enabled connection
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: steffen.klassert@secunet.com, davem@davemloft.net,
        netdev@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        atul.gupta@chelsio.com, harshjain.prof@gmail.com
References: <93ad9333-1e77-58fc-3f47-a967294fe188@chelsio.com>
 <f1a91df3-c191-7ce1-1721-c94ca4322aa9@chelsio.com>
 <20190102125109.az6n4rr4m2hng6d6@gondor.apana.org.au>
From: Harsh Jain <harsh@chelsio.com>
Message-ID: <692a865e-1903-bff8-a8f4-aface07a96ac@chelsio.com>
Date: Thu, 3 Jan 2019 16:16:56 +0530
MIME-Version: 1.0
In-Reply-To: <20190102125109.az6n4rr4m2hng6d6@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 02-01-2019 18:21, Herbert Xu wrote:
> On Wed, Dec 26, 2018 at 03:16:29PM +0530, Harsh Jain wrote:
>> +linux-crypto
>>
>> On 26-12-2018 14:54, Harsh Jain wrote:
>>> Hi All,
>>>
>>> Kernel version on both machines: 4.19.7.
>>>
>>> Packet drops with EBADMSG is observed on receive end of connection. It seems that sometimes crypto driver receives packet with wrong "seq_hi" value in AAD. See below the dump of assoc data for 1 such instance.
>>>
>>> [  380.823454] assoclen 8th byte 1 clen 1464 op 1  ==> High byte of ESN
>>> [  380.828398] authsize 12 cryptlen 1464
>>> [  380.832637] dt00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 ==> Decrypted data seems correct,last byte is proto(06 TCP)
>>> [  380.840215] dt00000010: bf ee 4f 80 a4 7f 2a 50 6a 5a 0b 10
>>> [  380.846636] ass00000000: 0a bc d3 31 <00 00 00 01> 00 1c e5 ec 0e af 04 69 ==> ESN-Hi = 1
>>> [  380.854316] ass00000010: a4 fc 08 ad
>>>
>>> Note: If I decrypt the same packet with ESN - Hi = 0. It Decrypt successfully means peer machine has used ESN-HI = 0 while encrypting.
>>>
>>> To debug further we added trace in "xfrm_replay_seqhi". Following was the output:
>>>
>>>  <idle>-0     [003] ..s.   380.967766: xfrm_replay_seqhi: seq_hi 0x 1 seq 0x 1ce5ec bottom 0x 1ce5ee replay seq 0x 1ce62d replay window 0x 40
>>>
>>> 1) Is this an expected variable with ESN enables connection?.
>>>
>>> 2) If packets are supposed to be dropped can't we avoid decryption overhead.
>>>
>>> Following logs are attached
>>>
>>> 1) dmesg log
>>>
>>> 2) debug patch used to reproduce the issue.
>>>
>>> 3) ftace log file
>>>
>>> 4) ip xfrm state list
> Does this occur if you use software crypto on the receiving end
> while keeping the sending end unchanged?

I tried with "authencesn(hmac(sha1-ssse3),cbc(aes-asm))" on both sides.

Server : iperf  -s  -w 512k  -p 20002

Client : iperf  -t 60 -w 512k -l 2048 -c 1.0.0.96 -P 32 -p 20002

>
> If not then I would start debugging this within your driver.

ESP Packet whose's sequence No. is out of window gets dropped with EBADMSG.  It seems that "xfrm_replay_seqhi" intentionally increments the "seq_hi" to fail verification for Out of seq packet.

>
> Thanks,

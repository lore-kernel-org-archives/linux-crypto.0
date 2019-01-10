Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:17748 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfAJFgg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 00:36:36 -0500
Subject: Re: IPSec ESN: Packets decryption fail with ESN enabled connection
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        atul.gupta@chelsio.com, harshjain.prof@gmail.com
References: <93ad9333-1e77-58fc-3f47-a967294fe188@chelsio.com>
 <f1a91df3-c191-7ce1-1721-c94ca4322aa9@chelsio.com>
 <20190102125109.az6n4rr4m2hng6d6@gondor.apana.org.au>
 <692a865e-1903-bff8-a8f4-aface07a96ac@chelsio.com>
 <20190104083419.GG3581@gauss3.secunet.de>
From: Harsh Jain <harsh@chelsio.com>
Message-ID: <cb10516d-3d18-57d9-714f-6540aacbe450@chelsio.com>
Date: Thu, 10 Jan 2019 11:06:21 +0530
MIME-Version: 1.0
In-Reply-To: <20190104083419.GG3581@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 04-01-2019 14:04, Steffen Klassert wrote:
> On Thu, Jan 03, 2019 at 04:16:56PM +0530, Harsh Jain wrote:
>> On 02-01-2019 18:21, Herbert Xu wrote:
>>> Does this occur if you use software crypto on the receiving end
>>> while keeping the sending end unchanged?
>> I tried with "authencesn(hmac(sha1-ssse3),cbc(aes-asm))" on both sides.
>>
>> Server : iperf  -s  -w 512k  -p 20002
>>
>> Client : iperf  -t 60 -w 512k -l 2048 -c 1.0.0.96 -P 32 -p 20002
>>
>>> If not then I would start debugging this within your driver.
>> ESP Packet whose's sequence No. is out of window gets dropped with EBADMSG.  It seems that "xfrm_replay_seqhi" intentionally increments the "seq_hi" to fail verification for Out of seq packet.
> Yes, this is defined in RFC 4303 Appendix A2.2.

Thanks, It means we cannot avoid verification part for packets with low seql.

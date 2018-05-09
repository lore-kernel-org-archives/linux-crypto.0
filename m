From: Atul Gupta <atul.gupta@chelsio.com>
Subject: Re: [PATCH v15 net-next 00/12] Chelsio Inline TLS
Date: Wed, 9 May 2018 17:45:58 +0530
Message-ID: <72c25ff5-0849-b457-5f78-dade937805c9@chelsio.com>
References: <1522512723-31747-1-git-send-email-atul.gupta@chelsio.com>
 <20180331.233753.2141475779224683361.davem@davemloft.net>
 <ee9bfb6a-887b-a0fb-8880-dc709a217b50@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davejwatson@fb.com,
        sd@queasysnail.net, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: Boris Pismenny <borisp@mellanox.com>,
        David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <ee9bfb6a-887b-a0fb-8880-dc709a217b50@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 4/1/2018 6:27 PM, Boris Pismenny wrote:
> Hi,
>
> On 4/1/2018 6:37 AM, David Miller wrote:
>> From: Atul Gupta <atul.gupta@chelsio.com>
>> Date: Sat, 31 Mar 2018 21:41:51 +0530
>>
>>> Series for Chelsio Inline TLS driver (chtls)
>>
>> Series applied, thank you.
>>
>
> Sorry for being late to the party, could you please help answer a few questions to help me understand better.
Going over these points and addressing some of them in follow-up patches:
>
> 1. What happens if someone attempts to set a TCP socket option for a socket whose TCP stack resides in the TCP offload engine(TOE)? Do you emulate all Linux socket options? What about IP socket options?
HW offloaded options are handled while rest shall be redirected to host.
>
> If I follow the code correctly, then the original TCP/IP setsockopt is called. But, it doesn't change any of the parameters of the TCP/IP offload engine in hardware.
>
> 2. I can't find where is the TLS record sequence number pushed to hardware. Is that on purpose?
seq-nos is pushed to HW in cpl_tx_tls_sfo->scmd1
>
> FYI, ignoring this parameter might cause a record sequence number reuse which breaks the integrity of the AES-GCM TLS ciphersuite.
>
> 3. How does a TOE handle Tx only or Rx only?
Driver does not differentiate/isolate the tx and rx path for Inline Processing
>
> 4. What happens when there is a routing change that redirects traffic to a different netdev? Is there a software fallback?
The case we think is handling the next hop change, is there any other case?
>
> 5. The TLS socket option is set in the middle of a TCP connection. What happens to the existing TCP connection and the data that is currently queued in the TCP write queue?
I believe this behave same as SW. If by TLS options you mean re-keying then outstanding data on Tx is flushed before new key takes effect. For Rx user should be careful else it will result in MAC error.

Thanks
Atul
>
> Thanks,
> Boris.
>

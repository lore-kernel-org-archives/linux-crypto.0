From: Boris Pismenny <borisp@mellanox.com>
Subject: Re: [PATCH v15 net-next 00/12] Chelsio Inline TLS
Date: Sun, 1 Apr 2018 15:57:50 +0300
Message-ID: <ee9bfb6a-887b-a0fb-8880-dc709a217b50@mellanox.com>
References: <1522512723-31747-1-git-send-email-atul.gupta@chelsio.com>
 <20180331.233753.2141475779224683361.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davejwatson@fb.com,
        sd@queasysnail.net, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: David Miller <davem@davemloft.net>, atul.gupta@chelsio.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180331.233753.2141475779224683361.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On 4/1/2018 6:37 AM, David Miller wrote:
> From: Atul Gupta <atul.gupta@chelsio.com>
> Date: Sat, 31 Mar 2018 21:41:51 +0530
> 
>> Series for Chelsio Inline TLS driver (chtls)
> 
> Series applied, thank you.
> 

Sorry for being late to the party, could you please help answer a few 
questions to help me understand better.

1. What happens if someone attempts to set a TCP socket option for a 
socket whose TCP stack resides in the TCP offload engine(TOE)? Do you 
emulate all Linux socket options? What about IP socket options?

If I follow the code correctly, then the original TCP/IP setsockopt is 
called. But, it doesn't change any of the parameters of the TCP/IP 
offload engine in hardware.

2. I can't find where is the TLS record sequence number pushed to 
hardware. Is that on purpose?

FYI, ignoring this parameter might cause a record sequence number reuse 
which breaks the integrity of the AES-GCM TLS ciphersuite.

3. How does a TOE handle Tx only or Rx only?

4. What happens when there is a routing change that redirects traffic to 
a different netdev? Is there a software fallback?

5. The TLS socket option is set in the middle of a TCP connection. What 
happens to the existing TCP connection and the data that is currently 
queued in the TCP write queue?

Thanks,
Boris.

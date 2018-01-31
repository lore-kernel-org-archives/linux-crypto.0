From: Atul Gupta <atul.gupta@chelsio.com>
Subject: Re: [RFC crypto v3 8/9] chtls: Register the ULP
Date: Wed, 31 Jan 2018 16:14:55 +0530
Message-ID: <9e81c5b4-f319-8b33-5dec-dad19582bde4@chelsio.com>
References: <20180125210850.GA69117@davejwatson-mba>
 <CY4PR1201MB0230C0D2D0F24900A084574D97E60@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <CY4PR1201MB0230042A4D0EA83DC8F1BE7397E40@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <20180130171144.GA42146@davejwatson-mba>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "sd@queasysnail.net" <sd@queasysnail.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ganeshgr@chelsio.co" <ganeshgr@chelsio.co>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Dave Watson <davejwatson@fb.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180130171144.GA42146@davejwatson-mba>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Tuesday 30 January 2018 10:41 PM, Dave Watson wrote:
> On 01/30/18 06:51 AM, Atul Gupta wrote:
>
>> What I was referring is that passing "tls" ulp type in setsockopt
>> may be insufficient to make the decision when multi HW assist Inline
>> TLS solution exists.
> Setting the ULP doesn't choose HW or SW implementation, I think that
> should be done later when setting up crypto with
>
> setsockopt(SOL_TLS, TLS_TX, struct crypto_info).
setsockpot [mentioned above] is quite late for driver to enable HW 
implementation, we require something as early as tls_init 
[setsockopt(sock, SOL_TCP, TCP_ULP, "tls", sizeof("tls"))], for driver 
to set HW prot and offload connection beside Inline Tx/Rx.
>
> Any reason we can't use ethtool to choose HW vs SW implementation, if
> available on the device?
Thought about it,  the interface index is not available to fetch netdev 
and caps check to set HW prot eg. bind [prot.hash] --> tls_hash to 
program HW.
>
>> Some HW may go beyond defining sendmsg/sendpage of the prot and
>> require additional info to setup the env? Also, we need to keep
>> vendor specific code out of tls_main.c i.e anything other than
>> base/sw_tx prot perhaps go to hw driver.
> Sure, but I think we can add hooks to tls_main to do this without a
> new ULP.
Current code calls update_sk_prot for TLS_BASE_TX and TLS_SW_TX, future 
Inline TLS assist HWs will add TLS_HW_TX, TLS_OFLD, ... etc additional 
hooks to update sk prots can make code confusing?

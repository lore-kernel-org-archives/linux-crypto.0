From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: qat - fix resource release omissions
Date: Tue, 13 Sep 2016 14:56:26 +0200
Message-ID: <878bddf5-9561-a2e9-7f97-323f11a13d54@gmail.com>
References: <20160902144753.31334-1-lambert.quentin@gmail.com>
 <20160902144753.31334-3-lambert.quentin@gmail.com>
 <20160906101851.GA27032@sivswdev01.ir.intel.com>
 <20160913124006.GB31835@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, giovanni.cabiddu@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913124006.GB31835@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 13/09/2016 14:40, Herbert Xu wrote:
> On Tue, Sep 06, 2016 at 11:18:51AM +0100, Giovanni Cabiddu wrote:
>> ---8<---
>> Subject: [PATCH] crypto: qat - fix leak on error path
>>
>> Fix a memory leak in an error path in uc loader.
>>
>> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Patch applied.  Thanks.
Sorry, I completly missed Giovanni's message. Good work!

Quentin

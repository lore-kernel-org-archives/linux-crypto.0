From: Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH 14/14] x86/crypto: aesni: Update aesni-intel_glue to use
 scatter/gather
Date: Tue, 13 Feb 2018 11:49:49 -0800
Message-ID: <188ad18b-adb1-714c-0327-acfca77a145b@google.com>
References: <cover.1518211765.git.davejwatson@fb.com>
 <20180212195128.GA61087@davejwatson-mba.local>
 <dc69bdfa-6dc2-da54-9d9a-b171aeb3212b@google.com>
 <20180213182203.GA2122@davejwatson-mba.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        linux-kernel@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Dave Watson <davejwatson@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180213182203.GA2122@davejwatson-mba.local>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[Resending after delivery failure]

Hi Dave,

On 02/13/2018 10:22 AM, Dave Watson wrote:
>
> Yes, these both sound reasonable.  I will send a V2.
>
> Thanks!

Another minor suggestion for v2:

It might be a good idea to check if the first assoclen bytes are already contiguous and only do the kmalloc if that isn't the case.

Thanks,
Junaid

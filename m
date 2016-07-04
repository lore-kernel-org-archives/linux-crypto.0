From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv2 06/27] crypto: ahash: increase the maximum allowed
 statesize
Date: Mon, 4 Jul 2016 12:17:02 +0300
Message-ID: <577A298E.4040803@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
 <1466601840-18486-7-git-send-email-t-kristo@ti.com>
 <20160624103209.GA19607@gondor.apana.org.au> <5770B283.8000902@ti.com>
 <20160627050031.GA5673@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: tony@atomide.com, lokeshvutla@ti.com, linux-crypto@vger.kernel.org,
 linux-omap@vger.kernel.org, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20160627050031.GA5673@gondor.apana.org.au>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 27/06/16 08:00, Herbert Xu wrote:
> On Mon, Jun 27, 2016 at 07:58:43AM +0300, Tero Kristo wrote:
>>
>> Ok, I think I need to allocate the storage space locally then within
>> the driver. Would it be ok to call kmalloc / free in the export /
>> import implementation of the driver? The size of the unhashed buffer
>> in omap-sham is unfortunately rather large.
>
> The allocation should usually be done from the request_alloc
> function, i.e., you set the reqsize and the user does the allocation
> for you.

I need some clarification on this, afaik request_alloc related 
functionality only works per-request basis. The export / import 
functionality however is supposed to work across multiple requests. The 
test code for example does this:


         ret = crypto_ahash_export(req, state);
...
         ahash_request_free(req);

         req = ahash_request_alloc(tfm, GFP_KERNEL);
...
         ret = crypto_ahash_import(req, state);


... which means if I attempt to allocate extra space for the export 
buffer within the first request, it is not available at the import time 
anymore.

Is there any limitation how many simultaneous exports can be done from a 
driver? I was wondering if I can allocate a single export buffer for the 
whole driver.

-Tero

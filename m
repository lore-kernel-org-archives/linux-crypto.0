From: "Li, Weigang" <weigang.li@intel.com>
Subject: RE: [PATCH] crypto: add asynchronous compression support
Date: Thu, 19 Nov 2015 05:52:41 +0000
Message-ID: <929511EA6367314D8E32364A24D45FA61301F63F@shsmsx102.ccr.corp.intel.com>
References: <1445008260-39367-1-git-send-email-weigang.li@intel.com>
 <20151016151354.GA16648@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Struk, Tadeusz" <tadeusz.struk@intel.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57958 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbbKSFwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Nov 2015 00:52:45 -0500
In-Reply-To: <20151016151354.GA16648@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/16/2015 11:13 PM, Herbert Xu wrote:
> On Fri, Oct 16, 2015 at 11:11:00PM +0800, Weigang Li wrote:
>> This patch set introduces Asynchronous Compression API.
>> What is proposed is a new crypto type called crypto_acomp_type,
>> plus new struct acomp_alg and struct crypto_acomp, together with number
>> of helper functions to register acomp type algorithms and allocate tfm
>> instances. This is to make it similar to how the existing crypto API
>> works for the ablkcipher, and akcipher types.
>> The operations the new interface will provide are:
>>
>> 	int (*compress)(struct acompress_request *req);
>> 	int (*decompress)(struct acompress_request *req);
>>
>> The benefits it gives interface are:
>> - the new interface allows for asynchronous implementations and
>>    scatterlist buffer that can use hardware to offload the compression
>>    operations, the new asynchronous API can be called by the linux kernel
>>    components (i.e., btrfs) who want to use hardware acceleration for data
>>    compression.
>>
>> New helper functions have been added to allocate crypto_acomp instances
>> and invoke the operations to make it easier to use.
>>
>> Signed-off-by: Weigang Li <weigang.li@intel.com>
> 
> Thanks for the patch! Joonsoo Kim is also working on the compression
> interface for zram.  Could you two collaborate and come up with one
> interface rather than two?
> 
> Cheers,
> 
Hello Herbert,

After sync-up with Joonsoo Kim, we think it may be not feasible for a s/w implementation of the sg-list based asynchronous interface, we propose separate interfaces (patches) for acomp & ccomp. The reasons are:
1. to support sg-list in the ccomp (like what shash/ahash did), the partial update is required, some algorithms do not support partial update (i.e., lzo), that means:
2. the format of output buffer (sg-list) will be different, e.g., the lzo need contain the "length" info for each block in the output sg-list in order to de-compression, while zlib doesn't need, then it is difficult to have a single async sg-list i/f.
3. to compress a sg-list buffer, the lzo also requires an intermediate buffer to save the output of a block, and copy it back to the sg-list output buffer, it will introduce the complexity and cost, we don't see value for sg-list support in a s/w compression.

Any suggestions?

From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v3 2/2] crypto: akcipher - Changes to asymmetric key API
Date: Thu, 1 Oct 2015 08:17:49 -0700
Message-ID: <560D4E9D.1060502@intel.com>
References: <20150922163352.18101.85685.stgit@tstruk-mobl1>
 <20150922163403.18101.92452.stgit@tstruk-mobl1>
 <20151001134536.GA27555@gondor.apana.org.au> <560D48B0.8090502@intel.com>
 <20151001151519.GA28373@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4863 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403AbbJAPUC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 11:20:02 -0400
In-Reply-To: <20151001151519.GA28373@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/01/2015 08:15 AM, Herbert Xu wrote:
> On Thu, Oct 01, 2015 at 07:52:32AM -0700, Tadeusz Struk wrote:
>> On 10/01/2015 06:45 AM, Herbert Xu wrote:
>>> On Tue, Sep 22, 2015 at 09:34:03AM -0700, Tadeusz Struk wrote:
>>>>
>>>>  struct akcipher_request {
>>>>  	struct crypto_async_request base;
>>>> -	void *src;
>>>> -	void *dst;
>>>> -	unsigned int src_len;
>>>> -	unsigned int dst_len;
>>>> +	struct scatterlist *src;
>>>> +	struct scatterlist *dst;
>>>> +	unsigned int out_len;
>>>
>>> I think src_len/dst_len should be kept as the SG list may contain
>>> more entries than the ones that you need to process.
>>>
>> Herbert,
>> Could you still apply it and the "Add mpi sgl helpers" on top
>> and I'll add the src_len/dst_len in an incremental patch?
>> It will make it easier for me.
> 
> Well I don't think we need out_len with dst_len being there so
> this would be adding and then removing out_len for no good reason.
> 

Technically it would be renaming instead of adding and then removing :)

From: Dave Watson <davejwatson@fb.com>
Subject: Re: [PATCHv2] tls: Add support for encryption using async offload
 accelerator
Date: Wed, 31 Jan 2018 07:22:28 -0800
Message-ID: <20180131152228.GA24247@davejwatson-mba>
References: <20180131160437.6583-1-vakul.garg@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <linux-crypto@vger.kernel.org>, <ilyal@mellanox.com>,
        <aviadye@mellanox.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Gilad Ben-Yossef <gilad@benyossef.com>
To: Vakul Garg <vakul.garg@nxp.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180131160437.6583-1-vakul.garg@nxp.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/31/18 09:34 PM, Vakul Garg wrote:
> Async crypto accelerators (e.g. drivers/crypto/caam) support offloading
> GCM operation. If they are enabled, crypto_aead_encrypt() return error
> code -EINPROGRESS. In this case tls_do_encryption() needs to wait on a
> completion till the time the response for crypto offload request is
> received.

Comments from V1
> On Wed, Jan 31, 2018 at 8:10 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>> Hi Vakul,
>>
>> On Wed, Jan 31, 2018 at 12:36 PM, Vakul Garg <vakul.garg@nxp.com> wrote:
>>> Async crypto accelerators (e.g. drivers/crypto/caam) support offloading
>>> GCM operation. If they are enabled, crypto_aead_encrypt() return error
>>> code -EINPROGRESS. In this case tls_do_encryption() needs to wait on a
>>> completion till the time the response for crypto offload request is
>>> received.
>>>
>>
>> Thank you for this patch. I think it is actually a bug fix and should
>> probably go into stable
>
> On second though in stable we should probably just disable async tfm
> allocations.
> It's simpler. But this approach is still good for -next
>
>
> Gilad

I agree with Gilad, just disable async for now. 

If the flag MSG_DONTWAIT is set, we should be returning -EINPROGRESS
and not wait for a response.  I had started working on a patch for
that, but it's pretty tricky to get right.

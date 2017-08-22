From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix XTS-AES-128 support on v5 CCPs
Date: Tue, 22 Aug 2017 13:24:16 -0500
Message-ID: <9aaee2ee-93c7-556b-1199-344822397f14@amd.com>
References: <150032210775.102848.1585950131204303137.stgit@sosxen.amd.com>
 <14a02623-b19e-b4ae-c078-57912a83cd4b@amd.com>
 <f5714d71-4e4a-b942-7e1e-58f478a5ff21@amd.com>
 <32d0b50e-e5d5-6041-0ee9-f8384c7c79a3@amd.com>
 <20170819040226.GB29641@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0078.outbound.protection.outlook.com ([104.47.42.78]:57538
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751807AbdHVSY2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 14:24:28 -0400
In-Reply-To: <20170819040226.GB29641@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/18/2017 11:02 PM, Herbert Xu wrote:
> On Fri, Aug 18, 2017 at 11:41:04AM -0500, Gary R Hook wrote:
>>> On Tue, Jul 25, 2017 at 02:12:11PM -0500, Gary R Hook wrote:
>>>> Version 5 CCPs have some new requirements for XTS-AES: the type field
>>>> must be specified, and the key requires 512 bits, with each part
>>>> occupying 256 bits and padded with zeroes.
>>>>
>>>> cc: <stable@vger.kernel.org> # 4.9.x+
>>>>
>>>> Signed-off-by: Gary R Hook <ghook@amd.com>
>>>
>>> Patch applied.  Thanks.
>>
>> Herbert,
>>
>> *ping*
>>
>> This is a bug fix, Could we push this into 4.13, please?
>
> I don't think this one is critical enough to go in right now.
> Is there any reason why it can't wait until the next merge window?

I am happy to defer to your expertise in this area. My concern was
whether the patch had been overlooked. I see now that it had not.

Thank you, sir.

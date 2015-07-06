From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH 10/10] crypto: tcrypt: Added speed tests for Async AEAD
 crypto alogrithms
Date: Mon, 6 Jul 2015 14:15:06 +0530
Message-ID: <559A4012.8070407@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com> <1435814320-30347-11-git-send-email-lokeshvutla@ti.com> <20150706074403.GE20192@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
	<linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150706074403.GE20192@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,
On Monday 06 July 2015 01:14 PM, Herbert Xu wrote:
> On Thu, Jul 02, 2015 at 10:48:40AM +0530, Lokesh Vutla wrote:
>> Adding simple speed tests for a range of block sizes for Async AEAD crypto
>> algorithms.
>>
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> 
> What's wrong with the existing AEAD speed tests?
> 
The existing AEAD test case does not do a wait_for_completion(), when
the return value is EINPROGRESS or EBUSY like it is done for acipher_speed tests.

Can I be updating the same test case for handling this?
Correct me if I am wrong.

Thanks and regards,
Lokesh

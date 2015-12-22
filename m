From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 1/2] crypto: KEYS: convert public key to the akcipher
 api
Date: Tue, 22 Dec 2015 06:23:59 -0800
Message-ID: <56795CFF.1080106@intel.com>
References: <201512200735.x3U85zQL%fengguang.wu@intel.com>
 <5678684F.2020308@gmail.com> <20151222120919.GA25163@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tstruk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:26098 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbbLVO11 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Dec 2015 09:27:27 -0500
In-Reply-To: <20151222120919.GA25163@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert
On 12/22/2015 04:09 AM, Herbert Xu wrote:
> On Mon, Dec 21, 2015 at 12:59:59PM -0800, Tadeusz Struk wrote:
>>
>> The previous patch was broken, re-sending again, sorry.
>>
>> I think there is something missing in this configuration.
>> cat .config | grep KEXEC_BZIMAGE_VERIFY_SIG gives nothing.
>> Anyways, this patch should fix it.
> 
> No this is unacceptable.  Please fix it properly by making the
> header file self-contained, e.g., by using a forward declaration.

What about the first two. This one is completely unrelated.
It only supposed to fix some random configuration issue
reported by a build robot, which isn't really important now.
The other two convert the module verifier to the new API.
Thanks,
-- 
TS

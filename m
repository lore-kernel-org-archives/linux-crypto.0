From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: Problem with RSA test from testmgr
Date: Thu, 2 Mar 2017 08:26:24 -0800
Message-ID: <3cc00e47-6076-51db-06d0-771af799984a@intel.com>
References: <20170228155953.GA1732@Red> <20170301120414.GA18217@Red>
 <122aa2a3-e478-1a68-083a-273ceabaf2fb@intel.com>
 <3589679.E0B746otbi@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:57805 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751229AbdCBQ3H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 11:29:07 -0500
In-Reply-To: <3589679.E0B746otbi@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 03/01/2017 10:08 PM, Stephan Müller wrote:
>> 	memset(ptextp, 0, 256);
>> 	memcpy(ptextp + 64 - 8, ptext_ex, plen);
> I actually have tested that and it did not return the data the kernel 
> implementation would return

It did for me:
Result 64 plen=8
63 1c cd 7b e1 7e e4 de c9 a8 89 a1 74 cb 3c 63 7d 24 ec 83 c3 15 e4 7f 73 05 34 d1 ec 22 bb 8a 5e 32 39 6d c1 1d 7d 50 3b 9f 7a ad f0 2e 25 53 9f 6e bd 4c 55 84 0c 9b cf 1a 4b 51 1e 9e 0c 06

Are you sure you are compering this with the fist test vector?
http://lxr.free-electrons.com/source/crypto/testmgr.h#L183

Thanks,
-- 
Tadeusz

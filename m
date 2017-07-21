From: Gary R Hook <gary.hook@amd.com>
Subject: Re: Poor RNG performance on Ryzen
Date: Fri, 21 Jul 2017 10:04:16 -0500
Message-ID: <842a138e-ff8f-4a2a-0bbe-3e419b008d65@amd.com>
References: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
 <20170721092656.GA18604@wintermute>
 <09c9be2b-8b4d-ee06-8071-4f748fdb5970@gmail.com>
 <20170721144741.4igkvsd2fowptsy2@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, Oliver Mangold <o.mangold@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0068.outbound.protection.outlook.com ([104.47.38.68]:25376
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750849AbdGUPEv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 11:04:51 -0400
In-Reply-To: <20170721144741.4igkvsd2fowptsy2@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/21/2017 09:47 AM, Theodore Ts'o wrote:
> On Fri, Jul 21, 2017 at 01:39:13PM +0200, Oliver Mangold wrote:
>> Better, but obviously there is still much room for improvement by reducing
>> the number of calls to RDRAND.
>
> Hmm, is there some way we can easily tell we are running on Ryzen?  Or
> do we believe this is going to be true for all AMD devices?
>
> I guess we could add some kind of "has_crappy_arch_get_random()" call
> which could be defined by arch/x86, and change how aggressively we use
> arch_get_random_*() depending on whether has_crappy_arch_get_random()
> returns true or not....

Just a quick note to say that we are aware of the issue, and that it is
being addressed.

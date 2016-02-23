From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Tue, 23 Feb 2016 16:21:49 -0500
Message-ID: <56CCCD6D.3040506@oracle.com>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz> <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de> <56C9E865.3050500@gmail.com>
 <56CCC8D3.8040001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <w@1wt.eu>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Ondrej Kozina <okozina@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Milan Broz <gmazyland@gmail.com>, "Thomas D." <whissi@whissi.de>,
	Jiri Slaby <jslaby@suse.cz>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38681 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbcBWVWc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Feb 2016 16:22:32 -0500
In-Reply-To: <56CCC8D3.8040001@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/23/2016 04:02 PM, Milan Broz wrote:
> On 02/21/2016 05:40 PM, Milan Broz wrote:
>> > On 02/20/2016 03:33 PM, Thomas D. wrote:
>>> >> Hi,
>>> >>
>>> >> FYI: v3.10.97, v3.14.61 and 3.18.27 are also affected.
>>> >>
>>> >> v4.3.6 works. Looks like the patch set is only compatible with >=linux-4.3.
>>> >>
>>> >> v3.12.54 works because it doesn't contain the patch in question.
>> > 
>> > Hi,
>> > 
>> > indeed, because whoever backported this patchset skipped two patches
>> > from series (because of skcipher interface file was introduced later).
> Ping?
> 
> I always thought that breaking userspace is not the way mainline kernel
> operates and here we break even stable tree...
> 
> Anyone planning to release new kernel version with properly backported patches?
> There is already a lot of downstream distro bugs reported.

Hi Milan,

I'd really like to see an ack on your patch by one of the crypto/ maintainers
before putting it into a -stable release.


Thanks,
Sasha

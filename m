From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Mon, 18 Apr 2016 17:03:38 -0400
Message-ID: <57154BAA.9050705@oracle.com>
References: <56C5A66E.5010905@whissi.de> <56C87929.8040304@whissi.de>
 <56C9E865.3050500@gmail.com> <56CD6AB6.7000801@suse.cz>
 <56CD6FD8.20004@gmail.com> <20160224171203.GE16597@kroah.com>
 <56D0361B.8040301@gmail.com> <56D080AA.7030307@oracle.com>
 <7210213c-7446-5181-c2b2-8d7aaa756a2a@whissi.de>
 <57141096.1000802@oracle.com> <20160418020230.GA16179@gondor.apana.org.au>
 <8cf2e39f-003a-3af8-2666-bbaf43035995@whissi.de>
 <5714D917.7020006@oracle.com> <57154680.7070304@gmail.com>
 <e0e49a4b-85d4-9266-d41b-64847d47f4bc@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>,
	Stephan Mueller <smueller@chronox.de>,
	Willy Tarreau <w@1wt.eu>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ondrej Kozina <okozina@redhat.com>
To: "Thomas D." <whissi@whissi.de>, Milan Broz <gmazyland@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26218 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbcDRVEg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 17:04:36 -0400
In-Reply-To: <e0e49a4b-85d4-9266-d41b-64847d47f4bc@whissi.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/18/2016 04:56 PM, Thomas D. wrote:
> Hi,
> 
> Milan Broz wrote:
>> could you please try backported patches here
>> https://mbroz.fedorapeople.org/tmp/3.18/ ?
> 
> This patch set works for me and fixes my reported problem (tested
> against 3.18.30).
> 
> Thank you!

Excellent, I'll add this in and release. Thank you both.

Sorry for missing it on my end.


Thanks,
Sasha

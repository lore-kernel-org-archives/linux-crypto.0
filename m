From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH v2 2/2] crypto: qat - Enforce valid numa configuration
Date: Tue, 14 Oct 2014 13:32:56 -0400
Message-ID: <543D5E48.80103@redhat.com>
References: <20141014012251.742.5500.stgit@tstruk-mobl1> <20141014012432.742.24559.stgit@tstruk-mobl1> <543D00C3.9000208@redhat.com> <543D381B.9080609@intel.com> <543D441D.5090301@redhat.com> <543D5AD4.1090809@intel.com> <543D5CFF.20804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, naleksan@redhat.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	Larry Woodman <lwoodman@redhat.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbaJNRf3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Oct 2014 13:35:29 -0400
In-Reply-To: <543D5CFF.20804@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/14/2014 01:27 PM, Prarit Bhargava wrote:
> 
> 
> On 10/14/2014 01:18 PM, Tadeusz Struk wrote:
>> On 10/14/2014 08:41 AM, Prarit Bhargava wrote:
>>> Oh, that's a really good point.  But can you at least change the message to do a
>>> FW_BUG and dump the node information?  That would be useful for debugging.
>>
>> But this not always will be a FW_BUG. If a user will not populate one of
>> the nodes with memory this will happen as well. 
> 
> Hmmm ... let's maybe think about this.  I wonder if there is some mechanism with
> which we can determine that?  Larry Woodman -- is there any mm related call that
> we can make to determine if a node is memory-less?
> 
> I could see this to be
>> the main reason of this message to be printed. In this case
>> num_possible_nodes() will be e.g. 2 and dev_to_node(&pdev->dev) will be
>> -1 so I don't really know what will be a useful info to print so we
>> don't confuse the user.
> 
> If you see -1, it means "No node was assigned" ... so -1 in a debug message is
> okay IMO.

Never mind -- I'm not thinking straight after a long weekend :)  This is all
okay.  The message above will only print iff node < 0, ie) -1.

So I'll ack shortly.

P.

> 
> P.
> 
>> T
>>

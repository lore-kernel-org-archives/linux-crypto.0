From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 1/4] PPC4xx: Generalizing ADMA driver modifications
Date: Thu, 23 Sep 2010 15:51:45 -0700
Message-ID: <4C9BDA01.2060001@intel.com>
References: <1285279839-16588-1-git-send-email-tmarri@apm.com> <4C9BD6DC.3070707@intel.com> <fe45b421a909d749a6cf583426a1ce6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"yur@emcraft.com" <yur@emcraft.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>
To: Tirumala Marri <tmarri@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4405 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab0IWWvr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Sep 2010 18:51:47 -0400
In-Reply-To: <fe45b421a909d749a6cf583426a1ce6d@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/23/2010 3:44 PM, Tirumala Marri wrote:
>>
>> Did you look at this changelog before sending?  It just deletes 4000
>> lines of code??
> [Marri] The reason I have to send it in different file is the size of the
> patch.
> There seem to be issue with patch sizes 200k or more.

Read the rest of what I wrote:

> Moving and renaming code in one patch makes it very difficult to verify
> the result.  When generalizing code the first thing I want to see with a
> very quick glance at the patch(es) is that the existing implementation
> is not harmed.  One way to go about this is to first identify the
> portions of existing code that you want to reuse in your driver and the
> pieces that are truly ppc440spe specific.  Move the ppc440spe pieces to
> their own file (get this reviewed and approved by the ppc440spe
> authors).  The remaining code in adma.c will be assumed generic.  You
> can then have another patch to do a simple s/ppc440spe/ppc4xx/ in adma.c
> (no other logic changes or code movement).  Then you can introduce your
> ppc460ex unique implementation that calls into adma.c.

The patch would not be so large if you leave the existing code where it 
is and move the implementation specific pieces to their own file.

--
Dan

From: "Wang, Shane" <shane.wang@intel.com>
Subject: RE: [RFC PATCH v2] Add VMAC(AES) to Linux for intel_txt support
Date: Fri, 14 Aug 2009 16:32:57 +0800
Message-ID: <037F493892196B458CD3E193E8EBAD4F01EAB64820@pdsmsx502.ccr.corp.intel.com>
References: <4A5F41C4.3050808@intel.com> <4A5F431B.6060307@intel.com>
 <4A805375.4030902@intel.com> <20090814032201.GA2544@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Cihula, Joseph" <joseph.cihula@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40243 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZHNIeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2009 04:34:50 -0400
In-Reply-To: <20090814032201.GA2544@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Tue, Aug 11, 2009 at 01:05:57AM +0800, Shane Wang wrote:
>> 
>> For the comment
>>> This is unnecessary.  Please use the standard kernel helpers
>>> from asm/byteorder.h (which you get by including linux/kernel.h).
>> The current code distinguishes some macro implementations according
>> to different platforms to improve the MACing speed, which is one of
>> the reasons VMAC is very fast for MACing. Do we need to give these
>> up? 
> 
> I'm talking about your macros such as get64BE/get64LE.  We have
> identical standard kernel helpers be64_to_cpu/le64_to_cpu which
> should already be optimal.
> 
> Cheers,

OK, I will update.

Thanks for the comment.

Shane
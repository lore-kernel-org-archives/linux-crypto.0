From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: Re: [RFC v1.1 1/5] crypto: GnuPG based MPI lib
Date: Wed, 17 Aug 2011 13:50:23 +0300
Message-ID: <4E4B9CEF.2060201@gmail.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com> <b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com> <alpine.LRH.2.00.1108161056310.7706@tundra.namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: James Morris <jmorris@namei.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44515 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1HQKtL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 06:49:11 -0400
In-Reply-To: <alpine.LRH.2.00.1108161056310.7706@tundra.namei.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 16/08/11 03:57, James Morris wrote:
> On Thu, 11 Aug 2011, Dmitry Kasatkin wrote:
> 
>> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
>>
>> Adds the multi-precision-integer maths library which was originally taken
>> from GnuPG and ported to the kernel by (among others) David Howells.
>> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
> 
> First thing -- this code needs to be formatted using kernel coding style.
> 
> 
> - James

The code is inherited from GnuPG which does not follow kernel coding
standard. There are lots of "checkpatch" errors and warnings..
Do you say it must be reformatted?

- Dmitry

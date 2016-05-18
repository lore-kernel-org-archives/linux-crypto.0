From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: Typos and RSA
Date: Wed, 18 May 2016 09:01:41 -0700
Message-ID: <8f3a5cfc-9132-0c01-f6ca-93c92eb4025c@intel.com>
References: <573B8BA3.8020902@amd.com>
 <ae33e745-feca-c588-015d-bf2b4ca461f0@intel.com> <573B9F54.7050006@amd.com>
 <6203568.4quGhfsc99@positron.chronox.de> <573C90E6.8000203@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Gary R Hook <ghook@amd.com>, Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25374 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbcERQD1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 12:03:27 -0400
In-Reply-To: <573C90E6.8000203@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/18/2016 08:57 AM, Gary R Hook wrote:
> Yes, thank you. After spending more time wandering through rsa.c & rsa_helper.c
> I have come to realize that I have been laboring under a paradigm imposed by
> my implementation requirements. Now that I have that cleared up, the answer to
> my question it self-evident.Although I'm still not clear on why testmgr feels
> the need to create a SGL table with an empty second element (for the existing
> tests), rather than a single SGL.

Because the role of testmgr is to test different scenarios like more than one
entry in an sgl, etc.
Thanks,
-- 
TS

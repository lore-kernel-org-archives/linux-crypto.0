From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: key retention service: DH support
Date: Thu, 26 May 2016 10:04:30 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1605260958360.18304@mjmartin-mac01.local>
References: <alpine.OSX.2.20.1605240851210.7071@tmhoole-mobl2.amr.corp.intel.com> <1884439.7dZQH0lY4q@tauon.atsec.com> <27639.1464073468@warthog.procyon.org.uk> <28895.1464074381@warthog.procyon.org.uk> <2025704.nsKCcck7Ux@tauon.atsec.com>
 <311.1464173906@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51150 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbcEZRFZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 13:05:25 -0400
In-Reply-To: <311.1464173906@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Wed, 25 May 2016, David Howells wrote:

> Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:
>
>> Since the KDF patches are not yet merged, I'm not sure of the best way to
>> accomodate the future feature. We could future-proof KEYCTL_DH_COMPUTE by
>> adding a 5th arg, an optional pointer to KDF configuration (NAME and
>> LABEL).
>
> If we want to do this, it needs to be done before the merge window closes,
> maybe by -rc2.  Just requiring the extra argument to be 0 for now and/or
> extending struct keyctl_dh_params to include some must-be-zeroed spare space
> would do for now.

I sent a patch ([PATCH] KEYS: Add optional key derivation parameters for 
DH) to define the additional parameter. For now, an error is returned if 
KDF configuration is provided.

--
Mat Martineau
Intel OTC

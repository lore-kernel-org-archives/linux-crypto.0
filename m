From: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: arch_random_refill
Date: Sun, 11 May 2014 20:45:24 -0700
Message-ID: <537043D4.8070301@linux.intel.com>
References: <21542339.0lFnPSyGRS@myon.chronox.de> <53703E74.9020700@linux.intel.com> <3260147.sUis3H5ONm@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47480 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaELDpZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 May 2014 23:45:25 -0400
In-Reply-To: <3260147.sUis3H5ONm@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/11/2014 08:36 PM, Stephan Mueller wrote:
> 
> But in our current predicament, not everybody trusts a few potentially easily 
> manipulated gates that have no other purpose than produce white noise which 
> are developed by the biggest chip vendor in the US. Gates which have other 
> purposes may not be that easily manipulated.
>

Incidentally, I disagree with the "easily manipulated" bit.  Yes, I have
seen the paper which says that you can do it in such a way that it
doesn't show up on *visual* examination.  However, put an electrical
probe on it and it shows up immediately.

	-hpa

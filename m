From: Andy Whitcroft <apw@canonical.com>
Subject: Re: Checkpatch complaining about spaces around * used as
 arithmetic operator
Date: Wed, 17 Nov 2010 20:50:01 +0000
Message-ID: <20101117205001.GC6038@shadowen.org>
References: <8A0E4C92AE2D6D40AF99653191DA323161417367B8@rrsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Allyn, Mark A" <mark.a.allyn@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:34338 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab0KQUuH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Nov 2010 15:50:07 -0500
Content-Disposition: inline
In-Reply-To: <8A0E4C92AE2D6D40AF99653191DA323161417367B8@rrsmsx501.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 17, 2010 at 01:44:03PM -0700, Allyn, Mark A wrote:
> Hello:
> 
> I had checkpatch complain about spaces around the * symbol when it is used as an arithmetic operator (multiply) and not an address indicator.
> 
> This did not happen before; it's happening in the current next kernel.
> 
> Are there intended changes to checkpatch to require no spaces after the * even for multiply?

No that would be incorrect.  Could you send me the example which is
triggering it so I can try and determine why.

-apw
